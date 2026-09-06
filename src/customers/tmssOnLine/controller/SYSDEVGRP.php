<?php 
final class sysdevgrpController extends tmssController2 {
  function initialize(){ $this->CONTROLLER='sysdevgrp'; $this->MODEL='sysdevgrp'; $this->VIEW='sysdevgrp'; $this->ID='sysdevgrpcod'; $this->OBJTYP='SYS_DVG'; }
  function additionalFunctions($lp_act){
    $this->mdl = $this->co_reg->load->model($this->MODEL);
    switch( $lp_act ){
			// GETLIST by TEXT. devuelve lista de documentos segun texto
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['sysdevgrptxt'])?'[~fltrow~]d.sysdevgrptxt'.chr(9).''.chr(9).$this->prm['sysdevgrptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
        break;	
    }
  }
}
?>