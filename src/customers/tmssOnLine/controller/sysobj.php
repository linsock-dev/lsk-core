<?php
final class sysobjController extends tmssController {
	const MODEL = 'sysobj';
	const VIEW  = 'sysobj';
	const ID = 'sysobjcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // INDEX. metodo principal del controlador
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
			
			
      // SAVE.  graba un objeto
      case '#00':
				if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->sysobjcod	) );
					
					// CLASES DE OBJETO. obtengo la lista de clases de objeto
					$lo_objclsmdl = $this->co_reg->load->model('sysobjcls');
					$lv_prm = array('vewfldflt'=>	'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
					$this->lo_mdl->sysobjcls = $lo_objclsmdl->getList( $lv_prm );

          // recupero todos los grupos de desarrollo
          $lo_devmdl = $this->co_reg->load->model('sysdevgrp');
          $lv_prm = array('vewfldflt'=>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
          $lo_rs1 = $lo_devmdl->getList($lv_prm);
          $lv_devgrp = array();
          foreach($lo_rs1 as $lv_row){ $lv_devgrp[$lv_row['sysdevgrpcod']]=$lv_row['sysdevgrptxt']; }                  
          
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'devgrp'=>$lv_devgrp) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // NEW.  crea un nuevo objeto
      case '#01':
				$this->lo_mdl->create();
				
				// CLASES DE OBJETO. obtengo la lista de clases de objeto
				$lo_objclsmdl = $this->co_reg->load->model('sysobjcls');
				$lv_prm = array('vewfldflt'=>	'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
				$this->lo_mdl->sysobjcls = $lo_objclsmdl->getList( $lv_prm );
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY.  COPY. carga un objeto en modo edicion o visualización
      case '#02': case '#03': case '#001':
				$lv_key = array( self::ID=>($lp_prm[self::ID]??($this->co_reg->request->post[self::ID]??'')) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.']') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// CLASES DE OBJETO. obtengo la lista de clases de objeto
				$lo_objclsmdl = $this->co_reg->load->model('sysobjcls');
				$lv_prm = array('vewfldflt'=>	'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
				$this->lo_mdl->sysobjcls = $lo_objclsmdl->getList( $lv_prm );
        
        // recupero todos los grupos de desarrollo
        $lo_devmdl = $this->co_reg->load->model('sysdevgrp');
        $lv_prm = array('vewfldflt'=>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs1 = $lo_devmdl->getList($lv_prm);
        $lv_devgrp = array();
        foreach($lo_rs1 as $lv_row){ $lv_devgrp[$lv_row['sysdevgrpcod']]=$lv_row['sysdevgrptxt']; }        
        
      	// copiar
        if($lp_act == '#001'){
          $this->lo_mdl->sysobjcod = '';
          $this->lo_mdl->sysobjcodext = '';
          $this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';  
        } 
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'devgrp'=>$lv_devgrp) );
        break;
			
			
			// DELETE. borra un objeto
			case '#04':
				$this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;			
			
			
			// EDT.  abre el editor
			case '#edt':

				// PREFERENCIAS. se recuperan las preferencias de usuario
				$lo_usrprfmdl = $this->co_reg->load->model('syssecusrprf');
				$lv_prm=array('vewfldflt'=>	'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9)
																		.'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9). 'SYS_OBJ' .chr(9).chr(9)
																		.'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
											);
				$lo_usrprfarr = $lo_usrprfmdl->getList( $lv_prm );
				$lv_usrthm = 'default';
				$lv_autcls = '';
				foreach($lo_usrprfarr as $lv_row){
					if(trim(strtolower($lv_row['usrprfkey']))=='usrthm' && trim($lv_row['usrprfval'])!=''){ $lv_usrthm = trim($lv_row['usrprfval']); }
					if(trim(strtolower($lv_row['usrprfkey']))=='autcls' && trim($lv_row['usrprfval'])!=''){ $lv_autcls = trim($lv_row['usrprfval']); }
				}
				$this->lo_mdl->usrprf = array('usrthm'=>$lv_usrthm,'autcls'=>$lv_autcls);
        
         // GRUPO DE DESARROLLO. recupero grupos de desarrollo de usuario
        $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
        $lv_prm = array('vewfldflt'=> '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs2 = $lo_devgrpmdl->getList($lv_prm);
        $lv_usrdevgrp = [];
        foreach($lo_rs2 as $lv_row){ 
          $lv_sysdevgrpusr_arr = json_decode($lv_row['sysdevgrpusr'], true);
          foreach($lv_sysdevgrpusr_arr as $lv_usr){
            if(strtoupper($lv_usr) == $this->co_reg->sec->usrcod){
              $lv_usrdevgrp[] .= $lv_row['sysdevgrpcod'];
            }
          }
        }
        
				return $this->co_reg->document->getView( 'sysobjedt', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'usrdevgrp'=>$lv_usrdevgrp) );
				break;
			
			
			// EDT SRCH. busca objetos segun el texto ingresado
			case '#edtsrch':
				$lo_post = $this->co_reg->request->post;
				
				$lo_post['sysobjclscod'] = ($lo_post['sysobjclscod']??'');
				
				// OBJETOS. obtiene los archivos registrados en el sistema dependiendo de lo buscado
				$lv_prm = array('vewfldflt' => '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																			.($lo_post['sysobjclscod']!='' ? '[~fltrow~]c.sysobjclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjclscod'].chr(9).chr(9):'')
																			.(isset($lo_post['sysobjsrchtxt'])?'[~fltrow~]o.sysobjtxt'.chr(9).'LIKE'.chr(9).strtoupper($lo_post['sysobjsrchtxt']).chr(9).chr(9).chr(9):''),
												'vewfldord' => ' o.sysobjtxt ',
												'vewmaxrec' => '50');
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				
				// ORDEN DE TRANSPORTE. recupera los objetos de ordenes de transporte no liberadas
				$lo_systraobjmdl = $this->co_reg->load->model('systraobj');
				$lv_prm = array('vewfldflt' => '[~fltrow~]ot.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			(isset($lo_post['usrcod'])?'[~fltrow~]ot.usrcod'.chr(9).'='.chr(9).chr(9).$lo_post['usrcod'].chr(9).chr(9):''),
												'vewfldord' => ' o.sysobjtxt ');
				$lo_systraobjrs = $lo_systraobjmdl->getList($lv_prm);
				
				// RESPUESTA. procesa la lista de respuesta en funcion de la busqueda o del usuario
				$lv_ret = array();
				if( isset($lo_post['usrcod']) ){
					$lv_ret = $lo_systraobjrs;
				} else {
					foreach ($lo_rs as $lv_row) {
						$lv_row['usrcod'] = '';
						foreach ($lo_systraobjrs as $lv_rowtra) {
							if($lv_row['sysobjcod'] == $lv_rowtra['sysobjcod']){
								$lv_row['usrcod'] = $lv_rowtra['usrcod'];
								$lv_row['lckttl'] = $lv_rowtra['usrcod'].' (OT #'.$lv_rowtra['systracod'].')';
								break;
							}
						}
						$lv_ret[] = $lv_row;
					}
				}
				
				return $this->co_reg->document->getJson($lv_ret);
				break;
			
        
			// FLE CONT. devuelve el contenido de un objeto
			case '#flecont':
				$lo_post = $this->co_reg->request->post;
				return $this->lo_mdl->getContent($lo_post['sysobjcod'], ($lo_post['vercod']??'DEV') );
				break;
			
			
			// SEND FILE. envia un archivo (desa o prd)
			case '#sendFile':
				$lo_post = $this->co_reg->request->post;
				return $this->lo_mdl->sendFile( $lo_post['sysobjcod'], $lo_post['sendto'] );
				break;

			// TRA OBJETO. devuelve la vista de ordenes de transporte ==> MOVER A CONTRLADOR SYSTRAOBJ
			/*
			case '#traobj':
				return $this->co_reg->document->getView( 'systraobj', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			*/
      
			// GET VERSIONS. devuelve una lista de versiones del objeto 
			case '#getversions':
				$lo_post = $this->co_reg->request->post;
				$lo_ver = $this->lo_mdl->getVersions( array('sysobjcod'=>$lo_post['sysobjcod']) );
				return $this->co_reg->document->getJson( array('data'=>$lo_ver) );
			
    	// SHOW COMPARE. devuelve vista de comparacion para un objeto
			case '#showCompare':
        $lo_post = $this->co_reg->request->post;
				$this->lo_mdl->load( array(self::ID=>$lo_post['sysobjcod']) );
        $this->lo_mdl->objver = $this->lo_mdl->getVersions( array('sysobjcod'=>$lo_post['sysobjcod']) );
        $this->lo_mdl->btn = $lo_post['btn'] ?? false;
				return $this->co_reg->document->getView( 'sysobjvercmp', array('data'=>$this->lo_mdl) );
				break;
			
			
			// SVE USR PRF. graba las preferencia de usuario
			case '#sveusrfrf':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				
				// PREFERENCIAS. grabar
				$lo_usrprfmdl = $this->co_reg->load->model('syssecusrprf');
				// theme
				$lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'SYS_OBJ','usrprfkey'=>'usrthm','usrprfval'=>(isset($lo_post['usrthm'])?$lo_post['usrthm']:''),'docsts'=>'A');
				$lo_usrprfmdl->save( $lv_dat );
				// auto close
				$lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'SYS_OBJ','usrprfkey'=>'autcls','usrprfval'=>(isset($lo_post['usrthm'])?$lo_post['autcls']:''),'docsts'=>'A');
				$lo_usrprfmdl->save( $lv_dat );
				
				return $this->co_reg->document->getJson( $lv_ret );
				break;
			
      
			// DBQUERY.  abre ventana de query de base de datos / busqueda de strings
      case '#dbquery':
			
				// CLASES DE OBJETO. obtengo la lista de clases de objeto
				$lo_objclsmdl = $this->co_reg->load->model('sysobjcls');
				$lv_prm = array('vewfldflt'=>	'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
				$this->lo_mdl->sysobjcls = $lo_objclsmdl->getList( $lv_prm );
			
				return $this->co_reg->document->getView( 'sysobjqry', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// DBQUERY EXECUTE. ejecuta una sentencia SQL
			case '#dbquery_execute':
				$lo_post = $this->co_reg->request->post;
				$lo_rs = $this->co_reg->db->sqlquery( $lo_post['qrystr'], array(), 1 );
				if( is_array($lo_rs) ){
					return $this->co_reg->document->getJson( $lo_rs );
				} else {
					return $lo_rs;
				}
				break;
			
			case '#stringfind_execute':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array();
				$lv_strfnd = ($lo_post['strfnd']??'');
				if( $lv_strfnd!='' ){
					// obtiene todos los objetos declarados en el sistema como activos
					$lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]o.sysobjclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjclscod'].chr(9).chr(9),
													'vewfldord' => ' o.sysobjtxt ',
													'vewmaxrec' => '1000');
					$lo_rs = $this->lo_mdl->getList($lv_prm);

					// busca el string
					foreach($lo_rs as $lv_row){
						$lv_cnt = $this->lo_mdl->getContent( $lv_row['sysobjcod'], 'DEV' );
						if( stripos($lv_cnt,$lv_strfnd)!==false ){
							$lv_ret[] = array('sysobjcod'=>$lv_row['sysobjcod'],'sysobjtxt'=>$lv_row['sysobjtxt'],'sysobjclscod'=>$lv_row['sysobjclscod'],'sysobjclstxt'=>$lv_row['sysobjclstxt']);
						}
					}
				}
				return $this->co_reg->document->getJson( $lv_ret );
				break;
				
    }
  }
}
?>