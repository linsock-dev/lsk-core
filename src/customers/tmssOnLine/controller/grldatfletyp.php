<?php
final class grldatfletypController extends tmssController2 {
  
	function initialize(){$this->CONTROLLER='grldatfletyp';$this->MODEL='grldatfletyp';$this->VIEW='grldatfletyp';$this->ID='fletypcod';}
  
	function additionalFunctions($lp_act){
    switch ( $lp_act ) {

    // GETLIST by TEXT. devuelve la lista según un texto
    case '#17': case '#18':
      $this->mdl = $this->co_reg->load->model($this->MODEL);
      $lv_prm = array('vewmaxrec' =>'10',
                      'vewfldflt' => (isset($this->prm['fletyptxt'])?'[~fltrow~]ft.fletyptxt'.chr(9).''.chr(9).$this->prm['fletyptxt'].chr(9).chr(9).chr(9):'').
                                    '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                      );
      $lo_data = $this->mdl->getList($lv_prm);
      return $this->co_reg->document->getJson( $lo_data );
      break;
    }
  }
}
?>