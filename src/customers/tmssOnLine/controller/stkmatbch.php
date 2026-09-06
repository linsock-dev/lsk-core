<?php
final class stkmatbchController extends tmssController2 {
  
	function initialize(){$this->CONTROLLER='stkmatbch';$this->MODEL='stkmatbch';$this->VIEW='stkmatbch';$this->ID='matbchcod';$this->enable_sysdoccls=true;}
	
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
          
			// GETLIST by TEXT. lista documentos segun texto
      case '#17':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['matbchcodext'])?'[~fltrow~]b.matbchcodext'.chr(9).''.chr(9).$this->prm['matbchcodext'].chr(9).chr(9).chr(9):'').
                        							 (isset($this->prm['matcod'])?'[~fltrow~]b.matcod'.chr(9).'='.chr(9).chr(9).$this->prm['matcod'].chr(9).chr(9):'').
																			'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }
}
?>