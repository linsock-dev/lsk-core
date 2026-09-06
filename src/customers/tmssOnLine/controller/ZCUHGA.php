<?php 
final class zcuhgaController extends tmssController {
	const MODEL = 'zcuhga';
	const VIEW  = 'zcuhga';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array(); 
 
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		if ( $lp_act!='C1' && $lp_act!='C2' ) {
			$this->co_reg->request->post['ajax']='1';
			$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		}

		// load model
		//		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$lo_mdlevl = $this->co_reg->load->model( 'hltpatevl' );

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
        
			// L I S T   S T O C K   P A C I E N T E
      case '#38':
        $lo_stkmatstkctr = $this->co_reg->load->controller('stkmatstk');
        $lp_prm['vewcod']='VEW_STK_RES';
        $lp_prm['vewfldflt']='';
        $lo_post = $this->co_reg->request->post;
        $lp_prm['adrnme001']=$lo_post['adrnme001'];
        if(isset($lo_post['adrnme001'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]a.adrnme001'.chr(9).'='.chr(9).chr(9).$lo_post['adrnme001'].chr(9).chr(9);}
        return $lo_stkmatstkctr->index( '08', $lp_prm );
        break;

      //   P A C I E N T E S    -    C U A D R O    D E    I N F O R M A C I O N
	    case '#39':
				$lv_buffer = '';
				
				// recupero datos de paciente
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$lp_prm['patcod']), false );
				
				// recupero clase de documento de contacto CRM
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'CRMPAT'.chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_docclsmdl->getList($lv_prm);
				$lv_sysdocclscod = '';
				if(count($lo_rs)>0){ $lv_sysdocclscod = $lo_rs[0]['sysdocclscod']; }
				$lo_patmdl->crmdocclscod = $lv_sysdocclscod;
				return $this->co_reg->document->getView( 'zcuhga_hltpat_infobox', array('data'=>$lo_patmdl) );
				break;
    
    
    }
  }
}
?>