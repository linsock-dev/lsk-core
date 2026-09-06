<?php
final class edutchlqdController extends tmssController {
	const CONTROLLER = 'edutchlqd';
	const MODEL = 'edutchlqd';
	const VIEW  = 'edutchlqd';
	const ID = 'edutchlqdcod';
	const OBJTYP = 'EDU_LQD';	
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

		$lv_edutchlqdcod = (isset($this->co_reg->request->post['edutchlqdcod'])?$this->co_reg->request->post['edutchlqdcod']:'');
		$lv_tchcod = (isset($this->co_reg->request->post['tchcod'])?$this->co_reg->request->post['tchcod']:'');
		$lv_strdte = (isset($this->co_reg->request->post['edutchlqdstrdte'])?$this->co_reg->request->post['edutchlqdstrdte']:'');
		$lv_enddte = (isset($this->co_reg->request->post['edutchlqdenddte'])?$this->co_reg->request->post['edutchlqdenddte']:'');
		$lv_sec = (isset($this->co_reg->request->post['token'])?$this->co_reg->request->post['token']:'');

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
				$lv_arr = $this->co_reg->request->post;
				$lv_arr['edutchlqdatr001']= '<strdte>'.$lv_arr['edutchlqdstrdte'].'</strdte>'.
																		'<enddte>'.$lv_arr['edutchlqdenddte'].'</enddte>';
				$lv_arr['edutchlqdids001'] = $lv_arr['opnsrvids'];
				$lv_arr['edutchlqdids002'] = $lv_arr['opnexpids'];
        if ( $this->lo_mdl->save($lv_arr) ) {					
					$this->lo_mdl->load( array(	'edutchlqdcod'=>$this->lo_mdl->edutchlqdcod	) );
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
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
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm, null, null, false);		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				 
				// get param (KEY)																						
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																			// ********************
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );										// ********************
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
	      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->edutchlqdcod = '';																										// ********************
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
				
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
				
			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->lo_mdl->accounting();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
				
			// VER DETALLE
			case '#11': case '#12': case '#13':
				$this->lo_mdl->opnexp = array();
				$this->lo_mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;

				// obtengo control de prestaciones no liquidados
				$lo_tchlqdmdl = $this->co_reg->load->model('edutchlqd');
				$lv_fltopt = array();
				if ($lp_act=='#13') { $lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.edutchlqdcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['edutchlqdcod'].chr(9).chr(9) ); }
				$lv_prm = array( 'edutchlqdcod'=>$lv_edutchlqdcod, 'tchcod'=>$lv_tchcod, 'edutchlqdstrdte'=>$lv_strdte, 'edutchlqdenddte'=>$lv_enddte, 'sysdocclscod'=>$this->lo_mdl->sysdoccls->sysdocclscod );
        $lo_rs = $lo_tchlqdmdl->getOpenServices( $lv_fltopt, $lv_prm );
				$this->lo_mdl->opnsrv = $lo_rs;
				
				// obtengo gastos no liquidados
				$lv_prm = array( 'edutchlqdcod'=>$lv_edutchlqdcod, 'tchcod'=>$lv_tchcod, 'edutchlqdstrdte'=>$lv_strdte, 'edutchlqdenddte'=>$lv_enddte );
				$lo_rs = $lo_tchlqdmdl->getOpenExpenses( null, $lv_prm );
				$this->lo_mdl->opnexp = $lo_rs;
				
				$lv_prm = array('lang'  => $this->co_reg->language,
											'input' => $this->co_reg->input,
											'sec' 	=> $this->co_reg->sec,
											'doc' 	=> $this->co_reg->document,
											'data' 	=> $this->lo_mdl,
											'load'  => $this->co_reg->load,
											'actcod'=> $this->data['actcod'],
											'model' => self::MODEL,
											);
				$lv_ret = $this->co_reg->load->view('edutchlqddet', $lv_prm );		
				return $lv_ret;
				break;
    }
  }
}
?>