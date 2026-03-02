import React from 'react';
import { Routes, Route } from 'react-router-dom';
import AdminLayout from '../layouts/AdminLayout';
import DashboardPage from '../pages/DashboardPage';
import LoginPage from '../pages/LoginPage';
import UsersPage from '../pages/UsersPage';
import CategoriesPage from '../pages/CategoriesPage';
import ProviderProfilesPage from '../pages/ProviderProfilesPage';
import JobsPage from '../pages/JobsPage';
import ReviewsPage from '../pages/ReviewsPage';
import LedgerPage from '../pages/LedgerPage';
import ProtectedRoute from './ProtectedRoute';
import './App.css';

function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route element={<ProtectedRoute />}>
        <Route path="/" element={<AdminLayout />}>
          <Route index element={<DashboardPage />} />
          <Route path="users" element={<UsersPage />} />
          <Route path="provider-profiles" element={<ProviderProfilesPage />} />
          <Route path="categories" element={<CategoriesPage />} />
          <Route path="jobs" element={<JobsPage />} />
          <Route path="reviews" element={<ReviewsPage />} />
          <Route path="ledger" element={<LedgerPage />} />
        </Route>
      </Route>
    </Routes>
  );
}

export default App;
