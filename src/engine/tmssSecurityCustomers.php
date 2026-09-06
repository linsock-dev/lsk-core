<?php
Class tmssSecurityCustomers {
	
	public static function getTimeout() {
		$lo_timeoutArr = array();
		$lo_timeoutArr[''] = 600;							// default: 10min (10min x 60seg)
		$lo_timeoutArr['LOGIN'] = 1800;				// 30min (30min x 60seg)
		$lo_timeoutArr['TTRAININGAR'] = 1200;	// 20min (20min x 60seg)
		$lo_timeoutArr['TINFUSIONAR'] = 1800;	// 30min (30min x 60seg)
		$lo_timeoutArr['TINFUSIONCL'] = 1800;	// 30min (30min x 60seg)
		$lo_timeoutArr['TINFUSIONUY'] = 1800;	// 30min (30min x 60seg)
		$lo_timeoutArr['DBALLESTER'] = 1800;	// 30min (30min x 60seg)
		return $lo_timeoutArr;
	}
	
}
?>