<?php
final class logvhcController extends tmssController2 {
  function initialize(){ $this->CONTROLLER='logvhc'; $this->MODEL='logvhc'; $this->VIEW='logvhc'; $this->ID='vhccod'; $this->OBJTYP='LOG_VHC'; $this->mdl = $this->co_reg->load->model($this->MODEL);}
  function additionalFunctions($lp_act){
    switch( $lp_act ){
  		// LIST by TEXT. lista documentos segun texto
      case '#18': case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['vhctxt'])?'[~fltrow~]v.vhctxt'.chr(9).''.chr(9).$this->prm['vhctxt'].chr(9).chr(9).chr(9):'').
																			(isset($this->prm['vhccodext'])?'[~fltrow~]v.vhccodext'.chr(9).'='.chr(9).chr(9).$this->prm['vhccodext'].chr(9).chr(9):'').
																			'[~fltrow~]v.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_rs );
        break;
    }
  }
}
?>