<?php
final class tmssRegistry {
	private $data = array();

	public function __get($lp_key) {
		return (isset($this->data[$lp_key]) ? $this->data[$lp_key] : null);
	}

	public function get($lp_key) {
		return (isset($this->data[$lp_key]) ? $this->data[$lp_key] : null);
	}
  
	public function set($lp_key, &$lp_val) {
		$this->data[$lp_key] = $lp_val;
	}

	public function has($lp_key) {
		return isset($this->data[$lp_key]);
	}
}
?>