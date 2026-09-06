<?php
final class sysappiaamdlController extends tmssController2 {
  function initialize(){ $this->MODEL='sysappiaamdl'; $this->VIEW='sysappiaamdl'; $this->ID='sysappiaamdlcod'; }

  function additionalFunctions($lp_act){
    switch( $lp_act ){
			// GETLIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewfldflt' => (isset($this->prm['sysappiaamdltxt'])?'[~fltrow~]iam.sysappiaamdltxt'.chr(9).''.chr(9).$this->prm['sysappiaamdltxt'].chr(9).chr(9).chr(9):'').
                                        '[~fltrow~]iam.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
      case '#execute':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->mdl->load( array('sysappiaamdlcod'=>$this->post['sysappiaamdlcod']) );
        $lv_ret = $this->mdl->execute( $this->post['key'], $this->post['prompt'], '' );
        return $this->co_reg->document->getJson( $lv_ret );
        break;
    }
  }
  
}
?>