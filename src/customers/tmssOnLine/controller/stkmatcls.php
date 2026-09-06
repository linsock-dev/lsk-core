<?php
final class stkmatclsController extends tmssController2 {
	function initialize(){$this->MODEL='stkmatcls';$this->VIEW='stkmatcls';$this->ID='matclscod';}
	function additionalFunctions($lp_act){
      switch ( $lp_act ) {
          
			// GETLIST by TEXT
      case '#17': case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['matclstxt'])?'[~fltrow~]c.matclstxt'.chr(9).''.chr(9).$this->prm['matclstxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
        $lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_data) );
        break;
    }
  }
}
?>