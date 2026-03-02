import axios from 'axios';

const getAuthToken = () => {
  return localStorage.getItem('admin_token');
};

const adminApiClient = axios.create({
    baseURL: '/api/admin',
});

adminApiClient.interceptors.request.use((config) => {
  const token = getAuthToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const getJobs = async () => {
  try {
    const response = await adminApiClient.get('/jobs');
    return response.data;
  } catch (error) {
    console.error("Error fetching jobs:", error);
    throw error;
  }
};

export const updateJob = async (jobId, jobData) => {
  try {
    const response = await adminApiClient.put(`/jobs/${jobId}`, jobData);
    return response.data;
  } catch (error) {
    console.error("Error updating job:", error);
    throw error;
  }
};

export const deleteJob = async (jobId) => {
  try {
    const response = await adminApiClient.delete(`/jobs/${jobId}`);
    return response.data;
  } catch (error) {
    console.error("Error deleting job:", error);
    throw error;
  }
};
