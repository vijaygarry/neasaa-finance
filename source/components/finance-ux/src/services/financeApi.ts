import apiClient from './apiClient';

// Common response wrapper — update here if backend envelope changes
type ApiResponse<T> = { operationMessage: string | null } & T;

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
