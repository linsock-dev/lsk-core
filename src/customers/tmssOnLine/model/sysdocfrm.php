<?php 
final class sysdocfrm extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'sysdocfrmcod';
  const OBJTYP = 'SYS_FRM';

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
    $this->data['sysdocfrmfld'] = array();
    $this->data['sysdocfrmfldatr'] = array();
		$this->sysdata = array();
	}

  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
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

  // GET LIST. devuelve lista de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew');}
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions( $lp_vewopt );
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }

	// CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     	$this->co_reg->db->sqldat($lp_in, 'sysdocfrmcod'),
                                     	$this->co_reg->db->sqldat($lp_in, 'sysdocfrmcodext'),
                                     	$this->co_reg->db->sqldat($lp_in, 'sysdocfrmtxt'),
                                     	$this->co_reg->db->sqldat($lp_in, 'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options')
																		);
		$this->sysdata['sqltxt'] = 'SYS_DOC_FRM_DEF (?, ?, ?, ?, ?, ?, ?, ?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' ) {
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

    //		A T R I B U T O S
		if ( ($lp_action=='01' ||$lp_action=='02' || $lp_action=='03') && $this->errcod==0 ) {
			$lo_frmfldatrmdl = $this->co_reg->load->model('sysdocfrmfldatr');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
			$lp_out['sysdocfrmfldatr'] = $lo_frmfldatrmdl->getList( $lv_prm );
		}

    //  E L E M E N T O S
    if ( ($lp_action=='02' || $lp_action=='03') && $this->errcod==0 ) {
			$lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'='.chr(9).chr(9).$lp_in['sysdocfrmcod'].chr(9).chr(9).
                                    '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                     	'vewfldord' => 'sysdocfrmfldord');
			$lp_out['sysdocfrmfld'] = $lo_frmfldmdl->getList( $lv_prm );
		}

		return ($this->errcod==0?true:false);
	}
}
?>