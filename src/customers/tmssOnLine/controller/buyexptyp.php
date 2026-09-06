<?php
final class buyexptypController extends tmssController2 {
  function initialize(){ $this->CONTROLLER='buyexptyp'; $this->MODEL='buyexptyp'; $this->VIEW='buyexptyp'; $this->ID='buyexptypcod'; $this->OBJTYP='BUY_EXT'; $this->mdl = $this->co_reg->load->model($this->MODEL);}
  function additionalFunctions($lp_act){
    switch( $lp_act ){
			// GETLIST by TEXT. devuelve lista de documentos segun texto
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['buyexptyptxt'])?'[~fltrow~]t.buyexptyptxt'.chr(9).''.chr(9).$this->prm['buyexptyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$this->data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('data'=>$this->data) );
        break;	
    }
  }
}
?>