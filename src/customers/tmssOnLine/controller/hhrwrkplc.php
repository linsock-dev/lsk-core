<?php
final class hhrwrkplcController extends tmssController2 {
  
	function initialize(){
    $this->CONTROLLER='hhrwrkplc';$this->MODEL='hhrwrkplc';$this->VIEW='hhrwrkplc';$this->ID='wrkplccod';$this->enable_sysdoccls=true;$this->extraRet = array('sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),'objtyp'=>'HHR_WKP');$this->preventCopy = array('wrkplccodext');
  }
  
   function additionalFunctions($lp_act){
      switch ( $lp_act ) {
          
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['wrkplctxt'])?'[~fltrow~]p.wrkplctxt'.chr(9).''.chr(9).$this->prm['wrkplctxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>