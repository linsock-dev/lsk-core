<?php
final class zcuosdController extends tmssController {
	const MODEL = 'zcuosd';
	const VIEW  = 'zcuosd';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    if($lp_act != 'temasis.ar.getnws' && $lp_act != 'temasis.ar.lstnws' && $lp_act != 'temasis.ar.getimg'){
      $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
 
    }
		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;

    switch( $lp_act ) {
			
			
			// ----------------------------------------------------------------------
			//
			//    I M P R E S I O N E S
			//
			// ----------------------------------------------------------------------
			
			
			
			
			
			//    B O L E T A   D E   D E P O S I T O
			//    impresion del fromulario de boleta de deposito
			case '#boletadeposito':
				$lo_post = $this->co_reg->request->post;
				$lv_tsrmovdoccod = (isset($lo_post['tsrmovdoccod'])?$lo_post['tsrmovdoccod']:$lp_prm['tsrmovdoccod']);
				
				// DEPOSITO. cargo datos del deposito
				$lo_depmdl = $this->co_reg->load->model('tsrmovdoc');
				$lo_depmdl->load( array('tsrmovdoccod'=>$lv_tsrmovdoccod) );

				// CHECK
				if( (isset($lp_prm['frmchk'])?$lp_prm['frmchk']:'')!='' ){
					if( $lo_depmdl->docsts='C' ){
						return '<errtyp>S</errtyp><errcod>0</errcod><errtxt></errtxt>';
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El documento debe estar contabilizado.</errtxt>';
					}
				}

				// EMPRESA. cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				
				// CODIGOS. recupero códigos de depositantes de delegaciones
				$lo_intmdl = $this->co_reg->load->model('sysint');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'HLT_DEL_DEP'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_int_rs = $lo_intmdl->getlist($lv_prm);
				
				$lv_buffer = 	$this->co_reg->document->getView('zcuosd_tsrmovdocpnt', array('bus'=>$lo_busmdl,'data'=>$lo_depmdl,'int'=>$lo_int_rs,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
		}
	}
}
?>