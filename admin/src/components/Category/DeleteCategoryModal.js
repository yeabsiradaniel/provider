import React from 'react';
import FormModal from '../FormModal';
import Button from '../Button';

const DeleteCategoryModal = ({ isOpen, onClose, onConfirm, categoryName, isLoading }) => {
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
            {isLoading ? 'Deleting...' : 'Delete Category'}
          </Button>
        </>
      }
    >
      <p>Are you sure you want to delete the category <strong>{categoryName}</strong>? This may fail if the category contains sub-categories.</p>
    </FormModal>
  );
};

export default DeleteCategoryModal;
