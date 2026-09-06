class tmssForm {
	
  # Properties
  
  private $co_reg;
  private $data = array();
	
	
	
  # methods
	
	
  /**
   * class constructor
   */
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
		$this->username='';
		$this->password='';
		$this->host='';
		$this->port='21';
		$this->ftpcnx=null;
	}
	
	
  /**
   * class destructor
   */
  function __destruct() {
		$this->logout();
	}
	
	
	function __get( $lp_key ) {
		if ( isset($this->data[$lp_key]) ) {
			return ($lp_key=='password'?'':$this->data[$lp_key]);
		} else {
			return '';
		}
	}
	
	
	function __set( $lp_key, $lp_val ) {
		$this->data[$lp_key] = $lp_val;
	}
	
	
	/**
	 * realiza la conexión y login al ftp
	 */
	function connect( $lp_host='', $lp_username='', $lp_password='', $lp_port='21') {
		if ( $lp_host!='' ) { $this->host=$lp_host; }
		if ( $lp_username!='' ) { $this->username=$lp_username; }
		if ( $lp_password!='' ) { $this->password=$lp_password; }
		if ( $lp_port!='' ) { $this->port=$lp_port; }
		if (isset($this->host, $this->username, $this->password, $this->port)) {
			$this->ftpcnx = ftp_connect($this->host, $this->port);
			if (!$this->ftpcnx) {
				return false;
			} else if (!ftp_login($this->ftpcnx, $this->username, $this->password)) {
				return false;
			} else {
				ftp_pasv ($this->ftpcon, true);
				return true;
			}
		}
	}
	
	
	/**
	 * cierra la conexión ftp
	 */
	function logout() {
		if (isset($this->ftpcnx)) {
			ftp_close($this->ftpcnx);
		}
	}
	
	
	/**
		* Split FTP URI into: 
		* $lo_ftp[0] = ftp://username:password@sld.domain.tld/path1/path2/ 
		* $lo_ftp[1] = ftp:// 
		* $lo_ftp[2] = username 
		* $lo_ftp[3] = password 
		* $lo_ftp[4] = sld.domain.tld 
		* $lo_ftp[5] = /path1/path2/ 
		*/
	function getDataFromUri( $lp_uri ) {
		$lo_ftp = array();
		preg_match('/ftp:\/\/(.*?):(.*?)@(.*?)(\/.*)/i', $lp_uri, $lo_ftp); 
		$this->data = array();
		$this->host = $lo_ftp[4];
		$this->username = $lo_ftp[2];
		$this->password = $lo_ftp[3];
		$this->port = '21';
		$this->path = $lo_ftp[5];
		$this->uri = $lp_uri;
	}
	
	
	/**
	  * sube un archivo al ftp
		*/
	function upload($lp_file, $lp_path, $lp_mode = FTP_ASCII) {
		$lv_upload = false;
		if (isset($lp_file, $lp_path)) {
			if (file_exists($lp_file)) {
				$lv_upload = ftp_put($this->ftpcnx, $lp_path, $lp_file, FTP_ASCII);
			}
		}
		return $lv_upload;
	}
	
	
	/**
	  * descarga un archivo desde el ftp
		*/
	function download($lp_serverfile, $lp_localfile, $lp_mode = FTP_BINARY) {
		if (isset($lp_file)) {
			if (ftp_get($this->ftpcnx, $lp_localfile, $lp_serverfile, FTP_BINARY)) {
				return true;
			}
		}
		return false;
	}
	
	
	/**
	  * lista los archivos de un directorio
		*/
	function ls($lp_dir = '.') {
		if (isset($this->ftpcon)) {
			$ls = ftp_nlist($this->ftpcnx, $lp_dir);
			return $ls;
		}
	}
		
	
	/**
	  * modifica los permisos de un archivo en el ftp
		*/
	function chmod($lp_file, $lp_permissions = 0644) {
		if (isset($lp_file)) {
			if (ftp_chmod($this->ftpcnx, $lp_permissions, $lp_file) !== false) {
				return true;
			} else {
				return false;
			}
		}
	}
	
	
	/**
	  * crea un directorio en el ftp
		*/
	function mkdir($lp_dirname) {
		if (isset($lp_dirname)) {
			return ftp_mkdir($this->ftpcnx, $lp_dirname);
		}
	}
	
	
	/**
	  * borra un archivo desde el ftp
		*/
	function delete($lp_file) {
		if (isset($lp_file)) {
			return ftp_delete($this->ftpcnx, $lp_file);
		}
	}
			
}