import { BrowserRouter, Routes, Route } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import HomePage from './pages/HomePage';
import StockDetailsPage from './pages/StockDetailsPage';
import OptionsPage from './pages/OptionsPage';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<MainLayout />}>
          <Route path="/" element={<HomePage />} />
          <Route path="/stock-details" element={<StockDetailsPage />} />
          <Route path="/options" element={<OptionsPage />} />
          <Route path="/accounts" element={<div>Accounts — coming soon</div>} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;