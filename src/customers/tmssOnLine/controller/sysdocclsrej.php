<?php
final class sysdocclsrejController extends tmssController {
	
	const MODEL = 'sysdocclsrej';				// **************************
	const VIEW  = 'sysdocclsrej';				// **************************
	const ID = 'sysdocclsrejcod';				// **************************
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
				$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				$lv_buffer = $this->co_reg->request->post['sysdocrej'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_docrej_arr = json_decode($lv_buffer,true);
					foreach( $lv_docrej_arr as $lv_row ) {
						$lv_row['sysdocclscod'] = $this->data['sysdocclscod'];
						$lv_row['sysdocclsrejatr'] = '<rejord>'.(isset($lv_row['sysdocclsrejord'])?$lv_row['sysdocclsrejord']:'').'</rejord>'.
																					'<rejman>'.(isset($lv_row['sysdocclsrejman'])?$lv_row['sysdocclsrejman']:'').'</rejman>';
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';							
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
						}
					}
				}

				// motivos de rechazo de la clase de documento
				$lo_docrejmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcr.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_docrejmdl->getList( $lv_prm );
				$this->lo_mdl->docrej = $lo_rs;				
				
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->data['actcod'] = '02';				
				return $this->getView();
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)
				if ( !isset($this->co_reg->request->post['sysdocclscod']) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro [sysdocclscod].</errtxt>';
				} else {
					$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				}
				
				// mensajes de la clase de documento
				$lo_docrejmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcr.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_docrejmdl->getList( $lv_prm );
				$this->lo_mdl->docrej = $lo_rs;

				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->getView();
        break;

    }

  }
	
	
	/**
	 * getView
	 */
	private function getView( $lp_vew='' ) {	
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' 	=> $this->co_reg->sec,
										'doc' 	=> $this->co_reg->document,
										'data'  => $this->lo_mdl,
										'load'  => $this->co_reg->load,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( ($lp_vew==''?self::VIEW:$lp_vew) , $lv_prm );		
		return $lv_ret;
	}
}
?>