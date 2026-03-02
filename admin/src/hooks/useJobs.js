import { useState, useEffect, useCallback } from 'react';
import * as jobService from '../api/jobService';

export const useJobs = () => {
  const [jobs, setJobs] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchJobs = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await jobService.getJobs();
      setJobs(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchJobs();
  }, [fetchJobs]);

  const editJob = async (jobId, jobData) => {
    try {
      const updatedJob = await jobService.updateJob(jobId, jobData);
      setJobs((prevJobs) =>
        prevJobs.map((job) => (job._id === jobId ? updatedJob : job))
      );
    } catch (err) {
      console.error("Failed to update job:", err);
      throw err;
    }
  };

  const removeJob = async (jobId) => {
    try {
      await jobService.deleteJob(jobId);
      setJobs((prevJobs) => prevJobs.filter((job) => job._id !== jobId));
    } catch (err) {
      console.error("Failed to delete job:", err);
      throw err;
    }
  };

  return { jobs, isLoading, error, fetchJobs, editJob, removeJob };
};
