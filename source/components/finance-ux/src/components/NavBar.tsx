import { useState } from 'react';
import { AppBar, Toolbar, Typography, Button, Box, Menu, MenuItem } from '@mui/material';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import { useNavigate, useLocation } from 'react-router-dom';

const navItems = [
  { label: 'Stocks', path: '/stock-details' },
  { label: 'Accounts', path: '/accounts' },
];

const optionsSubMenu = [
  { label: 'Call Option Chain', to: '/options?type=call' },
  { label: 'Put Option Chain', to: '/options?type=put' },
  { label: 'Covered Call Strategy', to: '/covered-call-strategy' },
  { label: 'Cash Secured Put Strategy', to: '/cash-secured-put-strategy' },
];

const OPTIONS_PATHS = ['/options', '/covered-call-strategy', '/cash-secured-put-strategy'];

export default function NavBar() {
  const navigate = useNavigate();
  const location = useLocation();
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);

  const isOptionsActive = OPTIONS_PATHS.some(p => location.pathname === p);

  const handleOptionsClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => setAnchorEl(null);

  const handleSubMenuClick = (to: string) => {
    navigate(to);
    handleMenuClose();
  };

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
          <Button
            color="inherit"
            onClick={() => navigate('/stock-details')}
            sx={{
              fontWeight: location.pathname === '/stock-details' ? 'bold' : 'normal',
              borderBottom: location.pathname === '/stock-details' ? '2px solid white' : '2px solid transparent',
              borderRadius: 0,
            }}
          >
            Stocks
          </Button>

          <Button
            color="inherit"
            onClick={handleOptionsClick}
            endIcon={<KeyboardArrowDownIcon />}
            sx={{
              fontWeight: isOptionsActive ? 'bold' : 'normal',
              borderBottom: isOptionsActive ? '2px solid white' : '2px solid transparent',
              borderRadius: 0,
            }}
          >
            Options
          </Button>
          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
            anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
            transformOrigin={{ vertical: 'top', horizontal: 'left' }}
          >
            {optionsSubMenu.map((item) => (
              <MenuItem key={item.to} onClick={() => handleSubMenuClick(item.to)}>
                {item.label}
              </MenuItem>
            ))}
          </Menu>

          {navItems.slice(1).map((item) => (
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
