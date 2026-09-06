<?php
final class hltprsspcController extends tmssController2 {
  
	function initialize(){$this->MODEL='hltprsspc';$this->VIEW='hltprsspc';$this->ID='spccod';}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// LIST by TEXT. devuelve lista de documentos
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['spctxt'])?'[~fltrow~]s.spctxt'.chr(9).''.chr(9).$this->prm['spctxt'].chr(9).chr(9).chr(9):'').
                        							(isset($this->prm['prstxt'])?'[~fltrow~]p.prstxt'.chr(9).''.chr(9).$this->prm['prstxt'].chr(9).chr(9).chr(9):'').
                        							(isset($this->prm['spccod'])?'[~fltrow~]ps.spccod'.chr(9).'='.chr(9).chr(9).$this->prm['spccod'].chr(9).chr(9):'').
                        							(isset($this->prm['prscod'])?'[~fltrow~]ps.prscod'.chr(9).'='.chr(9).chr(9).$this->prm['prscod'].chr(9).chr(9):'').
                                      '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                      '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]ps.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>