<style>
:root {
  --we-accent: #F43F5E;
  --we-accent-dark: #E11D48;
  --we-accent-soft: #FFF1F2;
  --we-accent-light: #FFE4E6;
  --we-navy: #0F172A;
  --we-navy-soft: #1E293B;
  --we-bg: #F8FAFC;
  --we-card: #FFFFFF;
  --we-muted: #64748B;
  --we-border: #E2E8F0;
  --we-success: #16A34A;
  --we-success-bg: #DCFCE7;
  --we-success-text: #166534;
  --we-pending: #D97706;
  --we-pending-bg: #FEF3C7;
  --we-pending-text: #92400E;
  --we-danger: #DC2626;
  --we-danger-bg: #FEE2E2;
  --we-danger-text: #991B1B;
  --we-gold: #F59E0B;
  --we-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
  --we-radius: 16px;
}
.we-status { display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 999px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; border: 1px solid transparent; }
.we-status.pending, .we-status.draft { background: var(--we-pending-bg); color: var(--we-pending-text); border-color: #FDE68A; }
.we-status.approved, .we-status.published, .we-status.registered { background: var(--we-success-bg); color: var(--we-success-text); border-color: #BBF7D0; }
.we-status.completed, .we-status.attended { background: #F1F5F9; color: #475569; border-color: #CBD5E1; }
.we-status.cancelled, .we-status.rejected { background: var(--we-danger-bg); color: var(--we-danger-text); border-color: #FECACA; }
.we-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.45); z-index: 2000; align-items: center; justify-content: center; padding: 20px; }
.we-modal-overlay.open { display: flex; }
.we-modal { background: var(--we-card); border-radius: 18px; width: 100%; max-width: 540px; max-height: 90vh; overflow: auto; box-shadow: 0 24px 64px rgba(15, 23, 42, 0.2); }
.we-modal-header { display: flex; align-items: flex-start; gap: 12px; padding: 20px 22px; border-bottom: 1px solid var(--we-border); background: var(--we-bg); }
.we-modal-header h3 { margin: 0; font-size: 17px; font-weight: 800; color: var(--we-navy); }
.we-modal-header p { margin: 4px 0 0; font-size: 13px; color: var(--we-muted); }
.we-modal-close { margin-left: auto; width: 36px; height: 36px; border-radius: 10px; border: 1px solid var(--we-border); background: #fff; color: var(--we-muted); cursor: pointer; }
.we-modal-body { padding: 18px 22px; }
.we-modal-row { display: flex; justify-content: space-between; gap: 12px; padding: 10px 0; border-bottom: 1px dashed var(--we-border); font-size: 13px; }
.we-modal-row:last-child { border-bottom: none; }
.we-modal-row .k { color: var(--we-muted); font-weight: 600; }
.we-modal-row .v { color: var(--we-navy); font-weight: 700; text-align: right; }
.we-modal-footer { padding: 16px 22px 20px; display: flex; flex-wrap: wrap; gap: 8px; border-top: 1px solid var(--we-border); background: var(--we-bg); }
.we-modal-btn { display: inline-flex; align-items: center; gap: 6px; padding: 10px 16px; border-radius: 10px; font-size: 13px; font-weight: 700; text-decoration: none; border: none; cursor: pointer; font-family: inherit; }
.we-modal-btn.primary { background: var(--we-accent); color: #fff; }
.we-modal-btn.secondary { background: #fff; color: var(--we-navy); border: 1px solid var(--we-border); }
.we-confirm-banner { background: var(--we-card); border: 1px solid #BBF7D0; border-left: 4px solid var(--we-success); border-radius: 14px; padding: 18px 20px; margin-bottom: 18px; }
.we-confirm-banner h3 { margin: 0 0 4px; font-size: 16px; color: var(--we-success-text); }
.we-confirm-banner p { margin: 0; font-size: 13px; color: var(--we-muted); }
.we-fact-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.we-fact { background: var(--we-bg); border: 1px solid var(--we-border); border-radius: 12px; padding: 14px 16px; }
.we-fact .k { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: var(--we-muted); }
.we-fact .v { font-size: 14px; font-weight: 700; color: var(--we-navy); margin-top: 4px; }
@media (max-width: 720px) { .we-fact-grid { grid-template-columns: 1fr; } }
</style>
