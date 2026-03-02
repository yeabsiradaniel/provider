import axios from 'axios';

const apiClient = axios.create({
  baseURL: '/api/auth',
});

export const requestOtp = async (phoneNumber) => {
  try {
    const response = await apiClient.post('/request-otp', { phoneNumber });
    return response.data;
  } catch (error) {
    console.error("Error requesting OTP:", error.response ? error.response.data : error.message);
    throw error.response ? new Error(error.response.data.message) : error;
  }
};

export const verifyOtpAndLogin = async (phoneNumber, otp, pin) => {
  try {
    // For login, we only need phone, otp, and pin. The role is inferred on the backend.
    const response = await apiClient.post('/verify-otp', { phoneNumber, otp, pin });
    return response.data;
  } catch (error) {
    console.error("Error verifying OTP for login:", error.response ? error.response.data : error.message);
    throw error.response ? new Error(error.response.data.message) : error;
  }
};
