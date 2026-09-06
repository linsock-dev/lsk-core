<?php
final class stkmattypController extends tmssController {
  
	const MODEL = 'stkmattyp';					// **************************
	const VIEW  = 'stkmattyp';					// **************************
	const ID = 'mattypcod';							// **************************
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
				
      // SAVE
      case '#00':        
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	'mattypcod'=>$this->lo_mdl->mattypcod	) );	// **************************
					return $this->getView();
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        } 
        break;
				
      // NEW
      case '#01':
				$this->lo_mdl->create();
				return $this->getView();
				break;
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
				$lv_key = array();
				
				// get param (KEY)
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );													// **************************
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );				// **************************
				}
				
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro ['.self::ID.'].</errtxt>';
					
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
					
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->mattypcod = '';																					// **************************
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->getView();
        break;
				
			// DELETE
      case '#04':
        if ( $this->lo_mdl->delete() ) {
					return '<errcod></errcod><errtxt></errtxt>';
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        }
        break;
    }
  }
	
	
	/**
	 * getView
	 * send screen to client browser
	 */
	private function getView() {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' 	=> $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data' 	=> $this->lo_mdl,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
}
?>