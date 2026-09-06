 <?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'EMA';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc['steevtcod']??'';
	$lv_steevtdoccod = $vew_data->evtdoc['steevtdoccod']??'';
	$lv_steevtdocatr = json_decode(mb_convert_encoding($vew_data->evtdoc['steevtdocatr']??'[]','UTF-8','iso-8859-1'), true);
	$lv_steevtdocatr = array_map(function($elem){return mb_convert_encoding($elem??'', 'iso-8859-1', 'UTF-8');}, $lv_steevtdocatr);

  $vew_data->tsktxtlst = ['' => ''] + array_column($vew_data->tskbar, 'srcobjtxt', 'srcobjcod001');
  $vew_data->tskcodextlst = ['' => ''] + array_column($vew_data->tskbar, 'srcobjcodext', 'srcobjcod001');
  $vew_data->tskclscodextlst = ['' => ''] + array_column($vew_data->tskbar, 'cnstskclscodext', 'srcobjcod001');
?> 
<section id="<?= $lv_sec; ?>">     
  <?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
  <?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
  <?= gethtml('steevtdocdat', 'hidden', (isset($vew_data->evtdoc) ? $vew_data->evtdoc['steevtdocatr'] : '')); ?>
	<div class="row">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            	<?= $vew_lang->technicalassistance; ?>
            <span class="tmss-card-icon">
            </span>
          </div>
        </div>
        <div class="card-body tmss-card-body-edit">
          <?php
            echo vew_boot($lv_col210, array('label' => $vew_lang->address,'input' => gethtml('steevtdocadr', 'doccmt1x100', $lv_steevtdocatr['steevtdocadr']??'', $lv_default) )) ;
          	echo vew_boot($lv_col255, array('label' => $vew_lang->schedule,'input1' => vew_boot($lv_col210, array('label' => $vew_lang->from,'input' => gethtml('steevtdocstrtme', 'doctme', $lv_steevtdocatr['steevtdocstrtme']??'', $lv_default) )),
                                            'input2' => vew_boot($lv_col210, array('label' => $vew_lang->to,'input' => gethtml('steevtdocendtme', 'doctme', $lv_steevtdocatr['steevtdocendtme']??'', $lv_default) ))));
    				echo vew_boot($lv_col255, array('label' =>$vew_lang->bond ,'input1' => vew_boot($lv_col210, array('label' => $vew_lang->from,'input' => gethtml('steevtdocstrlnk', 'doccmt1x50', $lv_steevtdocatr['steevtdocstrlnk']??'', $lv_default))),
																						'input2' => vew_boot($lv_col210, array('label' => $vew_lang->to,'input' => gethtml('steevtdocendlnk', 'doccmt1x50', $lv_steevtdocatr['steevtdocendlnk']??'', $lv_default)))));
          	echo vew_boot($lv_col255, array('label'=>$vew_lang->feescale, 'input1'=>gethtml('cnstskcod', $vew_data->tsktxtlst, $lv_steevtdocatr['cnstskcod']??'', $lv_default),
                                        		'input2' =>vew_boot($lv_col39, array(   'label'=>$vew_lang->quantity,'input'=>gethtml('steevtdocqty', 'docnum', $lv_steevtdocatr['steevtdocqty']??'', $lv_default)))));
            echo vew_boot($lv_col210, array('label'=>$vew_lang->observations,'input'=>gethtml('steevtdocobs', 'doccmt2x100', $lv_steevtdocatr['steevtdocobs']??'', $lv_default) ));							
          ?>
        </div>
      </div>
    </div>
     <!-- UBICACION -- se comenta hasta que se pueda guardar la imagen del form 
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <?=$vew_lang->location;?>
            <span class="tmss-card-icon">
            </span>
          </div>
        </div>
        <div class="card-body tmss-card-body-edit">
          <div id="sgnpadfrm" class="hidden">
            <div class="form-group tmss-form-group">
              <div id="sgnpad" class="">
                <canvas id="signature" style="border: #a6a6a6 1px solid;"></canvas>
              </div>
            </div>
          </div>
          <!-- Imagen firma --
          <div id="sgnpadimgfrm">
            <div class="form-group tmss-form-group">
              <label class="col-sm-2 control-label"><?= $vew_lang->file; ?></label>
              <div class="col-xs-10" id="sgnpadimg"><?php include('grldatuplshwpth.frm'); ?></div>
            </div>
          </div>
        </div>
      </div>
    </div>-->
    <!-- CIERRE -->
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <?=$vew_lang->closing;?>
            <span class="tmss-card-icon">
            </span>
          </div>
        </div>
        <div class="card-body tmss-card-body-edit">
          <?php
            echo vew_boot($lv_col2424, array('label'=>$vew_lang->remit,'input'=>gethtml('steevtdocrem', 'doccmt1x50', $lv_steevtdocatr['steevtdocrem']??'', $lv_default),
                                             'label1'=>$vew_lang->pec,'input1'=>gethtml('steevtdocpec', 'doccmt1x50', $lv_steevtdocatr['steevtdocpec']??'', $lv_default) ));							
            echo vew_boot($lv_col2424, array('label1'=>$vew_lang->date,'input1'=>gethtml('steevtdocpecdte', 'docdte', $lv_steevtdocatr['steevtdocpecdte']??'', $lv_default),
                                            'label2'=>$vew_lang->time,'input2'=>gethtml('steevtdocpectme', 'doctme', $lv_steevtdocatr['steevtdocpectme']??'', $lv_default)));							
          ?>
        </div>
      </div>
    </div>
    
  </div>
	<script>
   /* --NOTA: se comenta para en un futuro dibujar en el canvas, la logica funciona pero al ser un formulario de cliente no se puede guardar la imagen sin modificar el controlador de sistema
   //Si esta en modo lectura solo se puede ver la firma
    if($("#<?= $lv_sec; ?> #tmss_actcod").val()!='03'){
			$("#<?= $lv_sec; ?> #sgnpadfrm").removeClass("hidden");
			$("#<?= $lv_sec; ?> #sgnpadimgfrm").addClass("hidden");
		 }
    
   // 1. Definición de variables globales para este contexto
    var <?= $lv_sec; ?>_signaturePad;
    var <?= $lv_sec; ?>_canvas = $("#<?= $lv_sec; ?> canvas#signature").get()[0];
    // Clon para referencias (opcional según tu lógica original)
    var <?= $lv_sec; ?>_canvas_blank = <?= $lv_sec; ?>_canvas.cloneNode(true);
    
    // 2. Pre-carga de la imagen de fondo (El mapa de calles)
    var <?= $lv_sec; ?>_bgImage = new Image();
    // TIP SENIOR: Usa Base64 si la imagen es pequeña para evitar latencia de red, 
    // o una URL relativa si es un archivo.
    <?= $lv_sec; ?>_bgImage.src = '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'; 
    
    // Flag para saber si la imagen ya cargó
    var <?= $lv_sec; ?>_imgLoaded = false;
    
    <?= $lv_sec; ?>_bgImage.onload = function() {
        <?= $lv_sec; ?>_imgLoaded = true;
        // Si la imagen carga después de iniciar, forzamos el redibujado
        <?= $lv_sec; ?>_resizeCanvas();
    };

    // 3. Función dedicada para pintar el fondo
    function <?= $lv_sec; ?>_drawBackground() {
        if (!<?= $lv_sec; ?>_imgLoaded) return;

        var ctx = <?= $lv_sec; ?>_canvas.getContext("2d");
        
        // Guardamos el estado actual del contexto (color, grosor, etc)
        ctx.save();
        
        // Configuramos para que la imagen se dibuje "detrás" de lo que ya exista (trazos)
        // Esto es útil si quieres redibujar el fondo sin borrar la firma, 
        // aunque resizeCanvas suele limpiar todo.
        ctx.globalCompositeOperation = 'destination-over';

        // Dibujamos la imagen estirándola al tamaño lógico del canvas (offsetWidth/Height)
        // No usamos .width/.height directos porque esos tienen el ratio de píxeles aplicado.
        ctx.drawImage(
            <?= $lv_sec; ?>_bgImage, 
            0, 
            0, 
            <?= $lv_sec; ?>_canvas.offsetWidth, 
            <?= $lv_sec; ?>_canvas.offsetHeight
        );

        // Restauramos el estado para que la firma siga siendo negra/azul/etc.
        ctx.restore();
    }

    // 4. Lógica de Input (Mantenemos tu lógica original)
    $("#<?= $lv_sec; ?> #sgnini").on("keyup",function(){
        var lv_txt = $(this).prop("value").toUpperCase().trim();
        
        // Limpiamos (esto borra todo)
        if(<?= $lv_sec; ?>_signaturePad) {
             <?= $lv_sec; ?>_signaturePad.clear();
        }
        
        // Inmediatamente repintamos el fondo
        <?= $lv_sec; ?>_drawBackground();

        var lo_cnv = <?= $lv_sec; ?>_canvas.getContext("2d");
        lo_cnv.font = "48px Lucida Calligraphy";
        lo_cnv.fillStyle = "black"; // Aseguramos color por si acaso
        lo_cnv.fillText(lv_txt, 90, 95);
    });

    // 5. Función de Redimensionado (Optimizada)
    function <?= $lv_sec; ?>_resizeCanvas() {
        // Validación básica
        if (typeof <?= $lv_sec; ?>_signaturePad === 'undefined') { return false; }

        var ratio = Math.max(window.devicePixelRatio || 1, 1);

        // Ajuste de píxeles físicos vs lógicos
        <?= $lv_sec; ?>_canvas.width = <?= $lv_sec; ?>_canvas.offsetWidth * ratio ;
        <?= $lv_sec; ?>_canvas.height = <?= $lv_sec; ?>_canvas.offsetHeight * ratio ;
        
      // Aseguramos que via CSS también se vea al 100% (redundancia segura)
        var ctx = <?= $lv_sec; ?>_canvas.getContext("2d");
        ctx.scale(ratio, ratio);

        // Actualizamos el clon (si lo usas en otra parte de tu lógica)
        <?= $lv_sec; ?>_canvas_blank.width = <?= $lv_sec; ?>_canvas.width;
        <?= $lv_sec; ?>_canvas_blank.height = <?= $lv_sec; ?>_canvas.height;
        <?= $lv_sec; ?>_canvas_blank.getContext("2d").scale(ratio, ratio);

        // Limpiamos datos de la librería
        <?= $lv_sec; ?>_signaturePad.clear(); 
        
        // PINTAMOS EL FONDO
        <?= $lv_sec; ?>_drawBackground();
    }

    // 6. Inicialización
    tmssLoadScript("signature_pad", function(){
        <?= $lv_sec; ?>_signaturePad = new SignaturePad(<?= $lv_sec; ?>_canvas, {
            // Importante: Transparente para manejar nosotros el fondo o blanco si prefieres
            // Al usar una imagen de fondo, 'rgba(0,0,0,0)' suele ser mejor para ver la imagen,
            // pero si vas a exportar a JPG, necesitarás manejar el fondo en el export.
            backgroundColor: 'rgba(255, 255, 255, 0)', 
            penColor: 'rgb(0, 0, 0)'
        });
        
        // Configurar evento de resize
        window.onresize = <?= $lv_sec; ?>_resizeCanvas;
        
        // Llamada inicial
        <?= $lv_sec; ?>_resizeCanvas();
    });
    */
