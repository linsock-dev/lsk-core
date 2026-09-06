<?php 
class tmssDocument {

  private $co_reg;
  private $data = array();

  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
  function __destruct() {  }
  function __get( $lp_key ) { return (isset($this->data[$lp_key])?$this->data[$lp_key]:''); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
  
	
	
  /* *************************************************************************
	 * getMenu
	 * Devuelve un array con el menú de programas
	 * parámetros:
	 * - mdlcod: devuelve progarmas-operaciones específicos del módulo (DEFAULT: vacío)
	 * - buscod: empresa específica. Si no se indica, se devuelven todos los programas-operaciones (DEFAULT: current BUSCOD)
	 * - chkper: verificar permisos. Devuelve solo programas-operaciones que el usuario tenga permiso (DEFAULT: true)
	 * - getall: devuelve todos los programas, suscriptos o no (DEFAULT: false)
	 * - getopr: devolver operaciones (DEFAULT: false)
	 * - getsep: devolver separadores (DEFAULT: true)
	 * - getempfld: devuelve carpetas sin nodos (DEFAULT: false)
	 */
  function getMenu( $lp_prm=array() ) {
    $lv_mnu = array();
		
		/* valores x default */
		$lp_prm['mdlcod'] = (isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:'');
		$lp_prm['buscod'] = (isset($lp_prm['buscod'])?$lp_prm['buscod']:$this->co_reg->sec->buscod);
		$lp_prm['chkper'] = (isset($lp_prm['chkper'])?$lp_prm['chkper']:true);
		$lp_prm['getall'] = (isset($lp_prm['getall'])?$lp_prm['getall']:false);
		$lp_prm['getopr'] = (isset($lp_prm['getopr'])?$lp_prm['getopr']:false);
		$lp_prm['gethde'] = (isset($lp_prm['gethde'])?$lp_prm['gethde']:false);
		$lp_prm['getsep'] = (isset($lp_prm['getsep'])?$lp_prm['getsep']:true);
		$lp_prm['getempfld'] = (isset($lp_prm['getempfld'])?$lp_prm['getempfld']:false);
		
		/* obtengo programas-operaciones */
		$lo_rs=array();
		if ($lp_prm['getall']==true) {
			$lo_sysprg = $this->co_reg->load->model('sysappprg');			
			$lo_rs = $lo_sysprg->getList();
		} else {
			$lo_sysprg = $this->co_reg->load->model('sysfncsub');
			$lv_prm = array('cuscodext'=>$lp_prm['buscod']);
			$lo_rs = $lo_sysprg->getOperationsList(null,$lv_prm);
		}
		unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);			

		/* armo los menúes */
    if (isset($lo_rs) && count($lo_rs)!=0) {
			$lv_lstmdl='';
      for( $lv_inx=0; $lv_inx<count($lo_rs); $lv_inx++ ) {
        if ($lv_lstmdl!=strtoupper($lo_rs[$lv_inx]['mdlcod']) && ( strtoupper($lp_prm['mdlcod'])==strtoupper($lo_rs[$lv_inx]['mdlcod']) || $lp_prm['mdlcod']=='') ) {
					$lv_lstmdl=strtoupper($lo_rs[$lv_inx]['mdlcod']);
          $lv_mnutmp = array('mdlcod'=>$lo_rs[$lv_inx]['mdlcod'], 'mdltxt'=>$lo_rs[$lv_inx]['mdltxt'], 'mdlpic'=>$lo_rs[$lv_inx]['mdlpic'],
														'prgcod'=>'**', 'prgtxt'=>'', 'prgpic'=>'',
														'oprcod'=>'', 'oprtxt'=>'', 'oprpic'=>'',
														'prgfrm'=>'',
														'vewcod'=>'',
														'prgtypcod'=>'0',
														'prgmnuchl'=>$lo_rs[$lv_inx]['prgmnupar'],
														'prgmnupar'=>'',
														'mnulst'=> $this->getMenuArray( $lo_rs, $lv_inx, $lo_rs[$lv_inx]['prgmnupar'], $lp_prm )
														);
          // si contiene programas, cargo la carpeta principal
          if (count($lv_mnutmp['mnulst'])!=0 || $lp_prm['getempfld']==true) {
						$lv_mnu[] = $lv_mnutmp;
					}
        }
      }
    }
    return $lv_mnu;
	}
	
