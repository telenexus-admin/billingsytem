<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\widget\customer_expired.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee0aec353_23718229',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '0bfd2c9d189b3cffe700db3ae8c9533363d4e3b1' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\widget\\customer_expired.tpl',
      1 => 1776361611,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:pagination.tpl' => 1,
  ),
),false)) {
function content_69e37ee0aec353_23718229 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="panel panel-warning mb20 panel-hovered project-stats table-responsive">
    <div class="panel-heading"><?php echo Lang::T('Recently Recharged Customers');?>
</div>
    <div class="table-responsive">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>
                        <select style="border: 0px; width: 100%; background-color: #f9f9f9;"
                            onchange="changeExpiredDefault(this)">
                            <option value="username" <?php if ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'username') {?>selected<?php }?>>
                                <?php echo Lang::T('Username');?>

                            </option>
                            <option value="fullname" <?php if ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'fullname') {?>selected<?php }?>>
                                <?php echo Lang::T('Full Name');?>
</option>
                            <option value="phone" <?php if ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'phone') {?>selected<?php }?>><?php echo Lang::T('Phone');?>

                            </option>
                            <option value="email" <?php if ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'email') {?>selected<?php }?>><?php echo Lang::T('Email');?>

                            </option>
                        </select>
                    </th>
                    <th><?php echo Lang::T('Created / Expired');?>
</th>
                    <th><?php echo Lang::T('Internet Package');?>
</th>
                    <th><?php echo Lang::T('Transaction ID');?>
</th>
                    <th><?php echo Lang::T('Location');?>
</th>
                </tr>
            </thead>
            <tbody>
                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['expire']->value, 'expired');
$_smarty_tpl->tpl_vars['expired']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['expired']->value) {
$_smarty_tpl->tpl_vars['expired']->do_else = false;
?>
                    <?php $_smarty_tpl->_assignInScope('rem_exp', ((string)$_smarty_tpl->tpl_vars['expired']->value['expiration'])." ".((string)$_smarty_tpl->tpl_vars['expired']->value['time']));?>
                    <?php $_smarty_tpl->_assignInScope('rem_started', ((string)$_smarty_tpl->tpl_vars['expired']->value['recharged_on'])." ".((string)$_smarty_tpl->tpl_vars['expired']->value['recharged_time']));?>
                    <tr>
                        <td><a href="<?php echo Text::url('customers/view/',$_smarty_tpl->tpl_vars['expired']->value['id']);?>
">
                                <?php if ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'fullname') {?>
                                    <?php echo $_smarty_tpl->tpl_vars['expired']->value['fullname'];?>

                                <?php } elseif ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'phone') {?>
                                    <?php echo $_smarty_tpl->tpl_vars['expired']->value['phonenumber'];?>

                                <?php } elseif ($_smarty_tpl->tpl_vars['cookie']->value['expdef'] == 'email') {?>
                                    <?php echo $_smarty_tpl->tpl_vars['expired']->value['email'];?>

                                <?php } else { ?>
                                    <?php echo $_smarty_tpl->tpl_vars['expired']->value['username'];?>

                                <?php }?>
                            </a></td>
                        <td><small data-toggle="tooltip" data-placement="top"
                                title="<?php echo Lang::dateAndTimeFormat($_smarty_tpl->tpl_vars['expired']->value['recharged_on'],$_smarty_tpl->tpl_vars['expired']->value['recharged_time']);?>
"><?php echo Lang::timeElapsed($_smarty_tpl->tpl_vars['rem_started']->value);?>
</small>
                            /
                            <span data-toggle="tooltip" data-placement="top"
                                title="<?php echo Lang::dateAndTimeFormat($_smarty_tpl->tpl_vars['expired']->value['expiration'],$_smarty_tpl->tpl_vars['expired']->value['time']);?>
"><?php echo Lang::timeElapsed($_smarty_tpl->tpl_vars['rem_exp']->value);?>
</span>
                        </td>
                        <td><?php echo $_smarty_tpl->tpl_vars['expired']->value['namebp'];?>
</td>
                        <td><?php if ($_smarty_tpl->tpl_vars['expired']->value['trx_invoice']) {
echo $_smarty_tpl->tpl_vars['expired']->value['trx_invoice'];
} else { ?>-<?php }?></td>
                        <td><?php echo $_smarty_tpl->tpl_vars['expired']->value['routers'];?>
</td>
                    </tr>
                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
            </tbody>
        </table>
    </div>
    &nbsp; <?php $_smarty_tpl->_subTemplateRender("file:pagination.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
</div>
<?php echo '<script'; ?>
>
    function changeExpiredDefault(fl) {
        setCookie('expdef', fl.value, 365);
        setTimeout(() => {
            location.reload();
        }, 1000);
    }
<?php echo '</script'; ?>
><?php }
}
