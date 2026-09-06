<?php
final class hltargtrzatpController extends tmssController {
  
    
  protected $co_reg;
  private $data = array();
  
  
    
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are for logged users
    // check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

    switch( $lp_act ) {
      // list
      case '':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = 'hltargtrzatp';
        return $lo_vew->index( '00', $lp_prm );
        break;
    }

  }
    
}
?>