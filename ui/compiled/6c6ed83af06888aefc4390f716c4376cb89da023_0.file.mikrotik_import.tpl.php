<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:24:58
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\system\plugin\ui\mikrotik_import.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e2269a8f16d3_85005330',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6c6ed83af06888aefc4390f716c4376cb89da023' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\system\\plugin\\ui\\mikrotik_import.tpl',
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
function content_69e2269a8f16d3_85005330 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<form class="form-horizontal" method="post" role="form" action="<?php echo $_smarty_tpl->tpl_vars['_url']->value;?>
plugin/mikrotik_import_start_ui">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">Information</div>
                <div class="panel-body">
                    <ol>
                        <li>This Plugin only import Packages and Users</li>
                        <li>Active package will not be imported</li>
                        <li>You must Refill the user or User buy new package</li>
                    </ol>
                </div>
            </div>
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">Import User and Packages from Mikrotik</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-2 control-label"><?php echo Lang::T('Type');?>
</label>
                        <div class="col-md-6">
                            <input type="radio" id="Hot" name="type" value="Hotspot"> <?php echo Lang::T('Hotspot Plans');?>

                            <input type="radio" id="POE" name="type" value="PPPOE"> <?php echo Lang::T('PPPOE Plans');?>

                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label"><?php echo Lang::T('Routers');?>
</label>
                        <div class="col-md-6">
                            <select id="server" required name="server" class="form-control">
                                <option value=''><?php echo Lang::T('Select Routers');?>
</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button class="btn btn-success" type="submit">Import User</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
