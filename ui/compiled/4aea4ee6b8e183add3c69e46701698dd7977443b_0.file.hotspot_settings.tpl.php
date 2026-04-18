<?php
/* Smarty version 4.5.3, created on 2026-04-18 16:12:18
  from 'C:\Users\Administrator\Downloads\testing billing\system\plugin\ui\hotspot_settings.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e383322c0463_08130959',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '4aea4ee6b8e183add3c69e46701698dd7977443b' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\system\\plugin\\ui\\hotspot_settings.tpl',
      1 => 1776361424,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e383322c0463_08130959 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

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
                <a href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/download.php?preview=1" target="_blank">
                    <i class="fa fa-eye"></i> Preview Original Page
                </a>
            </li>
            <li>
                <a href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/download.php?download=1">
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
                <a href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/download2.php?preview=1" target="_blank">
                    <i class="fa fa-eye"></i> Preview Enhanced Page
                </a>
            </li>
            <li>
                <a href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/download2.php?download=1">
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
                                <input type="text" class="form-control" name="hotspot_title" value="<?php echo $_smarty_tpl->tpl_vars['hotspot_title']->value;?>
"
                                    required placeholder="Hotspot Page Title">
                            </div>
                            
                                  <br>
                                  
                                   <!-- Faqs-->
            <div class="mb-3" id="faq-section">
                <label class="form-label"><i class="fa fa-question-circle"></i> Extra Information / Solution/ Suggestion</label>
                <input type="text" class="form-control mb-2" name="faq1" value="<?php echo (($tmp = $_smarty_tpl->tpl_vars['faq1']->value ?? null)===null||$tmp==='' ? '' ?? null : $tmp);?>
" placeholder="FAQ 1 or Info" required>
                
                <input type="text" class="form-control mb-2" name="faq2" value="<?php echo (($tmp = $_smarty_tpl->tpl_vars['faq2']->value ?? null)===null||$tmp==='' ? '' ?? null : $tmp);?>
" placeholder="FAQ 2 or Info" required>
                
                <input type="text" class="form-control mb-2" name="faq3" value="<?php echo (($tmp = $_smarty_tpl->tpl_vars['faq3']->value ?? null)===null||$tmp==='' ? '' ?? null : $tmp);?>
" placeholder="FAQ 3 or Info">
            </div>
            
                   <br>
                   
                            <!-- Phone number-->
<div class="mb-3">
    <label class="form-label"><i class="fa fa-phone"></i> Support Phone Number</label>
    <input type="text" class="form-control" name="phone" value="<?php echo (($tmp = $_smarty_tpl->tpl_vars['phone']->value ?? null)===null||$tmp==='' ? '' ?? null : $tmp);?>
" placeholder="Support Phone Number">
</div>
            
                <br>
                
                                  <!--Select router-->
                            <div class="mb-3">
                                <label class="form-label"><i class="fa fa-wifi"></i> Router</label>
                                <select class="form-control" name="router_id">
                                    <option value="">Select a router</option>
                                    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['routers']->value, 'router');
$_smarty_tpl->tpl_vars['router']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['router']->value) {
$_smarty_tpl->tpl_vars['router']->do_else = false;
?>
                                        <option value="<?php echo $_smarty_tpl->tpl_vars['router']->value['id'];?>
" <?php if ($_smarty_tpl->tpl_vars['router']->value['id'] == $_smarty_tpl->tpl_vars['selected_router_id']->value) {?>selected<?php }?>>
                                            <?php echo $_smarty_tpl->tpl_vars['router']->value['name'];?>
</option>
                                    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
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
add server=hotspot1 dst-host=<?php echo $_smarty_tpl->tpl_vars['_domain']->value;?>
 action=accept
add server=hotspot1 dst-host=*.<?php echo $_smarty_tpl->tpl_vars['_domain']->value;?>
 action=accept
add server=hotspot1 dst-host=.<?php echo $_smarty_tpl->tpl_vars['_domain']->value;?>
 action=accept
add server=hotspot1 dst-host=<?php echo $_smarty_tpl->tpl_vars['main_domain']->value;?>
 action=accept
add server=hotspot1 dst-host=*.<?php echo $_smarty_tpl->tpl_vars['main_domain']->value;?>
 action=accept
add server=hotspot1 dst-host=.<?php echo $_smarty_tpl->tpl_vars['main_domain']->value;?>
 action=accept

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

<?php echo '<script'; ?>
>
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

<?php echo '</script'; ?>
>


<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
