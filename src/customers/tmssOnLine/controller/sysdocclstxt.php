<?php
final class sysdocclstxtController extends tmssController {
	
	const MODEL = 'sysdocclstxt';
	const VIEW  = 'sysdocclstxt';
	const ID = 'sysdocclstxtcod';
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
				$lv_buffer = $lo_post['sysdoctxt'];
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

				// textos de la clase de documento
				$lo_txtmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dct.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_txtmdl->getList( $lv_prm );
				$this->lo_mdl->docclstxt = $lo_rs;				
				
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->data['actcod'] = '02';				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)
				if ( !isset($this->co_reg->request->post['sysdocclscod']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else {
					$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				}
				
				// interlocutores de la clase de documento
				$lo_txtmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dct.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_txtmdl->getList( $lv_prm );
				$this->lo_mdl->docclstxt = $lo_rs;	

				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
        
        
      // GETLIST by TEXT. devuelve la lista según un texto
      case '#18':
        $lo_post = $this->co_reg->request->post;
				$lv_sysdocclscod = ($lo_post['sysdocclscod']??$lp_prm['sysdocclscod']??'');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['txttyptxt'])?'[~fltrow~]tt.txttyptxt'.chr(9).''.chr(9).$lp_prm['txttyptxt'].chr(9).chr(9).chr(9):'').
																			 ( $lv_sysdocclscod!='' ? '[~fltrow~]dc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_sysdocclscod .chr(9).chr(9):'').
																			'[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
				return $this->co_reg->document->getJson( $lo_rs );
				break;

    }
  }
}
?>