<?php
final class sysintcnvController extends tmssController {
  
	const MODEL = 'sysintcnv';					// **************************
	const VIEW  = 'sysintcnv';					// **************************
	const ID = 'sysintcnvcod';					// **************************
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

			// LOAD
      case '#': case '#03': case '#02':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' => '[~fltrow~]sysintcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysintcod'].chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				$this->lo_mdl->sysintcnvlst = $lo_rs;
				$this->lo_mdl->sysintcod = $lo_post['sysintcod'];
				return $this->getView();
        break;


      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				$lv_buffer = $lo_post['sysintcnvlst'];
				if ($lv_buffer!='') {
					$i=0;
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_intcnv_arr = json_decode($lv_buffer,true);
					foreach( $lv_intcnv_arr as $lv_row ) {
						$lv_row['sysintcod'] = $lo_post['sysintcod'];
						$lv_row['docsts'] = 'A';							
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt><row>'.$i.'</row>';
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt><row>'.$i.'</row>';
						}
					}
				}
				
				// cargo los valores
				$lv_prm = array('vewfldflt' => '[~fltrow~]sysintcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysintcod'].chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				$this->lo_mdl->sysintcnvlst = $lo_rs;
				return $this->getView();
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
										'sec' => $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data' => $this->lo_mdl,
										'actcod' => $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
}
?>