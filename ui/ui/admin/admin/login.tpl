<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>{Lang::T('Login')} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="{$app_url}/ui/ui/images/logo.png" type="image/x-icon" />
    <link rel="stylesheet" href="{$app_url}/ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="{$app_url}/ui/ui/styles/modern-AdminLTE.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">

    <style>
        body {
            background: #ffffff;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
            overflow-x: hidden;
        }
        .login-box {
            width: 100%;
            max-width: 420px;
            margin: 60px auto 0 auto;
            position: relative;
        }
        .login-logo {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            text-align: center;
            margin-bottom: 32px;
            letter-spacing: -0.5px;
            position: relative;
        }
        
        .login-logo::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: #4299e1;
            border-radius: 2px;
        }
        .login-card {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05), 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 40px 36px 32px 36px;
            display: flex;
            flex-direction: column;
            align-items: stretch;
            position: static;
        }
        .login-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 32px;
            text-align: center;
            position: relative;
        }
        
        .login-title::before {
            content: '🔐';
            display: block;
            font-size: 2rem;
            margin-bottom: 8px;
        }
        .form-group {
            margin-bottom: 24px;
            position: relative;
        }
        
        .form-group label {
            position: absolute;
            top: 12px;
            left: 16px;
            font-size: 1rem;
            color: #a0aec0;
            pointer-events: none;
            transition: all 0.3s ease;
            background: transparent;
            padding: 0 4px;
        }
        
        .form-group input:focus + label,
        .form-group input:not(:placeholder-shown) + label {
            top: -8px;
            left: 12px;
            font-size: 0.875rem;
            color: #4299e1;
            background: rgba(255, 255, 255, 0.9);
        }
        .form-control {
            border-radius: 12px;
            font-size: 1rem;
            padding: 16px;
            border: 2px solid #e2e8f0;
            background: #fff;
            transition: all 0.3s ease;
            width: 100%;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #4299e1;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
            background: #fff;
        }
        
        .form-control:-webkit-autofill,
        .form-control:-webkit-autofill:hover,
        .form-control:-webkit-autofill:focus,
        .form-control:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px #fff inset !important;
            -webkit-text-fill-color: #2d3748 !important;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            padding: 16px 0;
            transition: background 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            text-transform: none;
            letter-spacing: 0.5px;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #3182ce 0%, #2c5282 100%);
            box-shadow: 0 4px 12px rgba(66, 153, 225, 0.3);
        }
        
        .btn-primary:active {
            background: linear-gradient(135deg, #2c5282 0%, #2a4365 100%);
        }
        
        .btn-primary.loading {
            pointer-events: none;
        }
        
        .btn-primary.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            margin: auto;
            border: 2px solid transparent;
            border-top-color: #fff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #4299e1;
            text-decoration: none;
            font-size: 0.98rem;
        }
        .back-link:hover {
            text-decoration: underline;
            color: #3182ce;
        }
        /* Popup styles */
        .popup-message {
            position: fixed;
            top: 32px;
            left: 50%;
            transform: translateX(-50%);
            min-width: 260px;
            max-width: 90vw;
            background: #fff;
            color: #222;
            border-radius: 8px;
            box-shadow: 0 4px 24px rgba(44, 62, 80, 0.18);
            padding: 18px 28px;
            font-size: 1rem;
            font-weight: 500;
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 10px;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s;
        }
        .popup-message.show {
            opacity: 1;
            pointer-events: auto;
        }
        .popup-message.success {
            border-left: 6px solid #4299e1;
        }
        .popup-message.error {
            border-left: 6px solid #e74c3c;
        }
        .popup-icon {
            font-size: 1.3em;
        }
        
        /* Mobile Responsiveness */
        @media (max-width: 480px) {
            body {
                padding: 16px;
            }
            
            .login-box {
                max-width: 100%;
            }
            
            .login-card {
                padding: 32px 24px 28px 24px;
                border-radius: 16px;
            }
            
            .login-logo {
                font-size: 2rem;
                margin-bottom: 24px;
            }
            
            .login-title {
                font-size: 1.25rem;
                margin-bottom: 28px;
            }
            
            .form-control {
                padding: 14px;
                font-size: 16px; /* Prevents zoom on iOS */
            }
        }
        
        /* Accessibility improvements */
        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
        
        /* Focus visible for keyboard navigation */
        .btn-primary:focus-visible {
            outline: 2px solid #4299e1;
            outline-offset: 2px;
        }
    </style>
