<?php
final class grldatadr extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'adrnum'; 
	const API_KEY = 'AIzaSyBKwMGQeiphR7VtD5Iqe5Y9_lKwN2eCQVk';
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	//function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }
	
	function getApiKey() { return self::API_KEY; }
	function getData() {
		$lv_ret = array();
		foreach($this->data as $lv_key=>$lv_val) {
			$lv_ret[$lv_key] = ( is_a($lv_val, 'DateTime') ? $lv_val->format('d/m/Y') : $lv_val );
		}
		return $lv_ret;
	}
	
	// CREATE. inicializa el objeto
	function create() {
		$this->data = array();
		$this->sysdata = array();
	}
	
	// SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;

		// armo el nombre completo si no est� definido
		if ( ($this->data['adrnme001']??'')=='' ) {
			$lv_frtnme = ($this->data['adrfrtnme']??'');
			$lv_lstnme = ($this->data['adrlstnme']??'');
			$this->data['adrnme001'] = $lv_lstnme . ($lv_frtnme==''?'': ($lv_lstnme==''?'':', ').$lv_frtnme );
		}

		// FALTA:
		// los datos de conecto (telefono, mail, etc) deber�an estar en una tabla separada
		// ya que un celular puede tener mas de una referencia (por ejemplo, laboral, personal)

		// FALTA:
		// - verificar si el par�metro de obtener direcci�n para esta clase de objeto est� establecido
		// - ver como pasar la direcci�n basado en el pa�s (i.e. EEUU: nro+calle // ARG: calle+nro)
		$this->data['adrstr'] = ($this->data['adrstr']??'');
		$this->data['adrtwn'] = (intval($this->data['lndtwncod']??0)>0? $this->data['lndtwntxt'] : ($this->data['adrtwn']??''));
		$this->data['lndregtxt'] = ($this->data['lndregtxt']??'');
		$this->data['lndtxt'] = ($this->data['lndtxt']??'');
		if ( $this->data['adrstr']=='' || $this->data['adrtwn']=='' || $this->data['lndregtxt']=='' || $this->data['lndtxt']=='' ) {
			$this->data['adrmapgeo'] = '';
		} else {
			$this->data['adrmapgeo'] = $this->getCoordinates( utf8_decode($this->data['adrstr']).' '.
																												utf8_decode($this->data['adrstrnum']).','.
																												($this->data['adrtwn']!=''?utf8_decode($this->data['adrtwn']).',':'').
																												utf8_decode($this->data['lndregtxt']).','.
																												utf8_decode($this->data['lndtxt']) );
		}

		$lo_out_data = array();
		return $this->call_sp( '01', $this->data, $this->data );
  }
	
	// LOAD. carga el objeto
	function load( $lp_key=array() ) {
		$this->data['adrsrctyp'] = ($lp_key['adrsrctyp']??'');
		$this->data['adrsrccod'] = ($lp_key['adrsrccod']??'');
		if(isset($lp_key['sysecusr_buscod'])){ $this->data['sysecusr_buscod'] = '_SYS'; }
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $this->data );
	}
	
	// GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew');}
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
				$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	
	
	// ------ GEOLOCALIZACION --------------------------------
	// obtiene las coordenadas (lat, long) de una direccion usando Google Api
	// https://console.cloud.google.com/	(cuenta google@temasis.ar)
	// Restriccion x IP 190.105.227.144 en Geocoding API
	// -------------------------------------------------------
	function getCoordinates($lp_address){
		$lv_coordinates = '';
		$lp_address = str_replace(' ', '+', $lp_address);
		$lp_address = str_replace('á', 'a', $lp_address);
		$lp_address = str_replace('é', 'e', $lp_address);
		$lp_address = str_replace('í', 'i', $lp_address);
		$lp_address = str_replace('ó', 'o', $lp_address);
		$lp_address = str_replace('ú', 'u', $lp_address);
		$lp_address = str_replace('ñ', 'n', $lp_address);
		$lp_address = str_replace('Á', 'A', $lp_address);
		$lp_address = str_replace('É', 'E', $lp_address);
		$lp_address = str_replace('Í', 'I', $lp_address);
		$lp_address = str_replace('Ó', 'O', $lp_address);
		$lp_address = str_replace('Ú', 'U', $lp_address);
		$lp_address = str_replace('Ñ', 'N', $lp_address);
		$lp_address2 = json_encode($lp_address);
		if ( json_last_error() == JSON_ERROR_NONE ) {
      $lv_url = 'https://maps.googleapis.com/maps/api/geocode/json?address='.$lp_address2.'&key='.self::API_KEY;
			$lv_response = file_get_contents($lv_url);
			$lv_json = json_decode($lv_response,TRUE); //generate array object from the response from the web
			if ( sizeof($lv_json['results'])!=0 ) {
				if ($lv_json['results'][0]['geometry']['location_type']=='ROOFTOP' || $lv_json['results'][0]['geometry']['location_type']=='RANGE_INTERPOLATED'){
					$lv_coordinates = ($lv_json['results'][0]['geometry']['location']['lat'].",".$lv_json['results'][0]['geometry']['location']['lng']);
				}
			} else {
				var_dump( $lv_json );
			}
		}
		return $lv_coordinates;
	}
	// -------------------------------------------------------
	
	
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, ($lp_in['sysecusr_buscod']??$this->co_reg->sec->buscod),
																			$this->co_reg->db->sqldat($lp_in,'adrnum'),
																			$this->co_reg->db->sqldat($lp_in,'adrlstnme',false),
																			$this->co_reg->db->sqldat($lp_in,'adrfrtnme',false),
																			$this->co_reg->db->sqldat($lp_in,'adrnme001',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstrnme',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstrnum',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstrflr',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstrunt',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstrbld',false),
																			$this->co_reg->db->sqldat($lp_in,'adrstr',false),
																			$this->co_reg->db->sqldat($lp_in,'adrpstcod',false),
																			$this->co_reg->db->sqldat($lp_in,'adrcty',false),
																			$this->co_reg->db->sqldat($lp_in,'lndtwncod'),
																			$this->co_reg->db->sqldat($lp_in,'adrtwn',false),
																			$this->co_reg->db->sqldat($lp_in,'lndregcod'),
																			$this->co_reg->db->sqldat($lp_in,'lndcod'),
																			$this->co_reg->db->sqldat($lp_in,'adrphn001',false),
																			$this->co_reg->db->sqldat($lp_in,'adrphn002',false),
																			$this->co_reg->db->sqldat($lp_in,'adrfax',false),
																			$this->co_reg->db->sqldat($lp_in,'adreml',false),
																			$this->co_reg->db->sqldat($lp_in,'adrwebpge',false),
																			$this->co_reg->db->sqldat($lp_in,'adrmblphn',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($lp_in,'adrzon',false),
																			$this->co_reg->db->sqldat($lp_in,'adrsrctyp'),
																			$this->co_reg->db->sqldat($lp_in,'adrsrccod'),
																			$this->co_reg->db->sqldat($lp_in,'adrmapgeo',false),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'trazoncod'),
                                    	$this->co_reg->db->sqldat($lp_in,'adrzoncod')
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_ADR_DEF(?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,?,?,?,?,?,?,?,?)'; 
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' ) {
      if($this->errtyp!='E'){
				$lp_out = $lo_rs;
      }else{
        $lp_out=array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt);
      }
			
		// devuelve ID (registro individual)
		} else {
      if ( $lo_rs && count($lo_rs)>0 ) {
        if( $this->errtyp!='E' ){
					$lp_out = $lo_rs[0];
					$this->data[self::ID] = ($lp_out[self::ID]??array_values($lp_out)[0]);
        }
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -9999;
				$this->errtxt = $this->co_reg->language->message('UnexpectedError', $this->sysdata['sqlstm'] );
			}
		}
		return ($this->errcod==0?true:false);
  }
}
?>