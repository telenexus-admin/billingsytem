<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>{$_title} - {Lang::T('Payment Page')}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">
    <link rel="stylesheet" href="ui/ui/styles/professional-theme.css?2025.2.6" />
    <link rel="stylesheet" href="ui/ui/styles/sweetalert2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/plugins/pace.css" />
    <script src="ui/ui/scripts/sweetalert2.all.min.js"></script>
    <style>
        .thank-you-container {
            text-align: center;
            margin-top: 50px;
        }

        .bouncing-balls {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100px;
        }

        .ball {
            width: 20px;
            height: 20px;
            margin: 0 5px;
            border-radius: 50%;
            display: inline-block;
            animation: bounce 0.6s infinite alternate;
        }

        .ball:nth-child(1) {
            background-color: #ff5733;
            animation-delay: 0s;
        }

        .ball:nth-child(2) {
            background-color: #33ff57;
            animation-delay: 0.2s;
        }

        .ball:nth-child(3) {
            background-color: #3357ff;
            animation-delay: 0.4s;
        }

        .ball:nth-child(4) {
            background-color: #f0f;
            animation-delay: 0.6s;
        }

        .ball:nth-child(5) {
            background-color: #0ff;
            animation-delay: 0.8s;
        }

        @keyframes bounce {
            to {
                transform: translateY(-100%);
            }
        }

        .thank-you-container h1 {
            margin-top: 20px;
            color: #28a745;
            font-size: 24px;
        }

        .countdown-timer {
            font-size: 18px;
            color: #555;
        }

        @media screen and (max-width: 600px) {
            .thank-you-container {
                margin-top: 30px;
            }

            .bouncing-balls {
                height: 80px;
            }

            .ball {
                width: 15px;
                height: 15px;
                margin: 0 3px;
            }

            .thank-you-container h1 {
                font-size: 20px;
            }

            .countdown-timer {
                font-size: 16px;
            }

            .btn {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>

<body class="hold-transition login-page">
    {if isset($notify)}
    <script>
      // Display SweetAlert toast notification
      Swal.fire({
        icon: '{if $notify_t == "s"}success{else}error{/if}',
        title: '{$notify}',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 5000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener('mouseenter', Swal.stopTimer)
          toast.addEventListener('mouseleave', Swal.resumeTimer)
        }
      });
    </script>
    {/if}
    <div class="login-box">
        <div class="login-logo">
            <a href=""><b> {$companyName}</b></a>
        </div>
        {if $msg}
        <div class="callout callout-info" style="margin-bottom: 0!important;">
            {$msg}
        </div><br>
        {/if}

        <div class="thank-you-container">
            <div class="bouncing-balls">
                <div class="ball"></div>
                <div class="ball"></div>
                <div class="ball"></div>
                <div class="ball"></div>
                <div class="ball"></div>
            </div>
            <h1>Please wait while your transaction is proccessing</h1>
        </div>
        <br>
        <div class="login-box-body">
            <center>
                <div class="countdown-timer" id="countdown">Page will refresh in 5 seconds...</div>
            </center>
            <br>
            <div class="box-body">
                <a href="#" class="btn btn-block btn-success btn-flat" onclick="location.reload();">{Lang::T('Refresh')}</a>
            </div>
        </div>
    </div>

    <script src="ui/ui/scripts/jquery.min.js"></script>
    <script src="ui/ui/scripts/bootstrap.min.js"></script>
    <script src="ui/ui/scripts/adminlte.min.js"></script>
    <script src="ui/ui/scripts/plugins/select2.min.js"></script>
    <script src="ui/ui/scripts/pace.min.js"></script>
    <script src="ui/ui/scripts/custom.js"></script>

    <script>
        // Countdown timer
        var seconds = 5;
        function countdown() {
            var timer = setInterval(function () {
                seconds--;
                document.getElementById("countdown").innerHTML = "Page will refresh in " + seconds + " seconds...";
                if (seconds <= 0) {
                    clearInterval(timer);
                    window.location.reload();
                }
            }, 1000);
        }
        countdown();
    </script>
</body>

</html>
