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
  Divider,
  Button,
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { useState } from 'react';
import UploadCsvDialog from '../components/UploadCsvDialog';

// ─── Types ────────────────────────────────────────────────────────────────────

interface Position {
  symbol: string;
  name: string;
  quantity: number;
  avgCostBasis: number;   // cost per share
  lastPrice: number;
  pricePaid: number;      // total cost (qty × avgCostBasis)
}

// ─── Derived helpers ──────────────────────────────────────────────────────────

function marketValue(p: Position) {
  return p.quantity * p.lastPrice;
}

function gainLossDollar(p: Position) {
  return marketValue(p) - p.pricePaid;
}

function gainLossPct(p: Position) {
  if (p.pricePaid === 0) return 0;
  return (gainLossDollar(p) / p.pricePaid) * 100;
}

function fmt(n: number, decimals = 2) {
  return n.toLocaleString('en-US', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  });
}

function fmtCurrency(n: number) {
  return `$${fmt(Math.abs(n))}`;
}

// ─── Sample data (replace with API call once backend ready) ───────────────────

const SAMPLE_ACCOUNT = {
  accountNumber: 'XXX-XX1234',
  balance: 48_231.55,
};

const SAMPLE_POSITIONS: Position[] = [
  { symbol: 'AAPL', name: 'Apple Inc.', quantity: 50, avgCostBasis: 172.40, lastPrice: 211.18, pricePaid: 8_620.00 },
  { symbol: 'MSFT', name: 'Microsoft Corp.', quantity: 20, avgCostBasis: 380.00, lastPrice: 415.32, pricePaid: 7_600.00 },
  { symbol: 'NVDA', name: 'NVIDIA Corp.', quantity: 15, avgCostBasis: 620.50, lastPrice: 875.40, pricePaid: 9_307.50 },
  { symbol: 'AMZN', name: 'Amazon.com Inc.', quantity: 10, avgCostBasis: 185.00, lastPrice: 198.62, pricePaid: 1_850.00 },
  { symbol: 'GOOGL', name: 'Alphabet Inc.', quantity: 8, avgCostBasis: 155.00, lastPrice: 142.50, pricePaid: 1_240.00 },
  { symbol: 'META', name: 'Meta Platforms Inc.', quantity: 12, avgCostBasis: 510.00, lastPrice: 568.90, pricePaid: 6_120.00 },
  { symbol: 'TSLA', name: 'Tesla Inc.', quantity: 25, avgCostBasis: 230.00, lastPrice: 182.30, pricePaid: 5_750.00 },
];

// ─── Sub-components ───────────────────────────────────────────────────────────

function GainLossCell({ value, pct }: { value: number; pct: number }) {
  const positive = value >= 0;
  const color = positive ? 'success.main' : 'error.main';
  const sign = positive ? '+' : '−';

  return (
    <TableCell align="right" sx={{ whiteSpace: 'nowrap' }}>
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 0.25 }}>
        <Box>
          <Typography variant="body2" sx={{ color, fontWeight: 600, lineHeight: 1.2 }}>
            {sign}{fmtCurrency(value)}
          </Typography>
          <Typography variant="caption" sx={{ color, lineHeight: 1.2 }}>
            {sign}{fmt(Math.abs(pct))}%
          </Typography>
        </Box>
      </Box>
    </TableCell>
  );
}

// ─── Page ────────────────────────────────────────────────────────────────────

