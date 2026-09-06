<?php
final class sysdocclsController extends tmssController {
	const MODEL = 'sysdoccls';					
	const VIEW  = 'sysdoccls';					
	const ID = 'sysdocclscod';					
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

			// LIST
      case '#': case '#08': 
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				$lp_prm['srcmtd'] = 'getListExt';
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// CONFIGURACION. Convierte los campos del formulario en datos para POST
				$lo_post['sysdocclsatr'] = '';
				$lv_buffer = (isset($lo_post['sysdocclsatr_dat'])?$lo_post['sysdocclsatr_dat']:'');
				if ($lv_buffer!='') {
					$lv_docatr_arr = json_decode(html_entity_decode($lv_buffer),true);
					foreach( $lv_docatr_arr as $lv_row ) {
						$lo_post['sysdocclsatr'] .= '<'.$lv_row['cod'].'>'.$lv_row['val'].'</'.$lv_row['cod'].'>';
					}
				}
				
				// ATRIBUTOS. Convierte los campos del formulario en datos para POST
				$lo_post['sysdocclsatrusr'] = '';
				$lv_buffer = (isset($lo_post['sysdocclsatrusr_dat'])?$lo_post['sysdocclsatrusr_dat']:'');
				if ($lv_buffer!='') {
					$lv_docatr_arr = json_decode(html_entity_decode($lv_buffer),true);
					foreach( $lv_docatr_arr as $lv_row ) {
						$lo_post['sysdocclsatrusr'] .= '<'.$lv_row['cod'].'>'.$lv_row['val'].'</'.$lv_row['cod'].'>';
					}
				}
				
				// graba los datos
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array(	'sysdocclscod'=>$this->lo_mdl->sysdocclscod	) );
					
					// ATRIBUTOS. obtengo lista completa de atributos de la clase de documento
					$lo_atrmdl = $this->co_reg->load->model('sysdocclsatr');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]objtyp'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->objtyp.chr(9).chr(9));
					$this->lo_mdl->sysdocclsatrlst = $lo_atrmdl->getList($lv_prm);
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW
      case '#01':
				$this->lo_mdl->create();
				$this->lo_mdl->sysdocclsatrlst = array();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
				$lv_key = array();
				$lo_post = $this->co_reg->request->post;				
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );         
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->sysdocclscod = '';																										
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// ATRIBUTOS. obtengo lista completa de atributos de la clase de documento
				$lo_atrmdl = $this->co_reg->load->model('sysdocclsatr');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]objtyp'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->objtyp.chr(9).chr(9));
				$this->lo_mdl->sysdocclsatrlst = $lo_atrmdl->getList($lv_prm);				
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// GETLIST by TEXT. devuelve la lista según un texto
      case '#17': case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['sysdocclstxt'])?'[~fltrow~]d.sysdocclstxt'.chr(9).''.chr(9).$lp_prm['sysdocclstxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['objtyp'])?'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9):'').
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				return $this->co_reg->document->getJson( $this->lo_mdl->getList( $lv_prm ) );
				break;
       
			
			// load required view
			case '#23':
				$lo_post = $this->co_reg->request->post;
				$this->data['actcod'] = $lo_post['actcod'];
				$this->lo_mdl->sysdocclsreqfld = $lo_post['sysdocclsreqfld'];
        return $this->co_reg->document->getView( 'sysdocclsreq', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
    }
  }
}
?>