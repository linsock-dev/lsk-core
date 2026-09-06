<?php
final class sysdocclsfleController extends tmssController {
	
	const MODEL = 'sysdocclsfle';
	const VIEW  = 'sysdocclsfle';
	const ID = 'sysdocclsflecod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
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

			// SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				$this->data['sysdocclscod'] = $lo_post['sysdocclscod'];
        
				if ( $this->lo_mdl->save($lo_post) ) {
          $lo_flemdl = $this->co_reg->load->model( self::MODEL );
          $lv_prm = array('vewfldflt' =>'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
          $lo_rs = $lo_flemdl->getList( $lv_prm );
          $this->lo_mdl->docclsfle = $lo_rs;				

          $this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
          $this->data['actcod'] = '02';
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)
				if ( !isset($this->co_reg->request->post['sysdocclscod']) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [sysdocclscod].') );
				} else {
					$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				}
				
				// interlocutores de la clase de documento
				$lo_flemdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_flemdl->getList( $lv_prm );
				$this->lo_mdl->docclsfle = $lo_rs;	
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
        
        
      // GETLIST by TEXT. devuelve la lista según un texto
      case '#18':
        $lo_post = $this->co_reg->request->post;
				$lv_sysdocclscod = ($lo_post['sysdocclscod']??$lp_prm['sysdocclscod']??'');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['fletyptxt'])?'[~fltrow~]dc.sysdocclstxt'.chr(9).''.chr(9).$lp_prm['fletyptxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_sysdocclscod.chr(9).chr(9).
																			'[~fltrow~]dcf.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				return $this->co_reg->document->getJson( $this->lo_mdl->getList( $lv_prm ) );
				break;
    }
  }
}
?>