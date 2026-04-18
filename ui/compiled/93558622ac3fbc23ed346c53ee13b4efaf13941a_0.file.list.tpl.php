<?php
/* Smarty version 4.5.3, created on 2026-04-18 16:00:10
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\admin\bandwidth\list.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e3805a02b576_73444301',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '93558622ac3fbc23ed346c53ee13b4efaf13941a' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\admin\\bandwidth\\list.tpl',
      1 => 1776361567,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:pagination.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e3805a02b576_73444301 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<div class="row">
	<div class="col-sm-12">
		<div class="panel panel-hovered mb20 panel-primary">
			<div class="panel-heading"><?php echo Lang::T('Bandwidth Plans');?>
</div>
			<div class="panel-body">
				<div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
					<div class="col-md-8">
						<form id="site-search" method="post" action="<?php echo Text::url('bandwidth/list/');?>
">
							<div class="input-group">
								<div class="input-group-addon">
									<span class="fa fa-search"></span>
								</div>
								<input type="text" name="name" class="form-control"
									placeholder="<?php echo Lang::T('Search by Name');?>
...">
								<div class="input-group-btn">
									<button class="btn btn-success" type="submit"><?php echo Lang::T('Search');?>
</button>
								</div>
							</div>
						</form>
					</div>
					<div class="col-md-4">
						<a href="<?php echo Text::url('bandwidth/add');?>
" class="btn btn-primary btn-block"><i
								class="ion ion-android-add">
							</i> <?php echo Lang::T('New Bandwidth');?>
</a>
					</div>&nbsp;
				</div>
				<div class="table-responsive">
					<table class="table table-bordered table-condensed table-striped table_mobile">
						<thead>
							<tr>
								<th><?php echo Lang::T('Bandwidth Name');?>
</th>
								<th><?php echo Lang::T('Rate');?>
</th>
								<th>Burst</th>
								<th><?php echo Lang::T('Manage');?>
</th>
							</tr>
						</thead>
						<tbody>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
								<tr>
									<td><?php echo $_smarty_tpl->tpl_vars['ds']->value['name_bw'];?>
</td>
									<td><?php echo $_smarty_tpl->tpl_vars['ds']->value['rate_down'];?>
 <?php echo $_smarty_tpl->tpl_vars['ds']->value['rate_down_unit'];?>
 / <?php echo $_smarty_tpl->tpl_vars['ds']->value['rate_up'];?>
 <?php echo $_smarty_tpl->tpl_vars['ds']->value['rate_up_unit'];?>

									</td>
									<td><?php echo $_smarty_tpl->tpl_vars['ds']->value['burst'];?>
</td>
									<td>
										<a href="<?php echo Text::url('bandwidth/edit/',$_smarty_tpl->tpl_vars['ds']->value['id']);?>
"
											class="btn btn-sm btn-warning"><?php echo Lang::T('Edit');?>
</a>
										<a href="<?php echo Text::url('bandwidth/delete/',$_smarty_tpl->tpl_vars['ds']->value['id']);?>
" id="<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
"
											class="btn btn-danger btn-sm"
											onclick="return ask(this, '<?php echo Lang::T('Delete');?>
?')"><i
												class="glyphicon glyphicon-trash"></i></a>
									</td>
								</tr>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</tbody>
					</table>
				</div>
				<?php $_smarty_tpl->_subTemplateRender("file:pagination.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
				
			</div>
		</div>
	</div>
</div>
</div>

<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
