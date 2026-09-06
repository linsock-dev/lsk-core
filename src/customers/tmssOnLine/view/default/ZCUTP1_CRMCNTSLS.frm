<?php
	// url del formulario
	$lv_lnk = '?prg=zcutp1_tmg&act=crmslsdsh';

	// campos requeridos (la vista unificada lista contactos; no tiene campos obligatorios)
	$vew_input->setReqFields( array() );

	// clave del documento (vista de listado: no aplica un documento puntual)
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->contacts;

	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
	$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;

	// permiso para responder el ticket (operacion '05', misma logica que la vista CRMCNT)
	// si el usuario no tiene el permiso, no se muestra la caja de respuesta (textarea + boton enviar)
	$lv_canrpl = $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05');

	// valores x default
	// (la vista lista contactos existentes; sin valores por defecto)

	// libreria de estilos bootstrap
	include_once('_library.frm');

	// Botones por vista
	// se ocultan los botones por defecto Nuevo y Modificar (per=false) y se deja unicamente Actualizar a la derecha
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);	// se deshabilita el copiado (boton estandar de SYSDOCHDR)
	$vew_tbl['rfrsh'] = array('per'=>true, 'acc'=>$lv_sec.'_refresh()');	// Actualizar: ejecuta la funcion refresh (recarga toda la vista)

	// Origenes. (la grilla lista todos los origenes; se inicializan por consistencia con la vista estandar)
	$lv_srcobjtyp = strtoupper( (isset($vew_data->sysdoccls) && is_object($vew_data->sysdoccls)) ? $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp') : '' );
	$lv_srcurl = '';
	$lv_srccod = '';
	$lv_srctxt = '';
	$lv_srclbl = $vew_lang->requester;
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

	<style>
		/* ----------------------------------------------------------------------
		   REPLICA DEL MAQUETADO /// Estilos 100% CSS + Font Awesome 6 
		   ---------------------------------------------------------------------- */
		#<?= $lv_sec; ?> .tmss-crm-ws {
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
			--tmss-purple: #8b5cf6;
			--tmss-cyan: #14a6b7;
			--tmss-shadow: 0 10px 28px rgba(21, 39, 58, .08);
			--tmss-shadow-soft: 0 6px 18px rgba(21, 39, 58, .06);
			--tmss-radius: 10px;
			--tmss-radius-sm: 7px;

			color: var(--tmss-text);
			background: var(--tmss-bg);
			font-size: 13px;
			padding: 18px;
			display: grid;
			grid-template-columns: minmax(560px, 1fr) minmax(560px, 1fr);
			gap: 18px;
			align-items: stretch;
			/* la vista ocupa el alto disponible y el scroll queda dentro de cada panel (sin scroll de pagina) */
			/* --tmss-chrome es solo el fallback antes de que corra _fithgt; el alto exacto lo fija el JS */
			--tmss-chrome: 150px;
			box-sizing: border-box;	/* el padding (18px) entra dentro del alto, asi no desborda el viewport */
			height: calc(100vh - var(--tmss-chrome));
			overflow: hidden;
		}
		#<?= $lv_sec; ?> .tmss-crm-ws,
		#<?= $lv_sec; ?> .tmss-crm-ws * { box-sizing: border-box; }
		/* el form estandar trae padding-bottom: 60px que generaba scroll bajo el workspace: lo anulo solo aca */
		#<?= $lv_sec; ?> #<?= $lv_sec; ?>_frm { padding-bottom: 0; margin: 0; }

		#<?= $lv_sec; ?> .tmss-crm-ws .panel {
			min-width: 0;
			min-height: 0;
			background: transparent;
			border: 0;
			box-shadow: none;
			display: flex;
			flex-direction: column;
			gap: 14px;
			margin: 0;
			overflow: hidden;
		}

		/* tarjeta de la bandeja (izquierda): ocupa todo el panel y el scroll vive en la tabla */
		#<?= $lv_sec; ?> .list-card { flex: 1; display: flex; flex-direction: column; min-height: 0; }

		/* tarjetas */
		#<?= $lv_sec; ?> .tmss-card {
			background: #fff;
			border: 1px solid var(--tmss-line);
			border-radius: var(--tmss-radius);
			box-shadow: var(--tmss-shadow-soft);
			overflow: hidden;
		}
		#<?= $lv_sec; ?> .detail-summary { border-top: 4px solid var(--tmss-blue); }

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
		#<?= $lv_sec; ?> .card-title {
			display: flex;
			align-items: center;
			gap: 10px;
			min-width: 0;
			float: none;
			font-size: 16px;
			font-weight: 900;
			color: #2c3a50;
		}
		#<?= $lv_sec; ?> .card-title i { color: var(--tmss-blue); font-size: 17px; }

		/* boton de filtros en el header de la bandeja */
		#<?= $lv_sec; ?> .card-header #btnflt {
			display: inline-flex; align-items: center; gap: 6px; height: 36px; padding: 0 11px; margin: 0;
			border: 1px solid #d7e8f8; border-radius: 8px; background: #f7fbff; color: var(--tmss-blue-dark);
			box-shadow: none; font-weight: 700;
		}
		#<?= $lv_sec; ?> .card-header #btnflt:hover { background: #eef8ff; border-color: #badcf7; }
		#<?= $lv_sec; ?> .card-header #btnflt .badge { background: var(--tmss-blue); color: #fff; }
		#<?= $lv_sec; ?> .card-header #btnflt .badge:empty { display: none; }

		/* tabla */
		#<?= $lv_sec; ?> .table-wrap { overflow: auto; flex: 1; min-height: 0; }
		#<?= $lv_sec; ?> table.crm-table { width: 100%; border-collapse: separate; border-spacing: 0; margin: 0; min-width: 640px; }
		#<?= $lv_sec; ?> table.crm-table th {
			position: sticky;
			top: 0;
			z-index: 2;
			background: linear-gradient(180deg, #fff, #fbfdff);
			border-bottom: 1px solid #d9e0e9;
			color: #4c5a6e;
			padding: 11px 12px;
			text-align: left;
			font-size: 12px;
			font-weight: 900;
			white-space: nowrap;
		}
		#<?= $lv_sec; ?> table.crm-table td {
			padding: 11px 12px;
			border-bottom: 1px solid #eef2f7;
			color: #29364a;
			font-size: 12px;
			vertical-align: middle;
			white-space: nowrap;
		}
		#<?= $lv_sec; ?> table.crm-table tbody tr { cursor: pointer; transition: background .15s ease, box-shadow .15s ease; }
		#<?= $lv_sec; ?> table.crm-table tbody tr:hover { background: #f7fbff; }
		#<?= $lv_sec; ?> table.crm-table tbody tr.selected,
		#<?= $lv_sec; ?> table.crm-table tbody tr.selected td { background: #eef7ff; }
		#<?= $lv_sec; ?> table.crm-table tbody tr.selected { box-shadow: inset 4px 0 0 var(--tmss-blue); }
		#<?= $lv_sec; ?> .crm-id { font-weight: 900; color: #29384e; }
		#<?= $lv_sec; ?> .row-title { max-width: 230px; overflow: hidden; text-overflow: ellipsis; font-weight: 800; color: #273549; line-height: 1.35; }

		/* etiquetas (motivo) */
		#<?= $lv_sec; ?> .tag {
			display: inline-flex; align-items: center; justify-content: center; gap: 5px;
			min-height: 22px; border-radius: 5px; padding: 5px 9px; font-size: 10px; line-height: 1;
			font-weight: 900; text-transform: uppercase; letter-spacing: .01em;
			background: #e6f4ff; color: #1681d8; border: 1px solid #d2ecff;
		}

		/* estado (punto + texto) */
		#<?= $lv_sec; ?> .status { display: inline-flex; align-items: center; gap: 7px; font-weight: 900; color: #354156; font-size: 11px; text-transform: uppercase; }
		#<?= $lv_sec; ?> .status .dot { width: 8px; height: 8px; border-radius: 999px; display: inline-block; background: #92acd0; flex: 0 0 auto; }

		/* enlace de referencia / protocolo */
		#<?= $lv_sec; ?> .protocol-link { color: var(--tmss-blue-dark); font-weight: 900; text-decoration: none; border-bottom: 1px dashed rgba(11,127,210,.6); cursor: pointer; }
		#<?= $lv_sec; ?> .protocol-link:hover { color: #075f9d; border-bottom-style: solid; }

		/* pie de la grilla */
		#<?= $lv_sec; ?> .table-footer {
			min-height: 46px; border-top: 1px solid var(--tmss-line); padding: 9px 18px;
			color: #67768a; background: #fff; display: flex; align-items: center; justify-content: space-between;
			gap: 12px; font-size: 12px; flex-wrap: wrap;
		}
		#<?= $lv_sec; ?> .count-badge {
			background: var(--tmss-blue); color: #fff; border-radius: 999px; padding: 2px 7px; font-weight: 900;
			min-width: 20px; text-align: center; display: inline-flex; align-items: center; justify-content: center;
		}

		/* ---- panel de detalle ---- */
		#<?= $lv_sec; ?> .summary-top {
			display: grid; grid-template-columns: minmax(90px, 110px) 1fr auto; gap: 18px;
			padding: 16px 20px 12px; align-items: start; background: #fff;
		}
		#<?= $lv_sec; ?> .summary-label { display: block; color: #738197; font-size: 11px; font-weight: 900; margin-bottom: 6px; }
		#<?= $lv_sec; ?> .summary-id { color: var(--tmss-blue-dark); font-size: 21px; line-height: 1; font-weight: 900; }
		#<?= $lv_sec; ?> .summary-title h2 { margin: 0; font-size: 19px; color: #213047; letter-spacing: -.25px; text-transform: uppercase; }
		/* Cod. Protocolo: en la cabecera de la card, al costado del titulo y tirado a la derecha (estilo del # CrmCntCod de la vista CrmCnt) */
		#<?= $lv_sec; ?> .summary-protocol { min-width: 0; text-align: right; }
		#<?= $lv_sec; ?> .summary-protocol .protocol-value { display: inline-flex; align-items: center; gap: 6px; color: var(--tmss-blue-dark); font-weight: 900; font-size: 14px; white-space: nowrap; }
		#<?= $lv_sec; ?> .summary-actions { display: flex; align-items: center; gap: 9px; flex-wrap: nowrap; }

		#<?= $lv_sec; ?> .tmss-btn {
			height: 37px; border: 1px solid var(--tmss-line); border-radius: 6px; background: #fff; color: #536174;
			padding: 0 14px; display: inline-flex; align-items: center; justify-content: center; gap: 8px;
			font-weight: 700; white-space: nowrap; box-shadow: 0 2px 8px rgba(21,39,58,.025); cursor: pointer;
		}
		#<?= $lv_sec; ?> .tmss-btn.primary { background: var(--tmss-blue); color: #fff; border-color: var(--tmss-blue); box-shadow: 0 6px 14px rgba(29,154,242,.24); }

		#<?= $lv_sec; ?> .summary-data {
			border-top: 1px solid var(--tmss-line); padding: 12px 20px;
			display: grid; grid-template-columns: repeat(6, minmax(0, 1fr)); gap: 10px 14px; background: #fff;
		}
		#<?= $lv_sec; ?> .summary-item { min-width: 0; }
		#<?= $lv_sec; ?> .summary-item .item-label { display: flex; align-items: center; gap: 6px; color: #6d7a8d; font-size: 11px; font-weight: 900; margin-bottom: 4px; white-space: nowrap; }
		#<?= $lv_sec; ?> .summary-item .item-label i { color: #8493a7; }
		#<?= $lv_sec; ?> .summary-item .item-value { color: #243044; font-size: 13px; font-weight: 900; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
		#<?= $lv_sec; ?> .priority-low { color: #243044; display: inline-flex; align-items: center; gap: 6px; }
		#<?= $lv_sec; ?> .priority-low i { color: var(--tmss-muted); font-size: 11px; }	/* color real por <clr> de crmcntprtatr (inline); este es el fallback sin dato */

		#<?= $lv_sec; ?> #divdtl { flex: 1; min-height: 0; display: flex; flex-direction: column; gap: 14px; }	/* separa el detalle resumen de la card de historial */
		#<?= $lv_sec; ?> #divdtl > .detail-summary { flex: 0 0 auto; }	/* el resumen mantiene su alto; el detalle ocupa el resto */
		#<?= $lv_sec; ?> .detail-content { flex: 1; min-height: 0; overflow: hidden; display: grid; grid-template-columns: minmax(300px, 40%) minmax(360px, 60%); gap: 14px; }
		#<?= $lv_sec; ?> .detail-card { display: flex; flex-direction: column; min-height: 0; }
		#<?= $lv_sec; ?> .detail-card .card-body { padding: 16px; overflow: auto; flex: 1; min-height: 0; }
		#<?= $lv_sec; ?> .description-card .card-body { display: flex; flex-direction: column; gap: 18px; color: #435065; font-size: 13px; line-height: 1.62; }
		#<?= $lv_sec; ?> .description-text { margin: 0; white-space: pre-line; }

		/* cartel de actividad del motivo (CrmCntMtvAct) dentro de la card de Descripcion */
		#<?= $lv_sec; ?> .description-note {
			margin-top: auto; border: 1px solid #dceeff; background: #f4fbff; border-radius: 8px;
			padding: 12px; color: #35627f; line-height: 1.5; font-weight: 700; white-space: pre-line;
			display: flex; gap: 9px; align-items: flex-start;
		}
		#<?= $lv_sec; ?> .description-note i { color: var(--tmss-blue-dark); margin-top: 2px; }

		/* card de historial: el listado ocupa el alto disponible y el compositor queda fijo al pie */
		#<?= $lv_sec; ?> .history-card .card-body { display: flex; flex-direction: column; gap: 14px; padding: 16px; overflow: hidden; }
		#<?= $lv_sec; ?> #dtlhst { flex: 1; min-height: 0; overflow: auto; }	/* UN solo scroll: el de este wrapper */

		/* El componente sysdocchg se monta en #divchgdoclst (mismo id que espera en la vista estandar CRMCNT),
		   pero trae su propia card ("Historial") + su propio scroll interno. Como la card de Comentarios ya da
		   el marco y el titulo, aplano TODO lo que el componente traiga adentro para que la timeline quede
		   directamente dentro de la card de comentarios y quede UN solo scroll (el de #dtlhst).
		   Los selectores van por descendiente a proposito: cada entrada del historial es una fila de timeline
		   (punto + nombre + texto + fecha), no una card, asi que aplanar en profundidad no la afecta. */
		#<?= $lv_sec; ?> #dtlhst .tmss-scrollbar,
		#<?= $lv_sec; ?> #dtlhst [style*="overflow"],
		#<?= $lv_sec; ?> #dtlhst [style*="max-height"] { overflow: visible !important; max-height: none !important; height: auto !important; }
		#<?= $lv_sec; ?> #dtlhst .card,
		#<?= $lv_sec; ?> #dtlhst .panel,
		#<?= $lv_sec; ?> #dtlhst .tmss-card {
			border: 0 !important; border-radius: 0 !important; background: transparent !important;
			box-shadow: none !important; margin: 0 !important;
		}
		#<?= $lv_sec; ?> #dtlhst .card > .card-header,
		#<?= $lv_sec; ?> #dtlhst .panel > .panel-heading { display: none !important; }	/* el titulo ya lo da la card de comentarios */
		#<?= $lv_sec; ?> #dtlhst .card > .card-body,
		#<?= $lv_sec; ?> #dtlhst .panel > .panel-body { padding: 0 !important; }

		/* caja de comentarios / respuesta del ticket */
		#<?= $lv_sec; ?> .reply-composer { flex: 0 0 auto; position: relative; margin: 0; }
		#<?= $lv_sec; ?> .reply-input {
			display: block; width: 100%; height: 38px; min-height: 38px; max-height: 96px; resize: none;
			border: 1px solid #000 !important; border-radius: 6px; outline: 0; box-shadow: none;
			background: #fff; color: #29364a; padding: 8px 40px 8px 10px;	/* deja libre la derecha para el boton */
			font-size: 13px; line-height: 1.4;
		}
		#<?= $lv_sec; ?> .reply-input::placeholder { color: #7e8795; font-weight: 700; }
		#<?= $lv_sec; ?> .reply-tools { position: absolute; right: 5px; bottom: 5px; display: flex; align-items: center; gap: 4px; }
		#<?= $lv_sec; ?> .reply-icon-btn {
			width: 30px; height: 30px; border: 0; border-radius: 6px; background: transparent; color: #2b3546;
			display: inline-flex; align-items: center; justify-content: center; font-size: 16px; cursor: pointer;
		}
		#<?= $lv_sec; ?> .reply-icon-btn:hover { background: #f1f6fb; color: var(--tmss-blue-dark); }
		#<?= $lv_sec; ?> .reply-icon-btn:disabled { opacity: .5; cursor: default; }

		/* historial / timeline */
		#<?= $lv_sec; ?> .timeline { position: relative; padding: 2px 0 2px 30px; }
		#<?= $lv_sec; ?> .timeline::before { content: ""; position: absolute; top: 16px; bottom: 19px; left: 10px; width: 2px; background: #b9d3ec; }
		#<?= $lv_sec; ?> .timeline-item { position: relative; padding: 0 0 22px 0; }
		#<?= $lv_sec; ?> .timeline-item:last-child { padding-bottom: 0; }
		#<?= $lv_sec; ?> .timeline-dot { position: absolute; left: -28px; top: 1px; width: 20px; height: 20px; background: #fff; border: 3px solid var(--tmss-blue); border-radius: 50%; z-index: 1; box-shadow: 0 0 0 4px #eef8ff; }
		#<?= $lv_sec; ?> .timeline-dot.muted { width: 11px; height: 11px; left: -23.5px; top: 6px; border: 0; background: #92acd0; box-shadow: none; }
		#<?= $lv_sec; ?> .timeline-row { display: grid; grid-template-columns: 1fr auto; gap: 10px; align-items: start; }
		#<?= $lv_sec; ?> .history-name { font-size: 11px; font-weight: 900; color: #3a4658; text-transform: uppercase; margin-bottom: 6px; }
		#<?= $lv_sec; ?> .history-text { color: #354257; line-height: 1.5; font-size: 12px; }
		#<?= $lv_sec; ?> .history-date { color: #7b8798; font-size: 11px; font-weight: 800; white-space: nowrap; }

		#<?= $lv_sec; ?> .tmss-detail-empty { padding: 48px 20px; text-align: center; color: #99a3b1; }
		#<?= $lv_sec; ?> .tmss-detail-empty i { font-size: 42px; display: block; margin-bottom: 12px; opacity: .5; }

		/* responsive (igual criterio que el maquetado) */
		@media (max-width: 1380px) {
			/* en una sola columna ya no se puede ajustar todo al alto: se habilita scroll de la vista */
			#<?= $lv_sec; ?> .tmss-crm-ws { grid-template-columns: 1fr; height: auto; overflow: auto; }
			#<?= $lv_sec; ?> .panel { overflow: visible; }
			#<?= $lv_sec; ?> .list-card { min-height: 420px; }
			#<?= $lv_sec; ?> .table-wrap { max-height: 60vh; }
			#<?= $lv_sec; ?> .detail-content { grid-template-columns: 1fr; }
			/* en una sola columna el detalle ocupa todo el ancho: los 6 datos siguen entrando en una fila */
		}
		@media (max-width: 760px) {
			#<?= $lv_sec; ?> .tmss-crm-ws { padding: 12px; gap: 12px; }
			#<?= $lv_sec; ?> .summary-top { grid-template-columns: 1fr; text-align: left; }
			#<?= $lv_sec; ?> .summary-protocol { text-align: left; }
			#<?= $lv_sec; ?> .summary-data { grid-template-columns: repeat(3, minmax(0, 1fr)); }
		}
	</style>

	<form method="POST" class="tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<div class="tmss-crm-ws">

			<!-- I Z Q U I E R D A :   B A N D E J A   C R M   ( campos fijos, alimentada por #18 ) -->
			<section class="panel">
				<article class="tmss-card detail-summary list-card">
					<div class="card-header">
						<div class="card-title"><i class="fa-solid fa-table-list"></i> <?= $vew_lang->contacts; ?></div>
						<a href="#" id="btnflt" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->filter; ?>"><i class="fas fa-filter"></i><span id="fltcnt" class="badge"></span></a>
					</div>
					<div class="table-wrap">
						<table class="table table-hover table-no-bordered table-condensed crm-table">
							<thead>
								<tr>
									<th>ID CRM</th>
									<th><?= $vew_lang->date; ?></th>
									<th><?= $vew_lang->title; ?></th>
									<th>Cod. Paciente</th>
									<th><?= $vew_lang->motive; ?></th>
									<th><?= $vew_lang->status; ?></th>
								</tr>
							</thead>
							<tbody id="crmrow"></tbody>
						</table>
					</div>
					<div class="table-footer">
						<div><span id="crmqtytxt"><?= $vew_lang->get('records'); ?></span> <span id="crmqty" class="count-badge">0</span></div>
					</div>
				</article>
			</section>

			<!-- D E R E C H A :   D E T A L L E   ( render cliente desde la fila seleccionada ) -->
			<section class="panel">
				<div id="divdtl">
					<article class="tmss-card detail-summary">
						<div class="tmss-detail-empty">
							<i class="far fa-hand-pointer"></i>
							Seleccione un contacto de la lista para ver el detalle.
						</div>
					</article>
				</div>
			</section>

		</div> <!-- /tmss-crm-ws -->
	</form>

	<script>
		// ------------------------------------------------------------------------
		// B A N D E J A   ( autonoma - campos fijos - datos via operacion #18 )
		// ------------------------------------------------------------------------

		// almacen de filas para el render del detalle (clave: crmcntcod)
		var <?= $lv_sec; ?>_rec = {};

		// listado inicial recuperado en el _tmg (op crmslsdsh, sin control de autorizacion y con el patcodext ya
		// resuelto) y adjuntado al modelo: se pinta en la carga sin un ida-y-vuelta extra.
		// Acceso DIRECTO a $vew_data->cntlst (sin isset): el modelo expone la propiedad via __get, pero el
		// isset()/?? magico devuelve false si no hay __isset.
		// OJO: se serializa con json_encode y NO con $vew_doc->getJson: getJson ademas marca la respuesta como
		// application/json, y aca la respuesta es la VISTA completa -> el cliente intentaba parsear todo el
		// html como json y la carga moria con parsererror.
<?php
		$lv_initrows = ( is_object($vew_data) ? $vew_data->cntlst : array() );
		if ( !is_array($lv_initrows) ) { $lv_initrows = array(); }
		// normalizo a utf-8 los strings que no lo sean (pueden venir latin1 de sql server): un solo byte
		// invalido haria fallar el json_encode completo. preg //u = test de utf-8 valido sin depender de mbstring.
		array_walk_recursive( $lv_initrows, function( &$lp_v ) { if ( is_string($lp_v) && @preg_match('//u',$lp_v)!==1 ) { $lp_v = utf8_encode($lp_v); } } );
		// HEX_TAG escapa < y > (que un </script> en los datos no corte el bloque); PARTIAL_OUTPUT_ON_ERROR
		// deja en null el valor problematico en vez de devolver false por toda la lista.
		$lv_initjsn = json_encode( $lv_initrows, JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT|JSON_PARTIAL_OUTPUT_ON_ERROR );
		if ( $lv_initjsn===false || $lv_initjsn===null || $lv_initjsn==='' ) { $lv_initjsn = '[]'; }
?>
		var gv_<?= $lv_sec; ?>_initrows = <?= $lv_initjsn; ?>;

		// filtro - parametros (campos: ID, Titulo, Fecha, Cod. Externo, Motivo, Estado; fldcod = alias del SP)
		var gv_<?= $lv_sec; ?>_flt = [
			{"fldttl": "ID CRM",                   "fldcod": "c.crmcntcod",    "fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
			{"fldttl": "<?= $vew_lang->title; ?>", "fldcod": "c.crmcnttxt",    "fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
			{"fldttl": "<?= $vew_lang->date; ?>",  "fldcod": "c.crmcntdte",    "fldtyp": "DATE", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
			{"fldttl": "Cod. Externo",             "fldcod": "c.crmcntrefdoc", "fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
			{"fldttl": "<?= $vew_lang->motive; ?>","fldcod": "m.crmcntmtvtxt", "fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
			{"fldttl": "<?= $vew_lang->status; ?>","fldcod": "s.crmcntststxt", "fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""}
		];

		// escape html
		function <?= $lv_sec; ?>_esc( lp_val ) {
			return $("<div>").text( lp_val==undefined||lp_val==null ? "" : lp_val ).html();
		}

		// formatea una fecha que puede venir como string o como objeto {date:"YYYY-MM-DD ..."}
		function <?= $lv_sec; ?>_fdte( lp_val ) {
			if ( !lp_val ) { return ""; }
			var lv_s = (typeof lp_val === "object") ? (lp_val.date || "") : lp_val;
			lv_s = String(lv_s).substr(0,10);
			if ( lv_s.charAt(4)=="-" ) { var p = lv_s.split("-"); return p[2]+"/"+p[1]+"/"+p[0]; }
			return lv_s;
		}

		// color del estado: token <clr> del atributo del estado (igual que la grilla estandar)
		function <?= $lv_sec; ?>_stsclr( lp_row ) {
			var lv_clr = $("<div>"+(lp_row.crmcntstsatr||"")+"</div>").find("clr").text();
			return lv_clr!="" ? ("var("+lv_clr+")") : "";
		}

		// badge de estado: punto + texto en mayusculas (replica del maquetado)
		function <?= $lv_sec; ?>_sts( lp_row ) {
			var lv_clr = <?= $lv_sec; ?>_stsclr( lp_row );
			var lv_dot = lv_clr!="" ? ' style="background:'+lv_clr+'"' : '';
			return '<span class="status"><span class="dot"'+lv_dot+'></span>'+ <?= $lv_sec; ?>_esc( lp_row.crmcntststxt||"" ) +'</span>';
		}

		// extrae el token <clr> (ej: "--tmss-red") de un atributo XML; "" si no tiene
		function <?= $lv_sec; ?>_clr( lp_atr ) {
			return $("<div>"+(lp_atr||"")+"</div>").find("clr").text();
		}

		// etiqueta de motivo coloreada con el <clr> de crmcntprtatr (prioridad)
		// el <clr> es el color "fuerte" del token (ej --tmss-red): lo uso como texto/borde y derivo un fondo
		// SUAVE con color-mix, para que el tag se vea como un badge pastel y no como un bloque 500 solido.
		function <?= $lv_sec; ?>_mtvtag( lp_row ) {
			var lv_txt = <?= $lv_sec; ?>_esc( lp_row.crmcntmtvtxt||"" );
			var lv_clr = <?= $lv_sec; ?>_clr( lp_row.crmcntprtatr );
			if ( lv_clr!="" ) {
				var lv_c = 'var('+lv_clr+')';
				return '<span class="tag" style="background:color-mix(in srgb, '+lv_c+' 14%, #fff);color:'+lv_c+';border-color:color-mix(in srgb, '+lv_c+' 32%, #fff)">'+ lv_txt +'</span>';
			}
			// sin color definido -> gris suave
			return '<span class="tag" style="background:#f0f2f5;color:#6d7a8d;border-color:#e2e8f0">'+ lv_txt +'</span>';
		}

		// prioridad: flecha segun nivel (Baja=abajo, Media=derecha, Alta=arriba, sin dato=guion)
		// color de la flecha tomado del <clr> de crmcntprtatr
		function <?= $lv_sec; ?>_prt( lp_row ) {
			var lv_txt = ( lp_row.crmcntprttxt || "" ).toString();
			var lv_up  = lv_txt.toUpperCase();
			var lv_clr = <?= $lv_sec; ?>_clr( lp_row.crmcntprtatr );
			var lv_sty = ' style="color:'+ ( lv_clr!="" ? 'var('+lv_clr+')' : '#9aa6b5' ) +'"';	// sin color definido -> gris suave
			var lv_icn;
			if      ( lv_up.indexOf("ALTA") >=0 ) { lv_icn = 'fa-arrow-up'; }
			else if ( lv_up.indexOf("MEDIA")>=0 ) { lv_icn = 'fa-arrow-right'; }
			else if ( lv_up.indexOf("BAJA") >=0 ) { lv_icn = 'fa-arrow-down'; }
			else                                  { lv_icn = 'fa-minus'; }	// sin dato -> guion medio
			var lv_lbl = ( lv_txt.trim()!="" ) ? <?= $lv_sec; ?>_esc(lv_txt) : '&mdash;';
			return '<span class="priority-low"><i class="fa-solid '+lv_icn+'"'+lv_sty+'></i>'+ lv_lbl +'</span>';
		}

		// Cod. de Protocolo como link a la ficha del paciente (data-patcod para el load, data-patcodext a mostrar)
		// el patcod (ID del paciente, necesario para abrir la ficha) es el CrmCntSrcCod del contacto
		// si no hay CrmCntSrcCod / sin protocolo se muestra un guion sin link
		function <?= $lv_sec; ?>_prtlnk( lp_row ) {
			var lv_ext = <?= $lv_sec; ?>_esc( lp_row.patcodext || "" );
			var lv_cod = <?= $lv_sec; ?>_esc( lp_row.crmcntsrccod || "" );
			if ( lv_cod=="" || lv_ext=="" ) { return lv_ext || '&mdash;'; }
			return '<span class="protocol-link" data-patcod="'+ lv_cod +'" data-patcodext="'+ lv_ext +'">'+ lv_ext +'</span>';
		}

		// abre la ficha del paciente (nueva seccion) con el patcod (necesario para el load) y el patcodext
		function <?= $lv_sec; ?>_opndtl( lp_patcod, lp_patcodext ) {
			if ( !lp_patcod ) { return; }
			tmssLink("?prg=zcutp1_tmg&act=crmslsdtl", [{target:"_new_section", post_data:[
				{name:"patcod",    value: lp_patcod},
				{name:"patcodext", value: lp_patcodext||""}
			]}]);
		}

		// El filtro fijo de origen (CrmCntSrcTyp='HLT_PAT') lo aplica ahora el _tmg (op crmslsdsh), no la vista.

		// pinta la grilla con las filas ya resueltas (incluido el patcodext de cada contacto HLT_PAT)
		function <?= $lv_sec; ?>_rndgrd( lp_row ) {
			<?= $lv_sec; ?>_rec = {};
			var lv_htm = "";
			for ( var i=0; i<lp_row.length; i++ ) {
				var r = lp_row[i];
				<?= $lv_sec; ?>_rec[ r.crmcntcod ] = r;
				lv_htm += '<tr data-id="'+ <?= $lv_sec; ?>_esc(r.crmcntcod) +'">'
					+  '<td class="crm-id">'+ <?= $lv_sec; ?>_esc(r.crmcntcod) +'</td>'
					+  '<td>'+ <?= $lv_sec; ?>_fdte(r.crmcntreqdte || r.crmcntdte || r.ctedte) +'</td>'
					+  '<td class="row-title">'+ <?= $lv_sec; ?>_esc(r.crmcnttxt||"") +'</td>'
					+  '<td>'+ <?= $lv_sec; ?>_prtlnk(r) +'</td>'	/* Cod. Protocolo: PatCodExt del paciente (link a la ficha) */
					+  '<td>'+ <?= $lv_sec; ?>_mtvtag(r) +'</td>'
					+  '<td>'+ <?= $lv_sec; ?>_sts(r) +'</td>'
					+  '</tr>';
			}
			$("#<?= $lv_sec; ?> #crmrow").html( lv_htm );
			$("#<?= $lv_sec; ?> #crmqty").text( lp_row.length );

			// selecciono el primer contacto para mostrar un detalle de entrada
			$("#<?= $lv_sec; ?> #crmrow tr:first").trigger("click");
		}

		// recarga el listado de contactos desde el _tmg (misma op crmslsdsh con dshrld=1): devuelve SOLO el JSON del
		// listado, ya SIN control de autorizacion (op 18 del SP) y con el patcodext de cada HLT_PAT ya resuelto.
		// lp_pstdat opcional: si viene, son los filtros; si no, recarga con maxrec 100.
		function <?= $lv_sec; ?>_lodgrd( lp_pstdat ) {
			var lv_pst = lp_pstdat || [{name:"vewmaxrec", value:"100"}];
			// marca de recarga PROPIA (no 'ajax', que el framework agrega a toda XHR): el _tmg responde con getJson
			lv_pst.push({name:"dshrld", value:"1"});

			tmssCallProcess("?prg=zcutp1_tmg&act=crmslsdsh", lv_pst, function( data ) {
				// normalizo la respuesta a un array de filas
				var lv_row = data;
				if ( lv_row && !$.isArray(lv_row) ) { lv_row = lv_row.data || lv_row.rows || lv_row.rs || []; }
				lv_row = lv_row || [];

				// el protocolo ya viene resuelto del server: pinto directo
				<?= $lv_sec; ?>_rndgrd( lv_row );
			});
		}

		// filtros -> pasa los filtros al controlador y recarga la grilla con el resultado
		function <?= $lv_sec; ?>_fltcto( lp_flt ) {
			gv_<?= $lv_sec; ?>_flt = lp_flt;
			var lv_fltint = tmssFilterParseToInternal( lp_flt );
			$("#<?= $lv_sec; ?> #fltcnt").text( lv_fltint["fltqty"]=="0" ? "" : lv_fltint["fltqty"] );
			<?= $lv_sec; ?>_lodgrd([ {name:"vewmaxrec", value:(lv_fltint["maxrec"]||"100")}, {name:"vewfldflt", value:lv_fltint["fltstr"]} ]);
		}

		// click sobre una fila -> render del detalle a la derecha
		$("#<?= $lv_sec; ?>").on("click", "#crmrow tr", function() {
			$("#<?= $lv_sec; ?> #crmrow tr").removeClass("selected");
			$(this).addClass("selected");
			<?= $lv_sec; ?>_rnddtl( $(this).data("id") );
		});

		// click en el Cod. de Protocolo (grilla o card de cabecera) -> abre la ficha del paciente
		// stopPropagation para no disparar la seleccion de la fila al mismo tiempo
		$("#<?= $lv_sec; ?>").on("click", ".protocol-link", function(e){ e.preventDefault(); e.stopPropagation();
			<?= $lv_sec; ?>_opndtl( $(this).data("patcod"), $(this).data("patcodext") );
		});

		// ------------------------------------------------------------------------
		// D E T A L L E   ( render cliente desde la fila + historial via sysdocchg )
		// ------------------------------------------------------------------------
		function <?= $lv_sec; ?>_rnddtl( lp_crmcntcod ) {
			var r = <?= $lv_sec; ?>_rec[ lp_crmcntcod ];
			if ( !r ) { return; }

			var lv_esc  = <?= $lv_sec; ?>_esc;
			var lv_prt = lv_esc(r.patcodext||"") || '&mdash;';	/* Cod. Protocolo: PatCodExt del paciente (origen HLT_PAT) */
			// el Cod. de Protocolo de la cabecera tambien linkea a la ficha del paciente (patcod = CrmCntSrcCod)
			var lv_prtcll = ( (r.crmcntsrccod||"") && (r.patcodext||"") )
				? '<span class="protocol-value protocol-link" data-patcod="'+ lv_esc(r.crmcntsrccod) +'" data-patcodext="'+ lv_esc(r.patcodext) +'">'+ lv_prt +'</span>'
				: '<span class="protocol-value">'+ lv_prt +'</span>';
			var lv_due  = <?= $lv_sec; ?>_fdte(r.crmcntduedte) || '&mdash;';
			var lv_rsp = lv_esc(r.usrtxt || r.usrcod || '') || '&mdash;';
			var lv_way  = lv_esc(r.crmcntwaycod || '') || '&mdash;';
			var lv_dsc = (r.crmcntrqs && String(r.crmcntrqs).trim()!="") ? lv_esc(r.crmcntrqs) : '<span style="color:#99a3b1;">Sin descripci&oacute;n registrada.</span>';
			var lv_act  = (r.crmcntmtvact && String(r.crmcntmtvact).trim()!="") ? lv_esc(r.crmcntmtvact) : "";	// actividad del motivo (CrmCntMtvAct)

			var lv_htm =
				'<article class="tmss-card detail-summary">'
				+   '<div class="summary-top">'
				+     '<div>'
				+       '<span class="summary-label">ID CRM</span>'
				+       '<div class="summary-id">'+ lv_esc(r.crmcntcod) +'</div>'
				+     '</div>'
				+     '<div class="summary-title">'
				+       '<span class="summary-label"><?= $vew_lang->title; ?></span>'
				+       '<h2>'+ (lv_esc(r.crmcnttxt||"") || '&nbsp;') +'</h2>'
				+     '</div>'
				+     '<div class="summary-protocol">'
				+       '<span class="summary-label">Cod. Paciente</span>'
				+       lv_prtcll
				+     '</div>'
				+   '</div>'
				+   '<div class="summary-data">'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-solid fa-tag"></i> <?= $vew_lang->motive; ?></div><div class="item-value">'+ <?= $lv_sec; ?>_mtvtag(r) +'</div></div>'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-regular fa-circle-dot"></i> <?= $vew_lang->status; ?></div><div class="item-value">'+ <?= $lv_sec; ?>_sts(r) +'</div></div>'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-solid fa-flag"></i> <?= $vew_lang->priority; ?></div><div class="item-value">'+ <?= $lv_sec; ?>_prt(r) +'</div></div>'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-regular fa-user"></i> <?= $vew_lang->responsible; ?></div><div class="item-value">'+ lv_rsp +'</div></div>'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-regular fa-calendar-days"></i> <?= $vew_lang->duedate; ?></div><div class="item-value">'+ lv_due +'</div></div>'
				+     '<div class="summary-item"><div class="item-label"><i class="fa-regular fa-comments"></i> <?= $vew_lang->contactroute; ?></div><div class="item-value">'+ lv_way +'</div></div>'
				+   '</div>'
				+ '</article>'
				+ '<div class="detail-content">'
				+   '<article class="tmss-card detail-card description-card">'
				+     '<div class="card-header"><div class="card-title"><i class="fa-regular fa-file-lines"></i> <?= $vew_lang->description; ?></div></div>'
				+     '<div class="card-body">'
				+       '<p class="description-text">'+ lv_dsc +'</p>'
				+       ( lv_act!="" ? '<div class="description-note"><i class="fa-regular fa-lightbulb"></i> <span>'+ lv_act +'</span></div>' : '' )
				+     '</div>'
				+   '</article>'
				+   '<article class="tmss-card detail-card history-card">'
				+     '<div class="card-header"><div class="card-title"><i class="fa-regular fa-clock"></i> <?= $vew_lang->comments; ?></div></div>'
				+     '<div class="card-body">'
				+       '<div id="dtlhst"><div id="divchgdoclst"><div class="tmss-detail-empty" style="padding:24px;"><i class="fas fa-spinner fa-spin"></i></div></div></div>'
<?php if ( $lv_canrpl ) { ?>
				+       '<div class="reply-composer" id="rplcmp">'
				+         '<textarea class="reply-input" id="rplinp" rows="1" placeholder="Escribir una respuesta..."></textarea>'
				+         '<div class="reply-tools">'
				+           '<button class="reply-icon-btn send" type="button" title="<?= $vew_lang->reply; ?>"><i class="fa-regular fa-paper-plane"></i></button>'
				+         '</div>'
				+       '</div>'
<?php } ?>
				+     '</div>'
				+   '</article>'
				+ '</div>';

			$("#<?= $lv_sec; ?> #divdtl").html( lv_htm );

<?php if ( $lv_canrpl ) { ?>
			// caja de comentarios -> publica la respuesta del ticket (logica de publicacion CRMCNT, operacion #12)
			$("#<?= $lv_sec; ?> #rplcmp .reply-icon-btn.send").on("click", function(e){ e.preventDefault();
				<?= $lv_sec; ?>_pstrpl( lp_crmcntcod );
			});
			// Enter envia; Shift+Enter hace salto de linea
			$("#<?= $lv_sec; ?> #rplinp").on("keydown", function(e){
				if ( e.which === 13 && !e.shiftKey ) { e.preventDefault(); <?= $lv_sec; ?>_pstrpl( lp_crmcntcod ); }
			});
<?php } ?>

			// historial: comentarios/cambios del contacto (componente existente)
			<?= $lv_sec; ?>_lodhst( lp_crmcntcod );
		}

		// historial -> reutiliza el componente de comentarios de sysdocchg
		// Contrato del componente (identico al de la vista estandar CRMCNT): lv_chgdocsrctyp / lv_chgdocsrccod
		// son GLOBALES (sin var) porque el html+js que devuelve el componente las lee para repintarse, y el
		// listado se monta en #divchgdoclst, que es el contenedor que el componente espera encontrar.
		function <?= $lv_sec; ?>_lodhst( lp_crmcntcod ) {
			lv_chgdocsrctyp = "<?= $lv_objtyp; ?>";
			lv_chgdocsrccod = lp_crmcntcod;
			tmssCallProcessNoBackdrop(
				"?prg=sysdocchg&act=13&prm_chgdocsrctyp=" + lv_chgdocsrctyp + "&prm_chgdocsrccod=" + lv_chgdocsrccod + "&prm_bcksec=<?= $lv_sec; ?>&prm_main=comentarios",
				[],
				function( data ) { $("#<?= $lv_sec; ?> #divchgdoclst").html( data ); }
			);
		}

		// fecha actual en formato dd/mm/aaaa (para la fecha del comentario)
		function <?= $lv_sec; ?>_tdy() {
			var d = new Date();
			var p = function(n){ return (n<10?"0":"")+n; };
			return p(d.getDate())+"/"+p(d.getMonth()+1)+"/"+d.getFullYear();
		}

		// responder -> publica la respuesta del ticket desde la caja de comentarios
		// replica la logica de publicacion de CRMCNT (vista + operacion #12): conserva estado/responsable/motivo
		// del ticket y crea el comentario con el texto ingresado.
		function <?= $lv_sec; ?>_pstrpl( lp_crmcntcod ) {
			var r = <?= $lv_sec; ?>_rec[ lp_crmcntcod ];
			if ( !r ) { return; }

			var lv_inp = $("#<?= $lv_sec; ?> #rplinp");
			var lv_txt   = (lv_inp.val()||"").trim();
			if ( lv_txt=="" ) { toastr.warning("Escriba una respuesta."); return; }
			lv_txt = lv_txt.replace(/(?:\r\n|\r|\n)/g, "<br>");

			// datos post: mismo set que usa la vista estandar al responder, sin cambio de estado/horas
			var lv_post = [{"name":"crmcntcmt","value":lv_txt},
										 {"name":"crmcntstscod","value":(r.crmcntstscod||"")},
										 {"name":"crmcntststxt","value":(r.crmcntststxt||"")},
										 {"name":"crmcntcmtdte","value":<?= $lv_sec; ?>_tdy()},
										 {"name":"usrcod","value":(r.usrcod||"")},
										 {"name":"crmcntcod","value": lp_crmcntcod},
										 {"name":"crmcntmtvcod","value":(r.crmcntmtvcod||"")},
										 {"name":"sysdocclscod","value":(r.sysdocclscod||"")}];

			var lv_btn = $("#<?= $lv_sec; ?> #rplcmp .reply-icon-btn.send");
			lv_btn.prop("disabled", true);

			// cambia el estado/responsable (sin cambios) y crea el comentario
			tmssCallProcessNoBackdrop("?prg=crmcnt&act=12", lv_post, function(){
				lv_inp.val("");
				lv_btn.prop("disabled", false);
				<?= $lv_sec; ?>_lodhst( lp_crmcntcod );	// refresca el historial manteniendo la seleccion
			});
		}

		// ------------------------------------------------------------------------
		// A L T O   ( la vista ocupa exactamente el alto disponible: sin scroll de pagina ni del form )
		// ------------------------------------------------------------------------
		// El scroll aparece sobre el form/contenedor cuando el area visible NO llega hasta el fondo de la
		// ventana (hay cromia tambien debajo). Por eso no alcanza con innerHeight: mido hasta el fondo REAL
		// del ancestro que recorta (el que tiene overflow auto/scroll/hidden) y limito el alto a ese borde.
		function <?= $lv_sec; ?>_fithgt() {
			var lo_wsp = document.querySelector("#<?= $lv_sec; ?> .tmss-crm-ws");
			if ( !lo_wsp ) { return; }
			// en una sola columna se permite el scroll natural (lo maneja el media query)
			if ( window.innerWidth <= 1380 ) { lo_wsp.style.height = ""; return; }

			var lv_top    = lo_wsp.getBoundingClientRect().top;
			var lv_btm = window.innerHeight;	// por defecto, el fondo de la ventana

			// recorro los ancestros y me quedo con el borde inferior visible mas alto (el que realmente acota)
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
		// R E F R E S H   ( carga de datos de la vista )
		// ------------------------------------------------------------------------
		// Concentra toda la carga de datos de la vista. Se ejecuta en la carga inicial y cada vez que se
		// actualiza (boton Actualizar del toolbar, enganchado via vew_tbl['rfrsh']['acc']).
		function <?= $lv_sec; ?>_refresh() {
			<?= $lv_sec; ?>_fithgt();		// reajusta el alto disponible
			<?= $lv_sec; ?>_lodgrd();		// recarga el listado desde el server (op crmslsdsh + dshrld) y selecciona el primer contacto
		}

		// ------------------------------------------------------------------------
		// B O T O N E S   ( toolbar )
		// ------------------------------------------------------------------------

		// filtros -> abre el dialogo estandar y refresca la grilla con los filtros aplicados
		$("#<?= $lv_sec; ?> #btnflt").on("click", function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltcto );
		});

		// carga inicial: el listado ya viene embebido desde el _tmg (op crmslsdsh) -> pinto sin llamar al server.
		// (El boton Actualizar del toolbar si usa <?= $lv_sec; ?>_refresh, que recarga desde el server.)
		$(document).ready(function(){
			<?= $lv_sec; ?>_fithgt();
			var lv_init = gv_<?= $lv_sec; ?>_initrows;
			if ( lv_init && !$.isArray(lv_init) ) { lv_init = lv_init.data || lv_init.rows || lv_init.rs || []; }
			<?= $lv_sec; ?>_rndgrd( lv_init || [] );
		});
	</script>

	<?php include( 'grldocfrmscr.frm' ); ?>
</section>