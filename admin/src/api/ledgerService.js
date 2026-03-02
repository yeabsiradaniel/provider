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

export const getLedger = async () => {
  try {
    const response = await adminApiClient.get('/ledger');
    return response.data;
  } catch (error) {
    console.error("Error fetching ledger:", error);
    throw error;
  }
};
