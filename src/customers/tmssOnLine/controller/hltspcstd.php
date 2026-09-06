<?php
final class hltspcstdController extends tmssController2 {
  
  function initialize(){$this->MODEL='hltspcstd';$this->VIEW='hltspcstd';$this->ID='spcstdcod';}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
      
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lo_post = $this->co_reg->request->post;
        $lv_spcstdtxt = isset($lo_post['spcstdtxt'])?$lo_post['spcstdtxt']:$this->prm['spcstdtxt'];
        $lv_spccod = isset($lo_post['spccod'])?$lo_post['spccod']:$this->prm['spccod'];
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]st.spccod'.chr(9).'='.chr(9).chr(9).$lv_spccod.chr(9).chr(9).
																			'[~fltrow~]st.spcstdtxt'.chr(9).''.chr(9).$lv_spcstdtxt.chr(9).chr(9).chr(9).
																			'[~fltrow~]st.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				
        $lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>