<?php
class tmssConfig {
	private $data = array();

  function __get( $lp_key ) {
    return (isset($this->data[$lp_key]) ? $this->data[$lp_key] : null);
  }

	public function get($lp_key) {
		return (isset($this->data[$lp_key]) ? $this->data[$lp_key] : null);
	}

	public function set($key, $value) {
		$this->data[$key] = $value;
	}

	public function has($key) {
		return isset($this->data[$key]);
	}

	public function load($filename) {
		$file = DIR_CONFIG . $filename . '.php';

		if (file_exists($file)) {
			$_ = array();

			require($file);

			$this->data = array_merge($this->data, $_);
		} else {
			trigger_error('Error: Could not load config ' . $file . '!');
			exit();
		}
	}
}