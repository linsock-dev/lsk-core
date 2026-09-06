<?php
final class sysapppryController extends tmssController {
	const MODEL = 'sysapppry';	
	const VIEW  = 'sysapppry';	
	const ID = 'sysappprycod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }  
  
	
  // Index - Método principal     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. Lista
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
		  // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
        
        if ( $this->lo_mdl->save($lo_post) ) {
          // grabo columnas de la tabla
					$lo_sysapicolmdl = $this->co_reg->load->model('sysapppryapi');
          $lo_post['sysappprycod'] = $this->lo_mdl->sysappprycod;
					$lv_buffer = $lo_post['sysappapi'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_sysvewcol_arr = json_decode($lv_buffer,true);
            foreach($lv_sysvewcol_arr as $lv_row){
              $lv_row['sysappprycod'] = $this->lo_mdl->sysappprycod;
              $lv_row['docsts'] = 'A';
              
              if(isset($lv_row['sysapppryapicfg'])){
                if(is_array($lv_row['sysapppryapicfg'])){
                  $lv_row['sysapppryapicfg'] = json_encode($lv_row['sysapppryapicfg']);
                }else{
                  $lv_row['sysapppryapicfg'] = substr($lv_row['sysapppryapicfg'],1 ,-1);
                }
              }
              
              if (isset($lv_row['deleted'])) {
                if ($lo_sysapicolmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysapicolmdl->errtyp,'errcod'=>$lo_sysapicolmdl->errcod,'errtxt'=>$lo_sysapicolmdl->errtxt));
                }
              } else if ($lo_sysapicolmdl->save($lv_row)==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysapicolmdl->errtyp,'errcod'=>$lo_sysapicolmdl->errcod,'errtxt'=>$lo_sysapicolmdl->errtxt));
              } 
            }
          }
					$this->lo_mdl->load( array('sysappprycod'=>$this->lo_mdl->sysappprycod	) );

          return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
			
      // NEW                
      case '#01':
				$this->lo_mdl->create(); 
        $this->lo_mdl->sysapppryapi = array();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			      
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->sysapppryapi; 
          foreach($lv_dat as &$lv_row){
            $lv_row['sysapppryapicod'] = ''; 
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          
          $this->lo_mdl->sysapppryapi = $lv_dat;
					$this->lo_mdl->sysappprycod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
 
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// GETLIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['sysappprytxt']) 	 ?'[~fltrow~]p.sysappprytxt'.chr(9).''.chr(9).utf8_decode($lp_prm['sysappprytxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'P'.chr(9).chr(9) );
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
        
      // POP UP. Configuración de habilitaciones
      case '#apicfg':
        $lo_post = $this->co_reg->request->post;        
				$this->lo_mdl->readonly = ( $lo_post['readonly'] ?? false );
				
				// carga APIs disponibles
				$lo_apimdl = $this->co_reg->load->model('sysappapi');
				$lo_apimdl->load(array('sysappapicod'=>$lo_post['sysappapicod']));	
				$this->lo_mdl->apidef = $lo_apimdl->apimap;
				
				// carga APIs habilitadas
				$lv_apipry = ( $lo_post['sysapppryapicfg'] ?? '[]' );
				$lv_apipry = ( $lv_apipry=='' ? '[]' : $lv_apipry );
				$lv_apipry = htmlspecialchars_decode($lv_apipry);
				
				// se quitan [ ] a inicio y fin del string para que se pueda convertir en JSON
				//$lv_apipry = substr( $lv_apipry, 1, -1);
				$this->lo_mdl->apipry = json_decode( $lv_apipry, true );
				
        //devuelve la vista del dialogo de escala de precios
        return $this->co_reg->document->getView( 'sysapppryapi', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
    }
  }
  
  public function execApi($lp_prm=array()){
    $lo_appprymdl = $this->co_reg->load->model('sysapppry');
    if( !$lo_appprymdl->load(array('sysappprytkn'=>$lp_prm['token'])) ){
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'Token inv&aacute;lido.') );
    }
		
		$lv_api_found = false;

		// verificar que el método/variante esté dentro de las apis habilitadas para proyectos y ejecutarla
    foreach($lo_appprymdl->sysapppryapi as $lv_row){

			// si coincide la api del proyecto con lo ejecutado
      if(strtoupper($lv_row['sysappapicodext']) == strtoupper($lp_prm['resource']) ){
				$lv_api_found = true;
				
				// verifico si tiene configuracion asociada (metodos)
        $lv_sysapppryapicfg = ($lv_row['sysapppryapicfg']??'');
        if($lv_sysapppryapicfg!=''){

					// recorro los metodos de la API
					$lv_mth_found = false;
          $lv_apicfg_arr = json_decode(html_entity_decode($lv_sysapppryapicfg),true);
					foreach($lv_apicfg_arr as $lv_row2){

						// si el metodo coincide (x ej. GET) y la variante tambien (x ej SEARCH)
          	if( $lp_prm['method']==$lv_row2['sysappapimapmth'] && strtoupper($lp_prm['variant'])==strtoupper($lv_row2['sysappapimapvar']) ){
							$lv_mth_found = true;
             	
             	//cargo modelo de la API
            	$lo_exeapimdl = $this->co_reg->load->model($lv_row2['sysappapimapmdl']);
              
              // cargo modelo de mapeo de API
              $lo_apimapmdl = $this->co_reg->load->model('sysappapimap');
              $lo_apimapmdl->load(array('sysappapimapcod'=>$lv_row2['sysappapimapcod']));
							$lv_maparr = json_decode(html_entity_decode($lo_apimapmdl->sysappapimapfldmap),true);

							$lv_ret = array();
							$lv_ret['data'] = array();
              // ejecuto la API
              switch($lo_apimapmdl->sysappapimapmdlmth){
								
                // SAVE. grabado de documentos
                case 'SAVE':
                  $lo_get = $this->co_reg->request->get;
                  $lo_post = $this->co_reg->request->post;
									
									// convierte los datos recibidos a una estructura con campos internos
                  $lv_svedat = strtoupper($lp_prm['resource']) == 'SALES-ORDERS' ? $this->fieldsToInternal_json($lo_post, $lv_maparr) : $this->fieldsToInternal($lo_post, $lv_maparr);
                  if(($lv_svedat['errtyp']??'S') == 'E'){
                    $lv_ret = $lv_svedat;
                  }else{	

                    // si se le definio un ID al metodo, agrego el valor de la url a los datos POST
                    if($lo_apimapmdl->sysappapimapfldcod!=''){
                      $lv_svedat[strtolower($lo_apimapmdl->sysappapimapfldcod)] = $lp_prm['apifield'];
                    }

                    // si hay datos, se ejecuta el método de gabacion
                    if(count($lv_svedat) > 1){

                      if ( $lo_exeapimdl->save($lv_svedat) ) {
                        $lv_ret['data'] = array($lo_exeapimdl->getData());
                        $lv_ret['data'] = $this->fieldsToExternal($lv_ret['data'], $lv_maparr);
                      }
                      $lv_ret['errtyp']=$lo_exeapimdl->errtyp;
                      $lv_ret['errcod']=$lo_exeapimdl->errcod;
                      $lv_ret['errtxt']=$lo_exeapimdl->errtxt;
                      $lv_ret['errmsg']=$lo_exeapimdl->errmsg;
                      if(($lo_get['_debugger']??'')!=''){
                        $lv_ret['sqlstm'] = $lo_exeapimdl->getsysdata('sqlstm');
                      }
                    } else {
                      $lv_ret['errtyp']='E';
                      $lv_ret['errcod']=-1;
                      $lv_ret['errtxt']='No data received.';
                      $lv_ret['errmsg']='noDataRecived';
                    }
                  }
									return $this->co_reg->document->getJson( $lv_ret );
                  break;
																
								
                // LOAD. carga un recurso ejecutando el metodo load del modelo
                case 'LOAD':
                  if( $lo_exeapimdl->load(array(strtolower($lo_apimapmdl->sysappapimapfldcod)=>$lp_prm['apifield'])) ){
										$lv_dat = array($lo_exeapimdl->getData());
										$lv_ret['data'] = $this->fieldsToExternal($lv_dat, $lv_maparr);
									}
									$lv_ret['errtyp'] = $lo_exeapimdl->errtyp;
									$lv_ret['errcod'] = $lo_exeapimdl->errcod;
									$lv_ret['errtxt'] = $lo_exeapimdl->errtxt;
									$lv_ret['errmsg'] = $lo_exeapimdl->errmsg;
                  return $this->co_reg->document->getJson( $lv_ret );
                  break;					
								
								
                // DELETE. borra un documento
                case 'DELETE':								
                  $lo_exeapimdl->delete(array(strtolower($lo_apimapmdl->sysappapimapfldcod)=>$lp_prm['apifield']));
									$lv_ret['errtyp']=$lo_exeapimdl->errtyp;
									$lv_ret['errcod']=$lo_exeapimdl->errcod;
									$lv_ret['errtxt']=$lo_exeapimdl->errtxt;
									$lv_ret['errmsg']=$lo_exeapimdl->errmsg;
                  return $this->co_reg->document->getJson( $lv_ret );
                  break;


								// GETLIST.devuelve una lista de documentos
                case 'GETLIST':
                  $lo_get = $this->co_reg->request->get;

									// convierte los datos recibidos a una estructura con campos internos
                  $lv_dat = $this->fieldsToInternal($lo_get, $lv_maparr);
                  if(isset($lv_dat['errtyp'])){
                    $lv_ret = $lv_dat;
                  }else{

                    // si hay datos, se ejecuta el método de gabacion
                    if(count($lv_dat) > 0){
                      $lv_fltfld = '';
                      foreach($lv_dat as $lv_key=>$lv_val){
                        $lv_expfld = explode('$', $lv_val);
                        $lv_dat = array(0=>$lv_key,1=>(count($lv_expfld)<1?'':$lv_expfld[0]),2=>'',3=>'',4=>'');
                        switch ($lv_dat[1]){
                          case 'LIKE':
                            $lv_dat[2]=html_entity_decode(isset($lv_expfld[1]) ? $lv_expfld[1] : ''); 
                            break;
                          case 'EE': case 'NE':
                            break;
                          case 'IN': case 'NI': case 'SW': case 'EW': case 'BT': case 'NB': case 'EQ': case 'GT': case 'LT': case 'LE': case 'GE': case 'NS':
                            $lv_dat[3]=html_entity_decode(isset($lv_expfld[1]) ? $lv_expfld[1] : ''); 
                            $lv_dat[4]=html_entity_decode(isset($lv_expfld[2]) ? $lv_expfld[2] : ''); 
                            break;
                          case 'ZZ':
                            $lv_dat[2]=html_entity_decode(isset($lv_expfld[1]) ? $lv_expfld[1] : ''); 
                            $lv_dat[3]=html_entity_decode(isset($lv_expfld[2]) ? $lv_expfld[2] : ''); 
                            $lv_dat[4]=html_entity_decode(isset($lv_expfld[3]) ? $lv_expfld[3] : ''); 
                            break;
                          default:
                            $lv_dat[1]='EQ'; 
                            $lv_dat[3]=html_entity_decode(isset($lv_expfld[0]) ? $lv_expfld[0] : ''); 
                            break;
                        }
                        $lv_fltfld .= '[~fltrow~]'.$lv_dat[0].chr(9).$lv_dat[1].chr(9).$lv_dat[2].chr(9). str_replace(';', chr(10),$lv_dat[3]).chr(9).$lv_dat[4].chr(9);
                      }
                      $lv_prm['vewfldflt'] = $lv_fltfld;

                      // GRUPO. agrupamiento de campos. &_group=campo1$campo2$campo3
                      if(isset($lo_get['_group'])){
                        $lv_arr = $this->convertFieldsToInternal(explode('$',$lo_get['_group']), $lo_apimapmdl->sysappapimapfldmap);
                        $lv_prm['vewfldgrp'] = implode(',',$lv_arr);
                      }

                      // GRUPO. CALCULADOS. campos calculados. &_groupcalc=SUM|campo1|name$MAX|campo2|name$MIN|campo3|name
                      if( isset($lo_get['_group']) && isset($lo_get['_groupcalc']) ){
                        $lv_arr = array();
                        $lv_grpcal = explode('$',$lo_get['_groupcalc']);
                        foreach($lv_grpcal as $lv_row){
                          $lv_fldarr = explode('|',$lv_row);
                          if( count($lv_fldarr)==3 ){
                            $lv_fldstr = $this->convertFieldsToInternal( array($lv_fldarr[1]), $lo_apimapmdl->sysappapimapfldmap);
                            if( ($lv_fldstr[0]??'') !=''){
                              $lv_arr[] = $lv_fldarr[0].'(isnull('.$lv_fldstr[0].',^0^)) as '.$lv_fldarr[2];

                              // agregar campos calculados al mapeo de salida (ya que no se encuentran definidos en la api)
                              $lv_maparr[] = array('fldmapapifld'=>$lv_fldarr[2],'fldmapfldcod'=>$lv_fldarr[2],'fldmapin'=>'','fldmapout'=>'X');

                            }
                          }
                        }
                        if(count($lv_arr)>0){ $lv_prm['vewfldgrpcal'] = implode(',',$lv_arr); }
                      }

                      // ORDEN. ordenamiento de registros de salida. &_order=campo1$campo2_DESC$campo3
                      if( isset($lo_get['_order']) ){
                        $lv_arr = $this->convertFieldsToInternal(explode('$',$lo_get['_order']), $lo_apimapmdl->sysappapimapfldmap, true);
                        $lv_prm['vewfldord'] = implode(',',$lv_arr);
                      }

                      // MAX. cantidad maxima de registros. &_max=30
                      if( isset($lo_get['_max']) ){
                        $lv_prm['vewmaxrec'] = $lo_get['_max'];
                      }

                      // EJECUCION. se obtiene el listado
                      $lo_rs = $lo_exeapimdl->getList($lv_prm);
                      if(isset($lo_rs['errtyp']) && $lo_rs['errtyp'] == 'E'){
                        $lv_ret = $lo_rs;
                        $lv_ret['errmsg'] = '';
                      }else{
                        // convierte los datos internos en una estructura de salida
                        $lv_ret['data'] = $this->fieldsToExternal( $lo_rs, $lv_maparr );
                        $lv_ret['errtyp'] = 'S';
                        $lv_ret['errcod'] = 0;
                        $lv_ret['errtxt'] = '';
                        $lv_ret['errmsg'] = '';
                        if(($lo_get['_debugger']??'')!=''){
                          $lv_ret['sqlstm'] = $lo_exeapimdl->getsysdata('sqlstm');
                        }
                      }
                    } else {
                      $lv_ret['errtyp'] = 'E';
                      $lv_ret['errcod'] = -6;
                      $lv_ret['errtxt'] = 'Al menos un parámetro de entrada debe ser proporcionado/declarado.';
                      $lv_ret['errmsg'] = '';
                    }
                  }
									return $this->co_reg->document->getJson( $lv_ret );
                  break;
								
								// DEFAULT. el método del modelo declarado en la definicion de la api no es valido
								default:
									$lv_ret = array();
									$lo_get = $this->co_reg->request->get;
									$lo_post = $this->co_reg->request->post;
									$lo_prmdat = array_merge( $lo_get, $lo_post );
									
									// si la api tiene definido un campo de parametro lo asigno como mapeo de entrada
									if( $lo_apimapmdl->sysappapimapfldcod!='' ){
										$lv_prmfld = strtolower($lo_apimapmdl->sysappapimapfldcod);
										$lo_prmdat[ $lv_prmfld ] = (isset($lp_prm['apifield'])?$lp_prm['apifield']:'') ;										
										$lv_maparr[] = array('fldmapin'=>'x','fldmapapifld'=>$lv_prmfld,'fldmapfldcod'=>$lv_prmfld);
									}
						
									$lv_mthact = $lo_apimapmdl->sysappapimapmdlmth;
									if(is_callable(array($lo_exeapimdl, $lv_mthact))){

										// convierte los datos recibidos a una estructura con campos internos
										$lv_usrdat = $this->fieldsToInternal($lo_prmdat, $lv_maparr);
                    if(isset($lv_usrdat['errtyp'])){
											$lv_ret = $lv_usrdat;
                    }else{

                      // ejecuta el método
                      $lv_dat = $lo_exeapimdl->$lv_mthact($lv_usrdat);

                      // activo debugger
                      if(($lo_get['_debugger']??'')!=''){
                        $lv_ret['sqlstm'] = $lo_exeapimdl->getsysdata('sqlstm');
                      }

                      // verifica los datos y los convierte para la salida
                      // el metodo es true-false y se recuperan los datos para devolver
                      if( is_bool($lv_dat) ){
                        $lv_dat = array($lo_exeapimdl->getData());
                        $lv_ret['data'] = $this->fieldsToExternal($lv_dat, $lv_maparr);
                        $lv_ret['errtyp'] = $lo_exeapimdl->errtyp;
                        $lv_ret['errcod'] = $lo_exeapimdl->errcod;
                        $lv_ret['errtxt'] = $lo_exeapimdl->errtxt;
                        $lv_ret['errmsg'] = $lo_exeapimdl->errmsg;
                      } else {
                        // convierte los datos internos en una estructura de salida
                        $lv_ret['data'] = $this->fieldsToExternal( $lv_dat, $lv_maparr );
                        $lv_ret['errtyp'] = 'S';
                        $lv_ret['errcod'] = 0;
                        $lv_ret['errtxt'] = '';
                        $lv_ret['errmsg'] = '';
                      }
                    }
									} else {
										$lv_ret['errtyp']='E';
										$lv_ret['errcod']=-13;
										$lv_ret['errtxt']='Metodo de API ['.$lo_apimapmdl->sysappapimapmdlmth.'] no definido. Consultar con el administrador.';
									} 
									return $this->co_reg->document->getJson( $lv_ret );
									break;
              }   
            }
          }
					if( $lv_mth_found == false ){
						return $this->co_reg->document->getJson(array('errtyp'=>'E', 'errcod'=>'-12', 'errtxt'=>'No se encontro el metodo ['.$lp_prm['method'].'] / variante ['.strtoupper($lp_prm['variant']).'] en la configuracion del proyecto.'));
					}
        } else {
					return $this->co_reg->document->getJson(array('errtyp'=>'E', 'errcod'=>'-12', 'errtxt'=>'Falta configuracion para API. Consultar con el administrador.'));
				}
      }
    }
		if($lv_api_found==false){
			return $this->co_reg->document->getJson(array('errtyp'=>'E', 'errcod'=>'-12', 'errtxt'=>'No existe la API dentro del proyecto. Consultar con el administrador.'));
		}
  }
	
	
	
	// callRemoteApi
	// recibe: array de parametros
	//					- apires 		(obligatorio. recurso a obtener. x ej. "dev_logistica")
	//					- prytkn		(obligatorio. token del proyecto)
	//					- usrcod / usrpwd  o  usrtkn	(obligatorio. usuario/clave o token de sesion de usuario)
	//					- data 			(opcional. array con datos a enviar como POST)
	//					- debugger	(opcional. flag para obtener el sqlstm de la ejecución del modelo)
	// devuelve: array
	//					- errtyp / errcod / errtxt (resultado de ejecución)
	//					- data (respuesta de la API como array)
	public function callRemoteApi($lp_prm=array()){
    $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');

		// valido parametros de funcion
		if( ($lp_prm['apires']??'')=='' ){
			$lv_ret=array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro APIRES.');
			return $lv_ret;
		} else if( ($lp_prm['prytkn']??'')=='' ){
			$lv_ret=array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro PRYTKN.');
			return $lv_ret;
		} else if( ($lp_prm['usrtkn']??'')=='' && (($lp_prm['usrcod']??'')=='' || ($lp_prm['usrpwd']??'')=='') ){
			$lv_ret=array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro USRCOD/USRPWD o USRTKN.');
			return $lv_ret;
		}

		// toma la URL actual y la reemplaza por api.gorse.php como base + el recurso
		//$lv_apiurl = 'https://localhost/sysdev/tmssOnLine/api.gorse.php';
		$lv_apiurl = $_SERVER['HTTP_REFERER'];
		$lv_apiurl = str_ireplace('index.php','',$lv_apiurl);
		$lv_apiurl = str_ireplace('?','',$lv_apiurl);
		if( stripos($lv_apiurl,'token=')!=false ){
			$lv_apiurl = substr($lv_apiurl,0,stripos($lv_apiurl,'token='));
		}
    if( stripos($lv_apiurl,'gorse.php')!=false ){
			$lv_apiurl = substr($lv_apiurl,0,stripos($lv_apiurl,'gorse.php'));
		}
		$lv_apiurl .= 'api.gorse.php/'.$lp_prm['apires'];

		// inicializo llamada
    $lo_cur = curl_init($lv_apiurl);
		
    // asignamos parametros de ejecucion
    curl_setopt($lo_cur, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)');
    curl_setopt($lo_cur, CURLOPT_CUSTOMREQUEST, 'GET');
    curl_setopt($lo_cur, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($lo_cur, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($lo_cur, CURLOPT_SSL_VERIFYPEER, 0);
		
    // configuramos header
		$lv_hdr = array('Content-Type: application/json','proyect-token: '.$lp_prm['prytkn']);
		if(($lp_prm['usrtkn']??'')!=''){
			$lv_hdr[] = 'user-token: '.$lp_prm['usrtkn'];
		} else {
			$lv_hdr[] = 'user: '.$lp_prm['usrcod'];
			$lv_hdr[] = 'password: '.$lp_prm['usrpwd'];
		}
    curl_setopt($lo_cur, CURLOPT_HTTPHEADER, $lv_hdr);        
    
		// agrego parametros data como POST
		if( count($lp_prm['data']??array())>0 ){
			$lv_datstr = http_build_query($lp_prm['data']);
			curl_setopt($lo_cur, CURLOPT_POST, 1);
			curl_setopt($lo_cur, CURLOPT_POSTFIELDS, $lv_datstr );
		}
		
		// ejecuto llamada
		if( !$lo_rs=curl_exec($lo_cur)){
      trigger_error(curl_error($lo_cur));
    }
		
		// verifico respuesta de llamada
    $lv_stscod = curl_getinfo($lo_cur, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
      //$lv_ret['data'] = json_decode($lo_rs,true);
      $lv_ret = json_decode($lo_rs,true);
    }else{
			$lv_ret = array('errtyp'=>'E','errcod'=>$lv_stscod,'errtxt'=>'Server Response:'. $lv_stscod);
    }
		
		// cierro llamada
    curl_close($lo_cur);
		
		// devuelvo resultado
    return $lv_ret;
	}
	
	
	
	// fieldsToExternal
	// convierte los datos con nombres de campo internos a un array con nombres de campo externos
	// recibe: array con datos del proceso
	//				 json con mapeo de campos api-internos
	// devuelve: array con datos y nombres de campo api: data2 = array(id: 632, material.:[id: 400, description: 'nombre', ...] material.description: '', material.id:)
  // 
  private function fieldsToExternal( $lp_dat, $lp_map=array() ){
		$lv_retdat = array();
		
		// si existen campos definidos, usar y mostrar solo los que tengan una X en la salida
		if(count($lp_map)==0){
			return array('errtyp'=>'E','errcod'=>'-5','errtxt'=>'No hay campos de salida configurados en la API.');
		}		
		
		// realiza mapeo
		foreach($lp_dat as $lv_rowdat){
			$lv_tmp = array();
			foreach($lv_rowdat as $lv_key=>$lv_val){
				// sub-estructura
				if(is_array($lv_val)){
					$lv_outarrfld = $this->getApiField( $lp_map, $lv_key ); // busco nombre de array de salida
          if( $lv_outarrfld != NULL ){
            $lv_outarrfld = explode( '.', $lv_outarrfld )[0]; // me quedo solo con el nombre del campo sin el punto
            $lv_tmp[ $lv_outarrfld ] = array(); // agrego array de salida
            foreach($lv_val as $lv_arrrowdat){	// recorro los registros del array
              $lv_arrtmp = array(); //creo array temporal
              foreach($lv_arrrowdat as $lv_arrkey=>$lv_arrval){ // recorro los campos de cada fila
								$lv_outfld = $this->getApiField( $lp_map, $lv_key.'.'.$lv_arrkey ); // busco nombre del campo de salida solo si existe un mapeo para dicho campo.
                if( $lv_outfld != NULL ){
                  $lv_outfld = explode('.', $lv_outfld)[1];	// me quedo solo con el nombre del campo sin la estructura
                  $lv_arrtmp[ $lv_outfld ] = $lv_arrval; // asigno el valor del campo interno al campo de salida dentro del array temporal (array[array_campo_salida] = array_valor_salida)
                }
              }
              $lv_tmp[ $lv_outarrfld ][] = $lv_arrtmp;	// asigno array temporal al array de salida: array[campo_salida] = [array[array_campo_salida] = array_valor_salida], [array[array_campo_salida] = array_valor_salida], ...
            }
          }
				// campo directo
				} else {
					$lv_outfld = $this->getApiField( $lp_map, $lv_key ); // busco nombre del campo de salida
					if ($lv_outfld != NULL){ // si existe mapeo para el campo
            $lv_tmp[ $lv_outfld ] = $lv_val; // asigno valor del campo interno al campo de salida
          }
				}
			}
      if (count($lv_tmp) != 0){
        $lv_retdat[] = $lv_tmp;
      }
		}
		return $lv_retdat;
  }
  
	// devuelve el campo interno basado en un campo de api
	private function getApiField( $lp_map, $lp_fld, $lp_outflg='x' ){
		foreach($lp_map as $lv_row){
			$lv_apifld = strtolower($lv_row['fldmapapifld']??'');
			$lv_tmsfld = strtolower($lv_row['fldmapfldcod']??'');
			// si el campo interno NO tiene alias
			// o es parte de una sub-estructura (se comprueba por el campo de salida)
			// entonces no tiene alias y se asigna directamente
      if ( stripos($lv_tmsfld,'.')===false || stripos($lv_apifld,'.')!=false ){
        $lv_tmsfld2 = $lv_tmsfld;
      } else{
        $lv_tmsfld2 = explode('.', $lv_tmsfld)[1];
      }
			if( strtolower($lv_row['fldmapout']??'')==$lp_outflg && $lp_fld==$lv_tmsfld2){
				return $lv_apifld;
				break;
			}
		}		
	}
	
  
	/* getIncompleteRequiredFields
	 		Si no se recibieron datos, devuelve todos los campos requeridos (siempre con el nombre de campo de api).
    	Si se recibieron datos, devuelve todos los campos requeridos que no cumplen que:
            Directos (ej.: docsts): fueron especificados y no están vacíos (como string)
            Tipo array (material.): fue especificado y contiene al menos una fila (sin importar los campos de c/fila)
            Campo de array (material.quantity): si existe alguna fila en el array, en c/fila fue especificado y no está vacío (como string)
  
	   recibe: array con datos recibidos
	  				 json con mapeo de campos api-internos
	   devuelve: array con nombres de campo de api
  */
  private function getIncompleteRequiredFields($lp_dat, $lp_map){
  	// Obtener campos requeridos
    $lv_reqfld_arr = [];
    foreach($lp_map as $lv_row){
    	if(strtolower($lv_row['fldmapin']??'')=='x' && strtolower($lv_row['fldmapreq']??'')=='x' && $lv_row['fldmapapifld']){
        $lv_reqfld_arr[$lv_row['fldmapapifld']] = '';
      }
    }
    
    if(count($lv_reqfld_arr) && !count($lp_dat)){
      return $lv_reqfld_arr;
    }
    
    // Recorre cada uno de los campos/valores recibidos para buscar los requeridos que estén incompletos
    foreach($lv_reqfld_arr as $lv_keyreq=>$lv_rowreq){
      if(isset($lv_reqfld_arr[$lv_keyreq])){
        if(strpos($lv_keyreq, '.') === false){
          if(isset($lp_dat[$lv_keyreq]) && $lp_dat[$lv_keyreq] !== ''){
            unset($lv_reqfld_arr[$lv_keyreq]);
          }
        }else{
          $lv_arrnme = substr($lv_keyreq, 0, strpos($lv_keyreq, '.'));
          $lv_valarr = json_decode(html_entity_decode($lp_dat[$lv_arrnme]??'[]'), true);
          $lv_valarr = is_array($lv_valarr) ? $lv_valarr : array();
          if($lv_keyreq == $lv_arrnme.'.'){
            if(count($lv_valarr)){
              unset($lv_reqfld_arr[$lv_keyreq]);
            }
          }else{
            // Obtengo todos los campos requeridos en las filas del array
            $lv_rowfldreq_arr = [];
          	foreach($lv_reqfld_arr as $lv_keyreq2=>$lv_rowreq2){
              if(str_starts_with($lv_keyreq2, $lv_arrnme.'.') && $lv_keyreq2 != $lv_arrnme.'.'){
                $lv_rowfld = substr($lv_keyreq2, strpos($lv_keyreq2, '.')+1);
                $lv_rowfldreq_arr[$lv_rowfld] = 0;
              }
            }
            
            if(!count($lv_valarr)){
             foreach($lv_rowfldreq_arr as $lv_reqfld=>$lv_row){
               unset($lv_reqfld_arr[$lv_arrnme.'.'.$lv_reqfld]);
             }
            }else{
              foreach($lv_valarr as $lv_arrrow){	//por cada fila verifico los campos requeridos
                foreach($lv_rowfldreq_arr as $lv_reqfld=>$lv_row){
                  if(isset($lv_arrrow[$lv_reqfld]) && $lv_arrrow[$lv_reqfld] !== ''){
                    $lv_rowfldreq_arr[$lv_reqfld]++;
                  }
                }
              }
              
              foreach($lv_rowfldreq_arr as $lv_reqfld=>$lv_numrowok){
              	if($lv_numrowok == count($lv_valarr)){
               		unset($lv_reqfld_arr[$lv_arrnme.'.'.$lv_reqfld]);
                }
              }
          	}
          }
        }
      }
    }
    
    return $lv_reqfld_arr;
  }
  
  // fieldsToInternal_json
	// convierte los datos recibidos con nombres de campo de api en nombres de campos internos. 
  // Las subestructuras las convierte a json
	// recibe: array con datos recibidos
	//				 json con mapeo de campos api-internos
	// devuelve: array con datos y nombres de campo internos
  private function fieldsToInternal_json( $lp_dat, $lp_map=array(), $lp_is_order=false ){
    $lv_retdat = array();
		// Verfica si hay campos para mapear
    if( count($lp_map)==0 ){
			return array('errtyp'=>'E', 'errcod'=>'-6', 'errtxt'=>'Falta configuración del sistema. Consultar con el administrador.');
		}
    
    // Verifica campos requeridos
    $lv_incfld_arr = $this->getIncompleteRequiredFields($lp_dat, $lp_map);
    if(count($lv_incfld_arr)){
      $lv_incfld_str = ''; // Armo mensaje
      foreach($lv_incfld_arr as $lv_incfld=>$lv_row){
        $lv_incfld_str .= ($lv_incfld_str?', ':'').$lv_incfld;
      }
      return array('errtyp'=>'E', 'errcod'=>'-7', 'errtxt'=>'El o los siguientes campos requeridos están incompletos: '.$lv_incfld_str); 
    }
    
		// Recorre cada uno de los campos/valores enviado por el usuario
		foreach($lp_dat as $lv_key=>$lv_val){
      foreach($lp_map as $lv_row){
        // Revisa si el campo de entrada es un array, revisando si el campo API tiene un punto al final.
        if($lv_key.'.' == ($lv_row['fldmapapifld']??'')){
          // Es json => Reemplazo los nombres de las keys
         	try {
           	$lv_valarr = json_decode(html_entity_decode($lv_val), true, 512, JSON_THROW_ON_ERROR);
            if(is_array($lv_valarr) && count($lv_valarr)){
              $lv_newval_arr = array();
              foreach($lv_valarr as $lv_arrrow){
                $lv_newrow = array();
                foreach((array) $lv_arrrow as $lv_keyrow=>$lv_valrow){
                  $lv_tmsfld = explode('.', $this->getTmsField( $lp_map, $lv_key.'.'.$lv_keyrow ))[1];
									$lv_newrow[$lv_tmsfld] = $lv_valrow;
                }
                $lv_newval_arr[] = $lv_newrow;
              }
              
              $lv_val = json_encode($lv_newval_arr);
            }else{
              throw new Exception('El json no es un array o bien está vacío');
            }
          } catch (JsonException | Exception $e) {
      			return array('errtyp'=>'E', 'errcod'=>'-8', 'errtxt'=>'Hubo un error al convertir el campo json: '.$lv_key); 
          }
          
          $lv_retdat[ $this->getTmsField( $lp_map, $lv_key.'.' ) ] = $lv_val; 
        	break;
        } else if( $lv_key == ($lv_row['fldmapapifld']??'') ){
          // CAMPO. mapeo de campos
					$lv_retdat[ $this->getTmsField($lp_map,$lv_key) ] = $lv_val;
          break;
        }				
			}
		} 
    
    foreach($lv_retdat as $lv_retfld=>$lv_retval){ // Recorre el array de salida y elimina el elemento que contiene el array de entrada sin mapear.
      if($lv_retfld == ""){ unset($lv_retdat[$lv_retfld]); }
    }
		return $lv_retdat;
  }
  
	// devuelve el campo interno basado en un campo de api
	private function getTmsField( $lp_map, $lp_fld, $lp_inflg='x' ){
		foreach($lp_map as $lv_row){
			$lv_apifld = strtolower($lv_row['fldmapapifld']??'');
			$lv_tmsfld = strtolower($lv_row['fldmapfldcod']??'');
			if( strtolower($lv_row['fldmapin']??'')==$lp_inflg && $lp_fld==$lv_apifld){
				return $lv_tmsfld;
				break;
			}
		}		
	}
  
	// fieldsToInternal
	// convierte los datos recibidos con nombres de campo de api en nombres de campos internos
  // Las subestructuras las convierte a <row>...</row>
	// recibe: array con datos recibidos
	//				 json con mapeo de campos api-internos
	// devuelve: array con datos y nombres de campo internos
  private function fieldsToInternal( $lp_dat, $lp_map=array(), $lp_is_order=false ){
    $lv_retdat = array();
		// Verfica si hay campos para mapear
    if( count($lp_map)==0 ){
			return array('errtyp'=>'E', 'errcod'=>'-6', 'errtxt'=>'Falta configuración del sistema. Consultar con el administrador.');
		}
    
    // Verifica campos requeridos
    $lv_incfld_arr = $this->getIncompleteRequiredFields($lp_dat, $lp_map);
    if(count($lv_incfld_arr)){
      $lv_incfld_str = ''; // Armo mensaje
      foreach($lv_incfld_arr as $lv_incfld=>$lv_row){
        $lv_incfld_str .= ($lv_incfld_str?', ':'').$lv_incfld;
      }
      return array('errtyp'=>'E', 'errcod'=>'-7', 'errtxt'=>'El o los siguientes campos requeridos están incompletos: '.$lv_incfld_str); 
    }

		// Recorre cada uno de los campos/valores enviado por el usuario
		foreach($lp_dat as $lv_key=>$lv_val){
      foreach($lp_map as $lv_row){
        // Revisa si el campo de entrada es un array, revisando si el campo API tiene un punto al final.
        if($lv_key.'.' == ($lv_row['fldmapapifld']??'')){
          $lv_buffer = "";
          $lv_valarr = json_decode(html_entity_decode($lv_val), true);
					foreach($lv_valarr as $lv_arrrow){ // Recorre el array de entrada y mapea elemento por elemento en una estructura de tags entre un <row></row>.
						$lv_buffer .= '<row>';
						foreach((array) $lv_arrrow as $lv_keyrow=>$lv_valrow){ // Crea la estructura de tags y va agregando los elementos uno por uno.
							$lv_tmsfld = explode('.', $this->getTmsField( $lp_map, $lv_key.'.'.$lv_keyrow ))[1];
							$lv_buffer.='<'.$lv_tmsfld.'>'.$lv_valrow.'</'.$lv_tmsfld.'>';
						}
						$lv_buffer .= '</row>';
					}
          $lv_retdat[ $this->getTmsField( $lp_map, $lv_key.'.' ) ] = $lv_buffer; // Asigna buffer al array de salida en la posición del campo interno correspondiente al array.
        	break;
        } else if ( $lv_key == ($lv_row['fldmapapifld']??'') ){    
          // CAMPO. mapeo de campos
					$lv_retdat[ $this->getTmsField($lp_map,$lv_key) ] = $lv_val;
          break;
        }				
			}
		} 
    foreach($lv_retdat as $lv_retfld=>$lv_retval){ // Recorre el array de salida y elimina el elemento que contiene el array de entrada sin mapear.
      if($lv_retfld == ""){ unset($lv_retdat[$lv_retfld]); }
    }
		return $lv_retdat;
  }

	// convertFieldsToInternal
	// convierte un array cuyos valores son nombres de campos de api en campos internos
	// recibe: array con nombres de campos de api
	//				 json con mapeo de campos api-internos
	// devuelve: array con nombres de campo internos
  private function convertFieldsToInternal( $lp_arr, $lp_map, $lp_is_order=false ){
    $lv_retdat = array();
		
		// verfica si hay campos para mapear
    if($lp_map==''){
			return array('errtyp'=>'E', 'errcod'=>'-6', 'errtxt'=>'Falta configuración del sistema. Consultar con el administrador.');
		}
		
		// realiza mapeo
		$lv_apiarr = json_decode(html_entity_decode($lp_map),true);
		foreach($lv_apiarr as $lv_row){
			if( isset($lv_row['fldmapin']) && $lv_row['fldmapin']!='' ){
				$lv_apifld = strtolower($lv_row['fldmapapifld']);
				$lv_tmsfld = strtolower($lv_row['fldmapfldcod']);
				
				foreach($lp_arr as $lv_key=>$lv_val){
					if($lv_val==$lv_apifld){
						$lv_retdat[] = $lv_tmsfld; break;
					} else if($lp_is_order==true && $lv_val==$lv_apifld.'_desc') {
						$lv_retdat[] = $lv_tmsfld.' desc'; break;
					}
				}

			}
		}	
		return $lv_retdat;
  }
}
?>