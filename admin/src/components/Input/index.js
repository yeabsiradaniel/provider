import React from 'react';
import styles from './Input.module.css';

const Input = ({ label, id, ...props }) => {
  return (
    <div className={styles.inputWrapper}>
      {label && <label htmlFor={id} className={styles.label}>{label}</label>}
      <input id={id} className={styles.input} {...props} />
    </div>
  );
};

export default Input;
