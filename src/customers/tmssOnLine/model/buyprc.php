<?php 
final class buyprc extends tmssAction2 {
	function initialize(){ $this->ID = 'buyprccod'; }
  
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['buyprcmat'] = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }

    // preparo atributos de cabecera
		$lp_dat['buyprcatr']='<fledec>'.($lp_dat['buyprcatrfledec']??'').'</fledec>'
												.'<newmat>'.($lp_dat['buyprcatrnewmat']??'').'</newmat>'
												.'<updcst>'.($lp_dat['buyprcatrupdcst']??'').'</updcst>';
		
		// preparo materiales
		$lv_buffer = ($lp_dat['buyprcmat']??'');
		if ($lv_buffer!='') {
			$lv_buffer = html_entity_decode($lv_buffer);
			$lv_buyprcpmat_arr = json_decode($lv_buffer,true);
			$lv_buyprcmat='';
			foreach( $lv_buyprcpmat_arr as $lv_row ) {
				//if( (($lo_post['buyprcatrnewmat']??'')=='0' && ( ($lv_row['matcod']??'')=='' || ($lv_row['mattxt']??'')=='' || ($lv_row['matuntcod']??'')=='')) ){ continue; }	// si no tienen relacion no se carga
				if( ($lv_row['supmatcod']??'')=='' ||	($lv_row['supmattxt']??'')=='' || ($lv_row['supmatprc']??'')=='' || ($lv_row['supmatuntcod']??'')=='' ) { continue; } // valido datos minimos
				$lv_buyprcmat.='<row>'
												.'<supmatcod>'.$lv_row['supmatcod'].'</supmatcod>'
												.'<supmattxt>'.$lv_row['supmattxt'].'</supmattxt>'
												.'<supmatprc>'.$lv_row['supmatprc'].'</supmatprc>'
												.'<supmatuntcod>'.$lv_row['supmatuntcod'].'</supmatuntcod>'
												.'<matcod>'.($lv_row['matcod']??'').'</matcod>'
												.'<mattxt>'.($lv_row['mattxt']??'').'</mattxt>'
												.'<matuntcod>'.($lv_row['matuntcod']??'').'</matuntcod>'
											.'</row>';
			}
			$lp_dat['buyprcmat'] = $lv_buyprcmat;
		}		
		
    return parent::save( $lp_dat, $lp_authCheck );
	}
  	
  // GET MATERIALS. devuelve lista de productos cargados en la lista de precios
  function getMaterials( $lp_key=array() ) { 
		$lo_rs = array();
		$this->call_sp( '28', $lp_key, $lo_rs );
		return $lo_rs;
  }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'buyprccod'),
																			$this->co_reg->db->sqldat($lp_in,'buyprccodext'),
                                      $this->co_reg->db->sqldat($lp_in,'buyprctxt'),
                                  		$this->co_reg->db->sqldat($lp_in,'supcod'),
                                      $this->co_reg->db->sqldat($lp_in,'curcod'),
                            					$this->co_reg->db->sqldte($lp_in,'buyprcstrdte'), 
                                      $this->co_reg->db->sqldte($lp_in,'buyprcenddte'), 
                                      $this->co_reg->db->sqldat($lp_in,'buyprcatr',false),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'buyprcmat',false)	
																		);
		$this->sysdata['sqltxt'] = 'BUY_PRC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|28')){return false;}

		//		P R E C I O S  Y  M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {			
			$lp_out['buyprcmat'] = $this->getMaterials( array('buyprccod'=>$lp_in['buyprccod']) );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>