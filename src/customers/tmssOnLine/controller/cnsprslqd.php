<?php
final class cnsprslqdController extends tmssController {
	const CONTROLLER = 'cnsprslqd';
	const MODEL = 'cnsprslqd';	
	const VIEW  = 'cnsprslqd';	
	const ID = 'cnsprslqdcod';	
	const OBJTYP = 'CNS_LQP';	
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
        
        $lo_post['cnsprslqdopnsrvids']=html_entity_decode($lo_post['cnsprslqdopnsrvids']);
				if ( $this->lo_mdl->save($lo_post) ) {  
					// Recargo el documento
					$this->lo_mdl->load( array('cnsprslqdcod'=>$this->lo_mdl->cnsprslqdcod	) );
          
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
					$this->lo_mdl->cnsprslqdcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        /*else if ( $lp_act == '#02' ) {
					// obtengo gastos liquidados
          $lv_prm = array( 'cnsprslqdcod'=>$this->lo_mdl->cnsprslqdcod, 'srcobjcod001'=>$this->lo_mdl->srcobjcod001, 'cnsprslqdstrdte'=>$this->lo_mdl->cnsprslqdstrdte->format('d/m/Y'),'cnsprslqdenddte'=>$this->lo_mdl->cnsprslqdenddte->format('d/m/Y') );
          $lv_lqdmdl = $this->co_reg->load->model( self::MODEL );
          //$lo_srv = $lv_lqdmdl->getServices( array(), $lv_prm );
          $lo_opnsrv = $lv_lqdmdl->getOpenServices( array(), $lv_prm );
          $this->lo_mdl->srv = $lo_opnsrv;
				}*/
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
			
			
			// CONTABILIZAR
      case '#09':
        $this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
			
			
			// VER DETALLE
			case '#21': case '#22': case '#23':
				$lo_post = $this->co_reg->request->post;
				$lv_cnsprslqdcod = (isset($lo_post['cnsprslqdcod'])?$lo_post['cnsprslqdcod']:'');
				$lv_srcobjcod001 = (isset($lo_post['srcobjcod001'])?$lo_post['srcobjcod001']:'');
				$lv_strdte = (isset($lo_post['cnsprslqdstrdte'])?$lo_post['cnsprslqdstrdte']:'');
				$lv_enddte = (isset($lo_post['cnsprslqdenddte'])?$lo_post['cnsprslqdenddte']:'');

				$this->lo_mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;

				// obtengo control de prestaciones no liquidados
				$lv_fltopt = array();
				//if ($lp_act=='#13') { $lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.cnsprslqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['cnsprslqdcod'].chr(9).chr(9) ); }
				$lv_prm = array( 'cnsprslqdcod'=>$lv_cnsprslqdcod, 'srcobjcod001'=>$lv_srcobjcod001, 'cnsprslqdstrdte'=>$lv_strdte, 'cnsprslqdenddte'=>$lv_enddte, 'sysdocclscod'=>$this->lo_mdl->sysdoccls->sysdocclscod );
				$lo_data = $this->lo_mdl->getOpenServices( $lv_fltopt, $lv_prm );
				return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );

				break;
    }
  }
}
?>