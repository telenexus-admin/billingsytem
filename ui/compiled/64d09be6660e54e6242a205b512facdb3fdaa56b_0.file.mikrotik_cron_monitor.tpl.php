<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\widget\mikrotik_cron_monitor.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee08d79a8_07193380',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '64d09be6660e54e6242a205b512facdb3fdaa56b' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\widget\\mikrotik_cron_monitor.tpl',
      1 => 1776361612,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e37ee08d79a8_07193380 (Smarty_Internal_Template $_smarty_tpl) {
if ($_smarty_tpl->tpl_vars['_c']->value['router_check'] && count($_smarty_tpl->tpl_vars['routeroffs']->value) > 0) {?>
    <div class="panel panel-danger">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="fa fa-exclamation-triangle"></i> <?php echo Lang::T('Routers Offline');?>

                <span class="badge pull-right"><?php echo count($_smarty_tpl->tpl_vars['routeroffs']->value);?>
</span>
            </h3>
        </div>
        <div class="panel-body">
            <div class="alert alert-warning small" style="margin-bottom: 5px; padding: 5px;">
                <i class="fa fa-bell"></i> <?php echo Lang::T('SMS alert sent to admin');?>

            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-condensed table-hover">
                <tbody>
                    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['routeroffs']->value, 'ros');
$_smarty_tpl->tpl_vars['ros']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ros']->value) {
$_smarty_tpl->tpl_vars['ros']->do_else = false;
?>
                        <tr>
                            <td>
                                <a href="<?php echo Text::url('routers/edit/',$_smarty_tpl->tpl_vars['ros']->value['id']);?>
" class="text-bold text-red">
                                    <i class="fa fa-exclamation-circle text-red"></i> 
                                    <?php echo $_smarty_tpl->tpl_vars['ros']->value['name'];?>

                                </a>
                                <br>
                                <small class="text-muted"><?php echo $_smarty_tpl->tpl_vars['ros']->value['ip_address'];?>
</small>
                            </td>
                            <td class="text-right text-red" data-toggle="tooltip" 
                                data-placement="left" title="<?php echo Lang::dateTimeFormat($_smarty_tpl->tpl_vars['ros']->value['last_seen']);?>
">
                                <i class="fa fa-clock-o"></i> 
                                <?php if ($_smarty_tpl->tpl_vars['ros']->value['last_seen']) {?>
                                    <?php echo Lang::timeElapsed($_smarty_tpl->tpl_vars['ros']->value['last_seen']);?>

                                <?php } else { ?>
                                    <?php echo Lang::T('Never');?>

                                <?php }?>
                            </td>
                        </tr>
                    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                </tbody>
            </table>
        </div>
        <div class="panel-footer small text-muted">
            <i class="fa fa-clock-o"></i> <?php echo Lang::T('Updated');?>
: <?php echo date('Y-m-d H:i:s');?>

            <span class="pull-right">
                <a href="javascript:void(0)" onclick="refreshRouterStatus()">
                    <i class="fa fa-refresh"></i>
                </a>
            </span>
        </div>
    </div>
<?php }?>

<?php echo '<script'; ?>
>
function refreshRouterStatus() {
    location.reload();
}

$(function () {
    $('[data-toggle="tooltip"]').tooltip();
});
<?php echo '</script'; ?>
>
<?php }
}
