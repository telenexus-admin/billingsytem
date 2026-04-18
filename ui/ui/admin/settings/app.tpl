{include file="sections/header.tpl"}
<style>
    /* Modern Form Styles */
    :root {
        --primary-color: #4361ee;
        --primary-light: #eef2ff;
        --success-color: #10b981;
        --warning-color: #f59e0b;
        --danger-color: #ef4444;
        --dark-color: #1f2937;
        --light-color: #f9fafb;
        --border-color: #e5e7eb;
        --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
        --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
        --shadow-lg: 0 10px 25px rgba(0,0,0,0.1);
    }

    /* Header Styling */
    .page-header {
        background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
        border-radius: 0 0 20px 20px;
        padding: 30px 0;
        margin-bottom: 30px;
        box-shadow: var(--shadow-lg);
        position: relative;
        overflow: hidden;
    }

    .page-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.1' fill-rule='evenodd'/%3E%3C/svg%3E");
    }

    .page-header-content {
        position: relative;
        z-index: 1;
        text-align: center;
        color: white;
    }

    .page-header h1 {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .page-header p {
        font-size: 16px;
        opacity: 0.9;
        max-width: 600px;
        margin: 0 auto;
    }

    /* Panel Styling */
    .panel {
        border: none;
        border-radius: 12px;
        box-shadow: var(--shadow-md);
        margin-bottom: 20px;
        background: white;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .panel:hover {
        box-shadow: var(--shadow-lg);
        transform: translateY(-2px);
    }

    .panel-heading {
        background: linear-gradient(135deg, var(--light-color) 0%, white 100%);
        border-bottom: 2px solid var(--primary-color);
        padding: 20px 25px;
        cursor: pointer;
        transition: all 0.3s ease;
        position: relative;
    }

    .panel-heading:hover {
        background: linear-gradient(135deg, #e5e7eb 0%, var(--light-color) 100%);
    }

    .panel-heading[aria-expanded="true"] {
        background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
        color: white;
    }

    .panel-heading[aria-expanded="true"] .panel-title {
        color: white;
    }

    .panel-heading[aria-expanded="true"] .collapse-icon {
        transform: rotate(180deg);
        color: white;
    }

    .panel-title {
        font-weight: 600;
        font-size: 16px;
        color: var(--dark-color);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .panel-title i {
        font-size: 18px;
        width: 24px;
    }

    .collapse-icon {
        position: absolute;
        right: 25px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--primary-color);
        transition: all 0.3s ease;
    }

    .panel-body {
        padding: 25px;
        background: white;
    }

    /* Form Group Styling */
    .form-group {
        margin-bottom: 25px;
        padding: 20px;
        border: 1px solid var(--border-color);
        border-radius: 10px;
        background: var(--light-color);
        transition: all 0.3s ease;
        position: relative;
    }

    .form-group:hover {
        border-color: var(--primary-color);
        background: white;
        box-shadow: var(--shadow-sm);
    }

    .form-group::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background: var(--primary-color);
        border-radius: 4px 0 0 4px;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .form-group:hover::before {
        opacity: 1;
    }

    .control-label {
        font-weight: 600;
        color: var(--dark-color);
        margin-bottom: 8px;
        display: block;
        font-size: 14px;
    }

    .help-block {
        font-size: 12px;
        color: #6b7280;
        margin-top: 8px;
        display: block;
        line-height: 1.4;
    }

    .help-block.col-md-4 {
        background: white;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid var(--border-color);
        margin-top: 10px;
    }

    /* Form Controls */
    .form-control {
        border: 2px solid var(--border-color);
        border-radius: 8px;
        padding: 10px 15px;
        font-size: 14px;
        transition: all 0.3s ease;
        background: white;
        height: auto;
    }

    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
    }

    select.form-control {
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%234361ee' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 15px center;
        background-size: 16px;
        padding-right: 40px;
    }

    /* Input Groups */
    .input-group {
        box-shadow: var(--shadow-sm);
        border-radius: 8px;
        overflow: hidden;
    }

    .input-group-addon {
        background: var(--primary-light);
        border: 2px solid var(--border-color);
        border-right: none;
        color: var(--primary-color);
        font-weight: 600;
        padding: 10px 15px;
        display: flex;
        align-items: center;
    }

    .input-group .form-control {
        border-left: none;
        border-radius: 0 8px 8px 0;
    }

    /* Switch Styling */
    .switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 26px;
    }

    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: .4s;
        border-radius: 34px;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 18px;
        width: 18px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        transition: .4s;
        border-radius: 50%;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    input:checked + .slider {
        background-color: var(--success-color);
    }

    input:focus + .slider {
        box-shadow: 0 0 1px var(--success-color);
    }

    input:checked + .slider:before {
        transform: translateX(24px);
    }

    /* Button Styling */
    .btn {
        border-radius: 8px;
        padding: 10px 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
    }

    .btn-success {
        background: linear-gradient(135deg, var(--success-color) 0%, #34d399 100%);
        color: white;
    }

    .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
        background: linear-gradient(135deg, #0da271 0%, #10b981 100%);
    }

    .btn-success.btn-block {
        padding: 15px;
        font-size: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        margin-top: 20px;
    }

    .btn-group .btn {
        background: linear-gradient(135deg, var(--warning-color) 0%, #fbbf24 100%);
        color: white;
        border-radius: 6px;
        padding: 6px 12px;
        font-size: 12px;
        border: none;
    }

    .btn-group .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
    }

    .btn-info {
        background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
        color: white;
    }

    .btn-info:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
    }

    .btn-xs {
        padding: 4px 10px !important;
        font-size: 11px !important;
    }

    /* Info Callout */
    .bs-callout {
        border-left: 4px solid var(--primary-color);
        background: var(--light-color);
        padding: 20px;
        border-radius: 8px;
        margin: 30px 0;
        box-shadow: var(--shadow-sm);
    }

    .bs-callout h4 {
        color: var(--primary-color);
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .bs-callout h4 b {
        font-weight: 700;
    }

    .bs-callout p {
        color: var(--dark-color);
        line-height: 1.6;
        margin-bottom: 10px;
        font-family: 'Courier New', monospace;
        background: white;
        padding: 15px;
        border-radius: 6px;
        border: 1px solid var(--border-color);
    }

    /* System Info */
    .pull-right.text-muted {
        background: white;
        padding: 15px;
        border-radius: 10px;
        border: 1px solid var(--border-color);
        box-shadow: var(--shadow-sm);
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }

    .pull-right.text-muted small {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* Checkbox Custom Styling */
    .checkbox-container {
        display: flex;
        align-items: flex-start;
        padding: 15px;
        background: white;
        border-radius: 8px;
        border: 2px solid var(--border-color);
        cursor: pointer;
        transition: all 0.3s ease;
        margin-bottom: 10px;
    }

    .checkbox-container:hover {
        border-color: var(--primary-color);
        background: var(--primary-light);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .checkbox-container input[type="checkbox"] {
        margin-top: 3px;
        margin-right: 15px;
        width: 18px;
        height: 18px;
        cursor: pointer;
    }

    .checkbox-label {
        flex: 1;
    }

    .checkbox-label strong {
        font-size: 14px;
        color: var(--dark-color);
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
    }

    .checkbox-label i {
        font-size: 16px;
    }

    .checkbox-label small {
        display: block;
        font-size: 12px;
        line-height: 1.4;
        color: #6b7280;
    }

    /* Toast Notifications */
    .toast-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        animation: slideIn 0.3s ease;
    }

    .toast {
        background: white;
        border-radius: 10px;
        box-shadow: var(--shadow-lg);
        padding: 16px 20px;
        margin-bottom: 10px;
        min-width: 300px;
        display: flex;
        align-items: center;
        gap: 12px;
        border-left: 4px solid;
    }

    .toast-success {
        border-left-color: var(--success-color);
    }

    .toast-error {
        border-left-color: var(--danger-color);
    }

    .toast-warning {
        border-left-color: var(--warning-color);
    }

    .toast-info {
        border-left-color: var(--primary-color);
    }

    .toast i {
        font-size: 20px;
    }

    .toast-success i {
        color: var(--success-color);
    }

    .toast-error i {
        color: var(--danger-color);
    }

    .toast-warning i {
        color: var(--warning-color);
    }

    .toast-info i {
        color: var(--primary-color);
    }

    .toast-content {
        flex: 1;
    }

    .toast-title {
        font-weight: 600;
        margin-bottom: 4px;
        color: var(--dark-color);
    }

    .toast-message {
        font-size: 13px;
        color: #6b7280;
    }

    .toast-close {
        cursor: pointer;
        color: #9ca3af;
        transition: color 0.3s ease;
    }

    .toast-close:hover {
        color: var(--dark-color);
    }

    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    /* Modal Styling */
    .modal-content {
        border-radius: 12px;
        border: none;
        box-shadow: var(--shadow-lg);
    }

    .modal-header {
        background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
        color: white;
        border-radius: 12px 12px 0 0;
        padding: 20px;
    }

    .modal-title {
        font-weight: 600;
    }

    .modal-body {
        padding: 25px;
    }

    .modal-footer {
        padding: 20px;
        border-top: 1px solid var(--border-color);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .panel-body {
            padding: 15px;
        }
        
        .form-group {
            padding: 15px;
        }
        
        .page-header {
            padding: 20px 0;
            border-radius: 0 0 15px 15px;
        }
        
        .page-header h1 {
            font-size: 24px;
        }
        
        .help-block.col-md-4 {
            margin-top: 15px;
        }
        
        .checkbox-container {
            padding: 12px;
        }
        
        .toast {
            min-width: auto;
            width: 90%;
            margin: 0 auto 10px;
        }
    }

    /* Animation */
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

    .panel {
        animation: fadeInUp 0.5s ease forwards;
        opacity: 0;
    }

    .panel:nth-child(1) { animation-delay: 0.1s; }
    .panel:nth-child(2) { animation-delay: 0.2s; }
    .panel:nth-child(3) { animation-delay: 0.3s; }
    .panel:nth-child(4) { animation-delay: 0.4s; }
    .panel:nth-child(5) { animation-delay: 0.5s; }
    .panel:nth-child(6) { animation-delay: 0.6s; }
    .panel:nth-child(7) { animation-delay: 0.7s; }
    .panel:nth-child(8) { animation-delay: 0.8s; }
    .panel:nth-child(9) { animation-delay: 0.9s; }
    .panel:nth-child(10) { animation-delay: 1s; }
    .panel:nth-child(11) { animation-delay: 1.1s; }

    /* Password Toggle */
    .password-toggle {
        position: relative;
    }

    .password-toggle-btn {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: #6b7280;
        cursor: pointer;
        padding: 5px;
        z-index: 10;
    }

    .password-toggle-btn:hover {
        color: var(--primary-color);
    }
</style>

<!-- Toast Notifications Container -->
<div id="toast-container" class="toast-notification"></div>

<!-- Test SMS Modal -->
<div class="modal fade" id="testSmsModal" tabindex="-1" role="dialog" aria-labelledby="testSmsModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white; opacity: 1;">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="testSmsModalLabel">
                    <i class="fas fa-sms"></i> Test SMS Notification
                </h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="test_phone_number">Phone Number</label>
                    <input type="text" class="form-control" id="test_phone_number" placeholder="Enter phone number with country code">
                    <small class="help-block">Example: 254712345678</small>
                </div>
                <div class="form-group">
                    <label for="test_message">Test Message</label>
                    <textarea class="form-control" id="test_message" rows="3">This is a test SMS from your application.</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" onclick="sendTestSms()">
                    <i class="fas fa-paper-plane"></i> Send Test SMS
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Test WhatsApp Modal -->
<div class="modal fade" id="testWaModal" tabindex="-1" role="dialog" aria-labelledby="testWaModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white; opacity: 1;">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="testWaModalLabel">
                    <i class="fab fa-whatsapp"></i> Test WhatsApp Notification
                </h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="test_wa_number">Phone Number</label>
                    <input type="text" class="form-control" id="test_wa_number" placeholder="Enter phone number with country code">
                    <small class="help-block">Example: 254712345678</small>
                </div>
                <div class="form-group">
                    <label for="test_wa_message">Test Message</label>
                    <textarea class="form-control" id="test_wa_message" rows="3">This is a test WhatsApp message from your application.</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" onclick="sendTestWa()">
                    <i class="fas fa-paper-plane"></i> Send Test WhatsApp
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Test Email Modal -->
<div class="modal fade" id="testEmailModal" tabindex="-1" role="dialog" aria-labelledby="testEmailModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white; opacity: 1;">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="testEmailModalLabel">
                    <i class="fas fa-envelope"></i> Test Email Notification
                </h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="test_email_address">Email Address</label>
                    <input type="email" class="form-control" id="test_email_address" placeholder="Enter email address">
                    <small class="help-block">Example: user@example.com</small>
                </div>
                <div class="form-group">
                    <label for="test_email_subject">Subject</label>
                    <input type="text" class="form-control" id="test_email_subject" value="Test Email from Application">
                </div>
                <div class="form-group">
                    <label for="test_email_message">Test Message</label>
                    <textarea class="form-control" id="test_email_message" rows="3">This is a test email from your application.</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" onclick="sendTestEmail()">
                    <i class="fas fa-paper-plane"></i> Send Test Email
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Test Telegram Modal -->
<div class="modal fade" id="testTgModal" tabindex="-1" role="dialog" aria-labelledby="testTgModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white; opacity: 1;">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="testTgModalLabel">
                    <i class="fab fa-telegram"></i> Test Telegram Notification
                </h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="test_tg_chat_id">Chat/Group ID</label>
                    <input type="text" class="form-control" id="test_tg_chat_id" placeholder="Enter Telegram Chat ID or Group ID">
                    <small class="help-block">Optional. Leave empty to use configured ID.</small>
                </div>
                <div class="form-group">
                    <label for="test_tg_message">Test Message</label>
                    <textarea class="form-control" id="test_tg_message" rows="3">This is a test Telegram message from your application.</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" onclick="sendTestTg()">
                    <i class="fas fa-paper-plane"></i> Send Test Telegram
                </button>
            </div>
        </div>
    </div>
</div>

<div class="page-header">
    <div class="page-header-content">
        <h1><i class="fas fa-cogs"></i> Application Settings</h1>
        <p>Configure your system preferences and notification settings</p>
    </div>
</div>

<form class="form-horizontal" method="post" role="form" action="{Text::url('')}settings/app-post" enctype="multipart/form-data">
    <input type="hidden" name="csrf_token" value="{$csrf_token}">
    
    <!-- General Settings Panel -->
    <div class="panel" id="accordion" role="tablist" aria-multiselectable="true">
        <div class="panel-heading" role="tab" id="General" data-toggle="collapse" data-parent="#accordion" href="#collapseGeneral" aria-expanded="true" aria-controls="collapseGeneral">
            <h3 class="panel-title">
                <i class="fas fa-sliders-h"></i>
                {Lang::T('General Settings')}
            </h3>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseGeneral" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="General">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Application Name / Company Name')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="CompanyName" name="CompanyName" value="{$_c['CompanyName']}" placeholder="Enter your company name">
                    </div>
                    <span class="help-block col-md-4">{Lang::T('This Name will be shown on the Title')}</span>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Company Footer')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="CompanyFooter" name="CompanyFooter" value="{$_c['CompanyFooter']}" placeholder="Enter footer text">
                    </div>
                    <span class="help-block col-md-4">{Lang::T('Will show below user pages')}</span>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Phone Number')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="phone" name="phone" value="{$_c['phone']}" placeholder="+1234567890">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Income reset date')}</label>
                    <div class="col-md-5">
                        <select name="reset_day" id="reset_day" class="form-control">
                            {for $day=1 to 31}
                                <option value="{$day}" {if $_c['reset_day'] eq $day}selected="selected"{/if}>
                                    Day {$day}
                                </option>
                            {/for}
                        </select>
                    </div>
                    <span class="help-block col-md-4">{Lang::T('Income automatically resets on this day of every month')}</span>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Dashboard Structure')}</label>
                    <div class="col-md-5">
                        <input type="text" name="dashboard_cr" class="form-control" value="{$_c['dashboard_cr']}" placeholder="12.7,5.12">
                    </div>
                    <p class="help-block col-md-4">
                        <a href="{$app_url}/docs/#Dashboard%20Structure" target="_blank">{Lang::T('Read documentation')}</a>
                    </p>
                </div>

                <button class="btn btn-success btn-block" name="general" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- Localization Panel -->
    <div class="panel" id="accordion" role="tablist" aria-multiselectable="true">
        <div class="panel-heading" role="tab" id="Localization" data-toggle="collapse" data-parent="#accordion" href="#collapseLocalization" aria-expanded="false" aria-controls="collapseLocalization">
            <h3 class="panel-title">
                <i class="fas fa-globe"></i>
                {Lang::T('Localization')}
            </h3>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseLocalization" class="panel-collapse collapse" role="tabpanel" aria-labelledby="Localization">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Timezone')}</label>
                    <div class="col-md-5">
                        <select name="timezone" id="timezone" class="form-control">
                            {foreach $tlist as $value => $label}
                                <option value="{$value}" {if $_c['timezone'] eq $value}selected="selected" {/if}>
                                    {$label}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <p class="help-block col-md-4">Select your local timezone</p>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Date Format')}</label>
                    <div class="col-md-5">
                        <select class="form-control" name="date_format" id="date_format">
                            <option value="d/m/Y" {if $_c['date_format'] eq 'd/m/Y'} selected="selected" {/if}>DD/MM/YYYY (31/12/2025)</option>
                            <option value="d.m.Y" {if $_c['date_format'] eq 'd.m.Y'} selected="selected" {/if}>DD.MM.YYYY (31.12.2025)</option>
                            <option value="d-m-Y" {if $_c['date_format'] eq 'd-m-Y'} selected="selected" {/if}>DD-MM-YYYY (31-12-2025)</option>
                            <option value="m/d/Y" {if $_c['date_format'] eq 'm/d/Y'} selected="selected" {/if}>MM/DD/YYYY (12/31/2025)</option>
                            <option value="Y/m/d" {if $_c['date_format'] eq 'Y/m/d'} selected="selected" {/if}>YYYY/MM/DD (2025/12/31)</option>
                            <option value="Y-m-d" {if $_c['date_format'] eq 'Y-m-d'} selected="selected" {/if}>YYYY-MM-DD (2025-12-31)</option>
                            <option value="M d Y" {if $_c['date_format'] eq 'M d Y'} selected="selected" {/if}>MMM DD YYYY (Dec 31 2025)</option>
                            <option value="d M Y" {if $_c['date_format'] eq 'd M Y'} selected="selected" {/if}>DD MMM YYYY (31 Dec 2025)</option>
                            <option value="jS M y" {if $_c['date_format'] eq 'jS M y'} selected="selected" {/if}>DD MMM YY (31st Dec 25)</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">Choose how dates are displayed</p>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Default Language')}</label>
                    <div class="col-md-5">
                        <select class="form-control" name="language" id="language">
                            {foreach $lani as $lanis}
                                <option value="{$lanis@key}" {if $_c['language'] eq $lanis@key} selected="selected" {/if}>
                                    {$lanis@key}
                                </option>
                            {/foreach}
                            <option disabled>_________</option>
                            {foreach $lan as $lans}
                                <option value="{$lans@key}" {if $_c['language'] eq $lans@key} selected="selected" {/if}>
                                    {$lans@key}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4 help-block">
                        <a href="{Text::url('')}settings/language">{Lang::T('Language Editor')}</a>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Currency Code')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="currency_code" name="currency_code" value="{$_c['currency_code']}" placeholder="USD, EUR, KSH">
                    </div>
                    <span class="help-block col-md-4">{Lang::T('Keep it blank if you do not want to show currency code')}</span>
                </div>
                
                               
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Hotspot Package')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="hotspot_plan" name="hotspot_plan" value="{if $_c['hotspot_plan']==''}Hotspot Plan{else}{$_c['hotspot_plan']}{/if}">
                    </div>
                    <span class="help-block col-md-4">{Lang::T('Change title in user Plan order')}</span>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('PPPOE Package')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="pppoe_plan" name="pppoe_plan" value="{if $_c['pppoe_plan']==''}PPPOE Plan{else}{$_c['pppoe_plan']}{/if}">
                    </div>
                    <span class="help-block col-md-4">{Lang::T('Change title in user Plan order')}</span>
                </div>

                <button class="btn btn-success btn-block" name="localization" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- Security Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="Security" data-toggle="collapse" data-parent="#accordion" href="#collapseSecurity" aria-expanded="false" aria-controls="collapseSecurity">
            <h4 class="panel-title">
                <i class="fas fa-shield-alt"></i>
                {Lang::T('Security')}
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseSecurity" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Enable Session Timeout')}</label>
                    <div class="col-md-5">
                        <label class="switch">
                            <input type="checkbox" id="enable_session_timeout" value="1" name="enable_session_timeout" {if $_c['enable_session_timeout']==1}checked{/if}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <p class="help-block col-md-4">{Lang::T('Logout Admin if not Available/Online a period of time')}</p>
                </div>
                
                <div class="form-group" id="timeout_duration_input" style="display: {if $_c['enable_session_timeout']==1}block{else}none{/if};">
                    <label class="col-md-3 control-label">{Lang::T('Timeout Duration')}</label>
                    <div class="col-md-5">
                        <input type="number" value="{$_c['session_timeout_duration']}" class="form-control" name="session_timeout_duration" id="session_timeout_duration" placeholder="{Lang::T('Enter the session timeout duration (minutes)')}" min="1">
                    </div>
                    <p class="help-block col-md-4">{Lang::T('Idle Timeout, Logout Admin if Idle for xx minutes')}</p>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Single Admin Session')}</label>
                    <div class="col-md-5">
                        <select name="single_session" id="single_session" class="form-control">
                            <option value="no">{Lang::T('No')}</option>
                            <option value="yes" {if $_c['single_session']=='yes'}selected="selected"{/if}>{Lang::T('Yes')}</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">{Lang::T('Admin can only have single session login, it will logout another session')}</p>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Enable CSRF Validation')}</label>
                    <div class="col-md-5">
                        <select name="csrf_enabled" id="csrf_enabled" class="form-control">
                            <option value="no">{Lang::T('No')}</option>
                            <option value="yes" {if $_c['csrf_enabled']=='yes'}selected="selected"{/if}>{Lang::T('Yes')}</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">
                        <a href="https://en.wikipedia.org/wiki/Cross-site_request_forgery" target="_blank">{Lang::T('Cross-site request forgery')}</a>
                    </p>
                </div>
                
                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

       <!-- Telegram Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="TelegramNotification" data-toggle="collapse" data-parent="#accordion" href="#collapseTelegramNotification" aria-expanded="false" aria-controls="collapseTelegramNotification">
            <h4 class="panel-title">
                <i class="fab fa-telegram"></i>
                {Lang::T('Telegram Notification')}
                <div class="btn-group pull-right">
                    <a class="btn btn-info btn-xs" style="color: white;" href="javascript:void(0)" onclick="showTestTgModal()">
                        <i class="fas fa-paper-plane"></i> Test TG
                    </a>
                </div>
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseTelegramNotification" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Telegram Bot Token')}</label>
                    <div class="col-md-5 password-toggle">
                        <input type="password" class="form-control" id="telegram_bot" name="telegram_bot" value="{$_c['telegram_bot']}" placeholder="123456:asdasgdkuasghddlashdashldhalskdklasd">
                        <button type="button" class="password-toggle-btn" onclick="togglePassword('telegram_bot')">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Telegram User/Channel/Group ID')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="telegram_target_id" name="telegram_target_id" value="{$_c['telegram_target_id']}" placeholder="12345678">
                    </div>
                </div>
                
                <small id="emailHelp" class="form-text text-muted">{Lang::T('You will get Payment and Error notification')}</small>
                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- SMS Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="SMSNotification" data-toggle="collapse" data-parent="#accordion" href="#collapseSMSNotification" aria-expanded="false" aria-controls="collapseSMSNotification">
            <h4 class="panel-title">
                <i class="fas fa-sms"></i>
                {Lang::T('SMS Notification')}
                <div class="btn-group pull-right">
                    <a class="btn btn-info btn-xs" style="color: white;" href="javascript:void(0)" onclick="showTestSmsModal()">
                        <i class="fas fa-paper-plane"></i> {Lang::T('Test SMS')}
                    </a>
                </div>
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseSMSNotification" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('SMS Gateway')}</label>
                    <div class="col-md-5">
                        <select class="form-control" id="sms_gateway_type" name="sms_gateway_type" onchange="toggleSmsGateway()">
                            <option value="url" {if !$_c['sms_gateway_type'] || $_c['sms_gateway_type']=='url'}selected{/if}>SMS URL</option>
                            <option value="africastalking" {if $_c['sms_gateway_type']=='africastalking'}selected{/if}>Africa's Talking</option>
                            <option value="talksasa" {if $_c['sms_gateway_type']=='talksasa'}selected{/if}>TalkSasa</option>
                            <option value="umscomms" {if $_c['sms_gateway_type']=='umscomms'}selected{/if}>UMS Comms</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">Select your SMS gateway provider</p>
                </div>

                <!-- SMS URL Section -->
                <div id="sms_url_section">
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('SMS Server URL')}</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="sms_url" name="sms_url" value="{$_c['sms_url']}" placeholder="https://domain/?param_number=[number]&param_text=[text]&secret=">
                        </div>
                        <p class="help-block col-md-4">{Lang::T('Must include')} <b>[text]</b> &amp; <b>[number]</b>, {Lang::T('it will be replaced.')}</p>
                    </div>
                </div>

                <!-- Africa's Talking Section -->
                <div id="africastalking_section" style="display: none;">
                    <div class="form-group">
                        <label class="col-md-3 control-label">Africa's Talking Username</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="africastalking_username" name="africastalking_username" value="{$_c['africastalking_username']}" placeholder="sandbox">
                        </div>
                        <p class="help-block col-md-4">Your Africa's Talking username (use 'sandbox' for testing)</p>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">Africa's Talking API Key</label>
                        <div class="col-md-5 password-toggle">
                            <input type="password" class="form-control" id="africastalking_api_key" name="africastalking_api_key" value="{$_c['africastalking_api_key']}" placeholder="Your API Key">
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('africastalking_api_key')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <p class="help-block col-md-4">Your Africa's Talking API Key</p>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">Sender ID (Optional)</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="africastalking_sender_id" name="africastalking_sender_id" value="{$_c['africastalking_sender_id']}" placeholder="AFRICASTKNG">
                        </div>
                        <p class="help-block col-md-4">Custom sender ID (leave empty for default)</p>
                    </div>
                </div>

                <!-- TalkSasa Section -->
                <div id="talksasa_section" style="display: none;">
                    <div class="form-group">
                        <label class="col-md-3 control-label">TalkSasa API Key</label>
                        <div class="col-md-5 password-toggle">
                            <input type="password" class="form-control" id="talksasa_api_key" name="talksasa_api_key" value="{$_c['talksasa_api_key']}" placeholder="Your TalkSasa API Key">
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('talksasa_api_key')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <p class="help-block col-md-4">Your TalkSasa API Key</p>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">Sender ID (Optional)</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="talksasa_sender_id" name="talksasa_sender_id" value="{$_c['talksasa_sender_id']}" placeholder="TALKSASA">
                        </div>
                        <p class="help-block col-md-4">Custom sender ID (leave empty for TALKSASA default)</p>
                    </div>
                </div>

                <!-- UMS Comms Section -->
                <div id="umscomms_section" style="display: none;">
                    <div class="form-group">
                        <label class="col-md-3 control-label">UMS Comms API Key</label>
                        <div class="col-md-5 password-toggle">
                            <input type="password" class="form-control" id="umscomms_api_key" name="umscomms_api_key" value="{$_c['umscomms_api_key']}" placeholder="Your UMS Comms API Key">
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('umscomms_api_key')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <p class="help-block col-md-4">Your UMS Comms API Key</p>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">App ID</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="umscomms_app_id" name="umscomms_app_id" value="{$_c['umscomms_app_id']}" placeholder="Your App ID">
                        </div>
                        <p class="help-block col-md-4">Your UMS Comms App ID (default: UMSC131190)</p>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">Sender ID</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="umscomms_sender_id" name="umscomms_sender_id" value="{$_c['umscomms_sender_id']}" placeholder="UMS_TX">
                        </div>
                        <p class="help-block col-md-4">Your UMS Comms Sender ID (default: UMS_TX)</p>
                    </div>
                </div>

                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- Whatsapp Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="WhatsappNotification" data-toggle="collapse" data-parent="#accordion" href="#collapseWhatsappNotification" aria-expanded="false" aria-controls="collapseWhatsappNotification">
            <h4 class="panel-title">
                <i class="fab fa-whatsapp"></i>
                {Lang::T('Whatsapp Notification')}
                <div class="btn-group pull-right">
                    <a class="btn btn-info btn-xs" style="color: white;" href="javascript:void(0)" onclick="showTestWaModal()">
                        <i class="fas fa-paper-plane"></i> Test WA
                    </a>
                </div>
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseWhatsappNotification" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('WhatsApp Server URL')}</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="wa_url" name="wa_url" value="{$_c['wa_url']}" placeholder="https://domain/?param_number=[number]&param_text=[text]&secret=">
                    </div>
                    <p class="help-block col-md-4">{Lang::T('Must include')} <b>[text]</b> &amp; <b>[number]</b>, {Lang::T('it will be replaced.')}</p>
                </div>
                <small id="emailHelp" class="form-text text-muted">{Lang::T('You can use')} WhatsApp {Lang::T('in here too.')}</small>
                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- Email Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="EmailNotification" data-toggle="collapse" data-parent="#accordion" href="#collapseEmailNotification" aria-expanded="false" aria-controls="collapseEmailNotification">
            <h4 class="panel-title">
                <i class="fas fa-envelope"></i>
                {Lang::T('Email Notification')}
                <div class="btn-group pull-right">
                    <a class="btn btn-info btn-xs" style="color: white;" href="javascript:void(0)" onclick="showTestEmailModal()">
                        <i class="fas fa-paper-plane"></i> Test Email
                    </a>
                </div>
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseEmailNotification" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">Mail Port</label>
                    <div class="col-md-4">
                        <input type="text" class="form-control" id="smtp_host" name="smtp_host" value="{$_c['smtp_host']}" placeholder="mail.yourdomain.com">
                    </div>
                    <div class="col-md-2">
                        <input type="number" class="form-control" id="smtp_port" name="smtp_port" value="{$_c['smtp_port']}" placeholder="Usually 465 or 587">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Email Account Username</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="smtp_user" name="smtp_user" value="{$_c['smtp_user']}" placeholder="your@email.com">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Email Account Password</label>
                    <div class="col-md-5 password-toggle">
                        <input type="password" class="form-control" id="smtp_pass" name="smtp_pass" value="{$_c['smtp_pass']}">
                        <button type="button" class="password-toggle-btn" onclick="togglePassword('smtp_pass')">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Security Type</label>
                    <div class="col-md-5">
                        <select name="smtp_ssltls" id="smtp_ssltls" class="form-control">
                            <option value="" {if $_c['smtp_ssltls']==''}selected="selected"{/if}>None (Not Secure)</option>
                            <option value="ssl" {if $_c['smtp_ssltls']=='ssl'}selected="selected"{/if}>SSL (Most common)</option>
                            <option value="tls" {if $_c['smtp_ssltls']=='tls'}selected="selected"{/if}>TLS</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">If unsure, leave as SSL or None.</p>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Sender Email Address</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="mail_from" name="mail_from" value="{$_c['mail_from']}" placeholder="noreply@yourdomain.com">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Reply-To Email Address</label>
                    <div class="col-md-5">
                        <input type="text" class="form-control" id="mail_reply_to" name="mail_reply_to" value="{$_c['mail_reply_to']}" placeholder="support@yourdomain.com">
                    </div>
                    <p class="help-block col-md-4">This is where replies from your customers will go. Leave blank to use the sender address above.</p>
                </div>

                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- User Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="UserNotification" data-toggle="collapse" data-parent="#accordion" href="#collapseUserNotification" aria-expanded="false" aria-controls="collapseUserNotification">
            <h4 class="panel-title">
                <i class="fas fa-bell"></i>
                {Lang::T('User Notification')}
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseUserNotification" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Expired Notification')}</label>
                    <div class="col-md-5">
                        <select name="user_notification_expired" id="user_notification_expired" class="form-control">
                            <option value="none">{Lang::T('None')}</option>
                            <option value="wa" {if $_c['user_notification_expired']=='wa'}selected="selected"{/if}>{Lang::T('By WhatsApp')}</option>
                            <option value="sms" {if $_c['user_notification_expired']=='sms'}selected="selected"{/if}>{Lang::T('By SMS')}</option>
                            <option value="email" {if $_c['user_notification_expired']=='email'}selected="selected"{/if}>{Lang::T('By Email')}</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">{Lang::T('User will get notification when package expired')}</p>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Payment Notification')}</label>
                    <div class="col-md-5">
                        <select name="user_notification_payment" id="user_notification_payment" class="form-control">
                            <option value="none">{Lang::T('None')}</option>
                            <option value="wa" {if $_c['user_notification_payment']=='wa'}selected="selected"{/if}>{Lang::T('By WhatsApp')}</option>
                            <option value="sms" {if $_c['user_notification_payment']=='sms'}selected="selected"{/if}>{Lang::T('By SMS')}</option>
                            <option value="email" {if $_c['user_notification_payment']=='email'}selected="selected"{/if}>{Lang::T('By Email')}</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">{Lang::T('User will get invoice notification when buy package or package refilled')}</p>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Reminder Notification')}</label>
                    <div class="col-md-5">
                        <select name="user_notification_reminder" id="user_notification_reminder" class="form-control">
                            <option value="none">{Lang::T('None')}</option>
                            <option value="wa" {if $_c['user_notification_reminder']=='wa'}selected="selected"{/if}>{Lang::T('By WhatsApp')}</option>
                            <option value="sms" {if $_c['user_notification_reminder']=='sms'}selected="selected"{/if}>{Lang::T('By SMS')}</option>
                            <option value="email" {if $_c['user_notification_reminder']=='email'}selected="selected"{/if}>{Lang::T('By Email')}</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Reminder Notify Intervals')}</label><br>
                    <label class="col-md-3 control-label">
                        <input type="checkbox" name="notification_reminder_1day" value="yes" {if !isset($_c['notification_reminder_1day']) || $_c['notification_reminder_1day'] neq 'no'}checked{/if}>
                        {Lang::T('1 Day')}
                    </label>
                    <label class="col-md-3 control-label">
                        <input type="checkbox" name="notification_reminder_3days" value="yes" {if !isset($_c['notification_reminder_3days']) || $_c['notification_reminder_3days'] neq 'no'}checked{/if}>
                        {Lang::T('3 Days')}
                    </label>
                    <label class="col-md-3 control-label">
                        <input type="checkbox" name="notification_reminder_7days" value="yes" {if !isset($_c['notification_reminder_7days']) || $_c['notification_reminder_7days'] neq 'no'}checked{/if}>
                        {Lang::T('7 Days')}
                    </label>
                </div>
                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Changes')}
                </button>
            </div>
        </div>
    </div>

    <!-- Customer Type Notification Panel -->
    <div class="panel">
        <div class="panel-heading" role="tab" id="CustomerTypeNotifications" data-toggle="collapse" data-parent="#accordion" href="#collapseCustomerTypeNotifications" aria-expanded="false" aria-controls="collapseCustomerTypeNotifications">
            <h4 class="panel-title">
                <i class="fas fa-users"></i>
                {Lang::T('Customer Type Notifications')}
            </h4>
            <i class="fas fa-chevron-down collapse-icon"></i>
        </div>
        <div id="collapseCustomerTypeNotifications" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Enable Notifications For')}</label>
                    <div class="col-md-5">
                        <div style="display: flex; flex-direction: column; gap: 15px; padding: 20px; background: var(--light-color); border-radius: 10px; border: 2px solid var(--border-color);">
                            <label class="checkbox-container">
                                <input type="checkbox" name="notification_pppoe" value="yes" {if !isset($_c['notification_pppoe']) || $_c['notification_pppoe'] neq 'no'}checked{/if}>
                                <span class="checkbox-label">
                                    <strong>
                                        <i class="fas fa-plug" style="color: #4361ee; margin-right: 8px;"></i>
                                        PPPoE Customers
                                    </strong>
                                    <small class="text-muted" style="display: block; margin-top: 4px;">
                                        Enable notifications for PPPoE type customers. Includes all expiration, payment, and reminder notifications.
                                    </small>
                                </span>
                            </label>
                            
                            <label class="checkbox-container">
                                <input type="checkbox" name="notification_hotspot" value="yes" {if !isset($_c['notification_hotspot']) || $_c['notification_hotspot'] neq 'no'}checked{/if}>
                                <span class="checkbox-label">
                                    <strong>
                                        <i class="fas fa-wifi" style="color: #10b981; margin-right: 8px;"></i>
                                        Hotspot Customers
                                    </strong>
                                    <small class="text-muted" style="display: block; margin-top: 4px;">
                                        Enable notifications for Hotspot type customers. Includes all expiration, payment, and reminder notifications.
                                    </small>
                                </span>
                            </label>
                            
                            <label class="checkbox-container">
                                <input type="checkbox" name="notification_radius" value="yes" {if !isset($_c['notification_radius']) || $_c['notification_radius'] neq 'no'}checked{/if}>
                                <span class="checkbox-label">
                                    <strong>
                                        <i class="fas fa-server" style="color: #f59e0b; margin-right: 8px;"></i>
                                        Radius Customers
                                    </strong>
                                    <small class="text-muted" style="display: block; margin-top: 4px;">
                                        Enable notifications for Radius type customers. Includes all expiration, payment, and reminder notifications.
                                    </small>
                                </span>
                            </label>
                            
                            <label class="checkbox-container">
                                <input type="checkbox" name="notification_welcome_all" value="yes" {if !isset($_c['notification_welcome_all']) || $_c['notification_welcome_all'] neq 'no'}checked{/if}>
                                <span class="checkbox-label">
                                    <strong>
                                        <i class="fas fa-user-plus" style="color: #8b5cf6; margin-right: 8px;"></i>
                                        Welcome Messages
                                    </strong>
                                    <small class="text-muted" style="display: block; margin-top: 4px;">
                                        Send welcome messages to new customers regardless of their type. This overrides individual settings above.
                                    </small>
                                </span>
                            </label>
                        </div>
                    </div>
                    <p class="help-block col-md-4">
                        <i class="fas fa-info-circle" style="color: var(--primary-color); margin-right: 5px;"></i>
                        Select which customer types should receive notifications. If none are selected, notifications will be sent to all customer types by default.
                    </p>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Notification Priority')}</label>
                    <div class="col-md-5">
                        <select name="notification_priority" id="notification_priority" class="form-control">
                            <option value="all" {if !isset($_c['notification_priority']) || $_c['notification_priority']=='all'}selected{/if}>Send to All Enabled Types</option>
                            <option value="primary" {if $_c['notification_priority']=='primary'}selected{/if}>Only Primary Connection Type</option>
                            <option value="first_match" {if $_c['notification_priority']=='first_match'}selected{/if}>First Matching Type Only</option>
                        </select>
                    </div>
                    <p class="help-block col-md-4">
                        <i class="fas fa-exclamation-circle" style="color: var(--warning-color); margin-right: 5px;"></i>
                        Control how notifications are sent when customers have multiple connection types.
                    </p>
                </div>
                
                <div class="form-group">
                    <label class="col-md-3 control-label">{Lang::T('Enable Selective Notifications')}</label>
                    <div class="col-md-5">
                        <label class="switch">
                            <input type="checkbox" id="enable_selective_notifications" value="1" name="enable_selective_notifications" {if $_c['enable_selective_notifications']==1}checked{/if}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <p class="help-block col-md-4">
                        <i class="fas fa-toggle-on" style="color: var(--success-color); margin-right: 5px;"></i>
                        When enabled, notifications will only be sent to selected customer types above. When disabled, all customers receive notifications.
                    </p>
                </div>
                
                <div class="alert alert-info" style="margin-top: 20px; padding: 15px; border-left: 4px solid var(--primary-color); background: var(--primary-light);">
                    <div style="display: flex; align-items: flex-start; gap: 10px;">
                        <i class="fas fa-lightbulb" style="color: var(--primary-color); font-size: 18px; margin-top: 2px;"></i>
                        <div>
                            <strong>How it works:</strong>
                            <ul style="margin: 8px 0 0 0; padding-left: 20px; font-size: 13px;">
                                <li>This setting controls which customer types receive automated notifications</li>
                                <li>PPPoE: Customers using PPPoE connections</li>
                                <li>Hotspot: Customers using Hotspot/WiFi connections</li>
                                <li>Radius: Customers using Radius authentication</li>
                                <li>You can enable/disable notifications for each type independently</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <button class="btn btn-success btn-block" type="submit">
                    <i class="fas fa-save"></i> {Lang::T('Save Customer Type Settings')}
                </button>
            </div>
        </div>
    </div>

   </form>

