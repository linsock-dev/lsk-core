<?php
	/* url del formulario */
  $lv_lnk = '?prg=syssecdrttyp&prm_syssecdrttypcod='.$vew_data->syssecdrttypcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('syssecdrttyptxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->syssecdrttypcod;

	/* titulo */
	$lv_title = $vew_lang->directives;

	/* m�dulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DRT';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    <textarea id="syssecdrttypreq" name="syssecdrttypreq" class="hidden"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->syssecdrttypcod; ?><input type="hidden" id="syssecdrttypcod" name="syssecdrttypcod" value="<?= $vew_data->syssecdrttypcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        <div class="col-md-6">
          <!--directivas-->
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <?= $vew_lang->directive; ?>
                <span class="tmss-card-icon"><i class="fas fa-book"></i></span>
              </div>
            </div><!--header-->

            <!-- Modo lectura -->
            <div class="card-body tmss-card-body-edit">
              <?php
                echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('syssecdrttypcodext','doccmt1x40', $vew_data->syssecdrttypcodext, $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('syssecdrttyptxt', 'doccmt1x150', $vew_data->syssecdrttyptxt, $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 			'input'=>gethtml('syssecdrttyptyp', array( ''=>'', 'numeric'=>$vew_lang->numeric, 'string'=>$vew_lang->text, 'sn'=>$vew_lang->sn ), $vew_data->syssecdrttyptyp, $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
              ?>
            </div><!--body-->
          </div><!-- card -->
        </div><!--col-->
        
        <div class="col-md-6">
          <div class="row">
          	<!--Valores-->
            <div class="card">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->value; ?>
                  <a id="varBtn" class="card-icon"><i class="fas fa-book"></i></a>
                </div>
              </div><!--header-->

              <div class="card-body tmss-card-body-edit">
                <?= gethtml('syssecdrttypdef', 'hidden', $vew_data->syssecdrttypdef, $lv_default); ?>
								<!--div para directivas de tipo numerico-->
                <div id="numdefdiv" class="<?= ( $vew_data->syssecdrttyptyp != 'numeric' ? 'hidden' : '' ); ?>">
                  <?php
                    echo vew_boot($lv_col2424, array('label1'=>$vew_lang->minimum,
                                                    'input1'=>gethtml('syssecdrttypmin','docqty', $vew_data->syssecdrttypmin, $lv_default),
                                                    'label2'=>$vew_lang->maximum,
                                                    'input2'=>gethtml('syssecdrttypmax','docqty', $vew_data->syssecdrttypmax, $lv_default)) );
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->default, 'input'=>gethtml('syssecdrttypdefnum','docqty', ( $vew_data->syssecdrttyptyp == 'numeric' ? $vew_data->syssecdrttypdef : '' ), $lv_default) ));
                  ?>
                </div>
								<!--div para directivas de tipo string-->
                <div id="strdefdiv" class="<?= ( $vew_data->syssecdrttyptyp != 'string' ? 'hidden' : '' ); ?>">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->default, 
                                                 'input'=>gethtml('syssecdrttypdefstr','doccmt5x50', $vew_data->syssecdrttypdef, $lv_default) )); ?>
                </div>
								<!--div para directivas de tipo si/no-->
                <div id="sndefdiv" class="<?= ( $vew_data->syssecdrttyptyp != 'sn' ? 'hidden' : '' ); ?>">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->default, 
                                                 'input'=>gethtml('syssecdrttypdefsn', 'checkbox', ( $vew_data->syssecdrttypdef == '1' ? 'on' : 'off' ), $lv_default) )); ?>
                </div>
                <?php
                		echo vew_boot($lv_col273, array('label1'=>$vew_lang->message, 
                                                   'input1'=> gethtml('syssecdrttypmsg', 'doccmt1x100', $vew_doc->getTagValue( $vew_data->syssecdrttypatr, 'usrmsg' ), $lv_default ),
                                                   'input2'=> vew_boot($lv_col57, array('label1'=>$vew_lang->visible, 
                                                   																		'input1'=> gethtml('syssecdrttypvis', 'checkbox', ($vew_doc->getTagValue( $vew_data->syssecdrttypatr, 'usrshw' )== 1 ? 'on' : 'off'), $lv_default)))));
                ?>
              </div><!--body-->
            </div><!-- card -->
          </div><!--row-->
          
          <div class="row">
            <!--Dependencias-->
            <div class="card">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->dependencies; ?>
                  <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                </div>
              </div><!--header-->
              <div class="card-body">
                <div id="typreqtbl"></div>
              </div><!--body-->
            </div><!-- card -->
          </div><!--row-->
        </div><!--col-->
      </div>
    </div>
  </form>
  
  <script>
    var go_<?= $lv_sec; ?>_tblreq;
    var go_<?= $lv_sec; ?>_tblcfgreq;
    var gv_<?= $lv_sec; ?>_tbldatreq; 
    go_<?= $lv_sec; ?>_tblcfgreq = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->directive; ?>", width:"60%"}, {title:"<?= $vew_lang->value; ?>", width:"35%"}],
                columnsData: [
                              {id: "syssecdrttyptxt", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "syssecdrttyp",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"syssecdrttyptxt": "syssecdrttyptxt", 
                                                    "syssecdrttypcod": "syssecdrttypcod",
                                                   	"syssecdrtgrptypdefval": "syssecdrttypdef"}
                                           }
                                         };
                               }
                              },
                              {id: "syssecdrttypval", type: "text"}
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldatreq = [<?php
          $lv_buffer='';
          if($vew_data->syssecdrttypreq != ''){
            foreach($vew_data->syssecdrttypreq as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'syssecdrttypcod:"'.$lv_row['syssecdrttypcod'].'",'.
                          'syssecdrttyptxt:"'.$lv_row['syssecdrttyptxt'].'",'.
                          'syssecdrttypval:"'.$lv_row['syssecdrttypval'].'",'.
                          '}'; 
            }
          }
          echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tblreq = new tmssTable($("#<?= $lv_sec; ?> #typreqtbl"), go_<?= $lv_sec; ?>_tblcfgreq);
    
    $(function(){
    	go_<?= $lv_sec; ?>_tblreq.loadData(gv_<?= $lv_sec; ?>_tbldatreq);
    });
  </script>
  <!--logica varia-->
	<script>    
    //diccionario de variables en el campo mensaje
    $("#<?= $lv_sec; ?> #varBtn").click(function(){
      var lv_tbl = "<table class='table table-hover' style='margin:0px'>";
      lv_tbl = lv_tbl + "<thead><tr><th class='text-center'><?= $vew_lang->variables ?></th><th><?= $vew_lang->description ?></th></tr></thead>";
      lv_tbl = lv_tbl + "<tbody><tr><td class='text-center'>@@DEFAULT</td><td>Se utiliza para representar el valor del campo default</td></tr><tr><td class='text-center'>@@PATTERN</td><td><?= utf8_decode( 'se utiliza para representar las coincidencias de una contraseña dentro de los valores del campo default de una directiva de tipo texto' ); ?></td></tr></tbody>";
      lv_tbl = lv_tbl + "</table>";
      
      BootstrapDialog.show({
        message: lv_tbl,
        closable:false,
        draggable:true,
        buttons:[{label: "<?= $vew_lang->close; ?>", cssClass: "btn-default", action: function(dialog){ dialog.close(); }}],
        onshow: function(dialog){ dialog.$modalBody.css( "padding", "0px" ); }
      });
    })
  </script>
  
  <!--script para la logica visual de la tarjeta value-->
  <?php if( $vew_actcod != '00' && $vew_actcod != '03' ){ ?>
    <script>
      //sincroniza los valores de los campo default
      $("#<?= $lv_sec; ?> #syssecdrttypdefnum, #<?= $lv_sec; ?> #syssecdrttypdefstr, #<?= $lv_sec; ?> #syssecdrttypdefsn").change(function(e){e.preventDefault;$("#<?= $lv_sec; ?> #syssecdrttypdef").val( $(this).val() ); });

      //cambia el div de valor visible
      $("#<?= $lv_sec; ?> #syssecdrttyptyp").change(function(){
        //oculta todos los div
        $("#<?= $lv_sec; ?> #numdefdiv, #<?= $lv_sec; ?> #strdefdiv, #<?= $lv_sec; ?> #sndefdiv").addClass("hidden");
				
        //muestra el div adecuado dependiendo del tipo
        switch( $(this).val() ){
          case 'numeric':
            $("#<?= $lv_sec; ?> #numdefdiv").removeClass("hidden");
            //al campo default se le asigna el valor del campo default temporal actual
        		$("#<?= $lv_sec; ?> #syssecdrttypdef").val( $("#<?= $lv_sec; ?> #syssecdrttypdefnum").val() );
            break;
          case 'string':
            $("#<?= $lv_sec; ?> #strdefdiv").removeClass("hidden");
            //al campo default se le asigna el valor del campo default temporal actual
        		$("#<?= $lv_sec; ?> #syssecdrttypdef").val( $("#<?= $lv_sec; ?> #syssecdrttypdefstr").val() );
            break;
          case 'sn':
            $("#<?= $lv_sec; ?> #sndefdiv").removeClass("hidden");
            //al campo default se le asigna el valor del campo default temporal actual
        		$("#<?= $lv_sec; ?> #syssecdrttypdef").val( $("#<?= $lv_sec; ?> #syssecdrttypdefsn").val() );
            break;
          default:
            break;
        }
      });
    </script>
  <?php } ?>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
        var lv_dat = go_<?= $lv_sec; ?>_tblreq.getData();
        
        // Verifica que no haya directivas repetidas en la tabla
        for (var i=0; i < lv_dat.length; i++) {
          for (var j=0; j < lv_dat.length; j++) {
						if(lv_dat[i]["syssecdrttypcod"] == lv_dat[j]["syssecdrttypcod"] && i!=j){
              toastr.warning("Existen directivas repetidas.");
              return false;
            }
          }
        }
        
        $("#<?= $lv_sec; ?> #syssecdrttypreq").prop("value", JSON.stringify( lv_dat ) );

			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>