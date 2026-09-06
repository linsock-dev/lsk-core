<?php
final class syssecperautController extends tmssController {
  
	const MODEL = 'syssecperaut';				// **************************
	const VIEW  = 'syssecperaut';				// **************************
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
				$this->lo_mdl->buscod=$this->co_reg->sec->buscod;
				$this->co_reg->request->post['docsts'] = 'A';
				$lv_buffer = $this->co_reg->request->post['peraut'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_peraut_arr = json_decode($lv_buffer,true);
					foreach( $lv_peraut_arr as $lv_row ) {
						$this->co_reg->request->post['objtypcod'] = $lv_row['objtypcod'];
						$this->co_reg->request->post['autcod'] = $lv_row['autcod'];
						if ( isset($lv_row['key']) && $lv_row['key']!='' ) {
							$lv_key_arr = explode(chr(9),$lv_row['key']);
							$this->co_reg->request->post['objtypcod'] = $lv_key_arr[0];
							$this->co_reg->request->post['autcod'] = $lv_key_arr[1];
							if ( isset($lv_row['deleted']) ) {
								if ($this->lo_mdl->delete()==false) {
									return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';							
								}
							} else if ($lv_key_arr[0]!=$lv_row['objtypcod'] || $lv_key_arr[1]!=$lv_row['autcod']) {
								if ($this->lo_mdl->delete()==false) {
									return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
								} else {
									$this->co_reg->request->post['objtypcod'] = $lv_row['objtypcod'];
									$this->co_reg->request->post['autcod'] = $lv_row['autcod'];
									if ($this->lo_mdl->save()==false) {
										return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
									}
								}
							}
						} else if ($this->lo_mdl->save()==false) {
							return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
						}
					}
				}
				$this->data['actcod'] = '02';
				return $this->getView();
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
		
		// objetos de autorización
		$this->co_reg->request->post['usrgrpcod'] = (isset($this->co_reg->request->post['usrgrpcod'])?$this->co_reg->request->post['usrgrpcod']:'**');
		$this->co_reg->request->post['usrcod'] = (isset($this->co_reg->request->post['usrcod'])?$this->co_reg->request->post['usrcod']:'**');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['usrcod'].chr(9).chr(9).
																	'[~fltrow~]p.grpcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['usrgrpcod'].chr(9).chr(9));
		$lo_secrs = $this->lo_mdl->getList( $lv_prm );
		
		$this->lo_mdl->buscod = $lv_buscod;
		$this->lo_mdl->usrcod = (isset($this->co_reg->request->post['usrcod'])?$this->co_reg->request->post['usrcod']:'');
		$this->lo_mdl->usrgrpcod = (isset($this->co_reg->request->post['usrgrpcod'])?$this->co_reg->request->post['usrgrpcod']:'');
		$this->lo_mdl->usrbus = $lo_busrs;
		$this->lo_mdl->autobj = $lo_secrs;
		
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