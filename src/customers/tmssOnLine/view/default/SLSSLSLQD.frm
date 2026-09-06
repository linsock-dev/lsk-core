<?php
  // url del formulario
  $lv_lnk = '?prg=slsslslqd&prm_slsslslqdcod='.$vew_data->slsslslqdcod;

  // campos requeridos
  $vew_input->RequiredFields( array(
    'slsslslqddte','slsslslqdtxt','custxt','cuscod','slsslslqdstrdte','slsslslqdenddte','docsts'
  ));

  // clave del documento
  $lv_dockey = $vew_data->slsslslqdcod;

  // titulo
  $lv_title = $vew_lang->liquidation;

  // módulo y programa
  $lv_mdlcod = 'SLS';
  $lv_prgcod = 'SLQ';

  // librería de estilos bootstrap
  include_once('_library.frm');

  // valores x default
  if ( $vew_data->slsslslqdcod=='' && $vew_readonly==false ) {
    $vew_data->slsslslqddte = date('d/m/Y');
    $vew_data->docsts = 'A';
    $lv_curdte = new DateTime( date('Y-m-d') );
    if ( $lv_curdte->format('d')>10 ) {
      $lv_strdte = new DateTime(date('Y-m-d'));
      $lv_enddte = new DateTime(date('Y-m-d'));
      $lv_strdte->modify('first day of this month');
      $lv_enddte->modify('last day of this month');
    } else {
      $lv_strdte = new DateTime(date('Y-m-d'));
      $lv_enddte = new DateTime(date('Y-m-d'));
      $lv_strdte->modify('first day of last month');
      $lv_enddte->modify('last day of last month');
    }
    $vew_data->slsslslqdstrdte = $lv_strdte->format('d/m/Y');
    $vew_data->slsslslqdenddte = $lv_enddte->format('d/m/Y');
  } else {
    $vew_data->slsslslqdstrdte = $vew_doc->getTagValue($vew_data->slsslslqdatr001,'strdte');
    $vew_data->slsslslqdenddte = $vew_doc->getTagValue($vew_data->slsslslqdatr001,'enddte');
  }

  $lv_cusdaturl = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'slsslslqdcusurl');

  $vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
  $vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
  $vew_tbl['delsep'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04'));
  $vew_tbl['del']    = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04'));
  $vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=> $lv_sec.'_accounting()');
  $vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=> $lv_sec.'_accounting()');

  $lv_hasdoc = ($vew_data->slsslslqdcod!='' ? true : false);
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('slsslslqddoc','hidden',''); ?><!-- detalle serializado (viaja al act=00) -->
    <?= gethtml('slsslslqddoc','hidden',''); ?>
    <textarea id="opnlqdids" name="opnlqdids" class="hidden"></textarea>
    <input type="hidden" id="refdoccls" name="refdoccls" value="<?= $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'refdoccls'); ?>">
 

    <div class="container-fluid" role="tabpanel">

      <!-- tabs -->
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active">
          <a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a>
        </li>
        <li class="pull-right">
          <h4># <strong>
            <?= $vew_data->slsslslqdcod; ?>
            <?= gethtml('slsslslqdcod','hidden',$vew_data->slsslslqdcod); ?>
          </strong></h4>
        </li>
      </ul>

      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">

            <!-- card: cliente y estado -->
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    // typeahead de cliente: bloqueado si el documento ya existe
                    echo vew_boot($lv_col210, array(
                      'label'  => $vew_lang->customer,
                      'input1' => vew_boot(
                        array('style'=>'search','readonly'=>($vew_data->slsslslqdcod==''?$vew_readonly:true)),
                        array('input'=>gethtml('custxt','typeahead',$vew_data->custxt, ($vew_data->slsslslqdcod==''?$lv_default:$lv_always_disabled)))
                      )
                    ));
                    echo gethtml('cuscod','hidden',$vew_data->cuscod);
                    echo vew_boot($lv_col210, array(
                      'label' => $vew_lang->description,
                      'input' => gethtml('slsslslqdtxt','doccmt1x50',$vew_data->slsslslqdtxt,$lv_default)
                    ));
                    echo vew_boot($lv_col210, array(
                      'label'  => $vew_lang->status,
                      'input1' => gethtml('docsts','docstsacc',$vew_data->docsts,$lv_default),
                    ));
                  ?>
                </div>
              </div>
            </div>

            <!-- card: fecha, período y total general -->
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->data; ?>
                    <span class="tmss-card-icon font-weight-bold" id="slsslslqdtot"></span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col244, array(
                      'label' => $vew_lang->date,
                      'input' => gethtml('slsslslqddte','docdte',$vew_data->slsslslqddte, ($vew_data->slsslslqdcod==''?$lv_default:$lv_always_disabled))
                    ));
                    echo vew_boot($lv_col255, array(
                      'label'  => $vew_lang->period,
                      'input'  => gethtml('slsslslqdstrdte','docdte',$vew_data->slsslslqdstrdte, ($vew_data->slsslslqdcod=='' ? $lv_default : $lv_always_disabled)),
                      'input2' => gethtml('slsslslqdenddte','docdte',$vew_data->slsslslqdenddte, ($vew_data->slsslslqdcod=='' ? $lv_default : $lv_always_disabled)),
                    ));
                  ?>
                </div>
              </div>
            </div>

          </div><!-- /row -->

          <!-- card: tabla de insumos -->
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <?= ($vew_lang->SUPPLIES ?? 'Insumos'); ?>
                <!-- botón de sincronización: dispara la carga del detalle -->
                <a class="card-icon text-center tmssHiddeOnRead" id="btnnxttab" title="<?= $vew_lang->data; ?>">
                  <i class="fas fa-sync-alt"></i>
                </a>
              </div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-condensed table-hover" id="opnlqdtbl">
                <thead>
                  <tr>
                    <?= (!$vew_readonly ? '<th width="30"><input type="checkbox" id="opnlqdchkhdr"></th>' : ''); ?>
                    <th width="200">Contacto</th>
                    <th width="110">ID Movimiento</th>
                    <th width="100">Fecha</th>
                    <th width="240">Tipo</th>
                    <th width="110">N&deg; de Remito</th>
                    <th width="100">ID Material</th>
                    <th>Material</th>
                    <th width="90">Cantidad</th>
                    <?= (!$vew_readonly ? '<th width="100">Cant. Nueva</th>' : ''); ?>
                    <th width="90">Precio</th>
                    <th width="100">Total</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </div>
          </div><!-- /card insumos -->

        </div><!-- /tab general -->
      </div><!-- /tab-content -->
    </div><!-- /container-fluid -->
  </form>

  <script>
  
    //  INICIALIZACIÓN
    $(function(){
      // si el documento ya existe, carga el detalle automáticamente al abrir
      if(<?= $lv_hasdoc ? 'true' : 'false'; ?>){
        <?= $lv_sec; ?>_refreshData();
      }
      // checkbox global (header): propaga selección a todos los ítems 
      $("#<?= $lv_sec; ?>").on("change", "#opnlqdchkhdr", function(){
        var $tbody = $(this).closest("table").find("tbody");
        $tbody.find("input[name='subgrpchk']")
         .prop("checked", $(this).is(":checked"))
         .trigger("change");
      });
    });

    // typeahead de cliente
    var lo_get = { "fldsec": "<?= $lv_sec; ?>", "fldasg": { "custxt": "custxt", "cuscod": "cuscod" } };
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);

    // botón sync: valida campos y recarga el detalle
    $("#<?= $lv_sec; ?> #btnnxttab").on("click", function(e){e.preventDefault();
      if ( tmssCheckRequiredFields($("#<?= $lv_sec; ?>_frm")) == false ) {
  			return false;
			}
      <?= $lv_sec; ?>_refreshData();
    });


    // =========================================================================
    //  CARGA DEL DETALLE
    // =========================================================================
    function <?= $lv_sec; ?>_refreshData() {
      if ( tmssCheckRequiredFields($("#<?= $lv_sec; ?>_frm")) == false ) {
  			return false;
			}

      // muestra spinner mientras carga
      $("#<?= $lv_sec; ?> #opnlqdtbl tbody").empty()
        .append("<tr><td colspan='11'><i class='far fa-cogs fa-spin'></i> Cargando datos...</td></tr>");

      var lv_pstdat = [
        { name:"slsslslqdcod", 		value: $("#<?= $lv_sec; ?> #slsslslqdcod").val()	  },
        { name:"cuscod",          value: $("#<?= $lv_sec; ?> #cuscod").val()    			},
        { name:"slsslslqdstrdte", value: $("#<?= $lv_sec; ?> #slsslslqdstrdte").val() },
        { name:"slsslslqdenddte", value: $("#<?= $lv_sec; ?> #slsslslqdenddte").val() },
        { name:"sysdocclscod",    value: $("#<?= $lv_sec; ?> #sysdocclscod").val()    },
        { name:"docsts",          value: $("#<?= $lv_sec; ?> #docsts").val()          },
        { name:"readonly", 				value: <?= $vew_readonly ? 'true' : 'false'; ?> 		},
        { name:"refdoccls",       value: $("#<?= $lv_sec; ?> #refdoccls").val()				}
      ];

      tmssCallProcessNoBackdrop("?prg=slsslslqd&act=38", lv_pstdat, function(data){

       	var $tbody = $("#<?= $lv_sec; ?> #opnlqdtbl tbody");
        var lv_rows = data.data;

        $tbody.empty();

        if (!lv_rows || lv_rows.length == 0) {
          $tbody.append("<tr><td colspan='11'>No se encontraron datos.</td></tr>");
          return;
        }

        // construye el HTML de todas las filas en un buffer y lo inserta de una vez
        var lv_buffer = "";
        var lv_cntcod = null;

        for (var i = 0; i < lv_rows.length; i++) {
          var row = lv_rows[i];

          // en readonly solo muestra ítems que ya están grabados
          if (<?= $vew_readonly ? 'true' : 'false'; ?> && (!row.slsslslqddoccod || row.slsslslqddoccod == 0)) { continue; }

          // ---- fila de encabezado de grupo (una por contacto) ----
          if (lv_cntcod != row.stkcntcod) {
            lv_buffer += "<tr class='bg-info' name='subgrp' data-stkcntcod='"+row.stkcntcod+"'>";
            if (!<?= $vew_readonly ? 'true' : 'false'; ?>) {
              lv_buffer += "<td><input type='checkbox' name='subgrpchk' data-stkcntcod='"+row.stkcntcod+"'></td>";
            }
            lv_buffer += "<td colspan='7'><strong>"
                       +   "<a href='#' name='subgrp' data-stkcntcod='"+row.stkcntcod+"'>"
                       +     "<span class='fas fa-chevron-right' style='margin-right:4px;'></span>"
                       +   "</a> "+row.stkcnttxt
                       + "</strong></td>"
                       + "<td name='mattotqty'></td>"
                       + (!<?= $vew_readonly ? 'true' : 'false'; ?> ? "<td></td>" : "")
                       + "<td></td>"
                       + "<td name='mattotamt'>0.00</td>"
                       + "</tr>";
            lv_cntcod = row.stkcntcod;
          }

          // ---- cálculo de cantidad y total para esta fila ----
          // usa cantidad guardada si existe, si no la original del movimiento
          var lv_qtysaved = (row.slsslslqddocqtysaved && row.slsslslqddocqtysaved > 0) ? row.slsslslqddocqtysaved : row.matqty;
          // signo negativo para devoluciones
          var lv_sign = (row.matprctot < 0 ? -1 : 1);
          // total: recalcula con cantidad guardada si el ítem ya está en la liquidación
          var lv_total = (row.slsslslqddoccod > 0) ? lv_sign * row.untmatprc * lv_qtysaved : row.matprctot;

          // ---- fila de ítem ----
          lv_buffer += "<tr class='bg-secondary hidden' name='itmgrp'"
                     +   " data-stkcntcod='"+row.stkcntcod+"'"
                     +   " data-total='"+lv_total+"'>";

          // celda de checkbox (solo en edición)
          if (!<?= $vew_readonly ? 'true' : 'false'; ?>) {
            lv_buffer += "<td>"
                       +   "<input type='checkbox' name='itmchk'"
                       +     (row.slsslslqddoccod > 0 ? " checked" : "")
                       +     " data-slsslslqddoccod='"+row.slsslslqddoccod+"'"
                       +     " data-stkcntcod='"+row.stkcntcod+"'"
                       +     " data-refobjtyp='"+row.refobjtyp+"'"
                       +     " data-matqty='"+row.matqty+"'"
                       +     " data-matqtynew='"+(row.slsslslqddocqtysaved && row.slsslslqddocqtysaved > 0 ? row.slsslslqddocqtysaved : row.matqty)+"'"
                       +     " data-untmatprc='"+row.untmatprc+"'"
                       +     " data-matprctot='"+row.matprctot+"'"
                       +     " data-stkmovdoccod='"+row.movcod+"'"
                       +     " data-stkmovdocmatcod='"+row.stkmovdocmatcod+"'"
                       +     " data-matuntcod='"+row.matuntcod+"'"
                       +     " data-curcod='"+row.curcod+"'"
                       +   ">"
                       + "</td>";
          }

          // celdas de datos del movimiento
          lv_buffer += "<td></td>"
                     + "<td><a href='#' name='movlnk' data-refobjtyp='"+row.refobjtyp+"' data-refobjcod001='"+row.movcod+"'>"+row.movcod+"</a></td>"
                     + "<td>"+row.refdte+"</td>"
                     + "<td>"+row.refobjtyptxt+"</td>"
                     + "<td>"+row.movcodext+"</td>"
                     + "<td>"+row.matcod+"</td>"
                     + "<td>"+row.mattxt+"</td>";

          // celda de cantidad: muestra la guardada con icono de lápiz si fue modificada
          lv_buffer += "<td name='matqty'>"+<?= $lv_sec; ?>_fmt(lv_qtysaved);
          if (row.slsslslqddocqtysaved && row.slsslslqddocqtysaved != row.matqty) {
            lv_buffer += " <i class='fas fa-pencil-alt text-warning'"
                       +    " title='Cant. original: "+Number(row.matqty).toFixed(2)+"'></i>";
          }
          lv_buffer += "</td>";

          // celda de cantidad nueva (solo en edición)
          if (!<?= $vew_readonly ? 'true' : 'false'; ?>){
            var lv_qtynew = (row.slsslslqddocqtysaved && row.slsslslqddocqtysaved > 0) ? row.slsslslqddocqtysaved : row.matqty;
            lv_buffer += "<td>"
                       +   "<input type='number' name='matqtynew'"
                       +     " class='form-control form-control-sm text-right'"
                       +     " step='any' min='0.01' max='"+row.matqty+"'"
                       +     " value='"+parseFloat(lv_qtynew).toFixed(2)+"'"
                       +     " data-matqty-orig='"+row.matqty+"'"
                       +     " style='width:100px;'>"
                       + "</td>";
          }

          // celdas de precio y total
          lv_buffer += "<td name='untmatprc'>"+<?= $lv_sec; ?>_fmt(row.untmatprc)+"</td>"
                     + "<td name='matprctot'>"+<?= $lv_sec; ?>_fmt(lv_total)+"</td>"
                     + "</tr>";

        } // fin loop

        $tbody.append(lv_buffer);
				// link de movimiento: abre el documento de origen
        $tbody.find("a[name='movlnk']").on("click", function(e){e.preventDefault();
          var lv_refobjtyp = $(this).data("refobjtyp");
          if (!lv_refobjtyp) return;
          var lv_mdlcod = lv_refobjtyp.split("_")[0];
          var lv_prgcod = lv_refobjtyp.split("_")[1];
          tmssLink(
            "?prg=stkmovdoc&act=03&prm_mdlcod="+lv_mdlcod+"&prm_prgcod="+lv_prgcod+"&prm_stkmovdoccod="+$(this).data("refobjcod001")+"&prm_objtyp="+lv_refobjtyp,
            [{ target: "_new_section", post_data: [
              { name: "stkmovdoccod", value: $(this).data("refobjcod001") },
              { name: "objtyp",       value: lv_refobjtyp }
            ]}]
          );
        });
        // ---- colapsar/expandir grupo al clickear el encabezado ----
        $tbody.find("a[name='subgrp']").on("click", function(e){e.preventDefault();
          var lv_cnt = $(this).data("stkcntcod");
          var lv_expanded = $(this).find("span:first").hasClass("fa-chevron-down");
          if (lv_expanded) {
            $tbody.find("tr[name='itmgrp'][data-stkcntcod='"+lv_cnt+"']").addClass("hidden");
            $(this).find("span:first").removeClass("fa-chevron-down").addClass("fa-chevron-right");
          } else {
            $tbody.find("tr[name='itmgrp'][data-stkcntcod='"+lv_cnt+"']").removeClass("hidden");
            $(this).find("span:first").removeClass("fa-chevron-right").addClass("fa-chevron-down");
          }
        });

        // checkbox de ítem: sincroniza subgrupo y global, recalcula totales
        $tbody.find("input[name='itmchk']").on("change", function(){
          var lv_k = $(this).data("stkcntcod");
          var lv_tot_grp = $tbody.find("input[name='itmchk'][data-stkcntcod='"+lv_k+"']").length;
          var lv_chk_grp = $tbody.find("input[name='itmchk'][data-stkcntcod='"+lv_k+"']:checked").length;
          $tbody.find("input[name='subgrpchk'][data-stkcntcod='"+lv_k+"']")
                .prop("checked", lv_tot_grp > 0 && lv_tot_grp === lv_chk_grp);
          var lv_tot_all = $tbody.find("input[name='subgrpchk']").length;
          var lv_chk_all = $tbody.find("input[name='subgrpchk']:checked").length;
          $("#<?= $lv_sec; ?> #opnlqdchkhdr").prop("checked", lv_tot_all > 0 && lv_tot_all === lv_chk_all);
          <?= $lv_sec; ?>_totalItem($(this).closest("tr") );
        });

        // checkbox de subgrupo: propaga a sus ítems
       	$tbody.find("input[name='subgrpchk']").on("change", function(){
          var lv_k = $(this).data("stkcntcod");
          $tbody.find("input[name='itmchk'][data-stkcntcod='"+lv_k+"']")
                .prop("checked", $(this).is(":checked"))
                .trigger("change");
        });

        // input de cantidad nueva: valida límites, sincroniza data y recalcula
        $tbody.find("input[name='matqtynew']").on("input", function(){
          var lv_orig = parseFloat($(this).data("matqty-orig") || 0);
          var lv_qty  = parseFloat($(this).val()) || 0;
          if (lv_qty > lv_orig) { $(this).val(lv_orig); lv_qty = lv_orig; }
          if (lv_qty < 0)       { $(this).val(0);       lv_qty = 0; }
          $(this).closest("tr").find("input[name='itmchk']").data("matqtynew", lv_qty);
          <?= $lv_sec; ?>_totalItem($(this).closest("tr") );
        });
        
        // si hay checkboxes (edición): dispara change para sincronizar estado y totales
        if (!<?= $vew_readonly ? 'true' : 'false'; ?>){
            $tbody.find("tr[name='itmgrp'] input[name='itmchk']").each(function(){
                $(this).trigger("change");
            });
        // si no hay checkboxes (readonly): itera las filas directamente para calcular totales
        } else {
            $tbody.find("tr[name='itmgrp']").each(function(){
                <?= $lv_sec; ?>_totalItem($(this) );
            });
        }
      }); // fin callback act=38

    } // fin _refreshData


    // =========================================================================
    //  FUNCIONES DE TOTALES Y FORMATO
    // =========================================================================

    // formatea número con separador de miles y 2 decimales
    function <?= $lv_sec; ?>_fmt( n ){
      return Number(n).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    // total general: suma los totales de todos los grupos
    function <?= $lv_sec; ?>_totalGeneral(){
      var lv_tot = 0;
      $("#<?= $lv_sec; ?> #opnlqdtbl tbody tr[name='subgrp']").each(function(){
        lv_tot += parseFloat($(this).data("total") || 0);
      });
      $("#<?= $lv_sec; ?> #slsslslqdtot").html( "<strong>"+<?= $lv_sec; ?>_fmt(lv_tot)+"</strong>" );
    }

    // total de grupo: suma los totales de sus ítems y llama al general
    function <?= $lv_sec; ?>_totalGrupo(idGrupo ){
      var lv_tot  = 0;
      var $items  = $("#<?= $lv_sec; ?> #opnlqdtbl tbody tr[name='itmgrp'][data-stkcntcod='"+idGrupo+"']");
      var $subgrp = $("#<?= $lv_sec; ?> #opnlqdtbl tbody tr[name='subgrp'][data-stkcntcod='"+idGrupo+"']");
      $items.each(function(){ lv_tot += parseFloat($(this).data("total") || 0); });
      $subgrp.data("total", lv_tot).find("td[name='mattotamt']").html( <?= $lv_sec; ?>_fmt(lv_tot) );
      <?= $lv_sec; ?>_totalGeneral();
    }

    // total de ítem: respeta el estado del checkbox y la cantidad nueva
    function <?= $lv_sec; ?>_totalItem($row ){
      var lv_chk = $row.find("input[name='itmchk']");
      var lv_tot;
      if (lv_chk.length === 0) {
        // readonly: toma el total ya calculado en el data-total del tr
        lv_tot = parseFloat($row.data("total") || 0);
      } else {
        var lv_prc  = parseFloat(lv_chk.data("untmatprc") || 0);
        var lv_qtynew = lv_chk.data("matqtynew");
				var lv_qty = (lv_qtynew !== undefined && lv_qtynew !== null && lv_qtynew !== "") ? parseFloat(lv_qtynew): parseFloat(lv_chk.data("matqty") || 0);
        var lv_sign = (lv_chk.data("refobjtyp") === 'STK_SIN' ? -1 : 1);
        lv_tot = lv_chk.is(":checked") ? lv_sign * lv_prc * lv_qty : 0;
        $row.data("total", lv_tot).find("td[name='matprctot']").html( <?= $lv_sec; ?>_fmt(lv_tot) );
      }
      <?= $lv_sec; ?>_totalGrupo( lv_chk.length ? lv_chk.data("stkcntcod") : $row.data("stkcntcod") );
    }

  </script>

  <script>
    // =========================================================================
    //  CONTABILIZAR
    // =========================================================================
    function <?= $lv_sec; ?>_accounting() {
      BootstrapDialog.confirm({
        title:    "<?= $vew_lang->accounting; ?>",
        message:  "&iquest;Desea contabilizar el documento?",
        type:     BootstrapDialog.TYPE_WARNING,
        callback: function(result){ if(result){ <?= $lv_sec; ?>_fnc({action: "09"}); } }
      });
    }
  </script>

  <script>
    // =========================================================================
    //  GRABADO (pre-submit)
    // =========================================================================
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      if (lp_prm["action"] == "00") {

        // validaciones
        if ( !tmssCheckRequiredFields($("#<?= $lv_sec; ?>_frm")) ) {
          return false;
        }
        if ( $("#<?= $lv_sec; ?> #opnlqdtbl tbody input[name='itmchk']:checked").length === 0 ) {
          toastr.warning("Debe seleccionar al menos un insumo para liquidar.");
          return false;
        }
        // serializa los ítems marcados como JSON
        var lv_det = [];
        $("#<?= $lv_sec; ?> #opnlqdtbl tbody input[name='itmchk']:checked").each(function(){
          lv_det.push({
            slsslslqddoccod:    $(this).data("slsslslqddoccod")  || 0,
            stkmovdoccod:       $(this).data("stkmovdoccod")     || "",
            stkmovdocmatcod:    $(this).data("stkmovdocmatcod")  || "",
            slsslslqddocqty:    $(this).data("matqty")           || 0,
            slsslslqddocqtynew: $(this).data("matqtynew")        || $(this).data("matqty") || 0,
            matuntcod:          $(this).data("matuntcod")        || "",
            slsslslqddocprc:    $(this).data("untmatprc")        || 0,
            // lee el total desde la celda visible (ya incluye el recálculo por cantidad nueva)
            slsslslqddoctot:    parseFloat($(this).closest("tr").find("td[name='matprctot']").text().replace(/,/g,'')) || 0,
            curcod:             $(this).data("curcod")           || ""
          });
        });

        $("#<?= $lv_sec; ?> #slsslslqddoc").val( lv_det.length > 0 ? JSON.stringify(lv_det) : "" );
      }
    }
    // server response
    function <?= $lv_sec; ?>_fncbckext( data ) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
        if (gv_<?= $lv_sec; ?>_last_action == "04") {
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        } else if (gv_<?= $lv_sec; ?>_last_action == "09") {
          toastr.info("Documento contabilizado.");
          <?= $lv_sec; ?>_fnc({action: "99"});
          return;
        } else {
          $("#<?= $lv_sec; ?>").replaceWith( data );
        }
      }
    }
  </script>

  <?php include('grldocfrmscr.frm'); ?>
</section>