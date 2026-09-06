<?php
final class finaccplnController extends tmssController2{
	function initialize(){ $this->CONTROLLER='finaccpln'; $this->MODEL='finaccpln'; $this->VIEW='finaccpln'; $this->ID='finaccplncod'; $this->OBJTYP = 'FIN_PLN';  $this->enable_sysdoccls = false; $this->preventCopy = array('finaccplncodext'); }

  function additionalFunctions($lp_act){
  	switch ( $lp_act ) {  
      case '#finaccplnupl':
        $lo_post = $this->co_reg->request->post;
				$lo_data=array();
        $lo_data['finaccplncod'] = $lo_post['finaccplncod']??'';
				return $this->co_reg->document->getView('finaccplnupl', array('data' => $lo_data));
        break;
        
      case '#finaccplnuplchk':
        $lo_post = $this->co_reg->request->post;
        $lo_rs = $this->mdl->uploadCheck($lo_post);
        return $this->co_reg->document->getJson( $lo_rs );
        break;
        
      case '#finaccplnrpt':
        $lo_post = $this->co_reg->request->post;
				$lo_data=array();
        $lo_data['finaccplncod'] = $lo_post['finaccplncod']??'';
				return $this->co_reg->document->getView('finaccplnrpt', array('data' => $lo_data));
        break;
        
      case '#finaccplnrptdat':
        $lo_post = $this->co_reg->request->post;
        $lo_rs = $this->mdl->getReport($lo_post);
        return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
        break;
        
      case '#finaccplnperlist':
        $lo_rs = $this->mdl->getPerList();
        return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
        break;
        
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
								'vewfldflt' =>(isset($this->prm['finaccplntxt'])?'[~fltrow~]p.finaccplntxt'.chr(9).''.chr(9).$this->prm['finaccplntxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);			
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>