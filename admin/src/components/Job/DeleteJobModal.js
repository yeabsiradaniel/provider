import React from 'react';
import FormModal from '../FormModal';
import Button from '../Button';

const DeleteJobModal = ({ isOpen, onClose, onConfirm, jobName, isLoading }) => {
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
          <Button type="button" onClick={onConfirm} variant="destructive" disabled={isLoading}>
            {isLoading ? 'Deleting...' : 'Delete Job'}
          </Button>
        </>
      }
    >
      <p>Are you sure you want to delete the job: <strong>{jobName}</strong>? This action cannot be undone.</p>
    </FormModal>
  );
};

export default DeleteJobModal;
