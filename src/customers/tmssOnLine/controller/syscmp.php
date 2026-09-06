<?php
final class syscmpController extends tmssController {
	const MODEL = 'syscmp';							
	const VIEW  = 'syscmp';							
	const ID = 'sysdocclscod';					
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

	private const FTPS='gorse.ar';
	private const FTPU='syscmp_ftp';
	private const FTPP='y@Xe8pGrqqiw0t-XrL4F@'; 
   
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  // INDEX. main method
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST -------------------------------------------------------------------------------------
      case '#': case '#08': 
				return $this->co_reg->document->getview( self::VIEW, array('data'=>$this->lo_mdl, 'cmptyp'=>'', 'devcuscnx'=>'', 'srccnx'=>'', 'dstcnx'=>'', 'shwdif'=>'dif', 'actcod' => $this->data['actcod']) );
        break;


				
			// COMPARE DATABASE -------------------------------------------------------------------------
			case '#28':
			
				// determino los códigos de conexión según el tipo de compraración seleccionada
				$lv_cmptyp = (isset($this->co_reg->request->post['cmptyp'])?$this->co_reg->request->post['cmptyp']:'');
				$lv_cnxsrc = '';
				$lv_cnxdst = '';
				if ( $lv_cmptyp=='cor' ) {
					$lv_cnxsrc='X000043746';
					$lv_cnxdst='X000044076';
				} else if ( $lv_cmptyp=='imp' ) {
					$lv_cnxsrc='X000042706';
					$lv_cnxdst='X000043036';
				} else if ( $lv_cmptyp=='dev' ) {
					$lv_cnxsrc='X000043036';
					$lv_cnxdst='X000080192';
				} else if ( $lv_cmptyp=='cus' ) {
					$lv_cnxsrc='X000043036';
					$lv_cnxdst=$this->co_reg->request->post['devcuscnx'];					
				}
				
				// obtengo los datos del formulario
				$lv_prm = array('cmptyp' => (isset($this->co_reg->request->post['cmptyp'])?$this->co_reg->request->post['cmptyp']:''),
												'devcuscnx' => (isset($this->co_reg->request->post['devcuscnx'])?$this->co_reg->request->post['devcuscnx']:''),
												'srccnx' => $lv_cnxsrc,
												'dstcnx' => $lv_cnxdst,
												'shwdif' => (isset($this->co_reg->request->post['shwdif'])?$this->co_reg->request->post['shwdif']:''),
												'lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'doc'		=> $this->co_reg->document,
												'data' 	=> $this->lo_mdl,
												'actcod' => $this->data['actcod']
												);
												
				// obtengo la estructura de origen
				if ( $lv_cnxsrc!='' ) {
					$this->lo_mdl->getStructure( $lv_cnxsrc );
					$lv_prm['obj_src'] = $this->lo_mdl->sysobj;
					$lv_prm['col_src'] = $this->lo_mdl->syscol;
					$lv_prm['cmt_src'] = $this->lo_mdl->syscmt;
					$lv_prm['inx_src'] = $this->lo_mdl->sysinx;
					$lv_prm['inx_col_src'] = $this->lo_mdl->sysinxcol;
				}
				
				// obtengo la estructura de destino
				if ( $lv_cnxdst!='' ) {
					$this->lo_mdl->getStructure( $lv_cnxdst );
					$lv_prm['obj_dst'] = $this->lo_mdl->sysobj;
					$lv_prm['col_dst'] = $this->lo_mdl->syscol;
					$lv_prm['cmt_dst'] = $this->lo_mdl->syscmt;
					$lv_prm['inx_dst'] = $this->lo_mdl->sysinx;
					$lv_prm['inx_col_dst'] = $this->lo_mdl->sysinxcol;
				}
				
				// muestro el formulario de comparación
				return $this->co_reg->load->view( self::VIEW, $lv_prm);
				break;
			
			
			// GET FILE LIST. devuelve lista de archivos diferentes entre desa-prd
			case '#getFileList':
				$lo_post = $this->co_reg->request->post;
				$lv_grp = ($lo_post['grp']??'');
				$lv_fndflenme = ($lo_post['flenme']??'');

				$lo_objmdl = $this->co_reg->load->model('sysobj');
				
