import React from 'react';
import FormModal from '../FormModal';
import Button from '../Button';

const DeleteReviewModal = ({ isOpen, onClose, onConfirm, isLoading }) => {
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
            {isLoading ? 'Deleting...' : 'Delete Review'}
          </Button>
        </>
      }
    >
      <p>Are you sure you want to delete this review? This action cannot be undone.</p>
    </FormModal>
  );
};

export default DeleteReviewModal;
