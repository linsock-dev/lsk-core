<?php
final class hltpatclsController extends tmssController2 {
  function initialize(){$this->MODEL='hltpatcls';$this->VIEW='hltpatcls';$this->ID='hltpatclscod';}
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hltpatclstxt'])?'[~fltrow~]c.hltpatclstxt'.chr(9).''.chr(9).$this->prm['hltpatclstxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_data) );
        break;
        
    }
  }
}
?>