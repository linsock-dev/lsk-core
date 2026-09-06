<?php
final class crmcntmtvController extends tmssController {
	const MODEL = 'crmcntmtv';
	const VIEW  = 'crmcntmtv';
	const ID = 'crmcntmtvcod';
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
			
			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba un documento
			case '#00':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {
					// estado de motivos de contacto
					$lo_crmcntmtvsts = $this->co_reg->load->model('crmcntmtvsts');
					$lv_buffer = (isset($lo_post['crmcntstshottxt'])?$lo_post['crmcntstshottxt']:'');
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_crmcntmtvsts_arr = json_decode($lv_buffer,true);
						foreach( $lv_crmcntmtvsts_arr as $lv_row ) {
							$lv_row['crmcntmtvcod'] = $this->lo_mdl->crmcntmtvcod;
							$lv_row['docsts'] = 'A';
							if ( (isset($lv_row['deleted'])?$lv_row['deleted']:'')=='X' ) {
								if ($lo_crmcntmtvsts->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_crmcntmtvsts->errtyp,'errcod'=>$lo_crmcntmtvsts->errcod,'errtxt'=>$lo_crmcntmtvsts->errtxt));
								}
							} else if ($lo_crmcntmtvsts->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_crmcntmtvsts->errtyp,'errcod'=>$lo_crmcntmtvsts->errcod,'errtxt'=>$lo_crmcntmtvsts->errtxt));
							}
						}
					}
					$this->lo_mdl->load( array(	'crmcntmtvcod'=>$this->lo_mdl->crmcntmtvcod	) );
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        }
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualización
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.']'));
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
				} else if ( $lp_act == '#001' ) {
          
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->crmcntmtvsts; 
          foreach($lv_dat as &$lv_row){
            $lv_row['crmcntmtvstscod'] = ''; 
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          
          $this->lo_mdl->crmcntmtvsts = $lv_dat;
					$this->lo_mdl->crmcntmtvcod = '';
					$this->lo_mdl->crmcntmtvcodext = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			// GETLIST. devuelve la lista según un texto
      case '#17': case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['crmcntmtvtxt'])?'[~fltrow~]m.crmcntmtvtxt'.chr(9).''.chr(9).$lp_prm['crmcntmtvtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]m.crmcnttypcod'.chr(9).'='.chr(9).chr(9).$lp_prm['crmcnttypcod'].chr(9).chr(9).
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
				break;
      
      
      // GET STATUS. Devuelve una lista de las configuraciones de cambio de estado  
      case '#mtvsts':
        $lo_post = $this->co_reg->request->post;
        $lo_cntmtvstsmdl =  $this->lo_cntmtvsts = $this->co_reg->load->model('crmcntmtvsts');
        $lv_prm = array('vewfldflt'	=>'[~fltrow~]ms.crmcntmtvcod'.chr(9).'='.chr(9).chr(9).$lo_post[self::ID].chr(9).chr(9).
																		'[~fltrow~]ms.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				return $this->co_reg->document->getJson($lo_cntmtvstsmdl->getList($lv_prm));
    }
  }
}
?>