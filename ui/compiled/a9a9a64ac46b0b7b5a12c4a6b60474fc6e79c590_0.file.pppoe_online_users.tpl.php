<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:23:52
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\system\plugin\ui\pppoe_online_users.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e226587f3922_67626595',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'a9a9a64ac46b0b7b5a12c4a6b60474fc6e79c590' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\system\\plugin\\ui\\pppoe_online_users.tpl',
      1 => 1776361426,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e226587f3922_67626595 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title" style="display:inline-block;"><?php echo Lang::T('PPPoE_Online_Users');?>
</h3>
                <span class="label label-success" id="pppoe-online-badge" style="margin-left:8px; font-size:12px;">0 <?php echo Lang::T('Online');?>
</span>
            </div>
            <div class="panel-body">
                <?php if ($_smarty_tpl->tpl_vars['routers']->value) {?>
                <ul class="nav nav-tabs" style="margin-bottom:15px;">
                    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['routers']->value, 'r');
$_smarty_tpl->tpl_vars['r']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['r']->value) {
$_smarty_tpl->tpl_vars['r']->do_else = false;
?>
                    <li role="presentation"<?php if ($_smarty_tpl->tpl_vars['r']->value['id'] == $_smarty_tpl->tpl_vars['router']->value) {?> class="active"<?php }?>>
                        <a href="<?php echo $_smarty_tpl->tpl_vars['_url']->value;?>
plugin/pppoe_online_users/<?php echo $_smarty_tpl->tpl_vars['r']->value['id'];?>
"><?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['r']->value['name'], ENT_QUOTES, 'UTF-8', true);?>
</a>
                    </li>
                    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                </ul>
                <div class="form-group" style="max-width:420px;">
                    <label class="sr-only" for="pppoe-search-input"><?php echo Lang::T('Search');?>
</label>
                    <input type="search" id="pppoe-search-input" class="form-control"
                        placeholder="<?php echo Lang::T('Search_PPPoE_Online_placeholder');?>
"
                        autocomplete="off">
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover" id="pppoe-online-table" style="width:100%;">
                        <thead>
                            <tr>
                                <th style="width:50px;">#</th>
                                <th><?php echo Lang::T('Full_Name');?>
</th>
                                <th><?php echo Lang::T('Username');?>
</th>
                                <th><?php echo Lang::T('IP_Address');?>
</th>
                                <th><?php echo Lang::T('Mac_Address');?>
</th>
                                <th><?php echo Lang::T('Uptime');?>
</th>
                                <th><?php echo Lang::T('Service');?>
</th>
                                <th><?php echo Lang::T('Download__TX_');?>
</th>
                                <th><?php echo Lang::T('Upload__RX_');?>
</th>
                                <th><?php echo Lang::T('Total_Usage');?>
</th>
                                <th style="min-width:150px;"><?php echo Lang::T('Live_traffic');?>
</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <?php } else { ?>
                <p class="text-muted"><?php echo Lang::T('Router_not_found');?>
</p>
                <?php }?>
            </div>
        </div>
    </div>
</div>

<?php if ($_smarty_tpl->tpl_vars['routers']->value) {?>
<div class="modal fade" id="pppoe-user-modal" tabindex="-1" role="dialog" aria-labelledby="pppoe-user-modal-title">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo Lang::T('Close');?>
"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="pppoe-user-modal-title">—</h4>
            </div>
            <div class="modal-body">
                <p class="text-muted small" id="pppoe-user-modal-meta"></p>
                <div class="alert alert-warning alert-sm" id="pppoe-user-modal-no-customer" style="display:none;padding:8px 12px;">
                    <i class="fa fa-info-circle"></i> <span id="pppoe-user-modal-no-customer-txt"></span>
                </div>
                <p class="small text-uppercase text-muted" style="margin-bottom:6px;"><?php echo Lang::T('Live_traffic');?>
</p>
                <div id="pppoe-modal-chart-wrap">
                    <canvas id="pppoe-modal-chart-canvas"></canvas>
                </div>
            </div>
            <div class="modal-footer">
                <a href="#" class="btn btn-success" id="pppoe-user-modal-view-btn" style="display:none;">
                    <i class="fa fa-user"></i> <span class="pppoe-modal-view-label"><?php echo Lang::T('View');?>
</span>
                </a>
                <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo Lang::T('Close');?>
</button>
            </div>
        </div>
    </div>
</div>
<?php }?>