	/* *************************************************************************
	 * getMenuArray
	 * Recursiva para armar el menú de programas
	 */
  private function getMenuArray( &$lp_mnu, &$lp_inx, $lp_key, $lp_prm=array() ) {
    $lv_mnu = array();
    $lv_ext=0;
    for( ; $lp_inx<count($lp_mnu) && $lv_ext==0; $lp_inx++ ) {
      if ( $lp_mnu[$lp_inx]['prgmnupar']!=$lp_key ) {
        $lp_inx-=2;
        $lv_ext=1; 
      } else {

				//	C A R P E T A S
        if ( $lp_mnu[$lp_inx]['prgtypcod']==3 ) {
          $lv_mnutmp = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'], 'mdltxt'=>'', 'mdlpic'=>'',
														'prgcod'=>$lp_mnu[$lp_inx]['prgcod'], 'prgtxt'=>$lp_mnu[$lp_inx]['prgtxt'], 'prgpic'=>$lp_mnu[$lp_inx]['prgpic'],
														'oprcod'=>'', 'oprtxt'=>'', 'oprpic'=>'',
														'prgfrm'=>'',
														'vewcod'=>'',
														'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
														'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
														'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar'],
														'mnulst'=>array()
														);
					$lv_mnuchl = $lp_mnu[$lp_inx]['prgmnuchl'];
					$lp_inx++;
					$lv_mnutmp['mnulst'] = $this->getMenuArray( $lp_mnu, $lp_inx, $lv_mnuchl, $lp_prm );
          // si contiene programas, cargo la carpeta principal
          if ( count($lv_mnutmp['mnulst'])!=0 || $lp_prm['getempfld']==true ) {
						$lv_mnu[] = $lv_mnutmp;
					}
					
        //	S E P A R A D O R E S
        } else if ( $lp_mnu[$lp_inx]['prgtypcod']==2 && $lp_prm['getsep']==true ) {
          // no se cargan separadores si es la primer opción
          if ( count($lv_mnu)!=0 ) {
            // no se cargan dos separadores juntos
            if ($lv_mnu[count($lv_mnu)-1]['prgtypcod']!=2) {
              $lv_mnu[] = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'], 'mdltxt'=>'', 'mdlpic'=>'',
																'prgcod'=>$lp_mnu[$lp_inx]['prgcod'], 'prgtxt'=>'', 'prgpic'=>'',
																'oprcod'=>'', 'oprtxt'=>'', 'oprpic'=>'',
																'prgfrm'=>'',
																'vewcod'=>'',
																'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
																'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
																'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar']
																);
            }
          }
					
