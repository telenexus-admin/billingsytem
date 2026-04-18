<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\widget\graph_monthly_sales.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee01d1de0_57223791',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6fbede11074fb818f02c8487b7c14cfef958fa1b' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\widget\\graph_monthly_sales.tpl',
      1 => 1776361611,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e37ee01d1de0_57223791 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="box box-solid">
    <div class="box-header">
        <i class="fa fa-inbox"></i>
        <h3 class="box-title"><?php echo Lang::T('Total Monthly Sales');?>
</h3>
        <div class="box-tools pull-right">
            <button type="button" class="btn bg-teal btn-sm" data-widget="collapse">
                <i class="fa fa-minus"></i>
            </button>
            <a href="<?php echo Text::url('dashboard&refresh');?>
" class="btn bg-teal btn-sm">
                <i class="fa fa-refresh"></i>
            </a>
        </div>
    </div>
    <div class="box-body border-radius-none">
        <canvas class="chart" id="salesChart" style="height: 250px; width: 100%;"></canvas>
    </div>
    
    <!-- Debug info (remove in production) -->
    <div class="box-footer" style="display: none;" id="debug-info">
        <pre>Monthly Sales Data: <?php echo htmlspecialchars((string)json_encode($_smarty_tpl->tpl_vars['monthlySales']->value), ENT_QUOTES, 'UTF-8', true);?>
</pre>
    </div>
</div>

<!-- Make sure Chart.js is loaded -->
<?php echo '<script'; ?>
 src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"><?php echo '</script'; ?>
>

<?php echo '<script'; ?>
 type="text/javascript">
    <?php if ($_smarty_tpl->tpl_vars['_c']->value['hide_tmc'] != 'yes') {?>
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM loaded, creating chart...");
            
            try {
                // Get the data directly from PHP
                var monthlySales = <?php echo json_encode($_smarty_tpl->tpl_vars['monthlySales']->value);?>
;
                
                console.log("Raw monthlySales data:", monthlySales);
                console.log("Type of monthlySales:", typeof monthlySales);
                console.log("Is array?", Array.isArray(monthlySales));
                
                // If it's a string, parse it
                if (typeof monthlySales === 'string') {
                    monthlySales = JSON.parse(monthlySales);
                    console.log("Parsed monthlySales:", monthlySales);
                }
                
                // Ensure we have an array
                if (!monthlySales || !Array.isArray(monthlySales)) {
                    console.error("monthlySales is not an array:", monthlySales);
                    monthlySales = [];
                    
                    // Create empty data for all months
                    for (var i = 1; i <= 12; i++) {
                        monthlySales.push({
                            month: i,
                            totalSales: 0
                        });
                    }
                    console.log("Created empty monthlySales:", monthlySales);
                }
                
                // Month names
                var monthNames = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ];
                
                // Prepare data for chart
                var labels = [];
                var data = [];
                
                for (var i = 1; i <= 12; i++) {
                    labels.push(monthNames[i - 1]);
                    
                    // Find data for this month
                    var found = false;
                    for (var j = 0; j < monthlySales.length; j++) {
                        if (monthlySales[j] && monthlySales[j].month === i) {
                            data.push(parseFloat(monthlySales[j].totalSales) || 0);
                            console.log("Month " + i + " (" + monthNames[i-1] + "): " + monthlySales[j].totalSales);
                            found = true;
                            break;
                        }
                    }
                    
                    if (!found) {
                        data.push(0);
                        console.log("Month " + i + " (" + monthNames[i-1] + "): 0 (no data)");
                    }
                }
                
                console.log("Final labels:", labels);
                console.log("Final data:", data);
                
                // Calculate max value for y-axis
                var maxValue = Math.max.apply(null, data);
                console.log("Max value:", maxValue);
                
                var yMax = maxValue > 0 ? Math.ceil(maxValue / 1000) * 1000 : 10000;
                console.log("Y-axis max:", yMax);
                
                // Get canvas element
                var canvas = document.getElementById('salesChart');
                if (!canvas) {
                    console.error("Canvas element not found!");
                    return;
                }
                
                console.log("Canvas found, creating chart...");
                
                // Create chart
                var ctx = canvas.getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Monthly Sales',
                            data: data,
                            backgroundColor: '#f39c12',
                            borderColor: '#f39c12',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return 'Sales: ' + context.raw.toLocaleString();
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                grid: {
                                    display: false
                                }
                            },
                            y: {
                                beginAtZero: true,
                                min: 0,
                                max: yMax,
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                },
                                ticks: {
                                    stepSize: yMax / 5,
                                    callback: function(value) {
                                        return value.toLocaleString();
                                    }
                                }
                            }
                        }
                    }
                });
                
                console.log("Chart created successfully!");
                
            } catch (e) {
                console.error("Error creating chart:", e);
                console.error("Error stack:", e.stack);
            }
        });
    <?php }
echo '</script'; ?>
><?php }
}
