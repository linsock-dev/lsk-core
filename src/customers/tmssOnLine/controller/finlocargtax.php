<?php
final class finlocargtaxController extends tmssController {
	const MODEL = '';
	const VIEW  = '';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
      
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		//$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// IVA
			case '#calcIVA':
				//$lo_post = $this->co_reg->request->post;
				$lo_post = $lp_prm;	// las formulas personalizadas reciben los datos como parámetros LP_PRM de la función INDEX
				$lv_dochdr = (isset($lo_post['dochdr'])?$lo_post['dochdr']:array());
				$lv_docpos = (isset($lo_post['docpos'])?$lo_post['docpos']:array());
				$lv_docprc = (isset($lo_post['docprc'])?$lo_post['docprc']:array());
				$lv_dat = array();
				$lv_dte = new Datetime();
				$lv_srccndtot = (isset($lv_docprc['prccndtot'])?$lv_docprc['prccndtot']:0);	// importe base para calculo de IVA
				$lv_srccurcod = (isset($lv_docprc['curcod'])?$lv_docprc['curcod']:'');
				$lo_ret = array('prccndqty'=>0,'prccnduntcod'=>'','prccndval'=>$lv_srccndtot,'prccndcurcod'=>$lv_srccurcod,'prccndtot'=>0);
				
				// CONDICION. recupero ID de condición
				$lv_prccndcod = (isset($lv_docprc['prccndcod'])?$lv_docprc['prccndcod']:'0');
				
				// EMISOR. recupero taxcod del emisor
				$lv_srctaxcod = (isset($lv_dochdr['srctaxcatcod'])?$lv_dochdr['srctaxcatcod']:'01');
				$lv_dat['srcobj'] = array('taxcatcod'=>$lv_srctaxcod);
				
				// RECEPTOR. recupero taxcod del receptor
				$lv_dsttaxcod = (isset($lv_dochdr['taxcatcod'])?$lv_dochdr['taxcatcod']:'');
				$lv_dat['dstobj'] = array('taxcatcod'=>$lv_dsttaxcod);
				
				// MATERIAL. recupero taxind del material
				$lv_mattaxind = '';
				$lv_matcod = (isset($lv_docpos['matcod'])?$lv_docpos['matcod']:'');
				if($lv_matcod!='') {
					$lo_mattaxmdl = $this->co_reg->load->model('stkmattax');
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]mt.matcod'.chr(9).'='.chr(9).chr(9).$lv_docpos['matcod'].chr(9).chr(9).
																				'[~fltrow~]tt.fintaxtypcat'.chr(9).'='.chr(9).chr(9).'IVA'.chr(9).chr(9)
													); 
					$lo_rs = $lo_mattaxmdl->getList($lv_prm);
					if(count($lo_rs)>0){
						$lv_mattaxind = $lo_rs[0]['fintaxindcodext'];
						$lv_dat['stkmat']=array('fintaxindcodext'=>$lv_mattaxind);
					}
				}
				
				// recupero los registros de la condición
				// determino si existe la combinación
				$lo_forctr = $this->co_reg->load->controller('grldatprc');
				$lv_out = $lo_forctr->findConditionRecord( $lv_docprc['prccndcod'], $lv_dte, $lv_dat );
				if(count($lv_out['prccnd'])>0){
					$lo_ret['prccndqty'] = $lv_out['prccnd']['prccndqty'];
					$lo_ret['prccnduntcod'] = $lv_out['prccnd']['prccnduntcod'];
					if( $lv_out['prccnd']['prccnduntcod']=='%' && $lv_srccndtot!=0 ){
						$lo_ret['prccndtot'] = $lv_srccndtot * $lv_out['prccnd']['prccndqty'] / 100;
					}
				}
				
				// DEVUELVO DATOS. devuelvo el primer registro de condición
        return $this->co_reg->document->getJson( $lo_ret );
        break;
    }
  }
}
?>