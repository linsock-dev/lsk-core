<?php
final class fincecController extends tmssController2{
	function initialize(){ $this->CONTROLLER='fincec'; $this->MODEL='fincec'; $this->VIEW='fincec'; $this->ID='finceccod'; $this->OBJTYP = 'FIN_CEC';  $this->enable_sysdoccls = false;$this->preventCopy = array('finceccodext'); }
  
  function additionalFunctions($lp_act){
    switch ( $lp_act ) {
      // GET LIST. devuelve lista de documentos activos
      case '#18':
        $lv_prm = array('vewfldflt' => (isset($this->prm['fincectxt'])?'[~fltrow~]c.fincectxt'.chr(9).''.chr(9).$this->prm['fincectxt'].chr(9).chr(9).chr(9):'').
                                      '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );
        $lo_data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;			
    }
  }
}
?>