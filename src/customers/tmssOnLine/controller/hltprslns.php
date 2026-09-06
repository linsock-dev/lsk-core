<?php
final class hltprslnsController extends tmssController2 {
	function initialize(){$this->CONTROLLER='hltprslqd';$this->MODEL='hltprslns';$this->VIEW='hltprslns';$this->ID='hltlnscod';$this->enable_sysdoccls=true;}
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
      
      // ACCOUNTING. contabiliza el documento
      case '#09':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lo_post = $this->co_reg->request->post;
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );	
        $lo_post['sysdocclscod'] = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'sysdocclscodexp');
        $this->mdl->accounting( $lo_post );
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        break;
        
        
      // GETLIST by TEXT. busca lista por texto
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_post = $this->co_reg->request->post;
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['hltlnstxt']) 	 ?'[~fltrow~]hltlnstxt'.chr(9).''.chr(9).$this->prm['hltlnstxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
        $lo_data = $this->mdl->getList($lv_prm,null,null,false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
				break;
      
      // GETLIST CUOTAS.
      case '#19':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        $lp_prm['mdlcod'] = null;
        $lp_prm['prgcod'] = null;
        $lp_prm['srcmtd'] = 'getListQuota';
        $lp_prm['toolbar'] = false;
        return $lo_vew->index( '00', $this->prm );
        break;
      
    }
  }
}
?>