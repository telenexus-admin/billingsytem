<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\widget\info_payment_gateway.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee0a573c9_52561832',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '48bc9af90611451447660ee5e3785d48c2adbb6b' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\widget\\info_payment_gateway.tpl',
      1 => 1776361612,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e37ee0a573c9_52561832 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="panel panel-success panel-hovered mb20 activities">
    <div class="panel-heading"><?php echo Lang::T('Active Payment Gateway');?>
: <?php echo str_replace(',',', ',$_smarty_tpl->tpl_vars['_c']->value['payment_gateway']);?>

    </div>
    <div class="panel-body" style="padding:10px 15px;">
        <div style="display:flex;gap:1rem;align-items:center;flex-wrap:wrap;">
            <div><strong>Successful today:</strong> <?php echo (($tmp = $_smarty_tpl->tpl_vars['payments_today']->value['successful'] ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
            <div><strong>Failed today:</strong> <?php echo (($tmp = $_smarty_tpl->tpl_vars['payments_today']->value['failed'] ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
            <div><strong>Pending today:</strong> <?php echo (($tmp = $_smarty_tpl->tpl_vars['payments_today']->value['pending'] ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
        </div>
    </div>
</div><?php }
}
