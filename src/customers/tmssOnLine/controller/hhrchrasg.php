<?php
final class hhrchrasgController extends tmssController2 {
  
  function initialize(){
    $this->CONTROLLER='hhrchrasg';$this->MODEL='hhrchrasg';$this->VIEW='hhrchrasg';$this->ID='hhrchrasgcod';$this->enable_sysdoccls=true;$this->preventCopy = array('hhrchrasgcodext');
  }
            
  function additionalFunctions($lp_act){
    switch ( $lp_act ) {
			// OBTENER ATRIBUTOS DE CARGOS SEGÚN CLASE
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'hhrchrasgcod' => $this->post['hhrchrasgcod'],
												'hhrchrtypcod' => $this->post['hhrchrtypcod'],
												'srcobjtyp' => $this->post['srcobjtyp'],
												'srcobjcod' => $this->post['srcobjcod']
												);
				$lo_data = $this->mdl->getClassAtr(array(), $lv_prm);
				return $this->co_reg->document->getJson( array('data'=>$lo_data) ); 
        break;

      // LIST by TEXT
      case '#18':
        $lv_srcobjtyp = isset($this->prm['srcobjtyp']) ? $this->prm['srcobjtyp'] : (isset($this->post['srcobjtyp']) ? $this->post['srcobjtyp'] : '');
        $lv_srcobjcod = isset($this->prm['srcobjcod']) ? $this->prm['srcobjcod'] : (isset($this->post['srcobjcod']) ? $this->post['srcobjcod'] : '');
        $lv_prm = array('vewmaxrec' =>'10',
                        'vewfldflt' => ($lv_srcobjtyp?'[~fltrow~]ca.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lv_srcobjtyp.chr(9).chr(9):'').
                                       ($lv_srcobjcod?'[~fltrow~]ca.srcobjcod'.chr(9).'='.chr(9).chr(9).$lv_srcobjcod.chr(9).chr(9):'').
                                       (isset($this->prm['hhrchrasgtxt'])?'[~fltrow~]ca.hhrchrasgtxt'.chr(9).''.chr(9).$this->prm['hhrchrasgtxt'].chr(9).chr(9).chr(9):'').
                                       '[~fltrow~]ca.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );
        $lo_data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data) );        
        break;
      // ATROLD. devuelve la vista del histórico de antigüedad
      case '#atrold': 
        if (isset($this->post['hstatr'])){
          $this->mdl->atrold = json_decode(html_entity_decode($this->post['hstatr']),true);
          
        }else{
          $this->mdl->atrold = array();
        }
        
				//modo solo lectura
        $this->mdl->readonly = (isset($this->post['readonly'])?$this->post['readonly']:'false');
        
        //devuelve la vista del dialogo de escala de precios
        return $this->co_reg->document->getView( 'hhrlqdchrasgatrold', array('data'=>$this->mdl,'actcod'=>$lp_act ) );
				break;
    }
  }
}
?>