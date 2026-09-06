<?php 
final class tsrmovtypController extends tmssController2 {
  function initialize(){ $this->MODEL='tsrmovtyp'; $this->VIEW='tsrmovtyp'; $this->ID='tsrmovtypcod'; $this->mdl = $this->co_reg->load->model($this->MODEL);}
	function additionalFunctions( $lp_act ){
    switch( $lp_act ){
			// GETLIST by TEXT. lista los documentos por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['tsrmovtyptxt'])?'[~fltrow~]t.tsrmovtyptxt'.chr(9).''.chr(9).$this->prm['tsrmovtyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>