import { BrowserRouter, Routes, Route } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import HomePage from './pages/HomePage';
import StockDetailsPage from './pages/StockDetailsPage';
import OptionsPage from './pages/OptionsPage';
import CoveredCallStrategyPage from './pages/CoveredCallStrategyPage';
import CashSecuredPutStrategyPage from './pages/CashSecuredPutStrategyPage';
import AccountsImportPage from './pages/AccountsImportPage';
import AccountPositionPage from './pages/AccountPositionPage';
import AccountTransactionsPage from './pages/AccountTransactionsPage';
import { AccountProvider } from './context/AccountContext';

function App() {
  return (
    <AccountProvider>
      <BrowserRouter>
        <Routes>
          <Route element={<MainLayout />}>
            <Route path="/" element={<HomePage />} />
            <Route path="/stock-details" element={<StockDetailsPage />} />
            <Route path="/options" element={<OptionsPage />} />
            <Route path="/covered-call-strategy" element={<CoveredCallStrategyPage />} />
            <Route path="/cash-secured-put-strategy" element={<CashSecuredPutStrategyPage />} />
            <Route path="/accounts" element={<AccountsImportPage />} />
            <Route path="/accounts/position" element={<AccountPositionPage />} />
            <Route path="/accounts/transactions" element={<AccountTransactionsPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </AccountProvider>
  );
}

export default App;