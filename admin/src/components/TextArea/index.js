import React from 'react';
import styles from './TextArea.module.css';

const TextArea = ({ label, id, ...props }) => {
  return (
    <div className={styles.textareaWrapper}>
      {label && <label htmlFor={id} className={styles.label}>{label}</label>}
      <textarea id={id} className={styles.textarea} {...props} />
    </div>
  );
};

export default TextArea;
