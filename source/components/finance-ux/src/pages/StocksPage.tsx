import { useState, useCallback } from 'react';
import {
  Box, Typography, Autocomplete, TextField,
  Paper, Chip,
} from '@mui/material';
import { searchStocks, Stock } from '../services/financeApi';

export default function StocksPage() {
  const [options, setOptions] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<Stock | null>(null);

  const handleInputChange = useCallback(async (_: React.SyntheticEvent, value: string) => {
    if (value.trim().length === 0) {
      setOptions([]);
      return;
    }
    setLoading(true);
    try {
      const results = await searchStocks(value);
      setOptions(results);
    } catch {
      setOptions([]);
    } finally {
      setLoading(false);
    }
  }, []);

  return (
    <Box>
      <Typography variant="h5" gutterBottom>
        Stock Search
      </Typography>
      <Autocomplete
        sx={{ maxWidth: 480 }}
        options={options}
        loading={loading}
        getOptionLabel={(option) => `${option.symbol} — ${option.name}`}
        filterOptions={(x) => x}
        onChange={(_, value) => setSelected(value)}
        onInputChange={handleInputChange}
        noOptionsText="No results — try a symbol like AAPL"
        renderInput={(params) => (
          <TextField
            {...params}
            label="Search by symbol or name"
            placeholder="e.g. AAPL"
          />
        )}
        renderOption={(props, option) => (
          <li {...props} key={option.symbol}>
            <Box sx={{ py: 0.5 }}>
              <Typography variant="body1" sx={{ fontWeight: 'bold' }}>{option.symbol}</Typography>
              <Typography variant="body2" color="text.secondary">
                {option.name} · {option.type}
              </Typography>
            </Box>
          </li>
        )}
      />

      {selected && (
        <Paper sx={{ mt: 3, p: 3, maxWidth: 480 }}>
          <Typography variant="h6" gutterBottom>{selected.name}</Typography>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Chip label={selected.symbol} color="primary" />
            <Chip label={selected.type} variant="outlined" />
          </Box>
        </Paper>
      )}
    </Box>
  );
}
