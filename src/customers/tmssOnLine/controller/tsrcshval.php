<?php
final class tsrcshvalController extends tmssController {
	const CONTROLLER = 'tsrcshval';
	const MODEL = 'tsrcshval';
	const ID = 'tsrcshvalcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  //INDEX. metodo principal
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
 
      // LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['cshcod'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]cv.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
        																											 '[~fltrow~]cv.cshcod'.chr(9).'='.chr(9).chr(9).$lp_prm['cshcod'].chr(9).chr(9); }
        return $lo_vew->index( '00', $lp_prm );
        break;

    }
  }
}
?>