import { useState, useMemo } from 'react';
import {
  Box,
  Typography,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  TextField,
  MenuItem,
  InputAdornment,
  Divider,
  TableSortLabel,
  TablePagination,
  Button,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import ArrowDropUpIcon from '@mui/icons-material/ArrowDropUp';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import AddIcon from '@mui/icons-material/Add';
import UploadCsvDialog from '../components/UploadCsvDialog';

// ─── Types ────────────────────────────────────────────────────────────────────

type TxType = 'BUY' | 'SELL' | 'DIVIDEND' | 'DEPOSIT' | 'WITHDRAWAL' | 'INTEREST';
type SortDir = 'asc' | 'desc';
type SortKey = keyof Transaction;

interface Transaction {
  id: string;
  date: string;
  symbol: string;
  description: string;
  type: TxType;
  quantity: number | null;
  price: number | null;
  amount: number;
  netAmount: number;
}

// ─── Sample data ──────────────────────────────────────────────────────────────

const SAMPLE_TRANSACTIONS: Transaction[] = [
  { id: 'TX001', date: '2025-07-24', symbol: 'AAPL', description: 'Apple Inc.', type: 'BUY', quantity: 10, price: 211.18, amount: -2111.80, netAmount: -2111.80 },
  { id: 'TX002', date: '2025-07-22', symbol: 'TSLA', description: 'Tesla Inc.', type: 'SELL', quantity: 5, price: 182.30, amount: 911.50, netAmount: 910.01 },
  { id: 'TX003', date: '2025-07-20', symbol: 'MSFT', description: 'Microsoft Corp.', type: 'DIVIDEND', quantity: null, price: null, amount: 48.60, netAmount: 48.60 },
  { id: 'TX004', date: '2025-07-18', symbol: 'NVDA', description: 'NVIDIA Corp.', type: 'BUY', quantity: 5, price: 875.40, amount: -4377.00, netAmount: -4377.00 },
  { id: 'TX005', date: '2025-07-15', symbol: '', description: 'ACH Deposit', type: 'DEPOSIT', quantity: null, price: null, amount: 5000.00, netAmount: 5000.00 },
  { id: 'TX006', date: '2025-07-12', symbol: 'GOOGL', description: 'Alphabet Inc.', type: 'SELL', quantity: 3, price: 142.50, amount: 427.50, netAmount: 426.80 },
  { id: 'TX007', date: '2025-07-10', symbol: 'META', description: 'Meta Platforms Inc.', type: 'BUY', quantity: 4, price: 568.90, amount: -2275.60, netAmount: -2275.60 },
  { id: 'TX008', date: '2025-07-08', symbol: 'AAPL', description: 'Apple Inc.', type: 'DIVIDEND', quantity: null, price: null, amount: 23.00, netAmount: 23.00 },
  { id: 'TX009', date: '2025-07-05', symbol: '', description: 'Margin Interest', type: 'INTEREST', quantity: null, price: null, amount: -12.44, netAmount: -12.44 },
  { id: 'TX010', date: '2025-07-02', symbol: 'AMZN', description: 'Amazon.com Inc.', type: 'BUY', quantity: 10, price: 198.62, amount: -1986.20, netAmount: -1986.20 },
  { id: 'TX011', date: '2025-06-28', symbol: '', description: 'ACH Withdrawal', type: 'WITHDRAWAL', quantity: null, price: null, amount: -1000.00, netAmount: -1000.00 },
  { id: 'TX012', date: '2025-06-25', symbol: 'MSFT', description: 'Microsoft Corp.', type: 'SELL', quantity: 8, price: 415.32, amount: 3322.56, netAmount: 3320.87 },
  { id: 'TX013', date: '2025-06-20', symbol: 'NVDA', description: 'NVIDIA Corp.', type: 'BUY', quantity: 10, price: 620.50, amount: -6205.00, netAmount: -6205.00 },
  { id: 'TX014', date: '2025-06-15', symbol: '', description: 'ACH Deposit', type: 'DEPOSIT', quantity: null, price: null, amount: 10000.00, netAmount: 10000.00 },
  { id: 'TX015', date: '2025-06-10', symbol: 'TSLA', description: 'Tesla Inc.', type: 'BUY', quantity: 30, price: 230.00, amount: -6900.00, netAmount: -6900.00 },
];

const TX_TYPES: TxType[] = ['BUY', 'SELL', 'DIVIDEND', 'DEPOSIT', 'WITHDRAWAL', 'INTEREST'];

function fmt(n: number, decimals = 2) {
  return n.toLocaleString('en-US', { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
}

function fmtDate(iso: string) {
  return new Date(iso + 'T00:00:00').toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

const TYPE_COLORS: Record<TxType, 'success' | 'error' | 'info' | 'warning' | 'default'> = {
  BUY: 'info', SELL: 'warning', DIVIDEND: 'success', DEPOSIT: 'success', WITHDRAWAL: 'error', INTEREST: 'default',
};

function AmountCell({ amount }: { amount: number }) {
  const positive = amount >= 0;
  const color = positive ? 'success.main' : 'error.main';
  const Icon = positive ? ArrowDropUpIcon : ArrowDropDownIcon;
  return (
    <TableCell align="right" sx={{ whiteSpace: 'nowrap' }}>
      <Box sx={{ display: 'inline-flex', alignItems: 'center', gap: 0.25 }}>
        <Icon sx={{ color, fontSize: 18 }} />
        <Typography variant="body2" sx={{ fontWeight: 600, color }}>
          {positive ? '+' : '−'}${fmt(Math.abs(amount))}
        </Typography>
      </Box>
    </TableCell>
  );
}

export default function AccountTransactionsPage() {
  const [search, setSearch] = useState('');
  const [typeFilter, setTypeFilter] = useState<TxType | 'ALL'>('ALL');
  const [timelineFilter, setTimelineFilter] = useState<'ALL' | '30D' | '90D' | 'YTD' | '1Y'>('ALL');
  const [sortKey, setSortKey] = useState<SortKey>('date');
  const [sortDir, setSortDir] = useState<SortDir>('desc');
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(50);
  const [uploadOpen, setUploadOpen] = useState(false);

  const totalDeposits = SAMPLE_TRANSACTIONS.filter(t => t.type === 'DEPOSIT').reduce((s, t) => s + t.amount, 0);
  const totalWithdrawals = SAMPLE_TRANSACTIONS.filter(t => t.type === 'WITHDRAWAL').reduce((s, t) => s + Math.abs(t.amount), 0);
  const totalDividends = SAMPLE_TRANSACTIONS.filter(t => t.type === 'DIVIDEND').reduce((s, t) => s + t.amount, 0);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return [...SAMPLE_TRANSACTIONS]
      .filter(t => {
        const matchesType = typeFilter === 'ALL' || t.type === typeFilter;
        const matchesSearch = !q || t.symbol.toLowerCase().includes(q) || t.description.toLowerCase().includes(q) || t.type.toLowerCase().includes(q);

        let matchesTimeline = true;
        if (timelineFilter !== 'ALL') {
          const txDate = new Date(t.date + 'T00:00:00');
          const now = new Date();
          const diffDays = (now.getTime() - txDate.getTime()) / (1000 * 3600 * 24);

          if (timelineFilter === '30D') matchesTimeline = diffDays <= 30;
          else if (timelineFilter === '90D') matchesTimeline = diffDays <= 90;
          else if (timelineFilter === '1Y') matchesTimeline = diffDays <= 365;
          else if (timelineFilter === 'YTD') matchesTimeline = txDate.getFullYear() === now.getFullYear();
        }

        return matchesType && matchesSearch && matchesTimeline;
      })
      .sort((a, b) => {
        let va: string | number = a[sortKey] as string | number ?? '';
        let vb: string | number = b[sortKey] as string | number ?? '';
        if (typeof va === 'string') va = va.toLowerCase();
        if (typeof vb === 'string') vb = vb.toLowerCase();
        if (va < vb) return sortDir === 'asc' ? -1 : 1;
        if (va > vb) return sortDir === 'asc' ? 1 : -1;
        return 0;
      });
  }, [search, typeFilter, timelineFilter, sortKey, sortDir]);

  // Reset page to 0 when filters change
  useMemo(() => { setPage(0); }, [search, typeFilter, timelineFilter, sortKey, sortDir]);

  const paginated = useMemo(() => {
    return filtered.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage);
  }, [filtered, page, rowsPerPage]);

  const handleSort = (key: SortKey) => {
    if (sortKey === key) setSortDir(d => d === 'asc' ? 'desc' : 'asc');
    else { setSortKey(key); setSortDir('desc'); }
  };

  const SortCell = ({ label, field }: { label: string; field: SortKey }) => (
    <TableCell
      align={['amount', 'netAmount', 'price', 'quantity'].includes(field) ? 'right' : 'left'}
      sx={{ fontWeight: 700, whiteSpace: 'nowrap', bgcolor: 'action.hover' }}
    >
      <TableSortLabel active={sortKey === field} direction={sortKey === field ? sortDir : 'asc'} onClick={() => handleSort(field)}>
        {label}
      </TableSortLabel>
    </TableCell>
  );

  return (
    <Box sx={{ px: 4, pt: 1, pb: 4, maxWidth: 1300, mx: 'auto' }}>
      <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 2 }}>Transaction History</Typography>

      <Box sx={{ display: 'flex', gap: 3, flexWrap: 'wrap', mb: 4 }}>
        {[
          { label: 'Total Transactions', value: SAMPLE_TRANSACTIONS.length.toString(), color: undefined },
          { label: 'Total Deposited', value: `+$${fmt(totalDeposits)}`, color: 'success.main' },
          { label: 'Total Withdrawn', value: `−$${fmt(totalWithdrawals)}`, color: 'error.main' },
          { label: 'Dividends Received', value: `+$${fmt(totalDividends)}`, color: 'success.main' },
        ].map(card => (
          <Paper key={card.label} variant="outlined" sx={{ px: 3, py: 2, borderRadius: 2, minWidth: 180 }}>
            <Typography variant="body2" color="text.secondary">{card.label}</Typography>
            <Typography variant="h6" sx={{ fontWeight: 'bold', color: card.color ?? 'text.primary' }}>{card.value}</Typography>
          </Paper>
        ))}
      </Box>

      <Divider sx={{ mb: 3 }} />

      <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap', mb: 2, alignItems: 'center' }}>
        <TextField
          id="tx-search"
          size="small"
          placeholder="Search symbol or description…"
          value={search}
          onChange={e => setSearch(e.target.value)}
          sx={{ minWidth: 260 }}
          slotProps={{
            input: {
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon fontSize="small" />
                </InputAdornment>
              ),
            },
          }}
        />
        <TextField id="tx-type-filter" select size="small" label="Type" value={typeFilter}
          onChange={e => setTypeFilter(e.target.value as TxType | 'ALL')} sx={{ minWidth: 160 }}>
          <MenuItem value="ALL">All Types</MenuItem>
          {TX_TYPES.map(t => <MenuItem key={t} value={t}>{t}</MenuItem>)}
        </TextField>
        <TextField id="tx-timeline-filter" select size="small" label="Timeframe" value={timelineFilter}
          onChange={e => setTimelineFilter(e.target.value as any)} sx={{ minWidth: 160 }}>
          <MenuItem value="ALL">All Time</MenuItem>
          <MenuItem value="30D">Last 30 Days</MenuItem>
          <MenuItem value="90D">Last 90 Days</MenuItem>
          <MenuItem value="YTD">Year to Date</MenuItem>
          <MenuItem value="1Y">Last 1 Year</MenuItem>
        </TextField>
        <Box sx={{ ml: 'auto', display: 'flex', alignItems: 'center', gap: 2 }}>
          <Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => setUploadOpen(true)}>
            Add Transactions
          </Button>
          <Chip label={`${filtered.length} result${filtered.length !== 1 ? 's' : ''}`} size="small" variant="outlined" />
        </Box>
      </Box>

      <TableContainer component={Paper} variant="outlined" sx={{ borderRadius: 2 }}>
        <Table size="small" id="transactions-table">
          <TableHead>
            <TableRow>
              <SortCell label="Date" field="date" />
              <SortCell label="Symbol" field="symbol" />
              <SortCell label="Description" field="description" />
              <TableCell sx={{ fontWeight: 700, bgcolor: 'action.hover' }}>Type</TableCell>
              <SortCell label="Qty" field="quantity" />
              <SortCell label="Price" field="price" />
              <SortCell label="Amount" field="amount" />
              <SortCell label="Net Amount" field="netAmount" />
            </TableRow>
          </TableHead>
          <TableBody>
            {paginated.length === 0 ? (
              <TableRow><TableCell colSpan={8} align="center" sx={{ py: 4, color: 'text.disabled' }}>No transactions match your filters.</TableCell></TableRow>
            ) : (
              paginated.map(tx => (
                <TableRow key={tx.id} hover sx={{ '&:last-child td': { border: 0 } }}>
                  <TableCell sx={{ whiteSpace: 'nowrap' }}><Typography variant="body2">{fmtDate(tx.date)}</Typography></TableCell>
                  <TableCell><Typography variant="body2" sx={{ fontWeight: tx.symbol ? 700 : 400 }}>{tx.symbol || '—'}</Typography></TableCell>
                  <TableCell><Typography variant="body2" color="text.secondary">{tx.description}</Typography></TableCell>
                  <TableCell>
                    <Chip label={tx.type} size="small" color={TYPE_COLORS[tx.type]} variant="outlined" sx={{ fontWeight: 600, fontSize: '0.7rem' }} />
                  </TableCell>
                  <TableCell align="right"><Typography variant="body2">{tx.quantity != null ? tx.quantity : '—'}</Typography></TableCell>
                  <TableCell align="right"><Typography variant="body2">{tx.price != null ? `$${fmt(tx.price)}` : '—'}</Typography></TableCell>
                  <AmountCell amount={tx.amount} />
                  <AmountCell amount={tx.netAmount} />
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
        <TablePagination
          rowsPerPageOptions={[25, 50, 100]}
          component="div"
          count={filtered.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={(e, newPage) => setPage(newPage)}
          onRowsPerPageChange={(e) => {
            setRowsPerPage(parseInt(e.target.value, 10));
            setPage(0);
          }}
        />
      </TableContainer>

      <UploadCsvDialog
        open={uploadOpen}
        onClose={() => setUploadOpen(false)}
        type="TRANSACTIONS"
      />
    </Box>
  );
}