</script>
  <script>
    function lo_<?= $lv_sec; ?>_after(lp_data){
        if(lp_data.hasOwnProperty("stecod"))$("#<?= $lv_sec; ?> #stecod").trigger("change"); 
    }
  </script>
  <script>
    // parsea los datos del formulario
    function <?= $lv_sec; ?>_sve( lp_sec ){ 
      var lv_tskcodextlst = <?= json_encode($vew_data->tskcodextlst) ?> || {};
      var lv_tskclscodextlst = <?= json_encode($vew_data->tskclscodextlst) ?> || {};
      
			var lv_evtdat = {"steevtdoccod": $("#<?= $lv_sec; ?> #steevtdoccod").prop("value"),
											"srcobjtyp": "CNS_EVT_FRM",
											"srcobjcod": "1",
											"srcobjtxt": "ASISTENCIA TECNICA",
											"steevtdocatr": ""};
			var lv_frmatr = {}; 		
      //asistencia tecnica
      lv_frmatr["steevtdocadr"] = $("#<?= $lv_sec; ?> #steevtdocadr").val();
      lv_frmatr["steevtdocstrtme"] = $("#<?= $lv_sec; ?> #steevtdocstrtme").val();
      lv_frmatr["steevtdocendtme"] = $("#<?= $lv_sec; ?> #steevtdocendtme").val();	
      lv_frmatr["steevtdocstrlnk"] = $("#<?= $lv_sec; ?> #steevtdocstrlnk").val();	
      lv_frmatr["steevtdocendlnk"] = $("#<?= $lv_sec; ?> #steevtdocendlnk").val();	
      lv_tskcod= $("#<?= $lv_sec; ?> #cnstskcod").val();
			lv_frmatr["cnstskcod"] = lv_tskcod;
      lv_frmatr["cnstsktxt"] = $("#<?= $lv_sec; ?> #cnstskcod option:selected").text();
      lv_frmatr["cnstskcodext"] =lv_tskcodextlst[lv_tskcod];	
      lv_frmatr["cnstskclscodext"] =lv_tskclscodextlst[lv_tskcod];	
      
      lv_frmatr["steevtdocqty"] = $("#<?= $lv_sec; ?> #steevtdocqty").val();	
      lv_frmatr["steevtdocobs"] = $("#<?= $lv_sec; ?> #steevtdocobs").val();	
      //cierre
			lv_frmatr["steevtdocrem"] = $("#<?= $lv_sec; ?> #steevtdocrem").val();	
      lv_frmatr["steevtdocpec"] = $("#<?= $lv_sec; ?> #steevtdocpec").val();	
      lv_frmatr["steevtdocpecdte"] = $("#<?= $lv_sec; ?> #steevtdocpecdte").val();	
      lv_frmatr["steevtdocpectme"] = $("#<?= $lv_sec; ?> #steevtdocpectme").val();	

      lv_evtdat["steevtdocatr"] = JSON.stringify(lv_frmatr);
			$("#<?= $lv_sec; ?> #steevtdocdat").val( JSON.stringify([lv_evtdat]) );      
      return true;
    }
  </script>
  <script>
    tmssFormEdit("<?= $lv_sec; ?>", <?= $vew_readonly?'false':'true'; ?> );
  </script>
</section>