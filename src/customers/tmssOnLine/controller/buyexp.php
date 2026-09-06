<?php 
final class buyexpController extends tmssController2 {  
  function initialize(){
    $this->CONTROLLER='buyexp';$this->MODEL='buyexp';$this->VIEW='buyexp';$this->ID='buyexpcod';$this->enable_sysdoccls=true;$this->extraRet = array('objtyp'=>'BUY_EXP');
  }
  
  function afterCreate(){
    // cargo datos de la empresa
    $lo_busmdl = $this->co_reg->load->model('admbus');
    $lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
    $this->mdl->curcod = $lo_busmdl->curcod;	// moneda
    $this->mdl->srcobjcod=(isset($lo_post['srcobjcod']) && isset($lo_post['srcobjtxt'])?$lo_post['srcobjcod']:'');
    $this->mdl->srcobjtxt=(isset($lo_post['srcobjcod']) && isset($lo_post['srcobjtxt'])?$lo_post['srcobjtxt']:'');
  }
  
  function additionalFunctions($lp_act){
    switch ( $lp_act ) {
      // ACCOUNTING CANCEL. cancela la contabilizacion del documento
      case '#29':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lo_post = $this->co_reg->request->post;
        $this->mdl->accountingcancel( array('buyexpcod'=>$lo_post['buyexpcod']));
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        break;

      // SHOW DETAIL. devuelve vista con el detalle
      case '#13':
        // cargo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsmdl->load( array('sysdocclscod'=>$this->post['sysdocclscod']) );
        $this->mdl->sysdoccls = $lo_docclsmdl;
        
        // asigno valores desde post
        $this->mdl->impobjlst = json_decode( html_entity_decode($this->post['impobjlst']??'[]'), true);
        $this->mdl->buyexpdoccmt = ($this->post['buyexpdoccmt']??'');
        $this->mdl->sysdocrejcod = ($this->post['sysdocrejcod']??'');
        $this->mdl->readonly = ($this->post['readonly']??'false');
        
        return $this->co_reg->document->getView('buyexpdoc',array('data'=>$this->mdl,'objtyp'=>'BUY_EXP','actcod'=>$this->act));
        break;
    }
  }
}
?>