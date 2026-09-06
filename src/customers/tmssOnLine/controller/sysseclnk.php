<?php
final class sysseclnkController extends tmssController {
	const MODEL = 'sysseclnk';
	const VIEW  = 'sysseclnk';
	const ID = 'sysseclnkcod';
  protected $co_reg;
	protected $co_usr; 
	private $lo_mdl;
  private $data = array();
  
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
  
  
  /**
   * main method
   */     
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
      // SAVE
      case '#00':        
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	'sysseclnkcod'=>$this->lo_mdl->sysseclnkcod, false	) );
          return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->sysseclnkcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			
			/* **************************************************************************************
			
			 I N T E G R A C I O N
			 
			*************************************************************************************** */
			
			
			
			// CREAR-VINCULAR USUARIO
			case '#11':
				$lo_post = $this->co_reg->request->post;
				$this->co_usr = $this->co_reg->load->model('syssecusr');
				$lo_usrlnk = $this->co_reg->load->model('syssecusrlnk');
				$lo_usrbus = $this->co_reg->load->model('syssecusrbus');
				$lo_usrgrp = $this->co_reg->load->model('syssecusrgrp');
				$lo_usrprm = $this->co_reg->load->model('syssecusrprm');
				$lv_usrgrpcod = $lo_post['usrgrpcod']??'';
        
				if ( $lo_post['usrcod']!='' ) {
					if ($this->co_usr->load( array('usrcod'=>$lo_post['usrcod']) )==false) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-210,'errtxt'=>'El usuario que intenta vincular ya no tiene un acceso en el sistema.'));
					}
				} else {
					$lo_post['usrcod'] = $lo_post['srcobjtyp'] . '_' . $lo_post['srcobjcod'];
					$lo_post['adrnme001'] = $lo_post['usrtxt'];
          
					// creo el usuario
					if ($this->co_usr->save( $lo_post )==false) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-112,'errtxt'=>'No se pudo crear el usuario.'));
					}
				}

				// agrego el link (usuario-dato maestro)
				if ( $lo_usrlnk->save( array('usrcod'=>$lo_post['usrcod'],'srcobjtyp'=>$lo_post['srcobjtyp'],'srcobjcod'=>$lo_post['srcobjcod'],'docsts'=>'A') )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-211,'errtxt'=>'No se pudo vincular la cuenta al dato maestro.['.$lo_usrlnk->errcod.'/'.$lo_usrlnk->errtxt.']'));
        }
        
        $lo_post['usrcod'] = $this->co_usr->usrcod;
        $lo_post['syssecusrbus'] = $this->co_reg->sec->buscod;
        $lo_post['syssecusrgrp'] = $lo_post['usrgrpcod'];
        
        // agrego asociación de empresa
        if ( $lo_usrbus->save( $lo_post )==false ) { return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-431,'errtxt'=>'Error asignación de empresa.')); }
        
        // agrego asociación de rol de seguridad
        $lo_post['usrgrpcod'] = ''; // vacio el ID de rol para que siempre se agregue
        if ( $lo_usrgrp->save( $lo_post )==false ) { return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-532,'errtxt'=>'Error al asignar grupo.')); }
        
        // revisa si esta definido el parametro
        if ( $lo_post['usrprmcod']=='' ) { return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-533,'errtxt'=>'No se indicó rol para asignar al usuario.')); }
        
        // obtengo configuración de enlace
				$lo_syslnkmdl = $this->co_reg->load->model('sysseclnk');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]l.objtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
																			'[~fltrow~]l.usrgrpcod'.chr(9).'='.chr(9).chr(9).$lv_usrgrpcod.chr(9).chr(9));
				$lo_rs = $lo_syslnkmdl->getlist( $lv_prm, null, null, false );
        $lv_usrprm = array( array('usrcod'=>$this->co_usr->usrcod,'prmcod'=>$lo_post['usrprmcod'],'prmval'=>$lo_post['usrprmval'],'usrprmflttyp'=>'AND','prmfld'=>($lo_rs[0]['sysseclnksrcfld']??''),'prmobjtyp'=>$lo_post['srcobjtyp'],'docsts'=>$lo_post['docsts']) );

				// SALUD-PRESTADORES. para salud-prestadores, se ajustan los parametros de paciente
        if( $lo_post['srcobjtyp']=='HLT_PRS' ){
					$lv_patprm = $this->getExtraParameters($lo_post['srcobjtyp'], $lo_post['srcobjcod'], $this->co_usr->usrcod);
					if(count($lv_patprm)>0){
						$lv_usrprm = array_merge( $lv_usrprm, $lv_patprm);
					}
					$lv_prm = array('vewfldflt' =>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9).$this->co_usr->usrcod.chr(9).chr(9).
																					'[~fltrow~]prmfld'.chr(9).'='.chr(9).chr(9).'patcod'.chr(9).chr(9));
					$lo_rs = $lo_usrprm->getList($lv_prm);
					foreach($lo_rs as $lv_row){
					 $lo_usrprm->delete($lv_row);
					}
				}
				
        // agrego asociación de parámetros
        foreach( $lv_usrprm as $lv_row ){
          if ( !$lo_usrprm->save( $lv_row ) ) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-643,'errtxt'=>'Error al asignar parámetro.'));
          } 
        }
        
        return $this->co_reg->document->getJson( array('errtyp'=>'S', 'errcod'=>'0', 'usrcod'=>$this->co_usr->usrcod));
				break;
			
			
			
			// BORRAR USUARIO
			case '#14':
				$lo_post = $this->co_reg->request->post;
				$this->co_usr = $this->co_reg->load->model('syssecusr');
				if ($this->co_usr->load( array('usrcod'=>$lo_post['usrcod']) )==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-254,'errtxt'=>'No se pudo obtener información del usuario.'));
				} else {
					if ( $this->co_usr->delete( $lo_post ) == false ) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-142,'errtxt'=>'No se pudo borrar el usuario.'));
					}
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S', 'errcod'=>'0'));
				break;
			

			
			// DESVINCULAR CUENTAS
			case '#24':
				$lo_post = $this->co_reg->request->post;
				$lo_usrlnk = $this->co_reg->load->model('syssecusrlnk');
				if ( $lo_usrlnk->delete(array('usrcod'=>$lo_post['usrcod'],'srcobjtyp'=>$lo_post['srcobjtyp'],'srcobjcod'=>$lo_post['srcobjcod']))==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-241,'errtxt'=>'No se pudo desvincular la cuenta del dato maestro.'));
				}
				break;
			
			
			
			// DESBLOQUEAR USUARIO
			case '#17':
				$lo_post = $this->co_reg->request->post;
				$this->co_usr = $this->co_reg->load->model('syssecusr');
				if ($this->co_usr->load( array('usrcod'=>$lo_post['usrcod']) )==false) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-254,'errtxt'=>'No se pudo obtener información del usuario.'));
				} else if ( $this->co_usr->unlock( $lo_post ) == false) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-171,'errtxt'=>'No se pudo desbloquear el usuario.'));
				}
				break;
			
			 
			
			// ENVIAR INFO
			case '#25':
				$lo_post = $this->co_reg->request->post;
				$this->co_usr = $this->co_reg->load->model('syssecusr');
				if ($this->co_usr->load( array('usrcod'=>$lo_post['usrcod']) )==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-254,'errtxt'=>'No se pudo obtener información del usuario.'));
				} else {
					// obtengo texto del mensaje
					$lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_usrmsg = $lo_txtmdl->load(array('txtcodext' => 'USRACCINF', 'txtsys' => 0), false) ? $lo_txtmdl->txttxt : '';
				
					// envío mensaje
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = array( array('address'=>$this->co_usr->adreml) );
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis') );
					$lv_emlprm['subject'] = 'Datos de Acceso';
					if ( $lv_usrmsg!='' ) {
						$lv_link = $this->co_reg->sec->bseurl;
						$lv_bustxt = $this->co_reg->sec->bustxt;
						$lv_usrmsg = str_replace('[%1]', $this->co_usr->usrtxt, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%2]', $lv_link, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%3]', $lv_bustxt, $lv_usrmsg );
						$lv_usrmsg = str_replace('[%4]', $this->co_usr->usrcod, $lv_usrmsg );
						$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					} else {
						$lv_emlprm['bodyhtml'] = 'no encontro el texto';
					}
					if ( $lo_eml->send( $lv_emlprm ) == false) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-251,'errtxt'=>$lo_eml->getError()));
					}
				}
				break;
    }

  }
	
	/**
	 * inicializa el enlace según el tipo de objeto
	 * 1) carga los enlaces de objeto con el dato maestro
	 * 2) carga los vinculos ya establecidos para el dato maestro
	 * 3) carga usuarios existentes con la misma cuenta de email
	 */
	public function initialize( $lp_objtyp, $lp_srcobjcod, $lp_adreml ) {

		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->lo_mdl_usr = $this->co_reg->load->model('syssecusrlnk');
		$this->co_usr = $this->co_reg->load->model('syssecusr');
		
		$lv_ret = array();
		$lv_ret['sysseclnk'] = array();
		$lv_ret['syssecusr'] = $this->co_usr;
		$lv_ret['syssecusrlnk'] = array();

		// cargo los enlaces de objeto con el objeto actual
		$lv_prm = array('vewfldflt'=>'[~fltrow~]objtyp'.chr(9).'='.chr(9).chr(9).$lp_objtyp.chr(9).chr(9) );
		$lo_rs = $this->lo_mdl->getList( $lv_prm, null,null,false );
		$lv_ret['sysseclnk'] = $lo_rs;
		if ( count($lo_rs)==0 ) {
			// no hay enlaces con el objeto actual
			return $lv_ret;
		}
		
		// cargo los enlaces ya establecidos para el dato maestro
		$lv_usrcod = '';
		$lv_prm = array('vewfldflt'=>'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lp_objtyp.chr(9).chr(9).
																	'[~fltrow~]l.srcobjcod'.chr(9).'='.chr(9).chr(9).$lp_srcobjcod.chr(9).chr(9).
																	'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																	);
		$lo_lnkrs = $this->lo_mdl_usr->getList( $lv_prm );
    
    // cargo el primer usuario existente con la misma cuenta de email
    $lv_prm = array( 'vewfldflt' =>'[~fltrow~]a.adreml'.chr(9).'='.chr(9).chr(9).$lp_adreml.chr(9).chr(9) );
    $lo_usrrs = $this->co_usr->getList( $lv_prm );
    
    $lv_usrlnk = array();
    // identifica el vínculo correspondiente teniendo en cuenta el usuario con el mismo mail
    foreach($lo_lnkrs as $lv_row){
      foreach($lo_usrrs as $lv_row2){
        if($lv_row['usrcod'] == $lv_row2['usrcod']){
          $lv_usrlnk = $lv_row;
          break;
        }
      }
    }
    
		$lv_ret['syssecusrlnk'] = $lv_usrlnk;
		if ( count($lv_usrlnk)==0 ) {
			
			// no hay enlaces de usuario para el dato maestro
			// cargo el primer usuario existentes con la misma cuenta de email
			if ( count($lo_usrrs)!=0 ) { $lv_usrcod = $lo_usrrs[0]['usrcod']; }
			
		// asigno el usuario del enlace
		} else { $lv_usrcod = $lv_usrlnk['usrcod']; }
		
		// cargo los datos del usuario
		if ( $lv_usrcod!='' ) {
			$this->co_usr->load( array('usrcod'=>$lv_usrcod) );
			$lv_ret['syssecusr'] = $this->co_usr;
		}
				
		return $lv_ret;
	}
  
  public function getExtraParameters($lp_srcobjtyp, $lp_srcobjcod, $lp_usrcod){
    $lv_usrprm = array();
    
    // SALUD - PRESTADORES ------------------------------------------------
    // Al crear un usuario de tipo prestador, se obtienen todos los pacientes en los cuales el prestador actual desempeña alguna funcion.
    // Solo se tienen en cuenta aquellos roles que actualizan parámetros de usuario.
    // El resultado es un usuario de prestador con todos los pacientes que existian previamente.
    if( strtoupper($lp_srcobjtyp)=='HLT_PRS' ){
      // Obtiene posibles referencias a un usuario anterior si se crea un usuario para un prestador
      // obtiene roles que actualizan usuario
      $lo_prsrlsmdl = $this->co_reg->load->model( 'hltprsrls' );
      $lv_prm = array( 'vewfldflt' => '[~fltrow~]dbo.getTagValue(^UPDUSRPRM^,r.prsrlsatrval001)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                                      '[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
      $lo_rs = $lo_prsrlsmdl->getList( $lv_prm );
      
      // arma array con los codigos de los roles
      $lv_rlsarr = array();
      foreach( $lo_rs as $lv_row ){ array_push( $lv_rlsarr, $lv_row['prsrlscod'] ); }
      
      // obtiene los pacientes
      $lo_patprsmdl = $this->co_reg->load->model( 'hltpatprsrls' );
      $lv_prm = array( 'vewfldflt' => '[~fltrow~]p.prscod'.chr(9).'='.chr(9).chr(9).$lp_srcobjcod.chr(9).chr(9).
                                      '[~fltrow~]p.prsrlscod'.chr(9).'IN'.chr(9).chr(9).implode( chr(10), $lv_rlsarr ).chr(9).chr(9).
                                      '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
      $lo_rs = $lo_patprsmdl->getList( $lv_prm );
      
      // obtengo el ID de DEFINICION del PARAMETRO PATCOD
      $lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'patcod'.chr(9).chr(9), 'vewmaxrec'=>'1');
      $lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
      if ( count($lo_usrprmdef_rs)==0 ) { return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-534,'errtxt'=>'No se pudo obtener la definición de parámetros.')); }
      $lv_prmcod = $lo_usrprmdef_rs[0]['secusrprmcod'];
      
      // Guardo los IDs de pacientes en un array en una cadena separada por comas
      $lv_patcods = array();
      foreach( $lo_rs as $lv_row1 ){
      	$lv_patcods[] = $lv_row1['patcod'];
      }
      $patcodString = implode(',', $lv_patcods);
      // Arma los parametros con los datos de los usuarios anteriores
      foreach( $lo_rs as $lv_row ){
        array_push( $lv_usrprm, array('usrcod'=>$lp_usrcod,
                                      'prmcod'=>$lv_prmcod,
                                      'prmval'=>$patcodString,
                                      //'prmval'=>$lv_row['patcod'],
                                      'usrprmflttyp'=>'OR',
                                      'prmfld'=>'patcod',
                                      'prmobjtyp'=>'HLT_PAT',
                                      'docsts'=>'A' ));
      }
      
    }
    // (fin) SALUD - PRESTADORES ------------------------------------------
    
    return $lv_usrprm;
  }
	
}
?>