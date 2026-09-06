<?php
final class eduplnpreController extends tmssController {
  const CONTROLLER = 'eduplnpre';	
	const MODEL = 'eduplnpre';					
	const VIEW  = 'eduplnprereg';					
	const ID = 'eduplnprecod';					
	const OBJTYP ='EDU_PRE';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
 
 
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
  // main method     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
    
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':
        $lo_post = $this->co_reg->request->post;		
        if ( $this->lo_mdl->save($lo_post) ) {
          $lo_post['educurplncod'] = $lo_post['educurcod'];
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->eduplnprecod	) );

					// recargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
        
        
		// REGISTRO
      case '#11':
        // cargo pre-inscripciones existentes
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.stucod'.chr(9).'='.chr(9).chr(9).$lp_prm['stucod'].chr(9).chr(9));
        $lo_dat = $this->lo_mdl->getList( $lv_prm );
        $this->lo_mdl->prereg = $lo_dat;
        // cargo datos del alumno
        $lo_stumdl = $this->co_reg->load->model('edustu');
        $lo_stumdl->load( array('stucod'=>$lp_prm['stucod']), false );
        $this->lo_mdl->create();
        
        /* ------------------------------------------------ */
        /* obtengo clase de documento                       */
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
                            '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );                          // obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            
          } else {
            $lv_prm = array('lang'  => $this->co_reg->language,
                            'input' => $this->co_reg->input,
                            'sec'                 => $this->co_reg->sec,
                            'url'=>'index.php?prg='.self::CONTROLLER.'&act=11&prm_stucod='.$lp_prm['stucod'],
                            'doccls'=>$lv_docclsarr
                            );
            $lv_ret = $this->co_reg->load->view( 'sysdocclslst', $lv_prm );                  
            return $lv_ret;
          }
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {// obtengo toda la info de la clase de documento
        	$this->lo_mdl->sysdoccls = $lo_docclsmdl;
        } else {
        	echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        $this->lo_mdl->stucod=$lo_stumdl->stucod ;
        $this->lo_mdl->stutxt=$lo_stumdl->stutxt ;
				
        /* ------------------------------------------------ */
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>'01'));
      	break;
        
			// NEW
      case '#01':      
        $this->lo_mdl->create();
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;		
        
      
    // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':	
        $lv_key = array();
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));
        
				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
          
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->eduplnprecod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}

        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;		


			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
    }
  }
}
?>