import { useState, useEffect, useCallback } from 'react';
import * as ledgerService from '../api/ledgerService';

export const useLedger = () => {
  const [ledgerEntries, setLedgerEntries] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchLedger = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await ledgerService.getLedger();
      setLedgerEntries(data);
    } catch (err) {
      setError(err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchLedger();
  }, [fetchLedger]);

  return { ledgerEntries, isLoading, error, fetchLedger };
};