				//	P R O G R A M A S
        } else if ( $lp_mnu[$lp_inx]['prgtypcod']==1 ) {
					if(
							(($this->co_reg->sec->hasPermission($lp_mnu[$lp_inx]['mdlcod'], $lp_mnu[$lp_inx]['prgcod']) && $lp_prm['chkper']==true) || $lp_prm['chkper']==false)
							&&
							(($lp_mnu[$lp_inx]['prgmnuhde']=='1' && $lp_prm['gethde']==true) || $lp_mnu[$lp_inx]['prgmnuhde']=='0')
						) {
						
						$lv_mnutmpprg = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'], 'mdltxt'=>'', 'mdlpic'=>'',
																'prgcod'=>$lp_mnu[$lp_inx]['prgcod'], 'prgtxt'=>$lp_mnu[$lp_inx]['prgtxt'], 'prgpic'=>$lp_mnu[$lp_inx]['prgpic'],
																'oprcod'=>'', 'oprtxt'=>'', 'oprpic'=>'',
																'prgfrm'=>$lp_mnu[$lp_inx]['prgfrm'],
																'vewcod'=>$lp_mnu[$lp_inx]['vewcod'],
																'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
																'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
																'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar']
																);

						// O P E R A C I O N E S
						$lv_mnutmpopr = [];
						$lv_lstid = $lp_mnu[$lp_inx]['mdlcod'].'_'.$lp_mnu[$lp_inx]['prgcod'];
						for( ; $lp_inx<count($lp_mnu) && $lv_lstid==$lp_mnu[$lp_inx]['mdlcod'].'_'.$lp_mnu[$lp_inx]['prgcod']; $lp_inx++ ) {
							if ( $lp_prm['getopr']==true ) {
								if ( $lp_prm['chkper']==false || $this->co_reg->sec->hasPermission($lp_mnu[$lp_inx]['mdlcod'], $lp_mnu[$lp_inx]['prgcod'], $lp_mnu[$lp_inx]['oprcod']) ) {
									$lv_mnutmpopr[] = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'], 'mdltxt'=>'', 'mdlpic'=>'',
																					'prgcod'=>$lp_mnu[$lp_inx]['prgcod'], 'prgtxt'=>'', 'prgpic'=>'',
																					'oprcod'=>$lp_mnu[$lp_inx]['oprcod'], 'oprtxt'=>$lp_mnu[$lp_inx]['oprtxt'], 'oprpic'=>$lp_mnu[$lp_inx]['oprpic'],
																					'prgfrm'=>'',
																					'vewcod'=>'',
																					'prgtypcod'=>'4',
																					'prgmnuchl'=>'',
																					'prgmnupar'=>'',
																					);
								}
							}
						}
						$lv_mnutmpprg['mnulst'] = (isset($lv_mnutmpopr)?$lv_mnutmpopr:array());
						if ( count($lv_mnutmpprg['mnulst'])!=0 || $lp_prm['getempfld']==true || $lp_prm['getopr']==false ){
							$lv_mnu[] = $lv_mnutmpprg;
						}
						$lp_inx--;
					} else {
						// si no tiene permiso para ** entonces no sigo cargando operaciones, paso al siguiente programa
						$lv_lstid = $lp_mnu[$lp_inx]['mdlcod'].'_'.$lp_mnu[$lp_inx]['prgcod'];
						for( ; $lp_inx<count($lp_mnu) && $lv_lstid==$lp_mnu[$lp_inx]['mdlcod'].'_'.$lp_mnu[$lp_inx]['prgcod']; $lp_inx++ ) {}
						$lp_inx--;
					}
        }
      }
    }
    return $lv_mnu;
  }



	/** 
	 * Devuelve el valor de un tag
	 * OJO, no funciona si el tag tiene parámetros (falta desarrollar)
	 */
	function getTagValue( $lp_html, $lp_tagnme ) {
		//$lp_html = strtolower($lp_html);
		//$lp_tagnme = strtolower($lp_tagnme);
		$lp_html = ($lp_html==null?'':$lp_html);
		
		$lv_istr = stripos( $lp_html,'<'.$lp_tagnme.'>');
		if ( $lv_istr===FALSE ) { return ''; }
		$lv_istr = $lv_istr + strlen($lp_tagnme) + 2;

		$lv_ilen = stripos($lp_html, '</'.$lp_tagnme.'>', $lv_istr);
		if ( $lv_ilen===FALSE ) { return ''; }
		$lv_ilen = $lv_ilen - $lv_istr;

		$lv_sret = substr($lp_html, $lv_istr, $lv_ilen);
		return $lv_sret;
	}
	
	
	// convierte los string de un array a utf8 
	function array_utf8_converter($array) {
		if( is_array($array) ){
			array_walk_recursive($array, function(&$item, $key){
				if ( gettype($item)=='string' ) {
					if(!mb_detect_encoding($item, 'utf-8', true)){
						$item = utf8_encode($item);
					}
				}
			});
		}
		return $array;
	}
	
	
	// GET JSON. devuelve un array convertido como JSON y normalizado por UTF8 para que no haya errores
	function getJson( $lp_arr=array() ) {	
		$lv_retjsn = json_encode( $this->array_utf8_converter($lp_arr) );
		if ( json_last_error() == JSON_ERROR_NONE ) {
			$this->co_reg->response->addHeader('Content-type: application/json');
			return $lv_retjsn;
		} else {
			return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
		}
	}
	
	function getArrayFromJson( $lp_json='' ){
		$lv_arr = json_decode( ($lp_json==''?'[]':utf8_encode($lp_json)), true );
		array_walk_recursive($lv_arr, function(&$item, $key){
			if ( gettype($item)=='string' ) {
				if(!mb_detect_encoding($item, 'utf-8', true)){
					$item = utf8_decode($item);
				}
				$item = html_entity_decode($item);
			}
		});
		return $lv_arr;
	}
	
  
  // GET ARRAY FROM XML. convierte un string con formato <clave>valor</clave> en un array asociativo
  // @param string $lp_xml cadena con formato <atributo1>valor1</atributo1>...
  // @return array
  function getArrayFromXML($lp_xml) {
    $lv_ret = [];
    $lv_txt = preg_replace('/>\s+</', '><', trim($lp_xml));
    if ($lv_txt === '') { return $lv_ret; }
    $lv_patron = '/<([a-zA-Z0-9_-]+)>(.*?)<\/\1>/s';
    if (preg_match_all($lv_patron, $lv_txt, $lv_matches, PREG_SET_ORDER)) {
      foreach ($lv_matches as $lv_row) {
        $lv_key   = $lv_row[1];
        $lv_val   = $lv_row[2];
        $lv_ret[$lv_key] = trim($lv_val);
      }
    }
    return $lv_ret;
  }
  
  
	// GET VIEW. devuelve una vista
	function getView( $lp_vew, $lp_dat=array() ) {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' 	=> $this->co_reg->sec,
										'doc' 	=> $this->co_reg->document,
										'load'  => $this->co_reg->load,
										'db'		=> $this->co_reg->db
										);
		foreach($lp_dat as $lv_key=>$lv_val){ $lv_prm[$lv_key]=$lv_val; }
		$lv_ret = $this->co_reg->load->view( $lp_vew, $lv_prm );		
		return $lv_ret;
	}
	
	// GET CALL COMPONENTS. devuelve los componentes de una llamada como array (x ejemplo "?prg=slscus&act=03&prm_cuscod=1654")
	function getCallComponents( $lp_prm='' ) {
		$lv_ret = array('prg'=>'','act'=>'', 'prm'=>array());
		$lv_prmarr = explode('&',strtolower(html_entity_decode($lp_prm)));
		foreach ( $lv_prmarr as $lv_row ) {
			$lv_val = explode('=',$lv_row);
			if( substr($lv_val[0], 0, 4)=='prm_' ){ $lv_ret['prm'][ substr($lv_val[0],4,strlen($lv_val[0])-4) ] = $lv_val[1]; }
			if( $lv_val[0]=='?prg' ){ $lv_ret['prg'] = $lv_val[1]; }
			if( $lv_val[0]=='act' ){ $lv_ret['act'] = $lv_val[1]; }
		}
		return $lv_ret;
	}
	
  function numberToWords($number, $moneda='', $centimos='', $forzarCentimos=false){
		$converted = '';
		$decimales = '';

		if (($number < 0) || ($number > 999999999)) {
			return 'No es posible convertir el numero a letras';
		}
		
		$div_decimales = explode('.',$number);

		if(count($div_decimales) > 1){
			$number = $div_decimales[0];
			$decNumberStr = (string) $div_decimales[1];
			if(strlen($decNumberStr) == 2){
				$decNumberStrFill = str_pad($decNumberStr, 9, '0', STR_PAD_LEFT);
				$decCientos = substr($decNumberStrFill, 6);
				$decimales = self::numberToWords_convertGroup($decCientos);
			}
		} else if (count($div_decimales) == 1 && $forzarCentimos){
			$decimales = 'CERO ';
		}

		$numberStr = (string) $number;
		$numberStrFill = str_pad($numberStr, 9, '0', STR_PAD_LEFT);
		$millones = substr($numberStrFill, 0, 3);
		$miles = substr($numberStrFill, 3, 3);
		$cientos = substr($numberStrFill, 6);
		if (intval($millones) > 0) {
			if ($millones == '001') {
				$converted .= 'UN MILLON ';
			} else if (intval($millones) > 0) {
				$converted .= sprintf('%sMILLONES ', self::numberToWords_convertGroup($millones));
			}
    }

		if (intval($miles) > 0) {
			if ($miles == '001') {
				$converted .= 'MIL ';
			} else if (intval($miles) > 0) {
				$converted .= sprintf('%sMIL ', self::numberToWords_convertGroup($miles));
			}
		}

		if (intval($cientos) > 0) {
			if ($cientos == '001') {
				$converted .= 'UN ';
			} else if (intval($cientos) > 0) {
				$converted .= sprintf('%s ', self::numberToWords_convertGroup($cientos));
			}
		}

		if(empty($decimales)){
			$valor_convertido = $converted . strtoupper($moneda);
		} else {
			$valor_convertido = $converted . strtoupper($moneda) . ' CON ' . $decimales . ' ' . strtoupper($centimos);
		}

		return $valor_convertido;
	}

	private function numberToWords_convertGroup($n) {
		$UNIDADES = ['','UN ','DOS ','TRES ','CUATRO ','CINCO ','SEIS ','SIETE ','OCHO ','NUEVE ','DIEZ ','ONCE ','DOCE ','TRECE ','CATORCE ','QUINCE ','DIECISEIS ','DIECISIETE ','DIECIOCHO ','DIECINUEVE ','VEINTE '];
		$DECENAS = ['VENTI','TREINTA ','CUARENTA ','CINCUENTA ','SESENTA ','SETENTA ','OCHENTA ','NOVENTA ','CIEN '];
		$CENTENAS = ['CIENTO ','DOSCIENTOS ','TRESCIENTOS ','CUATROCIENTOS ','QUINIENTOS ','SEISCIENTOS ','SETECIENTOS ','OCHOCIENTOS ','NOVECIENTOS '];
		$output = '';
		if ($n == '100') {
			$output = 'CIEN ';
		} else if ($n[0] !== '0') {
			$output = $CENTENAS[$n[0] - 1];
		}
		$k = intval(substr($n,1));
		if ($k <= 20) {
			$output .= $UNIDADES[$k];
		} else {
			if(($k > 30) && ($n[2] !== '0')) {
				$output .= sprintf('%sY %s', $DECENAS[intval($n[1]) - 2], $UNIDADES[intval($n[2])]);
			} else {
				$output .= sprintf('%s%s', $DECENAS[intval($n[1]) - 2], $UNIDADES[intval($n[2])]);
			}
		}
		return $output;
	}
	
	// Realiza la llama a una UserExit
	// recibe:
	// - UEXIT: string que contiene la URL de la user exit (formato "?prg=....&act=...&prm_...=....)
	// - PRM: array con datos adicionales
	// devuelve:
	// - true/false: existe o no una user exit
	function callUserExit( $lp_uexit, $lp_prm, $lp_ctr=array() ) {
		$this->retUserExit = array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'' );
		$lp_uexit = trim($lp_uexit);
		if ( $lp_uexit=='' ) return false;
		$lv_prm = $lp_prm;
		$lv_ctr='';
		$lv_act='';
		$lv_keyprm = explode('&',$lp_uexit);
		foreach($lv_keyprm as $lv_uexitrow){
			$lv_key = explode('=',$lv_uexitrow);
			if(strtolower($lv_key[0])=='?prg'){ $lv_ctr=$lv_key[1]; }
			if(strtolower($lv_key[0])=='act'){ $lv_act=$lv_key[1]; }
			if(substr(strtolower($lv_key[0]), 0, 4)=='prm_'){
				//Crea un indice segun el nombre de parametro que se reciba despues del prm_
				$lv_prm[ substr($lv_key[0],4) ] = $lv_key[1];
			}
		}
		if($lv_ctr!='' && $lv_act!=''){
			if( count($lp_ctr)==0 ){ 
				$lo_ctr = $this->co_reg->load->controller( $lv_ctr ); 
			} else {
				$lo_ctr = $lp_ctr[ $lv_ctr ];
			}
			try {
				$this->retUserExit = $lo_ctr->index( $lv_act , $lv_prm );
			} catch(Exception $err) {
				$this->retUserExit = array( 'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=> $err->getMessage() );
			}
			return true;
		} else {
			return false;
		}
	}
	
}
?>