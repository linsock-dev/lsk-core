<?php
final class stkmat extends tmssAction2 {
  const OBJTYP = 'STK_MAT';
  function initialize(){ $this->ID = 'matcod'; }
	
	// CREATE. inicializa el objeto
	function create($lp_data=array()) {
    parent::create();
		$this->data['acc'] = $this->co_reg->load->model('grldatacc');
		$this->data['mattax'] = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
		// prepara atributos del material
    $lv_buf = '';
    $lv_buffer = ($lp_dat['matatr']??'');
    if ($lv_buffer!='') {
      $lv_buffer = html_entity_decode($lv_buffer);
      $lv_matatr_arr = json_decode($lv_buffer,true);
      for ($i=0; $i<count($lv_matatr_arr); $i++) {
        if($lv_matatr_arr[$i]['matatrnme']!='' && isset($lv_matatr_arr[$i]['matatrnme'])){
          $lv_buf .= '<atr'.$i.'><matatrnme>' . $lv_matatr_arr[$i]['matatrnme'] . '</matatrnme><matatrval>'. ($lv_matatr_arr[$i]['matatrval']??'') .'</matatrval></atr'.$i.'>';
        }
      }
       $lp_dat['matatr']=$lv_buf;
    }
		
		return parent::save( $lp_dat, $lp_authCheck );
  }
  
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'matcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'matcodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'mattxt'),
																			$this->co_reg->db->sqldat($lp_in,'matclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'matuntcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqlnum($lp_in,'matcst'),	
                                     	$this->co_reg->db->sqldat($lp_in,'matcstcurcod'),
                                     	$this->co_reg->db->sqlnum($lp_in,'matcstqty'),
                                     	$this->co_reg->db->sqldat($lp_in,'matcstuntcod'),
																			$this->co_reg->db->sqldat($lp_in,'matusebch'),
                                     	$this->co_reg->db->sqldat($lp_in,'matuseser'),
                                     	$this->co_reg->db->sqlnum($lp_in,'matminqtydel'), 
																			$this->co_reg->db->sqlnum($lp_in,'matpckdel'),
                                     	$this->co_reg->db->sqldat($lp_in,'matatr', false),
                                     	$this->co_reg->db->sqldat($lp_in,'mathiecod'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'matstkday'),
                                     	$this->co_reg->db->sqldat($lp_in,'matgencod'),
                                     	$this->co_reg->db->sqldat($lp_in,'matserdocclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'matbchdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'STK_MAT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,null,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		A C C
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_accmdl = $this->co_reg->load->model('grldatacc');
			$lp_in['accsrctyp'] = self::OBJTYP;
			$lp_in['accsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_accmdl->load( $lp_in );
				$lp_out['acc'] = $lo_accmdl;
			} else if( $lo_accmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_accmdl->errcod;
				$this->errtxt = $lo_accmdl->errtxt;
			} else {
				$lp_out['accnum']=$lo_accmdl->accnum;
			}
		}
		
		//		T A X 
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('stkmattax');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]mt.matcod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['mattax'] = $lo_taxmdl->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>