				// obtengo todos los objetos de la base de datos
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			($lv_fndflenme!=''?'[~fltrow~]o.sysobjtxt'.chr(9).''.chr(9).chr(9).$lv_fndflenme.chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'c.sysobjclstxt, o.sysobjtxt');
				$lo_rs = $lo_objmdl->getList( $lv_prm );
								
				// recupero los archivos del ftp de origen y destino
				$lo_fledev = $lo_objmdl->getFileList( 'developers', $lv_grp );
				$lo_flecus = $lo_objmdl->getFileList( 'customers', $lv_grp );
				
				// compara. recorre cada grupo y segmenta iguales, en origen y en destino
				$lo_tmp = array();
				foreach($lo_fledev as $lv_keygrp=>$lv_dev_grp){
					$lo_tmp[$lv_keygrp]=array('eq'  => array_intersect($lo_fledev[$lv_keygrp], $lo_flecus[$lv_keygrp]),
																		'dev' => array_diff($lo_fledev[$lv_keygrp], $lo_flecus[$lv_keygrp]),
																		'prd' => array_diff($lo_flecus[$lv_keygrp], $lo_fledev[$lv_keygrp])
																		);
				}

				$lv_cmparr =array('system\engine'=>'engine',
													'system\config'=>'config',
													'tmssonline\controller'=>'controller',
													'tmssonline\model'=>'model',
													'tmssonline\view\default'=>'view',
													'wwwroot'=>'wwwroot',
													'wwwroot\library\css\temasis'=>'css', 
													'wwwroot\library\js\temasis'=>'js',
													'tmssmarkey\controller'=>'controller',
													'tmssmarkey\model'=>'model',
												);
				
