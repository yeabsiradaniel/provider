import axios from 'axios';

// This will be replaced with a proper auth context later
const getAuthToken = () => {
  return localStorage.getItem('admin_token');
};

const apiClient = axios.create({
  baseURL: '/api/admin',
});

apiClient.interceptors.request.use((config) => {
  const token = getAuthToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const getProviderProfiles = async () => {
  try {
    const response = await apiClient.get('/provider-profiles');
    return response.data;
  } catch (error) {
    console.error("Error fetching provider profiles:", error);
    throw error;
  }
};

export const updateProviderProfile = async (profileId, profileData) => {
  try {
    const response = await apiClient.put(`/provider-profiles/${profileId}`, profileData);
    return response.data;
  } catch (error) {
    console.error("Error updating provider profile:", error);
    throw error;
  }
};

export const verifyProvider = async (userId) => {
    try {
      // Note: The original route was POST /api/admin/providers/:id/verify
      // We are using the user ID here as the provider ID.
      const response = await apiClient.post(`/providers/${userId}/verify`);
      return response.data;
    } catch (error) {
      console.error("Error verifying provider:", error);
      throw error;
    }
  };

export const unverifyProvider = async (userId) => {
    try {
      const response = await apiClient.post(`/providers/${userId}/unverify`);
      return response.data;
    } catch (error) {
      console.error("Error un-verifying provider:", error);
      throw error;
    }
  };
