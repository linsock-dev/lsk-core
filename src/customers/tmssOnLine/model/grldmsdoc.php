<?php  
final class grldmsdoc extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'grldmsdoccod';
  const FILE_ROOT = '../files';
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
	// CREATE. inicializa el objeto
	function create() {
		$this->data = array();
		$this->sysdata = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
  

	// DELETE. borra un adjunto
  function delete( $lp_post ) {
		// obtengo ubicaci�n de archivos
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod). chr(47) . '/DMS';
		$lv_server_filename = '';
		if ( realpath($lv_fleloc)==false ) {
			$lv_ret = array('error' => 'Directorio o ruta invalida o desconocida.');
		}
		
		// borrar el registro del archivo
		$this->data = $lp_post;
		$lo_out_data = array();
		if ( $this->call_sp( $this->data['act'], $this->data, $lo_out_data ) ) {
			// si no es una carpeta, borro el archivo
      if (($this->data['grldmsdocsrc']??'') != 'FD'){
        $lv_server_filename = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data['grldmsdocvercod'] . '.dms';
        if(file_exists($lv_server_filename)) {
          unlink($lv_server_filename);
          if(file_exists($lv_server_filename)) {
            $lv_ret = array('sv_info' => 'Se registro el borrado en la base de datos pero el archivo f�sico no pudo ser eliminado.');
          }else {
            $lv_ret = array('sv_info' => 'Archivo borrado del file server.');
          }
        }else {
            $lv_ret = array('sv_info' => 'Archivo ['.$this->data['grldmsdocvercod'].'] inexistente en file server.');
        }
      }
    }else {
      $lv_ret = array('sv_info' => 'Se produjo un error al registrar el borrado en la base de datos.');
    }
    $lv_ret['data'] = $lo_out_data;
    $this->data = $lv_ret;
    return;
  }
	
  // GET FOLDER LIST. devuelve recordset de carpetas
  function getFdList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null, $lp_sys=false ) {
    if ( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data, $lp_sys ) ) {
      $lo_out_data[0] = $lo_out_data;
      $lo_out_data['errcod'] = $this->errcod;
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // GET DOCUMENT LIST. devuelve recordset de documentos
  function getDocList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null, $lp_sys=false ) {
    if ( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '18', $lp_prm, $lo_out_data, $lp_sys ) ) {
      $lo_out = array('data'=>$lo_out_data, 'errcod'=>$this->errcod);
			$this->data = $lo_out;
      foreach ($this->data['data'] as &$lv_docrow){
        $lv_docrow['flesze'] = number_format($lv_docrow['flesze'] / 1024) . ' KB';
      }
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // GET FILE CONTENTS. devuelve el contenido del archivo
  function getFileContents( $lp_dat=array(), $lp_atr=array('mode'=>'rb','addpth'=>'') ) {
    $lv_buffer = '';
    $lv_fleloc = $lp_atr['addpth'] . self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod) . chr(47) . '/DMS';
    $lv_flelocful = realpath($lv_fleloc) . (substr(realpath($lv_fleloc), -1) == chr(92) ? '' : chr(92)) . $lp_dat['grldmsdocvercod'] . '.dms';

    if (file_exists($lv_flelocful)) {
      $lv_flenme = $lp_dat['flenme']; // nombre de archivo original
      $lv_fletyp = $lp_dat['fletyp']; // tipo MIME

      if ($lp_atr['mode'] === 'returnText' && str_starts_with(strtolower($lv_fletyp), 'text/')) {
        return file_get_contents($lv_flelocful);
      }

      if ($lp_atr['mode'] === 'returnBinary') {
        return file_get_contents($lv_flelocful);
      }

      // Limpiar buffers y evitar caracteres antes de los headers
      if (ob_get_length()) ob_clean();
      header('Content-Type: ' . $lv_fletyp);
      header('Content-Disposition: inline; filename="' . $lv_flenme . '"');
      header('Content-Length: ' . filesize($lv_flelocful));

      // Enviar el contenido binario al navegador
      readfile($lv_flelocful);
      return;
    } else {
      // Si el archivo no existe, se devuelve un error
      http_response_code(404);
      echo "Archivo no encontrado.";
      exit;
    }
  }

  
   // GET FILE DATA. devuelve la info previa del archivo
  function getFileData( $lp_dat=array(), $lp_atr=array('mode'=>'rb','addpth'=>'') ) {		
    $this->errtyp = 'S';
    $this->errcod = 0;
    $this->errmsg = '';
    $this->flecnt = '';
		
    $lp_key = isset($lp_dat['grldmsdocvercod']) ? 'grldmsdocvercod' : 'grldmsdoccod';
    $lp_act = ($lp_key == 'grldmsdocvercod' ? '13' : '03');
    
		// INFO. carga la info del archivo solicitado
		$lv_dat = array();
		if( $this->call_sp( $lp_act, array($lp_key=>$lp_dat[$lp_key]), $lv_dat ) ){
      $this->grldmsdoccod 	 		= $lv_dat['grldmsdoccod'];
			$this->grldmsdoctxt 	 		= $lv_dat['grldmsdoctxt'];
      $this->grldmsfldcod 	 		= $lv_dat['grldmsfldcod'];
      $this->grldmsdocsrc 	 		= $lv_dat['grldmsdocsrc'];
			$this->srcobjdocclscod 		= $lv_dat['srcobjdocclscod'];
      $this->sysdocclsatr 	 		= $lv_dat['sysdocclsatr'];
      $this->sysdocclstxt 	 		= $lv_dat['sysdocclstxt'];
      $this->grldmsdocvercod 		= $lv_dat['grldmsdocvercod'];
      $this->grldmsdocvercodext = $lv_dat['grldmsdocvercodext'];
			$this->fleext 				 		= $lv_dat['fleext'] ?? (stripos($lv_dat['fletyp'], 'pdf') !== false ? '.pdf' : (stripos($lv_dat['fletyp'], 'text') !== false ? '.txt' : ''));
			$this->fletyp					 		= $lv_dat['fletyp'];
      $this->flesze					 		= number_format($lv_dat['flesze'] / 1024) . ' KB';
      $this->docsts					 		= $lv_dat['docsts'];
      $this->versts			 		 		= $lv_dat['versts'];
      $this->alldocver			 		= $lv_dat['alldocver'] ?? '';
      $this->fletypcod			 		= $lv_dat['fletypcod'];
      $this->cteusr					 		= $lv_dat['cteusr'];
      $this->ctedte			 		 		= $lv_dat['ctedte'];
      $this->updusr			 		 		= $lv_dat['updusr'];
      $this->upddte			 		 		= $lv_dat['upddte'];
		}else {
			$this->errtyp='E';
			$this->errcod=-1;
			$this->errmsg='InvalidFile';
		}
		
		// DEVUELVE. info del archivo
		return $this->data;
	}
  
  // UPLOAD IMAGE. carga una imagen capturada desde la camara
	function uploadImage( $lp_post ) {
		$lv_flenme = 'image_' . uniqid() . ".png";
		
		//Decoding & saving file with tempName
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
		$folderPath = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme;
		$img = $lp_post['camera_base64'];
		$image_parts = explode(";base64,", $img);
		$image_type_aux = explode("image/", $image_parts[0]);
		$image_type = $image_type_aux[1];
		$image_base64 = base64_decode($image_parts[1]);
		$file = $folderPath;
		file_put_contents($file, $image_base64);
		
		//Creating image record in DB
		$this->data = $lp_post;
		$this->data['flenme'] = $lv_flenme;
		$this->data['flesze'] = filesize($file);
		$this->data['fleext'] = 'jpg';
		$this->data['fletyp'] = 'image/jpg';
		$this->data['fledsp'] = '';
		$this->data['docsts'] = 'A';
		$this->data['fleatr'] = '<ppl>'.( strtoupper(isset($lp_post['fleatrppl'])?$lp_post['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';
		
		if ( $this->call_sp( '01', $this->data, $lo_out_data ) ) {
			$this->data[self::ID] = array_values($lo_out_data)[0];	
			//Renaming image to final name
			rename (realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme, realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data[self::ID] . '.tmss');
		}
	}
	
	// UPLOAD FILE. carga un archivo
	function uploadFile( $lp_post ) {
		$lv_ret=array('error' => 'Archivo subido correctamente.');
		foreach ( $this->co_reg->request->files as $lo_fle) {
			$lo_out_data = array();
			$this->data = $lp_post;
      $this->data['grldmsdoccod'] = $lp_post['grldmsdoccod'] ?? '';
      $this->data['grldmsdocvercod'] = $lp_post['grldmsdocvercod'] ?? '';
			$this->data['fleatr'] = '<ppl>'.( strtoupper(isset($this->data['fleatrppl'])?$this->data['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';
			$this->data['docsts'] = $lp_post['docsts'] ?? 'A';//isset($lp_post['grldmsdoccod']) ? 'E' : 'A';
      $this->data['grldmsfldcod'] = $lp_post['flesrcfld'];
      $this->data['srcobjdocclscod'] = $lp_post['sysdocclscod'];
			if ( is_array($lo_fle['name']) ) {
				$this->data['tmpnme'] = $lo_fle['tmp_name'][0];
				$this->data['flenme'] = basename($lo_fle['name'][0]); 		// full_chat.png
				$this->data['fletyp'] = $lo_fle['type'][0];		// image/png
				$this->data['flesze'] = $lo_fle['size'][0];		// 57719
				$this->data['error'] = $lo_fle['error'][0];
			}else {
				$this->data['tmpnme'] = $lo_fle['tmp_name'];
				$this->data['flenme'] = basename($lo_fle['name']); 		// full_chat.png 		
				$this->data['fletyp'] = $lo_fle['type'];		// image/png
				$this->data['flesze'] = $lo_fle['size'];		// 57719
				$this->data['error'] = $lo_fle['error'];
			}
      $this->data['fleext'] = pathinfo($this->data['flenme'], PATHINFO_EXTENSION);
      $this->data['grldmsdocsrc'] = str_starts_with($lo_fle['type'], 'text') ? 'T' : 'F';
      $this->data['fletypcod'] = $lp_post['fletypcod'];
      
			if ($this->data['error']==UPLOAD_ERR_OK) {
				// obtengo ubicaci�n de archivos
        $lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod). chr(47) . '/DMS';
				if ( realpath($lv_fleloc)==false ) {
					$lv_ret['error'] = 'Directorio o ruta invalida o desconocida.';
				}
        // defino la actividad dependiendo de si el documento está ya en edición, si ya existe y está activo o si no existe.
       	$lv_act = ($this->data['docsts'] == 'E') ? '02' : (!empty($lp_post['grldmsdoccod']) ? '12' : '01');
				// grabo el registro
				if ( $this->call_sp( $lv_act, $this->data, $lo_out_data ) ) {
					$lv_ret['data'] = $lo_out_data;
					// subo el archivo
					if ( !move_uploaded_file($this->data['tmpnme'], realpath($lv_fleloc) . (substr(realpath($lv_fleloc), -1) == chr(92) ? '' : chr(92)) . $lv_ret['data']['grldmsdocvercod'] . '.dms') ) {
						$lv_ret['error'] = 'Se produjo un error al subir el archivo al file server.';
					}
				} else {
					$lv_ret['error'] = 'Se produjo un error al registrar el registro de archivo en la base de datos.';
				}
			} else {
				$lv_ret['error'] = 'Se produjo un error al grabar el archivo en una ubicacion temporal.';				
			}
		}
    $this->data = $lv_ret;
		return $this->data;
	}
  
  function uploadString( $lp_post ) {
		// GRABADO. graba el string como archivo con un nombre temporal
		$lv_flenme = $lp_post['grldmsdoctxt'] ?? 'Nuevo Texto';
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod). chr(47) . '/DMS';
		$lv_fulflenme = isset($lp_post['grldmsdocvercod']) ? realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lp_post['grldmsdocvercod'] . '.dms' : realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme;
    $lv_flecnt = $lp_post['flecnt'] ?? '';
    $lv_fmtflecnt = html_entity_decode(strip_tags($lv_flecnt), ENT_QUOTES | ENT_HTML5, 'UTF-8');
		try{
			file_put_contents( $lv_fulflenme, $lv_fmtflecnt );
      if ( isset($lp_post['grldmsdocvercod']) ){
        $this->errtyp='S';
        $this->errcod=0;
        $this->errtxt='Archivo grabado';
        return array( 'grldmsdocvercod'=>$lp_post['grldmsdocvercod'] );
      }
		} catch(Exception $e){
			$this->errtyp='E';
			$this->errcod=-1;
			$this->errtxt='Error al grabar archivo. '.$e->getMessage();
			return false;
		}
		
		// REGISTRO. registra el archivo fisico en la base de datos
		$this->data = $lp_post;
    // eliminam null, "", false, undefined, y cadenas vacías o con solo espacios para evitar errores en la creación o grabado de los registros
    $this->data = array_filter($this->data, function($v) { return isset($v) && $v !== '' && trim($v) !== '' && $v !== false; });
		$this->data['flenme'] = $lv_flenme;
		$this->data['flesze'] = filesize($lv_fulflenme);
		//$this->data['fleext'] = $lp_post['fleext'];
		$this->data['fletyp'] = $lp_post['fletyp'] ?? 'text/plain';
		$this->data['fledsp'] = '';
		//$this->data['docsts'] = 'A';
		$this->data['fleatr'] = '<ppl>'.( strtoupper(isset($lp_post['fleatrppl'])?$lp_post['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';
    if ( isset($lp_post['flesrcfld']) ){ $this->data['grldmsfldcod'] = $lp_post['flesrcfld']; }
    $this->data['srcobjdocclscod'] = $lp_post['sysdocclscod'] ?? '';
    $lo_out_data = array();
    $lv_act = isset($this->data['grldmsdoccod']) ? '12' : '01';
		if( $this->call_sp( $lv_act, $this->data, $lo_out_data ) ) {
			$this->data['grldmsdocvercod'] = array_values($lo_out_data)[1];
			// renombra el arvchivo fisico con el ID del registro de la base de datos
			rename ($lv_fulflenme, realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data['grldmsdocvercod'] . '.dms');
			return $lo_out_data;
		} else {
			return false;
		}
	}
  
  // PUBLISH. publica la version de un documento
  function publishFile( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		if( $this->call_sp( '05', $this->data, $lo_out_data ) ){
      return $lo_out_data;
    }
  }
	
	// DOWNLOAD. descarga un archivo
	function download() {
		// obtengo ubicaci�n de archivos
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod). chr(47) . '/DMS';
		if ( realpath($lv_fleloc)==false ) {
			$lv_ret[] = array('error' => 'Directorio o ruta invalida o desconocida.');
		}
		// descargo el archivo
		else {
      $lv_fulpth = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data['grldmsdocvercod'] . '.dms';
      while (ob_get_level()) ob_end_clean();

      header('Content-Type: ' . $this->data['fletyp']);
      header('Content-Disposition: attachment; filename="' . $this->data['grldmsdoctxt'] . '"');
      header('Content-Length: ' . filesize($lv_fulpth));

      $lo_fle = fopen($lv_fulpth, 'r');
      fpassthru($lo_fle);
      fclose($lo_fle);
		}
	}
  
  // GET FOLDER STRUCTURE. Devuelve carpetas y archivos anidados
  function getFolderStructure($lp_post = array()) {
    if (count($lp_post) == 0) { $lp_post = $this->co_reg->request->post; }

    $this->data = $lp_post;
    $lo_out_data = array();

    if ($this->call_sp('07', $this->data, $lo_out_data)) {
      //$lo_out_data['errcod'] = $this->errcod;
      $this->data = $lo_out_data;
    } else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }

    return $this->data;
  }

  
	//  CALL SP.  llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'grldmsdoccod'), 
																			$this->co_reg->db->sqldat($lp_in,'grldmsdoccodext'), 
																			$this->co_reg->db->sqldat($lp_in,'grldmsdoctxt', false), 
																			$this->co_reg->db->sqldat($lp_in,'grldmsfldcod'),
																			$this->co_reg->db->sqldat($lp_in,'grldmsdocsrc'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjpos'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'autcod'),
																			$this->co_reg->db->sqldat($lp_in,'perusrcod'),
																			$this->co_reg->db->sqldat($lp_in,'perusrrls'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($lp_in,'fletypcod'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'grldmsdocatr',false),
                                     	$this->co_reg->db->sqldat($lp_in,'grldmsdocvercod',false),
                                     	$this->co_reg->db->sqldat($lp_in,'grldmsdocvercodext',false),
                                      $this->co_reg->db->sqldat($lp_in,'flenme',false),
                                      $this->co_reg->db->sqldat($lp_in,'fleext',false),
                                      $this->co_reg->db->sqldat($lp_in,'fletyp',false),
                                      $this->co_reg->db->sqldat($lp_in,'flesze',false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_DMS_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='18' || $lp_action=='28' || $lp_action=='07' ) {
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