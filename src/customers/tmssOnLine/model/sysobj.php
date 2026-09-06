<?php
final class sysobj extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	private $lo_ftpcnx;
	const ID = 'sysobjcod';
	const OBJTYP = 'SYS_OBJ';

	private const FTPS='gorse.ar';
	private const FTPU='sysobjedt_ftp';
	private const FTPP='y@Xe8pGrqqiw0t-XrL4F@'; 

  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }

	function __destruct(){ $this->ftpClose(); }

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

  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // LOAD VERSION. carga los datos de una version
  function loadVersion( $lp_key=array() ) {
		return $this->call_sp( '13', $lp_key, $this->data );
  }
  
  // GET VERSIONS. devuelve la lista de versiones del objeto
  function getVersions( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lo_out_data = array();
		if ( !$this->call_sp( '18', $lp_dat, $lo_out_data ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $lo_out_data;
  }
  
	// GET CONTENT. devuelve el contenido de un objeto
  // recibe: id objeto
  //         version (opcional. DEV-default / PRD / <idVersion> )
	function getContent( $lp_sysobjcod, $lp_ver='DEV' ){
		$lv_ret = array('sysobjcod'=>$lp_sysobjcod,'flecnt'=>'','errtyp'=>'S','errcod'=>0,'errtxt'=>'','fleobj'=>array());
		
		// cargo objeto
		if( !$this->load( array('sysobjcod'=>$lp_sysobjcod) ) ){
			return $this->co_reg->document->getJson( array('sysobjcod'=>$lp_sysobjcod,'flecnt'=>'','errtyp'=>$this->errtyp,'errcod'=>$this->errcod,'errtxt'=>'Error al cargar objeto. '.$this->errtxt) );
		} else {
			$lv_ret['fleobj'] = $this->getData();
		}
		
		// recupero codigo de version del objeto
		if( $lp_ver!='DEV' && $lp_ver!='PRD' ){
			if( !$this->loadVersion(array('sysobjcod'=>$lp_sysobjcod,'sysobjver'=>$lp_ver)) ){
				return $this->co_reg->document->getJson( array('sysobjcod'=>$lp_sysobjcod,'flecnt'=>'','errtyp'=>$this->errtyp,'errcod'=>$this->errcod,'errtxt'=>'Error al recuperar version. '.$this->errtxt) );
			} else {
				$lv_ret['flecnt'] = $this->sysobjcnt;
			}
			
		// recupero codigo dev o prd
		} else {
			switch( $this->sysobjclstyp ){
				case 'JS': case 'PHP': case 'CSS':
					if( !$this->ftpConnect() ){ return $this->co_reg->document->getJson( array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt) ); }
					$lv_ret['flecnt'] = $this->ftpGetFileContent( '/'.($lp_ver=='DEV'?'developers':'customers').'.gorse.ar/'.$this->sysobjclspth.'/'.$this->sysobjtxt.$this->sysobjclsfleext );
					break;
				case 'SP':
					$lv_prm = array('objkey'=>$this->sysobjtxt, 'sysobjclssys'=>$this->sysobjclssys);
					$lo_rs = array();
					if( $this->call_sp_cmp( '33', $lv_prm, $lo_rs ) ){
						foreach($lo_rs as $lv_row){ $lv_ret['flecnt'].=$lv_row['text']; }
					} else {
						$lv_ret['errtyp'] = 'W';
						$lv_ret['errcod'] = -1;
						$lv_ret['errtxt'] = 'Objeto ['.$this->sysobjtxt.'] no encontrado';
					}
					break;
				case 'FN':
					$lv_prm = array('objkey'=>$this->sysobjtxt, 'sysobjclssys'=>$this->sysobjclssys);
					$lo_rs = array();
					if( $this->call_sp_cmp( '33', $lv_prm, $lo_rs ) ){
						foreach($lo_rs as $lv_row){ $lv_ret['flecnt'].=$lv_row['text']; }
					} else {
						$lv_ret['errtyp'] = 'W';
						$lv_ret['errcod'] = -1;
						$lv_ret['errtxt'] = 'Objeto ['.$this->sysobjtxt.'] no encontrado';
					}
					break;
				case 'TABLE':
					$lv_ret['flecnt'] = array();
					$lv_prm = array('objkey'=>$this->sysobjtxt, 'sysobjclssys'=>$this->sysobjclssys);
					$lo_rs = array();
					if( $this->call_sp_cmp( '23', $lv_prm, $lo_rs ) ){
						usort($lo_rs, 'sortByColumnOrder');
						$lv_ret['flecnt'] = $lo_rs;
					} else {
						$lv_ret['errtyp'] = 'W';
						$lv_ret['errcod'] = -1;
						$lv_ret['errtxt'] = 'Objeto ['.$this->sysobjtxt.'] no encontrado';
					}
					break;
			}
		}
		return $this->co_reg->document->getJson( $lv_ret );
	}
	
  // SET CONTENT. guarda el contenido de un objeto
  function setContent( $lp_sysobjcod, $lp_dat ){
    $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
		$this->load( array('sysobjcod'=>$lp_sysobjcod) );
		switch( strtoupper($this->sysobjclstyp) ){
			case 'PHP': case 'CSS': case 'JS':
				$lv_flenme = realpath('../'.$this->sysobjclspth.'/'.$this->sysobjtxt.$this->sysobjclsfleext);
				if(file_exists( $lv_flenme )){
					try{
						$lv_svsts = file_put_contents($lv_flenme, $lp_dat, LOCK_EX);
					} catch(Exception $e){
						$lv_ret['errtyp'] = 'E';
						$lv_ret['errcod'] = -2;
						$lv_ret['errtxt'] = 'Error al grabar el archivo: '.$e->getMessage();
					}
					if(!$lv_svsts){ //if($lv_svsts === false || $lv_svsts == -1){
						$lv_ret['errtyp'] = 'E';
						$lv_ret['errcod'] = -2;
						$lv_ret['errtxt'] = 'Error al grabar el archivo '.$this->sysobjtxt;
					}
				}else {
					$lv_ret['errtyp'] = 'E';
					$lv_ret['errcod'] = -1;
					$lv_ret['errtxt'] = 'Archivo ['.$this->sysobjtxt.'] no encontrado';
				}
				break;
			
			case 'SP':
				$lp_dat = str_ireplace('CREATE PROCEDURE','ALTER PROCEDURE',$lp_dat);
				try{
					if( !$this->co_reg->db->sqlexecute( $lp_dat, array(), ($this->sysobjclssys==1?0:1) ) ){
						$lv_ret['errtyp'] = 'E';
						$lv_ret['errcod'] = -3;
						$lv_ret['errtxt'] = 'Error al modificar SP: '.$this->co_reg->db->getLastErrorMessage();
					}
				} catch(Exception $e){
					$lv_ret['errtyp'] = 'E';
					$lv_ret['errcod'] = -2;
					$lv_ret['errtxt'] = 'Error al modificar SP: '.$e->getMessage();
				}
				break;
				
			case 'FN':
				$lp_dat = str_ireplace('CREATE FUNCTION','ALTER FUNCTION',$lp_dat);
				try{
					$lo_rs = $this->co_reg->db->sqlexecute( $lp_dat, array(), ($this->sysobjclssys==1?0:1) );
					if( $this->co_reg->db->getLastErrorMessage()!=''){
						$lv_ret['errtyp'] = 'E';
						$lv_ret['errcod'] = -3;
						$lv_ret['errtxt'] = 'Error al modificar FN: '.$this->co_reg->db->getLastErrorMessage();
					}
				} catch(Exception $e){
					$lv_ret['errtyp'] = 'E';
					$lv_ret['errcod'] = -2;
					$lv_ret['errtxt'] = 'Error al modificar FN: '.$e->getMessage();
				}
				break;
			
			default:
				$lv_ret['errtyp'] = 'E';
				$lv_ret['errcod'] = -1;
				$lv_ret['errtxt'] = 'Funcionalidad no habilitada para objeto ['.$this->sysobjtxt.'].';
				break;
    }
    return $this->co_reg->document->getJson( $lv_ret );
  }
	
	// SEND FILE. envia un archivo (desa->prd o prd->desa)
	function sendFile( $lp_sysobjcod, $lp_sendTo='customers' ){
		if( !$this->load( array('sysobjcod'=>$lp_sysobjcod) ) ){
			return $this->co_reg->document->getJson( array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt) );
		} else if( $lp_sendTo!='customers' && $lp_sendTo!='developers' ){
			return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'Invalid parameter [sendTo].') );
		}
		
		// conecto al ftp
		if( !$this->ftpConnect() ){ return $this->co_reg->document->getJson( array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt) ); }
		
		// lectura archivo origen
		$lv_srcfle = '/'.($lp_sendTo=='developers'?'customers':'developers').'.gorse.ar/'.$this->sysobjclspth.'/'.$this->sysobjtxt.$this->sysobjclsfleext;
		$lv_txt = $this->ftpGetFileContent( $lv_srcfle, FTP_ASCII );
		if($lv_txt==false){
			ftp_close($this->lo_ftpcnx);
			return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al leer archivo de origen ['.$lv_srcfle.']') );
		}
		
		// grabado archivo en destino
		$lv_dstfle = '/'.$lp_sendTo.'.gorse.ar/'.$this->sysobjclspth.'/'.$this->sysobjtxt.$this->sysobjclsfleext;
		$lv_stream = fopen('php://temp','w+');
		if( !fwrite($lv_stream, $lv_txt) ){
			fclose($lv_stream);
			ftp_close($this->lo_ftpcnx);
			return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error escribir contenido en memoria (len='.strlen($lv_txt).')') );
		} else {
			rewind($lv_stream);
			if( !ftp_fput($this->lo_ftpcnx, $lv_dstfle, $lv_stream, FTP_BINARY, 0) ){
				fclose($lv_stream);
				ftp_close($this->lo_ftpcnx);
				return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al grabar archivo en destino ['.$lv_dstfle.']') );
			}
		}
		fclose($lv_stream);

		// cierro ftp y envio respuesta
		ftp_close($this->lo_ftpcnx);
		return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
	}
	
	// GET FILE LIST. devuelve la lista de archivos de un directorio y su correspondiente ID de objeto
	function getFileList( $lp_env='customers', $lp_dir='' ) {

		// la busqueda se resume en las siguientes ubicaciones (cada una corresponde a una clase de objeto)
		$lv_cmparr =array('engine'=>'system/engine',
											'config'=>'system/config',
											'controller'=>'tmssOnLine/controller',
											'model'=>'tmssOnLine/model',
											'view'=>'tmssOnLine/view/default',
											'wwwroot'=>'wwwroot',
											'css'=>'wwwroot/library/css/temasis', 
											'js'=>'wwwroot/library/js/temasis'
										);
		
		// si se indico un directorio particular solo busco en ese
		if($lp_dir==''){ $lv_cmparr2 = $lv_cmparr;
		} else if(isset($lv_cmparr[$lp_dir])){ $lv_cmparr2 = array($lp_dir=>$lv_cmparr[$lp_dir]);
		} else { $lv_cmparr2 = array(); }
		
		// conecto al ftp
		if( !$this->ftpConnect() ){ return $this->co_reg->document->getJson( array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt) ); }
		
		// obtiene lista de archivos de cada directorio
		$lo_fle = array();
		foreach( $lv_cmparr2 as $lv_cmpkey=>$lv_cmpval){
			$lo_fle[$lv_cmpkey] = $this->ftpClearRawList( ftp_rawlist($this->lo_ftpcnx, '-al /'.$lp_env.'.gorse.ar/'.$lv_cmpval) );
		}
		
		// devuelve array con resultados
		return $lo_fle;
	}
	
	
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
																			$this->co_reg->db->sqldat($lp_in,'sysobjcod'),
																			$this->co_reg->db->sqldat($lp_in,'sysobjcodext'),
																			$this->co_reg->db->sqldat($lp_in,'sysobjtxt'),
																			$this->co_reg->db->sqldat($lp_in,'sysobjclscod'),
																			$this->co_reg->db->sqldat($lp_in,'sysobjver'),
																			$this->co_reg->db->sqldat($lp_in,'sysobjlck'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysobjsys'),
																			$this->co_reg->db->sqldat($lp_in,'sysdevgrp')
																		);
		$this->sysdata['sqltxt'] = 'SYS_OBJ_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , 0);

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='18') {
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
	
	//  CALL SP. llamada a base de datos
	private function call_sp_cmp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
																			($lp_in['objkey']??''),
																			($lp_in['objqry']??''),
																			($lp_in['objkey2']??'')
																		);
		$this->sysdata['sqltxt'] = 'SYS_CMP_DEF (?,?,?,?,?)';
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], ($lp_in['sysobjclssys']??0)==1?0:1 );
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		if ( $lp_action=='13' || $lp_action=='23' || $lp_action=='33' || $lp_action=='43' ) {
			$lp_out = $lo_rs;
		} else {
			if ( $lo_rs && count($lo_rs)>0 ) {
				if ( isset($lo_rs[0]['errcod']) )  {
					if ( $lo_rs[0]['errcod']!=0 ) {
						$this->errtyp = 'E';
						$this->errcod = $lo_rs[0]['errcod'];
						$this->errtxt = $lo_rs[0]['errtxt'];
					} else {
						$lp_out = $lo_rs[0];
						$this->data[self::ID] = array_values($lp_out)[0];
					}
				} else {
					$lp_out = $lo_rs[0];
				}
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -999;
				$this->errtxt = 'Error inesperado al procesar la operacion ['.$this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']).']';
			}
		}
		return ($this->errcod==0?true:false);
	}
	
	function ftpGetFileContent( $lp_fle, $lp_typ=FTP_ASCII ){
		$lv_txt = false;
		ob_start(); 
		if( ftp_get($this->lo_ftpcnx, 'php://output', $lp_fle, $lp_typ) ){
			$lv_txt = ob_get_contents();
		}
		ob_end_clean();
		return $lv_txt;
	}
	
	function ftpClose(){
		if( is_object($this->lo_ftpcnx) ){
			ftp_close( $this->lo_ftpcnx );
		}
		return true;
	}
	
	function ftpConnect(){
		// si esta conectado no hago nada
		if( is_object($this->lo_ftpcnx) ){ return true; }
		
		// Set up a connection
		$this->lo_ftpcnx = ftp_connect(self::FTPS);
		if( !$this->lo_ftpcnx ){
			return array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al conectar al servidor ['.$lv_srv.']');
		}
		
		// Login
		if ( !ftp_login($this->lo_ftpcnx, self::FTPU, self::FTPP) ) {
			ftp_close($this->lo_ftpcnx);
			return array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Credenciales de usuario invalidas. ['.self::FTPU.']');
		}
		
		return true;
	}
	
	private function ftpClearRawList( $lp_arr ){
		foreach($lp_arr as &$lv_row){
			$lv_row = substr($lv_row,39,strlen($lv_row)-39-4);
		}
		unset($lv_row);
		return $lp_arr;
	}
	
}

function sortByColumnOrder($a, $b) {
	return $a['colorder'] - $b['colorder'];
}
?>