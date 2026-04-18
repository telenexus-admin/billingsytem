<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\widget\activity_log.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee0c024a5_61803586',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'e1a864adfc38a07d79d0e5c4fd77894e92c88a69' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\widget\\activity_log.tpl',
      1 => 1776361611,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e37ee0c024a5_61803586 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="panel panel-default panel-hovered mb20 activities">
    <div class="panel-heading clearfix">
        <span><?php echo Lang::T('Recent Activity');?>
</span>
        <a href="<?php echo Text::url('logs/list');?>
" class="btn btn-xs btn-default pull-right"><?php echo Lang::T('View All');?>
</a>
    </div>
    <div class="panel-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="table table-condensed mb0">
                <tbody>
                    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['dlog']->value, 'lg');
$_smarty_tpl->tpl_vars['lg']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['lg']->value) {
$_smarty_tpl->tpl_vars['lg']->do_else = false;
?>
                        <tr>
                            <td style="width: 1%; white-space: nowrap; vertical-align: top;">
                                <small class="text-muted"><?php echo Lang::dateTimeFormat($_smarty_tpl->tpl_vars['lg']->value['date']);?>
</small>
                            </td>
                            <td style="width: 1%; vertical-align: top;">
                                <span class="label label-default"><?php echo $_smarty_tpl->tpl_vars['lg']->value['type'];?>
</span>
                            </td>
                            <td style="word-break: break-word; vertical-align: top;">
                                <small><?php echo nl2br($_smarty_tpl->tpl_vars['lg']->value['description']);?>
</small>
                            </td>
                        </tr>
                    <?php
}
if ($_smarty_tpl->tpl_vars['lg']->do_else) {
?>
                        <tr>
                            <td colspan="3" class="text-muted text-center"><?php echo Lang::T('No logs');?>
</td>
                        </tr>
                    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<?php }
}
