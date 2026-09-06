<?php
final class hltargtrz extends tmssAction { 
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
  const ID = 'trzamtcod';	
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
  
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
		$lp_dat['TrzDat'] = '<id_transaccion>'.(isset($lp_dat['id_transaccion'])?$lp_dat['id_transaccion']:'').'</id_transaccion>'
											. '<id_transaccion_global>'.(isset($lp_dat['id_transaccion_global'])?$lp_dat['id_transaccion_global']:'').'</id_transaccion_global>'
											. '<gln_origen>'.(isset($lp_dat['gln_origen'])?$lp_dat['gln_origen']:'').'</gln_origen>'
											. '<gln_destino>'.(isset($lp_dat['gln_destino'])?$lp_dat['gln_destino']:'').'</gln_destino>'
											. '<gtin>'.(isset($lp_dat['gtin'])?$lp_dat['gtin']:'').'</gtin>'
											. '<lote>'.(isset($lp_dat['lote'])?$lp_dat['lote']:'').'</lote>'
											. '<numero_serial>'.(isset($lp_dat['numero_serial'])?$lp_dat['numero_serial']:'').'</numero_serial>'
											. '<id_evento>'.(isset($lp_dat['id_evento'])?$lp_dat['id_evento']:'').'</id_evento>'
											. '<n_remito>'.(isset($lp_dat['n_remito'])?$lp_dat['n_remito']:'').'</n_remito>';

    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
	
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
  
  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
	}
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod
																			,(isset($lp_in['trzamtcod'])?$lp_in['trzamtcod']:'')
																			,(isset($lp_in['TrzTypCod'])?$lp_in['TrzTypCod']:'')
																			,(isset($lp_in['TrzDat'])?$lp_in['TrzDat']:'')
																			,(isset($lp_in['cnfdte'])?$this->co_reg->db->sqldate($lp_in['cnfdte']):'')
																			,(isset($lp_in['docsts'])?$lp_in['docsts']:'')
																			,(isset($this->sysdata['view_options'])?$this->sysdata['view_options']:'')
																		);
		$this->sysdata['sqltxt'] = 'HLT_ARG_TRZ_AMT_DEF (?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		if ( $lp_action=='08' ) {
			$lp_out = $lo_rs;
		} else {
			if ( $lo_rs && count($lo_rs)>0 ) {
				if ( isset($lo_rs[0]['errcod']) )  {
					if ( $lo_rs[0]['errcod']!=0 ) {
						$this->errtyp = 'E';
						$this->errcod = $lo_rs[0]['errcod'];
						$this->errtxt = $lo_rs[0]['errtxt'];
					} else {
						$lp_out = $lo_rs[0];
						$this->data[self::ID] = array_values($lp_out)[0];
					}
				} else {
					$lp_out = $lo_rs[0];
				}
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -999;
				$this->errtxt = 'Error inesperado al procesar la operacion ['.$this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']).']';
			}
		}		
		return ($this->errcod==0?true:false);
	} 
}
?>