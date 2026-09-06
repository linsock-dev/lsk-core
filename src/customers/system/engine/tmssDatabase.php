<?php
final class tmssDatabase {
  private $co_reg;
  private $data = array();
  private $co_cnx = array();
  private $co_err = array();    
  
  function __construct( &$lp_reg ) { $this->co_reg=$lp_reg; $this->wrkinx=-1; }
  function __destruct() { foreach( $this->co_cnx as $lv_row ) { if(isset($lv_row['dblnk'])){ sqlsrv_close( $lv_row['dblnk'] ); }} }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }  
	
  // SET_CONNECTION_INFO. asocia los datos de conexion con un indice 
  public function set_connection_info( $lp_inx, $lp_db, $lp_usr, $lp_pwd, $lp_srv ) {
    if ($lp_inx>=0) {
      $this->co_cnx[ $lp_inx ] = array( 'dblnk'=>null, 'SQL_DATABASE'=>$lp_db, 'SQL_USER'=>$lp_usr, 'SQL_PASS'=>$lp_pwd, 'SQL_SERVER'=>$lp_srv );
      return true;      
    } else {
      return false;
    }
  }
	
	// CLEAR_CUSTOMER_CONNECTION. quita la asociación de la conexion a un indice
  public function clear_customer_connection ( $lp_inx=null ) {
    $lv_inx = ($lp_inx==null || $lp_inx==0 ? count($this->co_cnx) : $lp_inx);
		if ($lv_inx==0) { return false; }
    if ( isset($this->co_cnx[$lv_inx]) ) { $this->co_cnx[$lv_inx]=array(); }
		return true;
	}
	
  // GET_SYSTEM_CONNECTION. obtiene los datos de conexion de la base de datos central
  public function get_system_connection() {
    if ( !isset($this->co_cnx[0]['dblnk']) || $this->co_cnx[0]['dblnk']==null ) {
			include 'tmssDatabaseCfg.php';
			if ( $this->set_connection_info(0,$lv_tmssDatabaseCfgCnxInf['db'],$lv_tmssDatabaseCfgCnxInf['usr'],$lv_tmssDatabaseCfgCnxInf['pwd'],$lv_tmssDatabaseCfgCnxInf['srv']) ) {
        //if ( !$this->open_database(0) ) {
        //  die ( 'I Could not to open system database. Method open_system_database(). ' );
        //} else {
          return true;
        //}
      } else {
        return false;
      }
    }
    return true;
  }
	
	// GET_CUSTOMER_CONNECTION. abre una conexion de usuario y la asocia a un indice
  public function get_customer_connection( $lp_inx=null, $lp_post=array() ) {

		$lo_post = ( count($lp_post)>0 ? $lp_post : $this->co_reg->request->post );

    // index calcularion    
    $lv_inx = ($lp_inx==null || $lp_inx==0 ? count($this->co_cnx) : $lp_inx);

    // check if database is already open
    if ( isset($this->co_cnx[$lv_inx]['dblnk']) ) {
      return true;
      
    // check if system database is already open
    } else if ( !isset($this->co_cnx[0]['dblnk']) ) {
    
      // open system database
      if ( !$this->open_database(0) ) {
        die ( 'I Could not to open system database. Method get_customer_connection().' );
      }
			
    }
      
    // check is system database is open
    if ( isset($this->co_cnx[0]['dblnk']) ) {

      // get global instance of security class
      $lo_sec = $this->co_reg->sec;
      if ($lo_sec==null) {
        die( 'No security class were defined. Method open_customer_database().');
        return false;
      }
            
      // execute stored procedure
      if ( $this->co_reg->sec->bsecnx=='' && isset($lo_post['bsecnx']) ) { 
				$this->co_reg->sec->bsecnx = $lo_post['bsecnx'];
      }

			if(count($lp_post)>0){ $lv_bsecnx = $this->co_reg->sec->bsecnx; $this->co_reg->sec->bsecnx=$lp_post['bsecnx']; }
			if($this->co_reg->sec->bsecnx==null){ $this->co_reg->sec->bsecnx='X000080192'; }
      $lo_arr = $this->sqlstoredprocedure( 'SYS_CNX_DEF ( ? , ? , ? , ? )', array('09','',NULL,$this->co_reg->sec->bsecnx), 0 );
			if(count($lp_post)>0){ $this->co_reg->sec->bsecnx = $lv_bsecnx; }

      if (!$lo_arr) {
        die ( 'Access to customer database cannot be obtained. Method open_customer_database( '.$this->co_reg->sec->bsecnx.' ). ');
        return false;
      } else if ( count($lo_arr)!=1 ) {
        die ( 'Invalid access connection. Method open_customer_database(). ');
        return false;
      } else {
        $lv_dat = $lo_arr[0];

        // set database connection
        if ( !$this->set_connection_info($lv_inx,$lv_dat['syscnxdb'],$lv_dat['syscnxusr'],$lv_dat['syscnxpwd'],$lv_dat['syscnxsrv']) ) {
          die ( 'I Could not to open customer database ' . $lv_dat['syscnxdb'] . '. Method open_customer_database().' );
          return false;
        }
      }
    }
    return true;
  }
  
	// OPEN_DATABASE. dado un indice de las conexiones abre la base de datos del usuario
	public function open_database( $lp_inx ) {

    if ( !isset($this->co_cnx[$lp_inx]) ) {
      if ( $lp_inx==0 ) {
        if ( !$this->get_system_connection() ) {
          die('error to get system connection info');
          return false;
        }
      } else {
        if ( !$this->get_customer_connection($lp_inx) ) {
          die('error to get customer connection info');
          return false;
        }
      }
    }

    if ( !isset($this->co_cnx[$lp_inx]['dblnk']) || $this->co_cnx[$lp_inx]['dblnk']==null ) {
      // build connection info array
      $lo_cnxinf = array( "Database"=>$this->co_cnx[$lp_inx]['SQL_DATABASE'], "UID"=>$this->co_cnx[$lp_inx]['SQL_USER'], "PWD"=>$this->co_cnx[$lp_inx]['SQL_PASS']); //, "CharacterSet"=>"UTF-8" ); 
      // open server connection
  		try {
  			$this->co_cnx[$lp_inx]['dblnk'] = sqlsrv_connect( $this->co_cnx[$lp_inx]['SQL_SERVER'], $lo_cnxinf );
  			if ( !$this->co_cnx[$lp_inx]['dblnk'] ) {
					//var_dump(sqlsrv_errors());
					//die();
  				throw new Exception ( "I Could not connect to the SQL server. Method tmssDatabase::open_databae()" );
          // sqlsrv_errors()
  			}
  		} catch ( Exception $err ) {
  			die ( $err->getMessage () );
  		}
    }
    
    return true;
	}
	
	/**
	 * method to deal with the execution of MS SQL stored proceedured
	 * @param $string $procName The name of the proceedure to execute
	 * @param array $paramArray An array containing entries for each paramneeded but the stored proceedure see the exampel in the code below
	 * @param int 0-system database / 1..n - customer database   
	 */
	public function sqlstoredprocedure( $lp_sqlstr, $lp_sqlprm, $lp_inx=-1 ) {

		// no se informo id de conexion y existe un ID de conexion de trabajo
		if( $lp_inx==-1 && $this->wrkinx!=-1 ) {
			$lp_inx=$this->wrkinx;
		// no se informo id de conexion y NO existe un ID de conexion de trabajo (se utiliza default=1)
		} else if( $lp_inx==-1 ) {
			$lp_inx=1;
		} else {
		// se informo ID de conexion (se utiliza lo informado)
		}
		
		// define the array to return
		$lo_rs = array ();

    // check if database connection was established
    if ( !$this->open_database( $lp_inx ) ) {
      die ( 'I Could not to open database. Method storedprocedured().' );
    }

    // query execution
    $lo_ret = sqlsrv_query($this->co_cnx[$lp_inx]['dblnk'], '{call '.$lp_sqlstr.'}', $lp_sqlprm);
    
    // check query result
    if ( $lo_ret == false ) {
      $this->co_err = sqlsrv_errors();
      return array();
      //die( print_r( sqlsrv_errors(), true));
    }
		
		// loop throught the result. set and place each result to the lo_rs array
    while( $lv_row = sqlsrv_fetch_array( $lo_ret, SQLSRV_FETCH_ASSOC ) ) {
      $lo_rs[] = array_change_key_case ( $lv_row , CASE_LOWER );
    }
		
    // free resources
    sqlsrv_free_stmt( $lo_ret );
    
		//returnt the result array
		return $lo_rs;
	}
	
	// SQL EXECUTE. ejecuta una sentencia SQL
	// recibe como parametros:
	// string. sentencia SQL a ejecutar
	// array. de valores de reemplazo para sentencia
	// int. id de conexión (siempre 1 ya que se ejecuta en la base de logueo - (0)es para base de sistema y no se usa por ahora)
	public function sqlexecute( $lp_sqlstr, $lp_sqlprm, $lp_inx ) {
		$this->co_err = '';
		
		// NO se permite un ID de que sea en el espacio de IDs reservados.
		//if ( $lp_inx != 1){ //< 100 ) { 
			//die('No está permitida la ejecución de query en ID < 100.');
			//die('No está permitida la ejecución de query en ID distinto de 1.');
		//}
	
    // check if database connection was established
    if ( !$this->open_database( $lp_inx ) ) { $this->co_err = 'E-1: I Could not to open database. Method storedprocedured().\r\n'; return false; }
		
    // sentence preparation
		$lv_stm = sqlsrv_prepare($this->co_cnx[$lp_inx]['dblnk'], $lp_sqlstr, $lp_sqlprm);
		if( !$lv_stm ) { $this->co_err = $this->parseSqlSrv_errors(sqlsrv_errors()); return false; }
		
    // sentence execution
    $lo_ret = sqlsrv_execute($lv_stm);
    if ( $lo_ret == false ) { $this->co_err = $this->parseSqlSrv_errors(sqlsrv_errors()); sqlsrv_free_stmt( $lv_stm ); return false; }
		
    // free resources
    sqlsrv_free_stmt( $lv_stm );
    
		//returnt the result array
		return $lo_ret;
	}
	
	
	// hace parse de los errores de sqlsrv_errors en un string
	function parseSqlSrv_errors( $lp_err ){
		$lv_ret = '';
		foreach($lp_err as $lv_row){
			if(isset($lv_row['message'])){
			$lv_ret .= '<br>'.($lv_row['code']??'0').': '.$lv_row['message'];
			}
		}
		return $lv_ret;
	}
	
	
	// SQL QUERY. ejecuta una sentencia SQL que devuelve registros
	// recibe como parametros:
	// string. sentencia SQL a ejecutar
	// array. de valores de reemplazo para sentencia
	// int. id de conexión (siempre 1 ya que se ejecuta en la base de logueo - (0)es para base de sistema y no se usa por ahora)
	public function sqlquery( $lp_sqlstr, $lp_sqlprm, $lp_inx ) {
		$this->co_err = '';
		
		// NO se permite un ID de que sea en el espacio de IDs reservados.
		if ( $lp_inx != 1){ //< 100 ) { 
			//die('No está permitida la ejecución de query en ID < 100.');
			die('No está permitida la ejecución de query en ID distinto de 1.');
		}
	
		// define the array to return
		$lo_rs = array ();

    // check if database connection was established
    if ( !$this->open_database( $lp_inx ) ) {
      die ( 'I Could not to open database. Method storedprocedured().' );
    }
		
    // sentence execution
    $lo_ret = sqlsrv_query($this->co_cnx[$lp_inx]['dblnk'], $lp_sqlstr, $lp_sqlprm);
    
    // check query result
    if ( $lo_ret == false ) {
			$lo_rs = array();			
      //$this->co_err = sqlsrv_errors();
      //return array();
      //die( print_r( sqlsrv_errors(), true));
			if( ($errors = sqlsrv_errors() ) != null) {
				foreach( $errors as $error ) {
					$lo_rs[] = array('sqlstate'=>$error[ 'SQLSTATE'],'code'=>$error[ 'code'],'message'=>$error[ 'message']);
				}
			}
			return $lo_rs;
    }

		// loop throught the result. set and place each result to the lo_rs array
    while( $lv_row = sqlsrv_fetch_array( $lo_ret, SQLSRV_FETCH_ASSOC ) ) {
      $lo_rs[] = array_change_key_case ( $lv_row , CASE_LOWER );
    }
		
    // free resources
    sqlsrv_free_stmt( $lo_ret );
    
		//returnt the result array
		return $lo_rs;
	}
	
  // sqldate. method to reverse the order of a given date and fix to mssql date format
	// 					so DD/MM/YYYY becomes YYYYMMDDHHMMSS
  function sqldate( $lp_dte ) {

		if(is_a($lp_dte, 'DateTime')){
			$lp_dte = $lp_dte->format('d/m/y');
		} else if( is_object($lp_dte) ){
			return '00000000000000';
		} else if ($lp_dte===null || $lp_dte=='' || strlen($lp_dte)!=10 ) {
			return '00000000000000';
		} 
		
    // split the date string @ / into three parts
    $lv_dtearr = explode( '/', $lp_dte, 3 );

    // array reverse to YYYY MM DD
    $lv_dtearrrev = array_reverse( $lv_dtearr );

    // building output string
    $lv_sqldte = '';
    $lv_cnt = 0;
    foreach( $lv_dtearrrev as $lv_dteprt ) {
      $lv_sqldte .= $lv_dteprt;
      $lv_cnt++;
    }

    // adding HHMMSS
    $lv_sqldte .= '000000';
    
    return $lv_sqldte;
  }
  
  // sqldatetime. method to reverse the order of a given date and fix to mssql date format
	// 							so DD/MM/YYYY HH:MM:SS becomes YYYYMMDDHHMMSS
  function sqldatetime( $lp_dte ) {

		if ($lp_dte===null || $lp_dte=='') { return '00000000000000'; } 
			
    // split the date string @ / into three parts
    $lv_dtearr = explode( '/', $lp_dte, 3 );

    // array reverse to YYYY MM DD
    $lv_dtearrrev = array_reverse( $lv_dtearr );

		// extracts time from year
		$lv_tmearr = explode(' ', $lv_dtearrrev[0], 2);
		$lv_dtearrrev[0] = $lv_tmearr[0];
		
		// removing : to get time as HHMMSS
		$lv_tmearr[1] = (count($lv_tmearr)==2?str_ireplace(':','',$lv_tmearr[1]):'000000');
		
		// join date array into output string
 		$lv_sqldte = implode('',$lv_dtearrrev);
		
    // adding HHMMSS
    $lv_sqldte .= $lv_tmearr[1];
    
    return $lv_sqldte;
  }

  // SQL DATA. normaliza un string para prevenir SQL Injection, conversión UTF8 y mayusculas (opcional)
	// preserva caracteres especiales 
  function sqldata( $lp_str, $lp_mayusc=true, $lp_default='' ) {
    $lv_str = $lp_default;
    if (trim($lp_str==null?'':$lp_str)!='') {
			// cambio simbolo EURO por su codificacion html
    	$lv_str = str_replace('','&euro;',$lp_str);
			// convierto caracteres especiales
			$lv_str = htmlspecialchars_decode( $lv_str );
			// convierto UTF8
      $lv_str = utf8_decode( trim($lv_str) );
			// prevengo SQL Injection
      $lv_str = str_replace( chr(39), ' ', $lv_str );
			// convierto a mayusculas
			if($lp_mayusc){ $lv_str = strtoupper($lv_str); }
      // html no reconoce acute en mayúsculas (acentos, tildes y simbolos especiales)
    	$lv_str = str_ireplace('ACUTE;','acute;',$lv_str);   
    	$lv_str = str_ireplace('TILDE;','tilde;',$lv_str);   
    	$lv_str = str_ireplace('&EURO;','&euro;',$lv_str);
    	$lv_str = str_ireplace('&LT;','&lt;',$lv_str);
    	$lv_str = str_ireplace('&GT;','&gt;',$lv_str);
    	$lv_str = str_ireplace('&AMP;','&amp;',$lv_str);   
    	$lv_str = str_ireplace('&QUOT;','&quot;',$lv_str);   
    	$lv_str = str_ireplace('&NBSP;','&nbsp;',$lv_str);   
    	$lv_str = str_ireplace('&APOS;','&apos;',$lv_str);   
    }
    return $lv_str;
  }
	
  // SQL DTE. recibe como parametro un array/string y lo normaliza
  function sqldte( $lp_arr, $lp_fld, $lp_format='' ) {
		$lv_str2 = '00000000000000';
		// si es un array y se informo nombre de campo
		if( is_array($lp_arr) && $lp_fld!='' ){
			$lv_str = (isset($lp_arr[ $lp_fld ])?$lp_arr[ $lp_fld ]:'');
			
			if($lp_format=='datetime'){
				$lv_str2 = $this->sqldatetime( $lv_str );
			} else {
				$lv_str2 = $this->sqldate( $lv_str );
			}
		}
    return $lv_str2;
  }

  
  function sqljsn( $lp_arr, $lp_var ){
    $lp_str = ($lp_arr[$lp_var]??'');
    $lp_str = ( trim($lp_str)=='' ? '[]' : $lp_str ); //json_encode($lp_str, JSON_UNESCAPED_UNICODE) );
    
  	// asegura UTF-8 valido
		if (!mb_check_encoding($lp_str, 'UTF-8')) {
    	$lp_str = mb_convert_encoding($lp_str, 'UTF-8', 'auto');
		}
  	//$lp_text = mb_convert_encoding($lp_str, 'UTF-8', 'auto');

  	// decodifica entidades HTML
  	$lp_str = html_entity_decode($lp_str, ENT_QUOTES | ENT_HTML5, 'UTF-8');

  	// Limpieza opcional: símbolo del euro
  	$lp_str = str_replace("\x80", '&euro;', $lp_str);

  	// Remueve caracteres de control invisibles (excepto \n \r \t)
  	//$lp_text = preg_replace('/[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]/u', '', $lp_text);
		
  	return trim($lp_str);
  }
  
  
  // SQL DAT. recibe como parametro un array/string y lo normaliza
	// verifica si es un array que el campo exista
  function sqldat( $lp_arr, $lp_fld, $lp_mayusc=true, $lp_default='' ) {
		$lv_str2 = '';
		
		// si es un array y se informo nombre de campo
		if( is_array($lp_arr) && $lp_fld!='' ){
			$lv_str = (isset($lp_arr[ $lp_fld ])?$lp_arr[ $lp_fld ]:'');
			$lv_str2 = $this->sqldata( $lv_str, $lp_mayusc, $lp_default );
		
		// si no es un array se normaliza directamente
		} else if(!is_array($lp_arr)) {
			$lv_str2 = $this->sqldata( $lp_arr, $lp_mayusc, $lp_default );
		}
    return $lv_str2;
  }
	
  // SQL NUM. recibe como parametro un array/string y lo normaliza
  function sqlnum( $lp_arr, $lp_fld, $lp_decimals=3 ) {
		$lv_str2 = '0';
		// si es un array y se informo nombre de campo
		if( is_array($lp_arr) && $lp_fld!='' ){
			$lv_str = (isset($lp_arr[ $lp_fld ])?$lp_arr[ $lp_fld ]:'');
			$lv_str2 = $this->sqlnumber( $lv_str, $lp_decimals );
		}
    return $lv_str2;
  }
	
  // sqlnumber. method to normalize numbers before execute stored procedure
  // 						this is required to prevent decimals sign errors
  function sqlnumber( $lp_num, $lp_dec=3 ) {
		if($lp_num==''){$lp_num=0;}
    return number_format( $lp_num * pow(10,$lp_dec), 0, '', '');  
  }
  
	// getLastErrorMessage. method to return the last error message from the db sqerver
	function getLastErrorMessage() {
    return $this->co_err;
	}

  function parseFilter( $lp_maxrec=null, $lp_fldflt=array(), $lp_fldord=array() ) {
    $lv_sbuffer = '<view>';

    // max records
    if ( $lp_maxrec!=null ) { 
      $lv_sbuffer .= '<vewmax>'.$lp_maxrec.'</vewmax>'; 
    }

    // filter
    if ( count($lp_fldflt)>0 ) {
      $lv_sbuffer .= '<vewflt> AND '.implode(' AND ',$lp_fldflt).'</vewflt>';
    }    

    // order
    if ( count($lp_fldord)>0 ) {
      $lv_sbuffer .= '<veword>'.implode(', ',$lp_fldord).'</veword>';
    }

    $lv_sbuffer .= '</view>';
    return $lv_sbuffer;
  }

  function getSqlStatement( $lp_sqltxt, $lp_sqlprm=array() ) {
		$lv_cnt = 0;
		$lv_ret = '';
		if ($lp_sqltxt!='') {
			$lv_arr = explode( '?', $lp_sqltxt );
			foreach( $lv_arr as $lv_row ) {
				$lv_ret .= $lv_row . ( count($lp_sqlprm)>$lv_cnt ? chr(39).$lp_sqlprm[ $lv_cnt ].chr(39) : '' );
				$lv_cnt++;
			}
		}
    return $lv_ret;
  }
		
  // TsqlDate. Convierte una fecha post DD/MM/YYYY en fecha para consulta T-SQL YYYY-MM-DD
  function tsqldate( $lp_dte ) {

		if ($lp_dte===null || $lp_dte=='') { return '0000-00-00'; } 
		
    // split the date string @ / into three parts
    $lv_dtearr = explode( '/', $lp_dte, 3 );

    // array reverse to YYYY MM DD
    $lv_dtearrrev = array_reverse( $lv_dtearr );

    // building output string
    $lv_sqldte = '';
    $lv_cnt = 0;
    foreach( $lv_dtearrrev as $lv_dteprt ) {
      $lv_sqldte .= ($lv_sqldte==''?'':'-') . $lv_dteprt;
      $lv_cnt++;
    }
    
    return $lv_sqldte;
  }
	
}
?>