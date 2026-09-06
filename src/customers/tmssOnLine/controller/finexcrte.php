<?php
final class finexcrteController extends tmssController {  
	const MODEL = 'finexcrte';
	const VIEW  = 'finexcrte';
	const ID = 'excrtecod';
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
        $lp_prm['srcmtd'] = 'getGroupedList';
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. Graba un objeto
      case '#00':        
				$lo_excrtemdl = $this->co_reg->load->model('finexcrte');
				$lo_dat = $this->co_reg->request->post;
				$lv_buffer = $lo_dat['finexcrte'];
				if ($lv_buffer!='') {
					$i=0;
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_excrte_arr = json_decode($lv_buffer,true);
					foreach( $lv_excrte_arr as $lv_row ) {
						$lv_row['excrteclscod'] = $lo_dat['excrteclscod'];
						$lv_row['curcodsrc'] = $lo_dat['curcodsrc'];
						$lv_row['curcoddst'] = $lo_dat['curcoddst'];
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($lo_excrtemdl->delete( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_excrtemdl->errtyp,'errcod'=>$lo_excrtemdl->errcod,'errtxt'=>$lo_excrtemdl->errtxt,'row'=> $i) );
							}
						} else if ($lo_excrtemdl->save( $lv_row )==false) {
							return $this->co_reg->document->getJson( array('errtyp'=>$lo_excrtemdl->errtyp,'errcod'=>$lo_excrtemdl->errcod,'errtxt'=>$lo_excrtemdl->errtxt,'row'=> $i) );
						}
						$i++;
					}
				}
			
				$lv_key = array('excrteclscod'=>$lo_dat['excrteclscod'], 'curcodsrc'=>$lo_dat['curcodsrc'], 'curcoddst'=>$lo_dat['curcoddst']);
				$this->lo_mdl->load( $lv_key );
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
      // NEW. Nuevo               
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY
      case '#02': case '#03': 
				$lv_key = array('excrteclscod'=>$lp_prm['excrteclscod'], 'curcodsrc'=>$lp_prm['curcodsrc'], 'curcoddst'=>$lp_prm['curcoddst']);
				if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$lo_mdl->errcod,'errtxt'=>$lo_mdl->errtxt) );
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
			
      // lista todos los indicadores
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10');
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;
			
			// OBTENER COTIZACION
      case '#19': 
				$lo_dat = $this->co_reg->request->post;
				$lo_rs = $this->lo_mdl->getExchangeRate(array(), $lo_dat);			
				return $this->co_reg->document->getJson( $lo_rs );
        break;  
    }
  }
}
?>