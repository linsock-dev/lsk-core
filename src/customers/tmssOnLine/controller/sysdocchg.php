<?php
final class sysdocchgController extends tmssController {
	const MODEL = 'sysdocchg';
	const VIEW  = 'sysdocchglst';
	const ID = 'sysdocchgcod';
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
			// SAVE. modifica un log de cambio (solo disponible para quien lo grabo originalmente)
			case '#12':
				$lo_post = $this->co_reg->request->post;
				if( $this->lo_mdl->updateAttibute( $lo_post ) ) {
					// se vuelve a cargar el detalle
					$lv_key = array('chgdocsrctyp'=>$lp_prm['chgdocsrctyp'],'chgdocsrccod'=>$lp_prm['chgdocsrccod'] );
					$lo_rs = $this->lo_mdl->getDetail($lv_key);
					$this->lo_mdl->chglst = $lo_rs;
					$this->lo_mdl->chgdocsrctyp = $lp_prm['chgdocsrctyp'];
					$this->lo_mdl->chgdocsrccod = $lp_prm['chgdocsrccod'];
					$this->lo_mdl->main = (isset($lp_prm['main'])?$lp_prm['main']:'');
					
					return $this->co_reg->document->getView( self::VIEW , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				} else  {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				break;
			
			
      // DISPLAY LOG. muestra el log de cambios completo
      case '#13':
				$lv_key = array('chgdocsrctyp'=>$lp_prm['chgdocsrctyp'],'chgdocsrccod'=>$lp_prm['chgdocsrccod'] );
				$lo_rs = $this->lo_mdl->getDetail($lv_key);
				$this->lo_mdl->chglst = $lo_rs;
				$this->lo_mdl->chgdocsrctyp = $lp_prm['chgdocsrctyp'];
				$this->lo_mdl->chgdocsrccod = $lp_prm['chgdocsrccod'];
				$this->lo_mdl->main = (isset($lp_prm['main'])?$lp_prm['main']:'');
				return $this->co_reg->document->getView( self::VIEW , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;				
			
    }
  }

}
?>