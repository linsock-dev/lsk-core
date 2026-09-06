<?php
final class cnslqdController extends tmssController {
	const CONTROLLER = 'cnslqd';
	const MODEL = 'cnslqd';	
	const VIEW  = 'cnslqd';	
	const ID = 'cnslqdcod';	
	const OBJTYP = 'CNS_LQC';	
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
        
				if ( $this->lo_mdl->save($lo_post) ) {  
					// Recargo el documento
					$this->lo_mdl->load( array('cnslqdcod'=>$this->lo_mdl->cnslqdcod	) );
          
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
          
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;		
			
			
      // NEW. Nuevo
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
			
			
      // CHANGE - DISPLAY - COPY.
      case '#02': case '#03': case '#001':
        $lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->cnslqdcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
      	// cargo la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;	
			
			
			// DELETE. Borra un objeto
      case '#04':
				$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// VER DETALLE
			case '#22': case '#23':
				$lo_post = $this->co_reg->request->post;
				$lv_cnslqdcod = (isset($lo_post['cnslqdcod'])?$lo_post['cnslqdcod']:'');
				$lv_cuscod = (isset($lo_post['cuscod'])?$lo_post['cuscod']:'');
				$lv_strdte = (isset($lo_post['cnslqdstrdte'])?$lo_post['cnslqdstrdte']:'');
				$lv_enddte = (isset($lo_post['cnslqdenddte'])?$lo_post['cnslqdenddte']:'');
				$lv_sysdoccslcod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				$lv_evtlqd = (isset($lo_post['evtlqd'])?$lo_post['evtlqd']:'');
        $lv_flt_post = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');

        if(!$lv_evtlqd){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Falta configuración en la clase de documento.') );
        }
        
        // obtengo eventos a liquidar
        $lv_flt_str = '[~fltrow~]se.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), explode(';', $lv_evtlqd)).chr(9).chr(9);
				$lv_flt_str .= $lv_flt_post; 

				$lv_flt = array('vewfldflt' => $lv_flt_str);
          
				$lv_prm = array( 'cnslqdcod'=>$lv_cnslqdcod, 'cuscod'=>$lv_cuscod, 'cnslqdstrdte'=>$lv_strdte, 'cnslqdenddte'=>$lv_enddte);
				$lo_data = $this->lo_mdl->getOpenServices( $lv_flt, $lv_prm );
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );
				break;
    }
  }
}
?>