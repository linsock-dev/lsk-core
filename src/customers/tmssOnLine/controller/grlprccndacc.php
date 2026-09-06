<?php 
final class grlprccndaccController extends tmssController {
  
	const MODEL = 'grlprccndacc';					
	const VIEW  = 'grlprccndacc';					
	const ID = 'prccndacccod';							
	const OBJTYP ='SYS_PCA';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  // main method        
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
				$lo_dat = $this->co_reg->request->post;
				
        if ( $this->lo_mdl->save( $lo_dat ) ) {
					// cargo datos del documento
					$this->lo_mdl->load( array('prccndacccod'=>$this->lo_mdl->prccndacccod) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
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
					$lv_key = array( self::ID=>$lp_prm[self::ID] );														
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID]);
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->prccndacccod = '';																							
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			
			// DELETE
      case '#04':
      $lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['prccndacctxt'])?'[~fltrow~]pca.prccndacctxt'.chr(9).''.chr(9).$lp_prm['prccndacctxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]pca.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												); 
				$lo_data = $this->lo_mdl->getList($lv_prm);
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_data) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json_');
					return $lv_retjsn;
				} else {
          return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
				}
        break;

    }

  }
}
?>