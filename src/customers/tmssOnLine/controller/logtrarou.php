<?php
final class logtrarouController extends tmssController2 {
  
  function initialize(){
    $this->CONTROLLER = 'logtrarou';
    $this->MODEL = 'logtrarou';
    $this->VIEW = 'logtrarou';
		$this->ID = 'traroucod';
  }
	
  function afterCopy(){
    $lv_dat = $this->mdl->getData();
    foreach($lv_dat as $lv_key=>&$lv_val){
      if( is_array($lv_val) ){
        // 2do nivel de profundidad de array
        foreach($lv_val as &$lv_row2){
          if (is_array($lv_row2)) {
            foreach($lv_row2 as $lv_key2=>&$lv_val2){
              if(strtolower($lv_key2) == 'trarouzoncod'){ $lv_val2=null; }
            }
            unset($lv_val2);
          }
        }
        unset($lv_row2);
      } else if(strtolower($lv_key) == 'trarouzoncod'){ $lv_val=null; }
    }
    unset($lv_val);
  	$this->mdl->setData( $lv_dat );
  }
      
	function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// GETLIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['traroutxt'])?'[~fltrow~]r.traroutxt'.chr(9).''.chr(9).$this->prm['traroutxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_data );
        break;
			
			
			// ROUTE DETERMINATION
			case '#33':
				$lo_post = $this->post;
				
				$lv_srcobjtyp = (isset($lo_post['srcobjtyp'])?$lo_post['srcobjtyp']:'');
				$lv_srcobjcod = (isset($lo_post['srcobjcod'])?$lo_post['srcobjcod']:''); 
				$lv_srccntcod = (isset($lo_post['srccntcod'])?(strval($lo_post['srccntcod'])==0?'':$lo_post['srccntcod']):'');
				
				// obtengo zona de transporte (de contacto o de cliente)
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>($lv_srccntcod!=''?'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9):'').
																			($lv_srccntcod!=''?'[~fltrow~]a.adrsrccod'.chr(9).'='.chr(9).chr(9).$lv_srccntcod.chr(9).chr(9):'').
																			($lv_srccntcod==''?'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).$lv_srcobjtyp.chr(9).chr(9):'').
																			($lv_srccntcod==''?'[~fltrow~]a.adrsrccod'.chr(9).'='.chr(9).chr(9).$lv_srcobjcod.chr(9).chr(9):'').
																			'[~fltrow~]isnull(a.trazoncod,0)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																			'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsadr = $lo_adrmdl->getList($lv_prm);
				
				// determino ruta
				$lo_rs = array();
				if( count($lo_rsadr)==1 ) {
					$lo_rouzonmdl = $this->co_reg->load->model('logtrarouzon');
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]rz.trazoncod'.chr(9).'='.chr(9).chr(9).$lo_rsadr[0]['trazoncod'].chr(9).chr(9).
																				'[~fltrow~]rz.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
													);
					$lo_rs = $lo_rouzonmdl->getList($lv_prm);
				}
        return $this->co_reg->document->getJson( $lo_rs );
				break;
    }
  }
}
?>