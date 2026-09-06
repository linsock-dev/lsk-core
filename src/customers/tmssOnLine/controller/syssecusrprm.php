<?php
final class syssecusrprmController extends tmssController {
	
	const MODEL = 'syssecusrprm';				
	const VIEW  = 'syssecusrprm';				
	const ID = 'usrprmcod';							
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

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				$this->data['buscod'] = $lo_post['buscod'];
				$this->data['usrcod'] = $lo_post['usrcod'];
				$lv_buffer = $lo_post['usrprm'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_usrprm_arr = json_decode($lv_buffer,true);
					foreach( $lv_usrprm_arr as $lv_row ) {
						$lv_row['buscod'] = $this->data['buscod'];
						$lv_row['usrcod'] = $this->data['usrcod'];
						$lv_row['docsts'] = 'A';
						$lv_row['usrprmflttyp'] = 'OR';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );					
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
						}
					}
				}
        
				// parámetros del usuario
				$lo_usrprmmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->data['usrcod'] .chr(9).chr(9));
				$lo_rs = $lo_usrprmmdl->getList( $lv_prm );
				$this->lo_mdl->usrprm = $lo_rs;

				// empresas del usuario
				$lo_busmdl = $this->co_reg->load->model('syssecusrbus');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9). $this->data['usrcod'] .chr(9).chr(9));
				$lo_rs = $lo_busmdl->getList($lv_prm);
				$this->lo_mdl->usrbus = $lo_rs;

				// definiciones de parámetros
				$lo_usrprm_mdl = $this->co_reg->load->model('syssecusrprm');
				$lv_prm = array(); //array('vewfldflt' =>(isset($lp_prm['prmtxt'])?'[~fltrow~]prmtxt'.chr(9).'='.chr(9).chr(9).$lp_prm['prmtxt'].chr(9).chr(9):'') );
				$lo_rs = $lo_usrprm_mdl->getDefinitions($lv_prm);
				$this->lo_mdl->usrprmdef = $lo_rs;
				
				$this->lo_mdl->buscod = $this->co_reg->sec->buscod;
				$this->lo_mdl->usrcod = $this->data['usrcod'];
				$this->data['actcod'] = '02';
				
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;

      // CHANGE - DISPLAY
      case '#02': case '#03':
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( !isset($this->co_reg->request->post['usrcod']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [usrcod].') );
				} else {
					$this->data['usrcod'] = $this->co_reg->request->post['usrcod'];
				}
				
				// parámetros del usuario
				$lo_usrprmmdl = $this->co_reg->load->model( self::MODEL );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->data['usrcod'] .chr(9).chr(9));
				$lo_rs = $lo_usrprmmdl->getList( $lv_prm );
				$this->lo_mdl->usrprm = $lo_rs;

				// empresas del usuario
				$lo_busmdl = $this->co_reg->load->model('syssecusrbus');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9). $this->data['usrcod'] .chr(9).chr(9));
				$lo_rs = $lo_busmdl->getList($lv_prm);
				$this->lo_mdl->usrbus = $lo_rs;

				// definiciones de parámetros
				$lo_usrprm_mdl = $this->co_reg->load->model('syssecusrprm');
				$lv_prm = array(); //array('vewfldflt' =>(isset($lp_prm['prmtxt'])?'[~fltrow~]prmtxt'.chr(9).'='.chr(9).chr(9).$lp_prm['prmtxt'].chr(9).chr(9):'') );
				$lo_rs = $lo_usrprm_mdl->getDefinitions($lv_prm);
				$this->lo_mdl->usrprmdef = $lo_rs;
				
				$this->lo_mdl->buscod = $this->co_reg->sec->buscod;
				$this->lo_mdl->usrcod = $this->data['usrcod'];
				
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;

			// LIST by TEXT (definicion de parametros) PENDIENTE NORMALIZAR JUNTO A LA VISTA SYSSECUSRPRM
      case '#18':
				$lo_usrprm_mdl = $this->co_reg->load->model('syssecusrprm');
				$lv_prm = array('vewfldflt' =>(isset($lp_prm['prmtxt'])?'[~fltrow~]prmtxt'.chr(9).'='.chr(9).chr(9).$lp_prm['prmtxt'].chr(9).chr(9):'') );
				$lo_rs = $lo_usrprm_mdl->getDefinitions($lv_prm);
				return $this->co_reg->document->getJson( $lo_rs );
        break;
				
    }
  }
}
?>