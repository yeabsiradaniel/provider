import React from 'react';
import Card from '../Card';
import styles from './StatCard.module.css';

const StatCard = ({ title, value, icon }) => {
  return (
    <Card>
      <div className={styles.statCard}>
        <div className={styles.iconWrapper}>
          {icon}
        </div>
        <div className={styles.textWrapper}>
          <p className={styles.title}>{title}</p>
          <p className={styles.value}>{value}</p>
        </div>
      </div>
    </Card>
  );
};

export default StatCard;
