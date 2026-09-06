<?php
final class slssvclqdController extends tmssController {
	const CONTROLLER = 'slssvclqd';
	const MODEL = 'slssvclqd';
	const VIEW  = 'slssvclqd';
	const ID = 'slssvclqdcod';
	const OBJTYP = 'SLS_SVL';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  //INDEX. metodo principal
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
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':
        $lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
        if ( $this->lo_mdl->save($lo_post) ) {
					$lv_ret['slssvclqdcod'] = $this->lo_mdl->slssvclqdcod;
        } else {
          $lv_ret['errtyp']=$this->lo_mdl->errtyp;
          $lv_ret['errcod']=$this->lo_mdl->errcod;
          $lv_ret['errtxt']=$this->lo_mdl->errtxt;
        } 
				return $this->co_reg->document->getJson( $lv_ret );
        break;
			
			
      // NEW
      case '#01':
				$this->lo_mdl->create();
				// obtengo clase de documento 											

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
     				return $this->co_reg->document->getView( 'sysdocclslst', array('data'=>$this->data,'url'=>'?prg='.self::CONTROLLER.'&act=01','actcod'=>$this->data['actcod'] ) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
        $lo_post = $this->co_reg->request->post;
				$lv_key = array();
				
				// get param (KEY)																						
        $lv_key = array( self::ID=>(isset($lp_prm[self::ID]) && $lp_prm[self::ID] != ''  ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>'-1','errtxt'=>'No se indico parametro ['.self::ID.']') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->slssvclqdcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
        break;
			
			
			// DELETE
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// CONTABILIZAR
      case '#09':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->accounting( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// VER DETALLE
			case '#11': case '#12': case '#13':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->opnexp = array();
				$this->lo_mdl->opnsrv = array();
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				
				// obtengo control de prestaciones no liquidados
				$lo_svclqdmdl = $this->co_reg->load->model('slssvclqddoc');
				if($lp_act=='#13'){
					$lv_prm = $lo_post;
					$lo_rs = $lo_svclqdmdl->getServices( array(), $lv_prm );
				} else {
					$lv_prm = $lo_post;
					$lo_rs = $lo_svclqdmdl->getOpenServices( array(), $lv_prm );
				}
				$this->lo_mdl->opnsrv = $lo_rs;
        $this->lo_mdl->oldsec = $lo_post['sec'];
        $this->lo_mdl->docsts = $lo_post['docsts'];
        return $this->co_reg->document->getView( 'slssvclqddet', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
        
        
      // AJUSTAR
			case '#slssvclqdaju':
				$lo_post = $this->co_reg->request->post;
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
        
        $lo_svclqdmdl = $this->co_reg->load->model('slssvclqddoc');
        $lv_prm = $lo_post;
        $lo_rs = $lo_svclqdmdl->getServices( array(), $lv_prm );
				$this->lo_mdl->opnsrv = $lo_rs;
        $this->lo_mdl->stkcntcod = $lo_post['stkcntcod'];
        $this->lo_mdl->slssvclqdstrdte = $lo_post['slssvclqdstrdte'];
        $this->lo_mdl->slssvclqdenddte = $lo_post['slssvclqdenddte'];
        
				return $this->co_reg->document->getView( 'slssvclqdaju', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
        
        
      // GRABAR AJUSTE
			case '#slssvclqdajusve':
				$lo_post = $this->co_reg->request->post;
        
				// grabo los documentos
        $lo_lqddoc = $this->co_reg->load->model('slssvclqddoc');
        $lv_buffer = $lo_post['newrows'];
        if ($lv_buffer!='') {
          $i=0;
          $lv_buffer = html_entity_decode($lv_buffer);
          $lv_lqddoc_arr = json_decode($lv_buffer,true);
          foreach( $lv_lqddoc_arr as $lv_row ) {
            $lv_row['slssvclqdcod'] = $lo_post['slssvclqdcod'];
            $lv_row['docsts'] = 'A';          
          	$lv_row['refobjtyp'] = 'SLS_SVL';
            $lv_row['refobjcod001'] = $lo_post['slssvclqdcod'];
          	$lv_row['refobjcod002'] = ($lv_row['slssvclqddocaju'] == 'X' ? $lv_row['oldrefobjcod002'] : $lv_row['slssvclqddoccod'] );
            $lv_row['slssvclqddoccodext'] = '';
          	$lv_row['slssvclqddoccod'] = (isset($lv_row['slssvclqddocoldcod']) ? $lv_row['slssvclqddocoldcod'] : '');
            if ( isset($lv_row['deleted']) ) {
              if ($lo_lqddoc->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt, 'row'=>$i) );
              }
            } else if ($lo_lqddoc->saveSingle( $lv_row )==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt, 'row'=>$i) );
            }
            $i++;
          }
        }
        
        // recargo el documento
        $this->lo_mdl->load( array(	'slssvclqdcod'=>$lo_post['slssvclqdcod']) );
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
        $this->lo_mdl->sysdoccls = $lo_docclsmdl;

        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				break;
        
    // GRABAR DOCUMENTO (POSICIÓN)
    case '#docsve':
      $lo_post = $this->co_reg->request->post;
      $lo_lqddoc = $this->co_reg->load->model('slssvclqddoc');
			if ($lo_lqddoc->save( $lo_post )==false) {
				return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqddoc->errtyp,'errcod'=>$lo_lqddoc->errcod,'errtxt'=>$lo_lqddoc->errtxt) );
			}else{
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
			}
      break;
    }
  }
}
?>