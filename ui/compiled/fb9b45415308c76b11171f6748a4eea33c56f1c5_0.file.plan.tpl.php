<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:26:36
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\admin\autoload\plan.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e226fcc61204_17751879',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'fb9b45415308c76b11171f6748a4eea33c56f1c5' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\admin\\autoload\\plan.tpl',
      1 => 1776361566,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e226fcc61204_17751879 (Smarty_Internal_Template $_smarty_tpl) {
?><option value="">Select Plans</option>
<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
<option value="<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
">
    <?php if ($_smarty_tpl->tpl_vars['ds']->value['enabled'] != 1) {?>DISABLED PLAN &bull; <?php }?>
    <?php echo $_smarty_tpl->tpl_vars['ds']->value['name_plan'];?>
 &bull;
    <?php echo Lang::moneyFormat($_smarty_tpl->tpl_vars['ds']->value['price']);?>

    <?php if ($_smarty_tpl->tpl_vars['ds']->value['prepaid'] != 'yes') {?> &bull; POSTPAID  <?php }?>
</option>
<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);
}
}
