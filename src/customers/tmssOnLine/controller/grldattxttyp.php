<?php
final class grldattxttypController extends tmssController {
  
	const MODEL = 'grldattxttyp';						
	const VIEW  = 'grldattxttyp';						
	const ID = 'txttypcod';									
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	    
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
					$this->lo_mdl->load( array(	'txttypcod'=>$this->lo_mdl->txttypcod	) );				
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
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
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );										
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->txttypcod = '';																										
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
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
      // LIST by TEXT. lista documentos segun texto
      case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['txttyptxt'])?'[~fltrow~]tt.txttyptxt'.chr(9).''.chr(9).$lp_prm['txttyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
        break;
        
    }

  }

}
?>