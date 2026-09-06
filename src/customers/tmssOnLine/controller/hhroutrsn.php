<?php
final class hhroutrsnController extends tmssController2 {
	function initialize(){$this->MODEL='hhroutrsn';$this->VIEW='hhroutrsn';$this->ID='hhroutrsncod';$this->preventCopy = array('hhroutrsncodext');}
  
  function additionalFunctions($lp_act)
  {
    switch($lp_act) {
      case '#18':
      	$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hhroutrsntxt'])?'[~fltrow~]r.hhroutrsntxt'.chr(9).''.chr(9).$this->prm['hhroutrsntxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$this->data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson(array('data'=>$this->data));
        break;
    }
  }
}
?>