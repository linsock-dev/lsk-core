<?php
final class syslngtraController extends tmssController {
	const MODEL = 'syslngtra';
	const VIEW  = 'syslngtra';
	const ID = 'lngcod';
  const FILE_ROOT = '../files';
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
			
			// LIST. lista los documentos en la grilla
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
      
      // SAVE. graba el documento
      case '#00':
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save() ) {
          
          // grabado de idioma en archivo
          try{
            $lv_buffer = '<?php '.PHP_EOL;
            $lv_txtarr = json_decode( html_entity_decode($lo_post['syslngtxt']), true );
            foreach($lv_txtarr as $lv_row){
              $lv_buffer .= '$_LNGTRA['.chr(39).$this->co_reg->db->sqldat($lv_row,'name').chr(39).']='.chr(39).$lv_row['value'].chr(39).';'.PHP_EOL;
            }
            $lv_buffer .= '?>';
            $lv_flenme = 'tmssLanguage_'.strtolower( $this->lo_mdl->lngcod );
            $lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper( $this->co_reg->sec->buscod );
            $lv_fle = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme .'.php';
            file_put_contents($lv_fle, $lv_buffer);
          } catch(Exception $e){
            return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Se produjo un error al registrar el archivo de traduccion: '.$e->getMessage()));
          } 
          
					$this->lo_mdl->load( array(	'lngcod'=>$this->lo_mdl->lngcod	) );
          
          // cargo traducciones
          $lo_lngmdl = $this->co_reg->load->model('syslng');
          $this->lo_mdl->txt = $lo_lngmdl->getTranslations( $this->lo_mdl->lngcod );

          // cargo traducciones de usuario
          $this->lo_mdl->tra = $this->lo_mdl->getTranslations( $this->lo_mdl->lngcod );
          
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ));
        } else {
	        return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        } 
        break;
			
      
      // NEW. devuelve la vista en modo creacion
      case '#01':
				$this->lo_mdl->create();
        
        // carga los idiomas activos
        $lo_lngmdl = $this->co_reg->load->model('syslng');
        $lv_prm = array('vewfldflt'=>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $this->lo_mdl->lng = $lo_lngmdl->getList( $lv_prm );
        
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ));
				break;
			
      
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
        $lv_key = array( self::ID => (isset($lp_prm[self::ID])?$lp_prm[self::ID]:$this->co_reg->request->post[self::ID]) );
				if ( !isset($lv_key[self::ID]) ) {
	        return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].'));
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
        	return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->lngcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
        // cargo traducciones
        $lo_lngmdl = $this->co_reg->load->model('syslng');
        $this->lo_mdl->txt = $lo_lngmdl->getTranslations(  $lv_key[self::ID] );
        
        // cargo traducciones de usuario
        $this->lo_mdl->tra = $this->lo_mdl->getTranslations(  $lv_key[self::ID] );
        
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ));
        break;
			
      
			// DELETE. borro el documento
      case '#04':
        $lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete();

        // borra el archivo
        if( $this->lo_mdl->errtyp!='E' ){
          try{
            $lv_flenme = 'tmssLanguage_'.strtoupper( $lo_post['lngcod'] );
            $lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper( $this->co_reg->sec->buscod );
            $lv_fle = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme .'.php';
            unlink($lv_fle);
          } catch(Exception $e){
            return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Se produjo un error al borrar el archivo de traduccion: '.$e->getMessage()));
          }
        }
        
        return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
    }
  }
}
?>