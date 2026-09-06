<?php
final class hhrlqdgrp extends tmssAction2 {
  function initialize(){ $this->ID = 'hhrlqdgrpcod'; }
    
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['hhrlqddoc'] = array();
	}  
	
	// GET DOCUMENTS. devuelve la lista de documentos de un grupo de liquidaciones
  function getDocuments( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '23', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET SOURCES. devuelve la lista de origenes para liquidación
  function getSources( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '33', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // UPDATETOTAL. actualiza el total de cabecera del documento basado en los documentos asignados
  function updateTotal( $lp_dat=array() ) {
    if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $this->data );
  }
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hhrlqdgrpcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrlqdgrptxt'),
                                      $this->co_reg->db->sqldte($lp_in,'hhrlqdgrpdte'), 
                                      $this->co_reg->db->sqldte($lp_in,'hhrlqdgrpstrdte'), 
                                      $this->co_reg->db->sqldte($lp_in,'hhrlqdgrpenddte'), 
																			$this->co_reg->db->sqldat($lp_in,'prcschcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrlqdgrpatr001', false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
                                    );
		$this->sysdata['sqltxt'] = 'HHR_LQD_GRP_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23|33')){return false;}    
		
		//		L I Q U I D A C I O N E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_grpmdl = $this->co_reg->load->model('hhrlqdgrp');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]g.hhrlqdgrpcod'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9));
			$lp_out['hhrlqddoc'] = $lo_grpmdl->getDocuments( $lv_prm );
		}
		
		//		C  O N D I C I O N E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lv_doc=array();
			foreach($lp_out['hhrlqddoc'] as $lv_rowdoc){$lv_doc[]=$lv_rowdoc['hhrlqdcod'];}
			$lo_prcmdl = $this->co_reg->load->model('grldatprc');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_LQD'.chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_doc).chr(9).chr(9),
                    	'vewfldord' => 'p.srcobjtyp, p.srcobjcod001, p.prcschcndrow' );
			$lp_out['hhrlqddocprc'] = $lo_prcmdl->getList( $lv_prm );
		}
    
		return ($this->errcod==0?true:false);
	}	
}
?>