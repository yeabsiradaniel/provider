import React from 'react';
import FormModal from '../FormModal';
import Button from '../Button';

const DeleteUserModal = ({ isOpen, onClose, onConfirm, userName }) => {
  return (
    <FormModal
      isOpen={isOpen}
      onClose={onClose}
      title="Confirm Deletion"
      footer={
        <>
          <Button type="button" onClick={onClose} variant="secondary">
            Cancel
          </Button>
          <Button type="button" onClick={onConfirm} variant="destructive">
            Delete User
          </Button>
        </>
      }
    >
      <p>Are you sure you want to delete the user <strong>{userName}</strong>? This action cannot be undone.</p>
    </FormModal>
  );
};

export default DeleteUserModal;
