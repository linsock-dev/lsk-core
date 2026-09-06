<?php
final class hltprsrlsController extends tmssController2 {

  function initialize(){$this->MODEL='hltprsrls';$this->VIEW='hltprsrls';$this->ID='prsrlscod';}
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// LIST by TEXT. Lista por texto
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['prsrlstxt'])?'[~fltrow~]r.prsrlstxt'.chr(9).''.chr(9).$this->prm['prsrlstxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>