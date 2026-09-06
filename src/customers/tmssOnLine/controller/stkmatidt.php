<?php
final class stkmatidtController extends tmssController {
	const MODEL = 'stkmatidt';
	const VIEW  = 'stkmatidt';
	const ID = 'matidtcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  
  // INDEX. metod principal de la clase
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
			
			// SAVE
      case '#00':
        $lo_post = $this->co_reg->request->post;
				$this->data['matcod'] = $this->co_reg->request->post['matcod'];
				$lv_buffer = (isset($lo_post['matidt'])?$lo_post['matidt']:'');
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_matidt_arr = json_decode($lv_buffer,true);
					foreach( $lv_matidt_arr as $lv_row ) {
						$lv_row['matcod'] = $this->data['matcod'];
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
						}
					}
				}
				
				// lista de conversiones
				$lo_matidt_mdl = $this->co_reg->load->model('stkmatidt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$this->data['matcod'].chr(9).chr(9) );
				$lo_rs = $lo_matidt_mdl->getList( $lv_prm );
				$this->lo_mdl->matidtlst = $lo_rs;
				
				$this->lo_mdl->matcod = $this->data['matcod'];
				$this->data['actcod'] = '02';
				
		    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
      
      // CHANGE - DISPLAY. devuelve la vista en modo modificacion o visualizacion
      case '#02': case '#03':
				$lv_key = array();
        $lo_post = $this->co_reg->request->post;
				
				// get param (KEY)																																		
				if ( !isset($lo_post['matcod']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [matcod].') );
				}
        $this->data['matcod'] = $lo_post['matcod'];
				
				// definiciones de parámetros
				$lo_matidt_mdl = $this->co_reg->load->model('stkmatidt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$lo_post['matcod'].chr(9).chr(9) );
				$lo_rs = $lo_matidt_mdl->getList($lv_prm);
				$this->lo_mdl->matidtlst = $lo_rs;
				
				$this->lo_mdl->matcod = $this->data['matcod'];
		    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
        break;
				
				
			// CODIGOS DE BARRA
			case '#barcodread':
				$lo_post = $this->co_reg->request->post;
				$lo_ret = array('matcod'=>'','matcodext'=>'','mattxt'=>'','matuntcod'=>'','barcod'=>'',
												'matbchcod'=>'','matbchcodext'=>'','matbchduedte'=>'','matbchduedtecnv'=>'',
												'matsercod'=>'','matsercodext'=>'',
												'matidtcod'=>'','matidtcodext'=>'','matidtqty'=>'','matidtuntcod'=>'','matbseqty'=>'');
				$lv_barcod = $lo_post['barcod'];
				if ( trim($lv_barcod)=='' ){ 
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'String de lectura invalido.') );
				}
				
				// ---------------------------------------------------------------
				// Lectura de etiqueta estándard TEMASIS
				//   MATERIAL|LOTE|SERIE|UM
				// ---------------------------------------------------------------
				if( stripos($lv_barcod,'|')!=false ) {
					$lv_matarr = explode('|', $lv_barcod);
					$lo_ret['matcod'] = $lv_matarr[0];
					$lo_ret['matbchcod'] = $lv_matarr[1];
					$lo_ret['matsercod'] = $lv_matarr[2];
					$lo_ret['matuntcod'] = $lv_matarr[3];
				} else {
				
				// ---------------------------------------------------------------
				// Lectura de etiqueta GS1
				//   (01) - gtin  [14 posiciones]
				//   (21) - serie [hasta 20 posiciones -termina con #-]
				//   (10) - lote  [hasta 10 posiciones -termina con #-]
				//   (17) - vto   [YYMMDD o YYMM]
				// ---------------------------------------------------------------
					$lv_found = true;
					$lv_val = $lv_barcod;
					while($lv_found==true){
						// gtin (14 posiciones)
						if( substr($lv_val,0,2)=='01' ) {
							$lo_ret['matidtcodext'] = substr($lv_val, 2, 13);
							$lv_val = substr($lv_val, 15, strlen($lv_val) - 15);

						// serie (hasta 20 pos, termina con #)
						} else if( substr($lv_val,0,2)=='21' ) {
							$lv_end = stripos($lv_val, '#');
              if ($lv_end==false){
                $lo_ret['matsercodext'] = substr($lv_val, 2, strLen($lv_val));
                $lv_val = substr($lv_val, strLen($lo_ret['matsercodext']), strLen($lv_val) - strLen($lo_ret['matsercodext']) - 3);
							} else {
                $lo_ret['matsercodext'] = substr($lv_val, 2, $lv_end - 2);
                $lv_val = substr($lv_val, strLen($lo_ret['matsercodext']) + 3, strLen($lv_val) - strLen($lo_ret['matsercodext']) - 3);
              }
            // lote (hasta 10 pos, termina con #)
						} else if( substr($lv_val,0,2)=='10' ) {
							$lv_end = stripos($lv_val, '#');
              if ($lv_end==false){
                $lo_ret['matbchcodext'] = substr($lv_val, 2, strLen($lv_val));
                $lv_val = substr($lv_val, strLen($lo_ret['matbchcodext']) , strLen($lv_val) - strLen($lo_ret['matbchcodext']) - 3);
							} else {
                $lo_ret['matbchcodext'] = substr($lv_val, 2, $lv_end - 2);
                $lv_val = substr($lv_val, strLen($lo_ret['matbchcodext']) + 3, strLen($lv_val) - strLen($lo_ret['matbchcodext']) - 3);
              }
            // vencimiento (6 pos, YYMMDD)
						} else if( substr($lv_val,0,2)=='17' ) {
							$lo_ret['matbchduedte'] = substr($lv_val, 2, 6);
							$lo_ret['matbchduedte'] = substr($lo_ret['matbchduedte'], -2) .'/'. substr($lo_ret['matbchduedte'], 2, 2) .'/20'. substr($lo_ret['matbchduedte'], 0, 2);
							$lv_val = substr($lv_val, 9, strLen($lv_val) - 8);
							
						} else {
							$lv_found = false;
						}
					}
				}
				$lo_data = array();
				
				//   N U M E R O   de   S E R I E
				if($lo_ret['matsercod']!='' || $lo_ret['matsercodext']!=''){
					$lo_matmdl = $this->co_reg->load->model('stkmatser');
					$lv_prm = array('vewfldflt' =>($lo_ret['matsercod']!=''?'[~fltrow~]s.matsercod'.chr(9).'='.chr(9).chr(9).$lo_ret['matsercod'].chr(9).chr(9):'').
																				($lo_ret['matsercodext']!=''?'[~fltrow~]s.matsercodext'.chr(9).'='.chr(9).chr(9).$lo_ret['matsercodext'].chr(9).chr(9):'').
																				'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewmaxrec' => '1');
					$lo_rs = $lo_matmdl->getList( $lv_prm, null, null, false );
					if( count($lo_rs)>0 ) {
						$lo_data['matcod'] 				= $lo_rs[0]['matcod'];
						$lo_data['mattxt'] 				= $lo_rs[0]['mattxt'];
						$lo_data['matuntcod'] 		= $lo_rs[0]['matuntcod'];
						$lo_data['matsercod'] 		= $lo_rs[0]['matsercod'];
						$lo_data['matsercodext'] 	= $lo_rs[0]['matsercodext'];
						$lo_data['matbchcod'] 		= ($lo_rs[0]['matbchcod']==null || $lo_rs[0]['matbchcod']==0 ? '' : $lo_rs[0]['matbchcod']);
						$lo_data['matbchcodext'] 	= ($lo_rs[0]['matbchcod']==null || $lo_rs[0]['matbchcod']==0 ? '' : $lo_rs[0]['matbchcodext']);
						$lo_data['matbchduedtecnv']=($lo_rs[0]['matbchcod']==null || $lo_rs[0]['matbchcod']==0 ? '' : $lo_rs[0]['matbchduedtecnv']);
						$lo_data['matidtqty'] 		= 1;
						$lo_data['matbseqty'] 		= 1;
						$lo_data['matidtuntcod']	= $lo_data['matuntcod'];
					}
				
				
				//   L O T E
				} else if ($lo_ret['matbchcod']!='' || $lo_ret['matbchcodext']!='' ) {
					$lo_matmdl = $this->co_reg->load->model('stkmatbch');
					$lv_prm = array('vewfldflt' =>($lo_ret['matbchcod']!=''?'[~fltrow~]b.matbchcod'.chr(9).'='.chr(9).chr(9).$lo_ret['matbchcod'].chr(9).chr(9):'').
																				($lo_ret['matbchcodext']!=''?'[~fltrow~]b.matbchcodext'.chr(9).'='.chr(9).chr(9).$lo_ret['matbchcodext'].chr(9).chr(9):'').
																				'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewmaxrec' => '1');
					$lo_rs = $lo_matmdl->getList( $lv_prm );
					if( count($lo_rs)>0 ) {
						$lo_data['matcod'] 				= $lo_rs[0]['matcod'];
						$lo_data['mattxt'] 				= $lo_rs[0]['mattxt'];
						$lo_data['matuntcod'] 		= $lo_rs[0]['matuntcod'];
						$lo_data['matbchcod'] 		= $lo_rs[0]['matbchcod'];
						$lo_data['matbchcodext'] 	= $lo_rs[0]['matbchcodext'];
						$lo_data['matbchduedtecnv']= $lo_rs[0]['matbchduedtecnv'];
					}
					
					// si la unidad de medida leía difiere de la unidad de medida base, entonces verificar si existe la conversión
					if( trim(strtoupper($lo_ret['matuntcod']))!=$lo_data['matuntcod'] ) {
						$lo_idtmdl = $this->co_reg->load->model('stkmatidt');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$lo_data['matcod'].chr(9).chr(9).
																					'[~fltrow~]i.matidtuntcod'.chr(9).'='.chr(9).chr(9).$lo_ret['matuntcod'].chr(9).chr(9).
																					'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewmaxrec' => '1');
						$lo_idtrs = $lo_idtmdl->getList( $lv_prm );
						if( count($lo_idtrs)>0 ) {
							$lo_data['matidtqty'] 	= $lo_idtrs[0]['matidtqty'];
							$lo_data['matbseqty'] 	= $lo_idtrs[0]['matbseqty'];
							$lo_data['matidtuntcod']= $lo_idtrs[0]['matidtuntcod'];
						} else {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Unidad de medida invalida para el material.') );
						}
					} else {
						$lo_data['matidtqty'] = 1;
						$lo_data['matbseqty'] = 1;
						$lo_data['matidtuntcod'] = $lo_data['matuntcod'];
					}
					
					
				//    E A N   ( identificacion )
				} else if ($lo_ret['matidtcodext']!='') {
					$lo_matmdl = $this->co_reg->load->model('stkmatidt');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]i.matidtcodext'.chr(9).'='.chr(9).chr(9).$lo_ret['matidtcodext'].chr(9).chr(9).
																				'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewmaxrec' => '1');
					$lo_rs = $lo_matmdl->getList( $lv_prm );
					if( count($lo_rs)>0 ) {
						$lo_data['matcod'] 				= $lo_rs[0]['matcod'];
						$lo_data['mattxt'] 				= $lo_rs[0]['mattxt'];
						$lo_data['matuntcod'] 			= $lo_rs[0]['matuntcod'];
						$lo_data['matidtqty'] 			= $lo_rs[0]['matidtqty'];
						$lo_data['matbseqty'] 			= $lo_rs[0]['matbseqty'];
						$lo_data['matidtuntcod'] 		= $lo_rs[0]['matidtuntcod'];
					}
				
				//    M A T E R I A L
				} else if ($lo_ret['matcod']!='') {
					$lo_matmdl = $this->co_reg->load->model('stkmat');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'='.chr(9).chr(9).$lo_ret['matcod'].chr(9).chr(9).
																				'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewmaxrec' => '1');
					$lo_rs = $lo_matmdl->getList( $lv_prm, null, null, false );
					if( count($lo_rs)>0 ) {
						$lo_data['matcod'] 		= $lo_rs[0]['matcod'];
						$lo_data['mattxt'] 		= $lo_rs[0]['mattxt'];
						$lo_data['matuntcod'] = $lo_rs[0]['matuntcod'];
					}
					
					// si la unidad de medida leía difiere de la unidad de medida base, entonces verificar si existe la conversión
					if( trim(strtoupper($lo_ret['matuntcod']))!=$lo_data['matuntcod'] ) {
						$lo_idtmdl = $this->co_reg->load->model('stkmatidt');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$lo_data['matcod'].chr(9).chr(9).
																					'[~fltrow~]i.matidtuntcod'.chr(9).'='.chr(9).chr(9).$lo_ret['matuntcod'].chr(9).chr(9).
																					'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewmaxrec' => '1');
						$lo_idtrs = $lo_idtmdl->getList( $lv_prm );
						if( count($lo_idtrs)>0 ) {
							$lo_data['matidtqty'] 	= $lo_idtrs[0]['matidtqty'];
							$lo_data['matbseqty'] 	= $lo_idtrs[0]['matbseqty'];
							$lo_data['matidtuntcod']= $lo_idtrs[0]['matidtuntcod'];
						} else {
	 	         	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Unidad de medida invalida para el material.') );
						}
					} else {
						$lo_data['matidtqty'] = 1;
						$lo_data['matbseqty'] = 1;
						$lo_data['matidtuntcod'] = $lo_data['matuntcod'];
					}
				}
				
				if( isset($lo_data['matcod']) ){
					foreach($lo_data as $lv_key=>$lv_val){ 
						$lo_ret[$lv_key] = $lv_val;
					}
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Material inválido.') );
				}
				
        return $this->co_reg->document->getJson( $lo_ret );
				break;		
      //OBTENER IDENTIFICADORES/CONVERSIONES MEDIANTE CODIGO DE MATERIAL
      case "#19":
        $lo_post = $this->co_reg->request->post;
        $lo_idtmdl = $this->co_reg->load->model('stkmatidt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$lo_post['matcod'].chr(9).chr(9).
                                      '[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                        'vewmaxrec' => '1');
        $lo_rs = $lo_idtmdl->getList( $lv_prm );
        return $this->co_reg->document->getJson($lo_rs);
        break;
    }
  }
}
?>