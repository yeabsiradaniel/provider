import axios from 'axios';

const getAuthToken = () => {
  return localStorage.getItem('admin_token');
};

const publicApiClient = axios.create({
  baseURL: '/api',
});

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

// Using the public route to get all categories for display
export const getCategories = async () => {
  try {
    const response = await publicApiClient.get('/categories');
    return response.data;
  } catch (error) {
    console.error("Error fetching categories:", error);
    throw error;
  }
};

export const createCategory = async (categoryData) => {
  try {
    const response = await adminApiClient.post('/categories', categoryData);
    return response.data;
  } catch (error) {
    console.error("Error creating category:", error);
    throw error;
  }
};

export const updateCategory = async (categoryId, categoryData) => {
  try {
    const response = await adminApiClient.put(`/categories/${categoryId}`, categoryData);
    return response.data;
  } catch (error) {
    console.error("Error updating category:", error);
    throw error;
  }
};

export const deleteCategory = async (categoryId) => {
  try {
    const response = await adminApiClient.delete(`/categories/${categoryId}`);
    return response.data;
  } catch (error) {
    console.error("Error deleting category:", error);
    throw error;
  }
};
