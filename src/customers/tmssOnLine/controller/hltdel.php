<?php
final class hltdelController extends tmssController2 {
	function initialize(){$this->MODEL='hltdel';$this->VIEW='hltdel';$this->ID='delcod';$this->enable_sysdoccls=true; $this->CONTROLLER='hltdel';}
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			
			// LIST by TEXT. lista los documentos segun texto
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['deltxt'])?'[~fltrow~]d.deltxt'.chr(9).''.chr(9).$this->prm['deltxt'].chr(9).chr(9).chr(9):'').
																			((isset($this->prm['sysdocclscod'])?$this->prm['sysdocclscod']:'')!=''?'[~fltrow~]dc.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$this->prm['sysdocclscod']).chr(9).chr(9):'').
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_data) );
        break;
    }
  }
}
?>