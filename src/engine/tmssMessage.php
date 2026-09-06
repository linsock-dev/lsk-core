<?php

class tmssMessage {

  private $data = array();
  private $co_reg;


 
  function __construct ( &$lp_reg ) {
    $this->co_reg = $lp_reg; 
  }
  
  function __destruct () { }
  
  function __get( $lp_key ) {
    return (isset($this->data[$lp_key])?$this->data[$lp_key]:'');
  }

  function __set( $lp_key , $lp_val ) {
    $this->data[$lp_key] = $lp_val;
  }

  public function getHtml() {
    $lv_typ = '';
    $lv_typcod = (isset($this->data['type'])?$this->data['type']:'');
    switch ($lv_typcod) {
      case 'E':
        $lv_typ = 'alert-danger';
        break;
      case 'W':
        $lv_typ = 'alert-warning';
        break;
      case 'S':
        $lv_typ = 'alert-success';
        break;
      default:
        $lv_typ = 'alert-info';
        break;
    }
    $lv_buffer = '<div class="alert '.$lv_typ.' alert-dismissable" role="alert">'
                .'<button type="button" class="close" data-dismiss="alert">&times;</button>'
                .(isset($this->data['text'])?$this->data['text']:'')
                .'</div>';
    return $lv_buffer;
  }

}