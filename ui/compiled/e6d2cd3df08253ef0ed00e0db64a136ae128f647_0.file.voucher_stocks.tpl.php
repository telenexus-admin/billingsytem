<?php
/* Smarty version 4.5.3, created on 2026-04-17 11:43:06
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\widget\voucher_stocks.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e1f29a94a861_87885868',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'e6d2cd3df08253ef0ed00e0db64a136ae128f647' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\widget\\voucher_stocks.tpl',
      1 => 1776361612,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e1f29a94a861_87885868 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="panel panel-default panel-hovered mb20 activities">
    <div class="panel-heading"><?php echo Lang::T('Voucher Stocks');?>
</div>
    <div class="panel-body">
        <div class="row text-center" style="margin-bottom: 15px;">
            <div class="col-xs-6">
                <span class="text-muted"><?php echo Lang::T('Unused');?>
</span>
                <h4 class="text-success" style="margin-top: 5px;"><?php echo (($tmp = $_smarty_tpl->tpl_vars['stocks']->value['unused'] ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</h4>
            </div>
            <div class="col-xs-6">
                <span class="text-muted"><?php echo Lang::T('Used');?>
</span>
                <h4 class="text-info" style="margin-top: 5px;"><?php echo (($tmp = $_smarty_tpl->tpl_vars['stocks']->value['used'] ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</h4>
            </div>
        </div>
        <?php if ((isset($_smarty_tpl->tpl_vars['plans']->value)) && count($_smarty_tpl->tpl_vars['plans']->value) > 0) {?>
            <div class="table-responsive">
                <table class="table table-condensed table-striped mb0">
                    <thead>
                        <tr>
                            <th><?php echo Lang::T('Plan');?>
</th>
                            <th class="text-right"><?php echo Lang::T('Unused');?>
</th>
                            <th class="text-right"><?php echo Lang::T('Used');?>
</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['plans']->value, 'p');
$_smarty_tpl->tpl_vars['p']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['p']->value) {
$_smarty_tpl->tpl_vars['p']->do_else = false;
?>
                            <tr>
                                <td><?php echo $_smarty_tpl->tpl_vars['p']->value['name_plan'];?>
</td>
                                <td class="text-right"><?php echo $_smarty_tpl->tpl_vars['p']->value['unused'];?>
</td>
                                <td class="text-right"><?php echo $_smarty_tpl->tpl_vars['p']->value['used'];?>
</td>
                            </tr>
                        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                    </tbody>
                </table>
            </div>
        <?php } else { ?>
            <p class="text-muted text-center mb0"><?php echo Lang::T('No vouchers');?>
</p>
        <?php }?>
    </div>
</div>
<?php }
}
