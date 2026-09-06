<?php
abstract class tmssController {
	protected $co_reg;

	public function __construct(&$lp_reg) {
		$this->co_reg = $lp_reg;
	}

	public function __get($lp_key) {
		return $this->co_reg->get($lp_key);
	}

	public function __set($lp_key, $lp_val) {
		$this->co_reg->set($lp_key, $lp_val);
	}
}
?>