<?php
final class sysfncController extends tmssController {
  
	const MODEL = 'sysfnc';							// **************************
	const VIEW  = 'sysfnc';							// **************************
	const ID = 'sysfnccod';							// **************************
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
					$this->lo_mdl->load( array(	'sysfnccod'=>$this->lo_mdl->sysfnccod	) );				// ********************
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
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																		// ********************
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );										// ********************
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro ['.self::ID.'].</errtxt>';

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->sysfnccod = '';																										// ********************
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
			
			// SHOW DETAIL
			case '#13':
				$lo_post = $this->co_reg->request->post;
				
				$lo_sysopr_rs = array();
				$lo_fncopr_rs = array();
				
				// cargo datos de funcionalidad
				$lo_fncmdl = $this->co_reg->load->model('sysfnc');
				$lo_fncmdl->load( array('sysfnccod'=>$lo_post['sysfnccod']) );	
				
				if ( $lo_fncmdl->sysfnccod!='' ) {
					
					// operaciones habilitadas para la funcionalidad
					$lo_fncoprmdl = $this->co_reg->load->model('sysfncopr');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]f.sysfnccod'.chr(9).'='.chr(9).chr(9).$lo_post['sysfnccod'].chr(9).chr(9));
					$lo_fncopr_rs = $lo_fncoprmdl->getList( $lv_prm );
					
				}
				
				// operaciones disponibles
				$lo_sysopr_rs = $this->co_reg->document->getMenu( array('getall'=>true,'getsep'=>false,'getopr'=>true,'gethde'=>true,'chkper'=>false,'getempfld'=>false) );
				
				$this->lo_mdl->fncopr = $lo_fncopr_rs;
				$this->lo_mdl->sysopr = $lo_sysopr_rs;
				$this->lo_mdl->sysfnc = $lo_fncmdl;
				
				$lv_prm = array('lang'	=> $this->co_reg->language,
												'input'	=> $this->co_reg->input,
												'sec'		=> $this->co_reg->sec,
												'data'	=> $this->lo_mdl,
												'actcod'=> $this->data['actcod'],
												'model' => self::MODEL
												);
				$lv_ret = $this->co_reg->load->view( 'sysfncshpdtl', $lv_prm );
				return $lv_ret;
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
										'load'  => $this->co_reg->load,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );		
		return $lv_ret;
	}
}
?>