<?php
final class sptptnaccController extends tmssController {
	const CONTROLLER = 'sptptnacc';
	const MODEL = 'sptptnacc';
	const VIEW  = 'sptptnacc';
	const ID = 'ptncod';
	const OBJTYP ='SPT_PTN';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve la vista de control de acceso
			case '#': case '#08':
				$this->lo_mdl->acctyp = $lp_prm['acctyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
      
			// CHECK ACCESS. verifica el acceso de un socio
			case '#13': 
        $this->lo_mdl->check();
				return $this->co_reg->document->getJson( $this->lo_mdl->getData() );
			break;			
    }
  }
}
?>