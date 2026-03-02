import { useState, useEffect, useCallback } from 'react';
import * as userService from '../api/userService';

export const useUsers = () => {
  const [users, setUsers] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchUsers = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await userService.getUsers();
      setUsers(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const addUser = async (userData) => {
    try {
      const newUser = await userService.createUser(userData);
      setUsers((prevUsers) => [...prevUsers, newUser]);
    } catch (err) {
      // Let the component handle UI feedback for this error
      throw err;
    }
  };

  const editUser = async (userId, userData) => {
    try {
      const updatedUser = await userService.updateUser(userId, userData);
      setUsers((prevUsers) =>
        prevUsers.map((user) => (user._id === userId ? updatedUser : user))
      );
    } catch (err) {
      throw err;
    }
  };

  const removeUser = async (userId) => {
    try {
      await userService.deleteUser(userId);
      setUsers((prevUsers) => prevUsers.filter((user) => user._id !== userId));
    } catch (err) {
      throw err;
    }
  };

  return { users, isLoading, error, fetchUsers, addUser, editUser, removeUser };
};
