import React, { useState, useEffect } from 'react';
import FormModal from '../FormModal';
import Button from '../Button';

const JobFormModal = ({ isOpen, onClose, onSubmit, job, isLoading }) => {
  const [status, setStatus] = useState('');

  useEffect(() => {
    if (job) {
      setStatus(job.status || '');
    }
  }, [job, isOpen]);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit({ status });
  };

  return (
    <FormModal
      isOpen={isOpen}
      onClose={onClose}
      onSubmit={handleSubmit}
      title="Edit Job Status"
      footer={
        <>
          <Button type="button" onClick={onClose} variant="secondary">
            Cancel
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading ? 'Saving...' : 'Save Changes'}
          </Button>
        </>
      }
    >
      <p>Job: <strong>{job?.serviceName}</strong></p>
      <div style={{ margin: '16px 0' }}>
        <label>Status</label>
        <select value={status} onChange={(e) => setStatus(e.target.value)} style={{ width: '100%', padding: '8px', borderRadius: '12px', border: '1px solid var(--color-tertiary)' }}>
          <option value="PENDING">Pending</option>
          <option value="ACCEPTED">Accepted</option>
          <option value="ACTIVE">Active</option>
          <option value="COMPLETED">Completed</option>
          <option value="CANCELLED">Cancelled</option>
          <option value="DECLINED">Declined</option>
        </select>
      </div>
    </FormModal>
  );
};

export default JobFormModal;
