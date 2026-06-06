import { useState, useCallback, useEffect, Fragment } from 'react';
import {
  Box,
  Paper,
  Typography,
  Autocomplete,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Switch,
  FormControlLabel,
  Button,
  IconButton,
  Collapse,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  Divider,
  Alert,
} from '@mui/material';
import ArrowDropUpIcon from '@mui/icons-material/ArrowDropUp';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import ExpandLessIcon from '@mui/icons-material/ExpandLess';
import { useSearchParams } from 'react-router-dom';
import { searchStocks, Stock } from '../services/financeApi';
import { COVERED_CALL_CHAIN, CoveredCallExpiration } from '../utils/coveredCallOptionChain';
import { SAMPLE_STOCKS, StockDetail } from '../utils/sampleStocks';
import { formatDateTime, formatExpiryLabel, PERIODS, PERIOD_DAYS, Period } from '../utils/dateUtils';
import { formatCount } from '../utils/numberUtils';
import EventBanner, { EventMarker } from '../components/EventBanner';

function getEvents(detail: StockDetail): EventMarker[] {
  const today = new Date().toISOString().slice(0, 10);
  const events: EventMarker[] = [];
  if (detail.dividendExDate && detail.dividendExDate >= today) {
    events.push({ type: 'dividend', label: 'Dividend Ex-Date', date: detail.dividendExDate });
  }
  if (detail.nextEarningsDate && detail.nextEarningsDate >= today) {
    events.push({ type: 'earnings', label: 'Earnings', date: detail.nextEarningsDate });
  }
  return events.sort((a, b) => a.date.localeCompare(b.date));
}

