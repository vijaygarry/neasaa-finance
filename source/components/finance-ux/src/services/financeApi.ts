import apiClient from './apiClient';

// Common response wrapper — update here if backend envelope changes
type ApiResponse<T> = { operationMessage: string | null } & T;

// ── Stock ─────────────────────────────────────────────────────────────────────

export interface Stock {
  symbol: string;
  name: string;
  type: string;
}

export const searchStocks = async (query: string): Promise<Stock[]> => {
  const { data } = await apiClient.post<ApiResponse<{ stockList: Stock[] }>>(
    '/api/stocks/search',
    { query }
  );
  return data.stockList ?? [];
};

// ── Accounts ──────────────────────────────────────────────────────────────────

export interface AccountDto {
  accountId: number;
  accountName: string;
  accountNumber: string;
  bankName: string;
  accountType: string | null;
  currentBalance: number | null;
}

export interface PositionDto {
  positionId: number;
  accountNumber: string;
  symbol: string;
  description: string;
  quantity: number;
  lastPrice: number | null;
  lastPriceChange: number | null;
  marketValue: number | null;
  costBasis: number | null;
  avgCostBasis: number | null;
  totalGlDollar: number | null;
  totalGlPct: number | null;
  todaysGlDollar: number | null;
  todaysGlPct: number | null;
  pctOfAccount: number | null;
  assetType: string;
}

export interface TransactionDto {
  txnId: number;
  accountNumber: string;
  runDate: string;
  action: string;
  symbol: string;
  description: string;
  securityType: string;
  quantity: number | null;
  price: number | null;
  commission: number | null;
  fees: number | null;
  accruedInterest: number | null;
  amount: number | null;
  settlementDate: string | null;
}

export const getAccountList = async (): Promise<AccountDto[]> => {
  const { data } = await apiClient.get<ApiResponse<{ accounts: AccountDto[] }>>(
    '/api/account/list'
  );
  return data.accounts ?? [];
};

export const saveAccount = async (
  accountName: string,
  accountNumber: string,
  bankName: string
): Promise<{ accountId: number }> => {
  const { data } = await apiClient.post<ApiResponse<{ accountId: number }>>(
    '/api/accounts/save',
    { accountName, accountNumber, bankName }
  );
  return { accountId: data.accountId };
};

export const importAccountCsv = async (
  file: File,
  csvType: 'POSITIONS' | 'TRANSACTIONS'
): Promise<{ rowsImported: number; accountNumber: string }> => {
  const form = new FormData();
  form.append('file', file);
  form.append('csvType', csvType);
  const { data } = await apiClient.post<ApiResponse<{ rowsImported: number; accountNumber: string }>>(
    '/api/accounts/import',
    form,
    { headers: { 'Content-Type': 'multipart/form-data' } }
  );
  return { rowsImported: data.rowsImported, accountNumber: data.accountNumber };
};

export const getAccountPositions = async (accountNumber: string): Promise<PositionDto[]> => {
  const { data } = await apiClient.post<ApiResponse<{ positions: PositionDto[] }>>(
    '/api/accounts/positions',
    { accountNumber }
  );
  return data.positions ?? [];
};

export const getAccountTransactions = async (accountNumber: string): Promise<TransactionDto[]> => {
  const { data } = await apiClient.post<ApiResponse<{ transactions: TransactionDto[] }>>(
    '/api/accounts/transactions',
    { accountNumber }
  );
  return data.transactions ?? [];
};

