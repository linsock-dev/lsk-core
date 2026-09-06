<?php
final class hltpatdiaController extends tmssController2 {
  
  function initialize(){$this->MODEL='hltpatdia';$this->VIEW='hltpatdia';$this->ID='patdiacod';}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
							
			// GETLIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['patdiatxt'])?'[~fltrow~]patdiatxt'.chr(9).''.chr(9).$this->prm['patdiatxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_rs) );
        break;
    }
  }
}
?>