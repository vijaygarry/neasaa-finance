import { useState, useCallback, Fragment } from 'react';
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
  ToggleButton,
  ToggleButtonGroup,
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
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import ExpandLessIcon from '@mui/icons-material/ExpandLess';
import { searchStocks, Stock } from '../services/financeApi';
import { SAMPLE_OPTIONS_CHAIN, ExpirationData } from '../utils/sampleOptionsChain';
import { SAMPLE_STOCKS, StockDetail } from '../utils/sampleStocks';

const PERIODS = ['3M', '6M', '9M', '12M'] as const;
type Period = typeof PERIODS[number];

const PERIOD_DAYS: Record<Period, number> = {
  '3M': 92,
  '6M': 183,
  '9M': 274,
  '12M': 366,
};

const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

function formatDateOnly(dateStr: string): string {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, '0');
  const mmm = MONTHS[d.getMonth()];
  const yyyy = d.getFullYear();
  return `${dd}-${mmm}-${yyyy}`;
}

function formatCount(n: number): string {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`;
  return n.toString();
}

interface EventMarker {
  type: 'dividend' | 'earnings';
  label: string;
  date: string; // ISO YYYY-MM-DD
}

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

function EventBanner({ event }: { event: EventMarker }) {
  const isDividend = event.type === 'dividend';
  const borderColor = isDividend ? '#2e7d32' : '#e65100';
  const bgColor = isDividend ? 'rgba(46, 125, 50, 0.07)' : 'rgba(230, 81, 0, 0.07)';
  const chipColor = isDividend ? 'success' : 'warning';

  return (
    <Box
      sx={{
        display: 'flex',
        alignItems: 'center',
        gap: 1.5,
        px: 2,
        py: 0.75,
        mb: 1,
        borderLeft: `3px solid ${borderColor}`,
        bgcolor: bgColor,
        borderRadius: '0 4px 4px 0',
      }}
    >
      <Chip
        label={isDividend ? 'Dividend' : 'Earnings'}
        size="small"
        color={chipColor as 'success' | 'warning'}
        sx={{ fontWeight: 'bold', fontSize: '0.7rem', height: 22 }}
      />
      <Typography variant="body2" sx={{ fontWeight: 600 }}>
        {event.label}
      </Typography>
      <Typography variant="body2" color="text.secondary">
        {formatDateOnly(event.date)}
      </Typography>
    </Box>
  );
}

export default function OptionsPage() {
  const [inputValue, setInputValue] = useState('');
  const [selectedOption, setSelectedOption] = useState<Stock | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [options, setOptions] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);
  const [period, setPeriod] = useState<Period>('3M');
  const [weeklyOptions, setWeeklyOptions] = useState(false);
  const [priceFrom, setPriceFrom] = useState('');
  const [priceTo, setPriceTo] = useState('');
  const [optionType, setOptionType] = useState<'call' | 'put'>('call');
  const [filteredExpirations, setFilteredExpirations] = useState<ExpirationData[] | null>(null);
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
    const to = priceTo ? parseFloat(priceTo) : null;

    if (from !== null && isNaN(from)) {
      setError('Price From must be a valid number.');
      return;
    }
    if (to !== null && isNaN(to)) {
      setError('Price To must be a valid number.');
      return;
    }
    if (from !== null && to !== null && from > to) {
      setError('Price From must be less than Price To.');
      return;
    }

    const chain = SAMPLE_OPTIONS_CHAIN[sym];
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
      const low = from ?? 0;
      const high = to ?? Infinity;
      exps = exps
        .map(exp => ({
          ...exp,
          calls: exp.calls.filter(c => c.strike >= low && c.strike <= high),
          puts: exp.puts.filter(p => p.strike >= low && p.strike <= high),
        }))
        .filter(exp =>
          (optionType === 'call' ? exp.calls : exp.puts).length > 0
        );
    }

    setFilteredExpirations(exps);
  }

  // Case 1: user picks from the suggestion dropdown — auto-submit immediately
  const handleChange = (_: React.SyntheticEvent, value: Stock | null) => {
    setSelectedOption(value);
    if (!value) {
      setFilteredExpirations(null);
      setCurrentSymbol('');
      setError('');
      return;
    }
    setInputValue(`${value.symbol} — ${value.name}`);
    setDropdownOpen(false);
    applyFilters(value.symbol);
  };

  // Cases 2 & 3: Enter key or Go button — look up from whatever is typed
  const handleGo = () => {
    setError('');
    setFilteredExpirations(null);
    setCurrentSymbol('');
    const raw = inputValue.trim();
    if (!raw) {
      setError('Please search for and select a stock.');
      return;
    }
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
    <Box sx={{ p: 3, maxWidth: 1200, mx: 'auto' }}>
      <Typography variant="h5" sx={{ fontWeight: 'bold', mb: 2 }}>
        Options Chain
      </Typography>

      {/* Configuration Panel */}
      <Paper elevation={2} sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'center' }}>

          {/* Stock search */}
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
                  if (e.key === 'Enter') handleGo();
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

          {/* Period selector */}
          <FormControl size="small" sx={{ minWidth: 100 }}>
            <InputLabel>Period</InputLabel>
            <Select
              value={period}
              label="Period"
              onChange={e => setPeriod(e.target.value as Period)}
            >
              {PERIODS.map(p => (
                <MenuItem key={p} value={p}>{p}</MenuItem>
              ))}
            </Select>
          </FormControl>

          {/* Weekly options toggle */}
          <FormControlLabel
            control={
              <Switch
                checked={weeklyOptions}
                onChange={e => setWeeklyOptions(e.target.checked)}
                size="small"
              />
            }
            label={<Typography variant="body2">Weekly Options</Typography>}
          />

          {/* Price range */}
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

          {/* Option type toggle */}
          <ToggleButtonGroup
            value={optionType}
            exclusive
            onChange={(_, v) => { if (v) setOptionType(v); }}
            size="small"
          >
            <ToggleButton
              value="call"
              sx={{
                '&.Mui-selected': {
                  bgcolor: 'success.main',
                  color: 'white',
                  '&:hover': { bgcolor: 'success.dark' },
                },
              }}
            >
              Call
            </ToggleButton>
            <ToggleButton
              value="put"
              sx={{
                '&.Mui-selected': {
                  bgcolor: 'error.main',
                  color: 'white',
                  '&:hover': { bgcolor: 'error.dark' },
                },
              }}
            >
              Put
            </ToggleButton>
          </ToggleButtonGroup>

          {/* Go button */}
          <Button
            variant="contained"
            startIcon={<PlayArrowIcon />}
            onClick={handleGo}
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

      {/* Results */}
      {filteredExpirations !== null && (
        <>
          {/* Stock price banner */}
          {stockInfo && (
            <Paper
              elevation={1}
              sx={{ p: 2, mb: 2, display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 2 }}
            >
              <Typography variant="h6" sx={{ fontWeight: 'bold' }}>{stockInfo.symbol}</Typography>
              <Typography variant="body1" color="text.secondary">{stockInfo.name}</Typography>
              <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
                ${stockInfo.currentPrice.toFixed(2)}
              </Typography>
              <Typography
                variant="body1"
                sx={{
                  color: stockInfo.changeValue >= 0 ? 'success.main' : 'error.main',
                }}
              >
                {stockInfo.changeValue >= 0 ? '+' : ''}
                {stockInfo.changeValue.toFixed(2)}&nbsp;
                ({stockInfo.changePercent.toFixed(2)}%)
              </Typography>
              <Chip
                label={optionType === 'call' ? 'Calls' : 'Puts'}
                color={optionType === 'call' ? 'success' : 'error'}
                size="small"
              />
              <Chip label={period} variant="outlined" size="small" />
              {weeklyOptions && <Chip label="Incl. Weekly" variant="outlined" size="small" />}
            </Paper>
          )}

          {filteredExpirations.length === 0 ? (
            <Alert severity="info">
              No expirations found for the selected criteria. Try a longer period or enable weekly options.
            </Alert>
          ) : (
            <>
              {/* Expand / Collapse All toolbar */}
              <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 1, mb: 1 }}>
                <Button size="small" variant="text" onClick={expandAll}>
                  Expand All
                </Button>
                <Button size="small" variant="text" onClick={collapseAll}>
                  Collapse All
                </Button>
              </Box>

              {filteredExpirations.map((exp, idx) => {
                const isCollapsed = collapsedDates.has(exp.date);
                const prevDate = idx === 0 ? '' : filteredExpirations[idx - 1].date;
                const eventsForBlock = events.filter(e =>
                  e.date <= exp.date && (prevDate === '' || e.date > prevDate)
                );
                const contracts = optionType === 'call' ? exp.calls : exp.puts;
                const itmColor = optionType === 'call'
                  ? 'rgba(76, 175, 80, 0.10)'
                  : 'rgba(244, 67, 54, 0.10)';

                return (
                  <Fragment key={exp.date}>
                    {/* Events that fall between the previous expiration and this one */}
                    {eventsForBlock.map(ev => (
                      <EventBanner key={ev.date} event={ev} />
                    ))}

                    <Paper elevation={2} sx={{ mb: 2, overflow: 'hidden' }}>
                      <Box
                        onClick={() => toggleExpiration(exp.date)}
                        sx={{
                          px: 1.5,
                          py: 1,
                          display: 'flex',
                          alignItems: 'center',
                          bgcolor: 'grey.100',
                          cursor: 'pointer',
                          userSelect: 'none',
                          '&:hover': { bgcolor: 'grey.200' },
                        }}
                      >
                        <IconButton size="small" sx={{ mr: 0.5 }}>
                          {isCollapsed ? <ExpandMoreIcon fontSize="small" /> : <ExpandLessIcon fontSize="small" />}
                        </IconButton>
                        <Typography variant="subtitle1" sx={{ fontWeight: 'bold' }}>
                          {exp.label}&nbsp;({exp.isWeekly ? 'W' : 'M'})
                        </Typography>
                        <Typography variant="caption" color="text.secondary" sx={{ ml: 1 }}>
                          (expires in {exp.daysToExpiry} days)
                        </Typography>
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
                          <Table size="small" sx={{ minWidth: 650 }}>
                            <TableHead>
                              <TableRow sx={{ bgcolor: 'grey.50' }}>
                                <TableCell sx={{ fontWeight: 'bold' }}>Strike</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Bid</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Ask</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Last</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Change</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Volume</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Open Int.</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>IV</TableCell>
                                <TableCell align="right" sx={{ fontWeight: 'bold' }}>Delta</TableCell>
                              </TableRow>
                            </TableHead>
                            <TableBody>
                              {contracts.map(contract => (
                                <TableRow
                                  key={contract.strike}
                                  sx={{
                                    bgcolor: contract.inTheMoney ? itmColor : 'transparent',
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
                                    <Typography variant="body2">{formatCount(contract.volume)}</Typography>
                                  </TableCell>
                                  <TableCell align="right">
                                    <Typography variant="body2">{formatCount(contract.openInterest)}</Typography>
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
                              ))}
                            </TableBody>
                          </Table>
                        </TableContainer>
                      )}
                      </Collapse>
                    </Paper>
                  </Fragment>
                );
              })}

              {/* Events that fall after the last expiration in the filtered list */}
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
