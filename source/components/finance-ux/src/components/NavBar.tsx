import { useState } from 'react';
import { AppBar, Toolbar, Typography, Button, Box, Menu, MenuItem } from '@mui/material';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import { useNavigate, useLocation } from 'react-router-dom';
import { navItems, NavItem } from './navMenuConfig';

export default function NavBar() {
  const navigate = useNavigate();
  const location = useLocation();
  const [openMenu, setOpenMenu] = useState<{ label: string; anchor: HTMLElement } | null>(null);

  const handleOpen = (label: string, event: React.MouseEvent<HTMLButtonElement>) => {
    setOpenMenu({ label, anchor: event.currentTarget });
  };

  const handleClose = () => setOpenMenu(null);

  const handleSubNav = (path: string) => {
    navigate(path);
    handleClose();
  };

  const isActive = (item: NavItem) => {
    if ('paths' in item) return item.paths.some(p => location.pathname === p.path.split('?')[0]);
    return location.pathname === item.path;
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
          {navItems.map((item) => {
            const active = isActive(item);
            const buttonSx = {
              fontWeight: active ? 'bold' : 'normal',
              borderBottom: active ? '2px solid white' : '2px solid transparent',
              borderRadius: 0,
            };

            if ('paths' in item) {
              return (
                <span key={item.label}>
                  <Button
                    color="inherit"
                    onClick={(e) => handleOpen(item.label, e)}
                    endIcon={<KeyboardArrowDownIcon />}
                    sx={buttonSx}
                  >
                    {item.label}
                  </Button>
                  <Menu
                    anchorEl={openMenu?.label === item.label ? openMenu.anchor : null}
                    open={openMenu?.label === item.label}
                    onClose={handleClose}
                    anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
                    transformOrigin={{ vertical: 'top', horizontal: 'left' }}
                    slotProps={{
                      paper: {
                        sx: {
                          bgcolor: 'primary.main',
                          color: 'white',
                          mt: 0.5,
                          minWidth: 200,
                        },
                      },
                    }}
                  >
                    {item.paths.map((sub) => (
                      <MenuItem
                        key={sub.path}
                        onClick={() => handleSubNav(sub.path)}
                        sx={{
                          fontSize: '0.875rem',
                          fontWeight: 500,
                          letterSpacing: '0.02857em',
                          fontFamily: 'inherit',
                          textTransform: 'uppercase',
                          '&:hover': { bgcolor: 'primary.dark' },
                        }}
                      >
                        {sub.label}
                      </MenuItem>
                    ))}
                  </Menu>
                </span>
              );
            }

            return (
              <Button
                key={item.path}
                color="inherit"
                onClick={() => navigate(item.path)}
                sx={buttonSx}
              >
                {item.label}
              </Button>
            );
          })}
        </Box>
      </Toolbar>
    </AppBar>
  );
}
