import { OptionContract, ExpirationData, StockOptionChain, SAMPLE_OPTIONS_CHAIN } from './sampleOptionsChain';

export interface CoveredCallContract extends OptionContract {
  avgVolume: number;
}

export interface CoveredCallExpiration extends Omit<ExpirationData, 'calls' | 'puts'> {
  calls: CoveredCallContract[];
  puts: CoveredCallContract[];
}

export interface CoveredCallChain extends Omit<StockOptionChain, 'expirations'> {
  expirations: CoveredCallExpiration[];
}

// Deterministic avgVolume derived from contract identifiers — no external rng needed
function computeAvgVolume(strike: number, dte: number, openInterest: number): number {
  const hash = ((strike * 7 + dte * 13) % 1000) / 1000; // 0..1
  return Math.max(1, Math.round(openInterest * (0.04 + hash * 0.10)));
}

function extendContract(c: OptionContract, dte: number): CoveredCallContract {
  return { ...c, avgVolume: computeAvgVolume(c.strike, dte, c.openInterest) };
}

export const COVERED_CALL_CHAIN: Record<string, CoveredCallChain> = Object.fromEntries(
  Object.entries(SAMPLE_OPTIONS_CHAIN).map(([symbol, chain]) => [
    symbol,
    {
      ...chain,
      expirations: chain.expirations.map(exp => ({
        ...exp,
        calls: exp.calls.map(c => extendContract(c, exp.daysToExpiry)),
        puts:  exp.puts.map(c  => extendContract(c, exp.daysToExpiry)),
      })),
    },
  ])
);
