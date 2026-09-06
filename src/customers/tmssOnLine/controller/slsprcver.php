<?php
final class slsprcverController extends tmssController {
	const CONTROLLER = 'slsprcver';
	const MODEL = 'slsprcver';
	const VIEW  = 'slsprcver';
	const ID = 'slsprclstvercod';
	const ID2 = 'slsprclstcod';
	const OBJTYP ='SLS_PRV';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  //INDEX. metodo principal
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
			
        
			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;		
        $lv_act = ( isset($lo_post[self::ID]) && !empty($lo_post[self::ID]) ? '02' : '01' );
        if ( $this->lo_mdl->save( $lo_post ) ) {	
          //obtengo la version
          $this->lo_mdl->load( array('slsprclstvercod'=>$this->lo_mdl->slsprclstvercod,'slsprclstcod'=>$lo_post['slsprclstcod']) );
          
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod))) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // NEW. crea un documento
			case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->slsprclstcod = $lo_post['slsprclstcod'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array();
				
				// get param (KEY)
				$lv_key = array( self::ID=>$lo_post[self::ID], self::ID2=>$lo_post[self::ID2] );
				
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $this->lo_mdl->slsprclstvercod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. elimina un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) ); 
				break;
			
			
			// LIST. lista los documentos
			case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lo_post['slsprclstcod'].chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'pv.slsprclststrdte desc'
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
				break;
			
    }
  }
}
?>