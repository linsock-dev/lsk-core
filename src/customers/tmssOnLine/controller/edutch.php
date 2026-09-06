<?php
final class edutchController extends tmssController {  
	const CONTROLLER = 'edutch';
	const MODEL = 'edutch';
	const VIEW  = 'edutch';	
	const ID = 'tchcod';
	const OBJTYP ='EDU_TCH';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; } 
  
	
  // Index - Método principal  
  public function index( $lp_act , $lp_prm = array() ) {
 
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. Lista
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. Graba un objeto
      case '#00':
        $lo_post = $this->co_reg->request->post;
				// grabo datos de profesor
        if( $this->lo_mdl->save() ) {
					
					// grabo areas de estudio del profesor
        	$lo_tchprf = $this->co_reg->load->model('edutchprf');
          $lv_buffer = $lo_post['tchprf'];
          if ($lv_buffer!='') {
          	$lv_buffer = html_entity_decode($lv_buffer);
						$lv_tchprf_arr = json_decode($lv_buffer,true);
            foreach( $lv_tchprf_arr as $lv_row ) {
            	$lv_row['tchcod'] = $this->lo_mdl->tchcod;
              $lv_row['docsts'] = 'A';
              $lo_tchprf->setFormData( $lv_row );
              if ( isset($lv_row['deleted']) ) {
								if ($lo_tchprf->delete($lv_row)==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_tchprf->errtyp,'errcod'=>$lo_tchprf->errcod,'errtxt'=>$lo_tchprf->errtxt) );
								} 
							} else {
								if ($lo_tchprf->save($lv_row)==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_tchprf->errtyp,'errcod'=>$lo_tchprf->errcod,'errtxt'=>$lo_tchprf->errtxt) );
								}
							}
            }
          }
          // cargo datos de Profesor
					$this->lo_mdl->load( array(	'tchcod'=>$this->lo_mdl->tchcod	) );
					
          // cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$lo_post['sysdocclscod']));

          // obtengo toda la info de la clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );

        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
      	break;	
			 
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				// ------------------------------------------------
				// obtengo clase de documento 										
				// ------------------------------------------------
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
					$this->lo_mdl->sysdocclstxt = $lo_docclsmdl->sysdocclstxt;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																	
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
					// cargo la clase de documento
        } else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				// copiar
				if ( $lp_act == '#001' ) {
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->tchprf;
          foreach($lv_dat as &$lv_row){
          	$lv_row['tchprfcod'] = '';
          	$lv_row['tchcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lv_row);
					$this->lo_mdl->tchprf = $lv_dat;
          $this->lo_mdl->tchcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;	
			
			
			// DELETE. Borra un objeto
      case '#04':
				$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;		
			
			
			// LIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['tchtxt'])?'[~fltrow~]p.tchtxt'.chr(9).''.chr(9).$lp_prm['tchtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
			
			
      // DISPLAY. Mostrar
      case '#23':
				if ( !isset($lp_prm[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lp_prm)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				$lv_vew = 'edutchinf' . (isset($lp_prm['vewtyp'])?$lp_prm['vewtyp']:'typ001');
				
				return $this->co_reg->document->getView( $lv_vew, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),'objtyp'=>self::OBJTYP) );
        break;
			
			
			// LIST. Lista (especialidades del prestador)
      case '#37':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['controller'] = 'edutch';
        $lp_prm['model'] = 'edutchprf';
				$lp_prm['actcod'] = '37';
        return $lo_vew->index( '00', $lp_prm );
        break;		
			
			
			// LIST by TEXT. Lista por texto (especialidades del prestador)
      case '#38':
				$lo_tchprf_mdl = $this->co_reg->load->model('edutchprf');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]p.tchcod'.chr(9).'='.chr(9).chr(9).$lp_prm['tchcod'].chr(9).chr(9).
																			'[~fltrow~]s.prftxt'.chr(9).''.chr(9).$lp_prm['prftxt'].chr(9).chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $lo_tchprf_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>