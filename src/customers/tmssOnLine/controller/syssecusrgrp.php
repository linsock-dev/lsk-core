<?php
final class syssecusrgrpController extends tmssController {
	const MODEL = 'syssecusrgrp';
	const VIEW  = 'syssecusrgrp';
	const ID = 'usrcod';								
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  // MAIN METHOD  
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
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->data['actcod'] = '02';
					if ( isset($lo_post['usrgrpcod']) ) {
						$lv_prm['usrgrpcod'] = $lo_post['usrgrpcod'];
					} else {
						$lv_prm['usrcod'] = $lo_post['usrcod'];
					}
					return $this->getView( $lv_prm );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
				if ( isset($lo_post['usrgrpcod']) ) {
					$lv_prm['usrgrpcod'] = $lo_post['usrgrpcod'];
				} else {
					$lv_prm['usrcod'] = $lo_post['usrcod'];
				}
				return $this->getView( $lv_prm );
        break;
				
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
    }

  }
	
	
	// FUNCION. getView recuperara una vista segun el parametro que reciba
	private function getView( $lp_data=array() ) {	
		$lo_sysgrp_rs = array();
		$lo_sysusr_rs = array();
		$lo_usrgrp_rs = array();
		$lv_vew = '';
		if ( isset($lp_data['usrcod']) ) {
			$lv_vew = 'syssecusrgrp';
			// cargo datos de usuario
			$lo_usr_mdl = $this->co_reg->load->model('syssecusr');
			$lo_usr_mdl->load( $lp_data );
			// cargo todos los grupos de la empresa
			$lo_grp_mdl = $this->co_reg->load->model('syssecgrp');
			$lo_sysgrp_rs = $lo_grp_mdl->getList();
			// cargo empresas de usuario
			$lo_usrgrp_rs = $this->lo_mdl->load( $lp_data );
		} else {
			$lv_vew = 'syssecgrpusr';
			// cargo datos de usuario----
			$lo_usr_mdl = $this->co_reg->load->model('syssecgrp');
			$lo_usr_mdl->load( $lp_data );
			// cargo todos los usuarios asignados a la empresa
			$lo_usrbus_mdl = $this->co_reg->load->model('syssecusrbus');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]u.buscod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod .chr(9).chr(9));
			$lo_sysusr_rs = $lo_usrbus_mdl->getList($lv_prm);
			// cargo todos los usuarios asignados al grupo
			$lo_usrgrp_mdl = $this->co_reg->load->model('syssecusrgrp');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]ug.usrgrpcod'.chr(9).'='.chr(9).chr(9).$lp_data['usrgrpcod'].chr(9).chr(9),
											'vewfldord' =>'u.usrtxt');
			$lo_usrgrp_rs = $lo_usrgrp_mdl->getList($lv_prm);
		}
	
    return $this->co_reg->document->getView( $lv_vew, array('data'=>$lo_usr_mdl,'actcod'=>$this->data['actcod'], 'sysusr'=> $lo_sysusr_rs, 'sysgrp'=> $lo_sysgrp_rs, 'usrgrp'=> $lo_usrgrp_rs) );
	}
}
?>