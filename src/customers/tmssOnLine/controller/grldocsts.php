<?php
final class grldocstsController extends tmssController {
    
	const MODEL = 'grldocmsg';					// **************************
	const VIEW  = 'grldocmsg';					// **************************
	const ID = 'docstscod';							// **************************
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
	//	$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		/*
		$this->data['vew_sec'] 	 = (isset($lp_prm['lv_sec'])?$lp_prm['lv_sec']:'');
		$this->data['sysdocclscod'] = (isset($lp_prm['sysdocclscod'])?$lp_prm['sysdocclscod']:'');
		$this->data['srcobjtyp'] = (isset($lp_prm['srcobjtyp'])?$lp_prm['srcobjtyp']:'');
		$this->data['srcobjcod'] = (isset($lp_prm['srcobjcod'])?$lp_prm['srcobjcod']:'');
		
		$this->lo_mdl->vew_sec	= $this->data['vew_sec'];
		$this->lo_mdl->sysdocclscod = $this->data['sysdocclscod'];
		$this->lo_mdl->srcobjtyp = $this->data['srcobjtyp'];
		$this->lo_mdl->srcobjcod = $this->data['srcobjcod'];
		*/
		
		$lv_doctre = array(''=>'No Tratado', 'C'=>'Completo','N'=>'No Tratado','P'=>'Parcial');
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// VER ESTADOS DE DOCUMENTO
      case '#03':
			
				$lo_rshdr = array();
				$lo_rspos = array();
				$lo_datprm = $this->co_reg->request->post;

				// cargo la info del documento
				switch( strtoupper($lo_datprm['srcobjtyp']) ) {
					case 'SLS_ORD': case 'SLS_QTA':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('slsord');
						if( $lo_docmdl->load( array('slsordcod'=>$lo_datprm['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->slsordmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'SLS_INV': case 'SLS_DEB': case 'SLS_CRE': 
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('slsinv');
						if( $lo_docmdl->load( array('slsinvcod'=>$lo_datprm['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->slsinvmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'STK_SIN': case 'STK_SOU': case 'STK_INV':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('stkmovdoc');
						if( $lo_docmdl->load( array('stkmovdoccod'=>$lo_datprm['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->stkmovdocmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'BUY_ORD':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('buyord');
						if( $lo_docmdl->load( array('buyordcod'=>$lo_datprm['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->buyordmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'BUY_INV': case 'BUY_DEB': case 'BUY_CRE':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('buyinv');
						if( $lo_docmdl->load( array('buyinvcod'=>$lo_datprm['srcobjcod']),false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->buyinvmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'EDU_LQC':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('edulqd');
						if( $lo_docmdl->load( array('edulqdcod'=>$lo_datprm['srcobjcod']),false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_datprm['srcobjtyp'],
																'srcobjcod'=>$lo_datprm['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							/*
							foreach($lo_docmdl->buyinvmat as $lv_row) {
								$lo_rspos[]=array('matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
							*/
						}
						break;
				}
			
				// cargo los tipos de mensaje del módulo
				/*
				$lo_docmsgmdl = $this->co_reg->load->model('sysdocmsg');
				$lv_prm = array('vewfldflt'=>(isset($lp_prm['mdlcod'])?'[~fltrow~]dm.objtypcod'.chr(9).''.chr(9).$lp_prm['mdlcod'].'_%'.chr(9).chr(9).chr(9):'').
																		 '[~fltrow~]dbo.getTagValue(^msgtyp^,dm.sysdocmsgatr)'.chr(9).'='.chr(9).chr(9). 'pdf' .chr(9).chr(9).
																		 '[~fltrow~]dm.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_rs = $lo_docmsgmdl->getList( $lv_prm );				
				$this->lo_mdl->docmsglst = $lo_rs;
				*/
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'doc'		=> $this->co_reg->document,
												'data' 	=> $this->lo_mdl,
												'dathdr'=> $lo_rshdr,
												'datpos'=> $lo_rspos,
												'actcod'=> $this->data['actcod'],
												'model' => self::MODEL,
												);
				return $this->co_reg->load->view( 'grldocsts', $lv_prm );
				break;
			
			// REPORTE DE ESTADOS
			case '#08':
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_rs) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
				}
				break;
		}
  }
	
	
	/**
	  * GET VIEW
		* muestro la vista de adjuntos
		*/
	private function getView( $lp_vew='' ) {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' 	=> $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data' 	=> $this->lo_mdl,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( ($lp_vew!=''?$lp_vew: self::VIEW ), $lv_prm );
		return $lv_ret;
	}	
}
?>