import React from 'react';
import styles from './Button.module.css';

const Button = ({ children, onClick, variant = 'primary', type = 'button', disabled = false }) => {
  const buttonClasses = `${styles.button} ${styles[variant]}`;

  return (
    <button
      type={type}
      className={buttonClasses}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
};

export default Button;
