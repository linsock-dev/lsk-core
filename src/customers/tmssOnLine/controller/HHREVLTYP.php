<?php
final class hhrevltypController extends tmssController2 { 
  
	function initialize(){$this->MODEL='hhrevltyp';$this->VIEW='hhrevltyp';$this->ID='hhrevltypcod';$this->preventCopy = array('hhrevltypcodext');}
  
   function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hhrevltyptxt'])?'[~fltrow~]t.hhrevltyptxt'.chr(9).''.chr(9).$this->prm['hhrevltyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>
 