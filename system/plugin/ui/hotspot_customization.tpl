{include file="sections/header.tpl"}

<style>
.hc-card          { border:none; border-radius:12px; box-shadow:0 4px 14px rgba(0,0,0,.08); margin-bottom:24px; }
.hc-card-header   { border-radius:12px 12px 0 0; padding:14px 20px; font-weight:600; font-size:1rem; }
.theme-card       { border:2px solid #e2e8f0; border-radius:10px; overflow:hidden; transition:border-color .2s, box-shadow .2s; }
.theme-card:hover { border-color:#ff9900; box-shadow:0 6px 20px rgba(255,153,0,.15); }
.theme-thumb      { width:100%; height:160px; object-fit:cover; background:#f8fafc; display:flex; align-items:center; justify-content:center; }
.theme-thumb img  { width:100%; height:160px; object-fit:cover; }
.theme-thumb .no-preview { color:#94a3b8; font-size:3rem; }
.file-tree        { font-family:monospace; font-size:.85rem; max-height:320px; overflow-y:auto; }
.file-tree .dir   { color:#f59e0b; font-weight:600; }
.file-tree .file  { color:#64748b; }
.badge-hotspot    { background:#10b981; color:#fff; font-size:.75rem; padding:3px 8px; border-radius:20px; }
</style>

<section class="content-header">
    <h4><i class="fa fa-paint-brush" style="color:#ff9900"></i> &nbsp;Hotspot Customization</h4>
    <ol class="breadcrumb">
        <li><a href="{$app_url}/?_route=dashboard">Home</a></li>
        <li class="active">Hotspot Customization</li>
    </ol>
</section>

<section class="content">

    {* ── Upload Theme ──────────────────────────────────────────────────────── *}
    <div class="panel panel-default hc-card">
        <div class="panel-heading hc-card-header" style="background:#ff9900;color:#fff;">
            <i class="fa fa-upload"></i> &nbsp;Upload Theme ZIP
        </div>
        <div class="panel-body">
            <form method="POST" action="{$app_url}/?_route=plugin/hotspot_customization"
                  enctype="multipart/form-data">
                <input type="hidden" name="_action" value="upload">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Theme Name <span class="text-danger">*</span></label>
                            <input type="text" name="theme_name" class="form-control"
                                   placeholder="e.g. My Dark Theme" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Description</label>
                            <input type="text" name="theme_desc" class="form-control"
                                   placeholder="Optional short description">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>ZIP File <span class="text-danger">*</span></label>
                            <input type="file" name="theme_zip" accept=".zip" required class="form-control">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>&nbsp;</label><br>
                            <button type="submit" class="btn btn-warning btn-block">
                                <i class="fa fa-upload"></i> Upload
                            </button>
                        </div>
                    </div>
                </div>
                <p class="help-block" style="margin-top:-8px;">
                    <i class="fa fa-info-circle"></i>
                    ZIP must contain <code>login.html</code> at root level. Optional: include
                    <code>preview.png</code> for a thumbnail.
                </p>
            </form>
        </div>
    </div>

    {* ── Router & File Browser ────────────────────────────────────────────── *}
    <div class="panel panel-default hc-card">
        <div class="panel-heading hc-card-header" style="background:#3b82f6;color:#fff;">
            <i class="fa fa-router"></i> &nbsp;Router File Browser
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Select Router</label>
                        <select id="browserRouter" class="form-control">
                            <option value="">-- choose a router --</option>
                            {foreach $routers as $r}
                                <option value="{$r.id}"
                                    {if $r.id eq $selected_router_id}selected{/if}>
                                    {$r.name} ({$r.ip_address})
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <button id="btnBrowse" class="btn btn-primary" onclick="loadRouterFiles()">
                        <i class="fa fa-folder-open"></i> Load Router Files
                    </button>
                </div>
                <div class="col-md-8">
                    <div id="browseResult" style="display:none">
                        <div class="row">
                            <div class="col-md-6">
                                <label><i class="fa fa-folder" style="color:#f59e0b"></i> Files on Router</label>
                                <div id="fileTree" class="file-tree border rounded p-2"></div>
                            </div>
                            <div class="col-md-6">
                                <label><i class="fa fa-list" style="color:#10b981"></i> Hotspot Profiles</label>
                                <table class="table table-condensed table-bordered" id="profileTable">
                                    <thead><tr><th>Profile</th><th>Current HTML Dir</th></tr></thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div id="browseLoading" style="display:none;text-align:center;padding:30px;">
                        <i class="fa fa-spinner fa-spin fa-2x"></i><br>Connecting to router…
                    </div>
                    <div id="browseError" class="alert alert-danger" style="display:none"></div>
                </div>
            </div>
        </div>
    </div>

    {* ── Theme Gallery ────────────────────────────────────────────────────── *}
    <div class="panel panel-default hc-card">
        <div class="panel-heading hc-card-header" style="background:#1e293b;color:#fff;">
            <i class="fa fa-th-large"></i> &nbsp;Theme Gallery
            {if count($themes) > 0}
                <span class="badge" style="background:#ff9900;margin-left:8px;">{count($themes)}</span>
            {/if}
        </div>
        <div class="panel-body">
            {if count($themes) == 0}
                <div class="text-center text-muted" style="padding:40px;">
                    <i class="fa fa-paint-brush fa-3x" style="margin-bottom:12px;"></i>
                    <p>No themes uploaded yet. Use the form above to upload your first theme.</p>
                </div>
            {else}
                <div class="row">
                    {foreach $themes as $t}
                        <div class="col-md-3 col-sm-6" style="margin-bottom:20px;">
                            <div class="theme-card">
                                <div class="theme-thumb">
                                    {if $t.preview_img neq ''}
                                        <img src="{$app_url}/upload/hotspot_themes/{$t.slug}/{$t.preview_img}"
                                             alt="{$t.name}">
                                    {else}
                                        <div class="no-preview" style="text-align:center;padding:40px;">
                                            <i class="fa fa-image"></i>
                                        </div>
                                    {/if}
                                </div>
                                <div style="padding:12px;">
                                    <strong>{$t.name}</strong>
                                    {if $t.description neq ''}
                                        <p class="text-muted" style="font-size:.82rem;margin:4px 0 8px;">
                                            {$t.description}
                                        </p>
                                    {/if}
                                    <p style="font-size:.78rem;color:#94a3b8;margin-bottom:10px;">
                                        Uploaded: {$t.created_at}
                                    </p>
                                    <div class="btn-group btn-group-sm btn-block">
                                        <button class="btn btn-success"
                                            onclick="openApplyModal({$t.id}, '{$t.name|escape:javascript}')">
                                            <i class="fa fa-check"></i> Apply
                                        </button>
                                        <a href="{$app_url}/?_route=plugin/hotspot_customization&action=delete&id={$t.id}"
                                           class="btn btn-danger"
                                           onclick="return confirm('Delete theme {$t.name|escape:javascript}?')">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {/if}
        </div>
    </div>

</section>

{* ── Apply Modal ────────────────────────────────────────────────────────────── *}
<div class="modal fade" id="applyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="POST" action="{$app_url}/?_route=plugin/hotspot_customization">
                <input type="hidden" name="_action"  value="apply">
                <input type="hidden" name="theme_id" id="modalThemeId" value="">
                <div class="modal-header" style="background:#ff9900;color:#fff;border-radius:4px 4px 0 0;">
                    <button type="button" class="close" data-dismiss="modal"
                            style="color:#fff;opacity:1;">&times;</button>
                    <h4 class="modal-title">
                        <i class="fa fa-bolt"></i> Apply Theme: <span id="modalThemeName"></span>
                    </h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label><i class="fa fa-wifi"></i> Router <span class="text-danger">*</span></label>
                        <select name="router_id" id="modalRouter" class="form-control"
                                onchange="loadProfiles(this.value)">
                            <option value="">-- select router --</option>
                            {foreach $routers as $r}
                                <option value="{$r.id}"
                                    {if $r.id eq $selected_router_id}selected{/if}>
                                    {$r.name} ({$r.ip_address})
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fa fa-list"></i> Hotspot Profile <span class="text-danger">*</span></label>
                        <select name="hs_profile" id="modalProfile" class="form-control">
                            <option value="default">default</option>
                        </select>
                        <p class="help-block">
                            Load router files above to populate real profiles, or type <code>default</code>.
                        </p>
                    </div>
                    <div class="alert alert-info" style="font-size:.88rem;">
                        <i class="fa fa-info-circle"></i>
                        <strong>What happens:</strong>
                        <ol style="margin:6px 0 0 16px;padding:0;">
                            <li>Theme files are uploaded via FTP to <code>hotspot/theme_name/</code> on the router.</li>
                            <li>The selected hotspot profile's <code>html-directory</code> is updated via RouterOS API.</li>
                            <li>Changes take effect immediately — no router reboot needed.</li>
                        </ol>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fa fa-bolt"></i> Apply to Router
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function loadRouterFiles() {
    var routerId = document.getElementById('browserRouter').value;
    if (!routerId) { alert('Please select a router first.'); return; }

    document.getElementById('browseResult').style.display  = 'none';
    document.getElementById('browseError').style.display   = 'none';
    document.getElementById('browseLoading').style.display = 'block';

    fetch(appUrl + '/?_route=plugin/hotspot_customization&action=browse&router_id=' + routerId)
        .then(function(r){ return r.json(); })
        .then(function(data){
            document.getElementById('browseLoading').style.display = 'none';
            if (data.error) {
                document.getElementById('browseError').innerText = data.error;
                document.getElementById('browseError').style.display = 'block';
                return;
            }
            renderFiles(data.files || []);
            renderProfiles(data.profiles || []);
            document.getElementById('browseResult').style.display = 'block';
        })
        .catch(function(e){
            document.getElementById('browseLoading').style.display = 'none';
            document.getElementById('browseError').innerText = 'Connection error: ' + e.message;
            document.getElementById('browseError').style.display = 'block';
        });
}

function renderFiles(files) {
    var html = '';
    if (files.length === 0) { html = '<em class="text-muted">No files found</em>'; }
    files.forEach(function(f){
        var icon  = f.type === 'directory' ? '📁' : '📄';
        var cls   = f.type === 'directory' ? 'dir' : 'file';
        var size  = f.size ? ' <small style="color:#94a3b8">(' + f.size + ' B)</small>' : '';
        html += '<div class="' + cls + '">' + icon + ' ' + f.name + size + '</div>';
    });
    document.getElementById('fileTree').innerHTML = html;
}

function renderProfiles(profiles) {
    var tbody = document.querySelector('#profileTable tbody');
    tbody.innerHTML = '';
    if (profiles.length === 0) {
        tbody.innerHTML = '<tr><td colspan="2" class="text-muted text-center">None found</td></tr>';
        return;
    }
    profiles.forEach(function(p){
        tbody.innerHTML += '<tr><td><strong>' + p.name + '</strong></td>' +
                           '<td><code>' + (p['html-directory'] || '—') + '</code></td></tr>';
    });
    // Also pre-populate the modal profile dropdown
    var sel = document.getElementById('modalProfile');
    sel.innerHTML = '';
    profiles.forEach(function(p){
        var opt = document.createElement('option');
        opt.value = p.name;
        opt.text  = p.name + (p['html-directory'] ? ' [' + p['html-directory'] + ']' : '');
        sel.appendChild(opt);
    });
}

function openApplyModal(themeId, themeName) {
    document.getElementById('modalThemeId').value    = themeId;
    document.getElementById('modalThemeName').innerText = themeName;
    // Auto-load profiles for whichever router is already selected in the browser panel
    var browserId = document.getElementById('browserRouter').value;
    if (browserId) {
        document.getElementById('modalRouter').value = browserId;
        loadProfiles(browserId);
    }
    jQuery('#applyModal').modal('show');
}

function loadProfiles(routerId) {
    if (!routerId) return;
    fetch(appUrl + '/?_route=plugin/hotspot_customization&action=browse&router_id=' + routerId)
        .then(function(r){ return r.json(); })
        .then(function(data){
            if (data.profiles) { renderProfiles(data.profiles); }
        });
}
</script>

{include file="sections/footer.tpl"}
