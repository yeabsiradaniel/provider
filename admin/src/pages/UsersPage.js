import React, { useState, useMemo, useCallback } from 'react';
import { useUsers } from '../hooks/useUsers';
import Table from '../components/Table';
import Button from '../components/Button';
import UserFormModal from '../components/User/UserFormModal';
import DeleteUserModal from '../components/User/DeleteUserModal';

const UsersPage = () => {
  const { users, isLoading, error, addUser, editUser, removeUser } = useUsers();
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);

  const handleOpenFormModal = useCallback((user = null) => {
    setCurrentUser(user);
    setIsFormModalOpen(true);
  }, []);

  const handleCloseFormModal = () => {
    setCurrentUser(null);
    setIsFormModalOpen(false);
  };

  const handleOpenDeleteModal = useCallback((user) => {
    setCurrentUser(user);
    setIsDeleteModalOpen(true);
  }, []);

  const handleCloseDeleteModal = () => {
    setCurrentUser(null);
    setIsDeleteModalOpen(false);
  };

  const handleFormSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      if (currentUser) {
        await editUser(currentUser._id, formData);
      } else {
        await addUser(formData);
      }
      handleCloseFormModal();
    } catch (err) {
      console.error("Failed to save user:", err);
      // Here you would show an error message to the user
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteConfirm = async () => {
    // A similar isSubmitting state could be added for delete if it's slow
    if (currentUser) {
      try {
        await removeUser(currentUser._id);
        handleCloseDeleteModal();
      } catch (err) {
        console.error("Failed to delete user:", err);
      }
    }
  };

  const columns = React.useMemo(
    () => [
      {
        Header: 'Name',
        accessor: 'firstName',
        Cell: ({ row }) => `${row.firstName} ${row.lastName}`,
      },
      {
        Header: 'Phone',
        accessor: 'phone',
      },
      {
        Header: 'Role',
        accessor: 'role',
      },
      {
        Header: 'Verified',
        accessor: 'verified',
        Cell: ({ row }) => (row.verified ? 'Yes' : 'No'),
      },
      {
        Header: 'Actions',
        accessor: '_id',
        Cell: ({ row }) => (
          <div style={{ display: 'flex', gap: '8px' }}>
            <Button onClick={() => handleOpenFormModal(row)}>Edit</Button>
            <Button onClick={() => handleOpenDeleteModal(row)} variant="destructive">Delete</Button>
          </div>
        ),
      },
    ],
    [handleOpenFormModal, handleOpenDeleteModal]
  );

  if (isLoading) return <div>Loading users...</div>;
  if (error) return <div>Error fetching users: {error.message}</div>;

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <h1>User Management</h1>
        <Button onClick={() => handleOpenFormModal()}>Add New User</Button>
      </div>
      <Table columns={columns} data={users} />
      <UserFormModal
        isOpen={isFormModalOpen}
        onClose={handleCloseFormModal}
        onSubmit={handleFormSubmit}
        user={currentUser}
        isLoading={isSubmitting}
      />
      <DeleteUserModal
        isOpen={isDeleteModalOpen}
        onClose={handleCloseDeleteModal}
        onConfirm={handleDeleteConfirm}
        userName={currentUser ? `${currentUser.firstName} ${currentUser.lastName}` : ''}
      />
    </div>
  );
};

export default UsersPage;
