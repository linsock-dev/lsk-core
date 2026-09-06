<?php
final class syslngtxtController extends tmssController {
  
	const MODEL = 'syslngtxt';					// **************************
	const VIEW  = 'syslngtxt';					// **************************
	const ID = 'lngvar';								// **************************
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
			
      // SAVE
      case '#00':        
        $this->lo_mdl->save();
				return '<errtyp>'.$this->lo_mdl->errtyp.'</errcod><errtyp>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        break;
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return '<errtyp>'.$this->lo_mdl->errtyp.'</errcod><errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        break;

    }
  }
}
?>