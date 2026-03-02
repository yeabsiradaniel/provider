import React from 'react';
import Modal from '../Modal';
import Card from '../Card';
import styles from './FormModal.module.css';

const FormModal = ({ isOpen, onClose, title, children, footer, onSubmit }) => {
  return (
    <Modal isOpen={isOpen} onClose={onClose}>
      <Card>
        <form onSubmit={onSubmit}>
            <h2 className={styles.formModalHeader}>{title}</h2>
            <div className={styles.formModalContent}>
                {children}
            </div>
            <div className={styles.formModalFooter}>
                {footer}
            </div>
        </form>
      </Card>
    </Modal>
  );
};

export default FormModal;
