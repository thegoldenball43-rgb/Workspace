# Evolve Neo Studio Workspace — Engineering Research & Architectural Decisions

## 1. Verified Industry Practices Studied
- **Stripe Invoicing**: Strict finite state machine (`draft -> open/issued -> paid | void | uncollectible`). Finalized invoices are immutable — due dates and line items cannot be silently edited; corrections use Credit Notes or Void + Replacement Invoice. Overdue is a derived display badge on an open invoice rather than a destructive status overwrite.
- **Xero & Zoho Invoice**: Partial payments keep an invoice open while dynamically recalculating outstanding balance; credit notes require a unique reference number, reason, and explicit allocation against the original invoice.
- **Apple Human Interface Guidelines (HIG)**: Visual discipline anchored in Clarity, Deference, and Depth — generous whitespace, crisp typographic hierarchy, tabular numerals for financial alignment, 44px minimum touch targets on iOS/mobile, and restrained semantic indicators without decorative clutter.

## 2. How Research Was Translated Into Evolve Neo
1. **Monetary Precision**: Implemented `BigInt` scaled-integer math (`currencyPrecision` 3 digits for BHD/KWD/OMR, 2 digits for USD/EGP/SAR/AED/EUR/GBP) eliminating IEEE-754 floating-point rounding bugs.
2. **Immutable Issued Invoices & Frozen Snapshots**: Clicking *Finalize & Issue* locks the editor and stores a `frozenSnapshot` of the invoice and company profile so re-downloading an archived PDF years later produces the exact original document.
3. **Dual-Mode Standalone A4 PDF Engine (Zero `window.print()`)**:
   - **English (Default)**: Pure vector `jsPDF` with embedded high-DPI Evolve Neo logo, multi-page pagination, repeating table headers, and `Page 01 of NN` footers.
   - **Arabic (RTL)**: High-DPI offscreen editorial A4 rendering sliced cleanly into paginated A4 PDF pages so Arabic ligatures and RTL alignment render without glyph disconnection.
4. **Immutable Project Reference Codes**: Auto-incrementing `EVN-YYYY-NNNN` counter that never reuses archived or deleted codes.
5. **Encrypted Credential Vault**: Browser-native Web Crypto API (`PBKDF2` 600,000 iterations + `AES-GCM 256-bit`) — zero plaintext passwords stored.
