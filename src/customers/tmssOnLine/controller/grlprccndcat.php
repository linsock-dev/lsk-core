<?php
final class grlprccndcatController extends tmssController2{
	function initialize(){ $this->CONTROLLER='grlprccndcat'; $this->MODEL='grlprccndcat'; $this->VIEW='grlprccndcat'; $this->ID='prccndcatcod'; $this->OBJTYP = 'SYS_PCC';  $this->enable_sysdoccls = false; }
  
  function additionalFunctions($lp_act){
  	switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['prccndcattxt'])?'[~fltrow~]pcc.prccndcattxt'.chr(9).''.chr(9).$this->prm['prccndcattxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]pcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												); 
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>