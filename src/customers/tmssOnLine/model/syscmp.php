<?php
final class syscmp extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = '';

  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }		
	
	// GETSTRUCTURE
	// obtiene la estructura de la base de datos indicada
	function getStructure( $lp_cnx ) {
		$lv_curcnx = $this->co_reg->sec->bsecnx;
				
		$this->co_reg->db->clear_customer_connection( 9 );
		
		$this->co_reg->sec->bsecnx = $lp_cnx;
		$this->co_reg->db->get_customer_connection( 9 );
		
		$this->sysdata['sqltxt'] = 'SYS_CMP_DEF (?,?,null,null)';

		// obtiene objetos
		$this->sysdata['sqlprm'] = array( '13', $this->co_reg->sec->usrcod );
    $this->data['sysobj'] = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );
		
		// obtiene columnas (tablas)
		$this->sysdata['sqlprm'] = array( '23', $this->co_reg->sec->usrcod );
    $this->data['syscol'] = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );
		
		// obtiene storedprocedures/funciones
		$this->sysdata['sqlprm'] = array( '33', $this->co_reg->sec->usrcod );
    $this->data['syscmt'] = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );
				
		// obtiene claves primarias/indices
		$this->sysdata['sqlprm'] = array( '43', $this->co_reg->sec->usrcod );
    $this->data['sysinx'] = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );

		// obtiene claves primarias/indices columnas
		$this->sysdata['sqlprm'] = array( '53', $this->co_reg->sec->usrcod );
    $this->data['sysinxcol'] = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );

		$this->co_reg->sec->bsecnx = $lv_curcnx;
	}
	
	// SETSTRUCTURE
	// envía un objeto a la base de datos indicada
	function setStructure( $lp_cnx, $lp_typ, $lp_key, $lp_qry ) {
		$lv_curcnx = $this->co_reg->sec->bsecnx;				
		$this->co_reg->db->clear_customer_connection( 9 );
		$this->co_reg->sec->bsecnx = $lp_cnx;
		$this->co_reg->db->get_customer_connection( 9 );
		
		$this->sysdata['sqltxt'] = 'SYS_CMP_DEF (?,?,?,?,?)';
		$lv_act = '';
		if ( $lp_typ=='U' ) { $lv_act = '71'; }
		if ( $lp_typ=='P' ) { $lv_act = '81'; }
		if ( $lp_typ=='FN' ) { $lv_act = '91'; }
		$this->sysdata['sqlprm'] = array( $lv_act , $this->co_reg->sec->usrcod, $lp_key, $lp_qry, '' );
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );
		$this->data['rs'] = $lo_rs;
		$this->co_reg->db->clear_customer_connection( 9 );
		$this->co_reg->sec->bsecnx = $lv_curcnx;
		return $lo_rs;
	}

	// UPDATESTRUCTURE
	// actualiza un objeto a la base de datos indicada
	function updateStructure( $lp_cnx, $lp_typ, $lp_key, $lp_qry, $lp_key2 ) {
		$lv_curcnx = $this->co_reg->sec->bsecnx;
		$this->co_reg->db->clear_customer_connection( 9 );
		$this->co_reg->sec->bsecnx = $lp_cnx;
		$this->co_reg->db->get_customer_connection( 9 );
		
		$this->sysdata['sqltxt'] = 'SYS_CMP_DEF (?,?,?,?,?)';
		$lv_act = '';
		//if ( $lp_typ=='U' ) { $lv_act = '72'; }
		if ( $lp_typ=='PK' ) { $lv_act = '75'; }
		if ( $lp_typ=='IX' ) { $lv_act = '76'; }
		if ( $lp_typ=='P' ) { $lv_act = '82'; }
		if ( $lp_typ=='FN' ) { $lv_act = '92'; }
		$this->sysdata['sqlprm'] = array( $lv_act , $this->co_reg->sec->usrcod, $lp_key, $lp_qry, $lp_key2 );
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'], $this->sysdata['sqlprm'], 9 );
		$this->data['rs'] = $lo_rs;
		$this->co_reg->db->clear_customer_connection( 9 );
		$this->co_reg->sec->bsecnx = $lv_curcnx;
		return $lo_rs;
	}
}
?>