export default function CoveredCallStrategyPage() {
  const [searchParams] = useSearchParams();

  const [inputValue, setInputValue] = useState('');
  const [selectedOption, setSelectedOption] = useState<Stock | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [options, setOptions] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);
  const [period, setPeriod] = useState<Period>('3M');
  const [weeklyOptions, setWeeklyOptions] = useState(false);
  const [priceFrom, setPriceFrom] = useState('');
  const [priceTo, setPriceTo] = useState('');

  const paramSymbol = (searchParams.get('symbol') ?? '').toUpperCase();

  const [filteredExpirations, setFilteredExpirations] = useState<CoveredCallExpiration[] | null>(null);
  const [currentSymbol, setCurrentSymbol] = useState('');
  const [collapsedDates, setCollapsedDates] = useState<Set<string>>(new Set());
  const [error, setError] = useState('');

  const toggleExpiration = (date: string) => {
    setCollapsedDates(prev => {
      const next = new Set(prev);
      if (next.has(date)) next.delete(date); else next.add(date);
      return next;
    });
  };
  const collapseAll = () => setCollapsedDates(new Set(filteredExpirations?.map(e => e.date) ?? []));
  const expandAll  = () => setCollapsedDates(new Set());

  const stockInfo = SAMPLE_STOCKS.find(s => s.symbol === currentSymbol);
  const events = stockInfo ? getEvents(stockInfo) : [];
  const isPositive = stockInfo ? stockInfo.changeValue >= 0 : false;
  const changeColor = isPositive ? 'success.main' : 'error.main';

  const handleInputChange = useCallback(async (
    _: React.SyntheticEvent,
    value: string,
    reason: string,
  ) => {
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

  function applyFilters(sym: string) {
    const from = priceFrom ? parseFloat(priceFrom) : null;
    const to   = priceTo   ? parseFloat(priceTo)   : null;

    if (from !== null && isNaN(from)) { setError('Price From must be a valid number.'); return; }
    if (to   !== null && isNaN(to))   { setError('Price To must be a valid number.'); return; }
    if (from !== null && to !== null && from > to) {
      setError('Price From must be less than Price To.'); return;
    }

    const chain = COVERED_CALL_CHAIN[sym];
    if (!chain) {
      setError('No options data available for this stock.');
      setFilteredExpirations(null);
      return;
    }

    setCurrentSymbol(sym);
    setCollapsedDates(new Set());
    const maxDTE = PERIOD_DAYS[period];
    let exps = chain.expirations.filter(exp => {
      if (exp.daysToExpiry > maxDTE) return false;
      if (!weeklyOptions && exp.isWeekly) return false;
      return true;
    });

    if (from !== null || to !== null) {
      const low  = from ?? 0;
      const high = to   ?? Infinity;
      exps = exps
        .map(exp => ({
          ...exp,
          calls: exp.calls.filter(c => c.strike >= low && c.strike <= high),
          puts:  exp.puts.filter(p  => p.strike >= low && p.strike <= high),
        }))
        .filter(exp => exp.calls.length > 0);
    }

    setFilteredExpirations(exps);
  }

  useEffect(() => {
    if (!paramSymbol) return;
    const stockMatch = SAMPLE_STOCKS.find(s => s.symbol === paramSymbol);
    if (!stockMatch) return;
    const opt: Stock = { symbol: stockMatch.symbol, name: stockMatch.name, type: 'EQUITY' };
    setSelectedOption(opt);
    setOptions([opt]);
    setInputValue(`${stockMatch.symbol} — ${stockMatch.name}`);
    setError('');
    applyFilters(stockMatch.symbol);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [paramSymbol]);

  const handleChange = (_: React.SyntheticEvent, value: Stock | null) => {
    setSelectedOption(value);
    if (!value) { setFilteredExpirations(null); setCurrentSymbol(''); setError(''); return; }
    setInputValue(`${value.symbol} — ${value.name}`);
    setDropdownOpen(false);
    applyFilters(value.symbol);
  };

  const handleGo = () => {
    setError('');
    setFilteredExpirations(null);
    setCurrentSymbol('');
    const raw = inputValue.trim();
    if (!raw) { setError('Please search for and select a stock.'); return; }
    const sym = raw.split(' — ')[0].trim().toUpperCase();
    const stockMatch = SAMPLE_STOCKS.find(s => s.symbol === sym);
    setDropdownOpen(false);
    if (stockMatch) {
      const opt: Stock = { symbol: stockMatch.symbol, name: stockMatch.name, type: 'EQUITY' };
      setSelectedOption(opt);
      setOptions(prev => (prev.some(o => o.symbol === sym) ? prev : [opt, ...prev]));
      setInputValue(`${stockMatch.symbol} — ${stockMatch.name}`);
    }
    applyFilters(sym);
  };

  return (
    <Box sx={{ p: 3, maxWidth: 1400, mx: 'auto' }}>
      <Typography variant="h5" sx={{ fontWeight: 'bold', mb: 2 }}>
        Covered Call Strategy
      </Typography>

      {/* Configuration Panel */}
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
                onKeyDown={(e) => { if (e.key === 'Enter') handleGo(); }}
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

          <FormControl size="small" sx={{ minWidth: 100 }}>
            <InputLabel>Period</InputLabel>
            <Select value={period} label="Period" onChange={e => setPeriod(e.target.value as Period)}>
              {PERIODS.map(p => <MenuItem key={p} value={p}>{p}</MenuItem>)}
            </Select>
          </FormControl>

          <FormControlLabel
            control={<Switch checked={weeklyOptions} onChange={e => setWeeklyOptions(e.target.checked)} size="small" />}
            label={<Typography variant="body2">Weekly Options</Typography>}
          />

          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <TextField
              size="small"
              label="Price From"
              value={priceFrom}
              onChange={e => setPriceFrom(e.target.value)}
              slotProps={{ htmlInput: { type: 'number', min: 0, step: 1 } }}
              sx={{ width: 115 }}
            />
            <Typography variant="body2" color="text.secondary">to</Typography>
            <TextField
              size="small"
              label="Price To"
              value={priceTo}
              onChange={e => setPriceTo(e.target.value)}
              slotProps={{ htmlInput: { type: 'number', min: 0, step: 1 } }}
              sx={{ width: 115 }}
            />
          </Box>

          <Button variant="contained" startIcon={<PlayArrowIcon />} onClick={handleGo}>
            Go
          </Button>
        </Box>
      </Paper>

      {error && (
        <Alert severity="warning" sx={{ mb: 2 }} onClose={() => setError('')}>{error}</Alert>
      )}

      {filteredExpirations !== null && (
        <>
          {/* Stock price banner */}
          {stockInfo && (
            <Paper elevation={1} sx={{ p: 3, mb: 2 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 1, mb: 1 }}>
                <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
                  {stockInfo.symbol} - {stockInfo.name}
                </Typography>
                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
                  <Chip label="Type: Call" color="success" size="small" />
                  <Chip label={`Period: ${period}`} variant="outlined" size="small" />
                  <Chip label={`Options: ${weeklyOptions ? 'Weekly' : 'Monthly'}`} variant="outlined" size="small" />
                  {(priceFrom || priceTo) && (
                    <Chip label={`Price: $${priceFrom || '0'} – $${priceTo || '∞'}`} variant="outlined" size="small" />
                  )}
                </Box>
              </Box>

              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
                  ${stockInfo.currentPrice.toFixed(2)}
                </Typography>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  {isPositive
                    ? <ArrowDropUpIcon sx={{ color: changeColor, fontSize: 32 }} />
                    : <ArrowDropDownIcon sx={{ color: changeColor, fontSize: 32 }} />
                  }
                  <Typography variant="h6" sx={{ fontWeight: 500, color: changeColor }}>
                    {isPositive ? '+' : ''}{stockInfo.changeValue.toFixed(2)}
                  </Typography>
                  <Typography variant="h6" sx={{ ml: 1, fontWeight: 500, color: changeColor }}>
                    ({isPositive ? '+' : ''}{stockInfo.changePercent.toFixed(2)}%)
                  </Typography>
                </Box>
              </Box>

              <Typography variant="caption" color="text.secondary" sx={{ display: 'block', mb: 1.5 }}>
                Last updated {formatDateTime(stockInfo.lastUpdated)}
              </Typography>
            </Paper>
          )}

          {filteredExpirations.length === 0 ? (
            <Alert severity="info">
              No expirations found for the selected criteria. Try a longer period or enable weekly options.
            </Alert>
          ) : (
            <>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 1, mb: 1 }}>
                <Button size="small" variant="text" onClick={expandAll}>Expand All</Button>
                <Button size="small" variant="text" onClick={collapseAll}>Collapse All</Button>
              </Box>

              {filteredExpirations.map((exp, idx) => {
                const isCollapsed = collapsedDates.has(exp.date);
                const prevDate = idx === 0 ? '' : filteredExpirations[idx - 1].date;
                const eventsForBlock = events.filter(e =>
                  e.date <= exp.date && (prevDate === '' || e.date > prevDate)
                );
                const contracts = exp.calls;
                const stockPrice = stockInfo?.currentPrice ?? 0;
                const expAvgVolume = contracts.length > 0
                  ? Math.round(contracts.reduce((sum, c) => sum + c.volume, 0) / contracts.length)
                  : 0;

                return (
                  <Fragment key={exp.date}>
                    {eventsForBlock.map(ev => <EventBanner key={ev.date} event={ev} />)}

                    <Paper elevation={2} sx={{ mb: 2, overflow: 'hidden' }}>
                      <Box
                        onClick={() => toggleExpiration(exp.date)}
                        sx={{
                          px: 1.5, py: 1,
                          display: 'flex', alignItems: 'center',
                          bgcolor: 'grey.100', cursor: 'pointer', userSelect: 'none',
                          '&:hover': { bgcolor: 'grey.200' },
                        }}
                      >
                        <IconButton size="small" sx={{ mr: 0.5 }}>
                          {isCollapsed ? <ExpandMoreIcon fontSize="small" /> : <ExpandLessIcon fontSize="small" />}
                        </IconButton>
                        <Typography variant="subtitle1" sx={{ fontWeight: 'bold' }}>
                          {formatExpiryLabel(exp.date)}
                        </Typography>
                        <Typography variant="caption" color="text.secondary" sx={{ ml: 1 }}>
                          ({exp.daysToExpiry} days to expire)
                        </Typography>
                        <Chip
                          label={exp.isWeekly ? 'Weekly' : 'Monthly'}
                          size="small"
                          variant="outlined"
                          sx={{ ml: 1.5, height: 20, fontSize: '0.68rem' }}
                        />
                      </Box>

                      <Collapse in={!isCollapsed}>
                        <Divider />
                        {contracts.length === 0 ? (
                          <Box sx={{ p: 2 }}>
                            <Typography variant="body2" color="text.secondary">
                              No contracts match the price range.
                            </Typography>
                          </Box>
                        ) : (
                          <TableContainer>
                            <Table size="small" sx={{ minWidth: 1200 }}>
                              <TableHead>
                                <TableRow sx={{ bgcolor: 'grey.50' }}>
                                  <TableCell sx={{ fontWeight: 'bold' }}>Strike</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Bid</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Effective Price</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>$ Gain</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>% Gain</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>% Annual Gain</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>ITM %</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Downside Protection %</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Volume</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Avg Volume</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Open Int.</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Ask</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Last</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Change</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>IV</TableCell>
                                  <TableCell align="right" sx={{ fontWeight: 'bold' }}>Delta</TableCell>
                                </TableRow>
                              </TableHead>
                              <TableBody>
                                {contracts.map(contract => {
                                  const moneyness = stockPrice > 0
                                    ? ((stockPrice - contract.strike) / stockPrice) * 100
                                    : 0;
                                  const downsideProtection = stockPrice > 0
                                    ? (contract.bid / stockPrice) * 100
                                    : 0;
                                  const effectivePrice = stockPrice - contract.bid;
                                  const gain = contract.strike - effectivePrice;
                                  const pctGain = effectivePrice > 0 ? (gain / effectivePrice) * 100 : 0;
                                  const annualGain = exp.daysToExpiry > 0
                                    ? (pctGain * 365) / exp.daysToExpiry
                                    : 0;

                                  return (
                                    <TableRow
                                      key={contract.strike}
                                      sx={{
                                        bgcolor: contract.inTheMoney ? 'rgba(0, 0, 0, 0.06)' : 'transparent',
                                        '&:hover': { bgcolor: 'action.hover' },
                                      }}
                                    >
                                      <TableCell>
                                        <Typography
                                          variant="body2"
                                          sx={{ fontWeight: contract.inTheMoney ? 'bold' : 'normal' }}
                                        >
                                          ${contract.strike.toFixed(2)}
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">${contract.bid.toFixed(2)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2" sx={{ fontWeight: 500 }}>
                                          ${effectivePrice.toFixed(2)}
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2" sx={{ color: gain >= 0 ? 'success.main' : 'error.main', fontWeight: 500 }}>
                                          {gain >= 0 ? '+' : ''}${gain.toFixed(2)}
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2" sx={{ color: pctGain >= 0 ? 'success.main' : 'error.main' }}>
                                          {pctGain >= 0 ? '+' : ''}{pctGain.toFixed(2)}%
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2" sx={{ color: annualGain >= 0 ? 'success.main' : 'error.main', fontWeight: 500 }}>
                                          {annualGain >= 0 ? '+' : ''}{annualGain.toFixed(2)}%
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography
                                          variant="body2"
                                          sx={{ color: moneyness >= 0 ? 'success.main' : 'error.main', fontWeight: 500 }}
                                        >
                                          {moneyness >= 0 ? '+' : ''}{moneyness.toFixed(2)}%
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2" sx={{ color: 'success.main' }}>
                                          {downsideProtection.toFixed(2)}%
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">{formatCount(contract.volume)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">{formatCount(expAvgVolume)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">{formatCount(contract.openInterest)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">${contract.ask.toFixed(2)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">${contract.last.toFixed(2)}</Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography
                                          variant="body2"
                                          sx={{ color: contract.change >= 0 ? 'success.main' : 'error.main' }}
                                        >
                                          {contract.change >= 0 ? '+' : ''}{contract.change.toFixed(2)}
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">
                                          {contract.impliedVolatility.toFixed(1)}%
                                        </Typography>
                                      </TableCell>
                                      <TableCell align="right">
                                        <Typography variant="body2">
                                          {contract.delta.toFixed(4)}
                                        </Typography>
                                      </TableCell>
                                    </TableRow>
                                  );
                                })}
                              </TableBody>
                            </Table>
                          </TableContainer>
                        )}
                      </Collapse>
                    </Paper>
                  </Fragment>
                );
              })}

              {events
                .filter(e => e.date > filteredExpirations[filteredExpirations.length - 1].date)
                .map(ev => <EventBanner key={ev.date} event={ev} />)
              }
            </>
          )}
        </>
      )}
    </Box>
  );
}
