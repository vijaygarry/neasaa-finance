import { useState, useCallback } from 'react';
import {
  Box, Typography, Autocomplete, TextField, Paper,
} from '@mui/material';
import ArrowDropUpIcon from '@mui/icons-material/ArrowDropUp';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';
import InfoTooltip from '../components/InfoTooltip';
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
  const [options, setOptions] = useState<Stock[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<StockDetail | null | 'not-found'>(null);

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

  const handleChange = (_: React.SyntheticEvent, value: Stock | null) => {
    if (!value) {
      setSelected(null);
      return;
    }
    const detail = SAMPLE_STOCKS.find((s) => s.symbol === value.symbol);
    setSelected(detail ?? 'not-found');
  };

  const detail = selected !== null && selected !== 'not-found' ? selected : null;
  const isPositive = detail !== null && detail.changeValue >= 0;
  const changeColor = isPositive ? 'success.main' : 'error.main';

  return (
    <Box>
      <Typography variant="h5" gutterBottom>
        Stock Details
      </Typography>

      <Autocomplete
        sx={{ maxWidth: 480 }}
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
            label="Search stock"
            placeholder="e.g. AAPL"
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

      {selected === 'not-found' && (
        <Paper sx={{ mt: 3, p: 3, maxWidth: 480 }}>
          <Typography variant="body1" color="text.secondary">
            Information not found for the selected stock.
          </Typography>
        </Paper>
      )}

      {detail && (
        <Box sx={{ mt: 3, maxWidth: 1000 }}>
          {/* Price Card */}
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold', mb: 1 }}>
              {detail.symbol} - {detail.name}
            </Typography>

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
