import { Box, Typography, Grid, Card, CardContent } from '@mui/material';

const summaryCards = [
  { label: 'Total Balance', value: '$0.00' },
  { label: 'Income (Month)', value: '$0.00' },
  { label: 'Expenses (Month)', value: '$0.00' },
];

export default function HomePage() {
  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" gutterBottom>
        Financial Dashboard
      </Typography>
      <Grid container spacing={3}>
        {summaryCards.map((card) => (
          <Grid size={{ xs: 12, sm: 4 }} key={card.label}>
            <Card>
              <CardContent>
                <Typography color="text.secondary">{card.label}</Typography>
                <Typography variant="h5">{card.value}</Typography>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}