type SubMenuItem = { label: string; path: string };

export type NavItem =
  | { label: string; path: string }
  | { label: string; paths: SubMenuItem[] };

export const navItems: NavItem[] = [
  { label: 'Stocks', path: '/stock-details' },
  { label: 'Options', paths: [
    { label: 'Option Chain', path: '/options?type=call' },
    { label: 'Covered Call Strategy', path: '/covered-call-strategy' },
    { label: 'Cash Secured Put Strategy', path: '/cash-secured-put-strategy' },
  ]},
  { label: 'Accounts', path: '/accounts' },
];
