import React, { useState, useEffect } from 'react';
import FormModal from '../FormModal';
import Input from '../Input';
import Button from '../Button';

const ProviderProfileFormModal = ({ isOpen, onClose, onSubmit, profile, isLoading }) => {
  const [formData, setFormData] = useState({
    radius: 0,
    negotiable: false,
    isOnline: false,
  });

  useEffect(() => {
    if (profile) {
      setFormData({
        radius: profile.radius || 0,
        negotiable: profile.negotiable || false,
        isOnline: profile.isOnline || false,
      });
    }
  }, [profile, isOpen]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmit(formData);
  };

  return (
    <FormModal
      isOpen={isOpen}
      onClose={onClose}
      onSubmit={handleSubmit}
      title="Edit Provider Profile"
      footer={
        <>
          <Button type="button" onClick={onClose} variant="secondary">
            Cancel
          </Button>
          <Button type="submit" disabled={isLoading}>
            {isLoading ? 'Saving...' : 'Save Changes'}
          </Button>
        </>
      }
    >
      <Input
        label="Service Radius (km)"
        name="radius"
        type="number"
        value={formData.radius}
        onChange={handleChange}
      />
      <div style={{ margin: '16px 0', display: 'flex', alignItems: 'center', gap: '10px' }}>
        <label htmlFor="negotiable">Price Negotiable:</label>
        <input
          id="negotiable"
          name="negotiable"
          type="checkbox"
          checked={formData.negotiable}
          onChange={handleChange}
        />
      </div>
      <div style={{ margin: '16px 0', display: 'flex', alignItems: 'center', gap: '10px' }}>
        <label htmlFor="isOnline">Force Online Status:</label>
        <input
          id="isOnline"
          name="isOnline"
          type="checkbox"
          checked={formData.isOnline}
          onChange={handleChange}
        />
      </div>
    </FormModal>
  );
};

export default ProviderProfileFormModal;
