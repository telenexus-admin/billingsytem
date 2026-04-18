{include file="sections/header.tpl"}

<style>
    /* Orange Theme Styles for Notification Settings */
    :root {
        --orange-primary: #fd7e14;
        --orange-light: #ffa94d;
        --orange-lighter: #ffd8a8;
        --orange-lightest: #fff4e6;
        --orange-dark: #e8590c;
        --orange-darker: #d9480f;
        --orange-gradient: linear-gradient(135deg, #fd7e14 0%, #e8590c 100%);
        --gray-50: #f8f9fa;
        --gray-100: #f1f3f5;
        --gray-200: #e9ecef;
        --gray-300: #dee2e6;
        --gray-400: #ced4da;
        --gray-500: #adb5bd;
        --gray-600: #868e96;
        --gray-700: #495057;
        --gray-800: #343a40;
        --gray-900: #212529;
        --success-color: #40c057;
        --success-light: #d3f9d8;
        --danger-color: #fa5252;
        --danger-light: #ffe3e3;
        --warning-color: #fab005;
        --warning-light: #fff3bf;
        --info-color: #228be6;
        --info-light: #d0ebff;
        --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
        --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        --radius-sm: 0.375rem;
        --radius: 0.5rem;
        --radius-md: 0.75rem;
        --radius-lg: 1rem;
    }

    /* Global Reset */
    body {
        background: linear-gradient(135deg, var(--orange-lightest) 0%, #fff4e6 100%);
        font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
        line-height: 1.5;
        color: var(--gray-800);
        min-height: 100vh;
    }

    .content-wrapper, .content {
        background: transparent !important;
        padding: 2rem !important;
    }

    /* Container */
    .form-container {
        max-width: 1400px;
        margin: 0 auto;
    }

    /* Header */
    .page-header {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--orange-lighter);
    }

    .page-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--orange-darker);
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 0.5rem;
        text-shadow: 0 1px 2px rgba(0,0,0,0.1);
    }

    .page-title i {
        color: var(--orange-primary);
        font-size: 1.75rem;
        background: var(--orange-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .page-subtitle {
        color: var(--gray-600);
        font-size: 1rem;
        font-weight: 400;
        padding-left: 2.5rem;
    }

    /* Modern Panel Design with Orange Theme */
    .orange-panel {
        background: white;
        border-radius: var(--radius-md);
        border: 1px solid var(--orange-lighter);
        box-shadow: var(--shadow);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        overflow: hidden;
        margin-bottom: 2rem;
    }

    .orange-panel:hover {
        box-shadow: var(--shadow-lg);
        border-color: var(--orange-light);
        transform: translateY(-2px);
    }

    .orange-panel.panel-primary {
        border-top: 3px solid var(--orange-primary);
    }

    /* Panel Header with Orange Gradient */
    .panel-header {
        background: var(--orange-gradient);
        padding: 1.25rem 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.75rem;
    }

    .panel-header i {
        color: white;
        font-size: 1.25rem;
        text-shadow: 0 1px 2px rgba(0,0,0,0.2);
    }

    .panel-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: white;
        margin: 0;
        letter-spacing: -0.025em;
        text-shadow: 0 1px 2px rgba(0,0,0,0.2);
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .panel-actions {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    /* Panel Body */
    .panel-body {
        padding: 1.5rem;
        background: white;
    }

    /* Panel Body Section */
    .panel-section {
        margin-bottom: 2rem;
        padding: 1.5rem;
        border-radius: var(--radius);
        background: var(--gray-50);
        border-left: 4px solid var(--orange-primary);
        transition: all 0.3s ease;
    }

    .panel-section:hover {
        background: var(--orange-lightest);
        transform: translateX(5px);
    }

    .panel-section:last-child {
        margin-bottom: 0;
    }

    /* Modern Form Group */
    .form-group-modern {
        margin-bottom: 1.5rem;
        position: relative;
    }

    .form-group-modern:last-child {
        margin-bottom: 0;
    }

    /* Form Labels */
    .control-label-modern {
        display: block;
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--orange-darker);
        margin-bottom: 0.75rem;
        letter-spacing: -0.025em;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .control-label-modern i {
        color: var(--orange-primary);
        font-size: 0.875rem;
    }

    .control-label-modern .required {
        color: var(--danger-color);
        margin-left: 0.25rem;
    }

    /* Textarea Controls */
    .textarea-modern {
        width: 100%;
        padding: 1rem;
        font-size: 0.9375rem;
        line-height: 1.6;
        color: var(--gray-900);
        background-color: white;
        border: 1px solid var(--orange-lighter);
        border-radius: var(--radius-sm);
        transition: all 0.2s ease;
        font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
        resize: vertical;
        min-height: 120px;
    }

    .textarea-modern:focus {
        outline: none;
        border-color: var(--orange-primary);
        box-shadow: 0 0 0 3px rgba(253, 126, 20, 0.15);
        background: var(--orange-lightest);
    }

    .textarea-modern:hover:not(:focus):not(:disabled) {
        border-color: var(--orange-light);
        background-color: var(--orange-lightest);
    }

    .textarea-modern::placeholder {
        color: var(--gray-400);
        font-style: italic;
    }

    .textarea-modern.small {
        min-height: 80px;
    }

    .textarea-modern.large {
        min-height: 200px;
    }

    /* Helper Block */
    .help-block-modern {
        margin-top: 0.75rem;
        font-size: 0.8125rem;
        line-height: 1.5;
        color: var(--gray-600);
        background: white;
        padding: 1rem;
        border-radius: var(--radius-sm);
        border: 1px solid var(--gray-200);
        border-left: 3px solid var(--orange-primary);
    }

    .help-block-modern b {
        color: var(--orange-dark);
        font-weight: 600;
        display: inline-block;
        margin-right: 0.25rem;
        font-family: monospace;
        background: var(--orange-lightest);
        padding: 0.125rem 0.375rem;
        border-radius: 3px;
        font-size: 0.75rem;
    }

    /* Two Column Layout for Textarea + Help Block */
    .two-column-layout {
        display: flex;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .textarea-column {
        flex: 1;
    }

    .help-column {
        width: 400px;
        flex-shrink: 0;
    }

    /* Orange Gradient Button */
    .btn-orange {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 0.875rem 2.5rem;
        font-size: 1rem;
        font-weight: 600;
        line-height: 1.5;
        color: white;
        background: var(--orange-gradient);
        border: none;
        border-radius: var(--radius);
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
        min-width: 220px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        box-shadow: 0 4px 12px rgba(253, 126, 20, 0.2);
    }

    .btn-orange:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(253, 126, 20, 0.3);
        background: linear-gradient(135deg, #e8590c 0%, #fd7e14 100%);
    }

    .btn-orange:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px rgba(253, 126, 20, 0.2);
    }

    .btn-orange i {
        font-size: 1.125rem;
    }

    .btn-orange.btn-sm {
        padding: 0.5rem 1.5rem;
        font-size: 0.875rem;
        min-width: auto;
    }

    /* Save Action */
    .save-action {
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid var(--orange-lighter);
        text-align: center;
    }

    /* Notification Type Badges */
    .notification-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.375rem;
        padding: 0.375rem 0.875rem;
        font-size: 0.75rem;
        font-weight: 600;
        border-radius: 9999px;
        text-transform: uppercase;
        margin-left: 1rem;
        background: var(--orange-gradient);
        color: white;
        box-shadow: 0 2px 4px rgba(253, 126, 20, 0.2);
    }

    /* Preview Button */
    .preview-btn {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        font-size: 0.8125rem;
        font-weight: 500;
        color: var(--orange-dark);
        background: var(--orange-lightest);
        border: 1px solid var(--orange-lighter);
        border-radius: var(--radius-sm);
        cursor: pointer;
        transition: all 0.2s ease;
        margin-left: 1rem;
    }

    .preview-btn:hover {
        background: var(--orange-lighter);
        color: var(--orange-darker);
        transform: translateY(-1px);
    }

    /* Character Counter */
    .char-counter {
        position: absolute;
        right: 1rem;
        bottom: 1rem;
        font-size: 0.75rem;
        color: var(--gray-500);
        background: rgba(255, 255, 255, 0.9);
        padding: 0.125rem 0.5rem;
        border-radius: 10px;
        pointer-events: none;
    }

    /* Responsive Design */
    @media (max-width: 1200px) {
        .two-column-layout {
            flex-direction: column;
            gap: 1rem;
        }
        
        .help-column {
            width: 100%;
        }
    }

    @media (max-width: 992px) {
        .content-wrapper, .content {
            padding: 1.5rem !important;
        }
        
        .page-title {
            font-size: 1.75rem;
        }
        
        .panel-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }
        
        .panel-actions {
            width: 100%;
            justify-content: flex-start;
        }
    }

    @media (max-width: 768px) {
        .content-wrapper, .content {
            padding: 1rem !important;
        }
        
        .page-header {
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
        }
        
        .page-title {
            font-size: 1.5rem;
        }
        
        .panel-header {
            padding: 1rem;
        }
        
        .panel-body, .panel-section {
            padding: 1rem;
        }
        
        .btn-orange {
            width: 100%;
            min-width: auto;
        }
    }

    @media (max-width: 576px) {
        .row {
            margin-left: -0.5rem;
            margin-right: -0.5rem;
        }
        
        .col-sm-12, .col-md-12 {
            padding-left: 0.5rem;
            padding-right: 0.5rem;
        }
        
        .panel-title {
            font-size: 1.125rem;
        }
        
        .notification-badge, .preview-btn {
            margin-left: 0.5rem;
            margin-top: 0.5rem;
        }
    }

    /* Animations */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .orange-panel {
        animation: fadeInUp 0.4s ease-out;
    }

    @keyframes highlight {
        0%, 100% {
            background-color: transparent;
        }
        50% {
            background-color: var(--orange-lightest);
        }
    }

    .highlight-section {
        animation: highlight 2s ease;
    }

    /* Custom Scrollbar */
    ::-webkit-scrollbar {
        width: 10px;
        height: 10px;
    }

    ::-webkit-scrollbar-track {
        background: var(--orange-lightest);
        border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb {
        background: var(--orange-gradient);
        border-radius: 4px;
        transition: background 0.3s ease;
    }

    ::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, #e8590c 0%, #fd7e14 100%);
    }

    /* Tab Navigation */
    .notification-tabs {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        margin-bottom: 2rem;
        padding: 1rem;
        background: white;
        border-radius: var(--radius);
        border: 1px solid var(--orange-lighter);
        box-shadow: var(--shadow-sm);
    }

    .notification-tab {
        padding: 0.75rem 1.5rem;
        font-size: 0.875rem;
        font-weight: 500;
        color: var(--gray-700);
        background: var(--gray-100);
        border: 1px solid var(--gray-300);
        border-radius: var(--radius-sm);
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .notification-tab:hover {
        background: var(--orange-lightest);
        color: var(--orange-dark);
        border-color: var(--orange-light);
        transform: translateY(-2px);
    }

    .notification-tab.active {
        background: var(--orange-gradient);
        color: white;
        border-color: var(--orange-primary);
        box-shadow: 0 2px 8px rgba(253, 126, 20, 0.2);
    }

    .notification-tab i {
        font-size: 1rem;
    }

    /* Template Variables Display */
    .template-variables {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 0.75rem;
        margin-top: 1rem;
        padding: 1rem;
        background: var(--orange-lightest);
        border-radius: var(--radius-sm);
        border: 1px solid var(--orange-lighter);
    }

    .template-variable {
        font-family: monospace;
        font-size: 0.8125rem;
        padding: 0.5rem;
        background: white;
        border-radius: 4px;
        border: 1px solid var(--gray-200);
        color: var(--orange-dark);
        display: flex;
        align-items: center;
        gap: 0.5rem;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .template-variable:hover {
        background: var(--orange-lighter);
        transform: translateX(5px);
    }

    .template-variable i {
        color: var(--orange-primary);
        font-size: 0.75rem;
    }

    /* Form Actions */
    .form-actions {
        position: sticky;
        bottom: 2rem;
        background: white;
        padding: 1.5rem;
        border-radius: var(--radius-md);
        border: 1px solid var(--orange-lighter);
        box-shadow: var(--shadow-lg);
        margin-top: 2rem;
        text-align: center;
        border-top: 3px solid var(--orange-primary);
        z-index: 100;
    }
</style>

<!-- Notification Settings Form with Orange Theme -->
<div class="form-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-bell"></i> {Lang::T('Notification Settings')}
        </h1>
        <p class="page-subtitle">{Lang::T('Configure automated messages for customer notifications and reminders')}</p>
    </div>

    <!-- Notification Tabs -->
    <div class="notification-tabs">
        <a href="#expired" class="notification-tab active">
            <i class="fas fa-calendar-times"></i> {Lang::T('Expired')}
        </a>
        <a href="#reminders" class="notification-tab">
            <i class="fas fa-clock"></i> {Lang::T('Reminders')}
        </a>
        <a href="#invoices" class="notification-tab">
            <i class="fas fa-file-invoice"></i> {Lang::T('Invoices')}
        </a>
        <a href="#welcome" class="notification-tab">
            <i class="fas fa-user-plus"></i> {Lang::T('Welcome')}
        </a>
        {if $_c['enable_balance'] == 'yes'}
        <a href="#balance" class="notification-tab">
            <i class="fas fa-money-bill-wave"></i> {Lang::T('Balance')}
        </a>
        {/if}
    </div>

    <form class="form-horizontal" method="post" role="form" action="{Text::url('settings/notifications-post')}">
        <input type="hidden" name="csrf_token" value="{$csrf_token}">
        
        <div class="orange-panel panel-primary">
            <div class="panel-header">
                <div class="panel-title">
                    <i class="fas fa-bell"></i> {Lang::T('User Notification Templates')}
                    <span class="notification-badge">{$total_notifications} Templates</span>
                </div>
                <div class="panel-actions">
                    <button class="btn-orange btn-sm" title="{Lang::T('Save All Changes')}" type="submit">
                        <i class="fas fa-save"></i> {Lang::T('Save All')}
                    </button>
                </div>
            </div>

            <div class="panel-body">
                <!-- Expired Notification Section -->
                <div class="panel-section" id="expired-section">
                    <div class="control-label-modern">
                        <i class="fas fa-calendar-times"></i> {Lang::T('Expired Notification Message')}
                        <span class="preview-btn" onclick="previewTemplate('expired')">
                            <i class="fas fa-eye"></i> {Lang::T('Preview')}
                        </span>
                    </div>
                    
                    <div class="two-column-layout">
                        <div class="textarea-column">
                            <textarea class="textarea-modern small" id="expired" name="expired" 
                                      placeholder="{Lang::T('Hello')} [[name]], {Lang::T('your internet package')} [[package]] {Lang::T('has been expired')}"
                                      rows="4" oninput="updateCounter(this)">{if $_json['expired']!=''}{Lang::htmlspecialchars($_json['expired'])}{else}{Lang::T('Hello')} [[name]], {Lang::T('your internet package')} [[package]] {Lang::T('has been expired')}.{/if}</textarea>
                            <div class="char-counter" id="expired-counter">0 characters</div>
                        </div>
                        
                        <div class="help-column">
                            <div class="help-block-modern">
                                <b>[[name]]</b> - {Lang::T('will be replaced with Customer Name')}.<br>
                                <b>[[username]]</b> - {Lang::T('will be replaced with Customer username')}.<br>
                                <b>[[package]]</b> - {Lang::T('will be replaced with Package name')}.<br>
                                <b>[[price]]</b> - {Lang::T('will be replaced with Package price')}.<br>
                                <b>[[bills]]</b> - {Lang::T('additional bills for customers')}.<br>
                                <b>[[payment_link]]</b> - {Lang::T('payment link for customers')}.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Reminders Section -->
                <div class="panel-section" id="reminders-section">
                    <h4 class="control-label-modern" style="font-size: 1rem; color: var(--orange-primary); margin-bottom: 1.5rem;">
                        <i class="fas fa-clock"></i> {Lang::T('Package Expiration Reminders')}
                    </h4>

                    <!-- 7 Days Reminder -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-calendar-day"></i> {Lang::T('Reminder 7 days before expiry')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern small" id="reminder_7_day" name="reminder_7_day"
                                          rows="4" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['reminder_7_day'])}</textarea>
                                <div class="char-counter" id="reminder_7_day-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[name]]</b> - {Lang::T('will be replaced with Customer Name')}.<br>
                                    <b>[[username]]</b> - {Lang::T('will be replaced with Customer username')}.<br>
                                    <b>[[package]]</b> - {Lang::T('will be replaced with Package name')}.<br>
                                    <b>[[price]]</b> - {Lang::T('will be replaced with Package price')}.<br>
                                    <b>[[expired_date]]</b> - {Lang::T('will be replaced with Expiration date')}.<br>
                                    <b>[[bills]]</b> - {Lang::T('additional bills for customers')}.<br>
                                    <b>[[payment_link]]</b> - {Lang::T('payment link for customers')}.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 3 Days Reminder -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-calendar-day"></i> {Lang::T('Reminder 3 days before expiry')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern small" id="reminder_3_day" name="reminder_3_day"
                                          rows="4" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['reminder_3_day'])}</textarea>
                                <div class="char-counter" id="reminder_3_day-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[name]]</b> - {Lang::T('will be replaced with Customer Name')}.<br>
                                    <b>[[username]]</b> - {Lang::T('will be replaced with Customer username')}.<br>
                                    <b>[[package]]</b> - {Lang::T('will be replaced with Package name')}.<br>
                                    <b>[[price]]</b> - {Lang::T('will be replaced with Package price')}.<br>
                                    <b>[[expired_date]]</b> - {Lang::T('will be replaced with Expiration date')}.<br>
                                    <b>[[bills]]</b> - {Lang::T('additional bills for customers')}.<br>
                                    <b>[[payment_link]]</b> - {Lang::T('payment link for customers')}.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 1 Day Reminder -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-calendar-day"></i> {Lang::T('Reminder 1 day before expiry')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern small" id="reminder_1_day" name="reminder_1_day"
                                          rows="4" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['reminder_1_day'])}</textarea>
                                <div class="char-counter" id="reminder_1_day-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[name]]</b> - {Lang::T('will be replaced with Customer Name')}.<br>
                                    <b>[[username]]</b> - {Lang::T('will be replaced with Customer username')}.<br>
                                    <b>[[package]]</b> - {Lang::T('will be replaced with Package name')}.<br>
                                    <b>[[price]]</b> - {Lang::T('will be replaced with Package price')}.<br>
                                    <b>[[expired_date]]</b> - {Lang::T('will be replaced with Expiration date')}.<br>
                                    <b>[[bills]]</b> - {Lang::T('additional bills for customers')}.<br>
                                    <b>[[payment_link]]</b> - {Lang::T('payment link for customers')}.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Invoices Section -->
                <div class="panel-section" id="invoices-section">
                    <h4 class="control-label-modern" style="font-size: 1rem; color: var(--orange-primary); margin-bottom: 1.5rem;">
                        <i class="fas fa-file-invoice"></i> {Lang::T('Payment Invoice Templates')}
                    </h4>

                    <!-- Invoice Paid -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-receipt"></i> {Lang::T('Invoice Notification Payment')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern large" id="invoice_paid" name="invoice_paid"
                                          placeholder="{Lang::T('Hello')} [[name]], {Lang::T('your internet package')} [[package]] {Lang::T('has been paid')}"
                                          rows="20" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['invoice_paid'])}</textarea>
                                <div class="char-counter" id="invoice_paid-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[company_name]]</b> {Lang::T('Your Company Name at Settings')}.<br>
                                    <b>[[address]]</b> {Lang::T('Your Company Address at Settings')}.<br>
                                    <b>[[phone]]</b> - {Lang::T('Your Company Phone at Settings')}.<br>
                                    <b>[[invoice]]</b> - {Lang::T('Invoice number')}.<br>
                                    <b>[[date]]</b> - {Lang::T('Date invoice created')}.<br>
                                    <b>[[payment_gateway]]</b> - {Lang::T('Payment gateway user paid from')}.<br>
                                    <b>[[payment_channel]]</b> - {Lang::T('Payment channel user paid from')}.<br>
                                    <b>[[type]]</b> - {Lang::T('is Hotspot or PPPOE')}.<br>
                                    <b>[[plan_name]]</b> - {Lang::T('Internet Package')}.<br>
                                    <b>[[plan_price]]</b> - {Lang::T('Internet Package Prices')}.<br>
                                    <b>[[name]]</b> - {Lang::T('Receiver name')}.<br>
                                    <b>[[user_name]]</b> - {Lang::T('Username internet')}.<br>
                                    <b>[[user_password]]</b> - {Lang::T('User password')}.<br>
                                    <b>[[expired_date]]</b> - {Lang::T('Expired datetime')}.<br>
                                    <b>[[footer]]</b> - {Lang::T('Invoice Footer')}.<br>
                                    <b>[[note]]</b> - {Lang::T('For Notes by admin')}.<br>
                                    <b>[[invoice_link]]</b> - {Lang::T('Invoice download link')}.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Balance Invoice -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-balance-scale"></i> {Lang::T('Balance Notification Payment')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern large" id="invoice_balance" name="invoice_balance"
                                          placeholder="{Lang::T('Hello')} [[name]], {Lang::T('your balance has been updated')}"
                                          rows="20" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['invoice_balance'])}</textarea>
                                <div class="char-counter" id="invoice_balance-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[company_name]]</b> - {Lang::T('Your Company Name at Settings')}.<br>
                                    <b>[[address]]</b> - {Lang::T('Your Company Address at Settings')}.<br>
                                    <b>[[phone]]</b> - {Lang::T('Your Company Phone at Settings')}.<br>
                                    <b>[[invoice]]</b> - {Lang::T('Invoice number')}.<br>
                                    <b>[[date]]</b> - {Lang::T('Date invoice created')}.<br>
                                    <b>[[payment_gateway]]</b> - {Lang::T('Payment gateway user paid from')}.<br>
                                    <b>[[payment_channel]]</b> - {Lang::T('Payment channel user paid from')}.<br>
                                    <b>[[type]]</b> - {Lang::T('is Hotspot or PPPOE')}.<br>
                                    <b>[[plan_name]]</b> - {Lang::T('Internet Package')}.<br>
                                    <b>[[plan_price]]</b> - {Lang::T('Internet Package Prices')}.<br>
                                    <b>[[name]]</b> - {Lang::T('Receiver name')}.<br>
                                    <b>[[user_name]]</b> - {Lang::T('Username internet')}.<br>
                                    <b>[[user_password]]</b> - {Lang::T('User password')}.<br>
                                    <b>[[trx_date]]</b> - {Lang::T('Transaction datetime')}.<br>
                                    <b>[[balance_before]]</b> - {Lang::T('Balance Before')}.<br>
                                    <b>[[balance]]</b> - {Lang::T('Balance After')}.<br>
                                    <b>[[footer]]</b> - {Lang::T('Invoice Footer')}.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Welcome Message -->
                <div class="panel-section" id="welcome-section">
                    <div class="control-label-modern">
                        <i class="fas fa-user-plus"></i> {Lang::T('Welcome Message for New Customers')}
                        <span class="preview-btn" onclick="previewTemplate('welcome_message')">
                            <i class="fas fa-eye"></i> {Lang::T('Preview')}
                        </span>
                    </div>
                    
                    <div class="two-column-layout">
                        <div class="textarea-column">
                            <textarea class="textarea-modern small" id="welcome_message" name="welcome_message"
                                      rows="4" oninput="updateCounter(this)">{Lang::htmlspecialchars($_json['welcome_message'])}</textarea>
                            <div class="char-counter" id="welcome_message-counter">0 characters</div>
                        </div>
                        
                        <div class="help-column">
                            <div class="help-block-modern">
                                <b>[[name]]</b> - {Lang::T('will be replaced with Customer Name')}.<br>
                                <b>[[username]]</b> - {Lang::T('will be replaced with Customer username')}.<br>
                                <b>[[password]]</b> - {Lang::T('will be replaced with Customer password')}.<br>
                                <b>[[url]]</b> - {Lang::T('will be replaced with Customer Portal URL')}.<br>
                                <b>[[company]]</b> - {Lang::T('will be replaced with Company Name')}.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Balance Notifications (Conditional) -->
                {if $_c['enable_balance'] == 'yes'}
                <div class="panel-section" id="balance-section">
                    <h4 class="control-label-modern" style="font-size: 1rem; color: var(--orange-primary); margin-bottom: 1.5rem;">
                        <i class="fas fa-money-bill-wave"></i> {Lang::T('Balance Transfer Notifications')}
                    </h4>

                    <!-- Send Balance -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-paper-plane"></i> {Lang::T('Send Balance Notification')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern small" id="balance_send" name="balance_send"
                                          rows="4" oninput="updateCounter(this)">{if $_json['balance_send']}{Lang::htmlspecialchars($_json['balance_send'])}{else}{Lang::htmlspecialchars($_default['balance_send'])}{/if}</textarea>
                                <div class="char-counter" id="balance_send-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[name]]</b> - {Lang::T('Receiver name')}.<br>
                                    <b>[[balance]]</b> - {Lang::T('how much balance have been send')}.<br>
                                    <b>[[current_balance]]</b> - {Lang::T('Current Balance')}.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Received Balance -->
                    <div class="form-group-modern">
                        <label class="control-label-modern">
                            <i class="fas fa-hand-holding-usd"></i> {Lang::T('Received Balance Notification')}
                        </label>
                        <div class="two-column-layout">
                            <div class="textarea-column">
                                <textarea class="textarea-modern small" id="balance_received" name="balance_received"
                                          rows="4" oninput="updateCounter(this)">{if $_json['balance_received']}{Lang::htmlspecialchars($_json['balance_received'])}{else}{Lang::htmlspecialchars($_default['balance_received'])}{/if}</textarea>
                                <div class="char-counter" id="balance_received-counter">0 characters</div>
                            </div>
                            <div class="help-column">
                                <div class="help-block-modern">
                                    <b>[[name]]</b> - {Lang::T('Sender name')}.<br>
                                    <b>[[balance]]</b> - {Lang::T('how much balance have been received')}.<br>
                                    <b>[[current_balance]]</b> - {Lang::T('Current Balance')}.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {/if}
            </div>

            <!-- Save Actions -->
            <div class="form-actions">
                <button class="btn-orange" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save All Notification Templates')}
                </button>
                <p class="help-block-modern" style="margin-top: 1rem; text-align: center;">
                    <i class="fas fa-info-circle"></i> {Lang::T('All changes will be applied immediately after saving')}
                </p>
            </div>
        </div>
    </form>
