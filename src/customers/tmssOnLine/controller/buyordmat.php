<?php
final class buyordmatController extends tmssController {
	const CONTROLLER = 'buyordmat';
	const MODEL = 'buyordmat';
	const VIEW  = 'buyordmat';
	const ID = 'buyordmatcod';
	const OBJTYP ='BUY_ORD_MAT';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();


  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  //INDEX. método principal     
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

        
			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				$lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9);
        return $lo_vew->index( '00', $lp_prm );
        break;
			
    }
  }
}
?>