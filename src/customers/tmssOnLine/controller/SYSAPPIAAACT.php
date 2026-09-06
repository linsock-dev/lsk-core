<?php
final class sysappiaaactController extends tmssController2 {
  function initialize(){ $this->MODEL='sysappiaaact'; $this->VIEW='sysappiaa'; $this->ID='sysappiaaactcod'; }

  function additionalFunctions($lp_act){
    switch( $lp_act ){
      case '#tasklist':
        $this->mdl = $this->co_reg->load->model( $this->MODEL );
        
        // recupero todas las activaciones
        $lv_tsklst = $this->mdl->getList();
        // parseo correctamente el JSON y los atributos de cada activación antes de enviarlo
        if ( $lv_tsklst ){ 
          foreach ( $lv_tsklst as &$lv_tskrow ){
            $lv_tskrow['sysappiaaactprmjsn'] = html_entity_decode($lv_tskrow['sysappiaaactprmjsn'], ENT_QUOTES | ENT_HTML5, 'UTF-8');
            $lv_tskrow['sysappiaaactatr'] = html_entity_decode($lv_tskrow['sysappiaaactatr'], ENT_QUOTES | ENT_HTML5, 'UTF-8');
          }
        }
        
        return $this->co_reg->document->getJson( array( 'data'=>$lv_tsklst, 'errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt ) );
    }
  }

}
?>