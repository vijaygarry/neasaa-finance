import { useState } from 'react';
import {
  Box,
  Typography,
  Chip,
  Tabs,
  Tab,
  TextField,
  MenuItem,
} from '@mui/material';
import AccountBalanceIcon from '@mui/icons-material/AccountBalance';
import AccountPositionPage from './AccountPositionPage';
import AccountTransactionsPage from './AccountTransactionsPage';
import { useAccount } from '../context/AccountContext';


// ─── Page ────────────────────────────────────────────────────────────────────

export default function AccountsImportPage() {
  const { selectedAccount, accounts, selectedAccountId, setSelectedAccountId, accountsLoading } = useAccount();
  const [activeTab, setActiveTab] = useState(0);
  return (
    <Box sx={{ px: 4, pt: 1, pb: 4 }}>
      {/* ── Title row with inline account selector ── */}
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 0, mb: 2 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
          Accounts
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
          <AccountBalanceIcon sx={{ fontSize: 16, color: 'text.secondary' }} />
          <TextField
            select
            size="small"
            value={selectedAccountId}
            onChange={e => setSelectedAccountId(Number(e.target.value))}
            disabled={accountsLoading}
            variant="outlined"
            sx={{ minWidth: 200 }}
          >
            {accounts.length === 0
              ? <MenuItem value="" disabled><Typography variant="body2" color="text.secondary">No accounts loaded</Typography></MenuItem>
              : accounts.map(a => (
                <MenuItem key={a.accountId} value={a.accountId}>
                  <Box>
                    <Typography variant="body2" sx={{ fontWeight: 600, lineHeight: 1.2 }}>
                      {a.accountName}
                    </Typography>
                    <Typography variant="caption" color="text.secondary">
                      {a.bankName} · {a.accountNumber}
                    </Typography>
                  </Box>
                </MenuItem>
              ))}
          </TextField>
        </Box>
      </Box>



      {/* Selected account info chips */}
      {selectedAccount && (
        <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mb: 2 }}>
          <Chip size="small" label={`Bank: ${selectedAccount.bankName}`} variant="outlined" />
          <Chip size="small" label={`ID: ${selectedAccount.accountNumber}`} variant="outlined" />
          {selectedAccount.balance != null && (
            <Chip
              size="small"
              label={`Balance: $${selectedAccount.balance.toLocaleString('en-US', { minimumFractionDigits: 2 })}`}
              color="success"
              variant="outlined"
            />
          )}
        </Box>
      )}

      {/* ── Tabs ── */}
      <Box sx={{ mb: 3 }}>
        <Tabs value={activeTab} onChange={(e, val) => setActiveTab(val)}>
          <Tab label="Positions" sx={{ fontWeight: 'bold' }} />
          <Tab label="Transaction History" sx={{ fontWeight: 'bold' }} />
        </Tabs>
      </Box>

      {/* ── Tab Content ── */}
      <Box sx={{ mx: -4, mb: 4 }}> {/* Negative margin to offset page padding if nested pages have their own padding */}
        {activeTab === 0 && <AccountPositionPage />}
        {activeTab === 1 && <AccountTransactionsPage />}
      </Box>


    </Box>
  );
}
