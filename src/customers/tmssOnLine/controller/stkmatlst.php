<?php
final class stkmatlstController extends tmssController2 {
  function initialize() { $this->MODEL='stkmatlst'; $this->VIEW='stkmatlst'; $this->ID='matlstcod'; }

  function copyDocument($lp_initialize = array(), $lp_authCheck = true, $lp_getJson = false) {
   array_push($lp_initialize, 'matlstmatcod');
   return parent::copyDocument($lp_getJson, $lp_authCheck,$lp_initialize);
  }

  function additionalFunctions($lp_act){
    switch( $lp_act ){
      // GETLIST by TEXT. busca documentos por texto
      case '#17':
       $this->lo_mdl = $this->co_reg->load->model($this->MODEL);
       $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['matlsttxt'])?'[~fltrow~]ml.matlsttxt'.chr(9).''.chr(9).$this->prm['matlsttxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]ml.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
        $lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }    
  }  
}
?>