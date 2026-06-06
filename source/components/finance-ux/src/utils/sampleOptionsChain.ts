export interface OptionContract {
  strike: number;
  bid: number;
  ask: number;
  last: number;
  change: number;
  changePercent: number;
  volume: number;
  openInterest: number;
  impliedVolatility: number; // percentage, e.g. 28.5 means 28.5%
  delta: number;             // calls: 0..1, puts: -1..0
  inTheMoney: boolean;
}

export interface ExpirationData {
  date: string;       // ISO: "2026-06-19"
  label: string;      // Display: "Jun 19, 2026"
  isWeekly: boolean;
  daysToExpiry: number;
  calls: OptionContract[];
  puts: OptionContract[];
}

export interface StockOptionChain {
  symbol: string;
  underlyingPrice: number;
  expirations: ExpirationData[];
}

// Deterministic pseudo-random in [0, 1) based on seed
function rng(seed: number): number {
  const x = Math.sin(seed * 127.1 + 311.7) * 43758.5453;
  return x - Math.floor(x);
}

// Abramowitz & Stegun normal CDF approximation (error < 7.5e-8)
function normCdf(x: number): number {
  const t = 1 / (1 + 0.2316419 * Math.abs(x));
  const poly = t * (0.319381530 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))));
  const pdf = Math.exp(-x * x / 2) / Math.sqrt(2 * Math.PI);
  const result = 1 - pdf * poly;
  return x >= 0 ? result : 1 - result;
}

function buildCall(
  strike: number,
  S: number,
  dte: number,
  baseIV: number,
  seed: number
): OptionContract {
  const T = dte / 365;
  const mon = Math.abs((strike - S) / S);
  const iv = baseIV * (1 + mon * 0.5);
  const tv = S * (iv / 100) * Math.sqrt(T) * 0.4;
  const intrinsic = Math.max(0, S - strike);
  const prem = Math.max(intrinsic + tv * Math.exp(-mon * 4), 0.01);

  const sp = prem < 0.5 ? 0.18 : prem < 3 ? 0.08 : prem < 15 ? 0.04 : 0.02;
  const bid = Math.max(0.01, +(prem * (1 - sp)).toFixed(2));
  const ask = +(prem * (1 + sp)).toFixed(2);

  const volScale = Math.exp(-mon * 6);
  const volume = Math.max(1, Math.round(rng(seed) * 12000 * volScale));
  const openInterest = Math.max(5, Math.round(rng(seed + 1) * 65000 * volScale));
  const change = +((rng(seed + 2) * 2 - 1) * prem * 0.12).toFixed(2);

  const sigma = iv / 100;
  const d1 = T > 0 ? (Math.log(S / strike) + (0.05 + sigma * sigma / 2) * T) / (sigma * Math.sqrt(T)) : (S > strike ? Infinity : -Infinity);
  const delta = +(normCdf(d1)).toFixed(4);

  return {
    strike,
    bid,
    ask,
    last: +prem.toFixed(2),
    change,
    changePercent: +((change / Math.max(prem, 0.01)) * 100).toFixed(2),
    volume,
    openInterest,
    impliedVolatility: +iv.toFixed(1),
    delta,
    inTheMoney: S > strike,
  };
}

function buildPut(
  strike: number,
  S: number,
  dte: number,
  baseIV: number,
  seed: number
): OptionContract {
  const T = dte / 365;
  const mon = Math.abs((strike - S) / S);
  const iv = baseIV * (1 + mon * 0.65); // put skew slightly higher
  const tv = S * (iv / 100) * Math.sqrt(T) * 0.4;
  const intrinsic = Math.max(0, strike - S);
  const prem = Math.max(intrinsic + tv * Math.exp(-mon * 4), 0.01);

  const sp = prem < 0.5 ? 0.18 : prem < 3 ? 0.08 : prem < 15 ? 0.04 : 0.02;
  const bid = Math.max(0.01, +(prem * (1 - sp)).toFixed(2));
  const ask = +(prem * (1 + sp)).toFixed(2);

  const volScale = Math.exp(-mon * 6);
  const volume = Math.max(1, Math.round(rng(seed + 200) * 10000 * volScale));
  const openInterest = Math.max(5, Math.round(rng(seed + 201) * 55000 * volScale));
  const change = +((rng(seed + 202) * 2 - 1) * prem * 0.12).toFixed(2);

  const sigma = iv / 100;
  const d1 = T > 0 ? (Math.log(S / strike) + (0.05 + sigma * sigma / 2) * T) / (sigma * Math.sqrt(T)) : (S < strike ? -Infinity : Infinity);
  const delta = +(normCdf(d1) - 1).toFixed(4);

  return {
    strike,
    bid,
    ask,
    last: +prem.toFixed(2),
    change,
    changePercent: +((change / Math.max(prem, 0.01)) * 100).toFixed(2),
    volume,
    openInterest,
    impliedVolatility: +iv.toFixed(1),
    delta,
    inTheMoney: S < strike,
  };
}

