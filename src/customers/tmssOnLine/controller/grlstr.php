<?php
final class grlstrController extends tmssController {
  
    
	const CONTROLLER = 'grlstr';
	const MODEL = 'grlstr';							// **************************
	const VIEW  = 'grlstr';							// **************************
	const ID = '';											// **************************
	const OBJTYP ='GRL_STR';
  protected $co_reg;
	private $lo_mdl;
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
		
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      // pantalla x default
      case '#':
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'doc'		=> $this->co_reg->document,
												'data' 	=> $this->lo_mdl,
												'load'  => $this->co_reg->load,
												'actcod'=> $this->data['actcod']
												);
				$lv_ret = $this->co_reg->load->view( 'grlstr', $lv_prm );		
				return $lv_ret;
        break;
				
			// vertical menu (menú de módulo)
			case '#18':
        // obtengo opciones de menú
        $lv_mnu = array();
        $lv_mnu = $this->co_reg->document->getMenu( array( 'getsep'=>false, 'chkper'=>true, 'getopr'=>false, 'mdlcod'=>$lp_prm['mdlcod'] ) );
				
        // preparo parámetros
        $lv_prm = array('mnu' => $lv_mnu,
												'lang' => $this->co_reg->language,
												'data' => array( 'mdlcod'=>$lp_prm['mdlcod'] )
												);
        
        // muestro pantalla
        $lv_buffer = $this->co_reg->load->view( 'sysdocmnumdl', $lv_prm );
        return $lv_buffer;
				break;
    }

  }
    
}
?>