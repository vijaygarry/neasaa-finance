import { useState, useRef } from 'react';
import {
  Box,
  Typography,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Alert,
  CircularProgress,
} from '@mui/material';
import CloudUploadIcon from '@mui/icons-material/CloudUpload';
import { importAccountCsv } from '../services/financeApi';

interface UploadCsvDialogProps {
  open: boolean;
  onClose: () => void;
  type: 'POSITIONS' | 'TRANSACTIONS';
}

export default function UploadCsvDialog({ open, onClose, type }: UploadCsvDialogProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [dragging, setDragging] = useState(false);
  const [importing, setImporting] = useState(false);
  const [importResult, setImportResult] = useState<{ rows: number; account: string } | null>(null);
  const [importError, setImportError] = useState('');

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0] ?? null;
    if (file) { setSelectedFile(file); setImportResult(null); setImportError(''); }
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setDragging(false);
    const file = e.dataTransfer.files?.[0] ?? null;
    if (file) { setSelectedFile(file); setImportResult(null); setImportError(''); }
  };

  const handleSubmit = async () => {
    if (!selectedFile) return;
    setImporting(true);
    setImportError('');
    setImportResult(null);
    try {
      const result = await importAccountCsv(selectedFile, type);
      setImportResult({ rows: result.rowsImported, account: result.accountNumber });
    } catch {
      setImportError('Import failed. Please ensure the file is a valid Fidelity CSV export.');
    } finally {
      setImporting(false);
    }
  };

  const handleClose = () => {
    setSelectedFile(null);
    setImportResult(null);
    setImportError('');
    onClose();
  };

  return (
    <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
      <DialogTitle>Upload {type === 'POSITIONS' ? 'Positions' : 'Transactions'} CSV</DialogTitle>
      <DialogContent>
        {/* Drop Zone */}
        <Box
          onDragOver={e => { e.preventDefault(); setDragging(true); }}
          onDragLeave={() => setDragging(false)}
          onDrop={handleDrop}
          onClick={() => inputRef.current?.click()}
          sx={{
            mt: 1,
            border: '2px dashed',
            borderColor: dragging ? 'primary.main' : 'divider',
            borderRadius: 3,
            p: 5,
            mb: 2,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: 1,
            cursor: 'pointer',
            transition: 'all 0.2s ease',
            bgcolor: dragging ? 'action.hover' : 'background.default',
            '&:hover': { borderColor: 'primary.main', bgcolor: 'action.hover' },
          }}
        >
          <CloudUploadIcon sx={{ fontSize: 48, color: dragging ? 'primary.main' : 'text.secondary' }} />
          <Typography variant="body1" color="text.secondary">
            {selectedFile
              ? `Selected: ${selectedFile.name}`
              : 'Drag & drop your CSV here, or click to browse'}
          </Typography>
          <Typography variant="caption" color="text.disabled">Supported format: .csv</Typography>
        </Box>

        <input
          ref={inputRef}
          type="file"
          accept=".csv"
          style={{ display: 'none' }}
          onChange={handleFileChange}
        />

        {importResult && (
          <Alert severity="success" sx={{ mb: 2 }}>
            ✓ Imported {importResult.rows} rows for account {importResult.account}.
          </Alert>
        )}
        {importError && (
          <Alert severity="error" sx={{ mb: 2 }} onClose={() => setImportError('')}>
            {importError}
          </Alert>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={handleClose} color="inherit">Cancel</Button>
        <Button
          variant="contained"
          onClick={handleSubmit}
          disabled={!selectedFile || importing}
          startIcon={importing && <CircularProgress size={16} color="inherit" />}
        >
          {importing ? 'Importing…' : 'Upload'}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
