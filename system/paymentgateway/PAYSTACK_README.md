# Paystack Payment Gateway - Self-Configuring Plugin

**Version:** 2.0 (Auto-Install)  
**Status:** Production Ready  
**Platform:** PHPNuxBill

---

## 🚀 QUICK START (5 Minutes)

This plugin is **self-configuring** - it automatically sets up all required database configurations on first load!

### 1️⃣ Install Plugin Files

Copy these files to your PHPNuxBill installation:

```
system/paymentgateway/
  ├── paystack.php              # Main gateway logic
  ├── paystack_install.php      # Auto-installer (runs automatically)
  └── PAYSTACK_README.md        # This file

ui/ui/paymentgateway/
  └── paystack.tpl              # Admin configuration template

api/callback/
  └── paystack.ts               # Vercel callback handler
```

### 2️⃣ Automatic Configuration

**The plugin automatically:**
- ✅ Creates all required database configs in `tbl_appconfig`
- ✅ Sets up default callback URL
- ✅ Initializes gateway settings
- ✅ Validates table structure

**No manual database imports needed!**

### 3️⃣ Get Paystack API Keys

1. Visit [Paystack Dashboard](https://dashboard.paystack.com)
2. Go to **Settings** → **API Keys & Webhooks**
3. Copy your keys:
   - **Test Mode:** `pk_test_xxx` and `sk_test_xxx` (for testing)
   - **Live Mode:** `pk_live_xxx` and `sk_live_xxx` (for production)

### 4️⃣ Configure in Admin Panel

1. Login to PHPNuxBill admin
2. Go to **Settings** → **Payment Gateway** → **Paystack**
3. Enter your API keys:
   ```
   Secret Key: sk_test_5efe...6c (or sk_live_xxx for production)
   Public Key: pk_test_xxx (or pk_live_xxx)
   Callback URL: https://phpnuxbill-webhooks.vercel.app/webhook/paystack
   ```
4. Click **Save Changes**

### 5️⃣ Deploy Webhook Handler (Vercel)

```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to PHPNuxBill root
cd c:\xampp\htdocs\phpnuxbill

# Deploy to Vercel
vercel --prod

# Add environment variable
vercel env add PAYSTACK_SECRET_KEY production
# Paste your sk_test_xxx or sk_live_xxx key

# Redeploy to apply env var
vercel --prod
```

---

## 📋 WHAT GETS AUTO-CONFIGURED

When you first load `paystack.php`, the installer automatically creates:

| Config Setting | Default Value | Description |
|----------------|---------------|-------------|
| `paystack_secret_key` | Empty | Your Paystack secret key (sk_test/sk_live) |
| `paystack_public_key` | Empty | Your Paystack public key (pk_test/pk_live) |
| `paystack_webhook_url` | Empty | Webhook URL (optional) |
| `paystack_callback_url` | Vercel URL | Callback handler URL |
| `enable_paystack` | `no` | Enable/disable gateway |

**All configs are created in `tbl_appconfig` table automatically!**

---

## 🔧 MANUAL INSTALLATION (CLI)

If you want to manually trigger installation:

```bash
# Navigate to gateway directory
cd c:\xampp\htdocs\phpnuxbill\system\paymentgateway

# Run installer
php paystack_install.php
```

**Output:**
```
═══════════════════════════════════════════════════════
  PAYSTACK GATEWAY INSTALLER
═══════════════════════════════════════════════════════

Checking installation status...

Gateway Status:
  • Installed: ✗ No
  • Gateway file: ✓ Exists
  • Callback file: ✓ Exists

Configuration Status:
  • paystack_secret_key: ✗ Missing
  • paystack_public_key: ✗ Missing
  • paystack_webhook_url: ✗ Missing
  • paystack_callback_url: ✗ Missing
  • enable_paystack: ✗ Missing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Installing Paystack Gateway...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Successfully added 5 Paystack configuration(s).
  • Configs added: 5
  • Configs skipped: 0
```

---

## ✅ VERIFY INSTALLATION

### Check Database Configs

```sql
SELECT * FROM tbl_appconfig WHERE setting LIKE 'paystack%';
```

**Expected output:**
```
+----+------------------------+---------------------------------------------------+
| id | setting                | value                                             |
+----+------------------------+---------------------------------------------------+
|  1 | paystack_secret_key    |                                                   |
|  2 | paystack_public_key    |                                                   |
|  3 | paystack_webhook_url   |                                                   |
|  4 | paystack_callback_url  | https://phpnuxbill-webhooks.vercel.app/webhook... |
|  5 | enable_paystack        | no                                                |
+----+------------------------+---------------------------------------------------+
```

### Test Payment Flow

1. **Create Test Plan**
   ```sql
   INSERT INTO tbl_plans (plan_name, price, validity, validity_unit) 
   VALUES ('Test Plan', 3, 1, 'Days');
   ```

2. **Make Test Payment**
   - Login as customer
   - Select test plan
   - Choose Paystack payment method
   - Use test card: `4084084084084081` (any CVV/expiry)

3. **Verify Success Page**
   - Should redirect to: `https://phpnuxbill-webhooks.vercel.app/webhook/paystack?reference=xxx`
   - See horizontal layout with transaction details
   - Background color: `#f1f1f1`

---

## 🔍 TROUBLESHOOTING

### Issue: "Paystack Gateway: Secret Key is not set"

**Cause:** Config not loaded or empty

**Fix:**
```bash
# Check if configs exist
php paystack_install.php

# Or manually in admin panel
Settings > Payment Gateway > Paystack > Enter secret key
```

### Issue: 404 Error on Callback URL

**Cause:** Vercel deployment not configured or environment variable missing

**Fix:**
```bash
# Check Vercel deployment
vercel list

# Add environment variable
vercel env add PAYSTACK_SECRET_KEY production

# Redeploy
vercel --prod
```

### Issue: "Could not verify transaction"

**Cause:** Missing `PAYSTACK_SECRET_KEY` in Vercel environment

**Fix:**
```bash
# List current env vars
vercel env ls

# Add if missing
vercel env add PAYSTACK_SECRET_KEY production
# Paste: sk_test_5efe... or sk_live_xxx

# Redeploy
vercel --prod
```

### Issue: Auto-installer didn't run

**Cause:** PHP error or permissions issue

**Fix:**
1. Check PHP error log
2. Manually run installer: `php paystack_install.php`
3. Verify file permissions (read/write on `system/paymentgateway/`)

---

## 🗂️ FILE STRUCTURE

```
phpnuxbill/
├── system/
│   └── paymentgateway/
│       ├── paystack.php              # Main gateway (auto-loads installer)
│       ├── paystack_install.php      # Auto-configuration script
│       └── PAYSTACK_README.md        # This documentation
│
├── ui/ui/paymentgateway/
│   └── paystack.tpl                  # Admin settings template
│
├── api/callback/
│   └── paystack.ts                   # Vercel callback handler
│
├── vercel.json                       # Vercel deployment config
├── package.json                      # Node dependencies (@vercel/node)
└── tsconfig.json                     # TypeScript configuration
```

---

## 🔐 SECURITY BEST PRACTICES

### ✅ DO:
- Store secret keys in `tbl_appconfig` (never hardcode)
- Use environment variables in Vercel (`PAYSTACK_SECRET_KEY`)
- Test with test keys (`sk_test_xxx`) before going live
- Enable HTTPS for callback URLs
- Verify transaction signatures from Paystack

### ❌ DON'T:
- Commit `.env` files with secret keys
- Share secret keys in public repositories
- Use production keys in development
- Hardcode API keys in code
- Skip transaction verification

---

## 📊 CONFIGURATION OPTIONS

### Database Configs (tbl_appconfig)

| Setting | Type | Required | Example |
|---------|------|----------|---------|
| `paystack_secret_key` | string | Yes | `sk_test_5efe...6c` |
| `paystack_public_key` | string | Yes | `pk_test_xxx` |
| `paystack_callback_url` | string | Yes | `https://phpnuxbill-webhooks.vercel.app/webhook/paystack` |
| `paystack_webhook_url` | string | No | For webhook notifications |
| `enable_paystack` | yes/no | Yes | `yes` to activate |

### Vercel Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `PAYSTACK_SECRET_KEY` | Yes | Your Paystack secret key |

---

## 🚢 DEPLOYMENT CHECKLIST

- [ ] Copy all plugin files to PHPNuxBill
- [ ] Verify auto-installation (check `tbl_appconfig`)
- [ ] Get Paystack API keys (test or live)
- [ ] Configure keys in admin panel
- [ ] Deploy callback to Vercel
- [ ] Add `PAYSTACK_SECRET_KEY` to Vercel environment
- [ ] Test with low-value transaction (e.g., 3 KES)
- [ ] Verify success page displays correctly
- [ ] Check transaction in Paystack dashboard
- [ ] Switch to live keys for production

---

## 📞 SUPPORT

**Installation Issues:**
- Run manual installer: `php system/paymentgateway/paystack_install.php`
- Check logs: `bugs/errors.txt`
- Verify database connection in `config.php`

**Payment Issues:**
- Check Paystack dashboard: https://dashboard.paystack.com
- Verify API keys are correct (test vs live)
- Check Vercel logs: `vercel logs phpnuxbill-webhooks`

**Callback Issues:**
- Test URL directly: `https://phpnuxbill-webhooks.vercel.app/webhook/paystack?reference=test`
- Check environment variables: `vercel env ls`
- Verify `PAYSTACK_SECRET_KEY` is set in Vercel

---

## 📝 CHANGELOG

### Version 2.0 (2024-02-14)
- ✨ Added auto-configuration installer
- ✨ Self-dependent plugin (no manual DB setup)
- ✨ CLI installation utility
- ✨ Status checking and validation
- 🐛 Fixed undefined variable warnings
- 🎨 Simplified success page UI (horizontal layout)
- 📚 Comprehensive documentation

### Version 1.0 (2024-02-13)
- Initial Paystack integration
- Vercel callback handler
- Admin configuration panel

---

## 📄 LICENSE

Part of PHPNuxBill - See LICENSE file in root directory

---

**Made with ❤️ for PHPNuxBill**

*No more manual database imports. Just copy, paste, and go!* 🚀
