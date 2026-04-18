<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:26:44
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\system\plugin\ui\mikrotik_import_start.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e227048833b1_36777343',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'd973073bedc3df64862afe4e5e59be73665da849' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\system\\plugin\\ui\\mikrotik_import_start.tpl',
      1 => 1776361425,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e227048833b1_36777343 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<form class="form-horizontal" method="post" role="form" action="<?php echo $_smarty_tpl->tpl_vars['_url']->value;?>
settings/app-post">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">Information</div>
                <div class="panel-body">
                    After import, you need to configure Packages, set time limit
                </div>
            </div>
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">Package import</div>
                <div class="panel-body">
                    <ol>
                        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['results']->value, 'result');
$_smarty_tpl->tpl_vars['result']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['result']->value) {
$_smarty_tpl->tpl_vars['result']->do_else = false;
?>
                            <li><?php echo $_smarty_tpl->tpl_vars['result']->value;?>
</li>
                        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</form>

<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