<?php if ($_smarty_tpl->tpl_vars['routers']->value) {
$_smarty_tpl->smarty->ext->_capture->open($_smarty_tpl, 'default', 'xfooter', null);
echo '<script'; ?>
 src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
>
(function () {
    var routerId = <?php echo $_smarty_tpl->tpl_vars['pppoe_ou_router']->value;?>
;
    var i18n = <?php echo $_smarty_tpl->tpl_vars['pppoe_ou_i18n']->value;?>
;
    var url = '<?php echo $_smarty_tpl->tpl_vars['_url']->value;?>
plugin/pppoe_online_users_json/' + encodeURIComponent(routerId);
    var POLL_MS = 5000;
    var MAX_POINTS = 36;
    var pppoeTrafficHistory = {};
    var pppoeCharts = {};
    var routeBase = '<?php echo strtr((string)$_smarty_tpl->tpl_vars['_url']->value, array("\\" => "\\\\", "'" => "\\'", "\"" => "\\\"", "\r" => "\\r", 
                       "\n" => "\\n", "</" => "<\/", "<!--" => "<\!--", "<s" => "<\s", "<S" => "<\S",
                       "`" => "\\`", "\${" => "\\\$\{"));?>
';
    var pppoeModalUsername = null;
    var pppoeModalChart = null;

    function pppoeDestroyCharts() {
        Object.keys(pppoeCharts).forEach(function (k) {
            try {
                if (pppoeCharts[k]) {
                    pppoeCharts[k].destroy();
                }
            } catch (e) { /* ignore */ }
            delete pppoeCharts[k];
        });
    }

    function pppoeFmtRate(bps) {
        // bps is bytes per second; convert to bits/s and auto-pick unit
        var bitsPerSec = Math.max(0, bps) * 8;
        if (bitsPerSec >= 1000000) {
            return (bitsPerSec / 1000000).toFixed(2) + ' Mbps';
        }
        return (bitsPerSec / 1000).toFixed(2) + ' Kbps';
    }

    function pppoeUpdateHistory(rows, now) {
        var present = {};
        rows.forEach(function (row) {
            var u = row.username;
            if (!u) {
                return;
            }
            present[u] = true;
            var txb = parseInt(row.tx_bytes, 10) || 0;
            var rxb = parseInt(row.rx_bytes, 10) || 0;
            var h = pppoeTrafficHistory[u];
            var dl = 0;
            var ul = 0;
            if (h && h.lastTs) {
                var dt = (now - h.lastTs) / 1000;
                if (dt > 0.2) {
                    if (txb >= h.txb) {
                        dl = (txb - h.txb) / dt;
                    }
                    if (rxb >= h.rxb) {
                        ul = (rxb - h.rxb) / dt;
                    }
                }
            }
            if (!pppoeTrafficHistory[u]) {
                pppoeTrafficHistory[u] = { dl: [], ul: [] };
            }
            var hist = pppoeTrafficHistory[u];
            hist.dl.push(dl);
            hist.ul.push(ul);
            while (hist.dl.length > MAX_POINTS) {
                hist.dl.shift();
                hist.ul.shift();
            }
            hist.txb = txb;
            hist.rxb = rxb;
            hist.lastTs = now;
        });
        Object.keys(pppoeTrafficHistory).forEach(function (u) {
            if (!present[u]) {
                delete pppoeTrafficHistory[u];
            }
        });
    }

    function destroyPppoeModalChart() {
        if (pppoeModalChart) {
            try {
                pppoeModalChart.destroy();
            } catch (e) { /* ignore */ }
            pppoeModalChart = null;
        }
    }

    function openPppoeModal(d) {
        pppoeModalUsername = d.username;
        var title = d.username;
        if (d.fullname && d.fullname !== '—') {
            title = d.username + ' — ' + d.fullname;
        }
        $('#pppoe-user-modal-title').text(title);
        $('#pppoe-user-modal-meta').text([d.address, d.caller_id, d.uptime].filter(Boolean).join(' · '));
        var hasCustomer = d.customer_id != null && d.customer_id > 0;
        $('#pppoe-user-modal-no-customer').toggle(!hasCustomer);
        $('#pppoe-user-modal-no-customer-txt').text(i18n.noLinkedCustomer);
        var $vbtn = $('#pppoe-user-modal-view-btn');
        if (hasCustomer) {
            $vbtn.attr('href', routeBase + 'customers/view/' + encodeURIComponent(String(d.customer_id))).show();
        } else {
            $vbtn.hide().attr('href', '#');
        }
        destroyPppoeModalChart();
        var canvas = document.getElementById('pppoe-modal-chart-canvas');
        if (!canvas || typeof Chart === 'undefined') {
            $('#pppoe-user-modal').modal('show');
            return;
        }
        var hist = pppoeTrafficHistory[d.username];
        var dl = (hist && hist.dl.length) ? hist.dl.slice() : [0];
        var ul = (hist && hist.ul.length) ? hist.ul.slice() : [0];
        var labels = dl.map(function (_, i) {
            return String(i + 1);
        });
        pppoeModalChart = new Chart(canvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'DL',
                        data: dl,
                        borderColor: 'rgba(40, 167, 69, 0.95)',
                        backgroundColor: 'rgba(40, 167, 69, 0.12)',
                        fill: true,
                        tension: 0.35,
                        pointRadius: 0,
                        borderWidth: 2
                    },
                    {
                        label: 'UL',
                        data: ul,
                        borderColor: 'rgba(0, 123, 255, 0.95)',
                        backgroundColor: 'rgba(0, 123, 255, 0.12)',
                        fill: true,
                        tension: 0.35,
                        pointRadius: 0,
                        borderWidth: 2
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: false,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: { boxWidth: 12, font: { size: 11 } }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (ctx) {
                                var v = ctx.parsed.y;
                                if (v === null || v === undefined) {
                                    return '';
                                }
                                return ctx.dataset.label + ': ' + pppoeFmtRate(v);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        display: true,
                        title: { display: false },
                        ticks: { maxTicksLimit: 8, font: { size: 10 } }
                    },
                    y: {
                        display: true,
                        beginAtZero: true,
                        ticks: {
                            maxTicksLimit: 6,
                            font: { size: 10 },
                            callback: function (v) {
                                return pppoeFmtRate(v);
                            }
                        }
                    }
                }
            }
        });
        $('#pppoe-user-modal').modal('show');
    }

    function syncPppoeModalChart() {
        if (!pppoeModalUsername || !pppoeModalChart) {
            return;
        }
        var hist = pppoeTrafficHistory[pppoeModalUsername];
        if (!hist || !hist.dl.length) {
            return;
        }
        pppoeModalChart.data.datasets[0].data = hist.dl.slice();
        pppoeModalChart.data.datasets[1].data = hist.ul.slice();
        pppoeModalChart.data.labels = hist.dl.map(function (_, i) {
            return String(i + 1);
        });
        pppoeModalChart.update('none');
    }

    function updatePppoeModalMeta(rows) {
        if (!pppoeModalUsername) {
            return;
        }
        var found = null;
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].username === pppoeModalUsername) {
                found = rows[i];
                break;
            }
        }
        if (found) {
            $('#pppoe-user-modal-meta').text([found.address, found.caller_id, found.uptime].filter(Boolean).join(' · '));
            var hasCustomer = found.customer_id != null && found.customer_id > 0;
            $('#pppoe-user-modal-no-customer').toggle(!hasCustomer);
            $('#pppoe-user-modal-no-customer-txt').text(i18n.noLinkedCustomer);
            var $vbtn = $('#pppoe-user-modal-view-btn');
            if (hasCustomer) {
                $vbtn.attr('href', routeBase + 'customers/view/' + encodeURIComponent(String(found.customer_id))).show();
            } else {
                $vbtn.hide().attr('href', '#');
            }
        } else if ($('#pppoe-user-modal').hasClass('in')) {
            $('#pppoe-user-modal-meta').text(i18n.sessionEnded);
        }
    }

    var table = $('#pppoe-online-table').DataTable({
        columns: [
            { data: 'row' },
            { data: 'fullname' },
            { data: 'username' },
            { data: 'address' },
            { data: 'caller_id' },
            { data: 'uptime' },
            { data: 'service' },
            { data: 'tx' },
            { data: 'rx' },
            { data: 'total' },
            {
                data: null,
                orderable: false,
                searchable: false,
                className: 'pppoe-live-cell',
                render: function () {
                    return '<div class="pppoe-live-wrap"><canvas class="pppoe-live-canvas" aria-hidden="true"></canvas></div>';
                }
            }
        ],
        order: [[0, 'asc']],
        paging: true,
        pageLength: 25,
        searching: true,
        info: true,
        language: {
            search: '',
            emptyTable: i18n.empty,
            zeroRecords: i18n.empty
        },
        dom: 'rtip',
        drawCallback: function () {
            pppoeDestroyCharts();
            if (typeof Chart === 'undefined') {
                return;
            }
            var api = this.api();
            api.rows({ page: 'current' }).every(function () {
                var d = this.data();
                var node = this.node();
                if (!d || !d.username || !node) {
                    return;
                }
                var canvas = node.querySelector('canvas.pppoe-live-canvas');
                if (!canvas) {
                    return;
                }
                var hist = pppoeTrafficHistory[d.username];
                var dl = (hist && hist.dl.length) ? hist.dl.slice() : [0];
                var ul = (hist && hist.ul.length) ? hist.ul.slice() : [0];
                var labels = dl.map(function (_, i) {
                    return String(i + 1);
                });
                pppoeCharts[d.username] = new Chart(canvas.getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            {
                                label: 'DL',
                                data: dl,
                                borderColor: 'rgba(40, 167, 69, 0.95)',
                                backgroundColor: 'rgba(40, 167, 69, 0.12)',
                                fill: true,
                                tension: 0.35,
                                pointRadius: 0,
                                borderWidth: 1.5
                            },
                            {
                                label: 'UL',
                                data: ul,
                                borderColor: 'rgba(0, 123, 255, 0.95)',
                                backgroundColor: 'rgba(0, 123, 255, 0.12)',
                                fill: true,
                                tension: 0.35,
                                pointRadius: 0,
                                borderWidth: 1.5
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: false,
                        interaction: { mode: 'index', intersect: false },
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function (ctx) {
                                        var v = ctx.parsed.y;
                                        if (v === null || v === undefined) {
                                            return '';
                                        }
                                        return ctx.dataset.label + ': ' + pppoeFmtRate(v);
                                    }
                                }
                            }
                        },
                        scales: {
                            x: { display: false },
                            y: {
                                display: false,
                                beginAtZero: true
                            }
                        }
                    }
                });
            });
        }
    });

    $('#pppoe-search-input').on('keyup change', function () {
        table.search(this.value).draw();
    });

    $('#pppoe-online-table tbody').on('click', 'tr', function () {
        var d = table.row(this).data();
        if (!d || !d.username) {
            return;
        }
        openPppoeModal(d);
    });

    $('#pppoe-user-modal').on('hidden.bs.modal', function () {
        pppoeModalUsername = null;
        destroyPppoeModalChart();
    });

    function refresh() {
        $.getJSON(url)
            .done(function (rows) {
                var n = rows.length;
                var now = Date.now();
                pppoeUpdateHistory(rows, now);
                $('#pppoe-online-badge').text(n + ' ' + i18n.online);
                table.clear();
                table.rows.add(rows).draw(false);
                updatePppoeModalMeta(rows);
                syncPppoeModalChart();
            })
            .fail(function () {
                $('#pppoe-online-badge').text('0 ' + i18n.online);
                pppoeTrafficHistory = {};
                pppoeDestroyCharts();
                destroyPppoeModalChart();
                pppoeModalUsername = null;
                table.clear().draw();
            });
    }

    refresh();
    setInterval(refresh, POLL_MS);
})();
<?php echo '</script'; ?>
>
<?php $_smarty_tpl->smarty->ext->_capture->close($_smarty_tpl);
}?>

<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
