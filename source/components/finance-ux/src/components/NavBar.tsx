import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { useNavigate, useLocation } from 'react-router-dom';

const navItems = [
  { label: 'Stocks', path: '/stocks' },
  { label: 'Options', path: '/options' },
  { label: 'Accounts', path: '/accounts' },
];

export default function NavBar() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <AppBar position="static">
      <Toolbar>
        <Box
          component="img"
          src="/logo_icon.jpg"
          alt="Neasaa Finance"
          onClick={() => navigate('/')}
          sx={{ height: 40, width: 40, borderRadius: 1, mr: 1, cursor: 'pointer' }}
        />
        <Typography
          variant="h6"
          sx={{ mr: 4, cursor: 'pointer', fontWeight: 'bold' }}
          onClick={() => navigate('/')}
        >
          Neasaa Finance
        </Typography>
        <Box sx={{ display: 'flex', gap: 1 }}>
          {navItems.map((item) => (
            <Button
              key={item.path}
              color="inherit"
              onClick={() => navigate(item.path)}
              sx={{
                fontWeight: location.pathname === item.path ? 'bold' : 'normal',
                borderBottom: location.pathname === item.path ? '2px solid white' : '2px solid transparent',
                borderRadius: 0,
              }}
            >
              {item.label}
            </Button>
          ))}
        </Box>
      </Toolbar>
    </AppBar>
  );
}
