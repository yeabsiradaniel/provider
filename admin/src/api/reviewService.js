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

export const getReviews = async () => {
  try {
    const response = await adminApiClient.get('/reviews');
    return response.data;
  } catch (error) {
    console.error("Error fetching reviews:", error);
    throw error;
  }
};

export const deleteReview = async (reviewId) => {
  try {
    const response = await adminApiClient.delete(`/reviews/${reviewId}`);
    return response.data;
  } catch (error) {
    console.error("Error deleting review:", error);
    throw error;
  }
};