<div class="row" style="margin-top: 30px;">
    <div class="col-md-12">
        <div class="pull-right text-muted">
            <small>
                <i class="fas fa-calendar"></i> 
                <strong>System Started:</strong> 
                {if $_c['system_start_date']}
                    {date('F j, Y', strtotime($_c['system_start_date']))}
                {else}
                    Not yet initialized
                {/if}
            </small>
        </div>
        <div class="clearfix"></div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Password toggle function
    window.togglePassword = function(id) {
        var input = document.getElementById(id);
        var icon = input.parentNode.querySelector('.fa-eye, .fa-eye-slash');
        if (input.type === 'password') {
            input.type = 'text';
            if (icon) {
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        } else {
            input.type = 'password';
            if (icon) {
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    };

    // Session timeout toggle
    var sessionTimeoutCheckbox = document.getElementById('enable_session_timeout');
    var timeoutDurationInput = document.getElementById('timeout_duration_input');
    
    if (sessionTimeoutCheckbox) {
        sessionTimeoutCheckbox.addEventListener('change', function() {
            if (this.checked) {
                timeoutDurationInput.style.display = 'block';
                document.getElementById('session_timeout_duration').required = true;
            } else {
                timeoutDurationInput.style.display = 'none';
                document.getElementById('session_timeout_duration').required = false;
            }
        });
    }

    // SMS Gateway toggle
    window.toggleSmsGateway = function() {
        var gatewayType = document.getElementById('sms_gateway_type').value;
        var sections = ['sms_url_section', 'africastalking_section', 'talksasa_section', 'umscomms_section'];
        
        sections.forEach(function(id) {
            var element = document.getElementById(id);
            if (element) {
                element.style.display = 'none';
            }
        });
        
        if (gatewayType === 'africastalking') {
            document.getElementById('africastalking_section').style.display = 'block';
        } else if (gatewayType === 'talksasa') {
            document.getElementById('talksasa_section').style.display = 'block';
        } else if (gatewayType === 'umscomms') {
            document.getElementById('umscomms_section').style.display = 'block';
        } else {
            document.getElementById('sms_url_section').style.display = 'block';
        }
    };
    
    var smsGatewaySelect = document.getElementById('sms_gateway_type');
    if (smsGatewaySelect) {
        smsGatewaySelect.addEventListener('change', toggleSmsGateway);
        toggleSmsGateway();
    }

    // Customer Type Notifications - Selective toggle
    var selectiveNotificationsCheckbox = document.getElementById('enable_selective_notifications');
    var notificationCheckboxes = document.querySelectorAll('input[name^="notification_"]');
    
    if (selectiveNotificationsCheckbox) {
        selectiveNotificationsCheckbox.addEventListener('change', function() {
            if (this.checked) {
                notificationCheckboxes.forEach(function(checkbox) {
                    checkbox.disabled = false;
                    if (checkbox.closest('.checkbox-container')) {
                        checkbox.closest('.checkbox-container').style.opacity = '1';
                    }
                });
            } else {
                notificationCheckboxes.forEach(function(checkbox) {
                    checkbox.disabled = true;
                    if (checkbox.closest('.checkbox-container')) {
                        checkbox.closest('.checkbox-container').style.opacity = '0.6';
                    }
                });
            }
        });
        
        // Initialize state
        if (selectiveNotificationsCheckbox.checked) {
            notificationCheckboxes.forEach(function(checkbox) {
                checkbox.disabled = false;
                if (checkbox.closest('.checkbox-container')) {
                    checkbox.closest('.checkbox-container').style.opacity = '1';
                }
            });
        } else {
            notificationCheckboxes.forEach(function(checkbox) {
                checkbox.disabled = true;
                if (checkbox.closest('.checkbox-container')) {
                    checkbox.closest('.checkbox-container').style.opacity = '0.6';
                }
            });
        }
    }

    // Collapse/Expand animation
    $('.panel-heading').click(function() {
        var icon = $(this).find('.collapse-icon');
        icon.toggleClass('fa-chevron-down fa-chevron-up');
    });

    // Form submission validation
    $('form').on('submit', function(e) {
        var sessionTimeoutCheckbox = document.getElementById('enable_session_timeout');
        if (sessionTimeoutCheckbox && sessionTimeoutCheckbox.checked) {
            var timeoutValue = document.getElementById('session_timeout_duration').value;
            if (!timeoutValue || timeoutValue < 1) {
                e.preventDefault();
                showToast('error', 'Validation Error', 'Please enter a valid session timeout duration (minimum 1 minute).');
                return false;
            }
        }
        
        // Validate at least one notification type is selected when selective notifications is enabled
        var selectiveNotificationsCheckbox = document.getElementById('enable_selective_notifications');
        var notificationCheckboxes = document.querySelectorAll('input[name^="notification_"]');
        
        if (selectiveNotificationsCheckbox && selectiveNotificationsCheckbox.checked) {
            var atLeastOneChecked = false;
            notificationCheckboxes.forEach(function(checkbox) {
                if (checkbox.checked && checkbox.name !== 'notification_welcome_all') {
                    atLeastOneChecked = true;
                }
            });
            
            if (!atLeastOneChecked) {
                e.preventDefault();
                showToast('warning', 'Notification Settings', 'Please select at least one customer type to receive notifications, or disable selective notifications.');
                return false;
            }
        }
    });

    // Initialize tooltips
    $('[data-toggle="tooltip"]').tooltip();
    
    // Check for test results in URL
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('testSms') || urlParams.has('testWa') || urlParams.has('testEmail') || urlParams.has('testTg')) {
        var testType = '';
        var success = urlParams.get('success');
        
        if (urlParams.has('testSms')) testType = 'SMS';
        if (urlParams.has('testWa')) testType = 'WhatsApp';
        if (urlParams.has('testEmail')) testType = 'Email';
        if (urlParams.has('testTg')) testType = 'Telegram';
        
        if (success === '1') {
            showToast('success', testType + ' Test Successful', 'Your test ' + testType + ' message has been sent successfully!');
        } else if (success === '0') {
            showToast('error', testType + ' Test Failed', 'Failed to send test ' + testType + ' message. Please check your configuration.');
        }
        
        // Clean URL
        window.history.replaceState({}, document.title, window.location.pathname + window.location.hash);
    }
});
// Toast notification function
function showToast(type, title, message) {
    var container = document.getElementById('toast-container');
    var toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    
    var icon = '';
    switch(type) {
        case 'success':
            icon = '<i class="fas fa-check-circle"></i>';
            break;
        case 'error':
            icon = '<i class="fas fa-exclamation-circle"></i>';
            break;
        case 'warning':
            icon = '<i class="fas fa-exclamation-triangle"></i>';
            break;
        case 'info':
            icon = '<i class="fas fa-info-circle"></i>';
            break;
    }
    
    // Use string concatenation instead of template literals to avoid Smarty parsing
    toast.innerHTML = icon + 
        '<div class="toast-content">' +
            '<div class="toast-title">' + title + '</div>' +
            '<div class="toast-message">' + message + '</div>' +
        '</div>' +
        '<i class="fas fa-times toast-close" onclick="this.parentElement.remove()"></i>';
    
    container.appendChild(toast);
    
    // Auto remove after 5 seconds
    setTimeout(function() {
        if (toast.parentNode) {
            toast.remove();
        }
    }, 5000);
}

