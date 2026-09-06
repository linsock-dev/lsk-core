<?php
final class syssecusrpwdController extends tmssController {
	const MODEL = 'syssecusr';
	const VIEW  = 'syssecusr';
	const ID = 'usrcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
    
  
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
  }
  
  
	
  // INDEX
	// método principal del controlador
  public function index( $lp_act , $lp_prm = array() ) {
	
    // operations 11 (password recovery), 12 (password recovery email send), 13 (password recovery confirmation & change), getPwdDirective (recovery of all password directives for an user) are for all users (logged and not logged)
    if ( $lp_act!='11' && $lp_act!='12' && $lp_act!='13' && $lp_act!='14' && $lp_act != 'getPwdDirectives' ) { 
      // check user session
			$this->co_reg->request->post['ajax']='1';
      $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
      if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
    }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) { 

      // password change - user
      case '#10':
        $lv_prm = array( 'lang' => $this->co_reg->language );
        return $this->co_reg->load->view('syssecusr_pwdchg' , $lv_prm );
        break;
				
      // password recovery - solicita ingreso de mail para cambiar contraseña
      case '#11':			
				echo $this->password_recovery( $this->co_reg->request->post );
        break;
 
      // password recovery - envio de mail de cambio de contraseña
      case '#12': 
        echo $this->password_recovery_email( $this->co_reg->request->post );
        break;

      // password recovery - solicta ingreso de nueva contraseña
      case '#13':
        return $this->password_recovery_confirmation( $lp_prm );
        break;

      // password recovery - graba nueva password
      case '#14':
        return $this->password_change( $lp_prm );
        break;
        
      // password change view - admin
      case '#15':
        $lo_post = $this->co_reg->request->post;
        $lo_post['recovery'] = true;
        $lo_post['admpwdchg'] = true;
        $lo_post['msgtxt'] = 'Ingrese la nueva contrase&ntilde;a.';
        
        return $this->co_reg->document->getView( 'syssecusr_pwdchg', array('data'=>$lo_post) );
        break; 
        
      // password change - admin
      case '#16':
        $lo_post = $this->co_reg->request->post;
        $lv_usrcod = $lo_post['usrcod'];
        $lv_usrpwd = $lo_post['usrpwd001'];
        $lo_usrmdl = $this->co_reg->load->model('syssecusr');
        $lv_prm = array( 'usrcod'=>$lv_usrcod, 'usrpwd'=>$lv_usrpwd);
        if ( $lo_usrmdl->changePassword( $lv_prm )==false ) {
        	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break; 
        
      case '#getPwdDirectives':
        //datos post
        $lo_post = $this->co_reg->request->post;
        //obtiene las directivas del usuario-----------------------------------------------------------------------------------
        
        //modelo de asignacion de grupos de directivas
        $lo_grpasgmdl = $this->co_reg->load->model("syssecdrtgrpasg");
      
        //llama a la accion 13 del modelo de tipos de directivas
        $lo_usrDrt = $lo_grpasgmdl->getUserDirectives( array(), array('usrcod'=>isset($lo_post['usrcod']) ? $lo_post['usrcod'] : $this->co_reg->sec->usrcod) );
        
        //arma un string con los id de las directivas del usuario
        $lv_drtStr = '';
        foreach( $lo_usrDrt as $lo_row ){ $lv_drtStr .= ( $lv_drtStr != '' ? '|' : '' ).$lo_row['syssecdrttypcod']; }
        
        //---------------------------------------------------------------------------------------------------------------------
        
        //obtiene los datos de las directivas del usuario y de las del sistema-------------------------------------------------
        
        //modelo de tipos de directivas
        $lo_typmdl = $this->co_reg->load->model('syssecdrttyp');
        
        //llama a la accion 10 del modelo de tipos de directivas
        // busca las directivas, dependencias y las directivas del sistema
        $lv_prm = array( 'vewfldflt' => '[~fltrow~]dt.syssecdrttypcodext'.chr(9).'SW'.chr(9).chr(9).'PWD'.chr(9).chr(9));
        $lo_drt = $lo_typmdl->getDirectives( $lv_prm, array( 'syssecdrttypatr' => $lv_drtStr ) );
        
        //---------------------------------------------------------------------------------------------------------------------
        
        //se sobre escriben los valores de las directivas por los valores del grupo--------------------------------------------
        foreach( $lo_usrDrt as $lo_row ){
          //recorre los datos de las directivas
          foreach( $lo_drt as &$lo_row2 ){
            if( $lo_row2['syssecdrttypcod'] == $lo_row['syssecdrttypcod']  ){
              //decide el valor más restrictivo entre los distintos valores de grupos y el valor por default para ver que valor se va usar para la directiva
              $lv_drtValTemp = explode( chr(10), html_entity_decode( $lo_row['syssecdrtgrptypdefval'] ) );
              foreach( $lv_drtValTemp as $lv_row3 ){
                if( $lo_row2['syssecdrttyptyp'] == 'string' ){
                  if( strtolower($lo_row2['syssecdrttypcodext']) != 'pwdstartwith' ){ 
                  	// valores del usuario + valor default de la directiva
                    $lo_row2['syssecdrttypdef'] = $lo_row2['syssecdrttypdef'].(strtolower($lo_row2['syssecdrttypcodext']) == 'pwdbannedwords' ? "|":"").$lv_row3; 
                  }else{
                    $lv_drtStartWith = ( isset($lo_row2['syssecdrttypdef'][0]) ?( strtolower($lo_row2['syssecdrttypdef'][0]) != 'w' ? ( strtolower($lo_row2['syssecdrttypdef'][0]) != 'n' ? 3 : 2 ) : 1 ): 1 );
                    $lv_usrStartWith = ( strtolower($lv_row3[0]) != 'w' ? ( strtolower($lv_row3[0]) != 'n' ? 3 : 2 ) : 1 );

                    $lo_row2['syssecdrttypdef'] = ( $lv_usrStartWith > $lv_drtStartWith ? $lv_row3[0] : $lo_row2['syssecdrttypdef'][0] );
                  }

                }else{ //numerico o s/n
                  $lo_row2['syssecdrttypdef'] = ( $lv_row3 >= $lo_row2['syssecdrttypdef'] ? $lv_row3 : $lo_row2['syssecdrttypdef'] );
                }
              }
              
              break;
            }
          }
          unset($lo_row2);
        }
        
        //---------------------------------------------------------------------------------------------------------------------

        return $this->co_reg->document->getJson( $lo_drt );
        break;
    }
  }
  
	
  
  // PASSWORD_RECOVERY
	// muestra el formulario que solicita el ingreso de email para recuperar la contraseña
  private function password_recovery( $lp_prm=array() ) {
		$lp_prm['sec'] = $this->co_reg->sec;
		$lp_prm['lang'] = $this->co_reg->language;
		$lv_buffer  = $this->co_reg->load->view('sysdochdr2', $lp_prm);
		$lv_buffer .= $this->co_reg->load->view('syssecusrpwdrec', $lp_prm);
		$lv_buffer .= $this->co_reg->load->view('sysdocftr2', $lp_prm);
    return $lv_buffer;
  }
	
	
	
  // PASSWORD_RECOVERY_EMAIL (ACC 12)
	// método por el cual se envía el mail al usuario para el reestablecimiento de la contraseña
  private function password_recovery_email( $lp_prm=array() ) {		
		$lv_msg = array();
		$lv_usreml = $lp_prm['usreml'];
		$lv_bseurl = $lp_prm['bseurl'];
		$lv_bsecnx = $lp_prm['bsecnx'];
		$lv_sysenv = $lp_prm['sysenv'];
		$this->co_reg->sec->bsecnx = $lp_prm['bsecnx'];
		$this->co_reg->sec->usrcod = 'TEMASIS_WEB';
		$this->co_reg->sec->buscod = 'TEMASIS';
		$lv_usrcod = '';
		$lv_usrtxt = '';
		$lv_usrtkn = '';
		$lv_usrmsg = '';
		
		// verifico si el email está registrado en el sistema
		$lv_prm = array('vewmaxrec' =>'1',
										'vewfldflt' =>'[~fltrow~]a.adreml'.chr(9).'='.chr(9).chr(9).$lv_usreml.chr(9).chr(9)
									);
		$lo_usrmdl = $this->co_reg->load->model('syssecusr');
		$lo_rs = $lo_usrmdl->getList( $lv_prm );
		if ( count($lo_rs)==0 ) {
			$lv_msg['msgttl'] = 'Direcci&oacute;n inv&aacute;lida';
			$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> La direcci&oacute;n de correo electr&oacute;nico [<strong>'.$lv_usreml.'</strong>] no corresponde a ning&uacute;n usuario registrado en el sistema.';
		} else {
			$lv_usrcod = $lo_rs[0]['usrcod'];
			$lv_usrtxt = $lo_rs[0]['usrtxt'];
		}
		
		// genero token
		$lo_tknmdl = $this->co_reg->load->model('syssecusrtkn');
		if ( $lv_usrcod!='' ) {
			$lv_prm = array('usrcod'=>$lv_usrcod, 'tknkey'=>'<tkntyp>password_recovery</tkntyp>' );
			if ( $lo_tknmdl->create($lv_prm)==false ) {
				$lv_msg['msgttl'] = 'Error al obtener el token';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> Se produjo un error al obtener el token.<br><br>'.$lo_tknmdl->errcod.': '.$lo_tknmdl->errtxt.'<br><br>Consulte con el administrador del sistema.';
			} else {
				$lv_usrtkn = $lo_tknmdl->acctkn;
			}
		}
		
		// obtengo texto del mensaje
		if ( $lv_usrcod!='' and $lv_usrtkn!='' ) {
			$lo_txtmdl = $this->co_reg->load->model('grldattxt');
      $lv_usrmsg = $lo_txtmdl->load(array('txtcodext' => 'PWDRECMSG', 'txtsys' => 0), false) ? $lo_txtmdl->txttxt : '';
		}
		
		// envío mensaje
		if ( $lv_usrcod!='' && $lv_usrtkn!='' ) {
			$lo_eml = new tmssMail();
			$lv_emlprm['to'] = array( array('address'=>$lv_usreml) );
			$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis') );
			$lv_emlprm['subject'] = utf8_decode('Cambiar contraseña');
			if ( $lv_usrmsg!='' ) {
				$lv_link = 'https://'.$_SERVER['SERVER_NAME'].'/?prg=syssecusrpwd&act=13&prm_usrcod='.$lv_usrcod.'&prm_data=';
				$lv_link .= str_ireplace('+','_',$this->co_reg->sec->encrypt( '<sectkn>'.$lv_usrtkn.'</sectkn><bsecnx>'.$lv_bsecnx.'</bsecnx><bseurl>'.$lv_bseurl.'</bseurl>',$lv_usrcod));
				$lv_usrmsg = str_replace( '[%1]', $lv_usrtxt, $lv_usrmsg );
				$lv_usrmsg = str_replace( '[%2]', $lv_link, $lv_usrmsg );
				$lv_emlprm['bodyhtml'] = $lv_usrmsg;
			} else {
				$lv_emlprm['bodyhtml'] = 'no encontro el texto';
			}
			if ( $lo_eml->send( $lv_emlprm ) ) {
				$lv_msg['msgttl'] = 'Cambiar contrase&ntilde;a';
				$lv_msg['msgtxt'] = 'Se ha enviado un email a su casilla de correo.<br>Por favor, siga las instrucciones.';
			} else {
				$lv_msg['msgttl'] = 'Error al enviar mail';
				$lv_msg['msgtxt'] = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
			}
		}
		$lv_msg['msgbtn'] = array( array('action'=>'document.location.href='.chr(39).$lv_bseurl.chr(39).';', 'text'=>'Cerrar') );
		$lv_buffer = $this->co_reg->load->view('sysdochdr2', $lv_msg);
		$lv_buffer .= $this->co_reg->load->view('syserrmsg', $lv_msg);
		$lv_buffer .= $this->co_reg->load->view('sysdocftr2', $lv_msg);
		return $lv_buffer;
	}
  
	
	
	// PASSWORD_RECOVERY_CONFIRMATION (ACC 13)
	// formulario que recibe la confirmación y solicita el ingreso de la nueva contraseña
  private function password_recovery_confirmation( $lp_prm ) {
		$lv_msg = array();
		$lv_msg['msgtxt'] = '';
		$lv_usrcod = (isset($lp_prm['usrcod'])?$lp_prm['usrcod']:'');
		$lv_usrtkn = '';
		
		// valido que el parametro data exista (ERR: 1301)
		if ( (isset($lp_prm['data'])?$lp_prm['data']:'')=='' || $lv_usrcod=='' ) {
			$lv_msg['msgttl'] = 'Acceso inv&aacute;lido';
			$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong><br>El link que ha utilizado no es v&aacute;lido.<br>No se ha encontrado uno de los par&aacute;metros necesarios para el acceso. (Error: 1301)<br>Por favor, intentelo nuevamente o contactese con el administrador del sistema.';
		} else {
			// valido que se haya podido desencriptar el parámetro (ERR: 1302)
			$lv_sdat = $this->co_reg->sec->decrypt(str_ireplace('_','+',$lp_prm['data']), $lv_usrcod );
			if ( $lv_sdat=='' ) {
				$lv_msg['msgttl'] = 'Acceso inv&aacute;lido';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong><br>El link que ha utilizado no es v&aacute;lido.<br>No se ha podido obtener el parametro de acceso. (Error: 1302)<br>Por favor, intentelo nuevamente o contactese con el administrador del sistema.';
			}
			$lv_lnktkn = $this->co_reg->document->getTagValue($lv_sdat, 'sectkn');		
			$lv_bsecnx = $this->co_reg->document->getTagValue($lv_sdat, 'bsecnx');
			$lv_bseurl = $this->co_reg->document->getTagValue($lv_sdat, 'bseurl');
						
			// valido que todos los parámetrs estén completos (ERR: 1303)
			if ( $lv_lnktkn=='' || $lv_bsecnx=='' || $lv_bseurl=='' ) {
				$lv_msg['msgttl'] = 'Acceso inv&aacute;lido';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong><br>El link que ha utilizado no es v&aacute;lido.<br>No se pudieron obtener todos los par&aacute;metros requeridos. (Error: 1303)<br>Por favor, intentelo nuevamente o contactese con el administrador del sistema.';
			} else {
				$this->co_reg->sec->bsecnx = $lv_bsecnx;
			}
		}
		
		// obtengo el token de la base de datos
		// valido que se haya podido obtener el token (ERR: 1304 / 1305)
		$lo_tknmdl = $this->co_reg->load->model('syssecusrtkn');
		if ( $lv_msg['msgtxt']=='' ) {
			$lv_usrtkn = '';
			$lv_prm = array( 'usrcod'=>$lv_usrcod );
			if ( $lo_tknmdl->load($lv_prm)==false ) {
				$lv_msg['msgttl'] = 'Error al obtener el token';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> Se produjo un error al obtener el token.<br><br>'.$lo_tknmdl->errcod.': '.$lo_tknmdl->errtxt.'<br><br>Por favor, consulte con el administrador del sistema.';
			} else {
				$lv_usrtkn = $lo_tknmdl->acctkn;
			}
		}
		
		// valido token de base de datos vs. token de la URL (ERR: 1306)
		if ( strtolower($lv_lnktkn)!=strtolower($lv_usrtkn) && $lv_msg['msgtxt']=='' ) {
			$lv_msg['msgttl'] = 'Token inv&aacute;lido';
			$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong><br>Link que ha utilizado no es v&aacute;lido o ha expirado. (Error: 1306)<br>Intente recuperar la contrase&ntilde;a nuevamente.';
		}

		// muestro mensaje de error o la vista para modificar la contraseña
		if ( $lv_msg['msgtxt']!='' ) {
			$lv_msg['msgbtn'] = array( array('action'=>'document.location.href='.chr(39).$lv_bseurl.chr(39).';', 'text'=>'Cerrar') );
			$lv_buffer = $this->co_reg->load->view( 'sysdochdr2' , $lv_msg );
			$lv_buffer .= $this->co_reg->load->view( 'syserrmsg' , $lv_msg );
			$lv_buffer .= $this->co_reg->load->view( 'sysdocftr2' , $lv_msg );
			return $lv_buffer;
		} else {
			$lv_prm = array('lang'  => $this->co_reg->language,
											'input' => $this->co_reg->input,
											'sec' 	=> $this->co_reg->sec,
											'model' => self::MODEL,
											'data' => array('msgtxt' => 'Ingrese la nueva contrase&ntilde;a', 
																			'recovery' => true,
																			'usrcod' => $lv_usrcod,
																			'bsecnx' => $lv_bsecnx,
																			'bseurl' => $lv_bseurl,
																			'lnktkn' => $lv_lnktkn
																			)
											);
			$lv_buffer = $this->co_reg->load->view('sysdochdr2' , $lv_prm);
			$lv_buffer .= $this->co_reg->load->view('syssecusr_pwdchg' , $lv_prm);
			$lv_buffer .= $this->co_reg->load->view('sysdocftr2' , $lv_prm);
			return $lv_buffer;
		}
	}
	
	
	
	// PASSWORD_CHANGE (ACC 14)
	// formulario que recibe la confirmación y solicita el ingreso de la nueva contraseña
	private function password_change( $lp_prm ) {
		$lv_msg = array();
		$lv_msg['msgttl']='';
		$lv_msg['msgtxt']='';
		$lo_dat = $this->co_reg->request->post;
		$lv_usrcod = $lo_dat['usrcod'];
		$lv_bsecnx = $lo_dat['bsecnx'];
		$lv_bseurl = $lo_dat['bseurl'];
		$lv_lnktkn = $lo_dat['lnktkn'];
		$lv_usrpwd = $lo_dat['usrpwd001'];
		$lv_usratr003 = $lo_dat['usratr003'];
		$this->co_reg->sec->bsecnx = $lv_bsecnx;
		$this->co_reg->sec->usrcod = 'TEMASIS_WEB';
		
		// obtengo el token de la base de datos
		// valido que se haya podido obtener el token (ERR: 1401 / 1402)
		$lo_tknmdl = $this->co_reg->load->model('syssecusrtkn');
		if ( $lv_msg['msgtxt']=='' ) {
			$lv_usrtkn = '';
			$lv_prm = array( 'usrcod'=>$lv_usrcod );
			if ( $lo_tknmdl->load($lv_prm)==false ) {
				$lv_msg['msgttl'] = 'Error al obtener el token';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> Se produjo un error al obtener el token.<br><br>'.$lo_tknmdl->errcod.': '.$lo_tknmdl->errtxt.'<br><br>Por favor, consulte con el administrador del sistema.';
			} else {
				$lv_usrtkn = $lo_tknmdl->acctkn;
			}
		}
		
		// valido token de base de datos vs. token de la URL (ERR: 1403)
		if ( strtolower($lv_lnktkn)!=strtolower($lv_usrtkn) && $lv_msg['msgtxt']=='' ) {
			$lv_msg['msgttl'] = 'Token inv&aacute;lido';
			$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong><br>Link que ha utilizado no es v&aacute;lido o ha expirado. (Error: 1403)<br>Intente recuperar la contrase&ntilde;a nuevamente.';
		}
		
		// actualizo contraseña
		if ( $lv_msg['msgtxt']=='' ) {
			$lv_usrtkn = '';
			$lo_usrmdl = $this->co_reg->load->model('syssecusr');
			$lv_prm = array( 'usrcod'=>$lv_usrcod, 'usrpwd'=>$lv_usrpwd, 'usratr003'=> $lv_usratr003);
			if ( $lo_usrmdl->changePassword( $lv_prm )==false ) {
				$lv_msg['msgttl'] = 'Error al actualizar contrase&ntilde;a';
				$lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> Se produjo un error al actualizar la contrase&ntilde;a. (Error: 1405)<br><br>'.$lo_usrmdl->errcod.': '.$lo_usrmdl->errtxt.'<br><br>Por favor, consulte con el administrador del sistema.';
			} else {
				// se modificó la contraseña
			}
		}
		
		if ($lv_msg['msgttl']=='') { $lv_msg['msgttl']='Actualizar contrase&ntilde;a'; }
		if ($lv_msg['msgtxt']=='') { $lv_msg['msgtxt']='La contrase&ntilde;a ha sido actualizada con &eacute;xito'; }
		$lv_msg['msgbtn'] = array( array('action'=>'document.location.href='.chr(39).$lv_bseurl.chr(39).';', 'text'=>'Cerrar') );
		$lv_buffer = $this->co_reg->load->view('sysdochdr2', $lv_msg);
		$lv_buffer .= $this->co_reg->load->view('syserrmsg', $lv_msg);
		$lv_buffer .= $this->co_reg->load->view('sysdocftr2', $lv_msg);
		return $lv_buffer;
	}

}
?>