</head>

<body>
    <div class="login-box">
        <div class="login-logo">
            {$_c['CompanyName']}
        </div>
        <div class="login-card">
            <div class="login-title">{Lang::T('Enter Admin Area')}</div>
            <form action="{Text::url('admin/post')}" method="post" autocomplete="on" id="loginForm">
                <input type="hidden" name="csrf_token" value="{$csrf_token}">
                <div class="form-group">
                    <input type="text" 
                           required 
                           class="form-control" 
                           name="username" 
                           id="username"
                           placeholder=" "
                           autocomplete="username"
                           aria-describedby="username-help">
                    <label for="username">{Lang::T('Username')}</label>
                </div>
                <div class="form-group">
                    <input type="password" 
                           required 
                           class="form-control" 
                           name="password" 
                           id="password"
                           placeholder=" "
                           autocomplete="current-password"
                           aria-describedby="password-help">
                    <label for="password">{Lang::T('Password')}</label>
                </div>
                <button type="submit" class="btn btn-primary btn-block" id="loginBtn">
                    <span class="btn-text">{Lang::T('Login')}</span>
                </button>
                <a href="{Text::url('login')}" class="back-link">{Lang::T('Go Back')}</a>
            </form>
        </div>
    </div>

    <!-- Popup Message -->
    <div id="popupMessage" class="popup-message">
        <span class="popup-icon" id="popupIcon"></span>
        <span id="popupText"></span>
    </div>

    <script>
        // Enhanced form handling with loading states
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('loginForm');
            const loginBtn = document.getElementById('loginBtn');
            const btnText = loginBtn.querySelector('.btn-text');
            
            // Form submission with loading state
            form.addEventListener('submit', function(e) {
                loginBtn.classList.add('loading');
                btnText.textContent = 'Signing in...';
                loginBtn.disabled = true;
            });
            
            // Auto-focus first empty field
            const username = document.getElementById('username');
            const password = document.getElementById('password');
            
            if (!username.value) {
                username.focus();
            } else if (!password.value) {
                password.focus();
            }
            
            // Enter key handling
            document.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    if (e.target === username && !password.value) {
                        password.focus();
                        e.preventDefault();
                    }
                }
            });
        });
        
        // Show popup if popup variable is set
        {if $popup}
            var popupHtml = `{$popup|escape:'html'}`;
            var isSuccess = popupHtml.toLowerCase().includes('success');
            var isError = popupHtml.toLowerCase().includes('invalid') || popupHtml.toLowerCase().includes('fail') || popupHtml.toLowerCase().includes('error');
            var popup = document.getElementById('popupMessage');
            var popupText = document.getElementById('popupText');
            var popupIcon = document.getElementById('popupIcon');
            popupText.innerHTML = popupHtml;
            if (isSuccess) {
                popup.classList.add('success');
                popupIcon.innerHTML = '✔️';
            } else if (isError) {
                popup.classList.add('error');
                popupIcon.innerHTML = '❌';
                // Reset form button on error
                setTimeout(function() {
                    const loginBtn = document.getElementById('loginBtn');
                    const btnText = loginBtn.querySelector('.btn-text');
                    if (loginBtn) {
                        loginBtn.classList.remove('loading');
                        btnText.textContent = '{Lang::T('Login')}';
                        loginBtn.disabled = false;
                    }
                }, 2000);
            } else {
                popupIcon.innerHTML = 'ℹ️';
            }
            popup.classList.add('show');
            setTimeout(function() {
                popup.classList.remove('show');
            }, 4000);
        {/if}
    </script>
</body>

</html>