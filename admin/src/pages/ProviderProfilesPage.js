import React, { useState, useMemo, useCallback } from 'react';
import { useProviderProfiles } from '../hooks/useProviderProfiles';
import Table from '../components/Table';
import Button from '../components/Button';
import ProviderProfileFormModal from '../components/ProviderProfile/ProviderProfileFormModal';

const ProviderProfilesPage = () => {
  const { profiles, isLoading, error, verifyProvider, unverifyProvider, updateProviderProfile } = useProviderProfiles();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProfile, setEditingProfile] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleVerify = useCallback(async (userId) => {
    if (window.confirm('Are you sure you want to verify this provider?')) {
      try {
        await verifyProvider(userId);
      } catch (err) {
        console.error('Verification failed', err);
      }
    }
  }, [verifyProvider]);

  const handleUnverify = useCallback(async (userId) => {
    if (window.confirm('Are you sure you want to UN-VERIFY this provider? This might have consequences.')) {
      try {
        await unverifyProvider(userId);
      } catch (err) {
        console.error('Un-verification failed', err);
      }
    }
  }, [unverifyProvider]);

  const handleOpenModal = useCallback((profile) => {
    setEditingProfile(profile);
    setIsModalOpen(true);
  }, []);

  const handleCloseModal = () => {
    setEditingProfile(null);
    setIsModalOpen(false);
  };

  const handleFormSubmit = async (formData) => {
    if (editingProfile) {
      setIsSubmitting(true);
      try {
        await updateProviderProfile(editingProfile._id, formData);
        handleCloseModal();
      } catch (err) {
        console.error("Failed to update profile:", err);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  const columns = useMemo(
    () => [
      {
        Header: 'Name',
        accessor: 'userId.firstName',
        Cell: ({ row }) => `${row.userId.firstName} ${row.userId.lastName}`,
      },
      {
        Header: 'Phone',
        accessor: 'userId', 
        Cell: ({ row }) => row.userId.phone, 
      },
      {
        Header: 'Services',
        accessor: 'serviceCategories',
        Cell: ({ row }) => row.serviceCategories.map(sc => sc.category.name.en).join(', '),
      },
      {
        Header: 'Online',
        accessor: 'isOnline',
        Cell: ({ row }) => (row.isOnline ? 'Yes' : 'No'),
      },
      {
        Header: 'Verified',
        accessor: 'userId.verified',
        Cell: ({ row }) => (row.userId.verified ? 'Yes' : 'No'),
      },
      {
        Header: 'Actions',
        accessor: 'userId._id',
        Cell: ({ row }) => (
          <div style={{ display: 'flex', gap: '8px' }}>
            <Button onClick={() => handleOpenModal(row)}>Edit</Button>
            {row.userId.verified ? (
              <Button onClick={() => handleUnverify(row.userId._id)} variant="destructive">
                Un-verify
              </Button>
            ) : (
              <Button onClick={() => handleVerify(row.userId._id)} variant="success">
                Verify
              </Button>
            )}
          </div>
        ),
      },
    ],
    [handleVerify, handleUnverify, handleOpenModal]
  );

  if (isLoading) return <div>Loading provider profiles...</div>;
  if (error) return <div>Error fetching profiles: {error.message}</div>;

  return (
    <div>
      <h1>Provider Profile Management</h1>
      <Table columns={columns} data={profiles} />
      <ProviderProfileFormModal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        onSubmit={handleFormSubmit}
        profile={editingProfile}
        isLoading={isSubmitting}
      />
    </div>
  );
};

export default ProviderProfilesPage;
