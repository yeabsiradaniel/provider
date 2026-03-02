import React from 'react';
import { useDashboard } from '../hooks/useDashboard';
import StatCard from '../components/StatCard';
import Card from '../components/Card';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

const DashboardPage = () => {
  const { stats, chartData, isLoading, error } = useDashboard();

  if (isLoading) return <div>Loading dashboard...</div>;
  if (error) return <div>Error fetching dashboard stats: {error.message}</div>;
  if (!stats) return <div>No statistics available.</div>;

  return (
    <div>
      <h1>Admin Dashboard</h1>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '20px', marginBottom: '20px' }}>
        <StatCard title="Total Users" value={stats.totalUsers} icon={<span>👥</span>} />
        <StatCard title="Total Providers" value={stats.totalProviders} icon={<span>🛠️</span>} />
        <StatCard title="Total Jobs" value={stats.totalJobs} icon={<span>📋</span>} />
        <StatCard title="Total Commission" value={`${stats.totalCommission.toFixed(2)} ETB`} icon={<span>💰</span>} />
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
        <Card>
          <h3>Pending Verifications</h3>
          {stats.pendingProviders.length > 0 ? (
            <ul>
              {stats.pendingProviders.map(p => (
                <li key={p._id}>{p.firstName} {p.lastName} - {p.phone}</li>
              ))}
            </ul>
          ) : (
            <p>No providers are currently pending verification.</p>
          )}
        </Card>
        <Card>
          <h3>Recent Jobs</h3>
           {stats.recentJobs.length > 0 ? (
            <ul>
              {stats.recentJobs.map(j => (
                <li key={j._id}>{j.serviceName} (Client: {j.clientId?.firstName})</li>
              ))}
            </ul>
          ) : (
            <p>No recent jobs.</p>
          )}
        </Card>
      </div>
      <div style={{ marginTop: '20px' }}>
        <Card>
            <h3>Jobs Overview</h3>
            <ResponsiveContainer width="100%" height={300}>
                <BarChart data={chartData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Legend />
                    <Bar dataKey="Jobs" fill="#8884d8" />
                </BarChart>
            </ResponsiveContainer>
        </Card>
      </div>
    </div>
  );
};

export default DashboardPage;
