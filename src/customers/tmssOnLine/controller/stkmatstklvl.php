<?php
final class stkmatstklvlController extends tmssController {
	
	const MODEL = 'stkmatstklvl';				// **************************
	const VIEW  = 'stkmatstklvl';				// **************************
	const ID = 'stkmatlvlcod';					// **************************
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
				$this->data['matcod'] = $this->co_reg->request->post['matcod'];
				$lv_buffer = $this->co_reg->request->post['matstklvl'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_matlvl_arr = json_decode($lv_buffer,true);
					foreach( $lv_matlvl_arr as $lv_row ) {
						$lv_row['matcod'] = $this->data['matcod'];
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
				
				// niveles de stock
				$lo_matlvl_mdl = $this->co_reg->load->model('stkmatstklvl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]l.matcod'.chr(9).'='.chr(9).chr(9).$this->data['matcod'].chr(9).chr(9) );
				$lo_rs = $lo_matlvl_mdl->getList( $lv_prm );
				$this->lo_mdl->matstklvllst = $lo_rs;
				
				// tipos de objetos
				$lo_objtyp_mdl = $this->co_reg->load->model('sysobjtyp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_objtyp_mdl->getList( $lv_prm );
				$this->lo_mdl->stkobjtypdef = $lo_rs;
				
				$this->lo_mdl->matcod = $this->data['matcod'];
				$this->data['actcod'] = '02';
				
				return $this->getView();
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( !isset($this->co_reg->request->post['matcod']) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro [usrcod].</errtxt>';
				} else {
					$this->data['matcod'] = $this->co_reg->request->post['matcod'];
				}
				
				// niveles de stock
				$lo_matlvl_mdl = $this->co_reg->load->model('stkmatstklvl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]l.matcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['matcod'].chr(9).chr(9) );
				$lo_rs = $lo_matlvl_mdl->getList($lv_prm);
				$this->lo_mdl->matstklvllst = $lo_rs;
				
				// tipos de objetos
				$lo_objtyp_mdl = $this->co_reg->load->model('sysobjtyp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_objtyp_mdl->getList( $lv_prm );
				$this->lo_mdl->stkobjtypdef = $lo_rs;
				
				$this->lo_mdl->matcod = $this->data['matcod'];
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
										'doc'		=> $this->co_reg->document,
										'data'  => $this->lo_mdl,
										'load'  => $this->co_reg->load,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( ($lp_vew==''?self::VIEW:$lp_vew) , $lv_prm );		
		return $lv_ret;
	}
}
?>