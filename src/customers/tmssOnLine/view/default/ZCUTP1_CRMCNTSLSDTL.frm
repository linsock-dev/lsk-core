<?php
	// url del formulario (ficha de paciente; vuelve al dashboard de contactos)
	$lv_lnk = '?prg=zcutp1_ttr&act=crmslsdtl';

	// campos requeridos (ficha de solo lectura: sin campos obligatorios)
	$vew_input->setReqFields( array() );

	// clave del documento (la ficha referencia al paciente cargado)
	$lv_dockey = ( isset($vew_data->patcod) ? $vew_data->patcod : '' );

	// titulo
	$lv_title = 'Ficha de Paciente';

	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
	$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;

	// libreria de estilos bootstrap
	include_once('_library.frm');

	// Botones por vista (ficha de solo lectura: se ocultan los botones por defecto)
	$vew_tbl['new']  = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['cpy']  = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>true, 'acc'=>$lv_sec.'_reload()');

	// helpers de presentacion
	// valor o guion medio
	$lv_val = function( $lp_v ) { return ( trim((string)$lp_v)!='' ? htmlspecialchars($lp_v) : '&mdash;' ); };
	// formateo seguro de fechas (el load puede devolver DateTime u objeto {date:...})
	$lv_fdte = function( $lp_v ) {
		if ( is_a($lp_v,'DateTime') ) { return date_format($lp_v,'d/m/Y'); }
		if ( is_object($lp_v) && isset($lp_v->date) ) { return substr($lp_v->date,8,2).'/'.substr($lp_v->date,5,2).'/'.substr($lp_v->date,0,4); }
		return ($lp_v!==null ? (string)$lp_v : '');
	};
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

	<style>
		/* ----------------------------------------------------------------------
		   FICHA DE PACIENTE  (replica de detalle_pacientes_v2.html)
		   Estilos 100% CSS + Font Awesome 6 (ya cargado en SYSDOCHDR.php).
		   Todo scopeado a #<?= $lv_sec; ?> para no afectar al resto del sistema.
		   ---------------------------------------------------------------------- */
		#<?= $lv_sec; ?> .tmss-pat-dtl {
			--tmss-blue: #1d9af2;
			--tmss-blue-2: #49a5df;
			--tmss-blue-dark: #0b7fd2;
			--tmss-bg: #f5f8fc;
			--tmss-card: #ffffff;
			--tmss-line: #e2eaf3;
			--tmss-line-2: #edf2f7;
			--tmss-text: #243044;
			--tmss-muted: #7a8798;
			--tmss-green: #40b66b;
			--tmss-green-soft: #dff5e8;
			--tmss-orange: #ffb300;
			--tmss-red: #e64646;
			--tmss-shadow-soft: 0 6px 18px rgba(21, 39, 58, .06);
			--tmss-radius: 10px;

			color: var(--tmss-text);
			background: var(--tmss-bg);
			font-size: 13px;
			padding: 18px;
			display: grid;
			grid-template-columns: minmax(290px, 25%) minmax(620px, 75%);
			gap: 18px;
			align-items: stretch;
			--tmss-chrome: 150px;	/* fallback antes de _fithgt; el alto exacto lo fija el JS */
			box-sizing: border-box;
			height: calc(100vh - var(--tmss-chrome));
			overflow: hidden;
		}
		#<?= $lv_sec; ?> .tmss-pat-dtl,
		#<?= $lv_sec; ?> .tmss-pat-dtl * { box-sizing: border-box; }
		/* el form estandar trae padding-bottom: 60px que generaria scroll: lo anulo solo aca */
		#<?= $lv_sec; ?> #<?= $lv_sec; ?>_frm { padding-bottom: 0; margin: 0; }

		/* tarjetas */
		#<?= $lv_sec; ?> .tmss-card {
			background: #fff;
			border: 1px solid var(--tmss-line);
			border-radius: var(--tmss-radius);
			box-shadow: var(--tmss-shadow-soft);
			overflow: hidden;
		}
		#<?= $lv_sec; ?> .tmss-card .card-header {
			min-height: 58px;
			padding: 15px 18px;
			border-bottom: 1px solid var(--tmss-line);
			display: flex;
			align-items: center;
			justify-content: space-between;
			gap: 12px;
			background: linear-gradient(180deg, #fff, #fbfdff);
			color: #2c3a50;
			font-weight: 900;
		}
		#<?= $lv_sec; ?> .card-title { display: flex; align-items: center; gap: 10px; min-width: 0; }
		#<?= $lv_sec; ?> .card-title i { color: var(--tmss-blue); font-size: 17px; }
		#<?= $lv_sec; ?> .card-title h2 { margin: 0; color: #2c3a50; font-size: 16px; font-weight: 900; letter-spacing: -.1px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
		#<?= $lv_sec; ?> .card-title small { color: #6d7a8d; font-size: 11px; font-weight: 700; margin-left: 2px; }

		/* ---- columna izquierda: resumen del paciente ---- */
		#<?= $lv_sec; ?> .patient-summary { display: flex; flex-direction: column; min-height: 0; }
		#<?= $lv_sec; ?> .summary-body { padding: 6px 18px 14px; overflow: auto; flex: 1; min-height: 0; }
		#<?= $lv_sec; ?> .summary-line { display: grid; grid-template-columns: 44px 1fr; gap: 12px; align-items: center; padding: 11px 0; }
		#<?= $lv_sec; ?> .summary-line + .summary-line { border-top: 1px solid #f0f3f7; }
		#<?= $lv_sec; ?> .summary-icon { width: 38px; height: 38px; border-radius: 999px; background: #eef7ff; color: var(--tmss-blue); display: inline-flex; align-items: center; justify-content: center; font-size: 16px; }
		#<?= $lv_sec; ?> .summary-label { color: #6d7a8d; font-size: 12px; font-weight: 900; margin-bottom: 4px; }
		#<?= $lv_sec; ?> .summary-value { color: #26354b; font-size: 13px; font-weight: 900; line-height: 1.35; }
		#<?= $lv_sec; ?> .summary-divider { height: 1px; background: var(--tmss-line); margin: 10px 0; }
		#<?= $lv_sec; ?> .summary-status { display: inline-flex; align-items: center; width: fit-content; padding: 5px 8px; border-radius: 5px; background: var(--tmss-green-soft); color: #187a40; font-size: 10px; font-weight: 900; text-transform: uppercase; }
		#<?= $lv_sec; ?> .summary-status.inactive { background: #fdecec; color: #b3261e; }
		#<?= $lv_sec; ?> .protocol-link { color: var(--tmss-blue-dark); font-weight: 900; text-decoration: none; border-bottom: 1px dashed rgba(11,127,210,.6); }

		/* ---- columna derecha: contactos + evoluciones ---- */
		#<?= $lv_sec; ?> .main-stack { display: grid; grid-template-rows: minmax(0, .95fr) minmax(0, 1.05fr); gap: 18px; min-height: 0; }
		#<?= $lv_sec; ?> .content-card { display: flex; flex-direction: column; min-height: 0; }
		#<?= $lv_sec; ?> .content-card .table-wrap { overflow: auto; flex: 1; min-height: 0; padding: 0 12px; }

		#<?= $lv_sec; ?> table.dtl-table { width: 100%; border-collapse: separate; border-spacing: 0; margin: 0; min-width: 640px; }
		#<?= $lv_sec; ?> table.dtl-table th {
			position: sticky; top: 0; z-index: 2;
			background: linear-gradient(180deg, #fff, #fbfdff);
			border-bottom: 1px solid #d9e0e9; color: #4c5a6e;
			padding: 11px 12px; text-align: left; font-size: 12px; font-weight: 900; white-space: nowrap;
		}
		#<?= $lv_sec; ?> table.dtl-table td { padding: 11px 12px; border-bottom: 1px solid #eef2f7; color: #29364a; font-size: 12px; vertical-align: middle; white-space: nowrap; }
		#<?= $lv_sec; ?> table.dtl-table tbody tr:hover { background: #f7fbff; }
		#<?= $lv_sec; ?> .crm-row-title { font-weight: 800; white-space: normal; line-height: 1.35; max-width: 260px; }

		/* etiquetas (motivo) */
		#<?= $lv_sec; ?> .pill { display: inline-flex; align-items: center; justify-content: center; min-height: 22px; border-radius: 5px; padding: 5px 9px; font-size: 10px; line-height: 1; font-weight: 900; text-transform: uppercase; letter-spacing: .01em; background: #e6f4ff; color: #1681d8; border: 1px solid #d2ecff; }

		/* estado de realizacion de la evolucion (SI = realizada / NO = pendiente) */
		#<?= $lv_sec; ?> .rlz { display: inline-flex; align-items: center; justify-content: center; min-height: 22px; border-radius: 5px; padding: 5px 9px; font-size: 10px; line-height: 1; font-weight: 900; text-transform: uppercase; letter-spacing: .01em; }
		#<?= $lv_sec; ?> .rlz-si { background: var(--tmss-green-soft); color: #187a40; border: 1px solid #bfe8cf; }
		#<?= $lv_sec; ?> .rlz-no { background: #fdecec; color: #b3261e; border: 1px solid #f5c9c9; }

		/* estado (punto + texto) */
		#<?= $lv_sec; ?> .status-dot { display: inline-flex; align-items: center; gap: 7px; font-weight: 900; color: #354156; font-size: 11px; text-transform: uppercase; }
		#<?= $lv_sec; ?> .status-dot::before { content: ""; width: 8px; height: 8px; border-radius: 999px; display: inline-block; background: #92acd0; }
		#<?= $lv_sec; ?> .status-dot.open::before { background: var(--tmss-orange); }
		#<?= $lv_sec; ?> .status-dot.closed::before { background: var(--tmss-green); }
		#<?= $lv_sec; ?> .status-dot.course::before { background: var(--tmss-blue); }

		#<?= $lv_sec; ?> .evolution-text { white-space: normal; line-height: 1.42; max-width: 760px; }
		#<?= $lv_sec; ?> .evolution-text strong { display: block; color: #2d3b50; margin-bottom: 2px; }
		#<?= $lv_sec; ?> .evolution-text span { color: #536174; }

		#<?= $lv_sec; ?> .table-footer { min-height: 42px; border-top: 1px solid var(--tmss-line); padding: 9px 18px; color: #67768a; background: #fff; display: flex; align-items: center; justify-content: space-between; gap: 12px; font-size: 12px; flex-wrap: wrap; }
		#<?= $lv_sec; ?> .count-badge { background: var(--tmss-blue); color: #fff; border-radius: 999px; padding: 2px 7px; font-weight: 900; min-width: 20px; text-align: center; display: inline-flex; align-items: center; justify-content: center; }
		#<?= $lv_sec; ?> .dtl-empty { padding: 28px 18px; text-align: center; color: #99a3b1; }
		#<?= $lv_sec; ?> .dtl-empty i { font-size: 30px; display: block; margin-bottom: 10px; opacity: .55; }

		/* responsive */
		@media (max-width: 1360px) {
			#<?= $lv_sec; ?> .tmss-pat-dtl { grid-template-columns: 300px 1fr; }
		}
		@media (max-width: 1050px) {
			#<?= $lv_sec; ?> .tmss-pat-dtl { grid-template-columns: 1fr; height: auto; overflow: auto; }
			#<?= $lv_sec; ?> .main-stack { grid-template-rows: auto auto; }
			#<?= $lv_sec; ?> .content-card .table-wrap { max-height: 50vh; }
		}
		@media (max-width: 720px) {
			#<?= $lv_sec; ?> .tmss-pat-dtl { padding: 12px; gap: 12px; }
		}
	</style>

	<form method="POST" class="tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<div class="tmss-pat-dtl">

			<!-- I Z Q U I E R D A :   R E S U M E N   D E L   P A C I E N T E -->
			<aside class="tmss-card patient-summary">
				<div class="card-header">
					<div class="card-title"><i class="fa-regular fa-user"></i> <h2>Resumen del paciente</h2></div>
				</div>
				<div class="summary-body">
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-solid fa-hospital-user"></i></span>
						<div>
							<div class="summary-label">ID interno</div>
							<div class="summary-value"><?= $lv_val($vew_data->patcod ?? ''); ?></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-regular fa-clipboard"></i></span>
						<div>
							<div class="summary-label">Cod. de protocolo</div>
							<div class="summary-value"><span class="protocol-link"><?= $lv_val($vew_data->patcodext ?? ''); ?></span></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-solid fa-location-dot"></i></span>
						<div>
							<div class="summary-label">Provincia</div>
							<div class="summary-value"><?= $lv_val($vew_data->adr->lndregtxt ?? ''); ?></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-regular fa-building"></i></span>
						<div>
							<div class="summary-label">Localidad</div>
							<div class="summary-value"><?= $lv_val($vew_data->adr->adrtwn ?? ''); ?></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-solid fa-award"></i></span>
						<div>
							<div class="summary-label">Patolog&iacute;a</div>
							<div class="summary-value"><?= $lv_val($vew_data->hltdisclstxt ?? ''); ?></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-solid fa-shield-heart"></i></span>
						<div>
							<div class="summary-label">Obra social</div>
							<div class="summary-value"><?= $lv_val($vew_data->custxt ?? ''); ?></div>
						</div>
					</div>

					<div class="summary-divider"></div>

					<div class="summary-line">
						<span class="summary-icon"><i class="fa-regular fa-calendar-check"></i></span>
						<div>
							<div class="summary-label">Paciente activo desde</div>
							<div class="summary-value"><?= $lv_val($lv_fdte($vew_data->patinbdte ?? '')); ?></div>
						</div>
					</div>
					<div class="summary-line">
						<span class="summary-icon"><i class="fa-solid fa-circle-check"></i></span>
						<div>
							<div class="summary-label">Estado del paciente</div>
							<span class="summary-status<?= (($vew_data->docsts ?? '')!='A' && ($vew_data->docsts ?? '')!='' ? ' inactive' : ''); ?>"><?= htmlspecialchars( ($vew_data->docsts ?? '')=='A' ? 'ACTIVO' : ( ($vew_data->docsts ?? '')=='I' ? 'INACTIVO' : ( ($vew_data->docsts ?? '')!='' ? $vew_data->docsts : '-' ) ) ); ?></span>
						</div>
					</div>
				</div>
			</aside>

			<!-- D E R E C H A :   C O N T A C T O S   +   E V O L U C I O N E S -->
			<section class="main-stack">

				<!-- Contactos CRM del paciente (contactos cargados server-side desde $vew_data->cnt, op #crmslsdtl) -->
				<?php
					// contactos recuperados en el controlador con getList (op #crmslsdtl): array de filas.
					// Acceso DIRECTO (sin isset()): el modelo expone la propiedad via __get, pero el
					// isset()/?? magico devuelve false si no hay __isset -> dejaria la card vacia.
					$lv_cntrs = $vew_data->cnt;
					if ( !is_array($lv_cntrs) ) { $lv_cntrs = array(); }
				?>
				<article class="tmss-card content-card">
					<div class="card-header">
						<div class="card-title"><i class="fa-solid fa-users"></i> <h2>Contactos CRM <small>(del paciente)</small></h2></div>
					</div>
					<div class="table-wrap">
						<table class="dtl-table">
							<thead>
								<tr>
									<th><?= $vew_lang->date; ?></th>
									<th><?= $vew_lang->type; ?></th>
									<th><?= $vew_lang->motive; ?></th>
									<th><?= $vew_lang->title; ?></th>
									<th><?= $vew_lang->status; ?></th>
									<th><?= $vew_lang->duedate; ?></th>
								</tr>
							</thead>
							<tbody id="crmrow">
								<?php if ( count($lv_cntrs) == 0 ) { ?>
									<tr><td colspan="6"><div class="dtl-empty"><i class="fa-regular fa-folder-open"></i> Sin contactos para este paciente.</div></td></tr>
								<?php } else {
									foreach ( $lv_cntrs as $lv_cnt ) {
										// Fecha (CrmCntReqDte, o CrmCntDte / CteDte como fallback) | Tipo | Motivo (badge coloreado con el token
										// <clr> resuelto en el controlador, crmcntprtclr) | Titulo | Estado (punto por clase) | Vencimiento
										$lv_cdte = ( ($lv_cnt['crmcntreqdte'] ?? '')!=='' && ($lv_cnt['crmcntreqdte'] ?? null)!==null ) ? $lv_cnt['crmcntreqdte']
															 : ( ( ($lv_cnt['crmcntdte'] ?? '')!=='' && ($lv_cnt['crmcntdte'] ?? null)!==null ) ? $lv_cnt['crmcntdte'] : ($lv_cnt['ctedte'] ?? '') );
										$lv_cmtv  = trim( (string)($lv_cnt['crmcntmtvtxt'] ?? '') );			// texto del motivo
										$lv_cclr  = trim( (string)($lv_cnt['crmcntprtclr'] ?? '') );			// token de color <clr> (resuelto en el controlador)
										$lv_ccls  = (string)($lv_cnt['crmcntstscls'] ?? '');					// clase de estado (1=cerrado / 0=abierto)
										$lv_cstsc = ( $lv_ccls==='1' ? 'closed' : ( $lv_ccls==='0' ? 'open' : '' ) );
								?>
									<tr>
										<td><?= $lv_val($lv_fdte($lv_cdte)); ?></td>
										<td><?= $lv_val($lv_cnt['crmcnttyptxt'] ?? ''); ?></td>
										<td><?php
											if ( $lv_cmtv=='' ) { echo '&mdash;'; }
											elseif ( $lv_cclr!='' ) { $lv_c='var('.htmlspecialchars($lv_cclr).')'; ?><span class="pill" style="background:color-mix(in srgb, <?= $lv_c; ?> 14%, #fff);color:<?= $lv_c; ?>;border-color:color-mix(in srgb, <?= $lv_c; ?> 32%, #fff)"><?= htmlspecialchars($lv_cmtv); ?></span><?php }
											else { ?><span class="pill" style="background:#f0f2f5;color:#6d7a8d;border-color:#e2e8f0"><?= htmlspecialchars($lv_cmtv); ?></span><?php }
										?></td>
										<td class="crm-row-title"><?= $lv_val($lv_cnt['crmcnttxt'] ?? ''); ?></td>
										<td><span class="status-dot <?= $lv_cstsc; ?>"><?= $lv_val($lv_cnt['crmcntststxt'] ?? ''); ?></span></td>
										<td><?= $lv_val($lv_fdte($lv_cnt['crmcntduedte'] ?? '')); ?></td>
									</tr>
								<?php } } ?>
							</tbody>
						</table>
					</div>
					<footer class="table-footer">
						<div><span id="crmqtytxt"><?= $vew_lang->get('records'); ?></span> <span id="crmqty" class="count-badge"><?= count($lv_cntrs); ?></span></div>
					</footer>
				</article>

				<!-- Historia Clinica del paciente (evoluciones cargadas server-side desde $vew_data->evl, op #crmslsdtl) -->
				<?php
					// evoluciones recuperadas en el controlador con getList (op #crmslsdtl): array de filas.
					// Acceso DIRECTO (sin isset()): el modelo expone la propiedad via __get, pero el
					// isset()/?? magico devuelve false si no hay __isset -> dejaba la card vacia.
					$lv_evlrs = $vew_data->evl;
					if ( !is_array($lv_evlrs) ) { $lv_evlrs = array(); }
				?>
				<article class="tmss-card content-card">
					<div class="card-header">
						<div class="card-title"><i class="fa-solid fa-wave-square"></i> <h2>Historia Cl&iacute;nica</h2></div>
					</div>
					<div class="table-wrap">
						<table class="dtl-table">
							<thead>
								<tr>
									<th><?= $vew_lang->date; ?></th>
									<th>Prestador</th>
									<th>Evoluci&oacute;n</th>
									<th>Realizada</th>
									<th><?= $vew_lang->motive; ?></th>
								</tr>
							</thead>
							<tbody id="evlrow">
								<?php if ( count($lv_evlrs) == 0 ) { ?>
									<tr><td colspan="5"><div class="dtl-empty"><i class="fa-regular fa-folder-open"></i> Sin registros de historia cl&iacute;nica para mostrar.</div></td></tr>
								<?php } else {
									foreach ( $lv_evlrs as $lv_evl ) {
										// Fecha | Realizada (DocSts: A=SI / P=NO) | Prestador (HltPrsTxt) | Evolucion (SpcTxt + EvlEvl) | Motivo de no realizacion
										$lv_dsc  = trim( (string)($lv_evl['spctxt'] ?? '') );
										$lv_dtl  = trim( (string)($lv_evl['evlevl'] ?? '') );
										$lv_dsts = strtoupper( trim( (string)($lv_evl['docsts'] ?? '') ) );			// estado de realizacion
										$lv_prs  = trim( (string)($lv_evl['hltprstxt'] ?? ($lv_evl['prstxt'] ?? '')) );	// prestador de la evolucion / planificacion
										$lv_mtv  = trim( (string)($lv_evl['evlcncmtvtxt'] ?? '') );					// motivo de no realizacion (resuelto en el controlador)
								?>
									<tr>
										<td><?= $lv_val($lv_fdte($lv_evl['evldte'] ?? '')); ?></td>
										<td><?= $lv_val($lv_prs); ?></td>
										<td><div class="evolution-text"><strong><?= ($lv_dsc!='' ? nl2br(htmlspecialchars($lv_dsc)) : '&mdash;'); ?></strong><?= ($lv_dtl!='' ? '<span>'.nl2br(htmlspecialchars($lv_dtl)).'</span>' : ''); ?></div></td>
										<td><?php if ( $lv_dsts=='A' ) { ?><span class="rlz rlz-si">S&iacute;</span><?php } elseif ( $lv_dsts=='P' ) { ?><span class="rlz rlz-no">No</span><?php } else { echo '&mdash;'; } ?></td>
										<td><?= ( $lv_dsts=='P' ? $lv_val($lv_mtv) : '&mdash;' ); ?></td>
									</tr>
								<?php } } ?>
							</tbody>
						</table>
					</div>
					<footer class="table-footer">
						<div><span id="evlqtytxt"><?= $vew_lang->get('records'); ?></span> <span id="evlqty" class="count-badge"><?= count($lv_evlrs); ?></span></div>
					</footer>
				</article>

			</section>
		</div> <!-- /tmss-pat-dtl -->
	</form>

	<script>
		// ------------------------------------------------------------------------
		//   F I C H A   D E   P A C I E N T E   ( paciente: <?= $vew_data->patcod ?? ''; ?> )
		// ------------------------------------------------------------------------
		var <?= $lv_sec; ?>_patcod    = "<?= $vew_data->patcod ?? ''; ?>";
		var <?= $lv_sec; ?>_patcodext = "<?= $vew_data->patcodext ?? ''; ?>";

		// ------------------------------------------------------------------------
		//   A L T O   ( la ficha ocupa el alto disponible: sin scroll de pagina )
		// ------------------------------------------------------------------------
		function <?= $lv_sec; ?>_fithgt() {
			var lo_wsp = document.querySelector("#<?= $lv_sec; ?> .tmss-pat-dtl");
			if ( !lo_wsp ) { return; }
			if ( window.innerWidth <= 1050 ) { lo_wsp.style.height = ""; return; }

			var lv_top    = lo_wsp.getBoundingClientRect().top;
			var lv_btm = window.innerHeight;
			var lo_anc = lo_wsp.parentElement;
			while ( lo_anc && lo_anc !== document.body && lo_anc !== document.documentElement ) {
				var lv_ovy = window.getComputedStyle(lo_anc).overflowY;
				if ( lv_ovy === "auto" || lv_ovy === "scroll" || lv_ovy === "hidden" ) {
					var lv_b = lo_anc.getBoundingClientRect().bottom;
					if ( lv_b > 0 && lv_b < lv_btm ) { lv_btm = lv_b; }
				}
				lo_anc = lo_anc.parentElement;
			}
			lo_wsp.style.height = Math.max(360, Math.floor(lv_btm - lv_top)) + "px";
		}
		$(window).on("resize", <?= $lv_sec; ?>_fithgt);

		// ------------------------------------------------------------------------
		//   R E F R E S H   ( carga de datos de la ficha )
		// ------------------------------------------------------------------------
		// Ajusta el alto en la carga inicial (los datos -contactos e historia clinica- se renderizan
		// server-side en la op #crmslsdtl, no hay carga client-side que disparar aca).
		function <?= $lv_sec; ?>_refresh() {
			<?= $lv_sec; ?>_fithgt();		// reajusta el alto disponible
		}

		// Actualizar (boton del toolbar, enganchado via vew_tbl['rfrsh']['acc']): reabre la ficha para
		// traer datos frescos del servidor (mismo mecanismo con el que el listado abre la ficha).
		function <?= $lv_sec; ?>_reload() {
			if ( <?= $lv_sec; ?>_patcod=="" ) { <?= $lv_sec; ?>_fithgt(); return; }
			tmssLink("?prg=zcutp1_ttr&act=crmslsdtl", [{target:"_new_section", post_data:[
				{name:"patcod",    value: <?= $lv_sec; ?>_patcod},
				{name:"patcodext", value: <?= $lv_sec; ?>_patcodext}
			]}]);
		}

		// carga inicial (document.ready: corre cuando el DOM de la seccion ya esta asentado)
		$(document).ready( <?= $lv_sec; ?>_refresh );
	</script>

	<?php include( 'grldocfrmscr.frm' ); ?>
</section>