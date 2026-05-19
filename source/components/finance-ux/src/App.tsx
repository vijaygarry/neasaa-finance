import { BrowserRouter, Routes, Route } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import HomePage from './pages/HomePage';
import StocksPage from './pages/StocksPage';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<MainLayout />}>
          <Route path="/" element={<HomePage />} />
          <Route path="/stocks" element={<StocksPage />} />
          <Route path="/options" element={<div>Options — coming soon</div>} />
          <Route path="/accounts" element={<div>Accounts — coming soon</div>} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;