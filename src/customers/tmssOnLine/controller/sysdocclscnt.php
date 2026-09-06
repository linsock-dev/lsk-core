<?php
final class sysdocclscntController extends tmssController {
	
	const MODEL = 'sysdocclscnt';
	const VIEW  = 'sysdocclscnt';
	const ID = 'sysdocclscntcod';
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
				$lv_buffer = $lo_post['sysdoccnt'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_docrej_arr = json_decode($lv_buffer,true);
					foreach( $lv_docrej_arr as $lv_row ) {
						$lv_row['sysdocclscod'] = $this->data['sysdocclscod'];
						$lv_row['sysdocclscntatr'] = '<sysdocclscntreq>'.(isset($lv_row['sysdocclscntreq'])?$lv_row['sysdocclscntreq']:'').'</sysdocclscntreq>'.
																					'<sysdocclscntqty>'.(isset($lv_row['sysdocclscntqty'])?$lv_row['sysdocclscntqty']:'').'</sysdocclscntqty>';
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';							
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
						}
					}
				}

				// interlocutores de la clase de documento
				$lo_cntmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_cntmdl->getList( $lv_prm );
				$this->lo_mdl->docclscnt = $lo_rs;				
				
				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->data['actcod'] = '02';				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)
				if ( !isset($this->co_reg->request->post['sysdocclscod']) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro [sysdocclscod].</errtxt>';
				} else {
					$this->data['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'];
				}
				
				// interlocutores de la clase de documento
				$lo_cntmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->data['sysdocclscod'] .chr(9).chr(9));
				$lo_rs = $lo_cntmdl->getList( $lv_prm );
				$this->lo_mdl->docclscnt = $lo_rs;	

				$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
				$this->lo_mdl->objtyp = $this->co_reg->request->post['objtyp'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
        
        
      // GETLIST by TEXT. devuelve la lista según un texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['cnttyptxt'])?'[~fltrow~]ct.sysdocclstxt'.chr(9).''.chr(9).$lp_prm['cnttyptxt'].chr(9).chr(9).chr(9):'').
																			 (isset($lp_prm['sysdocclscod'])?'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lp_prm['sysdocclscod'].chr(9).chr(9):'').
																			'[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				return $this->co_reg->document->getJson( $this->lo_mdl->getList( $lv_prm ) );
				break;

    }
  }
}
?>