<?php
/* Smarty version 4.5.3, created on 2026-04-17 11:43:06
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\widget\graph_customers_insight.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e1f29aa6e8b5_22572384',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'df72b256185ad7c11b33469bf07b351735e3cf61' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\widget\\graph_customers_insight.tpl',
      1 => 1776361611,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e1f29aa6e8b5_22572384 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="panel panel-info panel-hovered mb20 activities">
    <div class="panel-heading"><?php echo Lang::T('All Users Insights');?>
</div>
    <div class="panel-body">
        <div style="display:flex;gap:1rem;flex-wrap:wrap;align-items:flex-start;">
            <div style="flex:1 1 180px;max-width:240px;">
                <canvas id="userRechargesChart"></canvas>
            </div>
            <div style="flex:2 1 300px;max-width:560px;">
                <canvas id="planPerformanceChart"></canvas>
            </div>
        </div>
    </div>
</div>


<?php echo '<script'; ?>
 type="text/javascript">
            
        document.addEventListener("DOMContentLoaded", function() {
            // parse template variables
            var u_act = parseInt('<?php echo $_smarty_tpl->tpl_vars['u_act']->value;?>
') || 0;
            var c_all = parseInt('<?php echo $_smarty_tpl->tpl_vars['c_all']->value;?>
') || 0;
            var u_all = parseInt('<?php echo $_smarty_tpl->tpl_vars['u_all']->value;?>
') || 0;
            var expired = Math.max(0, u_all - u_act);
            var inactive = Math.max(0, c_all - u_all);

            // Small doughnut chart config for user insight
            var userData = {
                labels: ['Active', 'Expired', 'Inactive'],
                datasets: [{
                    data: [u_act, expired, inactive],
                    backgroundColor: ['#04BF0D', '#BF2304', '#3B82F6'],
                    hoverOffset: 6,
                }]
            };

            var userOptions = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom', labels: { boxWidth: 12 } },
                    tooltip: { enabled: true }
                }
            };

            // Plan performance (top 10) - horizontal bar
            var planLabels = [];
            var planCounts = [];
            try {
                planLabels = JSON.parse('<?php echo (($tmp = $_smarty_tpl->tpl_vars['plan_perf_labels']->value ?? null)===null||$tmp==='' ? '[]' ?? null : $tmp);?>
');
                planCounts = JSON.parse('<?php echo (($tmp = $_smarty_tpl->tpl_vars['plan_perf_counts']->value ?? null)===null||$tmp==='' ? '[]' ?? null : $tmp);?>
');
            } catch (e) {
                planLabels = [];
                planCounts = [];
                console && console.error && console.error('plan performance JSON parse error', e);
            }

            var planData = {
                labels: planLabels,
                datasets: [{
                    label: 'Recharges',
                    data: planCounts,
                    backgroundColor: planLabels.map((_, i) => 'rgba(59,130,246,' + (0.6 - Math.min(i * 0.03, 0.4)) + ')'),
                    borderColor: planLabels.map(() => 'rgba(59,130,246,1)'),
                    borderWidth: 1
                }]
            };

            var planOptions = {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { beginAtZero: true, ticks: { precision: 0 } },
                    y: { ticks: { autoSkip: true, maxRotation: 0, minRotation: 0 } }
                },
                plugins: { legend: { display: false }, tooltip: { enabled: true } }
            };

            // Render charts with smaller fixed heights
            var userCtx = document.getElementById('userRechargesChart').getContext('2d');
            document.getElementById('userRechargesChart').parentElement.style.height = '220px';
            var userChart = new Chart(userCtx, { type: 'doughnut', data: userData, options: userOptions });

            var planCtx = document.getElementById('planPerformanceChart').getContext('2d');
            document.getElementById('planPerformanceChart').parentElement.style.height = '220px';
            var planChart = new Chart(planCtx, { type: 'bar', data: planData, options: planOptions });
        });
    
<?php echo '</script'; ?>
><?php }
}
