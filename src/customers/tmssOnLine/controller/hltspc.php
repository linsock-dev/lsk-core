<?php
final class hltspcController extends tmssController2 {
	
  function initialize(){$this->MODEL='hltspc';$this->VIEW='hltspc';$this->ID='spccod';}
  
  function afterLoad (){
    $this->mdl->hltprsrlscod = $this->co_reg->document->getTagValue( html_entity_decode(strtolower($this->mdl->spcatrval001)), 'hltprsrlscod' );
  }
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lo_post = $this->co_reg->request->post;
        $lv_spctxt = isset($lo_post['spctxt'])?$lo_post['spctxt']:$this->prm['spctxt'];
        
				$lv_prm = array('vewmaxrec' =>'10',
          							'vewfldflt' =>'[~fltrow~]spctxt'.chr(9).''.chr(9).$lv_spctxt.chr(9).chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>