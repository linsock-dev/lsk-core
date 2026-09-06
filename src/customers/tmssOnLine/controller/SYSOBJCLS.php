<?php 
final class sysobjclsController extends tmssController2 {
  function initialize(){ $this->MODEL='sysobjcls'; $this->VIEW='sysobjcls'; $this->ID='sysobjclscod'; }
  
  function delete() {    
    $lo_post = $this->co_reg->request->post;
    $this->lo_mdl = $this->co_reg->load->model($this->MODEL);
    $lv_objmdl = $this->co_reg->load->model('sysobj');
    
    $lv_prm = array( 'vewmaxrec' =>'1', 'vewfldflt' =>'[~fltrow~]c.sysobjclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjclscod'] .chr(9).chr(9) );
    $lv_objlst = $lv_objmdl->getList($lv_prm);
    
    if (count($lv_objlst) != 0){
    	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se puede borrar la clase. Hay objetos asociados.') );
    } else{
      $this->lo_mdl->delete();
      return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
    }
  }
}
?>