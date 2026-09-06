<?php
final class tmssLoader {
	private $co_reg;
	private $co_ctr;
	private $co_mdl;
	private $co_vew;
  
	public function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }  
	
	public function controller( $lp_ctr, $lp_dir='' ) {
		$lv_dir = ($lp_dir!=''?$lp_dir:DIR_APPLICATION);
		$lv_fle = $lv_dir . '../tmssOnLine/controller/' . $lp_ctr . '.php';
		$lv_cls = $lp_ctr . 'Controller';
		if (file_exists($lv_fle)) {
			include_once($lv_fle);
			$this->co_ctr = new $lv_cls($this->co_reg);
		} else {
			trigger_error('Error: Could not load controller ' . $lv_fle . '!');
			exit();
		}    
    return $this->co_ctr;
	}
  
	public function model( $lp_mdl, $lp_dir='' ) {
		$lv_dir = ($lp_dir!=''?$lp_dir:DIR_APPLICATION);
		$lv_fle = $lv_dir . '../tmssOnLine/model/' . $lp_mdl . '.php';
    $lv_cls = $lp_mdl;
		if (file_exists($lv_fle)) {
			include_once($lv_fle);
      $this->co_mdl = new $lv_cls($this->co_reg);
		} else {
			trigger_error('Error: Could not load model ' . $lv_fle . '!');
			exit();
		}
    return $this->co_mdl;
	}
  
	public function view( $lp_vew, $lp_vewdat=array()) {
		$lv_fle = DIR_APPLICATION . '../tmssOnLine/view/default/' . $lp_vew . '.frm';
		if (file_exists($lv_fle)) {
			extract($lp_vewdat, EXTR_PREFIX_ALL, 'vew');
      $vew_token = uniqid('vew_' . time());
			ob_start();
			require($lv_fle);
      $lv_buffer = ob_get_contents();
			ob_end_clean();
			return $lv_buffer;
		} else {
			trigger_error('Error: Could not load view ' . $lv_fle . '!');
			exit();
		}
	}
  
}
?>