<?php 
final class buyprcController extends tmssController {
	const CONTROLLER = 'buyprc';
	const MODEL = 'buyprc';
	const VIEW  = 'buyprc';
	const ID = 'buyprccod';
	const OBJTYP ='BUY_PRC';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // control de sesion
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
				
				// grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {

					// cargo documento
					$this->lo_mdl->load( array('buyprccod'=>$this->lo_mdl->buyprccod) );
          
					// cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					
					// muestro vista
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        } else {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;

				$this->lo_mdl->create();
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				/* cargo datos de la empresa */
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
				//$this->lo_mdl->srcobjcod=(isset($lo_post['srcobjcod']) && isset($lo_post['srcobjtxt'])?$lo_post['srcobjcod']:'');
				//$this->lo_mdl->srcobjtxt=(isset($lo_post['srcobjcod']) && isset($lo_post['srcobjtxt'])?$lo_post['srcobjtxt']:'');
        $this->co_reg->response->addHeader('Content-Type: text/html; charset=utf-8');
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				/*
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->buyprccod = '';
					$this->lo_mdl->docsts = 'A';
					$this->lo_mdl->buyprcmat = array();          
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				*/
				}	
        
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				$this->co_reg->response->addHeader('Content-Type: text/html; charset=utf-8');
				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;

			
			// DELETE. borra un objeto
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// GET RELATIONS. busca codigos externos de materiales de proveedor
      case '#17':
				$lo_post = $this->co_reg->request->post;
				
        $lo_supmatmdl = $this->co_reg->load->model( 'buysupmat' );
        $lv_prm = array('vewfldflt' =>'[~fltrow~]sm.supcod'.chr(9).'='.chr(9).chr(9).($lo_post['supcod']??'').chr(9).chr(9).
                        							'[~fltrow~]sm.supmatcod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),($lo_post['supmatcod']??'')).chr(9).chr(9).
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $lo_supmatmdl->getList($lv_prm);
				
				return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }
}
?>