<?php 
final class stkmovdoc extends tmssAction2 {
  const OBJTYP = 'STK_MOV';
  function initialize(){ $this->ID = 'stkmovdoccod'; }
		
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create(  );
		$this->data['stkmovdocmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='stkmovdocmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['stkmovdocmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
          if(is_arraY($lv_matarr)){
						foreach( $lv_matarr as $lv_row ) {
              
              // Inicializo variables que no estan definidas en la tabla
              $lv_row['mattxt'] = utf8_decode(html_entity_decode($lv_row['mattxt']));
              $lv_row['stkmovdocmatcod'] = '';
              $lv_row['matqtypck'] = ($lv_row['matqtypck']??'');
              $lv_row['matuntcodpck'] = ($lv_row['matuntcodpck']??'');
              $lv_row['matbchcod'] = ($lv_row['matbchcod']??'');
              $lv_row['matbchcodext'] = ($lv_row['matbchcodext']??'');
              $lv_row['matbchduedte'] = ($lv_row['matbchduedte']??'');
              $lv_row['matsercod'] = ($lv_row['matsercod']??'');
              $lv_row['matsercodext'] = ($lv_row['matsercodext']??'');
              
							$this->data['stkmovdocmat'][] = $lv_row;
						}
          }
				}
			}
		}
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }		
    $lp_dat['stkmovdocatr'] = '<pic>'.($lp_dat['stkmovdocatrpic']??'').'</pic>';
    return parent::save( $lp_dat, $lp_authCheck );
  }
 	
  // CONFIRMATION. actualiza informaci�n de confirmaci�n de recepci�n
  function confirm( $lo_dat=array() ) {
    if( count($lo_dat)==0 ) { $lo_dat = $this->co_reg->request->post; }
		$lo_dat['stkmovdoccnf'] = '<cnftyp>'.$lo_dat['stkmovdoccnftyp'].'</cnftyp>'.
															'<cnfdte>'.$lo_dat['stkmovdoccnfdte'].'</cnfdte>'.
															'<cnfcmt>'.(isset($lo_dat['stkmovdoccnfcmt'])?htmlspecialchars_decode($lo_dat['stkmovdoccnfcmt']):'').'</cnfcmt>';
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '22', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function availabilityCheck( $lp_prm=array() ) {
		$lo_out_data = array();
		if ( $this->call_sp( '60', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoccod'), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoccodext'), 
																			$this->co_reg->db->sqldte($lp_in,'stkmovdocdte'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'), 
																			$this->co_reg->db->sqldat($lp_in,'srccntcod'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjcod'), 
																			$this->co_reg->db->sqldat($lp_in,'dstcntcod'), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovrsncod'), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoclck'), 
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoccmt'), 																				
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoccnf'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
																			$this->co_reg->db->sqldat($lp_in,'traroucod'),
                                     	$this->co_reg->db->sqldat($lp_in,'stkmovdoc',false),
																			$this->co_reg->db->sqldat($lp_in,'stkmovdocmat',false),
																			$this->co_reg->db->sqldat($lp_in,'stkmovdocatr',false)
																		);
		$this->sysdata['sqltxt'] = 'STK_MOV_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,null,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->errmat = $lo_rs[0]['errmat']??'';
    
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|60')){return false;}
		
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_matmdl = $this->co_reg->load->model('stkmovdocmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lp_in['stkmovdoccod'].chr(9).chr(9));
			$lp_out['stkmovdocmat'] = $lo_matmdl->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>