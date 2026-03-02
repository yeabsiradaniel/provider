import React, { useState, useEffect } from 'react';
import FormModal from '../FormModal';
import Input from '../Input';
import Button from '../Button';
import { isValidPhone, isValidPin } from '../../utils/validation';

const UserFormModal = ({ isOpen, onClose, onSubmit, user, isLoading }) => {
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    phone: '',
    role: 'client',
    pin: '',
  });

  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (isOpen) {
      if (user) {
        setFormData({
          firstName: user.firstName || '',
          lastName: user.lastName || '',
          phone: user.phone || '',
          role: user.role || 'client',
          pin: '',
        });
      } else {
        setFormData({ firstName: '', lastName: '', phone: '', role: 'client', pin: '' });
      }
      setErrors({}); // Reset errors when modal opens
    }
  }, [user, isOpen]);

  const validateField = (name, value) => {
    let errorMsg = '';
    if (name === 'phone' && !isValidPhone(value)) {
        errorMsg = 'Please enter a valid phone number (e.g., +2519...).';
    }
    if (name === 'pin' && value && !isValidPin(value)) {
        errorMsg = 'PIN must be between 4 and 6 digits.';
    }
    setErrors(prev => ({ ...prev, [name]: errorMsg }));
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    validateField(name, value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (Object.values(errors).some(error => error)) {
        // If there are any errors, don't submit
        return;
    }
    onSubmit(formData);
  };

  const isFormValid = !Object.values(errors).some(error => error);

  return (
    <FormModal
      isOpen={isOpen}
      onClose={onClose}
      onSubmit={handleSubmit}
      title={user ? 'Edit User' : 'Create New User'}
      footer={
        <>
          <Button type="button" onClick={onClose} variant="secondary">
            Cancel
          </Button>
          <Button type="submit" disabled={isLoading || !isFormValid}>
            {isLoading ? 'Saving...' : (user ? 'Save Changes' : 'Create User')}
          </Button>
        </>
      }
    >
        <Input
          label="First Name"
          name="firstName"
          value={formData.firstName}
          onChange={handleChange}
          required
        />
        <Input
          label="Last Name"
          name="lastName"
          value={formData.lastName}
          onChange={handleChange}
          required
        />
        <Input
          label="Phone"
          name="phone"
          value={formData.phone}
          onChange={handleChange}
          required
        />
        {errors.phone && <p style={{color: 'red', fontSize: '12px'}}>{errors.phone}</p>}
        <div style={{ margin: '16px 0' }}>
          <label>Role</label>
          <select name="role" value={formData.role} onChange={handleChange} style={{ width: '100%', padding: '8px', borderRadius: '12px', border: '1px solid var(--color-tertiary)' }}>
            <option value="client">Client</option>
            <option value="provider">Provider</option>
            <option value="admin">Admin</option>
          </select>
        </div>
        <Input
          label="PIN"
          name="pin"
          type="password"
          value={formData.pin}
          onChange={handleChange}
          placeholder={user ? 'Leave blank to keep same PIN' : ''}
          required={!user} // PIN is required for new users
        />
        {errors.pin && <p style={{color: 'red', fontSize: '12px'}}>{errors.pin}</p>}
    </FormModal>
  );
};

export default UserFormModal;
