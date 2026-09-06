<?php
class tmssInput {  
  private $co_reg;
  private $data = array();
  private $gv_reqfld = array();
  
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
		$this->gv_reqfld = '';
  }
  
	public function getReqFields(){ return $this->gv_reqfld; }
	public function setReqFields( $lp_reqfld=array() ){ $this->gv_reqfld = $lp_reqfld; }
	public function requiredFields( $lp_reqfld = array() ) { $this->gv_reqfld = $lp_reqfld; }
	
  public function GetField( $lp_fld ) {
    If ( count($this->data)==0 ) { 
      $this->InitFields(); 
    }
    return ( isset($this->data[$lp_fld])?$this->data[$lp_fld]:array());
  }
  
  private function InitFields() {
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( 'SYS_GRL_FLD_DEF ( ?, ? )', array( '18', $this->co_reg->sec->usrcod ), 0 );
    if ( $lo_rs && count($lo_rs)>=1 ) {
      foreach( $lo_rs as $lv_row ) {
        $this->data[ strtolower($lv_row["sysfld"]) ] = $lv_row;
      }
    }
  }

  private function ClearInputsCache() { $this->data = array(); }
	
}