<?php
final class syssecperController extends tmssController {
  
	const MODEL = 'syssecper';					// **************************
	const VIEW  = 'syssecper';					// **************************
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
		$lo_busrs = array();
		$lo_secrs = array();
		$lo_oprrs = array();
		$lv_buscod = $this->co_reg->sec->buscod;
		
		// empresas del usuario
		$lo_busmdl = $this->co_reg->load->model('syssecusrbus');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod .chr(9).chr(9));
		$lo_busrs = $lo_busmdl->getList($lv_prm);
			
		// operaciones disponibles
		$lo_oprrs = $this->co_reg->document->getMenu( array('buscod'=>$lv_buscod,'getsep'=>false,'getopr'=>true,'gethde'=>true,'chkper'=>false,'getempfld'=>false) );
		
		// permisos de usuario
		$this->co_reg->request->post['usrgrpcod'] = (isset($this->co_reg->request->post['usrgrpcod'])?$this->co_reg->request->post['usrgrpcod']:'**');
		$this->co_reg->request->post['usrcod'] = (isset($this->co_reg->request->post['usrcod'])?$this->co_reg->request->post['usrcod']:'**');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]p.buscod'.chr(9).'='.chr(9).chr(9).$lv_buscod.chr(9).chr(9).
																	'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['usrcod'].chr(9).chr(9).
																	'[~fltrow~]p.grpcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['usrgrpcod'].chr(9).chr(9));
		$lo_secrs = $this->lo_mdl->getList( $lv_prm );
		
		$this->lo_mdl->buscod = $lv_buscod;
		$this->lo_mdl->usrcod = (isset($this->co_reg->request->post['usrcod'])?$this->co_reg->request->post['usrcod']:'');
		$this->lo_mdl->usrgrpcod = (isset($this->co_reg->request->post['usrgrpcod'])?$this->co_reg->request->post['usrgrpcod']:'');
		$this->lo_mdl->usrbus = $lo_busrs;
		$this->lo_mdl->usrper = $lo_secrs;
		$this->lo_mdl->sysopr = $lo_oprrs;
		
		$lv_prm = array('lang'	=> $this->co_reg->language,
								'input'	=> $this->co_reg->input,
								'sec'		=> $this->co_reg->sec,
								'data'	=> $this->lo_mdl,
								'actcod'=> $this->data['actcod'],
								'model' => self::MODEL
								);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
	
}
?>