</div>

<script>
    // Character counter function
    function updateCounter(textarea) {
        const length = textarea.value.length;
        const counter = document.getElementById(textarea.id + '-counter');
        if (counter) {
            counter.textContent = length + ' characters';
            counter.style.color = length < 10 ? 'var(--danger-color)' : 
                                 length > 500 ? 'var(--warning-color)' : 'var(--success-color)';
        }
    }

  // Preview template function
function previewTemplate(templateId) {
    const textarea = document.getElementById(templateId);
    if (textarea && textarea.value.trim()) {
        // Create preview modal
        const modal = document.createElement('div');
        modal.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 9999;';
        modal.id = 'preview-modal-' + templateId;
        
        const content = document.createElement('div');
        content.style.cssText = 'background: white; padding: 2rem; border-radius: var(--radius-md); width: 90%; max-width: 600px; max-height: 80vh; overflow-y: auto; box-shadow: var(--shadow-xl);';
        
        // Escape HTML for preview
        const escapedContent = textarea.value
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
        
        content.innerHTML = 
            '<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 2px solid var(--orange-lighter);">' +
                '<h3 style="margin: 0; color: var(--orange-darker);">' +
                    '<i class="fas fa-eye"></i> Template Preview' +
                '</h3>' +
                '<button id="close-preview-btn" style="background: none; border: none; font-size: 1.5rem; color: var(--gray-500); cursor: pointer; padding: 0.5rem;">' +
                    '<i class="fas fa-times"></i>' +
                '</button>' +
            '</div>' +
            '<div style="background: var(--gray-50); padding: 1.5rem; border-radius: var(--radius); border-left: 3px solid var(--orange-primary); font-family: monospace; white-space: pre-wrap; line-height: 1.6;">' +
                escapedContent +
            '</div>' +
            '<div style="margin-top: 1.5rem; text-align: center;">' +
                '<button id="close-preview-btn-2" style="background: var(--orange-gradient); color: white; border: none; padding: 0.75rem 2rem; border-radius: var(--radius); cursor: pointer; font-weight: 600;">' +
                    '<i class="fas fa-check"></i> Close Preview' +
                '</button>' +
            '</div>';
        
        modal.appendChild(content);
        document.body.appendChild(modal);
        
        // Add event listeners after the modal is created
        setTimeout(function() {
            const closeBtn = document.getElementById('close-preview-btn');
            const closeBtn2 = document.getElementById('close-preview-btn-2');
            const modalElement = document.getElementById('preview-modal-' + templateId);
            
            if (closeBtn) {
                closeBtn.addEventListener('click', function() {
                    if (modalElement) {
                        modalElement.remove();
                    }
                });
            }
            
            if (closeBtn2) {
                closeBtn2.addEventListener('click', function() {
                    if (modalElement) {
                        modalElement.remove();
                    }
                });
            }
            
            // Also close modal when clicking outside content
            modalElement.addEventListener('click', function(e) {
                if (e.target === modalElement) {
                    modalElement.remove();
                }
            });
            
            // Close with Escape key
            document.addEventListener('keydown', function closeOnEscape(e) {
                if (e.key === 'Escape' && modalElement) {
                    modalElement.remove();
                    document.removeEventListener('keydown', closeOnEscape);
                }
            });
        }, 100);
    } else {
        alert('Please enter some content to preview.');
    }
}

    // Tab navigation
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize character counters
        const textareas = document.querySelectorAll('textarea');
        textareas.forEach(textarea => {
            updateCounter(textarea);
            
            // Add click handler for variable insertion
            textarea.addEventListener('focus', function() {
                this.closest('.two-column-layout').classList.add('highlight-section');
            });
            
            textarea.addEventListener('blur', function() {
                this.closest('.two-column-layout').classList.remove('highlight-section');
            });
        });

        // Tab switching
        const tabs = document.querySelectorAll('.notification-tab');
        const sections = {
            'expired': document.getElementById('expired-section'),
            'reminders': document.getElementById('reminders-section'),
            'invoices': document.getElementById('invoices-section'),
            'welcome': document.getElementById('welcome-section'),
            'balance': document.getElementById('balance-section')
        };

        tabs.forEach(tab => {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href').replace('#', '');
                
                // Update active tab
                tabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                
                // Scroll to section
                if (sections[targetId]) {
                    sections[targetId].scrollIntoView({ behavior: 'smooth', block: 'start' });
                    sections[targetId].classList.add('highlight-section');
                    
                    // Remove highlight after animation
                    setTimeout(() => {
                        sections[targetId].classList.remove('highlight-section');
                    }, 2000);
                }
            });
        });

        // Variable insertion
        const helpBlocks = document.querySelectorAll('.help-block-modern');
        helpBlocks.forEach(block => {
            const bTags = block.querySelectorAll('b');
            bTags.forEach(tag => {
                tag.style.cursor = 'pointer';
                tag.addEventListener('click', function() {
                    const variable = this.textContent.replace(/[\[\]]/g, '');
                    const textareaId = this.closest('.two-column-layout').querySelector('textarea').id;
                    const textarea = document.getElementById(textareaId);
                    
                    if (textarea) {
                        const start = textarea.selectionStart;
                        const end = textarea.selectionEnd;
                        const variableText = '[[' + variable + ']]';
                        
                        textarea.value = textarea.value.substring(0, start) + variableText + textarea.value.substring(end);
                        textarea.focus();
                        textarea.setSelectionRange(start + variableText.length, start + variableText.length);
                        
                        // Update counter
                        updateCounter(textarea);
                        
                        // Highlight effect
                        textarea.classList.add('highlight-section');
                        setTimeout(() => {
                            textarea.classList.remove('highlight-section');
                        }, 1000);
                    }
                });
            });
        });

        // Form validation
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            let hasErrors = false;
            const requiredFields = form.querySelectorAll('textarea[required]');
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.style.borderColor = 'var(--danger-color)';
                    field.style.boxShadow = '0 0 0 3px rgba(250, 82, 82, 0.15)';
                    
                    // Scroll to error
                    if (!hasErrors) {
                        field.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        hasErrors = true;
                    }
                } else {
                    field.style.borderColor = '';
                    field.style.boxShadow = '';
                }
            });
            
            if (hasErrors) {
                e.preventDefault();
                
                // Show error message
                const errorDiv = document.createElement('div');
                errorDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; background: var(--orange-gradient); color: white; padding: 1rem 1.5rem; border-radius: var(--radius); box-shadow: var(--shadow-lg); z-index: 9999; display: flex; align-items: center; gap: 0.5rem; animation: fadeInUp 0.3s ease;';
                errorDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i><span>Please fill in all required fields</span>';
                document.body.appendChild(errorDiv);
                
                setTimeout(function() {
                    errorDiv.style.animation = 'fadeInUp 0.3s ease reverse';
                    setTimeout(function() { errorDiv.remove(); }, 300);
                }, 5000);
            }
        });

        // Auto-save indicator
        let isDirty = false;
        const textInputs = form.querySelectorAll('textarea');
        textInputs.forEach(input => {
            input.addEventListener('input', function() {
                isDirty = true;
                document.title = '* ' + document.title.replace('* ', '');
            });
        });

        // Warn before leaving if unsaved changes
        window.addEventListener('beforeunload', function(e) {
            if (isDirty) {
                e.preventDefault();
                e.returnValue = 'You have unsaved changes. Are you sure you want to leave?';
            }
        });

        // Auto-resize textareas
        function autoResize(textarea) {
            textarea.style.height = 'auto';
            textarea.style.height = Math.min(textarea.scrollHeight, 400) + 'px';
        }

        textareas.forEach(textarea => {
            textarea.addEventListener('input', function() {
                autoResize(this);
            });
            // Initial resize
            autoResize(textarea);
        });
    });
</script>

{include file="sections/footer.tpl"}