// Test SMS Modal
function showTestSmsModal() {
    $('#testSmsModal').modal('show');
}

// Test WhatsApp Modal
function showTestWaModal() {
    $('#testWaModal').modal('show');
}

// Test Email Modal
function showTestEmailModal() {
    $('#testEmailModal').modal('show');
}

// Test Telegram Modal
function showTestTgModal() {
    $('#testTgModal').modal('show');
}

// Send Test SMS
function sendTestSms() {
    var phone = document.getElementById('test_phone_number').value;
    var message = document.getElementById('test_message').value;
    
    if (!phone) {
        showToast('error', 'Validation Error', 'Please enter a phone number');
        return;
    }
    
    if (!message) {
        showToast('error', 'Validation Error', 'Please enter a test message');
        return;
    }
    
    $('#testSmsModal').modal('hide');
    window.location.href = '{Text::url('settings/app&testSms=')}' + encodeURIComponent(phone) + '&message=' + encodeURIComponent(message);
}

// Send Test WhatsApp
function sendTestWa() {
    var phone = document.getElementById('test_wa_number').value;
    var message = document.getElementById('test_wa_message').value;
    
    if (!phone) {
        showToast('error', 'Validation Error', 'Please enter a phone number');
        return;
    }
    
    if (!message) {
        showToast('error', 'Validation Error', 'Please enter a test message');
        return;
    }
    
    $('#testWaModal').modal('hide');
    window.location.href = '{Text::url('settings/app&testWa=')}' + encodeURIComponent(phone) + '&message=' + encodeURIComponent(message);
}

