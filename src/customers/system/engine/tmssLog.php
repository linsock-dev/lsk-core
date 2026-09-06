<?php
class tmssLog {
	private $handle;

	public function __construct($filename) {
		date_default_timezone_set('America/Argentina/Buenos_Aires');
		$this->handle = fopen(DIR_LOGS . $filename . date('Ym') . '.txt', 'a');
	}

	public function write($message) {
		fwrite($this->handle, date('Y-m-d H:i:s') . chr(9) . print_r($message, true) . PHP_EOL);
	}
	
	public function __destruct() {
		fclose($this->handle);
	}
}
?>