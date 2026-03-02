import React, { useMemo, useState, useCallback } from 'react';
import { useReviews } from '../hooks/useReviews';
import Table from '../components/Table';
import Button from '../components/Button';
import { format } from 'date-fns';

import DeleteReviewModal from '../components/Review/DeleteReviewModal';

const ReviewsPage = () => {
  const { reviews, isLoading, error, removeReview } = useReviews();
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentTarget, setCurrentTarget] = useState(null);

  const handleDelete = useCallback((review) => {
    setCurrentTarget(review);
    setIsDeleteModalOpen(true);
  }, []);

  const handleDeleteConfirm = async () => {
    if (currentTarget) {
      setIsSubmitting(true);
      try {
        await removeReview(currentTarget._id);
        setIsDeleteModalOpen(false);
        setCurrentTarget(null);
      } catch (err) {
        console.error("Failed to delete review:", err);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  const columns = useMemo(
    () => [
      {
        Header: 'Date',
        accessor: 'createdAt',
        Cell: ({ row }) => format(new Date(row.createdAt), 'MMM d, yyyy'),
      },
      {
        Header: 'Provider',
        accessor: 'providerId',
        Cell: ({ row }) => row.providerId ? `${row.providerId.firstName} ${row.providerId.lastName}` : 'N/A',
      },
      {
        Header: 'Client',
        accessor: 'clientId',
        Cell: ({ row }) => row.clientId ? `${row.clientId.firstName} ${row.clientId.lastName}` : 'N/A',
      },
      {
        Header: 'Rating',
        accessor: 'rating',
      },
      {
        Header: 'Comment',
        accessor: 'comment',
        Cell: ({ row }) => <div style={{ maxWidth: '300px', whiteSpace: 'pre-wrap' }}>{row.comment}</div>,
      },
      {
        Header: 'Actions',
        accessor: '_id',
        Cell: ({ row }) => (
          <Button onClick={() => handleDelete(row)} variant="destructive">Delete</Button>
        ),
      },
    ],
    [handleDelete]
  );

  if (isLoading) return <div>Loading reviews...</div>;
  if (error) return <div>Error fetching reviews: {error.message}</div>;

  return (
    <div>
      <h1>Review Management</h1>
      <Table columns={columns} data={reviews} />
      <DeleteReviewModal 
        isOpen={isDeleteModalOpen}
        onClose={() => setIsDeleteModalOpen(false)}
        onConfirm={handleDeleteConfirm}
        isLoading={isSubmitting}
      />
    </div>
  );
};

export default ReviewsPage;
