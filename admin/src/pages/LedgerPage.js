import React, { useMemo } from 'react';
import { useLedger } from '../hooks/useLedger';
import Table from '../components/Table';
import { format } from 'date-fns';

const LedgerPage = () => {
  const { ledgerEntries, isLoading, error } = useLedger();

  const columns = useMemo(
    () => [
      {
        Header: 'Date',
        accessor: 'recordedAt',
        Cell: ({ row }) => format(new Date(row.recordedAt), 'MMM d, yyyy, h:mm a'),
      },
      {
        Header: 'Type',
        accessor: 'type',
      },
      {
        Header: 'Amount',
        accessor: 'amount',
        Cell: ({ row }) => `${row.amount.toFixed(2)} ETB`,
      },
      {
        Header: 'Provider',
        accessor: 'providerId',
        Cell: ({ row }) => row.providerId ? `${row.providerId.firstName} ${row.providerId.lastName}` : 'N/A',
      },
      {
        Header: 'Job',
        accessor: 'jobId',
        Cell: ({ row }) => row.jobId ? row.jobId.serviceName : 'N/A',
      },
    ],
    []
  );

  if (isLoading) return <div>Loading ledger...</div>;
  if (error) return <div>Error fetching ledger: {error.message}</div>;

  return (
    <div>
      <h1>Admin Ledger</h1>
      <Table columns={columns} data={ledgerEntries} />
    </div>
  );
};

export default LedgerPage;
