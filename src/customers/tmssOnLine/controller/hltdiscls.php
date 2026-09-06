<?php
final class hltdisclsController extends tmssController2 {
  
  function initialize(){$this->MODEL='hltdiscls';$this->VIEW='hltdiscls';$this->ID='hltdisclscod';}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
	
			// GETLIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lo_post = $this->co_reg->request->post;
        
        $lv_dat = isset($lo_post['hltdisclstxt']) ? $lo_post['hltdisclstxt'] : $this->prm['hltdisclstxt']; 
      
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lv_dat)?'[~fltrow~]hltdisclstxt'.chr(9).''.chr(9).$lv_dat.chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_data) );
        break;
    }
  }
}
?>