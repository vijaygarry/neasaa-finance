import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { AccountDto, getAccountList } from '../services/financeApi';

interface AccountContextValue {
  accounts: AccountDto[];
  selectedAccountId: number | '';
  setSelectedAccountId: (id: number | '') => void;
  selectedAccount: AccountDto | null;
  accountsLoading: boolean;
}

const AccountContext = createContext<AccountContextValue>({
  accounts: [],
  selectedAccountId: '',
  setSelectedAccountId: () => {},
  selectedAccount: null,
  accountsLoading: true,
});

export function AccountProvider({ children }: { children: ReactNode }) {
  const [accounts, setAccounts] = useState<AccountDto[]>([]);
  const [selectedAccountId, setSelectedAccountId] = useState<number | ''>('');
  const [accountsLoading, setAccountsLoading] = useState(true);

  useEffect(() => {
    getAccountList()
      .then(list => {
        setAccounts(list);
        if (list.length > 0) setSelectedAccountId(list[0].accountId);
      })
      .catch(() => {})
      .finally(() => setAccountsLoading(false));
  }, []);

  const selectedAccount = accounts.find(a => a.accountId === selectedAccountId) ?? null;

  return (
    <AccountContext.Provider value={{ accounts, selectedAccountId, setSelectedAccountId, selectedAccount, accountsLoading }}>
      {children}
    </AccountContext.Provider>
  );
}

export const useAccount = () => useContext(AccountContext);
