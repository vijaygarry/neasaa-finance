import { Box, Chip, Typography } from '@mui/material';
import { formatDateOnly } from '../utils/dateUtils';

export interface EventMarker {
  type: 'dividend' | 'earnings';
  label: string;
  date: string; // ISO YYYY-MM-DD
}

export default function EventBanner({ event }: { event: EventMarker }) {
  const isDividend = event.type === 'dividend';
  const borderColor = isDividend ? '#2e7d32' : '#e65100';
  const bgColor = isDividend ? 'rgba(46, 125, 50, 0.07)' : 'rgba(230, 81, 0, 0.07)';
  const chipColor = isDividend ? 'success' : 'warning';

  return (
    <Box
      sx={{
        display: 'flex',
        alignItems: 'center',
        gap: 1.5,
        px: 2,
        py: 0.75,
        mb: 1,
        borderLeft: `3px solid ${borderColor}`,
        bgcolor: bgColor,
        borderRadius: '0 4px 4px 0',
      }}
    >
      <Chip
        label={isDividend ? 'Dividend' : 'Earnings'}
        size="small"
        color={chipColor as 'success' | 'warning'}
        sx={{ fontWeight: 'bold', fontSize: '0.7rem', height: 22 }}
      />
      <Typography variant="body2" sx={{ fontWeight: 600 }}>
        {event.label}
      </Typography>
      <Typography variant="body2" color="text.secondary">
        {formatDateOnly(event.date)}
      </Typography>
    </Box>
  );
}
