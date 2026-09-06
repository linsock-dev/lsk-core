<?php		
	/* url del formulario */
  $lv_lnk = '?prg=finlocargcrt';

	/* campos requeridos */
	$vew_input->RequiredFields(  );

	/* clave del documento */
	$lv_dockey = ''; 

	/* titulo */
	$lv_title = 'Localizaci&oacute;n Argentina';
	
	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');

	// Botones por vista
	$vew_dropdown = false;
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <!-- Nav-Bar -->
	<?php include('grldocfrmtlb.frm'); ?>
  
  <div class="tab-content tmss-tab-content">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-3">
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                AFIP
              </div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <a href="#" class="tmssAlwaysEnabled card-opt-body text-center" id="btnprvafp"><strong>Solicitud</strong></a>
              <a href="#" class="tmssAlwaysEnabled card-opt-body text-center" id="btncrtafp"><strong>Certificado</strong></a>
              <a href="#" class="tmssAlwaysEnabled card-opt-body text-center" id="btnchkafp"><strong>Verificar Conexi&oacute;n</strong></a>      
            </div>
          </div>			
        </div>
        <div class="col-md-9">
          <div class="card">
            <div class="card-header">
              <div class="card-title">
              	Certificados Digitales  
                <a href='#' id='btnkeydwn' class='card-icon hidden' title="Descargar"><i class='fas fa-download'></i></a>
                <a href='#' id='btnkeygen' class='card-icon hidden' title="Generar"><i class='fas fa-cogs'></i></a>
                <a href='#' id='btnsve' class='card-icon btn btn-success hidden' title="Grabar"><i class='fas fa-save'></i></a>
                <a href='#' id='btncan' class='card-icon btn btn-danger hidden' title="Cancelar"><i class='fas fa-times'></i></a>
                <a href='#' id='btnload' class='card-icon hidden' title="Ingresar"><i class='fas fa-pencil-alt'></i></a>
                <a href='#' id='btnupload' class='card-icon hidden' title="Cargar"><i class='fas fa-upload'></i></a>
              </div>
            </div>
            <div class="card-body tmss-card-body-edit">
          		<div id="afip_content"></div>
              <div class="hidden"><input type="file" id="uplcrt"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
	<script>		
		// VERIFICAR CONEXION
		$("#<?= $lv_sec; ?> #btnchkafp").on("click",function(e){
      $("#<?= $lv_sec; ?> .card-title > a").addClass("hidden");
      
			var lv_pstdat = [];
			tmssCallProcess("?prg=finlocargwss&act=AfipCnxDmy", lv_pstdat, function(data){
				var lv_buffer = "<textarea id='txtkey' class='form-control' rows='10' disabled='disabled'>"+data+"</textarea>";
				$("#<?= $lv_sec; ?> #afip_content").html(lv_buffer);
			});
		});
		
    // SOLICITUD
		$("#<?= $lv_sec; ?> #btnprvafp").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> .card-title > a").addClass("hidden");
                                                            
			var lv_pstdat = [{name:"buscod",value:"<?= $vew_data->buscod; ?>"}];
			tmssCallProcess("?prg=finlocargcrt&act=AfipReqGet",lv_pstdat,function(data){
				var lv_buffer = "<textarea id='txtkey' class='form-control' rows='10' disabled='disabled'>"+data+"</textarea>";
				
        $("#<?= $lv_sec; ?> #afip_content").html(lv_buffer);
        $("#<?= $lv_sec; ?> #btnkeygen").removeClass("hidden");
        $("#<?= $lv_sec; ?> #btnkeydwn").removeClass("hidden");
			});
		});
    
    // Descargar
    $("#<?= $lv_sec; ?> #btnkeydwn").on("click",function(e){ e.preventDefault();
    	($("#<?= $lv_sec;?> #afip_content #txtkey").text() == "") ? toastr.warning("No existe un certificado para descargar.") : window.open("?prg=finlocargcrt&act=AfipReqGet&prm_dwn=1");
    });
		
    // Generar 
    $("#<?= $lv_sec; ?> #btnkeygen").on("click",function(e){
      e.preventDefault();
      BootstrapDialog.confirm({
        title: "Generar Clave",
        message: "Desea generar una clave privada?",
        callback: function(result) {
          if(result) {
            tmssCallProcess("?prg=finlocargcrt&act=AfipReqSet",lv_pstdat,function(data){
              $("#<?= $lv_sec; ?> #txtkey").text( data );
              toastr.success( "Clave generada." );
            });
          }
        }
      });
    });	
		
    // CERTIFICADO 
		$("#<?= $lv_sec; ?> #btncrtafp").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> .card-title > a").addClass("hidden");
                                                            
			var lv_pstdat = [{name:"buscod",value:"<?= $vew_data->buscod; ?>"}];
			tmssCallProcess("?prg=finlocargcrt&act=AfipCrtGet",lv_pstdat,function(data){
				var lv_buffer = "<textarea class='form-control' rows='10' id='txtkey' disabled='disabled'>"+data+"</textarea>";
				
        $("#<?= $lv_sec; ?> #afip_content").html(lv_buffer);
        $("#<?= $lv_sec; ?> #btnupload").removeClass("hidden");
        $("#<?= $lv_sec; ?> #btnload").removeClass("hidden");
			});
    });
    
    // Ingresar                                                    
    $("#<?= $lv_sec; ?> #btnload").on("click",function(e){ e.preventDefault();
      $(this).addClass("hidden");
      $("#<?= $lv_sec; ?> #btnupload").addClass("hidden").attr("disabled","disabled");
      $("#<?= $lv_sec; ?> #txtkey").prop("disabled","");
      $("#<?= $lv_sec; ?> #btnsve").removeClass("hidden");
      $("#<?= $lv_sec; ?> #btncan").removeClass("hidden"); 
    });

    // Grabar                                                  
    $("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
      var lv_pstdat = [{name:"crt", value:$("#<?= $lv_sec; ?> #txtkey").val()}];

      tmssCallProcess("?prg=finlocargcrt&act=AfipCrtSet",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #btnload").removeClass("hidden");
        $("#<?= $lv_sec; ?> #btnupload").removeClass("hidden");
        $("#<?= $lv_sec; ?> #txtkey").prop("disabled","diabled");
        $("#<?= $lv_sec; ?> #btnsve").addClass("hidden");
        $("#<?= $lv_sec; ?> #btncan").addClass("hidden");
        toastr.success("Certificado grabado.");
      });
    });

    // Cancelar                                                           
    $("#<?= $lv_sec; ?> #btncan").on("click",function(e){ e.preventDefault();
      var lv_pstdat = [{name:"buscod",value:"<?= $vew_data->buscod; ?>"}];

      tmssCallProcess("?prg=finlocargcrt&act=AfipCrtGet",lv_pstdat,function(data){
        var lv_buffer = "<textarea class='form-control' rows='10' id='txtkey' disabled='disabled'>"+data+"</textarea>";
        $("#<?= $lv_sec; ?> #afip_content").html(lv_buffer);
        $("#<?= $lv_sec; ?> #btnupload").removeClass("hidden");
        $("#<?= $lv_sec; ?> #btnload").removeClass("hidden");
        $("#<?= $lv_sec; ?> #btnsve").addClass("hidden");
        $("#<?= $lv_sec; ?> #btncan").addClass("hidden");
      });
    });

    // Cargar
    $("#<?= $lv_sec; ?> #btnupload").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> #uplcrt").trigger("click");
    });
    
    // Lectura de archivo .crt
    $("#<?= $lv_sec; ?> #uplcrt").on("change", function(e){ e.preventDefault();
      // Funcion de lectura pendiente
    });
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if (lp_prm['action']=='prn') {
				window.print();
			}
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>