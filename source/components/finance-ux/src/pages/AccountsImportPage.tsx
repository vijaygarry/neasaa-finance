import { useState } from 'react';
import {
  Box,
  Typography,
  Chip,
  Tabs,
  Tab,
  TextField,
  MenuItem,
  CircularProgress,
  Alert,
} from '@mui/material';
import AccountBalanceIcon from '@mui/icons-material/AccountBalance';
import AccountPositionPage from './AccountPositionPage';
import AccountTransactionsPage from './AccountTransactionsPage';
import { useAccount } from '../context/AccountContext';

// ─── Page ────────────────────────────────────────────────────────────────────

export default function AccountsImportPage() {
  const { selectedAccount, accounts, selectedAccountId, setSelectedAccountId, accountsLoading, accountsError } = useAccount();
  const [activeTab, setActiveTab] = useState(0);

  return (
    <Box sx={{ px: 4, pt: 1, pb: 4 }}>
      {/* ── Title row with inline account selector ── */}
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 0, mb: 2 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
          Accounts
        </Typography>
        {accountsLoading && <CircularProgress size={20} />}
        {!accountsLoading && (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
            <AccountBalanceIcon sx={{ fontSize: 16, color: 'text.secondary' }} />
            <TextField
              select
              size="small"
              value={selectedAccountId}
              onChange={e => setSelectedAccountId(Number(e.target.value))}
              variant="outlined"
              sx={{ minWidth: 200 }}
            >
              {accounts.length === 0
                ? <MenuItem value="" disabled><Typography variant="body2" color="text.secondary">No accounts</Typography></MenuItem>
                : accounts.map(a => (
                  <MenuItem key={a.accountId} value={a.accountId}>
                    <Typography variant="body2">
                      {a.accountName} · {a.bankName}
                    </Typography>
                  </MenuItem>
                ))}
            </TextField>
          </Box>
        )}
      </Box>

      {accountsError && (
        <Alert severity="error" sx={{ mb: 2 }}>{accountsError}</Alert>
      )}

      {!accountsLoading && !accountsError && accounts.length === 0 && (
        <Alert severity="info" sx={{ mb: 2 }}>No accounts found.</Alert>
      )}

      {/* ── Tabs ── */}
      <Box sx={{ mb: 3 }}>
        <Tabs value={activeTab} onChange={(_, val) => setActiveTab(val)}>
          <Tab label="Positions" sx={{ fontWeight: 'bold' }} />
          <Tab label="Transaction History" sx={{ fontWeight: 'bold' }} />
        </Tabs>
      </Box>

      {/* ── Tab Content ── */}
      <Box sx={{ mx: -4, mb: 4 }}>
        {activeTab === 0 && <AccountPositionPage />}
        {activeTab === 1 && <AccountTransactionsPage />}
      </Box>
    </Box>
  );
}
