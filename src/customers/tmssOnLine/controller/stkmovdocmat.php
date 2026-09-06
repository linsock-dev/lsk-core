<?php
final class stkmovdocmatController extends tmssController {
  
	const CONTROLLER = 'stkmovdoc';			
	const MODEL = 'stkmovdocmat';				
	const VIEW  = 'stkmovdocmat';				
	const ID = 'stkmovdocmatcod';				
	const OBJTYP ='STK_MOV';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		//$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				$lp_prm['vewfldflt'] .= '[~fltrow~]d.stkmovdoclck'.chr(9).'!='.chr(9).chr(9).'1'.chr(9).chr(9);
        return $lo_vew->index( '00', $lp_prm );
        break;
				
    }

  }	
}
?>