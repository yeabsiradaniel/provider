import React from 'react';
import { NavLink } from 'react-router-dom';
import styles from './Sidebar.module.css';
import { useAuth } from '../../contexts/AuthContext';
import Button from '../Button';

const Sidebar = () => {
  const { logout } = useAuth();

  return (
    <div className={styles.sidebar}>
      <div>
        <h3 className={styles.title}>Admin Panel</h3>
        <ul className={styles.navList}>
          <li>
            <NavLink to="/" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink} end>
              Dashboard
            </NavLink>
          </li>
          <li>
            <NavLink to="/users" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Users
            </NavLink>
          </li>
          <li>
            <NavLink to="/provider-profiles" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Provider Profiles
            </NavLink>
          </li>
          <li>
            <NavLink to="/categories" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Categories
            </NavLink>
          </li>
          <li>
            <NavLink to="/jobs" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Jobs
            </NavLink>
          </li>
          <li>
            <NavLink to="/reviews" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Reviews
            </NavLink>
          </li>
          <li>
            <NavLink to="/ledger" className={({ isActive }) => isActive ? `${styles.navLink} ${styles.navLinkActive}` : styles.navLink}>
              Ledger
            </NavLink>
          </li>
        </ul>
      </div>
      <Button onClick={logout} variant="destructive">Logout</Button>
    </div>
  );
};

export default Sidebar;