// Send Test Email
function sendTestEmail() {
    var email = document.getElementById('test_email_address').value;
    var subject = document.getElementById('test_email_subject').value;
    var message = document.getElementById('test_email_message').value;
    
    if (!email) {
        showToast('error', 'Validation Error', 'Please enter an email address');
        return;
    }
    
    if (!subject) {
        showToast('error', 'Validation Error', 'Please enter an email subject');
        return;
    }
    
    if (!message) {
        showToast('error', 'Validation Error', 'Please enter a test message');
        return;
    }
    
    $('#testEmailModal').modal('hide');
    window.location.href = '{Text::url('settings/app&testEmail=')}' + encodeURIComponent(email) + '&subject=' + encodeURIComponent(subject) + '&message=' + encodeURIComponent(message);
}

// Send Test Telegram
function sendTestTg() {
    var chatId = document.getElementById('test_tg_chat_id').value;
    var message = document.getElementById('test_tg_message').value;
    
    if (!message) {
        showToast('error', 'Validation Error', 'Please enter a test message');
        return;
    }
    
    $('#testTgModal').modal('hide');
    
    var url = '{Text::url('settings/app&testTg=')}' + encodeURIComponent(message);
    if (chatId) {
        url += '&chat_id=' + encodeURIComponent(chatId);
    }
    
    window.location.href = url;
}
</script>

{include file="sections/footer.tpl"}