interface ExpirationSpec {
  date: string;
  label: string;
  isWeekly: boolean;
  dte: number;
}

// All available expiration dates (weekly + monthly) through 12 months from 2026-06-04
const ALL_EXPIRATIONS: ExpirationSpec[] = [
  // Weekly expirations (non-monthly Fridays)
  { date: '2026-06-05', label: 'Jun 5, 2026',  isWeekly: true,  dte: 1   },
  { date: '2026-06-12', label: 'Jun 12, 2026', isWeekly: true,  dte: 8   },
  { date: '2026-06-26', label: 'Jun 26, 2026', isWeekly: true,  dte: 22  },
  { date: '2026-07-03', label: 'Jul 3, 2026',  isWeekly: true,  dte: 29  },
  { date: '2026-07-10', label: 'Jul 10, 2026', isWeekly: true,  dte: 36  },
  { date: '2026-07-24', label: 'Jul 24, 2026', isWeekly: true,  dte: 50  },
  { date: '2026-07-31', label: 'Jul 31, 2026', isWeekly: true,  dte: 57  },
  { date: '2026-08-07', label: 'Aug 7, 2026',  isWeekly: true,  dte: 64  },
  { date: '2026-08-14', label: 'Aug 14, 2026', isWeekly: true,  dte: 71  },
  { date: '2026-08-28', label: 'Aug 28, 2026', isWeekly: true,  dte: 85  },
  // Monthly expirations (3rd Friday of each month)
  { date: '2026-06-19', label: 'Jun 19, 2026', isWeekly: false, dte: 15  },
  { date: '2026-07-17', label: 'Jul 17, 2026', isWeekly: false, dte: 43  },
  { date: '2026-08-21', label: 'Aug 21, 2026', isWeekly: false, dte: 78  },
  { date: '2026-09-18', label: 'Sep 18, 2026', isWeekly: false, dte: 106 },
  { date: '2026-10-16', label: 'Oct 16, 2026', isWeekly: false, dte: 134 },
  { date: '2026-11-20', label: 'Nov 20, 2026', isWeekly: false, dte: 169 },
  { date: '2026-12-18', label: 'Dec 18, 2026', isWeekly: false, dte: 197 },
  { date: '2027-01-15', label: 'Jan 15, 2027', isWeekly: false, dte: 225 },
  { date: '2027-02-19', label: 'Feb 19, 2027', isWeekly: false, dte: 260 },
  { date: '2027-03-19', label: 'Mar 19, 2027', isWeekly: false, dte: 288 },
  { date: '2027-04-16', label: 'Apr 16, 2027', isWeekly: false, dte: 316 },
  { date: '2027-05-21', label: 'May 21, 2027', isWeekly: false, dte: 351 },
].sort((a, b) => a.dte - b.dte);

interface StockConfig {
  symbol: string;
  price: number;
  baseIV: number;
  strikeStep: number;
  strikeCount: number;
}

const STOCK_CONFIGS: StockConfig[] = [
  { symbol: 'AAPL',  price: 311.52, baseIV: 24.5, strikeStep: 5,  strikeCount: 15 },
  { symbol: 'TSLA',  price: 422.73, baseIV: 42.3, strikeStep: 10, strikeCount: 15 },
  { symbol: 'MSFT',  price: 428.05, baseIV: 27.7, strikeStep: 10, strikeCount: 15 },
  { symbol: 'GOOGL', price: 370.53, baseIV: 30.1, strikeStep: 5,  strikeCount: 15 },
  { symbol: 'AMZN',  price: 253.61, baseIV: 30.6, strikeStep: 5,  strikeCount: 15 },
];

function makeStrikes(price: number, step: number, count: number): number[] {
  const atm = Math.round(price / step) * step;
  const half = Math.floor(count / 2);
  return Array.from({ length: count }, (_, i) =>
    +(atm + (i - half) * step).toFixed(2)
  );
}

function buildChain(cfg: StockConfig): StockOptionChain {
  const { symbol, price, baseIV, strikeStep, strikeCount } = cfg;
  const strikes = makeStrikes(price, strikeStep, strikeCount);
  const symCode = symbol.charCodeAt(0) * 1000 + symbol.charCodeAt(1);

  const expirations: ExpirationData[] = ALL_EXPIRATIONS.map(exp => {
    const baseSeed = symCode + exp.dte * 100;
    return {
      date: exp.date,
      label: exp.label,
      isWeekly: exp.isWeekly,
      daysToExpiry: exp.dte,
      calls: strikes.map((k, i) =>
        buildCall(k, price, exp.dte, baseIV, baseSeed + i * 17 + k)
      ),
      puts: strikes.map((k, i) =>
        buildPut(k, price, exp.dte, baseIV, baseSeed + i * 17 + k)
      ),
    };
  });

  return { symbol, underlyingPrice: price, expirations };
}

export const SAMPLE_OPTIONS_CHAIN: Record<string, StockOptionChain> =
  Object.fromEntries(STOCK_CONFIGS.map(cfg => [cfg.symbol, buildChain(cfg)]));
