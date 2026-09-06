<?php
final class fintaxcatController extends tmssController {
	const MODEL = 'fintaxcat';	
	const VIEW  = 'fintaxcat';			
	const ID = 'taxcatcod';				
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
    
  
  // Main method
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
					$this->lo_mdl->load( array('lndcod'=>$this->lo_mdl->lndcod, self::ID=>$this->lo_mdl->taxcatcod	) );		
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

      // NEW                
      case '#01':
				$this->lo_mdl->create();
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( 'lndcod'=>$lp_prm['lndcod'], self::ID=>$lp_prm[self::ID] );																	
				} else {
					$lv_key = array( 'lndcod'=>$lp_prm['lndcod'], self::ID=>$this->co_reg->request->post[self::ID] );								
				}
				
				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.']') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->taxcatcod = '';																							
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );

			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['taxcattxt'])?'[~fltrow~]f.taxcattxt'.chr(9).''.chr(9).$lp_prm['taxcattxt'].chr(9).chr(9).chr(9):'').
                        							 (isset($lp_prm['lndcod'])?'[~fltrow~]f.lndcod'.chr(9).'='.chr(9).chr(9).$lp_prm['lndcod'].chr(9).chr(9):'').
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>