<?php
final class syssecdrtgrpasgController extends tmssController {
	const MODEL = 'syssecdrtgrpasg';
	const VIEW  = 'syssecdrtgrpasg';
	const ID = 'syssecdrtgrpasgcod';
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

			// SAVE. graba los documentos
      case '#00':
        $this->data['srcobjtyp'] = $this->co_reg->request->post['srcobjtyp'];
        $this->data['srcobjcod001'] = $this->co_reg->request->post['srcobjcod001'];
				
        $lv_buffer = $this->co_reg->request->post['grpasg'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_grpasg_arr = json_decode($lv_buffer,true);
					foreach( $lv_grpasg_arr as $lv_row ) {
						$lv_row['srcobjtyp'] = $this->data['srcobjtyp'];
            $lv_row['srcobjcod001'] = $this->data['srcobjcod001'];
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
				
				// asignacion de grupos de directivas
				$lo_grpasgmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dga.srcobjtyp'.chr(9).'='.chr(9).chr(9).$this->data['srcobjtyp'].chr(9).chr(9).
                        							'[~fltrow~]dga.srcobjcod001'.chr(9).'='.chr(9).chr(9).$this->data['srcobjcod001'].chr(9).chr(9)
                       );
				$lo_rs = $lo_grpasgmdl->getList( $lv_prm, array('srcobjtyp'=>$this->data['srcobjtyp']) );
				$this->lo_mdl->grpasg = $lo_rs;				
        
				$this->data['actcod'] = '02';				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
      // CHANGE - DISPLAY. devuelve la vista en modo visualizacion o modificación
      case '#02': case '#03':
				$lv_key = array();
				$lo_post = $this->co_reg->request->post;
				
				// get param (KEY)
				if ( !isset($lo_post['srcobjtyp']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [srcobjtyp].') );
				} else {
					$this->data['srcobjtyp'] = $lo_post['srcobjtyp'];
				}
        if ( !isset($lo_post['srcobjcod001']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [srcobjcod001].') );
				} else {
					$this->data['srcobjcod001'] = $lo_post['srcobjcod001'];
				}
				
				// asignacion de grupos de directivas
				$lo_grpasgmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dga.srcobjtyp'.chr(9).'='.chr(9).chr(9).$this->data['srcobjtyp'].chr(9).chr(9).
                        							'[~fltrow~]dga.srcobjcod001'.chr(9).'='.chr(9).chr(9).$this->data['srcobjcod001'].chr(9).chr(9)
                       );
				$lo_rs = $lo_grpasgmdl->getList( $lv_prm, array('srcobjtyp'=>$this->data['srcobjtyp']) );
				$this->lo_mdl->grpasg = $lo_rs;	
        $this->lo_mdl->srcobjtyp = $this->data['srcobjtyp'];
        $this->lo_mdl->srcobjcod001 = $this->data['srcobjcod001'];
          
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
    }
  }
}
?>