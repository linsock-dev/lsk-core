<?php
final class slsgrpController extends tmssController2 {  
	function initialize(){$this->MODEL='slsgrp';$this->VIEW='slsgrp';$this->ID='slsgrpcod';$this->enable_sysdoccls=true;}
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
          
      // GETLIST by TEXT
      case  '#18' :
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $lv_prm = array( 'vewmaxrec'  => 10 , 
                        'vewfldflt'  =>(isset($this->prm[ 'slsgrptxt' ])? '[~fltrow~]sg.slsgrptxt' .chr(9). '' .chr(9).$this->prm[ 'slsgrptxt' ].chr(9).chr(9).chr(9):  '')
                        .((isset($this->prm[ 'sysdocclscod' ])?$lp_prm[ 'sysdocclscod' ]: '' )!= '' ? '[~fltrow~]dc.sysdocclscod' .chr(9). 'IN' .chr(9).chr(9).str_ireplace( ';' ,chr(10),$lp_prm[ 'sysdocclscod' ]).chr(9).chr(9): '' )
                        . '[~fltrow~]sg.docsts' .chr(9). '=' .chr(9).chr(9). 'A' .chr(9).chr(9));
        $lo_data = $this->mdl->getList($lv_prm,null,null,false);        
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'data'=>$lo_data) );
        break;
    }
  }
}
?>