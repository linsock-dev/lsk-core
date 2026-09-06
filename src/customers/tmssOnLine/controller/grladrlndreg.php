<?php
final class grladrlndregController extends tmssController {
  
	const MODEL = 'grladrlndreg';						// **************************
	const VIEW  = 'grladrlndreg';						// **************************
	const ID = 'lndregcod';									// **************************
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
        return $lo_vew->index( '00', $lp_prm );
        break;
				
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['lndregtxt'])?'[~fltrow~]r.lndregtxt'.chr(9).''.chr(9).$lp_prm['lndregtxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['lndcod'])?'[~fltrow~]l.lndcod'.chr(9).'='.chr(9).chr(9).$lp_prm['lndcod'].chr(9).chr(9):'').
																			'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_data) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
				}
        break;
    }

  }
}
?>