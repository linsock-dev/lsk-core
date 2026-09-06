<?php
class tmssLanguage {

  private $data = array();
	private $datatra = array();
  private $co_reg;

  function __construct ( &$lp_reg ) { $this->co_reg = $lp_reg;  }
  function __get( $lp_key ) { return $this->getTranslation( $lp_key ); }
  function get( $lp_key ) { return $this->getTranslation( $lp_key ); }
	function getData(){ return $this->data; }
	
	
	// GET TRANSLATION
	// devuelve una traduccion
	// recibe: key. string a buscar. si key se encierra entre simbolos @variable@ entonces no se traduce.
	// devuelve: string traducido.
	public function getTranslation( $lp_key ) {
		$lp_key = ($lp_key==null?'':$lp_key);
		$lv_key = strtoupper($lp_key);
		if(strlen($lp_key)>=3 && substr($lp_key,0,1)=='@' && substr($lp_key,-1)=='@') { $lv_ret=substr($lp_key,1,strlen($lp_key)-2);
		} else if( is_array($this->datatra) && (isset($this->datatra[$lv_key])?$this->datatra[$lv_key]:'')!='' ) { $lv_ret=htmlentities($this->datatra[$lv_key]);
		} else if( is_array($this->data) && (isset($this->data[$lv_key])?$this->data[$lv_key]:'')!='' ) { $lv_ret=htmlentities($this->data[$lv_key]);
		} else { $lv_ret='@'.$lp_key.'@'; }
    return $lv_ret;
	}
	
	
	
	// MESSAGE
	// devuelve un mensaje con reemplazo de variables
	// recibe: keysin. string a buscar. si key se encierra entre simbolos @variable@ entonces no se traduce.
	//         var. string o array. de valores que se reemplazaran en el mensaje
	//         keyplu. string a buscar para mensajes que consideran plural.
	// devuelve: string traducido.
	
	// ejemplo: sentencia: $vew_lang->message('documentSaved',123);
	//          mensaje  : documentSaved => 'Documento [%1] grabado.'
	//          salida   : 'Documento 123 grabado.'

	// ejemplo: sentencia: $vew_lang->message('documentSelected',8,'documentSelectedPlu');
	//          mensaje  : documentSelected => '[%1] documento seleccionado.'
	//                     documentSelectedPlu => '[%1] documentos seleccionados.'
	//          salida   : '8 documentos seleccionados.'

	// ejemplo: sentencia: $vew_lang->message('error',array(-1,'linea 128'));
	//          mensaje  : error => 'Se produjo el error [%1] en [%2].'
	//          salida   : 'Se produjo el error -1 en linea 128.'
	public function message( $lp_keysin, $lp_var=null, $lp_keyplu=null ){
		$lv_keysin = strtoupper($lp_keysin);
		$lv_keyplu = ($lp_keyplu==null?'':strtoupper($lp_keyplu));
		$lv_retsin = '';
		$lv_retplu = '';
		$lv_ret = '';
		
		// obtengo mensaje (singular)
		if(strlen($lv_keysin)>=3 && substr($lv_keysin,0,1)=='@' && substr($lv_keysin,-1)=='@') { $lv_retsin=substr($lv_keysin,1,strlen($lv_keysin)-2);
		} else if( is_array($this->datatra) && (isset($this->datatra[$lv_keysin])?$this->datatra[$lv_keysin]:'')!='' ) { $lv_retsin=htmlentities($this->datatra[$lv_keysin]);
		} else if( is_array($this->data) && (isset($this->data[$lv_keysin])?$this->data[$lv_keysin]:'')!='' ) { $lv_retsin=htmlentities($this->data[$lv_keysin]);
		} else { $lv_retsin='@'.$lv_keysin.'@'; }
		
		// obtengo mensaje (plural)
		if($lv_keyplu!=''){
			if(strlen($lp_keyplu)>=3 && substr($lp_keyplu,0,1)=='@' && substr($lp_keyplu,-1)=='@') { $lv_retplu=substr($lp_keyplu,1,strlen($lp_keyplu)-2);
			} else if( is_array($this->datatra) && (isset($this->datatra[$lp_keyplu])?$this->datatra[$lp_keyplu]:'')!='' ) { $lv_retplu=htmlentities($this->datatra[$lp_keyplu]);
			} else if( is_array($this->data) && (isset($this->data[$lp_keyplu])?$this->data[$lp_keyplu]:'')!='' ) { $lv_retplu=htmlentities($this->data[$lp_keyplu]);
			} else { $lv_retplu='@'.$lp_keyplu.'@'; }
		}
		
		// reemplazo variables del array (si viene string se convierte a array)
		if($lp_var!=null && is_string($lp_var)){ $lp_var = array($lp_var); }
		if(is_array($lp_var)){
			// determinar si el mensaje es singular o plural
			$lv_ret = ( $lp_keyplu!='' && (is_numeric($lp_var[0]) && $lp_var[0]>1) ? $lv_retplu : $lv_retsin );
			$i=1;
			foreach($lp_var as $lv_val){
				$lv_ret = str_ireplace('[%'.$i.']',$lv_val,$lv_ret);
				$i++;
			}
		}

    return $lv_ret;
	}
	
	
	
	// INICIALIZE
	// inicializa las traducciones
  function initialize( $lp_lngcod='' ) {
		$lp_lngcod = ($lp_lngcod!=''?$lp_lngcod:($this->co_reg->sec->lngcod!=''?$this->co_reg->sec->lngcod:'ES'));
		if($this->co_reg->sec->bsecnx==''){ return false; }
		
		// determino idioma. si no se pudo determinar el idioma, cargo los datos de usuario para determinar que idioma utilizar
		if($lp_lngcod=='' && $this->co_reg->sec->usrcod!=''){
			$lo_usrmdl = $this->co_reg->load->model('syssecusr');
			if( $lo_usrmdl->load( array('usrcod'=>$this->co_reg->sec->usrcod) ) ){
				$lp_lngcod = $lo_usrmdl->lngcod;
			}
		}
		$lp_lngcod = ($lp_lngcod!=''?$lp_lngcod:'ES');
		$this->co_reg->sec->lngcod = $lp_lngcod; 
		
		// cargo traducciones
		$lo_lngmdl = $this->co_reg->load->model('syslng');
		$this->data = $lo_lngmdl->getTranslations( $lp_lngcod );

		// obtengo traducciones del cliente (si está logueado a una empresa)
		if( $this->co_reg->sec->isLogged() ) {			
			$lo_lngtramdl = $this->co_reg->load->model('syslngtra');
			$this->datatra = $lo_lngtramdl->getTranslations( $lp_lngcod );			
		}
  }
}
?>