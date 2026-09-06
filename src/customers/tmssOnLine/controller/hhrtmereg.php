<?php
final class hhrtmeregController extends tmssController {
	const CONTROLLER = 'hhrtmereg';
	const MODEL = 'hhrtmereg';
	const VIEW  = 'crmcnt';
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
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      // BORRADO DE HORAS
			case '#04':
				$lo_post = $this->co_reg->request->post;
        $lo_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lo_hhrtmereg = $this->co_reg->load->model('hhrtmereg');
        $hhrtmeregcod_arr = explode(',' , $lo_post['hhrtmeregcod']);
        foreach($hhrtmeregcod_arr as $lv_row){
        	if ($lo_hhrtmereg->delete( array('hhrtmeregcod' => $lv_row ) )==false) {
            return $this->co_reg->document->getJson(array('errtyp'=>$lo_hhrtmereg->errtyp,'errcod'=>$lo_hhrtmereg->errcod,'errtxt'=>$lo_hhrtmereg->errtxt));
          } 
        }
				return $this->co_reg->document->getJson( $lo_ret );
				break;
        
      // MOSTRADO DE HORAS
			case '#08':
				$lo_post = $this->co_reg->request->post;
        $lo_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lo_hhrtmereg = $this->co_reg->load->model('hhrtmereg');
        $lv_prm=array('vewfldflt' =>'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                    '[~fltrow~]t.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lo_post['crmcntcod'].chr(9).chr(9),
        							'vewfldord' => 't.HhrTmeRegDte DESC');
        $lo_rs=$lo_hhrtmereg->getList($lv_prm);
				return $this->co_reg->document->getJson( array('err'=>$lo_ret, 'data'=>$lo_rs) );
				break;
    }
  }
}
?>