<?php
final class hltprslqdautController extends tmssController2 {
	
  function initialize(){$this->CONTROLLER='hltprslqdaut';$this->MODEL='hltprslqdaut';$this->VIEW='hltprslqdaut';$this->ID='hltprslqdgrpcod';$this->enable_sysdoccls=true;}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
      
			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->mdl->accounting();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        break;
			
      
			// VER DETALLE. devuelve el detalle de las liquidaciones de prestadores
			case '#10': case '#11':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->data['actcod'] = $this->act;
				$lo_post = $this->co_reg->request->post;
				$this->mdl->opnlqd = array();
				$this->mdl->grpcuscod = $lo_post['grpcuscod'];

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$this->mdl->sysdoccls = $lo_docclsmdl;

				
				$lo_prslqdmdl = $this->co_reg->load->model('hltprslqdaut');
        $lv_prm = array('hltprslqdgrpcod'=>$lo_post['hltprslqdgrpcod'],
                        'hltprslqdgrpstrdte'=>$lo_post['hltprslqdgrpstrdte'],
                        'hltprslqdgrpenddte'=>$lo_post['hltprslqdgrpenddte'],
                        'sysdocclscod'=>$lo_post['sysdocclscod'],
                        'paymthcod'=>$lo_post['paymthcod'],
                        'bnkcod'=>$lo_post['bnkcod'],
                        'cuscod'=>$lo_post['cuscod']);
        // obtengo liquidaciones de prestadores no liquidadas
        if ($lp_act=='#10'){
          $lv_fldflt = array('vewfldflt' => ($lo_post['sysdocclscodprs']??''!='')?'[~fltrow~]c.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscodprs'].chr(9).chr(9):'');		
					$lo_rs = $lo_prslqdmdl->getOpenLiquidations( $lv_fldflt, $lv_prm );
        }
        // obtengo liquidaciones de prestadores liquidadas
        if ($lp_act=='#11'){
					$lo_rs = $lo_prslqdmdl->getLiquidations(array(), $lv_prm );
        }
				$this->mdl->opnlqd = $lo_rs;
				$this->mdl->bcksec = $this->prm['bcksec'];

        return $this->co_reg->document->getView( 'hltprslqdautdet', array('data'=>$this->mdl,'actcod'=>$this->data['actcod']) );
				break;
    }
  }
  
  function afterCreate(){
     $this->getmanlqddoccls();
 	}

  function beforeSave( $lp_dat ){
    $lp_dat['hltprslqdids'] = $lp_dat['opnlqdids'];
    return $lp_dat;
 	}

  function afterload(){
    $this->getmanlqddoccls();
    
 	}

  private function getmanlqddoccls() {
   // recupero la configuracion de la clase de documento de liquidacion individual
      $lo_lqddocclsmdl = $this->co_reg->load->model('sysdoccls');
      $lv_lqdsysdocclscod = $this->co_reg->document->getTagValue($this->mdl->sysdoccls->sysdocclsatr,'lqdsysdocclscod');
      $lo_lqddocclsmdl->load( array('sysdocclscod'=>$lv_lqdsysdocclscod) );
      $this->mdl->lqdsysdoccls = $lo_lqddocclsmdl;    
	}
}
?>