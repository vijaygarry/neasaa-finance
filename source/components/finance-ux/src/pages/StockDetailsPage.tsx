import { useState, useCallback } from 'react';
import {
  Box, Typography, Autocomplete, TextField, Paper, Button, Alert,
} from '@mui/material';
import ArrowDropUpIcon from '@mui/icons-material/ArrowDropUp';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import CallMadeIcon from '@mui/icons-material/CallMade';
import InfoTooltip from '../components/InfoTooltip';
import { useNavigate } from 'react-router-dom';
import { searchStocks, Stock } from '../services/financeApi';
import { StockDetail, SAMPLE_STOCKS } from '../utils/sampleStocks';

const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

function formatDate(dateStr: string): string {
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, '0');
  const mmm = MONTHS[d.getMonth()];
  const yyyy = d.getFullYear();
  const hh = String(d.getHours()).padStart(2, '0');
  const min = String(d.getMinutes()).padStart(2, '0');
  const ss = String(d.getSeconds()).padStart(2, '0');
  return `${dd}-${mmm}-${yyyy} ${hh}:${min}:${ss}`;
}

function formatNumber(value: number): string {
  if (value >= 1000000000000) return `$${(value / 1000000000000).toFixed(2)}T`;
  if (value >= 1000000000) return `$${(value / 1000000000).toFixed(2)}B`;
  if (value >= 1000000) return `${(value / 1000000).toFixed(2)}M`;
  if (value >= 1000) return `${(value / 1000).toFixed(0)}K`;
  return value.toFixed(2);
}

function formatDateOnly(dateStr: string): string {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, '0');
  const mmm = MONTHS[d.getMonth()];
  const yyyy = d.getFullYear();
  return `${dd}-${mmm}-${yyyy}`;
}

interface DataRowProps {
  label: string;
  value: string | number;
  highlight?: boolean;
}

function DataRow({ label, value, highlight }: DataRowProps) {
  return (
    <Box sx={{ display: 'flex', justifyContent: 'space-between', py: 0.75 }}>
      <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 500 }}>
        {label}
      </Typography>
      <Typography
        variant="body2"
        sx={{
          fontWeight: highlight ? 600 : 500,
          color: highlight ? 'text.primary' : 'text.primary',
        }}
      >
        {value}
      </Typography>
    </Box>
  );
}

