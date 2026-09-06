<?php
final class grldatmsgController extends tmssController {
	const MODEL = 'grldatmsg';
	const VIEW  = 'grldatmsg';
	const ID = 'msgcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
    
  
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			// *******************************************************************
			/*
      // ------------------------------------------------------------------------------------
      // CODIGO DE REFERENCIA - NO BORRAR
      // PARA CONTINUAR CON TICKET #1785 - GENERAL: NUEVA OPCION DESCARGAR Y ENVIAR MENSAJES
      // ------------------------------------------------------------------------------------
      // SEND / DOWNLOAD
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				if($lo_post['typ']=='dwn'){
					// Preparo el pdf
					$lo_file = @tempnam('tmp', 'zip');
					$lo_zip = new ZipArchive();
					$lo_zip->open($lo_file, ZipArchive::OVERWRITE);
				} else if ( $lo_post['typ']=='snd' ){
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lo_post['to'];
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ); 
					$lv_emlprm['subject'] = $lo_post['subject'];
					$lv_emlprm['bodyhtml'] = $lo_post['bodyhtml'];
				}
				
				foreach( ..... ){
					if ( $this->lo_mdl->save( $lo_post )==false ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
					} else if( $lo_post['msgtyp']=='pdf' ){
						$lv_dat = $this->co_reg->document->getCallComponents( $lo_post['msgfrm'] );
						if( $lv_dat['prg']=='' || $lv_dat['act']=='' ){ 
							return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Configuracion de mensaje incorrecto.') );
						} else {
							$lo_ctr = $this->co_reg->load->controller( $lv_dat['prg'] );
							$lv_buffer = $lo_ctr->index( $lv_dat['act'] , $lv_dat['prm'] );
							// valida respuesta (php <8.3)
							$lv_ret = json_decode($lv_buffer);
							if( json_last_error() === JSON_ERROR_NONE ){
								$lv_ret['msgtyp'] = $lo_post['msgtyp'];
								$lv_ret['msgfrm'] = $lo_post['msgfrm'];
								return $this->co_reg->document->getJson( $lv_ret );
							} else {
								if( $lo_post['typ']=='dwn' ){
									//***********************
									$lo_zip->addFromString($lv_tmprow->hhrlqddte->format('Y-m'). ' - '. $lv_srcobjtxt. ' - '. $lv_tmprow->hhrchrasgcod.'.pdf', $lv_buffer);								
								} else if ($lo_post['typ']=='snd'){
									//***********************
									$contact_image_data="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA";
									$data = substr($contact_image_data, strpos($contact_image_data, ","));
									$filename="test.png"; 
									$encoding = "base64"; 
									$type = "image/png";
									$lo_eml->AddStringAttachment(base64_decode($data), $filename, $encoding, $type); 								
								}
								
							}
						}
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','msgtyp'=>$lo_post['msgtyp'],'msg'=>$lo_post['msgfrm']) );
					}
				}
				
				// Cerrar y devolver zip
				if($lo_post['typ']=='dwn'){
					$lo_zip->close();
					header('Content-Type: application/zip');
					header('Content-Disposition: attachment; filename="Recibos '.$lo_recmdl->getData()[0]['buscod'].' - '.$lo_recmdl->getData()[0]['hhrlqddte']->format('d.m.Y').'.zip"');
					readfile($lo_file);
					unlink($lo_file);
				// enviar mail
				} else if($lo_post['typ']=='snd') {
					if ( !$lo_eml2->send( $lv_emlprm2 ) ) {
            return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml2->getError()) );
          }
				}
        break;
      // ------------------------------------------------------------------------------------
			*/
        
        
      case '#00':
        $lo_post = $this->co_reg->request->post;
        $lv_buffer = $this->co_reg->request->post['grldatmsgarr'];
        if ($lv_buffer != '') {
          $lv_buffer = html_entity_decode($lv_buffer);
          $lv_docmsg_arr = json_decode($lv_buffer, true);
          foreach ($lv_docmsg_arr as $lv_row) {
            if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
						}
          }
        } else {
          return $this->co_reg->document->getJson(array('errtyp' => $this->lo_mdl->errtyp, 'errcod' => $this->lo_mdl->errcod, 'errtxt' => $this->lo_mdl->errtxt));
        }
        break;
        
			// GRILLA DE MENSAJES. devuelve la vista de mensajes de una clase de documento
			case '#06':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo los posibles mensajes para la clase de documento
				$lo_clsmsgmdl = $this->co_reg->load->model('sysdocclsmsg');
				$lv_prm = array('vewfldflt'=> '[~fltrow~]dcm.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																			'[~fltrow~]dm.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9).
																			'[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9).
																			'[~fltrow~]dcm.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
																			);
				$lo_rs = $lo_clsmsgmdl->getList( $lv_prm );
				$this->lo_mdl->msglst = $lo_rs;
        
				// obtengo mensajes ya emitidos para el documento
				$lo_msglstmdl = $this->co_reg->load->model('grldatmsg');
        
				$lv_prm = array('vewfldflt' => '[~fltrow~]m.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
																			 '[~fltrow~]m.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																			 ($lo_post['srcobjcod002']!=''?'[~fltrow~]m.srcobjcod002'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod002'].chr(9).chr(9):'')
												);
				$lo_rs = $lo_msglstmdl->getList( $lv_prm );
				$this->lo_mdl->docmsg = $lo_rs;

				// prepara los datos y devuelve la vista
				$this->lo_mdl->sysdocclscod = $lo_post['sysdocclscod'];
				$this->lo_mdl->srcobjtyp = $lo_post['srcobjtyp']??'';
				$this->lo_mdl->srcobjcod = $lo_post['srcobjcod']??'';
				$this->lo_mdl->srcobjcod002 = $lo_post['srcobjcod002']??'';
        $this->lo_mdl->vew_sec = $lo_post['lv_sec'];
				return $this->co_reg->document->getView( 'grldatmsggrd' , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
      
      // IMPRIMIR. realiza la impresión/ejecución de un mensaje.  
      case '#07':
				$lo_post = $this->co_reg->request->post;
				
				// primero registra el evento
        if ( $this->lo_mdl->save( $lo_post )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
        
        // guarda el id del mensaje en el post
        $lo_post['msgnum'] = $this->lo_mdl->msgnum;
        
				// luego procesa el mensaje y crea el log
				if( $lo_post['msgtyp']=='pdf' ){
					$lv_dat = $this->co_reg->document->getCallComponents( $lo_post['msgfrm'] );
          if( $lv_dat['prg']=='' || $lv_dat['act']=='' ){
            // registra el error en el log
            $lo_post['errobj'] = json_encode( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Configuracion de mensaje incorrecto.') );
            $this->lo_mdl->save( $lo_post );
            return $this->co_reg->document->getJson( $lo_post['errobj'] );
          } else {
            // recupera el buffer del documento
            $lo_ctr = $this->co_reg->load->controller( $lv_dat['prg'] );
            //var_dump($lv_dat['prg'].$lv_dat['act'].$lv_dat['prm']);
            $lv_buffer = $lo_ctr->index( $lv_dat['act'] , $lv_dat['prm'] );
            // valida respuesta (php <8.3)
            $lv_ret = json_decode($lv_buffer,true);
            $lo_post['msgatr'] = '<mdlcod>'.$lv_dat['prg'].'</mdlcod><prgcod>'.$lv_dat['act'].'</prgcod>';
            if( json_last_error() === JSON_ERROR_NONE ){
              // si no hay error con el JSON llamo al save para registrar un nuevo log y luego devuelvo el JSON a la vista
              $lo_post['errobj'] = json_encode( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
              $this->lo_mdl->save( $lo_post );
              $lv_ret['msgtyp'] = $lo_post['msgtyp']??'';
              $lv_ret['msgfrm'] = $lo_post['msgfrm']??'';
              return $this->co_reg->document->getJson( $lv_ret );
            } else {
              // si hay error con el JSON llamo al save para registrar un nuevo log (con el error incluido) y luego devuelvo el buffer a la vista
              $lo_post['errobj'] =  json_encode( array('errtyp'=>'E','errcod'=>-2,'errtxt'=>'Error al convertir el buffer a JSON.') );
              $this->lo_mdl->save( $lo_post );
              return $lv_buffer;
            }
          }
        }
        break;
        
        
      // IMPRIMIR - GESTOR. realiza la impresión/ejecución de uno o más mensajes desde el gestor.
      case '#17':
      	$lo_post = $this->co_reg->request->post;

        $lo_msgarr = json_decode(html_entity_decode($lo_post['grldatmsg'], ENT_QUOTES) ?? '[]', true);

        if ($lo_msgarr != []) {
          // Generar ZIP temporal
          $lv_zipnme = "Mensajes_" . time() . ".zip";
          $lv_zippth = tempnam(sys_get_temp_dir(), 'zip_'); // archivo temporal

          $lv_zip = new \ZipArchive();
          if ($lv_zip->open($lv_zippth, \ZipArchive::CREATE | \ZipArchive::OVERWRITE) !== TRUE) {
            return $this->co_reg->document->getJson( ['errtyp'=>'E','errcod'=>-11,'errtxt'=>'No se pudo crear el ZIP'] );
          }

          foreach ($lo_msgarr as &$lv_msgrow) {
            try {
              // primero registra el evento
            	if ($this->lo_mdl->save($lv_msgrow) == false) {
                $lv_msgrow['errobj'] = json_encode( ['errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt] );
                continue;
                //return $this->co_reg->document->getJson( ['errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt] );
            	}

              $lv_msgrow['msgnum'] = $this->lo_mdl->msgnum;

              if ($lv_msgrow['msgtyp'] == 'pdf') {
                $lv_dat = $this->co_reg->document->getCallComponents($lv_msgrow['msgfrm']);
                if ($lv_dat['prg'] == '' || $lv_dat['act'] == '') {
                  $lv_msgrow['errobj'] = json_encode(['errtyp'=>'E','errcod'=>-1,'errtxt'=>'Configuración de mensaje incorrecta.']);
                  $this->lo_mdl->save($lv_msgrow);
                  //return $this->co_reg->document->getJson($lv_msgrow['errobj']);
                  continue;
                }

                // Cargar controlador y capturar output (por si el controller hace echo en vez de return)
                $lo_ctr = $this->co_reg->load->controller($lv_dat['prg']);
                $lv_buffer = $lo_ctr->index($lv_dat['act'], $lv_dat['prm']);

                if (!is_string($lv_buffer) || $lv_buffer=='') {
                  $lv_msgrow['errobj'] = json_encode(['errtyp'=>'E','errcod'=>-2,'errtxt'=>'Buffer del documento vacío o inválido.']);
                  $this->lo_mdl->save($lv_msgrow);
                  continue;
                }

                $lv_msgrow['msgatr'] = '<mdlcod>'.$lv_dat['prg'].'</mdlcod><prgcod>'.$lv_dat['act'].'</prgcod>';
                $lv_msgrow['errobj'] = json_encode(['errtyp'=>'S','errcod'=>0,'errtxt'=>'']);
                $this->lo_mdl->save($lv_msgrow);
								
                if ( $lv_msgrow['errobj'] && json_decode($lv_msgrow['errobj'], true)['errtyp'] !== 'E' ) {
                  $lv_zip->addFromString($lv_msgrow["srcobjcod"].".pdf", $lv_buffer);
                } else{
                  $lv_msgrow['errobj'] = json_encode( ['errtyp'=>'E','errcod'=>-3,'errtxt'=>'No se pudo agregar el contenido al ZIP.'] );
                  continue;
                }
              }
            }
            catch (\Throwable $e) { // atrapa Exception y Error (TypeError) y ErrorException
              // guardo error en DB (si no lo hicimos antes)
              $lv_msgrow['errobj'] = json_encode(['errtyp'=>'E','errcod'=>$e->getCode(),'errtxt'=>$e->getMessage()]);
              $this->lo_mdl->save($lv_msgrow);
              continue;
            }
          }

          // cerrar el zip después de cargar todos
          $lv_zip->close();

          // leer binario y pasarlo a base64
          $lv_zipbin = base64_encode(file_get_contents($lv_zippth));
          unlink($lv_zippth);

          return $this->co_reg->document->getJson( ['data'=>$lo_msgarr,'zipbin'=>['zipnme'=>$lv_zipnme, 'zipcnt'=>$lv_zipbin],'errtyp'=>'S','errcod'=>0,'errtxt'=>''] );
          } else {
            return $this->co_reg->document->getJson( ['errtyp'=>'E','errcod'=>-11,'errtxt'=>'No hay mensajes válidos para procesar'] );
          }
          break;
			
        
			// GETLIST. devuelve la lista de mensajes
			case '#18':
        $lo_post = $this->co_reg->request->post;
				// obtengo mensajes ya emitidos para el documento
				$lo_msglstmdl = $this->co_reg->load->model('grldatmsg');
        
				$lv_prm = array('vewfldflt' => '[~fltrow~]m.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
																			 '[~fltrow~]m.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																			 ($lo_post['srcobjcod002']!=''?'[~fltrow~]m.srcobjcod002'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod002'].chr(9).chr(9):'')
												);
				$lo_rs = $lo_msglstmdl->getList( $lv_prm );
        return $this->co_reg->document->getJson($lo_rs);
        break;
        
        
			// CENTRO DE MENSAJES
      case '#20':
				$lo_post = $this->co_reg->request->post;
			
				// cargo los tipos de mensaje del módulo
				$lo_docmsgmdl = $this->co_reg->load->model('sysdocmsg');
				$lv_prm = array('vewfldflt'=>(isset($lp_prm['mdlcod'])?'[~fltrow~]dm.objtypcod'.chr(9).''.chr(9).$lp_prm['mdlcod'].'_%'.chr(9).chr(9).chr(9):'').
																		 '[~fltrow~]dbo.getTagValue(^msgtyp^,dm.sysdocmsgatr)'.chr(9).'='.chr(9).chr(9). 'pdf' .chr(9).chr(9).
																		 '[~fltrow~]dm.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_rs = $lo_docmsgmdl->getList( $lv_prm );				
				$this->lo_mdl->docmsglst = $lo_rs;
        
        $this->lo_mdl->mdlcod=$lp_prm['mdlcod'];
				$this->lo_mdl->prgcod=$lp_prm['prgcod'];
        $this->lo_mdl->vewcod=$lp_prm['vewcod'];
        
				return $this->co_reg->document->getView( 'grldatmsg', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// CENTRO DE MENSAJES - BUSCAR. busca los mensajes emitidos o no para reprocesar
			case '#28':
				$lo_post = $this->co_reg->request->post;				
				// cargo los mensajes procesados/no procesados según los criterios de búsqueda
				$lo_docmsgmdl = $this->co_reg->load->model('grldatmsg');
        
        // formateo las fechas
        $lv_strdte = $this->co_reg->db->sqldate($lo_post['msgfndstrdte']);
				$lv_strdte = substr($lv_strdte,0,4).'-'.substr($lv_strdte,4,2).'-'.substr($lv_strdte,6,2);
				$lv_enddte = $this->co_reg->db->sqldate($lo_post['msgfndenddte']);
				$lv_enddte = substr($lv_enddte,0,4).'-'.substr($lv_enddte,4,2).'-'.substr($lv_enddte,6,2).' 23:59:59'; // le agrego la hora al final para que tenga en cuenta ese día
        
				// busco en mensajes procesados
				if( ($lo_post['msgfndexe']??'')=='1' ){
					$lv_prm = array('vewfldflt'=>(($lo_post['sysdocmsgcod']??'')!=''?'[~fltrow~]dm.sysdocmsgcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocmsgcod'].chr(9).chr(9):'').
																			 (($lo_post['srcobjcod']??'')!=''?'[~fltrow~]dm.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9):'').
																			 (($lo_post['msgatr']??'')!=''?'[~fltrow~]dm.msgatr'.chr(9).''.chr(9).$lo_post['msgatr'].chr(9).chr(9).chr(9):'').
                          						 '[~fltrow~]m.ctedte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9), // filtra por la fecha de emisión del mensaje
													'vewmaxrec'=>(($lo_post['vewmaxrec']??'')!=''?$lo_post['vewmaxrec']:'100'),
													'vewfldord'=>'l.applogcod desc'
													);
					$lo_rs = $lo_docmsgmdl->getList($lv_prm);
				// busco en mensajes pendiente de procesar
				} else {
          //Busco cual es el objtyp del mensaje pedido (Esto deberia obtenerse desde la vista probablemente antes de hacer un CallProcess pero la vista esta tomada).
          $lo_sysdocmsg = $this->co_reg->load->model('sysdocmsg');
          $lv_prm = array('vewfldflt'=>(($lo_post['sysdocmsgcod']??'')!=''?'[~fltrow~]dm.sysdocmsgcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocmsgcod'].chr(9).chr(9):''));
					
        	$lo_rs =  $lo_sysdocmsg->getList($lv_prm);
					$lo_post['srcobjcod'] = $lo_rs[0]['objtypcod'];
          
          // una vez recuperado el objtypcod, armo la lista de mensajes con dicho código
					$lv_prm = array('vewfldflt'=>(($lo_post['sysdocmsgcod']??'')!=''?'[~fltrow~]dcm.sysdocmsgcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocmsgcod'].chr(9).chr(9):'').
																			 (($lo_post['srcobjcod']??'')!=''?'[~fltrow~]dm.objtypcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9):'').
                          						 '[~fltrow~]st.ctedte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9), // como no hay mensaje ya procesado, filtra por la fecha de emisión de los documentos de origen
													'vewmaxrec'=>(($lo_post['vewmaxrec']??'')!=''?$lo_post['vewmaxrec']:'100'),
													'vewfldord'=>'st.ctedte desc'
													);
          
					$lo_rs = $lo_docmsgmdl->getMessageList( $lv_prm, array('srcobjtyp'=> $lo_post['srcobjcod']) );					
				}
				return $this->co_reg->document->getJson( $lo_rs );
				break;
      //MENSAJES DE REPORTE - OBTIENE, los mensajes de un reporte.
      case '#29':
        	$lo_post = $this->co_reg->request->post;
        	
        	$lo_docmsgmdl = $this->co_reg->load->model('grldatmsg');
        	$lv_prm = array('vewfldflt'=>(($lo_post['srcobjcod']??'')!=''?'[~fltrow~]m.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9):''),
													'vewmaxrec'=>(($lo_post['vewmaxrec']??'')!=''?$lo_post['vewmaxrec']:'100')
													);
					$lo_rs = $lo_docmsgmdl->getMessageList( $lv_prm, array('srcobjtyp'=> $lo_post['srcobjtyp']));
          return $this->co_reg->document->getJson( $lo_rs );
      break;       
		}
  }
}
?>