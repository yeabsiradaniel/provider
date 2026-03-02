import { useState, useEffect, useCallback } from 'react';
import * as categoryService from '../api/categoryService';

export const useCategories = () => {
  const [categories, setCategories] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchCategories = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await categoryService.getCategories();
      setCategories(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchCategories();
  }, [fetchCategories]);

  const addCategory = async (categoryData) => {
    try {
      await categoryService.createCategory(categoryData);
      fetchCategories(); // Refetch all categories to see the new one
    } catch (err) {
      console.error("Failed to add category:", err);
      throw err;
    }
  };

  const editCategory = async (categoryId, categoryData) => {
    try {
      await categoryService.updateCategory(categoryId, categoryData);
      fetchCategories(); // Refetch to see changes
    } catch (err) {
      console.error("Failed to edit category:", err);
      throw err;
    }
  };

  const removeCategory = async (categoryId) => {
    try {
      await categoryService.deleteCategory(categoryId);
      fetchCategories(); // Refetch to see the deletion
    } catch (err) {
      console.error("Failed to delete category:", err);
      throw err;
    }
  };

  return { categories, isLoading, error, fetchCategories, addCategory, editCategory, removeCategory };
};
