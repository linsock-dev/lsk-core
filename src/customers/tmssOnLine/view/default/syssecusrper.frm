<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecusrper&prm_usrpercod='.$vew_data->usrpercod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->usrpercod; 

	// titulo 
	$lv_title = $vew_lang->permissions;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'USP';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<nav class="navbar navbar-default tmss-navbar">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a><?php } ?>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!="01") { ?>
					<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn"><span class="fas fa-sync-alt"></span></a>
					<li class="btn navbar-text tmss-navbar-sep">|</li>
				<?php } ?>
				<a href="#" onclick="tmssTabSecCls(this);" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

	<style>
		* { margin: 0; padding: 0; }
		#page-wrap { margin: auto 0; }
		.treeview { margin: 10px 0 0 20px; }
		ul { list-style: none; }
		.treeview li {
			background: url(http://jquery.bassistance.de/treeview/images/treeview-default-line.gif) 0 0 no-repeat;
			padding: 2px 0 2px 16px;
		}
		.treeview > li:first-child > label {
			// style for the root element - IE8 supports :first-child
			but not :last-child ..... 
		}
		.treeview li.last {
			background-position: 0 -1766px;
		}
		.treeview li > input {
			height: 16px;
			width: 16px;
			// hide the inputs but keep them in the layout with events (use opacity) 
			opacity: 0;
			filter: alpha(opacity=0); // internet explorer  
			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(opacity=0)"; //IE8
		}
		.treeview li > label {
			background: url(http://www.thecssninja.com/demo/css_custom-forms/gr_custom-inputs.png) 0 -1px no-repeat;
			// move left to cover the original checkbox area 
			margin-left: -20px;
			// pad the text to make room for image 
			padding-left: 20px;
		}
		
		// Unchecked styles 
		.treeview .custom-unchecked {
			background-position: 0 -1px;
		}
		.treeview .custom-unchecked:hover {
			background-position: 0 -21px;
		}
		
		// Checked styles 
		.treeview .custom-checked { 
			background-position: 0 -81px;
		}
		.treeview .custom-checked:hover { 
			background-position: 0 -101px; 
		}

		// Indeterminate styles 
		.treeview .custom-indeterminate { 
			background-position: 0 -141px; 
		}
		.treeview .custom-indeterminate:hover { 
			background-position: 0 -121px; 
		}
	</style>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    <div id="page-wrap">
			<ul class="treeview">
        <li>
					<input type="checkbox" name="tall" id="tall">
					<label for="tall" class="custom-unchecked">Tall Things</label>
					<ul>
						<li><input type="checkbox" name="tall-1" id="tall-1"><label for="tall-1" class="custom-unchecked">Buildings</label></li>
						<li>
							<input type="checkbox" name="tall-2" id="tall-2"><label for="tall-2" class="custom-unchecked">Giants</label>
							<ul>
								<li><input type="checkbox" name="tall-2-1" id="tall-2-1"><label for="tall-2-1" class="custom-unchecked">Andre</label></li>
								<li class="last"><input type="checkbox" name="tall-2-2" id="tall-2-2"><label for="tall-2-2" class="custom-unchecked">Paul Bunyan</label></li>
							</ul>
						</li>
						<li class="last"><input type="checkbox" name="tall-3" id="tall-3"><label for="tall-3" class="custom-unchecked">Two sandwiches</label></li>
					</ul>
        </li>
        <li class="last">
					<input type="checkbox" name="short" id="short"><label for="short" class="custom-unchecked">Short Things</label>
					<ul>
            <li><input type="checkbox" name="short-1" id="short-1"><label for="short-1" class="custom-unchecked">Smurfs</label></li>
            <li><input type="checkbox" name="short-2" id="short-2"><label for="short-2" class="custom-unchecked">Mushrooms</label></li>
						<li class="last"><input type="checkbox" name="short-3" id="short-3"><label for="short-3" class="custom-unchecked">One Sandwich</label></li>
          </ul>
        </li>
			</ul>
    </div>
	</form>
	<script>
		$(function() {

			$('input[type="checkbox"]').change(checkboxChanged);

			function checkboxChanged() {
				var $this = $(this),
						checked = $this.prop("checked"),
						container = $this.parent(),
						siblings = container.siblings();

				container.find('input[type="checkbox"]')
				.prop({
						indeterminate: false,
						checked: checked
				})
				.siblings('label')
				.removeClass('custom-checked custom-unchecked custom-indeterminate')
				.addClass(checked ? 'custom-checked' : 'custom-unchecked');

				checkSiblings(container, checked);
			}

			function checkSiblings($el, checked) {
				var parent = $el.parent().parent(),
						all = true,
						indeterminate = false;

				$el.siblings().each(function() {
					return all = ($(this).children('input[type="checkbox"]').prop("checked") === checked);
				});

				if (all && checked) {
					parent.children('input[type="checkbox"]')
					.prop({
							indeterminate: false,
							checked: checked
					})
					.siblings('label')
					.removeClass('custom-checked custom-unchecked custom-indeterminate')
					.addClass(checked ? 'custom-checked' : 'custom-unchecked');

					checkSiblings(parent, checked);
				} 
				else if (all && !checked) {
					indeterminate = parent.find('input[type="checkbox"]:checked').length > 0;

					parent.children('input[type="checkbox"]')
					.prop("checked", checked)
					.prop("indeterminate", indeterminate)
					.siblings('label')
					.removeClass('custom-checked custom-unchecked custom-indeterminate')
					.addClass(indeterminate ? 'custom-indeterminate' : (checked ? 'custom-checked' : 'custom-unchecked'));

					checkSiblings(parent, checked);
				} 
				else {
					$el.parents("li").children('input[type="checkbox"]')
					.prop({
							indeterminate: true,
							checked: false
					})
					.siblings('label')
					.removeClass('custom-checked custom-unchecked custom-indeterminate')
					.addClass('custom-indeterminate');
				}
			}
		});
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>