{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title" style="display:inline-block;">{Lang::T('PPPoE_Online_Users')}</h3>
                <span class="label label-success" id="pppoe-online-badge" style="margin-left:8px; font-size:12px;">0 {Lang::T('Online')}</span>
            </div>
            <div class="panel-body">
                {if $routers}
                <ul class="nav nav-tabs" style="margin-bottom:15px;">
                    {foreach $routers as $r}
                    <li role="presentation"{if $r.id == $router} class="active"{/if}>
                        <a href="{$_url}plugin/pppoe_online_users/{$r.id}">{$r.name|escape:'html'}</a>
                    </li>
                    {/foreach}
                </ul>
                <div class="form-group" style="max-width:420px;">
                    <label class="sr-only" for="pppoe-search-input">{Lang::T('Search')}</label>
                    <input type="search" id="pppoe-search-input" class="form-control"
                        placeholder="{Lang::T('Search_PPPoE_Online_placeholder')}"
                        autocomplete="off">
                </div>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover" id="pppoe-online-table" style="width:100%;">
                        <thead>
                            <tr>
                                <th style="width:50px;">#</th>
                                <th>{Lang::T('Full_Name')}</th>
                                <th>{Lang::T('Username')}</th>
                                <th>{Lang::T('IP_Address')}</th>
                                <th>{Lang::T('Mac_Address')}</th>
                                <th>{Lang::T('Uptime')}</th>
                                <th>{Lang::T('Service')}</th>
                                <th>{Lang::T('Download__TX_')}</th>
                                <th>{Lang::T('Upload__RX_')}</th>
                                <th>{Lang::T('Total_Usage')}</th>
                                <th style="min-width:150px;">{Lang::T('Live_traffic')}</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                {else}
                <p class="text-muted">{Lang::T('Router_not_found')}</p>
                {/if}
            </div>
        </div>
    </div>
</div>

{if $routers}
<div class="modal fade" id="pppoe-user-modal" tabindex="-1" role="dialog" aria-labelledby="pppoe-user-modal-title">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="{Lang::T('Close')}"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="pppoe-user-modal-title">—</h4>
            </div>
            <div class="modal-body">
                <p class="text-muted small" id="pppoe-user-modal-meta"></p>
                <div class="alert alert-warning alert-sm" id="pppoe-user-modal-no-customer" style="display:none;padding:8px 12px;">
                    <i class="fa fa-info-circle"></i> <span id="pppoe-user-modal-no-customer-txt"></span>
                </div>
                <p class="small text-uppercase text-muted" style="margin-bottom:6px;">{Lang::T('Live_traffic')}</p>
                <div id="pppoe-modal-chart-wrap">
                    <canvas id="pppoe-modal-chart-canvas"></canvas>
                </div>
            </div>
            <div class="modal-footer">
                <a href="#" class="btn btn-success" id="pppoe-user-modal-view-btn" style="display:none;">
                    <i class="fa fa-user"></i> <span class="pppoe-modal-view-label">{Lang::T('View')}</span>
                </a>
                <button type="button" class="btn btn-default" data-dismiss="modal">{Lang::T('Close')}</button>
            </div>
        </div>
    </div>
</div>
{/if}

{if $routers}
{capture assign=xfooter}
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script>
(function () {
    var routerId = {$pppoe_ou_router nofilter};
    var i18n = {$pppoe_ou_i18n nofilter};
    var url = '{$_url}plugin/pppoe_online_users_json/' + encodeURIComponent(routerId);
    var POLL_MS = 5000;
    var MAX_POINTS = 36;
    var pppoeTrafficHistory = {};
    var pppoeCharts = {};
    var routeBase = '{$_url|escape:'javascript'}';
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
</script>
{/capture}
{/if}

{include file="sections/footer.tpl"}
