import React, { createContext, useState, useContext, useEffect } from 'react';
import * as authService from '../api/authService';
import * as userService from '../api/userService'; // To fetch user profile on load

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true); // Start with loading true for initial check
  const [error, setError] = useState(null);

  useEffect(() => {
    const checkLoggedIn = async () => {
      const token = localStorage.getItem('admin_token');
      if (token) {
        try {
          // You might want to add a 'verify-token' endpoint in the future
          // For now, we'll fetch the user's profile to see if the token is valid
          const profile = await userService.getMe();
          if (profile.role === 'admin') {
            setUser(profile);
            setIsAuthenticated(true);
          } else {
            // Not an admin, log them out from the admin panel
            localStorage.removeItem('admin_token');
          }
        } catch (err) {
          // Token is invalid or expired
          localStorage.removeItem('admin_token');
        }
      }
      setIsLoading(false);
    };
    checkLoggedIn();
  }, []);

  const requestOtp = async (phoneNumber) => {
    try {
      setError(null);
      await authService.requestOtp(phoneNumber);
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  const verifyLogin = async (phoneNumber, otp, pin) => {
    try {
      setError(null);
      const data = await authService.verifyOtpAndLogin(phoneNumber, otp, pin);
      if (data.user && data.user.role !== 'admin') {
        throw new Error('You do not have permission to access the admin panel.');
      }
      localStorage.setItem('admin_token', data.token);
      setUser(data.user);
      setIsAuthenticated(true);
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  const logout = () => {
    localStorage.removeItem('admin_token');
    setUser(null);
    setIsAuthenticated(false);
  };

  const value = {
    user,
    isAuthenticated,
    isLoading,
    error,
    requestOtp,
    verifyLogin,
    logout,
  };

  return (
    <AuthContext.Provider value={value}>
      {!isLoading && children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  return useContext(AuthContext);
};
