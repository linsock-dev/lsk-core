<?php
final class stkmanact extends tmssAction2 {
  function initialize(){ $this->ID = 'stkmanactcod'; }
  
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create(  );
		$this->data['stkmanactmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='stkmanactmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['stkmanactmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
          if(is_array($lv_matarr)){
						foreach( $lv_matarr as $lv_row ) {
              $lv_row['mattxt'] = utf8_decode(html_entity_decode($lv_row['mattxt']));
							$this->data['stkmanactmat'][] = $lv_row;
						}
          }
				}
			}
		}
	}
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }

	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stkmanactcod'),
                                      $this->co_reg->db->sqldte($lp_in,'stkmanactdte'),
                                     	$this->co_reg->db->sqldat($lp_in,'stkmanacttxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'stkmanactcmt'),
                                      $this->co_reg->db->sqldat($lp_in,'stkmovdoccod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
    
		$this->sysdata['sqltxt'] = 'STK_MAN_ACT_DEF (?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);    
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){
      if (($lp_action=='09' || $lp_action=='19') && $this->errcod!==0){ 
        $this->errmat = $lo_rs[0]['errmat'] ?? '';
      }
      return false;
    }
    
    //		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_stkmanordmat = $this->co_reg->load->model('stkmanactmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]r.stkmanactcod'.chr(9).'='.chr(9).chr(9).$lp_in['stkmanactcod'].chr(9).chr(9));
			$lp_out['stkmanactmat'] = $lo_stkmanordmat->getList( $lv_prm, null, null, false );
		}

    //		I N S U M O S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
      $lo_matmdl = $this->co_reg->load->model('stkmovdocmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lp_out['stkmovdoccod'].chr(9).chr(9));
			$lp_out['stkmovdocmat'] = $lo_matmdl->getList( $lv_prm );
		}
    
    //		C A B E C E R A  -  I N V E N T A R I O
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
      $lo_matmdl = $this->co_reg->load->model('stkmovdoc');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lp_out['stkmovdoccod'].chr(9).chr(9));
			$lp_out['stkmovdoc'] = $lo_matmdl->getList( $lv_prm, null, null, false );
		}
    
		return ($this->errcod==0?true:false);
	}
}
?>