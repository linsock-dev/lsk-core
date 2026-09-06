<?php
final class hhrlictypController extends tmssController2 {
	function initialize(){$this->MODEL='hhrlictyp';$this->VIEW='hhrlictyp';$this->ID='hhrlictypcod';$this->preventCopy = array('hhrlictypcodext');}
  
	function additionalFunctions($lp_act){
		switch ( $lp_act ) {
    	case '#18':
        $lv_prm = array(
            'vewmaxrec' => '10',
            'vewfldflt' => (isset($this->prm['hhrlictyptxt'])?'[~fltrow~]hhrlictyptxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($this->prm['hhrlictyptxt']).chr(9).chr(9).chr(9):'').
                           (isset($this->prm['hhrlictypatrautges'])?'[~fltrow~]hhrlictypatrautges'.chr(9).'='.chr(9).chr(9).$this->co_reg->db->sqldata($this->prm['hhrlictypatrautges']).chr(9).chr(9):'').
                           '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
        );
        $this->data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson($this->data);
      break;
		}
	}
}