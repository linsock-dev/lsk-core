<?php
final class fintaxtypController extends tmssController2 {
  function initialize(){
    $this->CONTROLLER='fintaxtyp';$this->MODEL='fintaxtyp';$this->VIEW='fintaxtyp';$this->ID='fintaxtypcod';$this->enable_sysdoccls=false;
    $this->preventCopy = array('fintaxtypcodext');
  }
  
  function additionalFunctions($lp_act){
    switch ( $lp_act ) {
      // GET LIST by TEXT. devuelve lista de documentos segun texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
								'vewfldflt' =>(isset($this->prm['fintaxtyptxt'])?'[~fltrow~]fintaxtyptxt'.chr(9).''.chr(9).$this->prm['fintaxtyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);					
				$lo_data = $this->mdl->getList($lv_prm, null, null,false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;
    }
  }
}
?>