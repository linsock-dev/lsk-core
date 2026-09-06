<?php
final class spttrfverController extends tmssController {
  
	const MODEL = 'spttrfver';					// **************************
	const VIEW  = 'spttrfver';					// **************************
	const ID = 'spttrfvercod';					// **************************
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
				$lo_post = $this->co_reg->request->post;
				
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array(	'spttrfvercod'=>$this->lo_mdl->spttrfvercod	) );				// ********************
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
        } 
        break;
			
      // NEW                
			case '#01':

				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->spttrfcod = $lo_post['spttrfcod'];
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
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
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
	
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->spttrfvercod = '';																										// ********************
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->getView();
        break;
				
			// DELETE
      case '#04':
				$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
      // SHOW VIEW
			case '#13':
				$lo_post = $this->co_reg->request->post;

				$this->lo_mdl->load($lo_post);

				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc'=> $this->co_reg->document,
												'data' => $this->lo_mdl,
												'sysseclnk' => $this->co_reg->load->controller('sysseclnk'),
												'actcod' => $this->data['actcod'],
												);
        return $this->co_reg->document->getView( 'spttrfver', $lv_prm );
			break;
			
			//LISTA DE VERSIONES
			case '#29':
				$lo_post = $this->co_reg->request->post;

				$lv_prm = array('vewfldflt' => (isset($lo_post['spttrfcod'])?'[~fltrow~]t.spttrfcod'.chr(9).''.chr(9).$lo_post['spttrfcod'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
			break;
		}

  }

	// getView. send screen to client browser
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