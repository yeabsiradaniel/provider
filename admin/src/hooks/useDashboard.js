import { useState, useEffect, useCallback } from 'react';
import * as dashboardService from '../api/dashboardService';

export const useDashboard = () => {
  const [stats, setStats] = useState(null);
  const [chartData, setChartData] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchStats = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const [statsData, chartStatsData] = await Promise.all([
        dashboardService.getDashboardStats(),
        dashboardService.getJobsByMonthStats(),
      ]);
      setStats(statsData);
      setChartData(chartStatsData);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchStats();
  }, [fetchStats]);

  return { stats, chartData, isLoading, error, fetchStats };
};
