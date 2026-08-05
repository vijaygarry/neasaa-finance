import { Box } from '@mui/material';
import { Outlet } from 'react-router-dom';
import NavBar from '../components/NavBar';
import Footer from '../components/Footer';

export default function MainLayout() {
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        minHeight: '100vh',
        background: 'linear-gradient(180deg, #a8d4e6 0%, #d4e4ed 18%, #e8ddd4 40%, #e6cdb8 60%, #e8c8c0 75%, #deb8c4 90%, #d4afc0 100%)',
      }}
    >
      <NavBar />
      <Box component="main" sx={{ flexGrow: 1, p: 3 }}>
        <Outlet />
      </Box>
      <Footer />
    </Box>
  );
}
