<?php
final class hltargtrzevt extends tmssAction {
 
  protected $co_reg;
  private $data = array();
    
  
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
  }
  

  /**
   * save single object
   */     
  function save() {
/*
    / / obtengo y combino los valores de $_POST[] con el objeto actual
    $lo_dat = array_replace( $this->data, $this->co_reg->request->post );
    
    / / determino si es creación o modificación
    if ( isset($this->data['usrcod']) && !empty($this->data['usrcod']) ) {
      $lv_act = '02';
      $lv_cod = $this->data['usrcod'];
    } else {
      $lv_act = '01';
      $lv_cod = '';
    }
    
    / / preparo & ejecuto SP
    $lv_sqlprm = array( $lv_act, $this->co_reg->sec->usrcod, $lv_cod, $lo_dat['adrfrtnme'], $lo_dat['adrlstnme'], $lo_dat['adreml'], $lo_dat['lngcod'], $lo_dat['docsts'], $lo_dat['adrstr'], $lo_dat['adrphn001'], $lo_dat['adrphnmbl'], $lo_dat['adrcnthrs'], $lo_dat['usrwndrfhtme'], $lo_dat['usrwndsty'] );
    $lv_sqltxt = 'SYS_SEC_USR_DEF (?,?,?,?,?,?,?,?,null,?,?,?,?,?,?)';
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $lv_sqltxt , $lv_sqlprm );
    if ( $lo_rs && count($lo_rs)>0 ) {
      $this->data['usrcod'] = $lo_rs[0]['usrcod'];
      return 'o se grabo o hubo un error';
    } else {
      return 'hubo un error';      
    }
    / /return json_encode( $lv_ret );
*/
  }
  
  
  /**
   * load single object
   */     
  function load( $lp_id ) {
/*
    $lv_sqlprm = array( '03', $this->co_reg->sec->usrcod, $lp_id );
    $lv_sqltxt = 'CRM_CNT_TYP_DEF (?,?,?)';
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $lv_sqltxt , $lv_sqlprm );
    if ( $lo_rs && count($lo_rs)>0 ) {
      $this->data = $lo_rs[0];
      return $this->data;
    } else {
      / / no se encontró el registro
      / / FALTA: que devuelvo?
      return false;
    }
*/
  }
  
  
  /**               
   * get list of objects
   */     
  function getList( $lp_prm ) {
    $lo_vew = $this->co_reg->load->model('grlvew');    
    $lv_sqlprm = array( '08', $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, $lo_vew->parseViewOptions($lp_prm) );
    $lv_sqltxt = 'HLT_ARG_TRZ_EVT_DEF (?,?,?,null,null,null,null,null,null,?)';
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $lv_sqltxt, $lv_sqlprm, 0 );
    if ( $lo_rs && count($lo_rs)>0 ) {
      $this->data = $lo_rs;
    } else {
      $this->data['data_sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
    $this->data['data_sqlprm'] = $lv_sqlprm;
    $this->data['data_sqltxt'] = $lv_sqltxt;
    return $this->data;
  }
  
  
  /**
   * delete single object
   */       
  function delete( $lp_id ) {
/*
    $lv_sqlprm = array( '04', $this->co_reg->sec->usrcod, $lp_id );
    $lv_sqltxt = 'CRM_CNT_TYP_DEF (?,?,?)';
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $lv_sqltxt , $lv_sqlprm );
    if ( $lo_rs && count($lo_rs)>0 ) {
      $this->data = $lo_rs[0];
    } else {
      //
    }
*/
  }
    
}
?>