				// compara. para los iguales obtiene el contenido y lo compara. el resto se agrega
				$lv_ret = array();
				foreach( $lo_rs as $lv_row ){
					if( $lv_row['sysobjclspth']==null or $lv_row['sysobjclspth']=='' ) { continue; }
					$lv_grp = $lv_cmparr[ strtolower($lv_row['sysobjclspth']) ];
					
					if( isset($lo_tmp[$lv_grp]) ){
						foreach($lo_tmp[$lv_grp]['eq'] as $lv_flenme){
							if( strtolower($lv_row['sysobjtxt'])==strtolower($lv_flenme) ){
								$lv_row['grp'] = $lv_keygrp;
								$lv_txtdev = $lo_objmdl->ftpGetFileContent( '/developers.gorse.ar/'.$lv_row['sysobjclspth'].'/'.$lv_row['sysobjtxt'].$lv_row['sysobjclsfleext'] );
								$lv_txtprd = $lo_objmdl->ftpGetFileContent( '/customers.gorse.ar/'.$lv_row['sysobjclspth'].'/'.$lv_row['sysobjtxt'].$lv_row['sysobjclsfleext'] );
								$lv_row['dif'] = ( $lv_txtdev==$lv_txtprd ? '' : 'X' );
								break;
							}
						}
						foreach($lo_tmp[$lv_grp]['dev'] as $lv_flenme){
							if( strtolower($lv_row['sysobjtxt'])==strtolower($lv_flenme) ){
								$lv_row['dif'] = 'D';
								$lv_row['grp'] = $lv_keygrp;
								break;
							}
						}
						foreach($lo_tmp[$lv_grp]['prd'] as $lv_flenme){
							if( strtolower($lv_row['sysobjtxt'])==strtolower($lv_flenme) ){
								$lv_row['dif'] = 'P';
								$lv_row['grp'] = $lv_keygrp;
								break;
							}
						}
						if( ($lv_row['dif']??'')!='' ){ $lv_ret[] = $lv_row; }
					}
				}
				return $this->co_reg->document->getJson( array('data'=>$lv_ret) );
				break;
			
			
			// COMPARE FILES ----------------------------------------------------------------------------
			case '#38':
				return $this->co_reg->document->getView('syscmpfle', array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;


				
			// send DATABASE OBJECT ---------------------------------------------------------------------
			case '#71':
				$lp_id = $this->co_reg->request->post['objid'];
				$lp_nme = $this->co_reg->request->post['objnme'];
				$lp_typ = $this->co_reg->request->post['objtyp'];
				$lp_way = $this->co_reg->request->post['way'];
				$lp_cnxsrc = $this->co_reg->request->post['cnxsrc'];
				$lp_cnxdst = $this->co_reg->request->post['cnxdst'];
				$lv_objsrc=array();
				$lv_colsrc=array();
				$lv_cmtsrc=array();
				if ( $lp_way=='tosrc' && $lp_cnxdst!='' ) {
					$this->lo_mdl->getStructure( $lp_cnxdst );
					$lv_objsrc = $this->lo_mdl->sysobj;
					$lv_colsrc = $this->lo_mdl->syscol;
					$lv_cmtsrc = $this->lo_mdl->syscmt;
				} else if ( $lp_way=='todst' && $lp_cnxsrc!='' ) {
					$this->lo_mdl->getStructure( $lp_cnxsrc );
					$lv_objsrc = $this->lo_mdl->sysobj;
					$lv_colsrc = $this->lo_mdl->syscol;
					$lv_cmtsrc = $this->lo_mdl->syscmt;
				}
				
				$lv_buffer = '';
				if ( $lp_typ=='U' ) {
					// obtengo los campos del objeto
					$lv_colsrcobj = array();
					foreach ( $lv_colsrc as $lv_row ) {
						if ($lv_row['id']==$lp_id) { $lv_colsrcobj[] = $lv_row; }
					}
					
					// ordeno las columnas por colorder
					usort($lv_colsrcobj, array("syscmpController", "array_sort_colorder") );	
					
					// preparo las columnas a agregar
					$lv_count=1;
					foreach ( $lv_colsrcobj as $lv_row ) {
						$lv_buffer .= '['.$lv_row['name'].'] ' . 
													$this->getFieldType( $lv_row['xtype'], $lv_row['xtypename'], $lv_row['length'], $lv_row['prec'], $lv_row['scale'], $lv_row['colstat'] )
													. ' ' . ($lv_row['isnullable']==0?'NOT ':'') . 'NULL'
													. ($lv_count<count($lv_colsrcobj)?',':'');
						$lv_count++;
					}
				
				} else if ( $lp_typ=='P' || $lp_typ=='FN' || $lp_typ=='TF' ) {
					// obtengo los campos del objeto
					$lv_cmtsrcobj = array();
					foreach ( $lv_cmtsrc as $lv_row ) {
						if ($lv_row['name']==$lp_nme) { $lv_cmtsrcobj[] = $lv_row; }
					}
					// ordeno las columnas por colid
					usort($lv_cmtsrcobj, array("syscmpController", "array_sort_colid") );
					// preparo los textos a agregar
					foreach ( $lv_cmtsrcobj as $lv_row ) {
						$lv_row['text'] = str_ireplace('CREATE PROCEDURE [dbo].['.$lp_nme.']','</TemasisSentence/>',$lv_row['text']);
						$lv_row['text'] = str_ireplace('CREATE FUNCTION [dbo].['.$lp_nme.']','</TemasisSentence/>',$lv_row['text']);
						$lv_buffer .= $lv_row['text'];
					}
				}
				
				// envio la estructura
				$lo_rs = $this->lo_mdl->setStructure( ($lp_way=='tosrc'?$lp_cnxsrc:$lp_cnxdst), $lp_typ, $lp_nme, $lv_buffer );
				echo (isset($lo_rs[0]['errcod'])?'ErrCod: '.$lo_rs[0]['errcod'].'<br>':(isset($lo_rs[0]['ErrorNumber'])?'ErrorNumber: '.$lo_rs[0]['ErrorNumber'].'<br>':''))
						.(isset($lo_rs[0]['ErrorSeverity'])?'ErrorSeverity: '.$lo_rs[0]['ErrorSeverity'].'<br>':'')
						.(isset($lo_rs[0]['ErrorState'])?'ErrorState: '.$lo_rs[0]['ErrorState'].'<br>':'')
						.(isset($lo_rs[0]['ErrorProcedure'])?'ErrorProcedure: '.$lo_rs[0]['ErrorProcedure'].'<br>':'')
						.(isset($lo_rs[0]['ErrorLine'])?'ErrorLine: '.$lo_rs[0]['ErrorLine'].'<br>':'')
						.(isset($lo_rs[0]['errtxt'])?'ErrTxt: '.$lo_rs[0]['errtxt'].'<br>':(isset($lo_rs[0]['ErrorMessage'])?'ErrorMessage: '.$lo_rs[0]['ErrorMessage'].'<br>':''));
				break;


				
			// update DATABASE OBJECT -------------------------------------------------------------------
			case '#72':
				$lp_id = $this->co_reg->request->post['objid'];
				$lp_nme = $this->co_reg->request->post['objnme'];
				$lp_nme2 = (isset($this->co_reg->request->post['objnme2'])?$this->co_reg->request->post['objnme2']:'');
				$lp_typ = $this->co_reg->request->post['objtyp'];
				$lp_way = $this->co_reg->request->post['way'];
				$lp_cnxsrc = $this->co_reg->request->post['cnxsrc'];
				$lp_cnxdst = $this->co_reg->request->post['cnxdst'];
				$lv_objsrc=array();
				$lv_colsrc=array();
				$lv_cmtsrc=array();
				$lv_inxsrc=array();
				$lv_inxcolsrc=array();
				if ( $lp_way=='tosrc' && $lp_cnxdst!='' ) {
					$this->lo_mdl->getStructure( $lp_cnxdst );
					$lv_objsrc = $this->lo_mdl->sysobj;
					$lv_colsrc = $this->lo_mdl->syscol;
					$lv_cmtsrc = $this->lo_mdl->syscmt;
					$lv_inxsrc = $this->lo_mdl->sysinx;
					$lv_inxcolsrc = $this->lo_mdl->sysinxcol;
				} else if ( $lp_way=='todst' && $lp_cnxsrc!='' ) {
					$this->lo_mdl->getStructure( $lp_cnxsrc );
					$lv_objsrc = $this->lo_mdl->sysobj;
					$lv_colsrc = $this->lo_mdl->syscol;
					$lv_cmtsrc = $this->lo_mdl->syscmt;
					$lv_inxsrc = $this->lo_mdl->sysinx;
					$lv_inxcolsrc = $this->lo_mdl->sysinxcol;
				}

				$lv_buffer = '';

				// TABLAS
				if ( $lp_typ=='U' ) {
					// obtengo los campos del objeto
					$lv_colsrcobj = array();
					foreach ( $lv_colsrc as $lv_row ) {
						if ($lv_row['id']==$lp_id) { $lv_colsrcobj[] = $lv_row; }
					}
					// ordeno las columnas por colorder
					usort($lv_colsrcobj, array("syscmpController", "array_sort_colorder") );	
					// preparo las columnas a agregar
					$lv_count=1;
					foreach ( $lv_colsrcobj as $lv_row ) {
						$lv_buffer .= '['.$lv_row['name'].'] ' . 
													$this->getFieldType( $lv_row['xtype'], $lv_row['xtypename'], $lv_row['length'], $lv_row['prec'], $lv_row['scale'], $lv_row['colstat'] )
													. ' ' . ($lv_row['isnullable']==0?'NOT ':'') . 'NULL'
													. ($lv_count<count($lv_colsrcobj)?',':'');
						$lv_count++;
					}

				// CLAVE PRIMARIA / INDICES
				} else if ( $lp_typ=='PK' || $lp_typ=='IX' ) {
					// obtengo los campos del objeto
					$lv_colsrcobj = array();
					foreach ( $lv_inxcolsrc as $lv_row ) {
						if ($lv_row['id']==$lp_id && $lv_row['objnme']==$lp_nme2) { $lv_colsrcobj[] = $lv_row; }
					}
					// ordeno las columnas por colorder
					usort($lv_colsrcobj, array("syscmpController", "array_sort_column_id") );	
					// preparo las columnas a agregar
					$lv_count=1;
					foreach ( $lv_colsrcobj as $lv_row ) {
						$lv_buffer .= $lv_row['name'] 
													. ($lv_count<count($lv_colsrcobj)?',':'');
						$lv_count++;
					}

				// STORED PROCEDURES - FUNCIONES
				} else if ( $lp_typ=='P' || $lp_typ=='FN' || $lp_typ=='TF' ) {
					// obtengo los campos del objeto
					$lv_cmtsrcobj = array();
					foreach ( $lv_cmtsrc as $lv_row ) {
						if ($lv_row['name']==$lp_nme) { $lv_cmtsrcobj[] = $lv_row; }
					}					
					// ordeno las columnas por colid
					usort($lv_cmtsrcobj, array("syscmpController", "array_sort_colid") );
					// preparo los textos a agregar
					foreach ( $lv_cmtsrcobj as $lv_row ) {
						$lv_row['text'] = str_ireplace('CREATE PROCEDURE [dbo].['.$lp_nme.']','</TemasisSentence/>',$lv_row['text']);
						$lv_row['text'] = str_ireplace('CREATE FUNCTION [dbo].['.$lp_nme.']','</TemasisSentence/>',$lv_row['text']);
						$lv_buffer .= $lv_row['text'];
					}
				}
								
				// envio la estructura
				$lo_rs = $this->lo_mdl->updateStructure( ($lp_way=='tosrc'?$lp_cnxsrc:$lp_cnxdst), $lp_typ, $lp_nme, $lv_buffer, $lp_nme2 );
				echo (isset($lo_rs[0]['errcod'])?'ErrCod: '.$lo_rs[0]['errcod'].'<br>':(isset($lo_rs[0]['ErrorNumber'])?'ErrorNumber: '.$lo_rs[0]['ErrorNumber'].'<br>':''))
						.(isset($lo_rs[0]['ErrorSeverity'])?'ErrorSeverity: '.$lo_rs[0]['ErrorSeverity'].'<br>':'')
						.(isset($lo_rs[0]['ErrorState'])?'ErrorState: '.$lo_rs[0]['ErrorState'].'<br>':'')
						.(isset($lo_rs[0]['ErrorProcedure'])?'ErrorProcedure: '.$lo_rs[0]['ErrorProcedure'].'<br>':'')
						.(isset($lo_rs[0]['ErrorLine'])?'ErrorLine: '.$lo_rs[0]['ErrorLine'].'<br>':'')
						.(isset($lo_rs[0]['errtxt'])?'ErrTxt: '.$lo_rs[0]['errtxt'].'<br>':(isset($lo_rs[0]['ErrorMessage'])?'ErrorMessage: '.$lo_rs[0]['ErrorMessage'].'<br>':''));
				break;
    }
	
  }

	private function ftpGetFileContent( $lp_cnx, $lp_fle, $lp_typ=FTP_ASCII ){
		$lv_txt = false;
		ob_start(); 
		if( ftp_get($lp_cnx, 'php://output', $lp_fle, $lp_typ) ){
			$lv_txt = ob_get_contents();
		}
		ob_end_clean();
		return $lv_txt;
	}

	private function ftpConnect(){
		// Set up a connection
		$lo_cnx = ftp_connect(self::FTPS);
		if( !$lo_cnx ){
			return array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al conectar al servidor ['.$lv_srv.']');
		}
		
		// Login
		if ( !ftp_login($lo_cnx, self::FTPU, self::FTPP) ) {
			ftp_close($lo_cnx);
			return array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Credenciales de usuario invalidas. ['.$lv_usr.']');
		}
		
		return $lo_cnx;
	}

	private function ftpClearRawList( $lp_arr ){
		foreach($lp_arr as &$lv_row){
			$lv_row = substr($lv_row,39,strlen($lv_row)-39-4);
		}
		unset($lv_row);
		return $lp_arr;
	}

	private static function array_sort_colorder($a, $b) {
    return ($a["colorder"]<$b["colorder"]?-1:1) ;
	}
	
	private static function array_sort_colid($a, $b) {
    return ($a["colid"]<$b["colid"]?-1:1) ;
	}
	
	private static function array_sort_column_id($a, $b) {
    return ($a["index_column_id"]<$b["index_column_id"]?-1:1) ;
	}
	
	private function getFieldType( $lp_type, $lp_typename, $lp_length, $lp_prec, $lp_scale, $lp_stat ) {
		$lv_type = '';
		switch( $lp_type ) {
			case 231: case 175: 
				$lv_type = '['.$lp_typename.']('.($lp_prec<0?'max':$lp_prec).')';
				break;
			case 56:
				$lv_type = '[int]';	
				if ( $lp_stat=='1' ) { $lv_type .= ' IDENTITY(1,1)'; }
				break;
			case 35: case 58: case 61: case 36: case 127: 
				$lv_type = '['.$lp_typename.']';
				break;
			case 106:
				$lv_type = '['.$lp_typename.']('.$lp_prec.', '.$lp_scale.')';
				break;
			default:
				$lv_type = ' [DESCONOCIDO '.$lp_type.']';
				break;
		}
		return $lv_type;
	}
}
?>