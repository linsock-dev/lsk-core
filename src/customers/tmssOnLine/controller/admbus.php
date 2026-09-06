<?php
final class admbusController extends tmssController {
	const CONTROLLER = 'admbus';
	const MODEL = 'admbus';
	const VIEW  = 'admbus';
	const ID = 'buscod';
	const OBJTYP = 'ADM_BUS';
  protected $co_reg;
	private $lo_mdl;
  private $data = array(); 
  
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  // INDEX. metodo principal de la clase
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

			// LIST. lista los objetos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
      
      // SAVE. graba un objeto
      case '#00':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array('buscod'=>$this->lo_mdl->buscod	) );
					
          $this->lo_mdl->sysdoccls = $this->co_reg->load->model('sysdoccls');
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
      
      // CHANGE - DISPLAY. carga un objeto en modo modificacion o visualización
      case '#02': case '#03':
				$lv_key = array( self::ID=> (isset($lp_prm[self::ID])?$lp_prm[self::ID]:$this->co_reg->request->post[self::ID]) );
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// CLASE DE DOCUMENTO. se carga info de la clase de documento
				$this->lo_mdl->sysdoccls = $this->co_reg->load->model('sysdoccls');
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        break;
		}
  }
}
?>