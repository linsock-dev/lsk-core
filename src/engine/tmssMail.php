<?php
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/5.5.23/class.pop3.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/5.5.23/class.smtp.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/5.5.23/class.phpmailer.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/5.5.23/class.phpmaileroauth.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/5.5.23/class.phpmaileroauthgoogle.php');
/*
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/POP3.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/SMTP.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/PHPMailer.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/OAuth.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/OAuthTokenProvider.php');
require_once (__DIR__.'/../../wwwroot/library/plugins/phptools/phpmailer/6.7.1/Exception.php');
*/
require_once ('tmssMailCalendar.php');

class tmssMail {

  private $data = array();
	protected $attachments = array();
	private $lo_eml;

	public function __construct() {
    $this->lo_eml = new PHPMailer;
		
		//$this->lo_eml->SMTPDebug = 3;                               // Enable verbose debug output

		// set connection info
		/*
		$this->lo_eml->isSMTP();                                      // Set mailer to use SMTP
		$this->lo_eml->Host = 'mail.temasis.ar';  								// Specify main and backup SMTP servers
		$this->lo_eml->SMTPAuth = true;                               // Enable SMTP authentication
		$this->lo_eml->Username = 'mdominguez@temasis.ar';        // SMTP username
		$this->lo_eml->Password = 'ch4n4rg9';                         // SMTP password
		//$this->lo_eml->SMTPSecure = 'tls';                          // Enable TLS encryption, `ssl` also accepted
		$this->lo_eml->Port = 2525;                                   // TCP port to connect to
		*/
		
		// set connection info 
		$this->lo_eml->isSMTP();                          // Set mailer to use SMTP
		$this->lo_eml->Host = 'mail.temasis.ar';  				// Specify main and backup SMTP servers
		$this->lo_eml->SMTPAuth = true;                   // Enable SMTP authentication
		$this->lo_eml->Username = 'noreply@temasis.ar';   // SMTP username
		$this->lo_eml->Password = '6kL6y81^x';            // SMTP password
		//$this->lo_eml->SMTPSecure = 'tls';                // Enable TLS encryption, `ssl` also accepted
		//$this->lo_eml->SMTPSecure = 'ssl';                  // Enable TLS encryption, `ssl` also accepted
		//$this->lo_eml->Port = 465;                                   	// TCP port to connect to
		$this->lo_eml->Port = 25;                         // TCP port to connect to
		//$this->lo_eml->SMTPDebug = SMTP::DEBUG_CLIENT;
		
		$this->lo_eml->SMTPOptions = array(
						'ssl' => array(
								'verify_peer' => false,
								'verify_peer_name' => false,
								'allow_self_signed' => true
						)
				);
    
    $this->lo_eml->CharSet = ini_get('default_charset');
	}

	public function send( $lp_prm=array() ) {
	
		// FROM
		if ( isset($lp_prm['from']) ) {
			if (isset($lp_prm['from'][0]['name'])) {
				$this->lo_eml->setFrom($lp_prm['from'][0]['address'], $lp_prm['from'][0]['name']);
			} else {
				$this->lo_eml->setFrom($lp_prm['from'][0]['address']);
			}
		}
		
		// TO
		if ( isset($lp_prm['to']) ) {
			foreach ( $lp_prm['to'] as $lv_row ) {
				if ( isset($lv_row['name']) ) {
					$this->lo_eml->addAddress( $lv_row['address'], $lv_row['name'] ); // Add a recipient
				} else {
					$this->lo_eml->addAddress( $lv_row['address'] );    						 // Add a recipient					
				}
			}
		}
		
		// CC
		if ( isset($lp_prm['cc']) ) {
			foreach ( $lp_prm['cc'] as $lv_row ) {
				$this->lo_eml->addCC( $lv_row['address'] );
			}
		}
		
		// REPLYTO
		if ( isset($lp_prm['replyto']) ) {
			if (isset($lp_prm['replyto'][0]['name'])) {
				$this->lo_eml->setFrom($lp_prm['replyto'][0]['address'], $lp_prm['replyto'][0]['name']);
			} else {
				$this->lo_eml->setFrom($lp_prm['replyto'][0]['address']);
			}			
		} else {
			$this->lo_eml->addReplyTo('noreply@temasis.ar');
		}
		
		// BCC
		if ( isset($lp_prm['bcc']) ) {
			foreach ( $lp_prm['bcc'] as $lv_row ) {
				$this->lo_eml->addBCC( $lv_row['address'] );
			}
		}

		// add attachments (attachments - file/filename)
		if ( isset($lp_prm['attachments']) ) {
			foreach ( $lp_prm as $lv_row ) {
				if ( isset($lv_row['filename']) ) {
					$this->lo_eml->addAttachment( $lv_row['file'], $lv_row['filename']);    // Optional name	
				} else {
					$this->lo_eml->addAttachment( $lv_row['file'] );         // Add attachments
				}
			}
		}

		// set subject (subject)
		$this->lo_eml->Subject = (isset($lp_prm['subject'])?$lp_prm['subject']:'');

		// set message (bodyhtml / bodytxt)
		if ( isset($lp_prm['bodyhtml']) ) {
			$this->lo_eml->isHTML(true);                                  // Set email format to HTML
		} else {
			$this->lo_eml->isHTML(false);                                  // Set email format to TEXT
		}
		$this->lo_eml->Body    = (isset($lp_prm['bodyhtml'])?$lp_prm['bodyhtml']:'');
		$this->lo_eml->AltBody = (isset($lp_prm['bodytext'])?$lp_prm['bodytext']:'');

		// email send
		return $this->lo_eml->send();
	}
	
	
	function sendCalendarEvent( $lp_prm=array() ) {
		
		// preparo calendario
    $lo_cal = new tmssMailCalendar( $this->co_reg );
		$lo_cal->name = $lp_prm['name'];
		$lo_cal->addEvent(array(
			'start'=>$lp_prm['calevtstr'],
			'end'=>$lp_prm['calevtend'],
			'summary'=>$lp_prm['calevtttl'],
			'description'=>$lp_prm['calevttxt'],
			'organizer'=>$lp_prm['calevtorg'],
			'location'=>$lp_prm['calevtloc']
		));
		
		// preparo mail
		$this->lo_eml->isHTML(true);
		if ( !isset($lp_prm['emlttl']) ) { $lp_prm['emlttl']='Temasis'; }
		if ( !isset($lp_prm['emlbdyhtm']) ) { $lp_prm['emlbdyhtm']=''; }
		if ( !isset($lp_prm['emlbdytxt']) ) { $lp_prm['emlbdytxt']=''; }
		$this->lo_eml->Body = $lp_prm['emlbdyhtm']; //'This is the <strong>HTML</strong> part of the email.';
		$this->lo_eml->AltBody = $lp_prm['emlbdytxt']; //'This is the text part of the email.';
		$this->lo_eml->Subject .= $lp_prm['emlttl']; //': iCal';
		$this->lo_eml->setFrom('noreply@temasis.ar', 'Temasis');
		foreach ($lp_prm['emlto'] as $lv_row) {
			$this->lo_eml->addAddress( $lv_row['address'], $lv_row['name'] );
		}
		$this->lo_eml->Ical = $lo_cal->render(false);		
		
		// envío
		return $this->lo_eml->send();
	}
	
	
	function getError() {
		return $this->lo_eml->ErrorInfo;
	}
	
}