export default function StockDetailsPage() {
  const navigate = useNavigate();
  const [inputValue, setInputValue] = useState('');
  const [selectedOption, setSelectedOption] = useState<Stock | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [options, setOptions] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<StockDetail | null | 'not-found'>(null);
  const [error, setError] = useState('');

  const handleInputChange = useCallback(async (
    _: React.SyntheticEvent,
    value: string,
    reason: string,
  ) => {
    // Ignore Autocomplete's internal clears: 'reset' (Enter with no highlighted option)
    // and 'blur' (input loses focus when Go button is clicked) — both fire with an empty
    // value and would wipe inputValue before doLookup has a chance to read it.
    if (!value.trim() && (reason === 'reset' || reason === 'blur')) return;

    setInputValue(value);
    if (!value.trim() || value.includes(' — ')) {
      if (!value.trim()) { setOptions([]); setSelectedOption(null); }
      return;
    }
    setSelectedOption(null);
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

  // Case 1: user picks from the suggestion dropdown — auto-submit immediately
  const handleChange = (_: React.SyntheticEvent, value: Stock | null) => {
    setSelectedOption(value);
    if (!value) {
      setSelected(null);
      setError('');
      return;
    }
    const detail = SAMPLE_STOCKS.find((s) => s.symbol === value.symbol);
    setSelected(detail ?? 'not-found');
    setError('');
  };

  // Cases 2 & 3: Enter key or Go button — look up from whatever is typed
  const doLookup = useCallback(() => {
    setError('');
    setSelected(null); // always clear stale details before a new lookup
    const raw = inputValue.trim();
    if (!raw) {
      setError('Please search for and select a stock.');
      return;
    }
    // Handle both plain symbol ("AAPL") and label format ("AAPL — Apple Inc.")
    const sym = raw.split(' — ')[0].trim().toUpperCase();
    const detail = SAMPLE_STOCKS.find((s) => s.symbol === sym);
    setDropdownOpen(false);
    if (detail) {
      const opt: Stock = { symbol: detail.symbol, name: detail.name, type: 'EQUITY' };
      setSelectedOption(opt);
      // Ensure the matched option is available so the controlled value renders correctly
      setOptions(prev => (prev.some(o => o.symbol === sym) ? prev : [opt, ...prev]));
      setInputValue(`${detail.symbol} — ${detail.name}`);
      setSelected(detail);
    } else {
      setSelected('not-found');
    }
  }, [inputValue]);

  const detail = selected !== null && selected !== 'not-found' ? selected : null;
  const isPositive = detail !== null && detail.changeValue >= 0;
  const changeColor = isPositive ? 'success.main' : 'error.main';

  return (
    <Box sx={{ p: 3, maxWidth: 1200, mx: 'auto' }}>
      <Typography variant="h5" sx={{ fontWeight: 'bold', mb: 2 }}>
        Stock Details
      </Typography>

      <Paper elevation={2} sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'center' }}>
          <Autocomplete
            size="small"
            sx={{ minWidth: 260 }}
            value={selectedOption}
            inputValue={inputValue}
            open={dropdownOpen}
            onOpen={() => setDropdownOpen(true)}
            onClose={() => setDropdownOpen(false)}
            options={options}
            loading={loading}
            getOptionLabel={(option) => `${option.symbol} — ${option.name}`}
            filterOptions={(x) => x}
            onChange={handleChange}
            onInputChange={handleInputChange}
            noOptionsText="No results — try a symbol like AAPL"
            renderInput={(params) => (
              <TextField
                {...params}
                size="small"
                label="Search stock"
                placeholder="e.g. AAPL"
                onKeyDown={(e) => {
                  if (e.key === 'Enter') doLookup();
                }}
              />
            )}
            renderOption={(props, option) => (
              <li {...props} key={option.symbol}>
                <Box sx={{ py: 0.5 }}>
                  <Typography variant="body1" sx={{ fontWeight: 'bold' }}>{option.symbol}</Typography>
                  <Typography variant="body2" color="text.secondary">{option.name}</Typography>
                </Box>
              </li>
            )}
          />
          <Button
            variant="contained"
            startIcon={<PlayArrowIcon />}
            onClick={doLookup}
          >
            Go
          </Button>
        </Box>
      </Paper>

      {error && (
        <Alert severity="warning" sx={{ mb: 2 }} onClose={() => setError('')}>
          {error}
        </Alert>
      )}

      {selected === 'not-found' && (
        <Alert severity="info" sx={{ mb: 2 }}>
          Information not found for the selected stock.
        </Alert>
      )}

      {detail && (
        <Box sx={{ mt: 3 }}>
          {/* Price Card */}
          <Paper sx={{ p: 3, mb: 3 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 1, mb: 1 }}>
              <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
                {detail.symbol} - {detail.name}
              </Typography>
              <Box sx={{ display: 'flex', gap: 1 }}>
                <Button
                  size="small"
                  variant="outlined"
                  color="success"
                  endIcon={<CallMadeIcon fontSize="small" />}
                  onClick={() => navigate(`/options?type=call&symbol=${detail.symbol}`)}
                >
                  Call Option Chain
                </Button>
                <Button
                  size="small"
                  variant="outlined"
                  color="error"
                  endIcon={<CallMadeIcon fontSize="small" />}
                  onClick={() => navigate(`/options?type=put&symbol=${detail.symbol}`)}
                >
                  Put Option Chain
                </Button>
              </Box>
            </Box>

            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
              <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
                ${detail.currentPrice.toFixed(2)}
              </Typography>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                {isPositive
                  ? <ArrowDropUpIcon sx={{ color: changeColor, fontSize: 32 }} />
                  : <ArrowDropDownIcon sx={{ color: changeColor, fontSize: 32 }} />
                }
                <Typography variant="h6" sx={{ fontWeight: 500, color: changeColor }}>
                  {isPositive ? '+' : ''}{detail.changeValue.toFixed(2)}
                </Typography>
                <Typography variant="h6" sx={{ ml: 1, fontWeight: 500, color: changeColor }}>
                  ({isPositive ? '+' : ''}{detail.changePercent.toFixed(2)}%)
                </Typography>
              </Box>
            </Box>

            <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.5 }}>
              Last updated {formatDate(detail.lastUpdated)}
            </Typography>

            <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', mt: 1 }}>
              <Typography variant="caption" color="text.secondary">
                {detail.assetType}
              </Typography>
              <Typography variant="caption" color="text.secondary">•</Typography>
              <Typography variant="caption" color="text.secondary">
                {detail.market}
              </Typography>
              <Typography variant="caption" color="text.secondary">•</Typography>
              <Typography variant="caption" color="text.secondary">
                {detail.sector}
              </Typography>
              <Typography variant="caption" color="text.secondary">•</Typography>
              <Typography variant="caption" color="text.secondary">
                {detail.industry}
              </Typography>
            </Box>
          </Paper>

          {/* Trading Data */}
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 2 }}>
              Trading Data
            </Typography>
            <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', sm: '1fr 1fr' }, gap: 2 }}>
              <Box>
                <DataRow
                  label="Day's Range"
                  value={`${detail.dayLow.toFixed(2)} - ${detail.dayHigh.toFixed(2)}`}
                />
                <DataRow
                  label="52 Week Range"
                  value={`${detail.fiftyTwoWeekLow.toFixed(2)} - ${detail.fiftyTwoWeekHigh.toFixed(2)}`}
                />
                <DataRow label="Previous Close" value={`$${detail.previousClose.toFixed(2)}`} />
                <DataRow label="Open" value={`$${detail.open.toFixed(2)}`} />
                <DataRow
                  label="Bid"
                  value={`${detail.bid.toFixed(2)} x ${detail.bidSize}`}
                />
                <DataRow
                  label="Ask"
                  value={`${detail.ask.toFixed(2)} x ${detail.askSize}`}
                />
              </Box>
              <Box>
                <DataRow
                  label="50 Day Average"
                  value={`${detail.fiftyDayAverage.toFixed(2)} (${isPositive ? '+' : ''}${detail.fiftyDayAverageChange.toFixed(2)})`}
                />
                <DataRow
                  label="200 Day Average"
                  value={`${detail.twoHundredDayAverage.toFixed(2)} (${detail.twoHundredDayAverageChange >= 0 ? '+' : ''}${detail.twoHundredDayAverageChange.toFixed(2)})`}
                />
                <DataRow label="Volume" value={formatNumber(detail.volume)} />
                <DataRow label="Avg. 10 Days Volume" value={formatNumber(detail.avgVolume10Days)} />
                <DataRow label="Avg. 3 Month Volume" value={formatNumber(detail.avgVolume3Months)} />
                <DataRow label="Market Cap" value={formatNumber(detail.marketCap)} />
              </Box>
            </Box>
          </Paper>

          {/* Fundamentals */}
          <Paper sx={{ p: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 2 }}>
              Fundamentals
            </Typography>
            <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', sm: '1fr 1fr' }, gap: 2 }}>
              <Box>
                <DataRow
                  label="P/E (TTM)"
                  value={detail.peTrailing > 0 ? detail.peTrailing.toFixed(2) : '—'}
                />
                <DataRow
                  label="P/E (Forward)"
                  value={detail.peForward > 0 ? detail.peForward.toFixed(2) : '—'}
                />
                <DataRow
                  label="Dividend Rate"
                  value={detail.dividendRate > 0 ? `$${detail.dividendRate.toFixed(2)}` : '—'}
                />
                <DataRow
                  label="Dividend Yield"
                  value={detail.dividendYield > 0 ? `${detail.dividendYield.toFixed(2)}%` : '—'}
                />
                <Box sx={{ display: 'flex', justifyContent: 'space-between', py: 0.75 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                    <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 500 }}>
                      Dividend Ex Date
                    </Typography>
                    <InfoTooltip text="The ex-dividend date is the cut-off day that determines whether an investor is entitled to a company's upcoming dividend payment. If you buy a stock on or after this date, you will not receive the dividend; if you buy before it, you are eligible to receive it." />
                  </Box>
                  <Typography variant="body2" sx={{ fontWeight: 500, color: 'text.primary' }}>
                    {formatDateOnly(detail.dividendExDate)}
                  </Typography>
                </Box>
                <DataRow
                  label="Dividend Pay Date"
                  value={formatDateOnly(detail.dividendPayDate)}
                />
              </Box>
              <Box>
                <DataRow
                  label="Next Earnings Date"
                  value={formatDateOnly(detail.nextEarningsDate)}
                />
                <DataRow
                  label="Earnings Start Date"
                  value={formatDateOnly(detail.earningsStartDate)}
                />
                <DataRow
                  label="Earnings End Date"
                  value={formatDateOnly(detail.earningsEndDate)}
                />
                <DataRow
                  label="Avg. Analyst Rating"
                  value={detail.averageAnalystRating > 0 ? detail.averageAnalystRating.toFixed(1) : '—'}
                />
                <DataRow
                  label="Analyst Rating"
                  value={detail.analystRatingLevel}
                />
                <DataRow
                  label="1Y Price Target"
                  value={detail.oneYearPriceTarget > 0 ? `$${detail.oneYearPriceTarget.toFixed(2)}` : '—'}
                />
              </Box>
            </Box>
          </Paper>
        </Box>
      )}
    </Box>
  );
}