export default function AccountPositionPage() {
  const [uploadOpen, setUploadOpen] = useState(false);
  const positions = SAMPLE_POSITIONS;

  const stockMarketValue = positions.reduce((sum, p) => sum + marketValue(p), 0);
  const stockCost = positions.reduce((sum, p) => sum + p.pricePaid, 0);

  // Cash is whatever remains to reach the total account balance
  const cashValue = SAMPLE_ACCOUNT.balance - stockMarketValue;
  const cashPosition: Position = {
    symbol: 'CASH',
    name: 'Cash and Sweep Vehicle',
    quantity: cashValue,
    avgCostBasis: 1.00,
    lastPrice: 1.00,
    pricePaid: cashValue,
  };

  const allPositions = [...positions, cashPosition];

  const totalMarketValue = SAMPLE_ACCOUNT.balance; // stockMarketValue + cashValue
  const totalCost = stockCost + cashValue;
  const totalGainLoss = totalMarketValue - totalCost;
  const totalGainLossPct = totalCost > 0 ? (totalGainLoss / totalCost) * 100 : 0;

  return (
    <Box sx={{ px: 4, pt: 1, pb: 4, maxWidth: 1200, mx: 'auto' }}>

      {/* ── Page Title ── */}
      <Typography variant="h4" sx={{ fontWeight: 'bold', mb: 2 }}>
        Account Position
      </Typography>

      {/* ── Account Info Cards ── */}
      <Box sx={{ display: 'flex', gap: 3, flexWrap: 'wrap', mb: 4 }}>
        <Paper variant="outlined" sx={{ px: 3, py: 2, borderRadius: 2, minWidth: 200 }}>
          <Typography variant="body2" color="text.secondary">Account Number</Typography>
          <Typography variant="h6" sx={{ fontWeight: 'bold', letterSpacing: 1 }}>
            {SAMPLE_ACCOUNT.accountNumber}
          </Typography>
        </Paper>

        <Paper variant="outlined" sx={{ px: 3, py: 2, borderRadius: 2, minWidth: 200 }}>
          <Typography variant="body2" color="text.secondary">Account Balance</Typography>
          <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
            ${fmt(SAMPLE_ACCOUNT.balance)}
          </Typography>
        </Paper>

        <Paper variant="outlined" sx={{ px: 3, py: 2, borderRadius: 2, minWidth: 200 }}>
          <Typography variant="body2" color="text.secondary">Portfolio Market Value</Typography>
          <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
            ${fmt(totalMarketValue)}
          </Typography>
        </Paper>

        <Paper
          variant="outlined"
          sx={{
            px: 3, py: 2, borderRadius: 2, minWidth: 200,
            borderColor: totalGainLoss >= 0 ? 'success.main' : 'error.main',
          }}
        >
          <Typography variant="body2" color="text.secondary">Total Gain / Loss</Typography>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
            <Typography
              variant="h6"
              sx={{ fontWeight: 'bold', color: totalGainLoss >= 0 ? 'success.main' : 'error.main' }}
            >
              {totalGainLoss >= 0 ? '+' : '−'}${fmt(Math.abs(totalGainLoss))}
              &nbsp;
              <Typography component="span" variant="body2" sx={{ color: 'inherit' }}>
                ({totalGainLoss >= 0 ? '+' : '−'}{fmt(Math.abs(totalGainLossPct))}%)
              </Typography>
            </Typography>
          </Box>
        </Paper>
      </Box>


      <Divider sx={{ mb: 3 }} />

      {/* ── Positions Table ── */}
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1.5 }}>
        <Typography variant="h6" sx={{ fontWeight: 600 }}>
          Account Positions
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          <Button variant="contained" size="small" startIcon={<AddIcon />} onClick={() => setUploadOpen(true)}>
            Add Positions
          </Button>
          <Chip label={`${positions.length} positions`} size="small" variant="outlined" />
        </Box>
      </Box>

      <TableContainer component={Paper} variant="outlined" sx={{ borderRadius: 2 }}>
        <Table size="small" id="account-positions-table">
          <TableHead>
            <TableRow sx={{ '& th': { fontWeight: 700, whiteSpace: 'nowrap', bgcolor: 'action.hover' } }}>
              <TableCell>Symbol / Name</TableCell>
              <TableCell align="right">Last Price</TableCell>
              <TableCell align="right">Qty</TableCell>
              <TableCell align="right">Cost Basis</TableCell>
              <TableCell align="right">Price Paid</TableCell>
              <TableCell align="right">Market Value</TableCell>
              <TableCell align="right">Gain / Loss</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {allPositions.map((p) => {
              const gl = gainLossDollar(p);
              const glp = gainLossPct(p);
              const mv = marketValue(p);

              return (
                <TableRow
                  key={p.symbol}
                  hover
                  sx={{ '&:last-child td': { border: 0 } }}
                >
                  <TableCell>
                    <Box>
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>
                        {p.symbol}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {p.name}
                      </Typography>
                    </Box>
                  </TableCell>
                  <TableCell align="right">
                    <Typography variant="body2">${fmt(p.lastPrice)}</Typography>
                  </TableCell>
                  <TableCell align="right">
                    <Typography variant="body2">{p.quantity}</Typography>
                  </TableCell>
                  <TableCell align="right">
                    <Typography variant="body2">${fmt(p.avgCostBasis)}</Typography>
                  </TableCell>
                  <TableCell align="right">
                    <Typography variant="body2">${fmt(p.pricePaid)}</Typography>
                  </TableCell>
                  <TableCell align="right">
                    <Typography variant="body2">${fmt(mv)}</Typography>
                  </TableCell>
                  <GainLossCell value={gl} pct={glp} />
                </TableRow>
              );
            })}

            {/* Totals row */}
            <TableRow sx={{ bgcolor: 'action.selected', '& td': { fontWeight: 700, borderTop: '2px solid', borderColor: 'divider' } }}>
              <TableCell colSpan={4}>
                <Typography variant="body2" sx={{ fontWeight: 700 }}>Total</Typography>
              </TableCell>
              <TableCell align="right">
                <Typography variant="body2" sx={{ fontWeight: 700 }}>${fmt(totalCost)}</Typography>
              </TableCell>
              <TableCell align="right">
                <Typography variant="body2" sx={{ fontWeight: 700 }}>${fmt(totalMarketValue)}</Typography>
              </TableCell>
              <GainLossCell value={totalGainLoss} pct={totalGainLossPct} />
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>

      <UploadCsvDialog
        open={uploadOpen}
        onClose={() => setUploadOpen(false)}
        type="POSITIONS"
      />
    </Box>
  );
}
