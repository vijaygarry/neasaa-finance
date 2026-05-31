import { Box, Tooltip } from '@mui/material';
import InfoIcon from '@mui/icons-material/Info';

interface InfoTooltipProps {
  text: string;
}

export default function InfoTooltip({ text }: InfoTooltipProps) {
  return (
    <Tooltip title={text} arrow enterDelay={200}>
      <Box
        sx={{
          width: '18px',
          height: '18px',
          backgroundColor: 'primary.main',
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          cursor: 'pointer',
        }}
      >
        <InfoIcon sx={{ fontSize: '14px', color: 'white' }} />
      </Box>
    </Tooltip>
  );
}
