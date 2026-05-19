import { Box, Typography, Divider } from '@mui/material';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';

export default function Footer() {
  return (
    <Box
      component="footer"
      sx={{ mt: 'auto', backgroundColor: 'grey.900', color: 'grey.400' }}
    >
      <Divider sx={{ borderColor: 'grey.700' }} />
      <Box sx={{ py: 2, px: 4, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 1 }}>
        <TrendingUpIcon fontSize="small" />
        <Typography variant="body2">
          © {new Date().getFullYear()} Neasaa Finance. All rights reserved.
        </Typography>
      </Box>
    </Box>
  );
}
