<?php
final class grldatupl extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'flecod';
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
	
	/**
	 * UPLOAD STRING
	 * carga una string y graba un archivo fisico
	 * Parametros:
	 * 	flenme: nombre del archivo (prueba)
	 *	fleext: extension del archivo (.pdf)
	 *	flecnt: contenido del archivo como string
	 *	fletyp: tipo mime del archivo (application/pdf)
	 */
	function uploadString( $lp_post ) {
	
		// GRABADO. graba el string como archivo con un nombre temporal
		$lv_flenme = $lp_post['flenme'];
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
		$lv_fulflenme = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme;
		$lv_flecnt = $lp_post['flecnt'];
		try{
			file_put_contents( $lv_fulflenme, (isset($lp_post['flecnt'])?$lp_post['flecnt']:'') );
		} catch(Exception $e){
			$this->errtyp='E';
			$this->errcod=-1;
			$this->errtxt='Error al grabar archivo. '.$e->getMessage();
			return false;
		}
		
		// REGISTRO. registra el archivo fisico en la base de datos
		$this->data = $lp_post;
		$this->data['flenme'] = $lv_flenme;
		$this->data['flesze'] = filesize($lv_fulflenme);
		$this->data['fleext'] = $lp_post['fleext'];
		$this->data['fletyp'] = $lp_post['fletyp'];
		$this->data['fledsp'] = '';
		$this->data['docsts'] = 'A';
		$this->data['fleatr'] = '<ppl>'.( strtoupper(isset($lp_post['fleatrppl'])?$lp_post['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';
		if( $this->call_sp( '01', $this->data, $lo_out_data ) ) {
			$this->data[self::ID] = array_values($lo_out_data)[0];
			// renombra el arvchivo fisico con el ID del registro de la base de datos
			rename (realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lv_flenme, realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data[self::ID] . '.tmss');
			return true;
		} else {
			return false;
		}
	}
	
	// UPLOAD FILE. carga un archivo
	function uploadFile( $lp_post ) {
		//$lv_ret=array();
		$lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
		foreach ( $this->co_reg->request->files as $lo_fle) {  
			$lo_out_data = array();
			$this->data = $lp_post;
			$this->data['fleatr'] = '<ppl>'.( strtoupper(isset($this->data['fleatrppl'])?$this->data['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';
			$this->data['docsts'] = 'A';
			if ( is_array($lo_fle['name']) ) { 
				$this->data['tmpnme'] = $lo_fle['tmp_name'][0];
				$this->data['flenme'] = basename($lo_fle['name'][0]); 		// full_chat.png
				$this->data['fletyp'] = $lo_fle['type'][0];		// image/png
				$this->data['flesze'] = $lo_fle['size'][0];		// 57719
				$this->data['error'] = $lo_fle['error'][0];
			} else {
				$this->data['tmpnme'] = $lo_fle['tmp_name'];
				$this->data['flenme'] = basename($lo_fle['name']); 		// full_chat.png
				$this->data['fletyp'] = $lo_fle['type'];		// image/png
				$this->data['flesze'] = $lo_fle['size'];		// 57719
				$this->data['error'] = $lo_fle['error'];
			}
			if ($this->data['error']==UPLOAD_ERR_OK) {
				// obtengo ubicaci�n de archivos
				$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
				$lv_ftp = false;
				if ( substr($lv_fleloc,0,6)=='ftp://' ) {
					$lv_ftp = true;
					$lo_ftp = new tmssFtp( $this->co_reg );
					$lo_ftp->getDataFromUri( $lv_fleloc );
					if ( !$lo_ftp->connect() ) {
						//$lv_ret[] = array('error' => 'Se produjo un error al conectarse al ftp server.');
						$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
						$lv_ret['errtxt'] = 'Se produjo un error al conectarse al ftp server. ';
					}
				} else if ( realpath($lv_fleloc)==false ) {
					//$lv_ret[] = array('error' => 'Directorio o ruta invalida o desconocida.');
					$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
					$lv_ret['errtxt'] .= 'Directorio o ruta invalida o desconocida. ';
				}
				// grabo el registro
				if ( $this->call_sp( '01', $this->data, $lo_out_data ) ) {
					$this->data[self::ID] = array_values($lo_out_data)[0];		
					// subo el archivo
					if ( $lv_ftp ) {
						if ( !$lo_ftp->upload($this->data['tmpnme'], $lo_ftp->path . $this->data[self::ID] . '.tmss' ) ) {
							$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
							$lv_ret['errtxt'] .= 'Se produjo un error al subir el archivo al ftp server. ';
						} else {
							//$lv_ret[] = array('files'=>$lo_fle);
							$lv_ret['errtxt'] .= $lv_ret['errtxt'] .= 'Archivo grabado ['.$lo_fle['name'].']. ';
						}
					} else if ( !move_uploaded_file($this->data['tmpnme'], realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data[self::ID] . '.tmss') ) {
						//$lv_ret[] = array('error' => 'Se produjo un error al subir el archivo al file server.');
						$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
						$lv_ret['errtxt'] .= 'Se produjo un error al subir el archivo al file server. ';
					}
				} else {
					//$lv_ret[] = array('error' => 'Se produjo un error al registrar el registro de archivo en la base de datos.');
					$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
					$lv_ret['errtxt'] .= 'Se produjo un error al registrar el registro de archivo en la base de datos. ';
				}
			} else {
				//$lv_ret[] = array('error' => 'Se produjo un error al grabar el archivo en una ubicacion temporal.');
				$lv_ret['errtyp'] = 'E'; $lv_ret['errcod'] = '-1'; 
				$lv_ret['errtxt'] .= 'Se produjo un error al grabar el archivo en una ubicacion temporal. ';
				
				switch ($this->data['error']) {
					case UPLOAD_ERR_INI_SIZE: $lv_ret['errtxt'] .= ' El archivo es demasiado grande para la configuracion del servidor. '
						.' / Limite por archivo (upload_max_filesize): ' . ini_get('upload_max_filesize')
						.' / Limite total del formulario (post_max_size): ' . ini_get('post_max_size')
						.' / Limite de memoria (memory_limit): ' . ini_get('memory_limit');
					
					; break;
					case UPLOAD_ERR_FORM_SIZE: $lv_ret['errtxt'] .= ' El archivo supera el limite del formulario. '; break;
					case UPLOAD_ERR_PARTIAL: $lv_ret['errtxt'] .=  ' La subida se interrumpio. Intentalo de nuevo. '; break;
					case UPLOAD_ERR_NO_FILE: $lv_ret['errtxt'] .= ' No seleccionaste ningún archivo. '; break;
					case UPLOAD_ERR_NO_TMP_DIR: $lv_ret['errtxt'] .= ' Error interno: Falta la carpeta temporal en el servidor. '; break;
					case UPLOAD_ERR_CANT_WRITE: $lv_ret['errtxt'] .= ' Error interno: No se pudo escribir en el disco. '; break;
					default: $lv_ret['errtxt'] .= ' Error desconocido en la subida. '; break;
				}	
			}
		}
		$this->errtyp=$lv_ret['errtyp'];
		$this->errcod=$lv_ret['errcod'];
		$this->errtxt=$lv_ret['errtxt'];
		return $lv_ret;
	}	
	
	// DOWNLOAD. descarga un archivo
	function download() {
		// obtengo ubicaci�n de archivos
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
		$lv_ftp = false;
		if ( substr($lv_fleloc,0,6)=='ftp://' ) {
			$lv_ftp = true;
			$lo_ftp = new tmssFtp( $this->co_reg );
			$lo_ftp->getDataFromUri( $lv_fleloc );
			if ( !$lo_ftp->connect() ) {
				$lv_ret[] = array('error' => 'Se produjo un error al conectarse al ftp server.');
			}
		} else if ( realpath($lv_fleloc)==false ) {
			$lv_ret[] = array('error' => 'Directorio o ruta invalida o desconocida.');
		}
		// descargo el archivo
		if ( $lv_ftp ) {
			if ( $lo_ftp->download( $this->data['flenme'], $lo_ftp->path . $this->data[self::ID] . '.tmss') ) {
				//echo "successfully written to $local_file\n";
			} else {
				$lv_ret[] = array('error' => 'Se produjo un error al descargar el archivo desde el ftp server.');
			}
		} else {
			header('Content-Type: '.$this->data['fletyp']);
			header('Content-Disposition: attachment; filename="'.$this->data['flenme'].'"');
			header('Content-Length: ' . $this->data['flesze']);
			$lo_fle = fopen(realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data[self::ID] . '.tmss', 'r');
			fpassthru($lo_fle);
			fclose($lo_fle);
		}
	}
	
  // SAVE. modificar registro
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['fleatr'] = '<ppl>'.( strtoupper(isset($lp_dat['fleatrppl'])?$lp_dat['fleatrppl']:'')=='ON' ? 1 : 0 ).'</ppl>';		
		$lp_dat['docsts'] = 'A';
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '02', $this->data, $lo_out_data );
  }
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
	
	// GET FILE CONTENTS. devuelve el contenido del archivo
  function getFileContents( $lp_dat=array(), $lp_atr=array('mode'=>'rb','addpth'=>'')) {
		$lv_buffer='';
		$lv_fleloc = $lp_atr['addpth'] . self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
		$lv_flelocful = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lp_dat[self::ID] . '.tmss';
		if( file_exists($lv_flelocful) ) {
			$lo_fle = fopen( $lv_flelocful , $lp_atr['mode'] );
			$lv_buffer = stream_get_contents($lo_fle);
			fclose($lo_fle);
		}
		return $lv_buffer;
	}
  
  // GET FILE DATA. devuelve el contenido del archivo junto con algunos datos extra
  function getFileData( $lp_dat=array(), $lp_atr=array('mode'=>'rb','addpth'=>'') ) {		
    $this->errtyp = 'S';
    $this->errcod = 0;
    $this->errmsg = '';
    $this->flecnt = '';
	
		// INFO. carga la info del archivo solicitado
		$lv_dat = array();
		if( $this->call_sp( '03', array('flecod'=>$lp_dat['flecod']), $lv_dat ) ){
			$this->flesrctyp = $lv_dat['flesrctyp'];
			$this->flesrccod = $lv_dat['flesrccod'];
		} else {
			$this->errtyp='E';
			$this->errcod=-1;
			$this->errmsg='InvalidFile';
		}
		
		// PERMISOS. FALTA ******************** !!!!
		// validar que el usuario tenga permisos para recuperar el archivo
	
    // CARGA. carga el archivo solicitado
		if($this->errcod==0){
			$lv_fleloc = $lp_atr['addpth'] . self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
			$lv_flelocful = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $lp_dat[self::ID] . '.tmss';
			if( file_exists($lv_flelocful) ) {
				$lo_fle = fopen( $lv_flelocful , $lp_atr['mode'] );
				$this->flecnt = base64_encode(stream_get_contents($lo_fle));
				fclose($lo_fle);
			} else {
				$this->errtyp='E';
				$this->errcod=-11;
				$this->errmsg='invalidFile';
			}
		}
		
		// DEVUELVE. info del archivo
		return array($this->data);
	}
  
  // DELETE. borra un adjunto
  function delete( $lp_post ) {
		$lv_ret = array();
		
		// obtengo ubicaci�n de archivos
		$lv_fleloc = self::FILE_ROOT . chr(47) . strtoupper($this->co_reg->sec->buscod);
		$lv_server_filename = '';
		$lv_ftp = false;
		if ( substr($lv_fleloc,0,6)=='ftp://' ) {
			$lv_ftp = true;
			$lo_ftp = new tmssFtp( $this->co_reg );
			$lo_ftp->getDataFromUri( $lv_fleloc );
			if ( !$lo_ftp->connect() ) {
				$lv_ret[] = array('error' => 'Se produjo un error al conectarse al ftp server.');
			}
		} else if ( realpath($lv_fleloc)==false ) {
			$lv_ret[] = array('error' => 'Directorio o ruta invalida o desconocida.');
		}
		
		// borrar el registro del archivo
		$this->data = $lp_post;
		$lo_out_data = array();
		if ( $this->call_sp( '04', $this->data, $lo_out_data ) ) {
			// borro el archivo
			if ( $lv_ftp ) {
				$lv_server_filename = $lo_ftp->path . $this->data[self::ID] . '.tmss';
				if ( $lo_ftp->delete($lv_server_filename) ) {
					//echo "successfully deleted";
					$lv_ret[] = array('info' => 'Archivo borrado del ftp server.');
				} else {
					$lv_ret[] = array('error' => 'Se produjo un error al borrar el archivo desde el ftp server.');
				}
			} else {
				$lv_server_filename = realpath($lv_fleloc) . (substr(realpath($lv_fleloc),0,-1)==chr(92)?'':chr(92)) . $this->data[self::ID] . '.tmss';
				if(file_exists($lv_server_filename)) {
					unlink($lv_server_filename);
					if(file_exists($lv_server_filename)) {
						$lv_ret[] = array('error' => 'Se registro el borrado en la base de datos pero el archivo f�sico no pudo ser eliminado.');
					} else {
						$lv_ret[] = array('info' => 'Archivo borrado del file server.');
					}
				} else {
					$lv_ret[] = array('info' => 'Archivo ['.$this->data[self::ID].'] inexistente en file server.');
				}
			}
		} else {
			$lv_ret[] = array('error' => 'Se produjo un error al registrar el borrado en la base de datos.');
		}
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions( $lp_vewopt );
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET MAIN PHOTO. obtiene el archivo principal asociado al objeto
  function getMainPhoto( $lp_dat=array() ) {
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '13', $this->data, $this->data );
  }	
	
	
	public function createTempFile( $lp_nme ){
		$lv_dir = '../files/'.$this->co_reg->sec->buscod.'/TMP';
		$lv_fulfle = $lv_dir.'/'.$lp_nme;
		if(!file_exists($lv_dir)) { mkdir($lv_dir, 0777, true); }
		$lo_ptr = fopen($lv_fulfle, 'w+');
		fclose($lo_ptr);
		return $lv_fulfle;
	}
	
	
	
	//  CALL SP.  llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'flecod'), 
																			$this->co_reg->db->sqldat($lp_in,'flenme'), 
																			$this->co_reg->db->sqldat($lp_in,'flesze'), 
																			$this->co_reg->db->sqldat($lp_in,'fleext'), 
																			$this->co_reg->db->sqldat($lp_in,'fletyp'), 
																			$this->co_reg->db->sqldat($lp_in,'fledsp'), 
																			$this->co_reg->db->sqldat($lp_in,'flecmt'), 
																			$this->co_reg->db->sqldat($lp_in,'fletypcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'), 
																			$this->co_reg->db->sqldat($lp_in,'flesrctyp'), 
																			$this->co_reg->db->sqldat($lp_in,'flesrccod'), 
																			$this->co_reg->db->sqldat($lp_in,'flesrcfld'), 
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldte($lp_in,'fleduedte'),
																			$this->co_reg->db->sqldat($lp_in,'fleatr',false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_FLE_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='13') {
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