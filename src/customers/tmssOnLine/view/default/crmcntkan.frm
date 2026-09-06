<?php
  // url del formulario
  $lv_lnk = '?prg=crmcnt';

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // titulo
	$lv_title = $vew_lang->Contacts;

  // módulo y programa
  $lv_mdlcod = 'CRM';
  $lv_prgcod = 'CNT';

  // clave del documento
	$lv_dockey = '';

	$vew_actcod='02';

  // librería de estilos bootstrap
  include_once('_library.frm');
	
	$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=crmcnt&act=01'.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
  $vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>true,'pos'=>'D','ttl'=>$vew_lang->refresh,'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');
	$vew_tbl['sp1'] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
	$vew_tbl['dsh'] = array('pos'=>'D','id'=>'btndsh','ttl'=>$vew_lang->dashboard,'tooltip'=>$vew_lang->dashboard,'icn'=>'far fa-chart-pie','css'=>'tmss-Opt','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=crmcnt&act=dsh'.chr(39).', [{target: '.chr(39).'_replace_with'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
	$vew_tbl['knu'] = array('pos'=>'D','id'=>'btnknu','ttl'=>$vew_lang->user,'tooltip'=>$vew_lang->users, 'icn'=>'fas fa-align-left fa-rotate-90','css'=>'tmss-Opt','per'=>($vew_data->vew=='sts'), 'acc'=>'tmssLink('.chr(39).'?prg=crmcnt&act=kan&prm_vew=usr'.chr(39).', [{target: '.chr(39).'_replace_with'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
	$vew_tbl['kns'] = array('pos'=>'D','id'=>'btnkns','ttl'=>$vew_lang->status,'tooltip'=>$vew_lang->statuses, 'icn'=>'fas fa-align-left fa-rotate-90','css'=>'tmss-Opt','per'=>($vew_data->vew=='usr'), 'acc'=>'tmssLink('.chr(39).'?prg=crmcnt&act=kan&prm_vew=sts'.chr(39).', [{target: '.chr(39).'_replace_with'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
	$vew_tbl['flt'] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'far fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?> ">
	<style>
		.Tlist { width: 260px; height: calc(100% - 17px);	margin-top:5px;	background-color: #e7e7e7; border-radius:5px; } 
		.Tlist > header > span { text-transform: capitalize; }
		.Tlist > header > .badge { margin-top:10px; }
		.Tlist span[name="link"]{ text-transform:capitalize; }
		.Tlist span[name="link"]:hover{ text-decoration:underline; cursor:pointer; }
		.Tui {height: 75vh; display: grid; grid-template-rows: 1fr; grid-template-columns: 100%; color: #eee; }
		.Tlists {	display: flex; overflow-x: auto; width: 100%; }
		.Tlists::after {content: ''; flex: 0 0 10px; }
		.Tlists > * {flex: 0 0 auto; margin-left:10px; }
		.Tlist > * {color: #333; padding: 0 10px; }
		.Tlist header {line-height: 36px; font-size: 16px; font-weight: bold; border-radius:5px; padding-left:20px; padding-right:20px;	margin-bottom: 6px;	}
		.Tlist ul {	margin: 0;	height: calc(100% - 46px);	overflow-y: auto;	}
		.Tli { margin-bottom: 5px; position:relative; list-style: none; background-color: #fff; padding-left:10px; padding-right:10px; padding-top:7px; padding-bottom:7px; border-radius:5px; overflow:hidden; }
		.Tli:after { content: ''; width: 0; height: 0; border-style: solid; border-width: 0 30px 30px 0; border-color: transparent var(--tmss-kanban-card-color) transparent transparent; right: 0; top: 0; position: absolute; }
		.Tli .card-info {	font-size:smaller; }
		.Tli .card-info span {	margin-right: 10px;}
		.Tli .card-info i {	color:#a6a6a6; }
	</style>
	<?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('vewflt','hidden',''); ?>
    <?= gethtml('vewfltdef','hidden',$vew_data->vewfldfltdef); ?>
    <div class="Tui"><div class="Tlists<?= ($vew_data->vew=='sts'?' droppable':''); ?>"></div></div>
  </form>
	<script>
		function <?= $lv_sec; ?>_refresh(){
			var lv_pstdat={ vewfldflt: "[~fltrow~]row_num_<?= $vew_data->vew; ?>\t\t\t\t\t"+(tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]==""?"":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]), 
											//vewfldord: "<?= ($vew_data->vew=='sts'?'crmcntststxt':'usrtxt'); ?>",
											vewmaxrec: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]==""?"100":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]) 
										};
			tmssCallProcess("?prg=crmcnt&act=28",lv_pstdat,function(data){
				
				// quito las tarjetas previas
				$("#<?= $lv_sec; ?> .tmssDraggable").remove();
				
				<?php if($vew_data->vew=='sts'){ ?>
					var lv_fnd = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"];
					var lv_fndstr = lv_fnd.indexOf("[~fltrow~]s.crmcntststxt");
					if( lv_fndstr!=-1){
						// oculto todas las columnas
						$("#<?= $lv_sec; ?> .Tlist").addClass("hidden");
						var lv_fndend = lv_fnd.indexOf("[~fltrow~]", lv_fndstr+1)
						var lv_fndlen = lv_fnd.length;
						var lv_flt = lv_fnd.substr( lv_fndstr, (lv_fndend==-1?lv_fndlen-lv_fndstr:lv_fndend) );
						var lv_pstdatsts={vewfldflt: lv_flt};
						tmssCallProcess("?prg=crmcntsts&act=18",lv_pstdatsts,function(datasts){
							for(var i=0; i<datasts.data.length; i++){
								$("#<?= $lv_sec; ?> .Tlist[data-crmcntstscod="+datasts.data[i]["crmcntstscod"]+"]").removeClass("hidden");
							}
						});
					}
				<?php } ?>
				var lv_col;
				var lv_card;
        const lv_usrgrp = <?= json_encode($vew_data->usrgrp); ?>;
        // agrego etiquetas
        for(var i=0; i<data.length; i++){

          // determino colores de tarjetas
          lv_clrsts = $("<div>"+data[i]["crmcntstsatr"]+"</div>").find("clr").text();
          lv_clrtyp = $("<div>"+data[i]["crmcnttypatr"]+"</div>").find("clr").text();
          lv_clrprt = $("<div>"+data[i]["crmcntprtatr"]+"</div>").find("clr").text();
          lv_clr = ( lv_clrprt=="" ? lv_clrtyp : lv_clrprt );
          lv_clrbck = (lv_clr==""?"--tmss-white":lv_clr);

          // determino letras indicadores de asignacion (responsable o estado)
          lv_ltr="";
          lv_ltrcod = "<?= ($vew_data->vew=='sts'?'usrcod':'crmcntstscod'); ?>";
          lv_ltrtxt = "<?= ($vew_data->vew=='sts'?'usrtxt':'crmcntststxt'); ?>";
          if( data[i][lv_ltrtxt]!="" && data[i][lv_ltrtxt]!=null ) {
            lv_ltrarr = data[i][lv_ltrtxt].split(" ");
            lv_ltr = lv_ltrarr[0].substring(0,1)+(lv_ltrarr.length>1?lv_ltrarr[1].substring(0,1):"");
          }

          // progreso
          lv_prg = $("<div>"+data[i]["crmcntatr"]+"</div>").find("prg").text();

          // fecha de ticket, fecha de vencimento y dias de vencido
          //lv_reqdte = moment(data[i]["crmcntreqdte"]["date"]);
          lv_duedte = (data[i]["crmcntduedte"]==null?null:moment(data[i]["crmcntduedte"]["date"]));
          lv_duedtedif = (lv_duedte!=null?lv_duedte.diff(new Date(),"days"):0); 
          var lv_cardInfo = "";

          // InfoAdicional de tarjeta (separada por ;)
          <?php if($vew_data->cardInfo!=''){
            $lv_arrInfo = explode(';',$vew_data->cardInfo);
            foreach($lv_arrInfo as $lv_rowInfo){
              $lv_rowInfo = strtolower($lv_rowInfo);
              echo 'lv_cardInfo += (typeof data[i]["'.$lv_rowInfo.'"]=="undefined"?"":"<br><span>"+(data[i]["'.$lv_rowInfo.'"]==null?"-":data[i]["'.$lv_rowInfo.'"])+"</span>");';
              }
            }
          ?>

          var lv_blc = false;
          if(data[i]["crmcntstsblc"] == 1) {
            lv_blc = true;
            var lv_blcexclst = JSON.parse(data[i]["crmcntstsblcexc"] || "[]");
            for(var row of lv_blcexclst){
              if(row.typ == "USR") lv_blc = row.val != "<?= $vew_sec->usrcod ?>";
              else if (row.typ == "ROL"){
                lv_usrgrp.forEach(function(row2){ lv_blc = row.val != row2.usrgrpcod;});
              }
              if(!lv_blc) break;
            };
          }

          // armo tarjeta
          lv_card = "<li class='Tli tmssDraggable Ui-sortable-handle " + ( lv_blc ? "ticketBlocked" : "") + "' id='"+data[i]["crmcntcod"]+"' data-sysdocclscod='"+data[i]["sysdocclscod"]+"' data-crmcntstscod='"+data[i]["crmcntstscod"]+"' data-usrcod='"+data[i]["usrcod"]+"' data-crmcntkanusrord='"+data[i]["crmcntkanusrord"]+"' data-crmcntkanstsord='"+data[i]["crmcntkanstsord"]+"' style='border: var("+lv_clrbck+") 1px solid; --tmss-kanban-card-color: var("+lv_clrbck+");'>"
                    +"<span name='link' data-id='"+data[i]["crmcntcod"]+"'>"+data[i]["crmcnttxt"].toLowerCase()+"</span>"
                    +lv_cardInfo
                    +"<div style='padding-top: 3px; padding-bottom: 3px; display: flex; justify-content: space-between; align-items: flex-end;'>"
                      +"<span class='card-info'>"
                        +"<span title='<?=$vew_lang->id;?>'><i class='far fa-hashtag'></i> "+data[i]["crmcntcod"]+"</span>"
                        +(lv_duedte!=null?"<span class='"+(lv_duedtedif<=7?"text-danger":"")+"' title='<?=$vew_lang->duedate;?>'><i class='far fa-calendar'></i> "+lv_duedte.format("MMM-DD")+"</span>":"")
                        +(lv_prg!=""?"<span title='<?=$vew_lang->progress;?>'><i class='far fa-percent'></i> "+lv_prg+"</span>":"")
                      +"</span>"
                      +(data[i][lv_ltrcod]!="" && data[i][lv_ltrcod]!=null ? "<span class='text-center' style='border-radius:50%; <?= ($vew_data->vew=='sts'?'background-color:#00000088; color:white;':'background-color:var("+lv_clrsts+"); color:var("+lv_clrsts+"-text);'); ?> font-weight:bold; padding-top:2px; width:26px; height:25px;' title='"+(lv_ltr!=""?data[i][lv_ltrtxt]:"("+data[i][lv_ltrcod]+")")+"'>"+(lv_ltr!=""?lv_ltr:"*")+"</span>" : "")
                    +"</div></li>";

          // verifico si existe la columna (estado o usuario)
          lv_colfld = "<?=($vew_data->vew=='sts'?'crmcntstscod':'usrcod');?>";
          lv_colval = (data[i][lv_colfld]=="" || data[i][lv_colfld]==null ? "0" : data[i][lv_colfld] );
          lv_coltxt = data[i]["<?=($vew_data->vew=='sts'?'crmcntststxt':'usrtxt');?>"];
					lv_colcls = "<?= $vew_data->vew=='sts'; ?>" ? data[i]['crmcntstscls'] : false;
          lv_colblc = "<?= $vew_data->vew=='sts'; ?>" ? data[i]['crmcntstsblc'] : false;
          lv_colblcexc = "<?= $vew_data->vew=='sts'; ?>" ? data[i]['crmcntstsblcexc'] : "[]";
          // agrego tarjeta a columna
          if( <?= $lv_sec; ?>_addColumn( lv_colfld, lv_colval, lv_coltxt, <?= ($vew_data->vew=='sts'?'lv_clrsts':'""'); ?>, lv_colcls, lv_colblc, lv_colblcexc ) ){
            $(lv_card).appendTo( $("#<?= $lv_sec; ?> .Tlist[data-"+lv_colfld+"="+lv_colval+"] .droppable") );
          }
        }

        // actualizo contadores de columnas
        $("#<?= $lv_sec; ?> .Tlist").each( function(){
          $(this).find("header .badge").text( $(this).find(".droppable .tmssDraggable").length );
        });

        // activo eventos click (tarjetas)
        $("#<?= $lv_sec; ?> .Tui li span[name=link]").on("click",function(e){e.preventDefault;
          tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).data("id"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
        })

        // activo eventos de drag&drop y sort
        tmssLoadScript("jquery-ui",function(){
          <?php if($vew_data->vew=='sts'){ ?>
          $("#<?= $lv_sec; ?> div.droppable").sortable({
            connectWith: "div.Tlists.droppable",
            opacity: 0.8,
            scrollSensitivity: 300,
            scrollSpeed: 20,
            revert: true,
            over : function(){ $(this).addClass('ui-state-highlight'); },
            out : function(){ $(this).removeClass('ui-state-highlight'); },
            start: function( event, ui ) { $(ui.item[0]).css("transform","rotate(3deg)"); },
            stop: function( event, ui ) { $(ui.item[0]).css("transform",""); },
            update: function( event, ui ) { 
              var lv_ord=""; $(".Tlist").each(function(){ lv_ord+=(lv_ord==""?"":";")+$(this).data("crmcntstscod"); });
              var lv_pstdat={colsts: lv_ord};
              tmssCallProcessNoBackdrop("?prg=crmcnt&act=kanprfsve",lv_pstdat,function(data){});
            }
          });
          <?php } ?>

          $("#<?= $lv_sec; ?> ul.droppable").sortable({
            connectWith: "ul.droppable",
            revert: true,
            helper:"clone",
            scrollSensitivity: 500,
            scrollSpeed: 30,
            appendTo: $("#<?= $lv_sec; ?> .Tlists"),
            over : function(event, ui){ $(this).addClass('ui-state-highlight'); },
            out : function(event, ui){ $(this).removeClass('ui-state-highlight'); },
            update: function(event, ui) {	
              if(this === ui.item.parent()[0]){
                var lv_confirmed = false;
                var lv_difsrc = ui.sender !== null && ui.sender !== undefined;
                var lv_stscls = $(event.target).parent().data("crmcntstscls");
                var lv_clsblc = $(event.target).parent().data("blc");
                if(lv_stscls == 1 && lv_difsrc){
                  BootstrapDialog.show({
                    title: "<?= $vew_lang->closecontact; ?>",
                    message: "Finalizar&aacute; el contacto una vez pase al estado " + $(event.target).parent().find("header span:first").text().toUpperCase() + ". &iquest;Desea proceder?",
                    type: BootstrapDialog.TYPE_WARNING,
                    closable: true,
                    onhidden: function(dialog) {
                        if (!lv_confirmed && ui.sender) {
                            ui.sender.sortable("cancel");
                        }
                    },
                    draggable: true,
                    size: BootstrapDialog.SIZE_NORMAL,
                    buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){
                                  dialogItself.close();
                                  if (ui.sender) {
                                      ui.sender.sortable("cancel");
                                  }
                                }
                              },
                              {	label: "<?= $vew_lang->yes; ?>", cssClass: "btn-warning",	action: function(confirmDialog){
                                  lv_confirmed = true;
                                  confirmDialog.close();
                									$(ui.item).toggleClass("ticketBlocked", lv_clsblc);
                                  <?= $lv_sec; ?>_updateTicket( event, ui );
                                }
                              }
                             ]
                  });
                } else {
                  <?= $lv_sec; ?>_updateTicket( event, ui ); 
                }
              }
            },
            start: function( event, ui ) { $(ui.helper).css("transform","rotate(3deg)"); },
            cancel: ".ticketBlocked"
          });
        });
      });
    };
		
		function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_refresh(); }
		
		function <?= $lv_sec; ?>_addColumn(lp_colfld, lp_colval, lp_coltxt, lp_colclr, lp_colcls=false, lp_colblc=false, lp_colblcexc){
      const lv_usrgrp = <?= json_encode($vew_data->usrgrp); ?>;
      var lv_blc = false;
      if(lp_colblc == true) {
        lv_blc = true;
        var lv_blcexclst = JSON.parse(lp_colblcexc || "[]");
        for(var row of lv_blcexclst){
          if(row.typ == "USR") lv_blc = row.val != "<?= $vew_sec->usrcod ?>"; 
          else if (row.typ == "ROL"){
            lv_usrgrp.forEach(function(row2){ lv_blc = row.val != row2.usrgrpcod;});
          }
          if(!lv_blc) break;
        };
      }
			var lv_qry = "#<?= $lv_sec; ?> .Tlist[data-"+lp_colfld+"="+lp_colval+"]";
			try { var $element = $(lv_qry); } catch(error) { return false; }
			if( $("#<?= $lv_sec; ?> .Tlist[data-"+lp_colfld+"="+lp_colval+"]").length==0 ){
				lv_col = "<div class='Tlist' data-"+lp_colfld+"='"+lp_colval+"' data-crmcntstscls='"+lp_colcls+"'data-blc='"+lv_blc+"'style='border-top: "+(lp_colclr==""?"transparent":"var("+lp_colclr+")")+" 4px solid;'>"
									+"<header style='display:flex;justify-content: space-between;'><span style='white-space:nowrap;overflow:hidden;'>"+(lp_colval=="0"?"(Sin Asignar)":(lp_coltxt==null?"("+lp_colval+")":lp_coltxt)).toLowerCase()+"</span>"
									+"<span class='badge pull-right' style='background-color: transparent; border-radius: 5px; border: #a6a6a6 1px solid; color: #161616; font-weight: normal; margin-top:8px;'></span></header><ul class='droppable'></ul></div>";
				$(lv_col).appendTo( $("#<?= $lv_sec; ?> .Tlists") );
			} else {
				//muestro la columna
				var lv_col = $("#<?= $lv_sec; ?> .Tlist[data-"+lp_colfld+"="+lp_colval+"]");
        lv_col.removeClass("hidden");
        lv_col.data("blc", lv_blc);
        lv_col.data("crmcntstscls" , lp_colcls);
			}
			return true;
		}
		
		
		 function <?= $lv_sec; ?>_updateTicket( event, ui ){			
			var lv_sort = "";
			var lv_crmcntcod = $(ui.item).prop("id");
			<?php if($vew_data->vew=='sts'){ ?>
				var lv_crmcntstscod_src = $(ui.sender).parent().data("crmcntstscod");
				var lv_crmcntstscod_dst = $(event.target).parent().data("crmcntstscod");
				var lv_crmcntusrcod_src = $(ui.item).data("usrcod");
				var lv_crmcntusrcod_dst = $(ui.item).data("usrcod");
				var lv_sysdocclscod = $(ui.item).data("sysdocclscod");
				//if( $(ui.item).prev().data("crmcntkanstsord")+1 != $(ui.item).data("crmcntkanstsord") ) {
        lv_sort = JSON.stringify($(event.target).sortable("toArray", {attribute: "id"}));
      	//}
			<?php } else if($vew_data->vew=='usr') { ?>
				var lv_crmcntstscod_src = $(ui.item).data("crmcntstscod");
				var lv_crmcntstscod_dst = $(ui.item).data("crmcntstscod");
				var lv_sysdocclscod = $(ui.item).data("sysdocclscod");
				var lv_crmcntusrcod_src = $(ui.sender).parent().data("usrcod");
				var lv_crmcntusrcod_dst = $(event.target).parent().data("usrcod")!="0"?$(event.target).parent().data("usrcod"):"";
				//if( $(ui.item).prev().data("cmrcntkanusrord")+1 != $(ui.item).data("crmcntkanusrord") ) {
        lv_sort = JSON.stringify($(event.target).sortable("toArray", {attribute: "id"}));
      	//}
			<?php } ?>
			if(lv_crmcntstscod_src!=lv_crmcntstscod_dst || lv_crmcntusrcod_src!=lv_crmcntusrcod_dst || lv_sort!="" ){
				var lv_dat=[{name:"crmcntcod",value:lv_crmcntcod},
										{name:"crmcntstscod",value:lv_crmcntstscod_dst},
										{name:"crmcntststxt",value:$(event.target).parent().find("header span:first").text() },
										{name:"usrcod",value:lv_crmcntusrcod_dst},
										{name:"sysdocclscod",value:lv_sysdocclscod},
                    {name:"crmcntupd",value:(ui.sender !== null)}
									 ];
				if(lv_sort!=""){ lv_dat.push({name:"<?= ($vew_data->vew=='usr'?'crmcntkanusrord':'crmcntkanstsord'); ?>",value:lv_sort}); }
        tmssCallProcessNoBackdropErr("?prg=crmcnt&act=16",lv_dat,function(data){
              $(ui.item).data("crmcntstscod",lv_crmcntstscod_dst);
              $("#<?= $lv_sec; ?> .Tlist[data-crmcntstscod="+lv_crmcntstscod_src+"] header span:last").text( $("#<?= $lv_sec; ?> .Tlist[data-crmcntstscod="+lv_crmcntstscod_src+"] .tmssDraggable").length );
              $("#<?= $lv_sec; ?> .Tlist[data-crmcntstscod="+lv_crmcntstscod_dst+"] header span:last").text( $("#<?= $lv_sec; ?> .Tlist[data-crmcntstscod="+lv_crmcntstscod_dst+"] .tmssDraggable").length );
              $(ui.item).data("usrcod",lv_crmcntusrcod_dst);
              $("#<?= $lv_sec; ?> .Tlist[data-crmcntusrcod="+(lv_crmcntusrcod_src!=""?lv_crmcntusrcod_src:0)+"] header span:last").text( $("#<?= $lv_sec; ?> .Tlist[data-crmcntusrcod="+(lv_crmcntusrcod_src!=""?lv_crmcntusrcod_src:0)+"] .tmssDraggable").length );
              $("#<?= $lv_sec; ?> .Tlist[data-crmcntusrcod="+(lv_crmcntusrcod_dst!=""?lv_crmcntusrcod_dst:0)+"] header span:last").text( $("#<?= $lv_sec; ?> .Tlist[data-crmcntusrcod="+(lv_crmcntusrcod_dst!=""?lv_crmcntusrcod_dst:0)+"] .tmssDraggable").length );
          		return true;
            },function(data){
              toastr.warning(data.errcod+": "+data.errtxt);
              ui.sender.sortable("cancel");
              return false;
            });
			}
		}
		
		
		$(function(){
			<?php
				// pra la vista de estado se muestran todos los estados disponibles
				if($vew_data->vew=='sts'){
					foreach( $vew_data->sts as $lv_row){
						echo $lv_sec.'_addColumn("crmcntstscod","'.$lv_row['crmcntstscod'].'","'.$lv_row['crmcntststxt'].'","'.$vew_doc->getTagValue($lv_row['crmcntstsatr'],'clr').'","'
              					.$lv_row['crmcntstscls'].'","'.$lv_row['crmcntstsblc'].'",'.json_encode($lv_row['crmcntstsblcexc']).');';
					}
				}
			?>
		});
	</script>
	<script>
		// FILTRO PERSONALIZADO
		var lv_<?= $lv_sec; ?>_grdfltcod = "<?= $vew_data->vewfltcod; ?>";
		var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->id; ?>','fldcod': 'c.crmcntcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->customer; ?>', 'fldcod': 'a.adrnme001', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->title; ?>','fldcod': 'c.crmcnttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->type; ?>','fldcod': 't.crmcnttyptxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->motive; ?>' ,'fldcod': 'm.crmcntmtvtxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->status; ?>' ,'fldcod': 's.crmcntststxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->responsible; ?>' ,'fldcod': 'c.usrcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->priority; ?>' ,'fldcod': 'p.crmcntprttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltcrm, "CRM_CNT_KAN", lv_<?= $lv_sec; ?>_grdfltcod, "<?= $lv_sec; ?>" );
		});
		
		//Filtros
		function <?= $lv_sec; ?>_fltcrm(lp_flt) {
			var lv_fltint;
			if( $("#<?= $lv_sec; ?> #btnflt .badge").length==0 ){
				$("<span class='badge'></span>").appendTo( $("#<?= $lv_sec; ?> #btnflt") );
			}
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #btnflt .badge").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint));
				<?= $lv_sec; ?>_refresh();
			}
		}

		$(function(){ 
			gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , $("#<?= $lv_sec; ?> #vewfltdef").val() );
			<?= $lv_sec; ?>_fltcrm( gv_<?= $lv_sec; ?>_flt );
			lv_fltint = tmssFilterParseToInternal( gv_<?= $lv_sec; ?>_flt );
			if( lv_fltint["fltqty"]==0 ){ <?= $lv_sec; ?>_refresh(); }
		});
	</script>
</section>