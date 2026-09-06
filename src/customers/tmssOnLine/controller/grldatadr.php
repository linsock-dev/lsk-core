<?php
final class grldatadrController extends tmssController {
    
	const MODEL = 'grldatadr';					// **************************
	const VIEW  = 'grldatadr';					// **************************
	const ID = 'adrnum';								// **************************
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	private $data_list = array();
  
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
  
	
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$this->data['buscod'] = $this->co_reg->sec->buscod;
		$this->data['adrsrctyp'] = (isset($this->co_reg->request->post['adrsrctyp'])?$this->co_reg->request->post['adrsrctyp']:'');
		$this->data['adrsrccod'] = (isset($this->co_reg->request->post['adrsrccod'])?$this->co_reg->request->post['adrsrccod']:'');
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
      // CHANGE - DISPLAY - COPY
      case '#03':
				$lv_key = array();
				$lv_key = $this->data;
				
				// load object
				$lo_adr = $this->co_reg->load->model( self::MODEL );
				if ( $lo_adr->load($lv_key)==false ) {
					return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
				}
				
				$this->lo_mdl->adr = $lo_adr;
				
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'doc' 	=> $this->co_reg->document,
												'data' 	=> $this->lo_mdl,
												'load'  => $this->co_reg->load,
												'actcod'=> $this->data['actcod']
												);
				$lv_ret = $this->co_reg->load->view( 'grldatadrpop', $lv_prm );		
				return $lv_ret;
				break;
		}
	}
}
?>