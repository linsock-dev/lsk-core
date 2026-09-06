<?php
final class logvhcclsController extends tmssController2 {
  function initialize(){ $this->CONTROLLER='logvhccls'; $this->MODEL='logvhccls'; $this->VIEW='logvhccls'; $this->ID='vhcclscod'; $this->OBJTYP='LOG_VCC'; $this->mdl = $this->co_reg->load->model($this->MODEL); }
  function additionalFunctions($lp_act){
    switch( $lp_act ){
        // GETLIST
      case '#17': case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['vhcclstxt'])?'[~fltrow~]vc.vhcclstxt'.chr(9).''.chr(9).$this->prm['vhcclstxt'].chr(9).chr(9).chr(9):'').
                        							'[~fltrow~]vc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
				$lo_rs = $this->mdl->getList($lv_prm,null,null,false);
				return $this->co_reg->document->getJson( $lo_rs );
        break;
    }
  }
}
?>