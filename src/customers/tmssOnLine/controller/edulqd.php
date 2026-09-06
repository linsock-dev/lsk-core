<?php
final class edulqdController extends tmssController {
	const CONTROLLER = 'edulqd';
	const MODEL = 'edulqd';	
	const VIEW  = 'edulqd';	
	const ID = 'edulqdcod';	
	const OBJTYP = 'EDU_LQC';	
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
				$lo_post['edulqdatr001']='<strdte>'.$lo_post['edulqdstrdte'].'</strdte>'.
																'<enddte>'.$lo_post['edulqdenddte'].'</enddte>';
				if ( $this->lo_mdl->save($lo_post) ) {
					
					// grabo los documentos
					$lo_lqddoc = $this->co_reg->load->model('edulqddoc');
					$lv_buffer = $lo_post['opnsrvids'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_lqddoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_lqddoc_arr as $lv_row ) {
							$lv_row['edulqdcod'] = $this->lo_mdl->edulqdcod;
							$lv_row['docsts'] = 'A';
							$lv_row['edulqddocatr001'] ='<refobjgrpcod>'.$lv_row['refobjgrpcod'].'</refobjgrpcod>'.
																					'<refobjgrptxt>'.utf8_decode($lv_row['refobjgrptxt']).'</refobjgrptxt>'.
																					'<refobjsubgrpcod>'.$lv_row['refobjsubgrpcod'].'</refobjsubgrpcod>'.
																					'<refobjsubgrptxt>'.utf8_decode($lv_row['refobjsubgrptxt']).'</refobjsubgrptxt>';
							if ( (isset($lv_row['deleted'])?$lv_row['deleted']:'')!='' ) {
								if ($lo_lqddoc->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt,'row'=> $i) );
								}
							} else if ($lo_lqddoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt,'row'=> $i) );
							}
							$i++;
						}
					}
					
					$lv_buffer = $lo_post['opnexpids'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_lqddoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_lqddoc_arr as $lv_row ) {
							$lv_row['edulqdcod'] = $this->lo_mdl->edulqdcod;
							$lv_row['docsts'] = 'A';
							if ( (isset($lv_row['deleted'])?$lv_row['deleted']:'')!='' ) {
								if ($lo_lqddoc->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt,'row'=> $i) );
								}
							} else if ($lo_lqddoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt,'row'=> $i) );
							}
							$i++;
						}
					}
					// Recargo el documento
					$this->lo_mdl->load( array('edulqdcod'=>$this->lo_mdl->edulqdcod	) );
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
					$this->lo_mdl->edulqdcod = '';
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
			
			
			// CONTABILIZAR
      case '#09':
        $this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
			
			
			// VER DETALLE
			case '#11': case '#12': case '#13':
				$lo_post = $this->co_reg->request->post;
				$lv_edulqdcod = (isset($lo_post['edulqdcod'])?$lo_post['edulqdcod']:'');
				$lv_cuscod = (isset($lo_post['cuscod'])?$lo_post['cuscod']:'');
				$lv_strdte = (isset($lo_post['edulqdstrdte'])?$lo_post['edulqdstrdte']:'');
				$lv_enddte = (isset($lo_post['edulqdenddte'])?$lo_post['edulqdenddte']:'');

				$this->lo_mdl->opnexp = array();
				$this->lo_mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;

				// obtengo control de prestaciones no liquidados
				$lo_prslqdmdl = $this->co_reg->load->model('edulqd');
				$lv_fltopt = array();
				if ($lp_act=='#13') { $lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.edulqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['edulqdcod'].chr(9).chr(9) ); }
				$lv_prm = array( 'edulqdcod'=>$lv_edulqdcod, 'cuscod'=>$lv_cuscod, 'edulqdstrdte'=>$lv_strdte, 'edulqdenddte'=>$lv_enddte, 'sysdocclscod'=>$this->lo_mdl->sysdoccls->sysdocclscod );
				$lo_rs = $lo_prslqdmdl->getOpenServices( $lv_fltopt, $lv_prm );
				$this->lo_mdl->opnsrv = $lo_rs;
				
				// obtengo gastos no liquidados
				$lv_prm = array( 'edulqdcod'=>$lv_edulqdcod, 'cuscod'=>$lv_cuscod, 'edulqdstrdte'=>$lv_strdte, 'edulqdenddte'=>$lv_enddte );
				$lo_rs = $lo_prslqdmdl->getOpenExpenses( null, $lv_prm );
				$this->lo_mdl->opnexp = $lo_rs;	
				
				return $this->co_reg->document->getView( 'edulqddet', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );				
				break;
    }
  }
}
?>