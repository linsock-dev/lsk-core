<?php
final class hhrorgchtwrk extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'hhrorgchtwrkcod';
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
	// CREATE. inicializa el objeto
	function create() {
		$this->data = array();
		$this->sysdata = array();
		$this->data['asg'] = array();
		$this->data['cap'] = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    
    $lp_dat['hhrorgchtwrkdat'] = '';
    
    if(isset($lp_dat['asg'])){
      $lp_dat['asg'] = json_decode(html_entity_decode($lp_dat['asg']),true);
      
      // obtengo asignaciones
      $lv_asg_tag = '';
      foreach($lp_dat['asg'] as $lv_asg){
        $lv_asg['hhremptmestr'] = isset($lv_asg['hhremptmestr']) && $lv_asg['hhremptmestr'] ? $lv_asg['hhremptmestr'] : date('d/m/Y');
        if(isset($lv_asg['deleted']) && isset($lv_asg['hhrorgchtwrkempcod'])){
          $lv_asg_tag .= '<asgrow>'
            . '<hhrorgchtwrkempcod>'.$lv_asg['hhrorgchtwrkempcod'].'</hhrorgchtwrkempcod>'
            . '<hhremptmecod>'.$lv_asg['hhremptmecod'].'</hhremptmecod>'
            . '<deleted>X</deleted>'
            . '</asgrow>';
        }else if(!isset($lv_asg['deleted'])){
          $lv_asg_tag .= '<asgrow>'
            . (isset($lv_asg['hhrorgchtwrkempcod']) ? '<hhrorgchtwrkempcod>'.$lv_asg['hhrorgchtwrkempcod'].'</hhrorgchtwrkempcod>' : '')
            . (isset($lv_asg['hhremptmecod']) ? '<hhremptmecod>'.$lv_asg['hhremptmecod'].'</hhremptmecod>' : '')
            . '<hhrempcod>' . $lv_asg['hhrempcod'] . '</hhrempcod>'
            . '<wrkplccod>' . $lv_asg['wrkplccod'] . '</wrkplccod>'
            . '<hhrtmerngcod>' . $lv_asg['hhrtmerngcod'] . '</hhrtmerngcod>'
            . '<hhremptmestr>' . $this->co_reg->db->sqldte($lv_asg, 'hhremptmestr') . '</hhremptmestr>'
            . '<wrkstepft>' . $lv_asg['wrkstepft'] . '</wrkstepft>'
            .'</asgrow>';
          
        }
      }
      
      $lv_asg_tag = $lv_asg_tag ? '<asg>' . $lv_asg_tag . '</asg>' : '';
      
      $lp_dat['hhrorgchtwrkdat'] .= $lv_asg_tag;
    }
      
    // obtengo capacidades
    if(isset($lp_dat['cap'])){
      $lp_dat['cap'] = json_decode(html_entity_decode($lp_dat['cap']),true);
      
      $lv_cap_tag = '';
      foreach($lp_dat['cap'] as $lv_cap){
        if(isset($lv_cap['deleted']) && isset($lv_cap['hhrorgchtwrkcapcod'])){
          $lv_cap_tag .= '<row>'
            . '<hhrorgchtwrkcapcod>'.$lv_cap['hhrorgchtwrkcapcod'].'</hhrorgchtwrkcapcod>'
            . '<deleted>X</deleted>'
            . '</row>';
        }else if(!isset($lv_cap['deleted'])){
          $lv_cap_tag .= '<row>'
            . (isset($lv_cap['hhrorgchtwrkcapcod']) ? '<hhrorgchtwrkcapcod>'.$lv_cap['hhrorgchtwrkcapcod'].'</hhrorgchtwrkcapcod>' : '')
            . '<wrkplccod>' . $lv_cap['wrkplccod'] . '</wrkplccod>'
            . '<hhrorgchtwrkpft>' . $lv_cap['hhrorgchtwrkpft'] . '</hhrorgchtwrkpft>'
            . '<hhrorgchtwrknonpft>' . (isset($lv_cap['hhrorgchtwrknonpft'])?$lv_cap['hhrorgchtwrknonpft']:0) . '</hhrorgchtwrknonpft>'
            . '<hhrorgchtwrkcaptyp>' . (isset($lv_cap['hhrorgchtwrkcaptyp']) ? $lv_cap['hhrorgchtwrkcaptyp'] : 0) . '</hhrorgchtwrkcaptyp>'
            .'</row>';
        }
      }
      $lv_cap_tag = $lv_cap_tag ? '<cap>' . $lv_cap_tag . '</cap>' : ''; 
      $lp_dat['hhrorgchtwrkdat'] .= $lv_cap_tag;
    }
    
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
	
  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de datos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
    
    $lp_vewopt['vewfldgrp'] = (isset($lp_vewopt['vewfldgrp']) ? $lp_vewopt['vewfldgrp'].', ' : '').'w.hhrorgchtwrkcod, w.hhrorgchtcod, w.wrkstecod, s.wrkstetxt, w.wrkstehghcod, wekemppfttotcap, wekempnonpfttotcap, wekhrspfttotcap, wekhrsnonpfttotcap';
    $lp_vewopt['vewfldgrpcal'] = (isset($lp_vewopt['vewfldgrpcal']) ? $lp_vewopt['vewfldgrpcal'].', ' : '')
      .' SUM((case when et.wrkstepft=1 then isnull(r.hhrtmerngwekhrs, 0) else 0 end)) as wekhrspfttot, SUM((case when et.wrkstepft=1 then 1 else 0 end)) /*COUNT(e.hhremptmecod)*/ as emptot ';
    
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // GET LIST. devuelve recordset de datos que cumplen criterio y sus ancestros
  function getListWithAncestors( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
    
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '10', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }

	// SAVE. graba el objeto
  function massiveSave( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '11', $this->data, $lo_out_data );
  }
  
	// CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtwrkcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtcod'), 
																			$this->co_reg->db->sqldat($lp_in,'wrkstecod'), 
																			$this->co_reg->db->sqldat($lp_in,'wrkstehghcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgwrkatr', false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtwrkdat',false),
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtwrk',false)
																		);
		$this->sysdata['sqltxt'] = 'HHR_ORG_CHT_WRK_DEF (?,?,?,?,?,?,?,?,?,?,null,null,null,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='10') {
      if($this->errtyp!='E'){
				$lp_out = $lo_rs;
      }else{
        $lp_out=array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt);
      }
			
		// devuelve ID (registro individual)
		} else {
      if ( $lo_rs && count($lo_rs)>0 ) {
        if( $this->errtyp!='E' ){
					$lp_out = $lo_rs[0];
					$this->data[self::ID] = ($lp_out[self::ID]??array_values($lp_out)[0]);
        }
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -9999;
				$this->errtxt = $this->co_reg->language->message('UnexpectedError', $this->sysdata['sqlstm'] );
			}
		}
    
    // H O R A R I O S
    if($lp_action=='03' && $this->errcod==0){
			$lo_emptmemdl = $this->co_reg->load->model('hhrorgchtwrkemp');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]we.hhrorgchtwrkcod'.chr(9).'='.chr(9).chr(9).$lp_out['hhrorgchtwrkcod'].chr(9).chr(9).
                     								'[~fltrow~]t.hhremptmestr'.chr(9).'<='.chr(9).chr(9).date('Y-m-d').chr(9).chr(9).
                      							'[~fltrow~]t.hhremptmeend'.chr(9).'>='.chr(9).chr(9).date('Y-m-d').chr(9).chr(9).
                     								'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                     								'[~fltrow~]we.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
			$lp_out['asg'] = $lo_emptmemdl->getList( $lv_prm );
    }
    
    // C A P A C I D A D
    if($lp_action=='03' && $this->errcod==0){
			$lo_capmdl = $this->co_reg->load->model('hhrorgchtwrkcap');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]c.hhrorgchtwrkcod'.chr(9).'='.chr(9).chr(9).$lp_out['hhrorgchtwrkcod'].chr(9).chr(9));
      $lp_out['cap'] = $lo_capmdl->getList( $lv_prm );
    }
    
		return ($this->errcod==0?true:false);
	}
}
?>