import React from 'react';
import styles from './Card.module.css';

const Card = ({ children, className }) => {
  const cardClasses = `${styles.card} ${className || ''}`;
  return <div className={cardClasses}>{children}</div>;
};

export default Card;
