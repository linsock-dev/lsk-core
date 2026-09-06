<?php
final class sysfncoprController extends tmssController {
  
	const MODEL = 'sysfncopr';					// **************************
	const VIEW  = 'sysfncopr';					// **************************
	const ID = '';											// **************************
  protected $co_reg;
	protected $co_usr;
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
      case '#': case '#02': case '#03': case '#08':
				return $this->getView();
        break;

      // SAVE
      case '#00':			
        if ( $this->lo_mdl->save() ) {
					$this->data['actcod'] = '02';
					return $this->getView();
        } else {
					$this->data['actcod'] = '02';
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
		$lo_sysopr_rs = array();
		$lo_fncopr_rs = array();
		
		// cargo datos de funcionalidad
		$lo_fncmdl = $this->co_reg->load->model('sysfnc');
		$lo_fncmdl->load( array('sysfnccod'=>$this->co_reg->request->post['sysfnccod']) );	
		
		if ( $lo_fncmdl->sysfnccod!='' ) {
			
			// operaciones habilitadas para la funcionalidad
			$lv_prm = array('vewfldflt' =>'[~fltrow~]f.sysfnccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['sysfnccod'].chr(9).chr(9));
			$lo_fncopr_rs = $this->lo_mdl->getList( $lv_prm );
			
		}
		
		// operaciones disponibles
		$lo_sysopr_rs = $this->co_reg->document->getMenu( array('getall'=>true,'getsep'=>false,'getopr'=>true,'gethde'=>true,'chkper'=>false,'getempfld'=>false) );
		
		$this->lo_mdl->fncopr = $lo_fncopr_rs;
		$this->lo_mdl->sysopr = $lo_sysopr_rs;
		$this->lo_mdl->sysfnc = $lo_fncmdl;
		
		$lv_prm = array('lang'	=> $this->co_reg->language,
										'input'	=> $this->co_reg->input,
										'sec'		=> $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data'	=> $this->lo_mdl,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
}
?>