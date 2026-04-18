{include file="sections/header.tpl"}

<style>
    .hotspot-settings-wrap .card {
        overflow: hidden;
    }

    .hotspot-settings-wrap #scriptContent {
        white-space: pre;
        overflow-x: auto;
        max-height: 380px;
    }

    @media (max-width: 767px) {
        .hotspot-settings-wrap .display-5 {
            font-size: 1.4rem;
        }
        .hotspot-settings-wrap .btn-group {
            width: 100%;
        }
        .hotspot-settings-wrap .btn-group .btn {
            width: 100%;
        }
    }

    /* Large-screen / TV readability */
    @media (min-width: 1600px) {
        .hotspot-settings-wrap .content-header h6 {
            font-size: 2rem;
        }
        .hotspot-settings-wrap .form-control,
        .hotspot-settings-wrap .btn,
        .hotspot-settings-wrap .list-group-item,
        .hotspot-settings-wrap .breadcrumb {
            font-size: 1.1rem;
        }
        .hotspot-settings-wrap #scriptContent {
            font-size: 1rem;
            line-height: 1.5;
            max-height: 500px;
        }
    }
</style>

<section class="content-header hotspot-settings-wrap">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h6 class="text-success fw-bold display-5 d-flex align-items-center">
            <i class="fa fa-wifi me-3"></i> Hotspot Settings
        </h6>

    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb bg-light p-3 rounded">
            <li class="breadcrumb-item"><a href="#">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Hotspot Settings</li>
        </ol>

<!-- Button groups for Hotspot Settings, Preview, and Download -->
<div class="d-flex gap-3 mb-3 flex-wrap">
    <!-- Original Login Page (download.php) -->
    <div class="btn-group">
        <button type="button" class="btn btn-success">
            <i class="fa fa-laptop"></i> Original Login Page
        </button>
        <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu" role="menu">
            <li>
                <a href="{$app_url}/download.php?preview=1" target="_blank">
                    <i class="fa fa-eye"></i> Preview Original Page
                </a>
            </li>
            <li>
                <a href="{$app_url}/download.php?download=1">
                    <i class="fa fa-download"></i> Download Original Page
                </a>
            </li>
        </ul>
    </div>

    <!-- Enhanced Login Page (download2.php)
    <div class="btn-group">
        <button type="button" class="btn btn-info">
            <i class="fa fa-magic"></i> Enhanced Login Page
        </button>
        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu" role="menu">
            <li>
                <a href="{$app_url}/download2.php?preview=1" target="_blank">
                    <i class="fa fa-eye"></i> Preview Enhanced Page
                </a>
            </li>
            <li>
                <a href="{$app_url}/download2.php?download=1">
                    <i class="fa fa-download"></i> Download Enhanced Page
                </a>
            </li>
        </ul>
    </div>-->
</div>
    </nav>
</section>


<section class="content hotspot-settings-wrap">
    <div class="row">
        <div class="col-md-12">
            <div class="card shadow-sm border-0">

                <div class="show" id="settingsForm">
                    <div class="card-body">
                        <form method="POST" action="" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label class="form-label"><i class="fa fa-header"></i> Hotspot Page Title</label>
                                <input type="text" class="form-control" name="hotspot_title" value="{$hotspot_title}"
                                    required placeholder="Hotspot Page Title">
                            </div>
                            
                                  <br>
                                  
                                   <!-- Faqs-->
            <div class="mb-3" id="faq-section">
                <label class="form-label"><i class="fa fa-question-circle"></i> Extra Information / Solution/ Suggestion</label>
                <input type="text" class="form-control mb-2" name="faq1" value="{$faq1|default:''}" placeholder="FAQ 1 or Info" required>
                
                <input type="text" class="form-control mb-2" name="faq2" value="{$faq2|default:''}" placeholder="FAQ 2 or Info" required>
                
                <input type="text" class="form-control mb-2" name="faq3" value="{$faq3|default:''}" placeholder="FAQ 3 or Info">
            </div>
            
                   <br>
                   
                            <!-- Phone number-->
