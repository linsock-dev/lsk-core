<?php
final class sysdocclsrsnController extends tmssController {	
	const MODEL = 'sysdocclsrsn';
	const VIEW  = 'sysdocclsrsn';
	const ID = 'sysdocclsrsncod';
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

			// SAVE
      case '#00':
				$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				$lv_buffer = $this->co_reg->request->post['sysdocrsn'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_docrsn_arr = json_decode($lv_buffer,true);
					foreach( $lv_docrsn_arr as $lv_row ) {
						$lv_row['sysdocclscod'] = $this->data['sysdocclscod'];
						$lv_row['sysdocclsrsnatr'] = '<rsnord>'.(isset($lv_row['sysdocclsrsnord'])?$lv_row['sysdocclsrsnord']:'').'</rsnord>'.
																					'<rsnman>'.(isset($lv_row['sysdocclsrsnman'])?$lv_row['sysdocclsrsnman']:'').'</rsnman>';
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
						}
					}
				}

				// motivos de rechazo de la clase de documento
				$lo_docrsnmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcr.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_docrsnmdl->getList( $lv_prm );
				$this->lo_mdl->docrsn = $lo_rs;				
				
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->data['actcod'] = '02';				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
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
				
				// mensajes de la clase de documento
				$lo_docrsnmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcr.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_docrsnmdl->getList( $lv_prm );
				$this->lo_mdl->docrsn = $lo_rs;

				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
    }
  }
}
?>