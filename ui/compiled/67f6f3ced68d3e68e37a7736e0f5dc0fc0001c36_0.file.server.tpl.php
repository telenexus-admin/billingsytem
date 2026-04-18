<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:26:32
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\admin\autoload\server.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e226f898f075_38489263',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '67f6f3ced68d3e68e37a7736e0f5dc0fc0001c36' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\admin\\autoload\\server.tpl',
      1 => 1776361566,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e226f898f075_38489263 (Smarty_Internal_Template $_smarty_tpl) {
?><option value=''><?php echo Lang::T('Select Routers');?>
</option>
<?php if ($_smarty_tpl->tpl_vars['_c']->value['radius_enable']) {?>
    <option value="radius">Radius</option>
<?php }
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['ds']->value['name'];?>
"><?php echo $_smarty_tpl->tpl_vars['ds']->value['name'];?>
</option>
<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);
}
}
