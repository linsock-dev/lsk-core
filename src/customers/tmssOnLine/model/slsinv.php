<?php
final class slsinv extends tmssAction2 {
  const OBJTYP = 'SLS_INV';
  function initialize(){ $this->ID = 'slsinvcod'; }	
	
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create();
		
    $this->data['slsinvmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='slsinvmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
          if($lv_matarr != NULL){
            foreach( $lv_matarr as $lv_row ) {
              // Inicializo las variables necesarias para poder armar la handson
              $lv_row['slsinvmatcod'] = '';
              $lv_row['slsinvmatatr'] = isset($lv_row['slsinvmatatr']) ? $lv_row['slsinvmatatr'] : '';
              $this->data['slsinvmat'][] = $lv_row;
            }
          }
				}
			}
		}
	}
		
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    if( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	
  // UPDATE PRICES. actualiza totales del documento
  function updatePrices( $lp_dat=array() ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '22', $this->data, $lo_out_data );
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'slsinvcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsinvcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'slsinvtxt'), 
																			$this->co_reg->db->sqldte($lp_in,'slsinvdte'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsinvtot'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'curexcrte'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldte($lp_in,'slsinvstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'slsinvenddte'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
																			$this->co_reg->db->sqldat($lp_in,'paytrmcod'),
																			$this->co_reg->db->sqldat($lp_in,'slsposcod'),
																			$this->co_reg->db->sqldte($lp_in,'slsinvprcdte'), 
																			$this->co_reg->db->sqldte($lp_in,'slsinvaccdte'),
																			$this->co_reg->db->sqldte($lp_in,'slsinvduedte'),
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcod'),
																		);
		$this->sysdata['sqltxt'] = 'SLS_INV_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_slsinvmat = $this->co_reg->load->model('slsinvmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]om.slsinvcod'.chr(9).'='.chr(9).chr(9).$lp_in['slsinvcod'].chr(9).chr(9));
			$lp_out['slsinvmat'] = $lo_slsinvmat->getList( $lv_prm );
		}
		
		//		P R E C I O S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_slsinvprc = $this->co_reg->load->model('grldatprc');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lp_out['objtyp'].chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lp_in['slsinvcod'].chr(9).chr(9),
											'vewfldord' =>'p.srcobjcod002, p.prcschcndrow ' );
			$lp_out['slsinvprc'] = $lo_slsinvprc->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>