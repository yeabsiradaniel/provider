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

export const getDashboardStats = async () => {
  try {
    const response = await adminApiClient.get('/dashboard');
    return response.data;
  } catch (error) {
    console.error("Error fetching dashboard stats:", error);
    throw error;
  }
};

export const getJobsByMonthStats = async () => {
    try {
      const response = await adminApiClient.get('/stats/jobs-by-month');
      return response.data;
    } catch (error) {
      console.error("Error fetching job stats:", error);
      throw error;
    }
  };
