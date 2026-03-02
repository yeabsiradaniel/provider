import { useState, useEffect, useCallback } from 'react';
import * as reviewService from '../api/reviewService';

export const useReviews = () => {
  const [reviews, setReviews] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchReviews = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await reviewService.getReviews();
      setReviews(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchReviews();
  }, [fetchReviews]);

  const removeReview = async (reviewId) => {
    try {
      await reviewService.deleteReview(reviewId);
      setReviews((prevReviews) => prevReviews.filter((review) => review._id !== reviewId));
    } catch (err) {
      console.error("Failed to delete review:", err);
      throw err;
    }
  };

  return { reviews, isLoading, error, fetchReviews, removeReview };
};
