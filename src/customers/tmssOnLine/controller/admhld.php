<?php
final class admhldController extends tmssController2 {
  function initialize(){ $this->MODEL='admhld'; $this->VIEW='admhld'; $this->ID='hldcod'; }
	
  function copyDocument( $lp_initialize=array(), $lp_authCheck=true, $lp_getJson=false ){
    array_push( $lp_initialize, 'hldmovcod' );
    return parent::copyDocument( $lp_getJson, $lp_authCheck, $lp_initialize );
  }
  
  function additionalFunctions($lp_act){
    switch( $lp_act ){
      // MONTHLY LIST. lista feriados del mes
      case '#23':
        $lo_hldmovmdl = $this->co_reg->load->model('admhldmov');
        $lv_prm = array('vewmaxrec' =>'100',
                        'vewfldflt' =>'[~fltrow~]hm.hldmovday'.chr(9).'BT'.chr(9).chr(9).$this->post['strdte'].chr(9).$this->post['enddte'].chr(9).
                                      '[~fltrow~]h.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                        'vewfldord' => 'hm.hldmovday' );
        $lo_data = $lo_hldmovmdl->getList( $lv_prm );
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }    
  }
}
?>