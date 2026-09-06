<?php
final class crmcntstsController extends tmssController2 {
	function initialize(){$this->MODEL='crmcntsts';$this->VIEW='crmcntsts';$this->ID='crmcntstscod';$this->preventCopy=array('crmcntstscodext');}
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'50',
												'vewfldflt' => (isset($this->prm['crmcntststxt'])?'[~fltrow~]s.crmcntststxt'.chr(9).''.chr(9).$this->prm['crmcntststxt'].chr(9).chr(9).chr(9):'').
																			($this->post['vewfldflt']??'').
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );

    }
  }
}
?>