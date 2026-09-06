<?php
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//
//	 I N T E R F A C E S    -    T A R E A S    P R O G R A M A D A S
//
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
final class zcutp1_cmdController extends tmssController {
  
  protected $co_reg;
  private $data = array();
  
   
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
	
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {
	
    // all methods of this class are for logged users
    // check user session
    //$this->co_reg->request->post['ajax']='1';
    //$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    //if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

    // acciones
    switch( $lp_act ) {
			
			
			// ----------------------------------------------------------------------
			//
			//   STOCK BAJO MINIMO - NOTIFICACION AUTOMATICA
			//
			// ----------------------------------------------------------------------
      case 'C1':
				$lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';
				
				// obtengo todos los stocks bajo mínimo
				$lo_stkmatstkmdl = $this->co_reg->load->model('stkmatstk');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        //,'vewfldord'=>'m.mattxt'
												);
				$lo_rs = $lo_stkmatstkmdl->underMinimum( $lv_prm );
        $lv_data_sqlstm = $lo_stkmatstkmdl->getsysdata('sqlstm');
        //echo '<code>'.($lv_data_sqlstm).'</code>';
				//unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if ( count($lo_rs)==0 ) { echo 'No existen stocks bajo mínimo.'; return; }
				
				// obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATSTKMINNTF'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_STK'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_msgrs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_msgrs['data_sqlprm']); unset($lo_msgrs['data_sqltxt']); unset($lo_msgrs['data_sqlstm']);
				if( count($lo_msgrs)!=0 ) {
					$lv_usrmsg = $lo_msgrs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}

				// recorro todos los stocks bajo punto mínimo
				$lv_usrmsgrow = '';
				for($i=0; $i<count($lo_rs); $i++) {
					$lv_usrmsgrow .= '<tr>'.
															'<td>'.$lo_rs[$i]['stkobjtyp'].'</td>'.
															'<td>'.$lo_rs[$i]['stkobjtxt'].'</td>'.
															'<td>'.$lo_rs[$i]['cnttxt'].'</td>'.
															'<td>'.$lo_rs[$i]['matcod'].'</td>'.
															'<td>'.$lo_rs[$i]['matcodext'].'</td>'.
															'<td>'.$lo_rs[$i]['mattxt'].'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatstk'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatlvlmin'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatlvlmax'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatptoped'],2).'</td>'.
														'</tr>';
				}
				
				// determino destinatarios
				$lv_mailto = array();
        //$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        //$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
				
				// envío mail
				if ( count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
					$lv_emlprm['subject'] = 'Logindoor - Stocks bajo minimo';
					$lv_usrmsgout = $lv_usrmsg;
					$lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%2]', 'Stocks Bajo Minimo', $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%3]', $lv_usrmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
					$lv_emlprm['bodyhtml'] = $lv_usrmsgout;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
					}
				}
				
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
			
			
			// ----------------------------------------------------------------------
			//
			//   DOCUMENTACION VENCIDA - NOTIFICACION AUTOMATICA
			//
			// ----------------------------------------------------------------------
      case 'C2':
				$lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';

				// obtengo todos los clientes activos
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_cusrs = $lo_slscusmdl->getList( $lv_prm );
				//unset($lo_cusrs['data_sqltxt']); unset($lo_cusrs['data_sqlprm']); unset($lo_cusrs['data_sqlstm']);
				
				// obtengo todos los proveedores activos
				$lo_buysupmdl = $this->co_reg->load->model('buysup');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_suprs = $lo_buysupmdl->getList( $lv_prm );
				//unset($lo_suprs['data_sqltxt']); unset($lo_suprs['data_sqlprm']); unset($lo_suprs['data_sqlstm']);

				// obtengo la documentación vencida (-1 mes) y NO vencida (+1 mes)
				$lv_curdte = new DateTime(date('Y-m-d'));
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-1 month');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+1 month');
				
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'>='.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'<='.chr(9).chr(9). $lv_enddte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTHABDOC'.chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );
				//unset($lo_flers['data_sqltxt']); unset($lo_flers['data_sqlprm']); unset($lo_flers['data_sqlstm']);
				
				// obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'GRLFLEDUEDTENTF'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_FLE'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_msgrs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_msgrs['data_sqlprm']); unset($lo_msgrs['data_sqltxt']); unset($lo_msgrs['data_sqlstm']);
				if( count($lo_msgrs)!=0 ) {
					$lv_usrmsg = $lo_msgrs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}

				// recorro todos los clientes
				$lv_cusmsgrow = '';
				foreach($lo_cusrs as $lv_cusrow) {
					$lv_fnd = false;
					foreach($lo_flers as $lv_flerow) {
						if ( $lv_flerow['flesrctyp']=='SLS_CUS' && $lv_flerow['flesrccod']==$lv_cusrow['cuscod'] ) {
							$lv_fnd = true;
							$lv_dtedif = date_diff( $lv_curdte, $lv_flerow['fleduedte'] );							
							if ( $lv_curdte > $lv_flerow['fleduedte'] ) { $lv_dif = -1; } else { $lv_dif = 1; }
							$lv_cusmsgrow .= '<tr>'.
																	'<td>'.$lv_cusrow['cuscod'].'</td>'.
																	'<td>'.$lv_cusrow['custxt'].'</td>'.
																	'<td>'.$lv_flerow['fleduedtecnv'].'</td>'.
																	'<td>'.($lv_dtedif->format('%d')*$lv_dif<0?'Vencida':'').'</td>'.
																	'<td>'.$lv_dtedif->format('%d')*$lv_dif.'</td>'.
																'</tr>';
						}
					}
					if ( $lv_fnd==false ) {
						$lv_cusmsgrow .= '<tr>'.
																'<td>'.$lv_cusrow['cuscod'].'</td>'.
																'<td>'.$lv_cusrow['custxt'].'</td>'.
																'<td>&nbsp;</td>'.
																'<td>No proporcionada</td>'.
																'<td>&nbsp;</td>'.
															'</tr>';
					}
				}

				// recorro todos los clientes
				$lv_supmsgrow = '';
				foreach($lo_suprs as $lv_suprow) {
					$lv_fnd = false;
					foreach($lo_flers as $lv_flerow) {
						if ( $lv_flerow['flesrctyp']=='BUY_SUP' && $lv_flerow['flesrccod']==$lv_suprow['supcod'] ) {
							$lv_fnd = true;
							$lv_dtedif = date_diff( $lv_curdte, $lv_flerow['fleduedte'] );							
							if ( $lv_curdte > $lv_flerow['fleduedte'] ) { $lv_dif = -1; } else { $lv_dif = 1; }
							$lv_supmsgrow .= '<tr>'.
																	'<td>'.$lv_suprow['supcod'].'</td>'.
																	'<td>'.$lv_suprow['suptxt'].'</td>'.
																	'<td>'.$lv_flerow['fleduedtecnv'].'</td>'.
																	'<td>'.($lv_dtedif->format('%d')*$lv_dif<0?'Vencida':'').'</td>'.
																	'<td>'.$lv_dtedif->format('%d')*$lv_dif.'</td>'.
																'</tr>';
						}
					}
					if ( $lv_fnd==false ) {
						$lv_supmsgrow .= '<tr>'.
																'<td>'.$lv_suprow['supcod'].'</td>'.
																'<td>'.$lv_suprow['suptxt'].'</td>'.
																'<td>&nbsp;</td>'.
																'<td>No proporcionada</td>'.
																'<td>&nbsp;</td>'.
															'</tr>';
					}
				}
				
				// determino destinatarios
				$lv_mailto = array();
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
				
				// envío mail
				if ( count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
					$lv_emlprm['subject'] = 'Logindoor - Habilitaciones a vencer/vencidas';
					$lv_usrmsgout = $lv_usrmsg;
					$lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%2]', 'Habilitaciones a vencer/vencidas', $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%3]', $lv_cusmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%4]', $lv_supmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
					$lv_emlprm['bodyhtml'] = $lv_usrmsgout;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
					}
				}
				
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
			
			
			
			// ----------------------------------------------------------------------
			//
			// ENVIO DE DATOS MAESTROS DE PACIENTES A MIDLEWARE DYNAMICS
			//
			// ----------------------------------------------------------------------
      case 'sendPacientesToDynamics':
      
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lo_sysint = $this->co_reg->load->model('sysint');
        $lo_hltpat = $this->co_reg->load->model('hltpat');

				// Obtener interfaz
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'PACIENTESTODYNAMICS'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
          $this->data['err'] = array('errcod'=>-1001,'errtxt'=>'No se encontro una interfaz con codigo externo [PacientesToDynamics].');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=>implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat ); 
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}

				// cargar interfaz y atributos
        if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
          $this->data['err'] = array('errcod'=>-1002,'errtxt'=>'No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt);
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }

				// establezco conexión con base de datos
				$lo_db = new tmssDatabase($this->co_reg);
				$lp_inx = 145;
				$lp_db = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_db'); //'Middleware'
				$lp_usr = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_usr'); //'CRM'
				$lp_pwd = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_pwd'); //'Arbol45'
				$lp_srv = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_srv'); //'tp-gp.cloudapp.net';
				if ( $lp_db=='' || $lp_usr=='' || $lp_pwd=='' || $lp_srv=='' ) {
					$this->data['err'] = array('errcod'=>-1003,'errtxt'=>'Uno o más parámetros de conexión no se han establecido.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;					
				} else {
					$lo_db->set_connection_info( $lp_inx, $lp_db, $lp_usr, $lp_pwd, $lp_srv );
					if ( $lo_db->open_database($lp_inx)==false ) {
						$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo abrir la conexión de base de datos en destino.');
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
							'applogtecinf'=> implode('-',$this->data['err']) );
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
						return false;					
					}
				}

        // Obtener el listado de pacientes cuya fechas de creación >= fecha de última ejecución
        $sysintlstrun = $lo_rs[0]['sysintlstrun']; 
        $lp_vewopt = array('vewfldflt' => '[~fltrow~]p.ctedte'.chr(9).'>='.chr(9).chr(9).date_format( ($sysintlstrun==''?'2000-01-01':$sysintlstrun),'yyyymmddHHnnss').chr(9).chr(9) );
				$lo_rs = $lo_hltpat->getList( $lp_vewopt );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']); unset($lo_rs['data_sqlprm']);				
        $lv_pat_qty = 0;
        $lv_pat_errqty = 0;
        $lv_pat_errtxt = '';
				foreach($lo_rs as $lv_row) {
					if($lo_hltpat->load( array('patcod'=>$lv_row['patcod']) )==false) {
						$lv_pat_errqty++;
						$lv_pat_errtxt.=($lv_pat_errqty==0?'':',').$lo_hltpat->patcod.'(load)';
					} else {
						$lp_sqlstr = 'INSERT INTO Pacientes (paci_Codigo, clie_Codigo, loca_Codigo, pato_Codigo, paci_Nombres, paci_Apellidos, paci_DNI, paci_Direccion1, paci_Ciudad, paci_Estado, paci_Pais, paci_Telefono, paci_Telefono2) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)';
						unset($lp_sqlprm);
						$lp_sqlprm[] = $lo_hltpat->patcod;
						$lp_sqlprm[] = $lo_hltpat->cuscod;
						$lp_sqlprm[] = $lo_hltpat->adr->lndtwncod;
						$lp_sqlprm[] = $lo_hltpat->patdiacod;
						$lp_sqlprm[] = $lo_hltpat->adr->adrfrtnme;
						$lp_sqlprm[] = $lo_hltpat->adr->adrlstnme;
						$lp_sqlprm[] = $lo_hltpat->tax->taxdocnum;
						$lp_sqlprm[] = $lo_hltpat->adr->adrstr;
						$lp_sqlprm[] = $lo_hltpat->adr->adrcty;
						$lp_sqlprm[] = $lo_hltpat->adr->adrtwn;
						$lp_sqlprm[] = $lo_hltpat->adr->lndcod;
						$lp_sqlprm[] = $lo_hltpat->adr->adrphn001;
						$lp_sqlprm[] = $lo_hltpat->adr->adrphn002;
						$lo_rs = $lo_db->sqlquery( $lp_sqlstr, $lp_sqlprm, $lp_inx );
						if( $lo_rs ) {
							$lv_pat_qty++;
							echo '<logtxt>Paciente '.$lo_hltpat->patcod.' transferido.</logtxt>';
						} else {
							$lv_pat_errqty++;
							$lv_pat_errtxt.=($lv_pat_errqty==0?'':',').$lo_hltpat->patcod.'(insert)';
						}
					}
				}

        // Registrar los datos de la última ejecución (sysintlstrunsts (E=Error, I=OK, W=Warning) y sysintlstrunlog)
        $lp_key = array('sysintcod'=>$lo_sysint->sysintcod,
												'sysintlstrunsts'=>($lv_pat_errqty>0?'E':'I'),
												'sysintlstrunlog'=>'Transferidos ['.$lv_pat_qty.'].'.chr(13).'NO Transferidos ['.$lv_pat_errtxt.'].'.chr(13).'IDs No Transferidos ['.$lv_pat_errtxt.']'
											); 
        if( $lo_sysint->setRunData($lp_key) == false ) {
					$this->data['err'] = array('errcod'=>-1005,'errtxt'=>'Error al ejecutar setRunData.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'Se produjo al menos un error al ejecutar sendPacientesToMSDynamics.', 'applogtecinf'=> implode(' | ',$this->data['err']), 'docsts'=>'E');
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }
          
        // Exito
        $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'sendPacientesToMSDynamics se jecuto correctamente.'.$lp_key['sysintlstrunlog'], 'applogtecinf'=>'', 'docsts'=>'A');
        $lo_logmdl->save( $lv_dat );  
				echo '<errcod>0</errcod><errtxt></errtxt><runlog>'.$lp_key['sysintlstrunlog'].'</runlog>';
        return true;
				break;
			
			
			
			// ----------------------------------------------------------------------
			//
			//   O B T I E N E    C O T I Z A C I O N E S
			//
			// ----------------------------------------------------------------------
			case 'getCotizaciones':
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lv_errcod = 0;
				$lv_errtxt = '';
				
				// Obtener interfaz
				$lo_sysint = $this->co_reg->load->model('sysint');
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'GETCOTIZACIONES'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
					$lv_errcod = -1001;
					$lv_errtxt = ' No se encontro una interfaz con codigo externo [getCotizaciones]. ';
          //$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar getCotizaciones.', 
					//	'applogtecinf'=>implode('-',$this->data['err']) );
					//$lo_logmdl->save( $lv_dat ); 
					//echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					//return false;
					
				// cargar interfaz y atributos	
				} else if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
					$lv_errcod = -1002;
					$lv_errtxt = ' No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt.'. ';
        }
				
				// determino destinatarios de notificacion de errores
				if( $lv_errcod==0) {
					$lv_usrmsg = '';
					$lv_mailto = array();
					$lv_usrlst = explode(',',$this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_errntf'));
					foreach( $lv_usrlst as $lv_row ) {
						if ( $lv_row!='' ) {
							$lv_mailto[] = array('address'=>$lv_row);
						}
					}
				}
				if( count($lv_mailto)==0 ) {
					$lv_mailto[] = array('address'=>'soporte.temasis@temasis.com.ar');
				}
				
				// obtengo mensaje de notificacion
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'ITZERRNTF'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'SYS_INT'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm,array(),null,true);
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)!=0 ) {
					$lv_usrmsg = $lo_rs[0]['txttxt'];
				} else {
					$lv_errcod .= -1003;
					$lv_errtxt .= ' No se pudo cargar el texto de notificacion de errores [ITZERRNTF]. ';
				}
				
				// obtengo las clases de documento para tipo de cambio comprador y vendedor
				if($lv_errcod==0) {
					$lv_excrteclscpa = 0;
					$lv_excrteclsvta = 0;
					$lo_excrteclsmdl = $this->co_reg->load->model('finexcrtecls');
					$lv_prm = array();
					$lo_rs = $lo_excrteclsmdl->getList( $lv_prm );
					//unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
					foreach( $lo_rs as $lv_row ) {
						if(strtolower($lv_row['excrteclscodext'])=='cpa'){ $lv_excrteclscpa=$lv_row['excrteclscod'];}
						if(strtolower($lv_row['excrteclscodext'])=='vta'){ $lv_excrteclsvta=$lv_row['excrteclscod'];}
					}
					if ($lv_excrteclscpa==0 || $lv_excrteclsvta==0) {
						$lv_errcod .= -1004;
						$lv_errtxt .= 'No se pudo determinar las clases de tipo de cambio Comprador(cpa)/Vendedor(vta). ';
					}
				}
				
				// obtengo T/C
				if($lv_errcod==0) {
					$lv_excrteurl = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_url');
					$lv_curdte = new DateTime(date('Y-m-d'));
					$lv_excrteurl=$lv_excrteurl.'?id=billetes&fecha='.$lv_curdte->format('d/m/Y').'&filtroEuro=1&filtroDolar=1';				
					$lv_data = file_get_contents($lv_excrteurl);
					$doc = new DOMDocument();
					libxml_use_internal_errors(false);
					$doc->loadHTML(mb_convert_encoding($lv_data, 'HTML-ENTITIES', 'UTF-8'));
				}
				
				// determino fecha de cotizaciones
				if($lv_errcod==0) {
					$lo_fnd = new DomXPath($doc);
				}

				// obtengo cotizaciones
				if ($lv_errcod==0) {
					$lo_excrtearr = array();
					$lv_pos = -1;
					$lv_clsnme='table table-bordered cotizador';
					$lo_nodes_query = $lo_fnd->query("//*[contains(@class, '$lv_clsnme')]");
					foreach($lo_nodes_query as $lv_row_query) {
						$lo_nodes_tbody = $lo_fnd->query(".//tbody", $lv_row_query );
						foreach($lo_nodes_tbody as $lv_row_body) {
							$lo_nodes_tr = $lo_fnd->query(".//tr", $lv_row_body );
							foreach( $lo_nodes_tr as $lv_row ) {
								$lo_nodes_td = $lo_fnd->query(".//td", $lv_row );
								
								$lv_curcod = '';
								if($lo_nodes_td->item(0)->nodeValue=='Dolar U.S.A'){ $lv_curcod='USD'; }
								if($lo_nodes_td->item(0)->nodeValue=='Euro'){ $lv_curcod='EUR'; }
								
								$lo_excrtearr[] = array('excrteclscod'=>$lv_excrteclscpa, 'curcodsrc'=>'ARS', 'curcoddst'=>$lv_curcod, 
																				'excrtedtefrm'=>date_create_from_format('d/m/Y',$lo_nodes_td->item(3)->nodeValue)->format('d/m/Y'), 
																				'excrte'=>str_ireplace(',','.',$lo_nodes_td->item(1)->nodeValue), 
																				'excrtedstqty'=>'1', 'docsts'=>'A');
								
								$lo_excrtearr[] = array('excrteclscod'=>$lv_excrteclsvta, 'curcodsrc'=>'ARS', 'curcoddst'=>$lv_curcod, 
																				'excrtedtefrm'=>date_create_from_format('d/m/Y',$lo_nodes_td->item(3)->nodeValue)->format('d/m/Y'), 
																				'excrte'=>str_ireplace(',','.',$lo_nodes_td->item(2)->nodeValue), 
																				'excrtedstqty'=>'1', 'docsts'=>'A');
								
								//var_dump( 'cotiz: '.$lo_nodes_td->item(0)->nodeValue.' comprador '.$lo_nodes_td->item(1)->nodeValue.' vendedor '.$lo_nodes_td->item(2)->nodeValue.' fecha '.$lo_nodes_td->item(3)->nodeValue );
							}
						}
					}
				}
				
				// actualizo las cotizaciones en BD
				$lv_mincurcod_arr = array();
				if ($lv_errcod==0) {
					$lv_mincurcod_arr = explode(',',str_ireplace(' ','',$this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_mincurcod')));
					$lo_excrtemdl = $this->co_reg->load->model('finexcrte');
					foreach($lo_excrtearr as $lv_row) {
						if( $lo_excrtemdl->save( $lv_row )==false ) {
							$lv_errcod .= -1005;
							$lv_errtxt .= ($lv_errtxt!=''?' // ':'').' No se pudo actualizar la cotizacion '.$lv_row['curcoddst'].'. ';
						} else {
							unset($lv_mincurcod_arr[ array_search($lv_row['curcoddst'], $lv_mincurcod_arr) ]);
						}
					}
				}
				
				// verifico si las monedas mínimas establecidas fueron actualizadas
				if( count($lv_mincurcod_arr)>0 ) {
					$lv_errcod .= -1006;
					$lv_errtxt .= ' No se pudieron actualizar las cotizaciones de las siguientes monedas ['.implode(', ',$lv_mincurcod_arr).']. ';
				}
				
				
				// notifico errores
				if ($lv_errcod!=0 && $lv_usrmsg!='' && count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = 'ERROR: '. $this->co_reg->sec->bustxt.' - Interfaz getCotizaciones';
					$lv_usrmsg = str_ireplace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%2]', 'Interfaz getCotizaciones', $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%3]', 'Se produjo un error al ejecutar la interfaz.<br>errcod: '.$lv_errcod.'<br>errtxt: '.$lv_errtxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsg );
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm )==false ) {
						$lv_errcod .= -1008;
						$lv_errtxt .= ' Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'. ';							
					}
				}
				
				$lo_sysint->setRunData( array('sysintcod'=>$lo_sysint->sysintcod,	'sysintlstrunsts'=>($lv_errcod==0?'I':'E'),	'sysintlstrunlog'=>($lv_errcod==0?'Procesado OK.':$lv_errtxt)) );
				echo '<errcod>'.$lv_errcod.'</errcod><errtxt>'.$lv_errtxt.'</errtxt>';
				return ($lv_errcod==0?true:false);

				break;
			
			
			
			
			
			// ----------------------------------------------------------------------
			//
			//    I N H A B I L I T A R    M A T E R I A L E S
			//    ( costo desactualizado )
			//
			// ----------------------------------------------------------------------
			case 'C6':
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lo_sysint = $this->co_reg->load->model('sysint');
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lo_cstmdl = $this->co_reg->load->model('stkmatcst');
				$lo_matmdl = $this->co_reg->load->model('stkmat');
				$lv_errcod = 0;
				$lv_errtxt = '';
				$lv_mailto = array();

				// Obtener interfaz
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'INHABILITA_MATERIAL'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
          $this->data['err'] = array('errcod'=>-1001,'errtxt'=>'No se encontro una interfaz con codigo externo [INHABILITA_MATERIAL].');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=>implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat ); 
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}

				// cargar interfaz y atributos
        if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
          $this->data['err'] = array('errcod'=>-1002,'errtxt'=>'No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt);
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }
				
				// busco texto de mail
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATCSTDUE'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_CST'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ) {
          $this->data['err'] = array('errcod'=>-1003,'errtxt'=>'No se pudo cargar texto para mensaje de email [STKMATCSTDUE]. errcod:-1003 / errtxt: No se pudo cargar texto para mensaje de email.');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				$lv_usrmsg = $lo_rs[0]['txttxt'];
				
				// busco parámetro de antiguedad
				$lv_days = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'lstupdqty'); // lstupdqty
				$lv_days = ($lv_days==''?0:strval($lv_days));
				if($lv_days<=0){
					$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo obtener días de vencimiento [lstupdqty]. errcod:-1004 / errtxt: No se pudo obtener dias de vencimiento.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				
				// busco parámetro de destinatarios
				$lv_dest = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'mailto'); // mailto
				$lv_dest_arr = explode(';',$lv_dest);
				for($i=0; $i<count($lv_dest_arr); $i++){
					if($lv_dest_arr[$i]!=''){ $lv_mailto[] = array('address'=>$lv_dest_arr[$i]); }
				}
				if(count($lv_mailto)<=0){
					$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo obtener destinatarios de mensajes [mailto]. errcod:-1005 / errtxt: No se pudo obtener destinatarios de mensajes.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				
				// busco materiales con costos desactualizados
				$lv_cstdte= new DateTime();
				$lv_cstdte->modify('-'.$lv_days.' day');	
				$lv_prm = array('vewfldflt' =>'[~fltrow~]isnull(mc.matcstlstupd,^1900-01-01^)'.chr(9).'<'.chr(9).chr(9).$lv_cstdte->format('Y-m-d').chr(9).chr(9).
																			'[~fltrow~]mc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'mc.matcstlstupd DESC');
				$lo_rs = $lo_cstmdl->getList($lv_prm);
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				
				// recorro lista y deshabilito materiales
				$lv_buffer = '';
				foreach($lo_rs as $lv_row){
					$lo_matmdl->load( array('matcod'=>$lv_row['matcod']) );
					$lv_dat = array();
					$lv_dat = $lo_matmdl->getData();
					$lv_dat['docsts'] = 'I';
					$lo_matmdl->save( $lv_dat );
					$lv_buffer .= '<tr><td>'.$lv_row['matcod'].'</td><td>'.$lv_row['mattxt'].'</td><td>'.$lv_row['stkmatcstlstupddte'].'</td></tr>';
				}
				
				// envío notificación
				if ( $lv_buffer!='' ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
					$lv_emlprm['subject'] = 'Logindoor - Inhabilitacion de Materiales';
					$lv_usrmsg = str_ireplace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%2]', $lv_buffer, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsg );
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'INHABILITA_MATERIAL se jecuto correctamente.', 'applogtecinf'=>'', 'docsts'=>'A');
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>0</errcod><errtxt></errtxt>';
						return true;
					} else {
						$this->data['err'] = array('errcod'=>-1005,'errtxt'=>'Se actualizaron materiales. No se pudo enviar notificacion. errcod:-1005 / errtxt: '.$lo_eml->getError());
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se actualizaron materiales. No se pudo enviar notificacion. ['.str_ireplace('</td>',' / ',str_ireplace('<td>',' - ',str_ireplace('</tr>','<br>',str_ireplace('<tr>','',$lv_buffer)))).']' , 
							'applogtecinf'=> implode('-',$this->data['err']) );
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
						return false;
					}
				}	else {
					// no se encontraron materiales desactualizados
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'INHABILITA_MATERIAL se jecuto correctamente. No se encontraron materiales desactualizados', 'applogtecinf'=>'', 'docsts'=>'A');
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>0</errcod><errtxt></errtxt>';
					return true;
				}
				break;
        
        /* M A I L   A U T O M A T I C O   L O T E   Y   V E N C I M I E N T O */
			case 'lngstkmatstklst':
      
        $lo_stkmdl = $this->co_reg->load->model('stkmatstk');
				/*Filtro los Materiales */
        $lv_flt='17,39,93,94,95,98,99,100,101,112,113,144,210,214,231,234,244,260,273,291,315,319,329,330,382,383,384,391,409,439,440,479,503,560,565,679,581,583,605,642,643,668,708,709,1881,2341';
        $lv_flt= str_replace(',', chr(10), $lv_flt);
  			
				$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_flt.chr(9).chr(9));
				$lo_rsmatstk= $lo_stkmdl->getlist($lv_prm);
				$lv_data_sqlstm = $lo_stkmdl->getsysdata('sqlstm');
        //echo '<code>'.($lv_data_sqlstm).'</code>';
        //$lv_buf ='<table >';
        //$lv_buf	='<tr>';
				//$lv_buf.='<th>Lugar</th>';        
        //$lv_buf.='<th>Material</th>';
        //$lv_buf.='<th>Descripcion</th>';
        //$lv_buf.='<th>Lote</th>';
        //$lv_buf.='<th>Vencimiento</th>';
        //$lv_buf.='<th>Serie</th>';
        //$lv_buf.='<th>Cantidad</th>';
        //$lv_buf.='</tr>';
        
        $lv_buf	='<tr>';
				$lv_buf.='<th>Submission Mth</th>';        
        $lv_buf.='<th>Product Code (CFN)</th>';
        $lv_buf.='<th>UOM</th>';
        $lv_buf.='<th>Quantity</th>';
        $lv_buf.='<th>Expiry date</th>';
        $lv_buf.='<th>Location</th>';
        $lv_buf.='<th>Status</th>';
        $lv_buf.='<th>Lot/Serial number (Optional)</th>';
        $lv_buf.='<th>NA1</th>';
        $lv_buf.='<th>NA2</th>';
        $lv_buf.='<th>Comments</th>';
        $lv_buf.='</tr>';
        
        foreach ($lo_rsmatstk as $lv_row){
          $lv_buf.='<tr>';
          //$lv_buf.='<td>'.$lv_row['stkobjtxt'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matcod'].'</td>';
          //$lv_buf.='<td>'.$lv_row['mattxt'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matbchcodext'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matbchduedtecnv'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matsercodext'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matqty'].'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td>'.$lv_row['matcodext'].'</td>';
          $lv_buf.='<td>EA</td>';
          $lv_buf.='<td>'.intval($lv_row['matqty']).'</td>';
          $lv_buf.='<td>'.$lv_row['matbchduedtecnv'].'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td>S</td>';
          $lv_buf.='<td>'.($lv_row['matsercodext']==''?$lv_row['matbchcodext']:$lv_row['matsercodext']).'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td></td>';
          $lv_buf.='</tr>';//
        }
        //$lv_buf .='</table>';
        //echo $lv_buf;
        //var_dump($lo_rsmatstk);
        // obtengo texto del mensaje
				$lv_usrmsg='';
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATSTKLST'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_MAT_STK'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm);
				//$lv_data_sqlstm= $lo_rs['data_sqlstm'];
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)!=0 ) {
					$lv_usrmsg = $lo_rs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        
				//// determino destinatarios
				//$lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
        /*$lv_env = $this->co_reg->config->get('environmet');
				if($lv_env=='dev'){
        */
				//if($lv_issisdev !== false){
        //$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        //$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
        $lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}

        
				// envío mail
				if ( $lv_usrmsg!='') {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = 'Reporte mensual de stock con lote y vencimiento ';
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_replace( '[%2]', $lv_buf , $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%4]', $this->co_reg->sec->usrtxt, $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%3]', utf8_decode($lo_post['crmcntsrctxt']), $lv_usrmsg);
					//$lo_post['crmcntrqs']=str_replace(chr(13),'<BR>',$lo_post['crmcntrqs']);
					//$lo_post['crmcntrqs']=$lo_post['crmcntrqs'].'<br><br><small>Interacci&oacute;n creada: '.$lv_now->format('d/m/Y').'</small>';
					//$lv_usrmsg = str_replace( '[%5]', utf8_decode($lo_post['crmcntrqs']), $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%6]', utf8_decode($lo_post['crmcntdte']), $lv_usrmsg);
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
						return '<errtyp>E</errtyp><errcod>'.$lv_errcod.'</errcod><errtxt>'.$lv_errtxt.'</errtxt>';
					}
				}
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
				
    }
  }
	  
}
?>