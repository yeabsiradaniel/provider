import React, { useState, useEffect } from 'react';
import FormModal from '../FormModal';
import Input from '../Input';
import Button from '../Button';

const CategoryFormModal = ({ isOpen, onClose, onSubmit, category, categories, isLoading }) => {
  const [formData, setFormData] = useState({
    'name.en': '',
    'name.am': '',
    icon: '',
    parent: null,
  });

  useEffect(() => {
    if (category) {
      setFormData({
        'name.en': category.name.en || '',
        'name.am': category.name.am || '',
        icon: category.icon || '',
        parent: category.parent || null,
      });
    } else {
      setFormData({ 'name.en': '', 'name.am': '', icon: '', parent: null });
    }
  }, [category, isOpen]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const finalData = {
        name: {
            en: formData['name.en'],
            am: formData['name.am'],
        },
        icon: formData.icon,
        parent: formData.parent === 'null' ? null : formData.parent,
    };
    onSubmit(finalData);
  };

  return (
    <FormModal
      isOpen={isOpen}
      onClose={onClose}
      onSubmit={handleSubmit}
      title={category ? 'Edit Category' : 'Create New Category'}
      footer={
        <>
          <Button type="button" onClick={onClose} variant="secondary">
            Cancel
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading ? 'Saving...' : (category ? 'Save Changes' : 'Create Category')}
          </Button>
        </>
      }
    >
      <Input
        label="Name (English)"
        name="name.en"
        value={formData['name.en']}
        onChange={handleChange}
        required
      />
      <Input
        label="Name (Amharic)"
        name="name.am"
        value={formData['name.am']}
        onChange={handleChange}
        required
      />
      <Input
        label="Icon Name (e.g., 'plumbing')"
        name="icon"
        value={formData.icon}
        onChange={handleChange}
      />
      <div style={{ margin: '16px 0' }}>
          <label>Parent Category</label>
          <select name="parent" value={formData.parent || 'null'} onChange={handleChange} style={{ width: '100%', padding: '8px', borderRadius: '12px', border: '1px solid var(--color-tertiary)' }}>
              <option value="null">None (Top-Level Category)</option>
              {categories.map(cat => (
                  <option key={cat._id} value={cat._id}>{cat.name.en}</option>
              ))}
          </select>
      </div>
    </FormModal>
  );
};

export default CategoryFormModal;
