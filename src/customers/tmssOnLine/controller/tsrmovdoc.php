<?php
final class tsrmovdocController extends tmssController {
	const CONTROLLER = 'tsrmovdoc';			
	const MODEL = 'tsrmovdoc';					
	const VIEW  = 'tsrmovdoc';					
	const ID = 'tsrmovdoccod';					
	const OBJTYP ='TSR_MOV';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  //INDEX. método principal 
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$lo_grltxtmdl = $this->co_reg->load->model('grldattxt');
		$lo_grltxttypmdl = $this->co_reg->load->model('grldattxttyp');
 		$lo_tsrmovdoccmpmdl = $this->co_reg->load->model('tsrmovdoccmp');
  	$lo_tsrmovdocvalmdl = $this->co_reg->load->model('tsrmovdocval');
    $lo_tsrcshvalmdl = $this->co_reg->load->model('tsrcshval');
    $lo_busmdl = $this->co_reg->load->model('admbus');
		$lo_paymthcodmdl=$this->co_reg->load->model('tsrpaymth');
    $this->data['actcod'] = $lp_act;
		
		$lp_prm['mdlcod'] = (isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:'');
		$lp_prm['prgcod'] = (isset($lp_prm['prgcod'])?$lp_prm['prgcod']:'');
		$lv_objtyp = strtoupper( $lp_prm['mdlcod'] . '_' . $lp_prm['prgcod'] );

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['objtyp'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9); }

        return $lo_vew->index( '00', $lp_prm );
        break;

          
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// grabo documento
        if ( $this->lo_mdl->save($lo_post) ) { 
					
					// cargo documento
					$this->lo_mdl->load( array(	'tsrmovdoccod'=>$this->lo_mdl->tsrmovdoccod	) );		
										
					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					
					// asigno parámetros adicionales
					$this->lo_mdl->mdlcod = $lp_prm['mdlcod'];
					$this->lo_mdl->prgcod = $lp_prm['prgcod'];
          
        	return $this->co_reg->document->getView( ($lv_objtyp=='TSR_TIC'?'tsrmovdoccon':self::VIEW) , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
        
			
      // NEW                
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->tsrmovdoccmptxt = array();
        $this->lo_mdl->tsrmovdocvaltxt = array();
        if ( ($lo_post['tmss_actcod'] ?? '') == '01' ){
          unset($lo_post);
          $lo_post['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'] ?? '';
        }
        
				//obtengo clase de documento
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). $lv_objtyp .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst',array('lang'  => $this->co_reg->language,'input' => $this->co_reg->input,'sec' 	=> $this->co_reg->sec,'url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				
				// cargo datos de la empresa
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
 
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod = $lp_prm['mdlcod'];
				$this->lo_mdl->prgcod = $lp_prm['prgcod'];
				$this->lo_mdl->srcobjcod = ($lo_post['srcobjcod']??'');
				$this->lo_mdl->srcobjtxt = ($lo_post['srcobjtxt']??'');
        return $this->co_reg->document->getView( ($lv_objtyp=='TSR_TIC'?'tsrmovdoccon':self::VIEW) , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':        
				// get param (KEY)																										
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );						

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );	
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->tsrmovdoccod = '';
          $this->lo_mdl->tsrmovdoccmp= [];
          $this->lo_mdl->tsrmovdocval = [];
					$this->lo_mdl->tsrmovdoctot = '';
					$this->lo_mdl->docsts = 'A';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}				
        
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod=$lp_prm['mdlcod'];
				$this->lo_mdl->prgcod=$lp_prm['prgcod'];
        
        return $this->co_reg->document->getView( ($lv_objtyp=='TSR_TIC'?'tsrmovdoccon':self::VIEW) , array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
	
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
        
      // ACCOUNTING.
      case '#09':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->accounting( $lo_post );
	 			return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
			
			// GET DEPOSITS. devuelve los depositos pendientes de conciliar para una cuenta determinada
      case '#getDeposits':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dc.objtyp'.chr(9).''.chr(9).'TSR_TID'.chr(9).chr(9).chr(9).
																			'[~fltrow~]m.bnkacccod'.chr(9).'='.chr(9).chr(9).$lo_post['bnkacccod'].chr(9).chr(9).
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9)
																			);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
				return $this->co_reg->document->getJson( $lo_rs );
				break;
			
			
      // tsrmovdocval . devuelve la vista para crear/visualizar metodos de pago
			case '#tsrmovdocval':
        //carga todos los datos para la vista
        $lo_post = $this->co_reg->request->post;
        $this->lo_mdl->paymthdat=$lo_post;
        
				//cargar opciones de metodos de pago activas
        $lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_rs =$lo_paymthcodmdl->getList($lv_prm);
				$this->lo_mdl->paymth =$lo_rs;
        return $this->co_reg->document->getView('tsrmovdocval', array('data'=>$this->lo_mdl, 'actcod'=>$lo_post["actcod"]));
				break;
        
    }
  }
}
?>