<div class="mb-3">
    <label class="form-label"><i class="fa fa-phone"></i> Support Phone Number</label>
    <input type="text" class="form-control" name="phone" value="{$phone|default:''}" placeholder="Support Phone Number">
</div>
            
                <br>
                
                                  <!--Select router-->
                            <div class="mb-3">
                                <label class="form-label"><i class="fa fa-wifi"></i> Router</label>
                                <select class="form-control" name="router_id">
                                    <option value="">Select a router</option>
                                    {foreach $routers as $router}
                                        <option value="{$router.id}" {if $router.id eq $selected_router_id}selected{/if}>
                                            {$router.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            
                    <br>

                            <div class="text-end">
                                <button type="submit" class="btn btn-success"><i class="fa fa-save"></i> Save
                                    Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-info text-white">
                    <h3 class="mb-0"><i class="fa fa-info-circle"></i> Usage Instructions</h3>
                </div>
                <div class="card-body">
                    <ol class="list-group list-group-numbered">
                        <li class="list-group-item">Click "Save Changes" twice for quick upload.</li>
                        <li class="list-group-item">Customize and personalize your settings.</li>
                        <li class="list-group-item">Download the <code>login.html</code> file.</li>
                        <li class="list-group-item">Upload <code>login.html</code> to your MikroTik router.</li>
                        <li class="list-group-item">Upload it to `hotspot/login.html` (replace the current file).</li>
                        <li class="list-group-item">Ensure the file is named <strong>login.html</strong>.</li>
                        <li class="list-group-item">Add your website URL and CDN hosts to the MikroTik walled garden.</li>
                        <li class="list-group-item">
                            Copy and run this walled-garden script:
                            <pre id="scriptContent"
                                class="w-full p-3 border rounded-md text-sm bg-gray-50 overflow-auto">
/ip hotspot walled-garden ip
add server=hotspot1 dst-host={$_domain} action=accept
add server=hotspot1 dst-host=*.{$_domain} action=accept
add server=hotspot1 dst-host=.{$_domain} action=accept
add server=hotspot1 dst-host={$main_domain} action=accept
add server=hotspot1 dst-host=*.{$main_domain} action=accept
add server=hotspot1 dst-host=.{$main_domain} action=accept

/ip hotspot walled-garden ip
add server=hotspot1 dst-host=code.jquery.com action=accept
add server=hotspot1 dst-host=cdn.jsdelivr.net action=accept
add server=hotspot1 dst-host=cdnjs.cloudflare.com action=accept
add server=hotspot1 dst-host=fonts.googleapis.com action=accept
add server=hotspot1 dst-host=cdn.tailwindcss.com action=accept
add server=hotspot1 dst-host=ajax.googleapis.com action=accept
add server=hotspot1 dst-host=stackpath.bootstrapcdn.com action=accept
add server=hotspot1 dst-host=use.fontawesome.com action=accept
add server=hotspot1 dst-host=fonts.gstatic.com action=accept
                      </pre>
                        </li>

                        <li class="list-group-item border-0 px-0">
                            <button type="button" onclick="copyToClipboard()" class="btn btn-primary mt-2">
                                <i class="fa fa-copy"></i> Copy Script
                            </button>
                        </li>

                        <div class="mt-3">
                            <small class="text-muted">
                                <i class="fa fa-info-circle"></i> 
                                Note: Replace "hotspot1" with your actual hotspot server name if different. 
                                These CDN hosts ensure your login page loads properly with all styles and scripts.
                            </small>
                        </div>

                    </ol>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    function copyToClipboard() {
        const scriptContent = document.getElementById("scriptContent").innerText;

        navigator.clipboard.writeText(scriptContent).then(() => {
            Swal.fire({
                icon: "success",
                title: "Copied!",
                text: "Walled garden script with CDN hosts copied to clipboard!",
                timer: 2000,
                showConfirmButton: false
            });
        }).catch(err => {
            console.error("Failed to copy: ", err);
        });
    }

</script>


{include file="sections/footer.tpl"}
