import React, { useState } from 'react';
import { useCategories } from '../hooks/useCategories';
import Button from '../components/Button';
import CategoryFormModal from '../components/Category/CategoryFormModal';
import DeleteCategoryModal from '../components/Category/DeleteCategoryModal';

const CategoryItem = ({ category, onEdit, onDelete }) => {
  return (
    <div style={{ marginLeft: '20px', borderLeft: '1px solid #ccc', paddingLeft: '10px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '5px' }}>
        <span>{category.name.en} / {category.name.am}</span>
        <div>
          <Button onClick={() => onEdit(category)}>Edit</Button>
          <Button onClick={() => onDelete(category)} variant="destructive">Delete</Button>
        </div>
      </div>
      {category.subCategories && category.subCategories.length > 0 && (
        <div>
          {category.subCategories.map(subCat => (
            <CategoryItem key={subCat._id} category={subCat} onEdit={onEdit} onDelete={onDelete} />
          ))}
        </div>
      )}
    </div>
  );
};


const CategoriesPage = () => {
  const { categories, isLoading, error, addCategory, editCategory, removeCategory } = useCategories();
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentTarget, setCurrentTarget] = useState(null);

  const handleEdit = (category) => {
    setCurrentTarget(category);
    setIsFormModalOpen(true);
  };
  
  const handleDelete = (category) => {
    setCurrentTarget(category);
    setIsDeleteModalOpen(true);
  };

  const handleAdd = () => {
    setCurrentTarget(null);
    setIsFormModalOpen(true);
  };

  const handleFormSubmit = async (formData) => {
    setIsSubmitting(true);
    try {
      if (currentTarget) {
        await editCategory(currentTarget._id, formData);
      } else {
        await addCategory(formData);
      }
      setIsFormModalOpen(false);
      setCurrentTarget(null);
    } catch (err) {
      console.error("Failed to save category:", err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteConfirm = async () => {
    if (currentTarget) {
      setIsSubmitting(true);
      try {
        await removeCategory(currentTarget._id);
        setIsDeleteModalOpen(false);
        setCurrentTarget(null);
      } catch (err) {
        console.error("Failed to delete category:", err);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  if (isLoading) return <div>Loading categories...</div>;
  if (error) return <div>Error fetching categories: {error.message}</div>;

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <h1>Category Management</h1>
        <Button onClick={handleAdd}>Add New Category</Button>
      </div>

      {categories.map(category => (
        <CategoryItem key={category._id} category={category} onEdit={handleEdit} onDelete={handleDelete} />
      ))}
      
      <CategoryFormModal 
        isOpen={isFormModalOpen} 
        onClose={() => setIsFormModalOpen(false)} 
        onSubmit={handleFormSubmit}
        category={currentTarget}
        categories={categories}
        isLoading={isSubmitting}
      />
      
      <DeleteCategoryModal 
        isOpen={isDeleteModalOpen}
        onClose={() => setIsDeleteModalOpen(false)}
        onConfirm={handleDeleteConfirm}
        categoryName={currentTarget ? currentTarget.name.en : ''}
        isLoading={isSubmitting}
      />
    </div>
  );
};

export default CategoriesPage;
