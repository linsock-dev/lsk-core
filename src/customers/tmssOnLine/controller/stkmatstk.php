<?php 
final class stkmatstkController extends tmssController {
	const MODEL = 'stkmatstk';
	const VIEW  = 'stkmatstk';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	private $data_list = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
    $lo_stkmovdocmdl = $this->co_reg->load->model('stkmovdoc' );
		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

			// BAJO MINIMO
      case '#15':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['srcmtd'] = 'underMinimum';
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

			// BAJO RESERVA
      case '#16':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['srcmtd'] = 'underReserve';
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
				
			// VALORIZADO
      case '#17':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['srcmtd'] = 'stockValorized';
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			// REAPROVISIONAMIENTO
      case '#18':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['srcmtd'] = 'stockReplenishment';
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			// DETERMINACION DE LOTES
			case '#25':
				$lo_dat = $this->co_reg->request->post;
				$lo_matmdl = $this->co_reg->load->model('stkmat');
        
        $lv_fdet='';
        switch( strtoupper($lo_dat['matbchdet']) ){
          case 'FEFO': $lv_fdet=', mb.matbchduedte, s.ctedte'; break;
          case 'LEFO': $lv_fdet=', mb.matbchduedte DESC, s.ctedte'; break;
          case 'FIFO': $lv_fdet=', s.ctedte'; break;
					case 'LIFO': $lv_fdet=', s.ctedte DESC'; break;
        }
				// obtengo todo el stock de los materiales sujeto a lote
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.stkobjtyp'.chr(9).'='.chr(9).chr(9).$lo_dat['srcobjtyp'].chr(9).chr(9).
																		'[~fltrow~]s.stkobjcod'.chr(9).'='.chr(9).chr(9).$lo_dat['srcobjcod'].chr(9).chr(9).
																		(intval($lo_dat['srccntcod'])>0?'[~fltrow~]s.stkcntcod'.chr(9).'='.chr(9).chr(9).$lo_dat['srccntcod'].chr(9).chr(9):'').
																		'[~fltrow~]s.matqty'.chr(9).'>'.chr(9).chr(9).'0'.chr(9).chr(9).
																		'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		'[~fltrow~]m.matusebch'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9),
												'vewfldord'=>'m.matcod'.$lv_fdet
				);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );

        //recuperar reservas
        $lo_dat['sysdocclscod']=73;
        $lo_rsv = $lo_stkmovdocmdl->availabilityCheck( $this->serializeDocData($lo_dat) );

        //corte de control de reservas con lote especificado
        foreach($lo_rsv as $lv_row){
          if($lv_row['stkmovdoccod']==null || $lv_row['matbchcod']==0)continue;
          foreach($lo_rs as &$lv_stock){
            if( $lv_row['matbchcod']==$lv_stock['matbchcod']){
    					$lv_stock['matqty']=$lv_stock['matqty']-$lv_row['matqty'];
          	}
          }
        }
        //corte de control de reservas sin lote especificado
         foreach($lo_rs as &$lv_stock){
          foreach($lo_rsv as &$lv_row){
            if($lv_row['stkmovdoccod']==null || $lv_row['matbchcod']!=0)continue;
            if( $lv_row['matqty']<$lv_stock['matqty']){
    					$lv_stock['matqty']=$lv_stock['matqty']-$lv_row['matqty'];
              $lv_row['matqty']=0;
          	}
          }
        }
        // recorro el array y realizo la determinación de lotes
				$lv_buffer = $this->co_reg->request->post['stkmovdocmat'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lo_movdocmat = json_decode($lv_buffer,true);
					for($i=0; $i<count($lo_movdocmat); $i++) {
						$lv_rejcod = (isset($lo_movdocmat[$i]['sysdocrejcod'])?$lo_movdocmat[$i]['sysdocrejcod']:'0');
						if( $lv_rejcod=='0' || $lv_rejcod=='' ) {
							// si el lote está vacío, tiene cantidad > 0
							$lo_movdocmat[$i]['matbchcodext'] = (isset($lo_movdocmat[$i]['matbchcodext'])?$lo_movdocmat[$i]['matbchcodext']:'');
							if ( $lo_movdocmat[$i]['matbchcodext']=='' && isset($lo_movdocmat[$i]['matcod']) ) {
								
								// Si material está sujeto a lote
								$lo_matmdl->load( array('matcod'=>$lo_movdocmat[$i]['matcod']), false );
								if ($lo_matmdl->matusebch=='1') {
									
									if ( ($lo_movdocmat[$i]['matbchcodext']=='' || (isset($lo_movdocmat[$i]['matbchdeterrcod'])?$lo_movdocmat[$i]['matbchdeterrcod']:'')!='' )
												&& $lo_movdocmat[$i]['matqty']>0 ) {
										
										// busco si el lote tiene stock
										$lv_matbchdeterrtxt = 'Stock insuficiente.';
										$lv_matbchdeterrcod = 'E';
										for($x=0; $x<count($lo_rs); $x++){
											if ( $lo_movdocmat[$i]['matcod']==$lo_rs[$x]['matcod'] && $lo_rs[$x]['matqty']>0 ) {
												// stock suficiente del lote
                        if ( $lo_movdocmat[$i]['matqty']<=$lo_rs[$x]['matqty'] ) {
													$lo_movdocmat[$i]['matbchcod'] = $lo_rs[$x]['matbchcod'];
													$lo_movdocmat[$i]['matbchcodext'] = $lo_rs[$x]['matbchcodext'];
													$lo_movdocmat[$i]['matbchduedte'] = date_format($lo_rs[$x]['matbchduedte'],'d/m/Y');
													$lo_rs[$x]['matqty'] = $lo_rs[$x]['matqty'] - $lo_movdocmat[$i]['matqty'];
													$lv_matbchdeterrtxt = '';
													$lv_matbchdeterrcod = 'I';
													break;
												// stock insuficiente, se permite SPLIT de lote?
												} else if(strtoupper($lo_dat['matbchdetspl'])=='X') {
                          //nueva cantidad
													$lv_newqty = $lo_movdocmat[$i]['matqty'] - $lo_rs[$x]['matqty'];
                          
                          //si hay un campo de cantidad requerida lo borro
                          if( isset($lo_movdocmat[$i]['matqtypck']) ){ $lo_movdocmat[$i]['matqtypck'] = 0; }
                          
                          // agrego nueva linea por el saldo sin asignar
													array_splice( $lo_movdocmat, $i+1, 0, array($lo_movdocmat[$i]) );
                          
                          //si hay un camopo de id de material de elaboracion lo borro
                          if( isset($lo_movdocmat[$i+1]['stkmovelbmatcod']) ){ $lo_movdocmat[$i+1]['stkmovelbmatcod'] = 0; }
                          
                          //asigna la nueva cantidad
													$lo_movdocmat[$i+1]['matqty'] = $lv_newqty;
													// asigno el lote actual
													$lo_movdocmat[$i]['matqty'] = $lo_rs[$x]['matqty'];
													$lo_movdocmat[$i]['matbchcod'] = $lo_rs[$x]['matbchcod'];
													$lo_movdocmat[$i]['matbchcodext'] = $lo_rs[$x]['matbchcodext'];
													$lo_movdocmat[$i]['matbchduedte'] = date_format($lo_rs[$x]['matbchduedte'],'d/m/Y');
													$lo_movdocmat[$i]['stkmovdocmatcod'] = '';
													$lo_rs[$x]['matqty'] = 0;
													$lv_matbchdeterrtxt = '';
													$lv_matbchdeterrcod = 'I';
													break;
												} else {
													$lv_matbchdeterrtxt .= ' No se permite split de lotes.';
													$lv_matbchdeterrcod = 'E';
													break;								
												}
											}
										}
										$lo_movdocmat[$i]['matbchdeterrtxt'] = $lv_matbchdeterrtxt;
										$lo_movdocmat[$i]['matbchdeterrcod'] = $lv_matbchdeterrcod;
									}
								} else {
									$lo_movdocmat[$i]['matbchdeterrcod'] = '';
									$lo_movdocmat[$i]['matbchdeterrtxt'] = '';
								}
							}
						}
					}
					
					$lv_ret = json_encode($lo_movdocmat);
					return $lv_ret;
				}
				break;
      
      //GETLIST by TEXT.
      case '#28':case '#27':
        $lo_post = $this->co_reg->request->post;
        $lo_matstkmdl = $this->co_reg->load->model('stkmatstk');

        $lv_sysdocclscod = isset($lo_post['sysdocclscod']) ? $lo_post['sysdocclscod'] : ($lp_prm['sysdocclscod'] ?? '');
        $lv_stkobjtyp	 = isset($lo_post['stkobjtyp']) ? $lo_post['stkobjtyp'] : ($lp_prm['stkobjtyp'] ?? '');
        $lv_stkobjcod	 = isset($lo_post['stkobjcod']) ? $lo_post['stkobjcod'] : ($lp_prm['stkobjcod'] ?? '');
        $lv_stkcntcod	 = isset($lo_post['stkcntcod']) ? $lo_post['stkcntcod'] : ($lp_prm['stkcntcod'] ?? '');

        $lv_prm = array('vewmaxrec' =>'10',
                        'vewfldflt' =>(isset($lp_prm['mattxt']) 	 	 ?'[~fltrow~]m.mattxt'.chr(9).''.chr(9).($lp_prm['mattxt']).chr(9).chr(9).chr(9):'').
                                      (isset($lp_prm['matcodext']) 	 ?'[~fltrow~]m.matcodext'.chr(9).'='.chr(9).chr(9).$lp_prm['matcodext'].chr(9).chr(9):'').
                                      (isset($lp_prm['matusebch']) 	 ?'[~fltrow~]m.matusebch'.chr(9).'='.chr(9).chr(9).$lp_prm['matusebch'].chr(9).chr(9):'').
                        							(isset($lp_prm['matuseser']) 	 ?'[~fltrow~]m.matuseser'.chr(9).'='.chr(9).chr(9).$lp_prm['matuseser'].chr(9).chr(9):'').
                        							(!empty($lv_stkobjtyp)			 	 ?'[~fltrow~]s.stkobjtyp'.chr(9).'='.chr(9).chr(9).$lv_stkobjtyp.chr(9).chr(9):'').
                        							(!empty($lv_stkobjcod)			 	 ?'[~fltrow~]s.stkobjcod'.chr(9).'='.chr(9).chr(9).$lv_stkobjcod.chr(9).chr(9):'').
                        							('[~fltrow~]s.stkcntcod'.chr(9).'='.chr(9).chr(9).$lv_stkcntcod.chr(9).chr(9)).
                                      (!empty($lv_sysdocclscod)			 ?'[~fltrow~]m.sysdocclscod'.chr(9).(strpos($lv_sysdocclscod, ';') ? 'IN': '=').chr(9).chr(9).str_replace(';', chr(10), $lv_sysdocclscod).chr(9).chr(9):'').
                                      '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );

        $lo_data = $lo_matstkmdl->getList( $lv_prm );
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
        break;
				
      // CONSULTA STOCK. devuelve el stock de un material/lote
			// FALTA: agregar consulta x nro de serie
			case '#29':
				$lo_post = $this->co_reg->request->post;
        $lo_matstkmdl = $this->co_reg->load->model('stkmatstk');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]s.stkobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
                                      '[~fltrow~]s.stkobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
                                      '[~fltrow~]s.matcod'.chr(9).'='.chr(9).chr(9).$lo_post['matcod'].chr(9).chr(9).
                                      '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                      '[~fltrow~](case when m.matusebch=0 and mb.matbchcodext=^^ then 1 when m.matusebch=1 and mb.matbchcodext=^'.$lo_post['matbchcodext'].'^ then 1 else 0 end)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9)
                      );
        $lo_rsstk = $lo_matstkmdl->getList( $lv_prm );
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','matstkqty'=>(count($lo_rsstk)>0?$lo_rsstk[0]['matqty']:0) ));
        break;
        
        
			// VERIFICACION DE DISPONIBILIDAD
      // dado un JSON con matcod,matbchcodext y/o matsercodext, verifica la existencia de stocks
      // todos los materiales son agrupados por los distintos codigos
			case '#30':
        // NORMALIZACION. realizo acumulacion de cantidades por material/lote/nro serie
        $lv_matarr = array();
        $lv_matlst = '';
        $lo_post = $this->co_reg->request->post;
        $lv_matchk = json_decode( html_entity_decode($lo_post['matarr']), true );
        foreach($lv_matchk as $lv_row){
          if( count($lv_row)>0 ) {
            $lv_key = $lv_row['matcod'].'_'.(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:'').'_'.(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:'');
            if( isset($lv_matarr[$lv_key]) ){
              $lv_matarr[$lv_key]['matqty']+=$lv_row['matqtypck']??$lv_row['matqtytot'];
            } else {
              //se cambio matqty por matqtytot
              $lv_matarr[$lv_key] = array('matcod'=>$lv_row['matcod'],'mattxt'=>$lv_row['mattxt'],'matusebch'=>(isset($lv_row['matusebch'])?$lv_row['matusebch']:''),'matuseser'=>(isset($lv_row['matuseser'])?$lv_row['matuseser']:''),'matbchcodext'=>(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:''),'matsercodext'=>(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:''),'matqty'=>$lv_row['matqtytot'],'matuntcod'=>$lv_row['matuntcod'],'row'=>$lv_row['row'] );
            }
            if(stripos(chr(10).$lv_matlst.chr(10), chr(10).$lv_row['matcod'].chr(10))===false){
							$lv_matlst.=($lv_matlst==''?'':chr(10)).$lv_row['matcod'];
						}
          }
        }
        
				// STOCK. obtengo todo el stock de los materiales sujeto a lote
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.stkobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
																		'[~fltrow~]s.stkobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																		(intval($lo_post['srccntcod'])>0?'[~fltrow~]s.stkcntcod'.chr(9).'='.chr(9).chr(9).$lo_post['srccntcod'].chr(9).chr(9):'').
																		'[~fltrow~]s.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_matlst.chr(9).chr(9).
																		'[~fltrow~]s.matqty'.chr(9).'>'.chr(9).chr(9).'0'.chr(9).chr(9).
																		'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord'=>'m.matcod' );
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
				
        // VERIFICACION. realizo verificación de disponibilidad
        $lo_ret = array();
        foreach($lv_matarr as $lv_key=>$lv_row){
					$lv_qty = 0;
					$lv_unt = '';
					$lo_add = array('matcod'=>$lv_row['matcod'],'mattxt'=>$lv_row['mattxt'],'matbchcodext'=>$lv_row['matbchcodext'],'matsercodext'=>$lv_row['matsercodext'],'matqty'=>$lv_row['matqty'],'matuntcod'=>$lv_row['matuntcod'],'row'=>$lv_row['row'],'errtyp'=>'S','errcod'=>0,'errtxt'=>'');

					// materiales sujetos a lote/serie que no indican lote o serie o materiales no sujeto
					if( ($lv_row['matusebch']=='1' && $lv_row['matbchcodext']=='') ||
							($lv_row['matuseser']=='1' && $lv_row['matsercodext']=='') ||
							($lv_row['matusebch']=='' && $lv_row['matuseser']=='') ){
							
							foreach($lo_rs as $lv_rowstk){
								if($lv_rowstk['matcod']==$lv_row['matcod']){
									$lv_unt=$lv_rowstk['matuntcod'];
									$lv_qty+=$lv_rowstk['matqty'];
								}
							}

					// materiales sujeto a lote y/o serie
					} else {
							foreach($lo_rs as $lv_rowstk){
								if($lv_rowstk['matcod'].'_'.$lv_rowstk['matbchcodext'].'_'.$lv_rowstk['matsercodext']==$lv_key){
									$lv_unt=$lv_rowstk['matuntcod'];
									$lv_qty+=$lv_rowstk['matqty'];
									break;
								}
							}
					}
					if( $lv_qty<$lv_row['matqty'] && $lv_row['matbchcodext']=='' ){
						$lo_add['errtyp']='E';
						$lo_add['errcod']=-1;
						$lo_add['errtxt']='Solo hay <b>'.$lv_qty.' '.($lv_unt==''?$lv_row['matuntcod']:$lv_unt).'</b> disponibles para Material '.$lv_row['matcod'].($lv_row['matbchcodext']==''?'':' / Lote '.$lv_row['matbchcodext']).($lv_row['matsercodext']==''?'':' / Serie '.$lv_row['matsercodext']).'.';
						$lo_add['matqtystk'] = $lv_qty;
            //$lo_add['matqtystk'] = $lv_qty;
					} else {
						$lo_add['matqtystk'] = $lv_qty;
					}
          $lo_ret[] = $lo_add;
				}
        return json_encode($lo_ret);
				break;
		}
	}	
  
  
  // SERIALIZACION. Serializo parametros para control de disponibilidad y grabado de documento
  private function serializeDocData( $lp_data = array() ) {
    // Preparo info de lista de materiales y documento de cabecera
    $lv_movdocmat_str = '';
    if ( (isset($lp_data['stkmovdocmat'])?$lp_data['stkmovdocmat']:'')!='' ) {
      $lv_buffer = $lp_data['stkmovdocmat'];
      $lv_buffer = html_entity_decode($lv_buffer);
      $lv_movdocmat_arr = json_decode($lv_buffer,true);

      foreach($lv_movdocmat_arr as $lv_row){
        if(empty($lv_row)){break;}
        if( !isset($lv_row['deleted']) ){
          $lv_movdocmat_str .= ( $lv_row != '' ? chr(9) : '').'<matcod>'.$lv_row['matcod'].'</matcod>'.
                                                              '<matqty>'.$lv_row['matqty'].'</matqty>'.
                                                              '<matuntcod>'.$lv_row['matuntcod'].'</matuntcod>'.
                                                              '<matbchcod>'.(isset($lv_row['matbchcod'])?$lv_row['matbchcod']:0).'</matbchcod>'.
            																									'<matbchcodext>'.(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:'').'</matbchcodext>'.
                                                              '<matsercod>'.(isset($lv_row['matsercod'])?$lv_row['matsercod']:0).'</matsercod>'.
            																									'<matsercodext>'.(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:'').'</matsercodext>';  
        } 
      }         
    	$lp_data['stkmovdocmat'] = $lv_movdocmat_str;
    }
    
    // informacion de movimiento
    $lp_data['stkmovdoc'] = '<sysdocclscod>'.$lp_data['sysdocclscod'].'</sysdocclscod>'.
                            '<srcobjtyp>'.(isset($lp_data['srcobjtyp'])?$lp_data['srcobjtyp']:'').'</srcobjtyp>'.
                            '<srcobjcod>'.(isset($lp_data['srcobjcod'])?$lp_data['srcobjcod']:'').'</srcobjcod>'.
                            '<srccntcod>'.(isset($lp_data['srccntcod'])?$lp_data['srccntcod']:'').'</srccntcod>';   
    
    return $lp_data;
  }
}
?>