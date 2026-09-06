<?php
final class hhrmedcovController extends tmssController2 {
	function initialize(){
    $this->MODEL='hhrmedcov';$this->VIEW='hhrmedcov';$this->ID='hhrmedcovcod';$this->enable_sysdoccls=true;$this->preventCopy = array('hhrmedcovcodext');;
  }
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {    
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hhrmedcovtxt'])?'[~fltrow~]isnull(c.hhrmedcovtxtsht,^^)+isnull(c.hhrmedcovtxt,^^)'.chr(9).''.chr(9).$this->prm['hhrmedcovtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				$lv_ret = array();
				foreach($lo_data as $lv_row){
					$lv_ret[] = array('hhrmedcovcod'=>$lv_row['hhrmedcovcod'],'hhrmedcovtxt'=>$lv_row['hhrmedcovtxtsht'].($lv_row['hhrmedcovtxtsht']!=''?' - ':'').$lv_row['hhrmedcovtxt']);
				}
				return $this->co_reg->document->getJson( $lv_ret );
        break;
    }
  }
}
?>