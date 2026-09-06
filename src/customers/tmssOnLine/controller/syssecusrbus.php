<?php
final class syssecusrbusController extends tmssController {
	const MODEL = 'syssecusrbus';
	const VIEW  = 'syssecusrbus';
	const ID = 'usrcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
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

      // SAVE. graba el documento
      case '#00':        
        if ( $this->lo_mdl->save( $lo_post = $this->co_reg->request->post ) ) {
					$this->data['actcod'] = '02';
          // cargo datos de usuario
          $lo_usrmdl = $this->co_reg->load->model('syssecusr');
          $lo_usrmdl->load( array('usrcod'=>$lo_post[self::ID]) );

          // cargo empresas del sistema (a las cuales tiene permiso el usuario actual)
          $lo_sysbus_rs = $this->lo_mdl->load( array('usrcod'=>$lo_post['usrcod']) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$lo_usrmdl, 'sysbus'=> $lo_sysbus_rs,'actcod'=>$this->data['actcod']) ); 
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualizacion
      case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
        // cargo datos de usuario
        $lo_usrmdl = $this->co_reg->load->model('syssecusr');
        $lo_usrmdl->load( array('usrcod'=>$lo_post[self::ID]) );
        // cargo empresas del sistema (a las cuales tiene permiso el usuario actual)
        $lo_sysbus_rs = $this->lo_mdl->load( array('usrcod'=>$lo_post[self::ID]) );
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$lo_usrmdl, 'sysbus'=> $lo_sysbus_rs,'actcod'=>$this->data['actcod']) ); 
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
      // user - accept terms and conditions
      case '#96':
        $lo_post = $this->co_reg->request->post;
        $this->lo_mdl->setUserAcceptanceTermsOfUse($lo_post['buscod']);
        return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>($this->lo_mdl->errcod?'No se pudo actualizar la aceptación de Términos de Uso y Política de Privacidad del usuario: ':'').$this->lo_mdl->errtxt));
        break;
    }
  }
}
?>