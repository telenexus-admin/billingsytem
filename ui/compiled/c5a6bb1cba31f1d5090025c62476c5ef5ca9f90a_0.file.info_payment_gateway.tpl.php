<?php
/* Smarty version 4.5.3, created on 2026-04-17 11:43:06
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\widget\info_payment_gateway.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e1f29a986fa3_69619350',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'c5a6bb1cba31f1d5090025c62476c5ef5ca9f90a' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\widget\\info_payment_gateway.tpl',
      1 => 1776361612,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e1f29a986fa3_69619350 (Smarty_Internal_Template $_smarty_tpl) {
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
