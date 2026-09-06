<?php
final class syssecusrController extends tmssController {
	const MODEL = 'syssecusr';			
	const VIEW  = 'syssecusr';					
	const ID = 'usrcod';					
  const OBJTYP = 'SYS_USR';
  const LOGIN_TIMEOUT = 1800; // ( 30min * 60sec )
  protected $co_reg;
	protected $lo_mdl;
  private $data = array();
  
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
  
  
  // MAIN METHOD 
  public function index( $lp_act , $lp_prm = array() ) {

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
	
    // operations 98 and 99 are for all users (logged and not logged)
    if ( $lp_act!='98' && $lp_act!='99' && $lp_act!='timeout') { 
      // check user session
			$this->co_reg->request->post['ajax']='1';
      $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
      if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
    }

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
      // ***********************************************************************
      //
      // U S E R
      //
      // ***********************************************************************
			
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// CORREO DUPLICADO. se valida que no exista otro usuario con la misma dirección de correo electronica
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'SYS_USR'.chr(9).chr(9).
																			'[~fltrow~]a.adrsrccod'.chr(9).'<>'.chr(9).chr(9).$lo_post['usrcod'].chr(9).chr(9).
																			'[~fltrow~]a.adreml'.chr(9).'='.chr(9).chr(9).$lo_post['adreml'].chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_adrmdl->getList($lv_prm);
				if( count($lo_rs)>0 ){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Ya existe un usuario con la misma direccion de correo electronico.') );
				}				
				
				if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	'usrcod'=>$this->lo_mdl->usrcod	) );	
					$this->data['actcod'] = ($lo_post['tmss_actcodacc']??$this->data['actcod']);
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array(); 
				
				// get param (KEY)										
        $lv_key = array( self::ID=> ($lp_prm[self::ID]??$this->co_reg->request->post[self::ID]) );
        
				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>'No se indico parametro ['.self::ID.']') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->usrcod = '';																										
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// UNLOCK
      case '#17':
        if ( $this->lo_mdl->unlock( array('usrcod'=>$this->co_reg->request->post['usrcod']) ) ) {
					$this->lo_mdl->load( array('usrcod'=>$this->co_reg->request->post['usrcod']) );									
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
     
      // GETLIST BY TEXT
      case '#18':
      $lv_prm = array('vewmaxrec' =>'10',
                      'vewfldflt' => (isset($lp_prm['usrtxt'])?'[~fltrow~]u.usrtxt'.chr(9).''.chr(9).$lp_prm['usrtxt'].chr(9).chr(9).chr(9):'').
                                    '[~fltrow~]u.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                      );
      $lo_rs = $this->lo_mdl->getList($lv_prm, null, null, false);
      return $this->co_reg->document->getJson( $lo_rs ); 

			
			// TIMEOUT
			case '#timeout':
				$lv_chk = $this->co_reg->sec->isLogged( true );
				$lv_ret = '';
				if($lv_chk==false){
					$lv_ret = '/*script*/tmssLogin("La sesión caducó. Por favor, ingrese la contraseña nuevamente.");';
				}
				return $lv_ret;
				break;
			
			
			
			// ***********************************************************************
      //
      // E M P R E S A S
      //
      // ***********************************************************************
			
			
			
      // change business
      case '16':
        // obtener parámetro para cambiar empresa (16) o para seleccionar inicialmente una (17)
				/*
				$lo_bus
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'data' 	=> $this->lo_mdl->bus,
												'actcod'=> $this->data['actcod'],
												'model' => self::MODEL,
												);
				*/
        return $this->co_reg->document->getView( 'syssecusrbus', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
      
      // my account
      case '#25':
				$this->lo_mdl->load( array('usrcod'=>$this->co_reg->sec->usrcod) );
        return $this->co_reg->document->getView( 'syssecusr', array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>'25') );
        break;
			
			
			// ENVIAR INFO
			case '#35':
				$lo_usrmdl = $this->co_reg->load->model('syssecusr');
				if ($lo_usrmdl->load( array('usrcod'=>$this->co_reg->request->post['usrcod']) )==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>'No se pudo obtener informacion del usuario') );
				} else {
					// obtengo texto del mensaje
					$lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_usrmsg = $lo_txtmdl->load(array('txtcodext' => 'USRACCINF', 'txtsys' => 0), false) ? $lo_txtmdl->txttxt : '';
					
					// envío mensaje
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = array( array('address'=>$lo_usrmdl->adreml) );
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.ar', 'name'=>'Temasis') );
					$lv_emlprm['subject'] = 'Datos de Acceso';
					if ( $lv_usrmsg!='' ) {
						$lv_link = $this->co_reg->sec->bseurl;
						$lv_bustxt = $this->co_reg->sec->bustxt;
						$lv_usrmsg = str_replace('[%1]', $lo_usrmdl->usrtxt, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%2]', $lv_link, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%3]', $lv_bustxt, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%4]', $lo_usrmdl->usrcod, $lv_usrmsg );
						$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					} else {
						$lv_emlprm['bodyhtml'] = 'no encontro el texto';
					}
					$lo_eml->send( $lv_emlprm ) ;
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$lo_eml->getError()) );
				}
				break;
			
			
      // user - business selector
      case '#97': 
        return $this->setUserBusiness();
        break;
      
			
      // user - login
      case '#98':
				$this->co_reg->sec->usrcod='';
				$this->co_reg->sec->buscod='';
				$this->co_reg->sec->bsecnx='';
        if( ($this->co_reg->request->post['buscod']??'')!='' ){
        	return $this->checkUserLogin('', true);
        }else{
        	return $this->checkUserLogin();
        }
        break;
			
			
      // user logout
      case '#99': 
				$lv_bseurl = ($this->co_reg->sec->bseurl=='' ? '' : $this->co_reg->sec->bseurl );
        if ($this->userLogout()) {
					$this->co_reg->response->addHeader('HTTP/1.1 301 Moved Permanently');
          if(isset($this->co_reg->request->get['bseurl'])){
        		$lv_bseurl = $this->co_reg->request->get['bseurl'];
          } else {
						$lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($lv_bseurl)));
						$lv_bseurl = '/'.$lv_path[1].'/'.$lv_path[2].'/'.$lv_path[3].'/'.$lv_path[4];
					}
					$this->co_reg->response->redirect( $lv_bseurl );
					exit();
        } else {
          // no debería haber errores
          // no se controla
        }
        break;
    }
  }



  // checkUserLogin. Valida las credenciales de usuario (login)
  public function checkUserLogin($lv_api='', $lv_rest=false) {
		$lo_post = $this->co_reg->request->post;
    
		// ISLOGGED. verifico si el usuario ya está logueado
		if($lv_api==''){
			if ( $this->co_reg->sec->isLogged() ) {
				//if($lv_api!=''){
				//	return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'0','errtxt'=>'') );
				//} else {
					return '';
				//}
			}
		}
    
		// SSL. verifico si la conexión SSL es válida
		if ( $this->co_reg->sec->is_ssl() == false ) {
      if($lv_api != ''){
        return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'La conexión que intenta utilizar para acceder al sitio de gestión no es una conexión SSL válida.') );
      }else{
        $lv_prm['msgttl'] = 'Conexión Inválida.';
        $lv_prm['msgtxt'] = 'La conexión que intenta utilizar para acceder al sitio de gestión no es una conexión SSL válida.';
        $lv_prm['msgbtn'] = array( array('text' => 'Cerrar', 'action' => 'document.location.href='.chr(39).'?prg=syssecusr&act=99'.chr(39)) );
        $lv_prm['sec'] = $this->co_reg->sec;
        $lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
                      $this->co_reg->load->view('syserrmsg', $lv_prm) .
                      $this->co_reg->load->view('sysdocftr2', $lv_prm);
        return $lv_buffer;
      }
		}
		
    // obtengo los indicadores de AJAX (son todas las llamadas del sistema excepto por el login inicial)
		// -- flag de llamada AJAX (no muestro vista, ejecuto script para mostrar popup de re login)
    $lv_ajx    = ($lo_post['ajax']??'');
		// -- indicador que dice que es el intento de re login desde el popup de timeout
    $lv_ajxlgn = ($lo_post['ajax_login']??'');
    // si es AJAX y NO viene del popup de re login entonces abro el popup para que ingrese la contraseña
    if ( $lv_ajx!='' && $lv_ajxlgn=='' ) {
			$lv_buffer = '/*script*/tmssLogin("La sesión caducó. Por favor, ingrese la contraseña nuevamente.");';        
      return $lv_buffer;
    }

    // USUARIO. no se fijo el usuario previamente
    if ($this->co_reg->sec->usrcod=='') {
			
			// intento hacer el login
			$lo_drt = $this->getUserDirectives($lo_post['usrcod']??'');
			$lv_lgn = $this->userLogin($lo_drt, $lv_api);
      
			// no se pudo loquear
      if ( $lv_lgn!=0 ) {
				// llamada ajax (session timeout)
        if ( $lv_ajx!='' ) {
          if ( $lv_lgn==-1 ) {
            if($lv_api != ''){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-2','errtxt'=>'Usuario/contrase&ntilde;a inv&aacute;lida. Intente nuevamente.') );
            }else{
	            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>'Usuario/contrase&ntilde;a inv&aacute;lida. Intente nuevamente.') );
            }
          } else if ( $lv_lgn==-2 ) {
            if($lv_api != ''){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Usuario bloqueado. Consulte con el administrador del sistema.') );
            }else{
            	return '/*script*/alert("Usuario bloqueado. Consulte con el administrador del sistema"); document.location.href="'.$this->co_reg->sec->bseurl.'?lgnmsg='.$lv_lgn.'";';
            }
          } else {
            if($lv_api != ''){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Error de login ['.$lv_lgn.']. Consulte con el administrador del sistema.') );
            }else{
            	return '/*script*/alert("Error de login ['.$lv_lgn.']. Consulte con el administrador del sistema"); document.location.href="'.$this->co_reg->sec->bseurl.'?lgnmsg='.$lv_lgn.'";';
            }
          }
				// llamada no ajax (login principal o timeout?)
        } else {
          if($lv_api != ''){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Acceso inv&aacute;lido.') );
          }else{
            $lv_prm['msgttl'] = 'Acceso inv&aacute;lido.'; 
            $lv_prm['msgtxt'] = '<center><h2><i class="fas fa-user-times"></i></h2><h3>'.utf8_encode($this->errtxt).'</h3><small>err'.$this->errcod.'</small></center>';
            $lv_prm['msgbtn'] = array( array('text' => 'Ok', 'action' => 'document.location.href='.chr(39).$this->co_reg->sec->bseurl.chr(39).';') );
            $lv_prm['sec'] = $this->co_reg->sec;
            $lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
                          $this->co_reg->load->view('syserrmsg', $lv_prm) .
                          $this->co_reg->load->view('sysdocftr2', $lv_prm);
            echo $lv_buffer;
            exit();
          }
				}
      } else {
        // user & password ==> ok
      	$lv_usrpwdchg = false;
        $lv_msgtxt = '';
        
        // valida directivas post-login
				foreach( $lo_drt as $lv_row ) {
					switch (strtolower($lv_row['syssecdrttypcodext'])) {
						case 'lgnpwdvaliddays':
							if(intval($lv_row['syssecdrttypdef']) < $this->data['pwddays'] ){
                $lv_usrpwdchg = true;
                $lv_msgtxt = 'Su contrase&ntilde;a ha caducado. Ingrese una nueva contrase&ntilde;a.';
              }
							break;
					}
				}
        
        // valida cambio de contraseña habilitado
        if($this->data['usrpwdchg'] == '1'){
          $lv_usrpwdchg = true;
          $lv_msgtxt = 'El administrador del sistema actualizó su contrase&ntilde;a. Por favor, ingrese una nueva contrase&ntilde;a.';
        }
        
        if($lv_usrpwdchg){
          // genero token
          $lo_tknmdl = $this->co_reg->load->model('syssecusrtkn');
          if ( $this->co_reg->sec->usrcod !='' ) {
            $lv_prm = array('usrcod'=>$this->co_reg->sec->usrcod, 'tknkey'=>'<tkntyp>password_recovery</tkntyp>' );
            if ( $lo_tknmdl->create($lv_prm) == false) {
              if($lv_api != ''){
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Se produjo un error al obtener el token de usuario.','errvar'=>array('errcod'=>$lo_tknmdl->errcod,'errtxt'=>$lo_tknmdl->errtxt) ) );
              }else{
                $lv_msg['msgttl'] = 'Error al obtener el token';
                $lv_msg['msgtxt'] = '<strong>Atenci&oacute;n: </strong> Se produjo un error al obtener el token.<br><br>'.$lo_tknmdl->errcod.': '.$lo_tknmdl->errtxt.'<br><br>Consulte con el administrador del sistema.';
                $lv_msg['msgbtn'] = array( array('text' => 'Cerrar', 'action' => 'document.location.href='.chr(39).$this->co_reg->sec->bseurl.chr(39).';') );
                $lv_msg['sec'] = $this->co_reg->sec;
                $lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_msg) .
                              $this->co_reg->load->view('syserrmsg', $lv_msg) .
                              $this->co_reg->load->view('sysdocftr2', $lv_msg);
                echo $lv_buffer;
                exit();
              }
            } else {
              $lv_usrtkn = $lo_tknmdl->acctkn;
            }
          }

          // muestro pantalla para cambiar la contraseña
          if($lv_api != ''){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>$lv_msgtxt) );
          }else{
            $lv_pwdchg = array('sec' => $this->co_reg->sec,
                              'lang' => $this->co_reg->language,
                              'data' => array('msgtxt' => $lv_msgtxt, 
                                              'recovery' => true,
                                              'usrcod' => $this->co_reg->sec->usrcod,
                                              'bsecnx' => $this->co_reg->sec->bsecnx,
                                              'bseurl' => $this->co_reg->sec->bseurl,
                                              'lnktkn' => $lv_usrtkn
                                             )
                            );
            $lv_buffer = $this->co_reg->load->view('sysdochdr2', $lv_pwdchg) .
                        $this->co_reg->load->view('syssecusr_pwdchg' , $lv_pwdchg ) .
                        $this->co_reg->load->view('sysdocftr2', $lv_pwdchg);
            echo $lv_buffer;
            exit();
          }
        }
      }
    }
		
    // login externo - verifico si se debe determinar/seleccionar la empresa
    if ($this->co_reg->sec->buscod=='') {
      $lv_buffer = $this->setUserBusiness($lv_api);
			if($lv_api!=''){
				$lv_ret = json_decode($lv_buffer,true);
        return $this->co_reg->document->getJson( array('errtyp'=>$lv_ret['errtyp'],'errcod'=>$lv_ret['errcod'],'errtxt'=>$lv_ret['errtxt']) );
			} else if ( $lv_buffer!='' ) { 
				return $lv_buffer;
			} 
    }
		
    // verifico si el token es válido
    $lv_tkn = $this->co_reg->sec->getToken();
    if ( $lv_tkn=='' ) {
			if ( $lv_ajx!='' ) {
				//$this->co_reg->response->redirect( ($this->co_reg->sec->bseurl==''?'':) '?token='.$lv_tkn );
				echo '****** no se pudo obtener el token . regresar a login o pagina error ++++++++++++++++++';
				exit();  				
			} else {
				$lv_prm['msgttl'] = 'Error de Acceso';
				$lv_prm['msgtxt'] = 'No se pudo obtener el token de acceso.<br><br>['. $this->co_reg->sec->usrcod .'/'.$this->co_reg->sec->usrtxt.'/'.$this->co_reg->sec->buscod.'/'.$this->co_reg->sec->bustxt.'/'.$this->co_reg->sec->bsecnx.']<br><br>Cont&aacute;ctese con el administrador del sistema.';
				$lv_prm['msgbtn'] = array( array('text' => 'Cerrar', 'action' => 'document.location.href='.chr(39).'?prg=syssecusr&act=99'.chr(39)) );
				$lv_prm['sec'] = $this->co_reg->sec;
				$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
											$this->co_reg->load->view('syserrmsg', $lv_prm) .
											$this->co_reg->load->view('sysdocftr2', $lv_prm);
				echo $lv_buffer;				
				exit();
			}
    }

    // redirect
    if ( $lv_ajx!='' ) {
      return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>'Acceso válido.') );
    } else {
      if(!$lv_rest){
      	$this->co_reg->response->redirect( '?token='.$lv_tkn );
      }else{
        $lv_bseurl = $this->co_reg->request->post['bseurl'];
        $lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($lv_bseurl)));
        
        if(!isset($lv_path[5]) || substr($lv_path[5],0,5) != 'user=' ){
          $lv_usrcod = $this->co_reg->sec->usrcod;
          $lv_res = ($lv_path[5]??'');
          $lv_doccod = ($lv_path[6]??'');
          $lv_bseurl = '/'.$lv_path[1].'/'.$lv_path[2].'/'.$lv_path[3].'/'.$lv_path[4].'/user='.$lv_usrcod.($lv_res != '' ? '/'.$lv_res : '').($lv_doccod != '' ? '/'.$lv_doccod : '');
        }
        $this->co_reg->response->redirect( $lv_bseurl );
      }
      exit();  
    }
  }
  
	
  
  // setUserBusiness. devuelve o establece la empresa que se utilizara
  private function setUserBusiness($lv_api='') {
    $lo_post = $this->co_reg->request->post;
		
    // initialize session values
    $this->co_reg->sec->buscod = '';
    $this->co_reg->sec->bustxt = '';
    $lv_buscod = '';
		$lv_bustxt = '';
		$lv_usrtrmacp = '';
		
    // obtengo la lista de empresas asignadas al usuario
		$lo_usrbus_mdl = $this->co_reg->load->model('syssecusrbus');
		$lo_usrbus_rs = $lo_usrbus_mdl->getList(null, array('usrcod'=>$this->co_reg->sec->usrcod) );
		$this->co_bus = $lo_usrbus_rs;
		
    // 0 - ninguna empresa fue asignada al usuario
    if ( count($this->co_bus)==0 ) {
			if($lv_api != ''){
				return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'El usuario [<strong>'. $this->co_reg->sec->usrcod .'</strong>] no está asignado a ninguna empresa en el sistema y no puede realizar operaciones.<br>Contáctese con el administrador del sistema.') );
			}else{
				$lv_prm['msgttl'] = 'Usuario inhabilitado.';
				$lv_prm['msgtxt'] = 'El usuario [<strong>'. $this->co_reg->sec->usrcod .'</strong>] no está asignado a ninguna empresa en el sistema y no puede realizar operaciones.<br>Contáctese con el administrador del sistema.';
				$lv_prm['msgbtn'] = array( array('text' => 'Cerrar', 'action' => 'document.location.href='.chr(39).'?prg=syssecusr&act=99'.chr(39)) );
				$lv_prm['sec'] = $this->co_reg->sec;
				$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
											$this->co_reg->load->view('syserrmsg', $lv_prm) .
											$this->co_reg->load->view('sysdocftr2', $lv_prm);
				return $lv_buffer;
			}
		// 1 - solo una empresa (la asigno)
		} else if ( count($this->co_bus)==1 ) {
			foreach( $this->co_bus as $lv_row ) {
				$lv_buscod = $lv_row['buscod'];
				$lv_bustxt = $lv_row['bustxt'];
				$lv_usrtrmacp = $lv_row['usrtrmacp'];
			}
    
		// n - varias empresas (verifico si debo mostrar o ya se ha seleccionado alguna)
		} else {
      
      $lo_cfg_rs = $this->co_reg->config->get('customers');
      $lo_bus_rs = $this->co_bus;
      
      foreach($lo_bus_rs as &$lv_row){
        foreach($lo_cfg_rs as $lv_key => $lv_row_cfg){
          if($lv_row['buscod'] == $lv_row_cfg['buscod']){
            $lv_row['resturl'] = $lv_key;
          }
        }
      }
      unset($lv_row);

      $this->co_bus = $lo_bus_rs;
			
      // verifico si viene de la pantalla de selección de empresas
      if( ($lo_post['buscod']??'')!='' ) {
        
				// la empresa seleccionada está en la lista de las disponibles del usuario?
				foreach($this->co_bus as $lv_row) {
					if($lv_row['buscod']==$this->co_reg->request->post['buscod']) {
						$lv_buscod = $lv_row['buscod'];
						$lv_bustxt = $lv_row['bustxt'];
						$lv_usrtrmacp = $lv_row['usrtrmacp'];
					}
				}
        if ( $lv_buscod=='' ) {
					if($lv_api!=''){
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'La empresa a la que desea acceder <strong>'.$this->co_reg->request->post['buscod'].'</strong> no está asignada al usuario <strong>'.$this->co_reg->sec->usrcod.'</strong> y no puede realizar operaciones.<br>Contáctese con el administrador del sistema.') );					
					}else{
						$lv_prm['msgttl'] = 'Error de selección.'; 
						$lv_prm['msgtxt'] = 'La empresa a la que desea acceder <strong>'.$this->co_reg->request->post['buscod'].'</strong> no está asignada al usuario <strong>'.$this->co_reg->sec->usrcod.'</strong> y no puede realizar operaciones.<br>Contáctese con el administrador del sistema.';
						$lv_prm['msgbtn'] = array( array('text' => $this->co_reg->language->close, 'action' => 'document.location.href="?prg=syssecusr&act=99"') );
						$lv_prm['sec'] = $this->co_reg->sec;
						$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
													$this->co_reg->load->view('syserrmsg', $lv_prm) .
													$this->co_reg->load->view('sysdocftr2', $lv_prm);
						return $lv_buffer;
					}
        }
			
			// debo mostrar lista de empresas
			} else {
				
				if($lv_api!=''){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'La interfaz API requiere que indique la empresa.') );
				}else{
					$lv_prm = array('sec' => $this->co_reg->sec,
													'lang' => $this->co_reg->language,
													'co_bus' => $this->co_bus
													);
					$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
												$this->co_reg->load->view('syssecusr_bussel' , $lv_prm ) .
												$this->co_reg->load->view('sysdocftr2');
					return $lv_buffer;
				}
			}
		}
		
		// ----------------------------------------
		// Terminos de Uso y Política de Privacidad
		// ----------------------------------------
		// el usuario ya había aceptado los terminos de la empresa seleccionada?
		if ( $lv_usrtrmacp=='' && $this->co_reg->sec->usrsysacc!=1 ) {
			if($lv_api!=''){
				return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'El usuario no ha aceptado los terminos y condiciones del servicio.') );
			} else {
				// verifico si se pasó el flag de aceptación (formulario de aceptación de terminos)
				if ( isset($this->co_reg->request->post['usrtrmacp']) ) {
					// actualizo la conformidad del usuario en la base
					if($lo_usrbus_mdl->setUserAcceptanceTermsOfUse($lv_buscod)==false) {
						$lv_prm['msgttl'] = 'Error inesperado'; 
						$lv_prm['msgtxt'] = 'No se pudo actualizar la aceptación de Términos de Uso y Política de Privacidad del usuario.' . $this->co_reg->sec->errcod.': '.$this->co_reg->sec->errtxt; //'La empresa a la que desea acceder <strong>'.$this->co_reg->request->post['buscod'].'</strong> no está asignada al usuario <strong>'.$this->co_reg->sec->usrcod.'</strong> y no puede realizar operaciones.<br>Contáctese con el administrador del sistema.';
						$lv_prm['msgbtn'] = array( array('text' => 'Ok', 'action' => 'document.location.href='.chr(39).$this->co_reg->sec->bseurl.chr(39).';') );
						$lv_prm['sec'] = $this->co_reg->sec;
						$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
													$this->co_reg->load->view('syserrmsg', $lv_prm) .
													$this->co_reg->load->view('sysdocftr2', $lv_prm);
						return $lv_buffer;
					}
				// no se encontró flag de aceptación -> muestro pantalla de confirmación
				} else {
					$lv_prm = array('sec' => $this->co_reg->sec,
													'lang' => $this->co_reg->language,
                    			'input' => $this->co_reg->input,
													'data' => array('buscod'=>$lv_buscod,'bustxt'=>$lv_bustxt)
													);
					$lv_buffer = 	$this->co_reg->load->view('sysdochdr2', $lv_prm) .
												$this->co_reg->load->view('syssecusr_trmacp', $lv_prm) .
												$this->co_reg->load->view('sysdocftr2', $lv_prm);
					return $lv_buffer;
				}
			}
		}
		// ----------------------------------------
    
		$this->co_reg->sec->buscod = $lv_buscod;
		$this->co_reg->sec->bustxt = $lv_bustxt;

    $lo_adrmdl = $this->co_reg->load->model('grldatadr');
    $lo_adrmdl->load(array('adrsrctyp' => 'ADM_BUS', 'adrsrccod' => $lv_buscod));
    $this->co_reg->sec->lndcod = $lo_adrmdl->lndcod;
    $this->co_reg->sec->lndtxt = $lo_adrmdl->lndtxt;
    

		if($lv_api!=''){
			return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'0','errtxt'=>'') );
		} else {
			return '';
		}
	}
	
	
  // userLogin. Obtiene las variables POST y verifica si el usuario/contraseña son correctos     
  private function userLogin( $lp_drt=array(), $lv_api='' ) {
    if($this->lo_mdl == null){
      $this->lo_mdl = $this->co_reg->load->model( self::MODEL );
    }
		$this->errcod = 0;
		$this->errtxt = '';
		$lo_post = $this->co_reg->request->post;
    $lv_usrcod = ($lo_post['usrcod']??$this->co_reg->sec->usrcod);
    $lv_bseurl = ($lo_post['bseurl']??$this->co_reg->sec->bseurl);
    $lv_bsecnx = ($lo_post['bsecnx']??$this->co_reg->sec->bsecnx);
		$lv_usrpwd = ($lo_post['usdpwd']??$this->co_reg->sec->usdpwd);
    // valida case sensitive
    $lv_cs = false;
    if( count($lp_drt)>0 ){
     $lv_cs_drt = array_filter($lp_drt, function($elem){ return (strtolower($elem['syssecdrttypcodext'])=='pwdlgncasesensitive'); });
		 $lv_cs = (($lv_cs_drt[0]['syssecdrttypdef']??'') == '1' ? true : false);
   	}
    $lv_usrpwd = ($lv_cs ? ($lo_post['usrpwd']??'') : ($lo_post['usrpwdupr']??($lo_post['usrpwd']??'')));
		
    $lv_lgnfcb = ($lo_post['lgnfcb']??'');
    if ( $lv_usrcod=='' || $lv_usrpwd=='' || $lv_bseurl=='' || $lv_bsecnx=='' ) {
			$this->errcod = -9;
			$this->errtxt = 'Uno o m&aacute;s par&aacute;metros previstos no se ha proporcionado';
    } else {
			$this->co_reg->sec->usrcod = $lv_usrcod;
			$this->co_reg->sec->bseurl = $lv_bseurl;
			$this->co_reg->sec->bsecnx = $lv_bsecnx;
      // check username and password in database
			$lv_prm = array( 'usrcod'=>$lv_usrcod, 'usrpwd'=>$lv_usrpwd, 'lgnfcb'=>$lv_lgnfcb );
			if ( $this->lo_mdl->checkUserLogin($lv_prm)==false ) {
				$this->errcod = $this->lo_mdl->errcod;
				$this->errtxt = $this->lo_mdl->errtxt;
			} else if( $this->lo_mdl->usrsysacc==1 && $lv_api=='' ){
				$this->errcod = -10;
				$this->errtxt = 'Este usuario es de Sistema. Solo se permite su acceso mediante APIs.';
			} else {
				$this->co_reg->sec->usrcod = $this->lo_mdl->usrcod;
				$this->co_reg->sec->usrtxt = $this->lo_mdl->usrtxt;
				$this->co_reg->sec->usrsysacc = $this->lo_mdl->usrsysacc;
				$this->co_reg->sec->timeout= time() + self::LOGIN_TIMEOUT;
				if( $this->lo_mdl->usrsysacc==1 ){
					$this->data['pwddays'] = 0;
					$this->data['usrpwdchg'] = 0;
				} else {
					$this->data['pwddays'] = $this->lo_mdl->pwddays;
					$this->data['usrpwdchg'] = $this->lo_mdl->usrpwdchg;
				}
			}
    }
		return $this->errcod;
  }
  
  
  // userLogout. Destruye el objeto sesión del usuario     
  private function userLogout() {
    $this->co_reg->session->destroy();
    return true;
  }
  
  
  public function getUserDirectives( $lp_usrcod = ''){
    //obtiene las directivas asignadas al usuario
    $lo_grpasgmdl = $this->co_reg->load->model('syssecdrtgrpasg');
    $lo_usrdrt = $lo_grpasgmdl->getUserDirectives( array(), array('usrcod' => ($lp_usrcod ? $lp_usrcod : $this->co_reg->sec->usrcod)) ); 

    //arma un string con los id de las directivas del usuario
    $lv_drtstr = '';
    foreach( $lo_usrdrt as $lo_row ){ $lv_drtstr .= ( $lv_drtstr != '' ? '|' : '' ).$lo_row['syssecdrttypcod']; }

    //obtiene las directivas del usuario y del sistema
    $lo_typmdl = $this->co_reg->load->model('syssecdrttyp');

    //llama a la accion 10 del modelo de tipos de directivas
    // busca las directivas, dependencias y las directivas del sistema
    $lv_prm = array( 'vewfldflt' => '[~fltrow~]dt.syssecdrttypcodext'.chr(9).'ZZ'.chr(9).' LIKE ^LGN%^ '.chr(9).' OR dt.syssecdrttypcodext LIKE ^PWDLGN%^ '.chr(9).chr(9));
    $lo_drt = $lo_typmdl->getDirectives( $lv_prm, array( 'syssecdrttypatr' => $lv_drtstr ) );

    //se sobre escriben los valores de las directivas por los valores del grupo
    foreach( $lo_usrdrt as $lo_row ){
      //recorre los datos de las directivas
      foreach( $lo_drt as &$lo_row2 ){
        if( $lo_row2['syssecdrttypcod'] == $lo_row['syssecdrttypcod']  ){
          //decide el valor más restrictivo entre los distintos valores de grupos y el valor por default para ver que valor se va usar para la directiva
          $lv_drtvaltemp = explode( chr(10), html_entity_decode( $lo_row['syssecdrtgrptypdefval'] ) );
          foreach( $lv_drtvaltemp as $lv_row3 ){
            if( $lo_row2['syssecdrttyptyp'] == 'string' ){
              $lo_row2['syssecdrttypdef'] = $lo_row2['syssecdrttypdef'].$lv_row3; 
            }else{ //numerico o s/n
              $lo_row2['syssecdrttypdef'] = ( $lv_row3 >= $lo_row2['syssecdrttypdef'] ? $lv_row3 : $lo_row2['syssecdrttypdef'] );
            }
          }
          
          break;
        }
      }
      unset($lo_row2);
    }
    
		return $lo_drt;
  }
}
?>