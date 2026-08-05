import React from 'react';
import ReactDOM from 'react-dom/client';
import { ThemeProvider, createTheme, CssBaseline } from '@mui/material';
import './index.css';
import App from './App';

const SF_PRO_FONT = "'SF Pro Display', 'SF Pro Text', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', 'Segoe UI', 'Roboto', sans-serif";

// ── Liquid Glass tokens ──
const GLASS_BG = 'rgba(255, 255, 255, 0.45)';
const GLASS_BORDER = '1px solid rgba(255, 255, 255, 0.55)';
const GLASS_BLUR = 'blur(18px) saturate(1.6)';
const GLASS_SHADOW = '0 4px 24px rgba(0, 0, 0, 0.06), inset 0 1px 0 rgba(255, 255, 255, 0.6)';
const GLASS_RADIUS = 8;

const theme = createTheme({
  typography: {
    fontFamily: SF_PRO_FONT,
  },
  shape: {
    borderRadius: GLASS_RADIUS,
  },
  components: {
    // ── Paper (cards, containers, dialogs) ──
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundColor: GLASS_BG,
          backdropFilter: GLASS_BLUR,
          WebkitBackdropFilter: GLASS_BLUR,
          border: GLASS_BORDER,
          boxShadow: GLASS_SHADOW,
        },
      },
    },
    // ── Buttons ──
    MuiButton: {
      styleOverrides: {
        contained: {
          backgroundColor: 'rgba(25, 118, 210, 0.75)',
          backdropFilter: 'blur(12px) saturate(1.4)',
          WebkitBackdropFilter: 'blur(12px) saturate(1.4)',
          border: '1px solid rgba(255, 255, 255, 0.35)',
          boxShadow: '0 2px 12px rgba(25, 118, 210, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.3)',
          '&:hover': {
            backgroundColor: 'rgba(25, 118, 210, 0.88)',
            boxShadow: '0 4px 20px rgba(25, 118, 210, 0.35), inset 0 1px 0 rgba(255, 255, 255, 0.3)',
          },
        },
        outlined: {
          backgroundColor: 'rgba(255, 255, 255, 0.3)',
          backdropFilter: 'blur(10px)',
          WebkitBackdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.5)',
          boxShadow: GLASS_SHADOW,
          '&:hover': {
            backgroundColor: 'rgba(255, 255, 255, 0.45)',
          },
        },
      },
    },
    // ── Dialog ──
    MuiDialog: {
      styleOverrides: {
        paper: {
          backgroundColor: 'rgba(255, 255, 255, 0.65)',
          backdropFilter: 'blur(24px) saturate(1.8)',
          WebkitBackdropFilter: 'blur(24px) saturate(1.8)',
          border: GLASS_BORDER,
          boxShadow: '0 8px 40px rgba(0, 0, 0, 0.12), inset 0 1px 0 rgba(255, 255, 255, 0.6)',
        },
      },
    },
    // ── Chip ──
    MuiChip: {
      styleOverrides: {
        root: {
          backgroundColor: 'rgba(255, 255, 255, 0.4)',
          backdropFilter: 'blur(10px)',
          WebkitBackdropFilter: 'blur(10px)',
          border: '1px solid rgba(255, 255, 255, 0.5)',
        },
      },
    },
    // ── AppBar / NavBar ──
    MuiAppBar: {
      styleOverrides: {
        root: {
          backgroundColor: 'rgba(255, 255, 255, 0.5)',
          backdropFilter: 'blur(20px) saturate(1.6)',
          WebkitBackdropFilter: 'blur(20px) saturate(1.6)',
          border: 'none',
          borderBottom: '1px solid rgba(255, 255, 255, 0.45)',
          boxShadow: '0 2px 16px rgba(0, 0, 0, 0.06)',
          color: 'rgba(0, 0, 0, 0.85)',
        },
      },
    },
    // ── TextField ──
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          backgroundColor: 'rgba(255, 255, 255, 0.35)',
          backdropFilter: 'blur(8px)',
          WebkitBackdropFilter: 'blur(8px)',
          borderRadius: GLASS_RADIUS,
          '& .MuiOutlinedInput-notchedOutline': {
            borderColor: 'rgba(255, 255, 255, 0.5)',
          },
          '&:hover .MuiOutlinedInput-notchedOutline': {
            borderColor: 'rgba(255, 255, 255, 0.7)',
          },
        },
      },
    },
    // ── Tabs ──
    MuiTabs: {
      styleOverrides: {
        root: {
          backgroundColor: 'rgba(255, 255, 255, 0.3)',
          backdropFilter: 'blur(10px)',
          WebkitBackdropFilter: 'blur(10px)',
          borderRadius: GLASS_RADIUS,
          padding: 4,
        },
      },
    },
    // ── TableContainer ──
    MuiTableContainer: {
      styleOverrides: {
        root: {
          backgroundColor: 'rgba(255, 255, 255, 0.4)',
          backdropFilter: GLASS_BLUR,
          WebkitBackdropFilter: GLASS_BLUR,
          border: GLASS_BORDER,
          boxShadow: GLASS_SHADOW,
        },
      },
    },
  },
});

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <App />
    </ThemeProvider>
  </React.StrictMode>
);
