const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

export function formatDateOnly(dateStr: string): string {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, '0');
  const mmm = MONTHS[d.getMonth()];
  const yyyy = d.getFullYear();
  return `${dd}-${mmm}-${yyyy}`;
}

// Formats a YYYY-MM-DD date string using local timezone (avoids UTC-midnight shift).
// new Date('YYYY-MM-DD') is parsed as UTC midnight; toLocaleDateString applies local offset.
export function formatExpiryLabel(dateStr: string): string {
  if (!dateStr) return '';
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short', day: 'numeric', year: 'numeric',
  });
}

export function formatDateTime(dateStr: string): string {
  const d = new Date(dateStr);
  const dd = String(d.getDate()).padStart(2, '0');
  const mmm = MONTHS[d.getMonth()];
  const yyyy = d.getFullYear();
  const hh = String(d.getHours()).padStart(2, '0');
  const min = String(d.getMinutes()).padStart(2, '0');
  const ss = String(d.getSeconds()).padStart(2, '0');
  return `${dd}-${mmm}-${yyyy} ${hh}:${min}:${ss}`;
}

export const PERIODS = ['3M', '6M', '9M', '12M'] as const;
export type Period = typeof PERIODS[number];

export const PERIOD_DAYS: Record<Period, number> = {
  '3M': 92,
  '6M': 183,
  '9M': 274,
  '12M': 366,
};
