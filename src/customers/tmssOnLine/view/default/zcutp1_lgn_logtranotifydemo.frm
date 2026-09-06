<?php
	include_once('_library.frm');
	$lv_sec = $vew_token;
	$lv_deliveries = $vew_data['deliveries'] ?? array();
	$lv_external_url = $vew_data['notification_url'] ?? 'https://www.logindoor.com.ar/proximaentrega.php?route_token=demo-route-E22';
	function zcutp1_lgn_notify_h($lp_value){
		return htmlspecialchars((string)$lp_value, ENT_QUOTES, 'UTF-8');
	}
?>
<section id="<?= $lv_sec; ?>" class="lgn-notify-demo" data-title="Demo proximidad de entrega">
	<style>
		#<?= $lv_sec; ?> { --demo-green:#109447; --demo-dark:#123d29; --demo-ink:#24372d; --demo-muted:#64766d; --demo-line:#dce5df; color:var(--demo-ink); background:#f5f7f5; min-height:100%; }
		#<?= $lv_sec; ?> * { box-sizing:border-box; }
		#<?= $lv_sec; ?> button, #<?= $lv_sec; ?> a { cursor:pointer; }
		#<?= $lv_sec; ?> .demo-toolbar { display:flex; align-items:center; justify-content:space-between; min-height:64px; padding:0 20px; color:#fff; background:var(--demo-green); }
		#<?= $lv_sec; ?> .demo-toolbar h2 { margin:0; color:#fff; font-size:19px; font-weight:700; }
		#<?= $lv_sec; ?> .demo-toolbar small { display:block; margin-top:2px; color:rgba(255,255,255,.82); font-size:11px; }
		#<?= $lv_sec; ?> .demo-menu-wrap { position:relative; }
		#<?= $lv_sec; ?> .demo-menu-button { display:grid; place-items:center; width:42px; height:42px; border:0; border-radius:9px; color:#fff; background:#08763a; }
		#<?= $lv_sec; ?> .demo-menu-button:focus { outline:2px solid #fff; outline-offset:2px; }
		#<?= $lv_sec; ?> .demo-menu { display:none; position:absolute; z-index:25; top:48px; right:0; width:230px; padding:7px 0; border:1px solid var(--demo-line); border-radius:10px; background:#fff; box-shadow:0 14px 34px rgba(18,61,41,.2); }
		#<?= $lv_sec; ?> .demo-menu.is-open { display:block; }
		#<?= $lv_sec; ?> .demo-menu a { display:flex; align-items:center; gap:10px; padding:11px 15px; color:#293b32; text-decoration:none; }
		#<?= $lv_sec; ?> .demo-menu a:hover, #<?= $lv_sec; ?> .demo-menu a:focus { color:#0d7338; background:#edf7f1; outline:0; }
		#<?= $lv_sec; ?> .demo-menu i { width:18px; text-align:center; }
		#<?= $lv_sec; ?> .demo-content { padding:18px; }
		#<?= $lv_sec; ?> .demo-flow { display:flex; align-items:flex-start; gap:10px; margin:0 0 16px; padding:12px 14px; border:1px solid #cfe5d8; border-radius:10px; color:#315d47; background:#eaf5ee; font-size:13px; line-height:1.45; }
		#<?= $lv_sec; ?> .demo-flow strong { color:#0c6f35; }
		#<?= $lv_sec; ?> .demo-layout { display:grid; grid-template-columns:minmax(0,1.4fr) minmax(280px,.6fr); gap:18px; }
		#<?= $lv_sec; ?> .demo-card { overflow:hidden; border:1px solid var(--demo-line); border-radius:12px; background:#fff; box-shadow:0 5px 16px rgba(31,66,47,.05); }
		#<?= $lv_sec; ?> .demo-card-head { display:flex; align-items:center; justify-content:space-between; min-height:55px; padding:0 16px; border-bottom:1px solid #edf1ee; }
		#<?= $lv_sec; ?> .demo-card-head h3 { margin:0; color:#304238; font-size:16px; font-weight:700; }
		#<?= $lv_sec; ?> .demo-route-table { width:100%; border-collapse:collapse; }
		#<?= $lv_sec; ?> .demo-route-table th { padding:11px 14px; color:#6b7a72; background:#fafbfa; font-size:11px; font-weight:700; text-align:left; text-transform:uppercase; }
		#<?= $lv_sec; ?> .demo-route-table td { padding:14px; border-top:1px solid #edf1ee; vertical-align:middle; }
		#<?= $lv_sec; ?> .demo-route-table strong, #<?= $lv_sec; ?> .demo-route-table small { display:block; }
		#<?= $lv_sec; ?> .demo-route-table strong { color:#0c853f; }
		#<?= $lv_sec; ?> .demo-route-table small { margin-top:3px; color:#6c7a72; }
		#<?= $lv_sec; ?> .demo-geo { display:inline-flex; align-items:center; gap:5px; padding:5px 8px; border-radius:999px; font-size:11px; font-weight:700; }
		#<?= $lv_sec; ?> .demo-geo.yes { color:#116e3b; background:#e6f6ed; }
		#<?= $lv_sec; ?> .demo-geo.no { color:#855f18; background:#fff5dc; }
		#<?= $lv_sec; ?> .demo-summary { padding:16px; }
		#<?= $lv_sec; ?> .demo-summary-row { display:grid; grid-template-columns:105px 1fr; gap:10px; padding:10px 0; border-bottom:1px solid #edf1ee; }
		#<?= $lv_sec; ?> .demo-summary-row:last-child { border-bottom:0; }
		#<?= $lv_sec; ?> .demo-summary-row span { color:#738078; }
		#<?= $lv_sec; ?> .demo-summary-row strong { color:#34483d; }
		#<?= $lv_sec; ?> .demo-stage { display:none; position:fixed; z-index:1050; inset:0; padding:28px 16px; overflow:auto; background:rgba(17,38,27,.58); }
		#<?= $lv_sec; ?> .demo-stage.is-open { display:block; }
		#<?= $lv_sec; ?> .demo-dialog { width:min(100%,560px); margin:0 auto; overflow:hidden; border-radius:15px; background:#fff; box-shadow:0 25px 70px rgba(0,0,0,.28); }
		#<?= $lv_sec; ?> .demo-dialog-head { display:flex; align-items:center; justify-content:space-between; padding:16px 18px; color:#fff; background:var(--demo-green); }
		#<?= $lv_sec; ?> .demo-dialog-head h3 { margin:0; color:#fff; font-size:18px; }
		#<?= $lv_sec; ?> .demo-close { width:34px; height:34px; border:0; border-radius:7px; color:#fff; background:rgba(0,0,0,.14); }
		#<?= $lv_sec; ?> .demo-message-list { padding:12px; }
		#<?= $lv_sec; ?> .demo-message-item { display:flex; align-items:center; gap:13px; width:100%; padding:15px; border:1px solid var(--demo-line); border-radius:10px; color:#263b30; background:#fff; text-align:left; text-decoration:none; transition:border-color .2s,background .2s; }
		#<?= $lv_sec; ?> .demo-message-item:hover, #<?= $lv_sec; ?> .demo-message-item:focus { border-color:#7dc89f; background:#f2faf5; outline:2px solid rgba(16,148,71,.2); outline-offset:2px; }
		#<?= $lv_sec; ?> .demo-message-icon { display:grid; place-items:center; flex:0 0 42px; height:42px; border-radius:10px; color:#fff; background:var(--demo-green); }
		#<?= $lv_sec; ?> .demo-message-copy { flex:1; }
		#<?= $lv_sec; ?> .demo-message-copy strong, #<?= $lv_sec; ?> .demo-message-copy small { display:block; }
		#<?= $lv_sec; ?> .demo-message-copy small { margin-top:3px; color:#718078; line-height:1.4; }
		#<?= $lv_sec; ?> .external-note { margin:0 12px 12px; padding:12px; border-radius:9px; color:#53665b; background:#f4f7f5; font-size:12px; line-height:1.45; }
		@media(max-width:900px){ #<?= $lv_sec; ?> .demo-layout { grid-template-columns:1fr; } }
		@media(max-width:620px){ #<?= $lv_sec; ?> .demo-content { padding:10px; } #<?= $lv_sec; ?> .demo-route-table th:nth-child(3), #<?= $lv_sec; ?> .demo-route-table td:nth-child(3) { display:none; } #<?= $lv_sec; ?> .demo-stage { padding:8px; } }
		@media(prefers-reduced-motion:reduce){ #<?= $lv_sec; ?> * { transition:none !important; } }
	</style>

	<header class="demo-toolbar">
		<div><h2>Seguimiento de transporte · Demo</h2><small>Hoja de ruta #<?= zcutp1_lgn_notify_h($vew_data['tracod']); ?> · datos simulados</small></div>
		<div class="demo-menu-wrap">
			<button type="button" class="demo-menu-button" id="<?= $lv_sec; ?>_menu_button" aria-label="Abrir acciones" aria-expanded="false"><i class="fas fa-ellipsis-v"></i></button>
			<div class="demo-menu" id="<?= $lv_sec; ?>_menu"><a href="#" id="<?= $lv_sec; ?>_refresh"><i class="fas fa-sync-alt"></i> Actualizar</a><a href="#" id="<?= $lv_sec; ?>_share"><i class="far fa-share-nodes"></i> Compartir</a><a href="#"><i class="far fa-info"></i> Info</a></div>
		</div>
	</header>

	<div class="demo-content">
		<div class="demo-flow"><i class="fas fa-arrow-up-right-from-square"></i><span><strong>Flujo corregido:</strong> Temasis solamente genera una sesión temporal de la hoja de ruta. La selección del destino, destinatario, canal, ubicación y envío se realiza en LogInDoor, fuera del sistema.</span></div>
		<div class="demo-layout">
			<div class="demo-card">
				<div class="demo-card-head"><h3>Entregas / retiros</h3><span class="label label-success"><?= count($lv_deliveries); ?> destinos</span></div>
				<table class="demo-route-table"><thead><tr><th>ID</th><th>Destino</th><th>Dirección</th><th>Geolocalización</th></tr></thead><tbody>
				<?php foreach($lv_deliveries as $lv_delivery){ ?>
					<tr><td><?= zcutp1_lgn_notify_h($lv_delivery['id']); ?><strong><?= zcutp1_lgn_notify_h($lv_delivery['code']); ?></strong></td><td><strong><?= zcutp1_lgn_notify_h($lv_delivery['destination']); ?></strong><small>Entrega pendiente</small></td><td><?= zcutp1_lgn_notify_h($lv_delivery['address']); ?></td><td><span class="demo-geo <?= $lv_delivery['has_geo']?'yes':'no'; ?>"><i class="fas <?= $lv_delivery['has_geo']?'fa-map-marker-alt':'fa-triangle-exclamation'; ?>"></i> <?= $lv_delivery['has_geo']?'Disponible':'No disponible'; ?></span></td></tr>
				<?php } ?>
				</tbody></table>
			</div>
			<div class="demo-card">
				<div class="demo-card-head"><h3>Transporte</h3><strong># <?= zcutp1_lgn_notify_h($vew_data['tracod']); ?></strong></div>
				<div class="demo-summary"><div class="demo-summary-row"><span>Código</span><strong><?= zcutp1_lgn_notify_h($vew_data['tracodext']); ?></strong></div><div class="demo-summary-row"><span>Vehículo</span><strong><?= zcutp1_lgn_notify_h($vew_data['vehicle']); ?></strong></div><div class="demo-summary-row"><span>Transportista</span><strong><?= zcutp1_lgn_notify_h($vew_data['driver']); ?></strong></div><div class="demo-summary-row"><span>Estado</span><strong><?= zcutp1_lgn_notify_h($vew_data['status']); ?></strong></div></div>
			</div>
		</div>
	</div>

	<div class="demo-stage" id="<?= $lv_sec; ?>_message_stage" role="dialog" aria-modal="true" aria-labelledby="<?= $lv_sec; ?>_messages_title">
		<div class="demo-dialog">
			<div class="demo-dialog-head"><h3 id="<?= $lv_sec; ?>_messages_title">Compartir</h3><button type="button" class="demo-close" data-close-stage aria-label="Cerrar"><i class="fas fa-times"></i></button></div>
			<div class="demo-message-list"><a class="demo-message-item" href="<?= zcutp1_lgn_notify_h($lv_external_url); ?>" target="_blank" rel="noopener"><span class="demo-message-icon"><i class="fas fa-route"></i></span><span class="demo-message-copy"><strong>Notificar proximidad de entrega</strong><small>Abrir LogInDoor con los datos temporales de esta hoja de ruta</small></span><i class="fas fa-arrow-up-right-from-square"></i></a></div>
			<p class="external-note"><i class="fas fa-shield-alt"></i> En producción se enviará únicamente un token de sesión. Los teléfonos, emails y coordenadas se recuperarán desde la API de forma segura.</p>
		</div>
	</div>

	<script>
	(function(){
		var root=$("#<?= $lv_sec; ?>");
		function closeStage(){root.find("#<?= $lv_sec; ?>_message_stage").removeClass("is-open");}
		root.find("#<?= $lv_sec; ?>_menu_button").on("click",function(){var menu=root.find("#<?= $lv_sec; ?>_menu");menu.toggleClass("is-open");$(this).attr("aria-expanded",menu.hasClass("is-open")?"true":"false");});
		root.find("#<?= $lv_sec; ?>_refresh").on("click",function(e){e.preventDefault();toastr.info("Datos de demostración actualizados.");});
		root.find("#<?= $lv_sec; ?>_share").on("click",function(e){e.preventDefault();root.find("#<?= $lv_sec; ?>_menu").removeClass("is-open");root.find("#<?= $lv_sec; ?>_message_stage").addClass("is-open");});
		root.find("[data-close-stage]").on("click",closeStage);
		root.find("#<?= $lv_sec; ?>_message_stage").on("click",function(e){if(e.target===this)closeStage();});
		$(document).on("keydown.<?= $lv_sec; ?>",function(e){if(e.key==="Escape")closeStage();});
	})();
	</script>
</section>
