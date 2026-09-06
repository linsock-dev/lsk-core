<?php
class tmssMailCalendar {

	protected $co_reg;
  private $data = array();
	private $events = array();
	
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
  }

	function __get( $lp_key ) {
		if ( isset($this->data[$lp_key]) ) {
			return $this->data[$lp_key];
		} else {
			return '';
		}
	}

	function __set( $lp_key, $lp_val ) {
		$this->data[$lp_key] = $lp_val;
	}

	/**
	 * Add an event to this calendar.
	 * @param string $start The start date and time as a unix timestamp
	 * @param string $end The end date and time as a unix timestamp
	 * @param string $summary A summary or title for the event
	 * @param string $description A description of the event
	 * @param string $url A URL for the event
	 * @param string $uid A unique identifier for the event - generated automatically if not provided
	 * @return array An array of event details, including any generated UID
	 */
	/*
		uid
		start (requerido)
		end (requerido)
		summary
		description
		url
		organizer
		location
	*/
	public function addEvent( $lp_event=array() ) {	
		if ( !isset($lp_event['uid']) ) { $lp_event['uid']=md5(uniqid(mt_rand(), true)).'@Temasis'; }
		$lp_event['start'] = $lp_event['start']->format('Ymd').'T'.$lp_event['start']->format('His');
		$lp_event['end'] = $lp_event['end']->format('Ymd').'T'.$lp_event['end']->format('His');
		$this->events[] = $lp_event;
		return $lp_event;
	}

	public function getEvents() {
		return $this->events;
	}

	public function clearEvents() {
		$this->events = array();
	}
		
    /**
     * Render and optionally output a vcal string.
     * @param bool $output Whether to output the calendar data directly (the default).
     * @return string The complete rendered vlal
METHOD:PUBLISH
METHOD:REQUEST
     */
	public function render($output = true) {
		
		if ($this->name=='') { return false; }
		
		//Add header
		$lv_ics = 'BEGIN:VCALENDAR
METHOD:REQUEST
VERSION:2.0
X-WR-CALNAME:'.$this->name.'
PRODID:-//hacksw/handcal//NONSGML v1.0//EN';

		//Add events
		foreach ($this->events as $event) {
			$lv_ics .= '
BEGIN:VEVENT
UID:'.$event['uid'].'
DTSTAMP:'.date('Ymd').'T'.date('His').'Z
DTSTART;America/Buenos_Aires:'.$event['start'].'
DTEND;America/Buenos_Aires:'.$event['end'].'
'.(isset($event['summary'])?'SUMMARY:'.str_replace('\n','\\n',$event['summary']):'').'
'.(isset($event['description'])?'DESCRIPTION:'.str_replace('\n', '\\n',$event['description']):'').'
'.(isset($event['organizer'])?'ORGANIZER;CN="'.$event['organizer'].'":mailto:noreply@temasis.com.ar':'').'
'.(isset($event['location'])?'LOCATION:'.str_replace("\n", "\\n", $event['location']):'').'
'.(isset($event['url'])?'URL;VALUE=URI:'.$event['url']:'').'
END:VEVENT';
        }

		//Add footer
		$lv_ics .= '
END:VCALENDAR';

		if ($output) {
			//Output
			$lp_filename = $this->name;
			//Filename needs quoting if it contains spaces
			if (strpos($lp_filename, ' ') !== false) {
					$lp_filename = '"'.$lp_filename.'"';
			}
			header('Content-type: text/calendar; charset=utf-8');
			header('Content-Disposition: inline; filename=' . $lp_filename . '.ics');
			echo $lv_ics;
		}
		return $lv_ics;
	}
}
