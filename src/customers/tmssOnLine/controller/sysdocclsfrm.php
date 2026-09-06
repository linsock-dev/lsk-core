<?php
final class sysdocclsfrmController extends tmssController {
	const CONTROLLER = 'sysdocclsfrm';
	const MODEL = 'sysdocclsfrm';
	const VIEW  = 'sysdocclsfrm';
	const ID = 'sysdocclsfrmcod';
	const OBJTYP ='SYS_CLS';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // control de sesion
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
				$this->data['sysdocclscod'] = $lo_post['sysdocclscod'];
				$lv_buffer = $lo_post['sysdocfrm'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_docrej_arr = json_decode($lv_buffer,true);
					foreach( $lv_docrej_arr as $lv_row ) {
						$lv_row['sysdocclscod'] = $this->data['sysdocclscod'];
            
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
          			return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'row'=>$lv_row['sysdocclstxtcod']) );							
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
          		return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'row'=>$lv_row['sysdocclstxtcod']) );
						}
					}
				}

				// formularios
				$lo_frmmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_frmmdl->getList( $lv_prm );
				$this->lo_mdl->docclsfrm = $lo_rs;			
				
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->data['actcod'] = '02';				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;


      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
				if ( !isset($this->co_reg->request->post['sysdocclscod']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} 
        
        $this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
        
				// formularios
				$lo_frmmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_frmmdl->getList( $lv_prm );
				$this->lo_mdl->docclsfrm = $lo_rs;

				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// LIST. devuelve el formualrio asignado a la clase de documento
      case '#18':
        $lo_post = $this->co_reg->request->post;
        $lv_prm = array('vewfldflt' =>'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9).($lo_post['sysdocclscod']??'').chr(9).chr(9).
																			(isset($lo_post['sysdocfrmcod'])?'[~fltrow~]dcf.sysdocfrmcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocfrmcod'].chr(9).chr(9):'')
												);
        $lo_rs = $this->lo_mdl->getList( $lv_prm );
				return $this->co_reg->document->getJson( $lo_rs );
        break;
    }
  }
}
?>