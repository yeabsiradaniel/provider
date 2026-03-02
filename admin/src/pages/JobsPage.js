import React, { useMemo, useState, useCallback } from 'react';
import { useJobs } from '../hooks/useJobs';
import Table from '../components/Table';
import Button from '../components/Button';
import { format } from 'date-fns';

import JobFormModal from '../components/Job/JobFormModal';
import DeleteJobModal from '../components/Job/DeleteJobModal';

const JobsPage = () => {
  const { jobs, isLoading, error, editJob, removeJob } = useJobs();
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentTarget, setCurrentTarget] = useState(null);

  const handleOpenFormModal = useCallback((job) => {
    setCurrentTarget(job);
    setIsFormModalOpen(true);
  }, []);

  const handleCloseFormModal = () => {
    setCurrentTarget(null);
    setIsFormModalOpen(false);
  };

  const handleOpenDeleteModal = useCallback((job) => {
    setCurrentTarget(job);
    setIsDeleteModalOpen(true);
  }, []);

  const handleCloseDeleteModal = () => {
    setCurrentTarget(null);
    setIsDeleteModalOpen(false);
  };

  const handleFormSubmit = async (formData) => {
    if (currentTarget) {
      setIsSubmitting(true);
      try {
        await editJob(currentTarget._id, formData);
        handleCloseFormModal();
      } catch (err) {
        console.error("Failed to update job:", err);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  const handleDeleteConfirm = async () => {
    if (currentTarget) {
      setIsSubmitting(true);
      try {
        await removeJob(currentTarget._id);
        handleCloseDeleteModal();
      } catch (err) {
        console.error("Failed to delete job:", err);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  const columns = useMemo(
    () => [
      {
        Header: 'Service',
        accessor: 'serviceName',
      },
      {
        Header: 'Client',
        accessor: 'clientId',
        Cell: ({ row }) => row.clientId ? `${row.clientId.firstName} ${row.clientId.lastName}` : 'N/A',
      },
      {
        Header: 'Provider',
        accessor: 'providerId',
        Cell: ({ row }) => row.providerId ? `${row.providerId.firstName} ${row.providerId.lastName}` : 'N/A',
      },
      {
        Header: 'Status',
        accessor: 'status',
      },
      {
        Header: 'Date',
        accessor: 'createdAt',
        Cell: ({ row }) => format(new Date(row.createdAt), 'MMM d, yyyy'),
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

  if (isLoading) return <div>Loading jobs...</div>;
  if (error) return <div>Error fetching jobs: {error.message}</div>;

  return (
    <div>
      <h1>Job Management</h1>
      <Table columns={columns} data={jobs} />
      <JobFormModal
        isOpen={isFormModalOpen}
        onClose={handleCloseFormModal}
        onSubmit={handleFormSubmit}
        job={currentTarget}
        isLoading={isSubmitting}
      />
      <DeleteJobModal
        isOpen={isDeleteModalOpen}
        onClose={handleCloseDeleteModal}
        onConfirm={handleDeleteConfirm}
        jobName={currentTarget?.serviceName}
        isLoading={isSubmitting}
      />
    </div>
  );
};

export default JobsPage;
