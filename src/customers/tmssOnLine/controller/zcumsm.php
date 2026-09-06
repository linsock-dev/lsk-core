<?php
final class zcumsmController extends tmssController {
	const MODEL = 'zcumsm';
	const VIEW  = 'zcumsm';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {
    header('Access-Control-Allow-Origin: https://temasis.ar');	//IMPORTANTE: PERMITE CONEXIÓN CON EL SERVIDOR TEMASIS.AR
    

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    if($lp_act != 'temasis.ar.getnws' && $lp_act != 'temasis.ar.lstnws' && $lp_act != 'temasis.ar.getimg'){
      $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
 
    }
		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;

    switch( $lp_act ) {
			
			
			// ----------------------------------------------------------------------
			//
			//    I N T E R F A Z 
			//
			// ----------------------------------------------------------------------
			
			
			// INTERFAZ - CARGA EMPLEADOS
			case '#itzemp':
        $lo_obj = new stdClass();
        $lo_obj->sysdoccls = '';
        
				// empleados
				$lo_empmdl = $this->co_reg->load->model('hhremp');
        $lv_emp_rs = $lo_empmdl->getList(array(), null, null, false);
        $lv_emp = array();
        foreach($lv_emp_rs as $lv_row){
          $lv_emp[] = array(
            'hhrempcod' => $lv_row['hhrempcod'],
            'hhrempcodext' => $lv_row['hhrempcodext'],
            'hhremptxt' => utf8_encode($lv_row['hhremptxt']),
            'sysdocclscod' => $lv_row['sysdocclscod'],
            'docsts' => $lv_row['docsts']  
          );
        }
				$lo_obj->emp = $lv_emp;
        
				// clase de documento de cargo
				$lo_asgclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_prm = array('vewfldflt' => '[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'HHR_CHA'.chr(9).chr(9).
                       									'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_obj->asgcls = $lo_asgclsmdl->getList($lv_prm);
        
				// tipos de cargos
				$lo_chrtypmdl = $this->co_reg->load->model('hhrchrtyp');
        $lv_chrtyp_rs = $lo_chrtypmdl->getList();
        $lv_chrtyp = array();
        foreach($lv_chrtyp_rs as $lv_row){
          $lv_chrtyp[] = array(
            'hhrchrtypcod' => $lv_row['hhrchrtypcod'],
            'hhrchrtyptxt' => utf8_encode($lv_row['hhrchrtyptxt'])
          );
        }
				$lo_obj->chrtyp = $lv_chrtyp;
        
        // cargos
				$lo_chrmdl = $this->co_reg->load->model('hhrchrasg');
        $lv_prm = array('vewfldflt' => '[~fltrow~]ca.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lv_chr_rs = $lo_chrmdl->getList($lv_prm, null, null, false);
        $lv_chr = array();
        foreach($lv_chr_rs as $lv_row){
          $lv_chr[] = array(
            'hhrchrasgcod' => $lv_row['hhrchrasgcod'],
            'hhrempcod' => $lv_row['srcobjcod'],
            'hhrchrtypcod' => $lv_row['hhrchrtypcod'],
            'chrclscod' => $lv_row['sysdocclscod'],
            'hhrchrasgdtestr' => $lv_row['hhrchrasgdtestr']->format('d/m/Y')
          );
        }
        $lo_obj->chr = $lv_chr;
        
				return $this->co_reg->document->getView( 'zcumsm_itzemp', array('data'=>$lo_obj) );
      	break;
        
        
      // GRABADO - CARGA EMPLEADOS
			case '#itzemp00':
				$lo_post = $this->co_reg->request->post;
        $lv_buffer = $lo_post['hhremp'];
        
        if($lv_buffer){
          $lo_empmdl = $this->co_reg->load->model('hhremp');
					$lo_asgclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_chrtypclsmdl = $this->co_reg->load->model('hhrchrcls');
          $lo_chrasgmdl = $this->co_reg->load->model('hhrchrasg');
          $lo_chrtypmdl = $this->co_reg->load->model('hhrchrtyp');
          
          // obtener clase de tipo de cargo
        	$lv_prm = array('vewfldflt' => '[~fltrow~]c.hhrchrclstxt'.chr(9).'='.chr(9).chr(9).'GENERAL'.chr(9).chr(9).
                       									'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
          $lv_chrtypcls_arr = $lo_chrtypclsmdl->getList($lv_prm);
          $lv_chrtypclscod = 0;
          if(count($lv_chrtypcls_arr)){
            $lv_chrtypclscod = $lv_chrtypcls_arr[0]["hhrchrclscod"];
          }else{
            $lv_chrtypcls = array('hhrchrclstxt'=>'GENERAL', 
                                  'doscts'=>'A');
            if($lo_chrtypclsmdl->save($lv_chrtypcls)){
              $lv_chrtypclscod = $lo_chrtypclsmdl->hhrchrclscod;
            }else{
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_chrtypclsmdl->errtyp,'errcod'=>$lo_chrtypclsmdl->errcod,'errtxt'=>$lo_chrtypclsmdl->errtxt) );
            }
          }
          
          $lv_emplst = json_decode( html_entity_decode($lv_buffer), true );	
          $lv_newchrtyp_arr = array();
          $lv_newasgcls_arr = array();
          $lv_newchr_arr = array();
          
          foreach($lv_emplst as $lv_emp){
            
            if($lv_emp['hhrempcod'] && !$lv_emp['chrcod']){
            
            	$lv_emp['lndcod'] = 'AR';
              
              // grabar empleado
            	if(!$lo_empmdl->save($lv_emp, false)){
        				return $this->co_reg->document->getJson( array('errtyp'=>$lo_empmdl->errtyp,'errcod'=>$lo_empmdl->errcod,'errtxt'=>$lo_empmdl->errtxt) );
            	}  
            
              // grabar tipo de cargo
              if(!$lv_emp['hhrchrtypcod']){
              	$lv_hhrchrtypcod = array_search($lv_emp['hhrchrtyptxt'], $lv_newchrtyp_arr);
                
                if($lv_hhrchrtypcod){
                  $lv_emp['hhrchrtypcod'] = $lv_hhrchrtypcod;
                }else{
                  $lv_chrtyp = array('hhrchrtypcod' => $lv_emp['hhrchrtypcod'],
                                    'hhrchrtyptxt' => $lv_emp['hhrchrtyptxt'],
                                     'hhrchrclscod'=> $lv_chrtypclscod,
                                    'docsts' => 'A');
                  
                  if($lo_chrtypmdl->save($lv_chrtyp)){
                    $lv_emp['hhrchrtypcod'] = $lo_chrtypmdl->hhrchrtypcod;
                    $lv_newchrtyp_arr[$lo_chrtypmdl->hhrchrtypcod] = $lv_emp['hhrchrtyptxt'];
                  }else{
                    return $this->co_reg->document->getJson( array('errtyp'=>$lo_chrtypmdl->errtyp,'errcod'=>$lo_chrtypmdl->errcod,'errtxt'=>$lo_chrtypmdl->errtxt) );
                  }
                }
              }
            
              // grabar clase de doc. de cargo
              if(!$lv_emp['chrclscod']){
              	$lv_chrclscod = array_search($lv_emp['chrclstxt'], $lv_newasgcls_arr);
                
                if($lv_chrclscod){
                  $lv_emp['chrclscod'] = $lv_chrclscod;
                }else{
                  $lv_asgcls = array('sysdocclscodext' => $lv_emp['chrclscodext'],
                                    'sysdocclstxt' => $lv_emp['chrclstxt'],
                                     'objtyp' => 'HHR_CHA',
                                     'sysdocclsatr' => '<srcobjtyp>HHR_EMP</srcobjtyp>',
                                     'docsts' => 'A');
                  
                  if($lo_asgclsmdl->save($lv_asgcls)){
                    $lv_emp['chrclscod'] = $lo_asgclsmdl->sysdocclscod;
                    $lv_newasgcls_arr[$lo_asgclsmdl->sysdocclscod] = $lv_emp['chrclstxt'];
                  }else{
                    return $this->co_reg->document->getJson( array('errtyp'=>$lo_asgclsmdl->errtyp,'errcod'=>$lo_asgclsmdl->errcod,'errtxt'=>$lo_asgclsmdl->errtxt) );
                  }
                }
              }
              
            	// grabar cargo de empleado
              $lv_chrasg = array('hhrchrtypcod' => $lv_emp['hhrchrtypcod'],
                                 'srcobjtyp' => 'HHR_EMP',
                                 'srcobjcod' => $lv_emp['hhrempcod'],
                                 'hhrchrasgdtestr' => $lv_emp['hhrempinbdte'],
                                 'sysdocclscod' => $lv_emp['chrclscod'],
                                 'docsts' => 'A');
              
              if(array_search($lv_chrasg, $lv_newchr_arr) === false){
              	$lv_newchr_arr[] = $lv_chrasg;
                if(!$lo_chrasgmdl->save($lv_chrasg, false)){
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_chrasgmdl->errtyp,'errcod'=>$lo_chrasgmdl->errcod,'errtxt'=>$lo_chrasgmdl->errtxt) );
                } 
              }
            }
          }
        }
        
      	break;  
        
			
			// INTERFAZ - CARGA PERSONAL
			case '#itzpersonal':
				$lo_mdl = $this->co_reg->load->model('hhrorgcht');
        
				// lugares de trabajo
				$lo_plcmdl = $this->co_reg->load->model('hhrwrkplc');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_mdl->plclst = $lo_plcmdl->getList( $lv_prm, null, null, false );
			
				// horarios
				$lo_tmemdl = $this->co_reg->load->model('hhrtmerng');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]tr.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_mdl->tmelst = $lo_tmemdl->getList( $lv_prm );
        
				// empleados
				$lo_empmdl = $this->co_reg->load->model('hhremp');
				$lo_mdl->emplst = $lo_empmdl->getList( array(), null, null, false );

				// puestos de trabajo
				$lo_wrkstemdl = $this->co_reg->load->model('hhrwrkste');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_mdl->wrkste = $lo_wrkstemdl->getList( $lv_prm );
        
        
        // cargo horarios de empleados
        $lo_emptmemdl = $this->co_reg->load->model('hhremptme');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_mdl->emptme = $lo_emptmemdl->getList( $lv_prm );
        
        
				return $this->co_reg->document->getView( 'zcumsm_itzper', array('data'=>$lo_mdl) );
      	break;
        
        
        
      // GRABADO - CARGA PERSONAL
			case '#itzpersonal00':
				$lo_post = $this->co_reg->request->post;
        $lv_hhrorgchtcod = isset($lo_post['hhrorgchtcod']) ? $lo_post['hhrorgchtcod'] : (isset($lp_prm['hhrorgchtcod']) ? $lp_prm['hhrorgchtcod'] : '');
        $lv_buffer = $lo_post['hhrmsm'];
        
        if($lv_buffer && $lv_hhrorgchtcod){
          $lo_sysint = $this->co_reg->load->model('sysint');
          
          // cargo interfaz
          $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'MSM CARGA'.chr(9).chr(9),'vewmaxrec' => '1');
					$lo_rs = $lo_sysint->getList( $lv_prm );
          if( count($lo_rs)==0 ){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1001,'errtxt'=>'No se encontro una interfaz con codigo externo [MSM CARGA].') );
          }else{
            if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1002,'errtxt'=>'No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']') );
            }
          }
          
          // cargo datos de la tabla
          $lv_buffer = json_decode( html_entity_decode($lv_buffer), true );	
          $lo_plcmdl = $this->co_reg->load->model('hhrwrkplc');
          $lo_tmemdl = $this->co_reg->load->model('hhrtmerng');
          $lo_empmdl = $this->co_reg->load->model('hhremp');
        	$lo_emptmemdl = $this->co_reg->load->model('hhremptme');
          $lo_wrkstemdl = $this->co_reg->load->model('hhrwrkste');
          $lo_orgwrkmdl = $this->co_reg->load->model('hhrorgchtwrk');
          $lv_org = array();
          $lv_emp = array();
          $lv_tme = array();
          $lv_plc = array();
          $lv_dpto = array();
          $lv_srv = array();
          $lv_fnc = array();
          $lv_empsysdocclscod = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'emp_sysdocclscod');
          $lv_wkpsysdocclscod = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'wkp_sysdocclscod');
          
          foreach($lv_buffer as $lv_row){
            $lv_empststxt = $lv_row['estado'] ? strtoupper($lv_row['estado']) : 'A';
            $lv_empdocsts = $lv_empststxt == 'BAJA' || strpos($lv_empststxt, 'PASE')!==false || $lv_empststxt == 'RENUNCIO' || $lv_empststxt == 'RENUNCIA'  ? 'I' : 'A';
            
            // grabo empleado
            if($lo_post['updemp'] && !$lv_row['hhrempcod']){
              $lv_hhrempcod = array_search($lv_row['hhrempcodext'], $lv_emp);
              
              // recupero el id si ya lo tengo
              if($lv_hhrempcod){
                $lv_row['hhrempcod'] = $lv_hhrempcod;
              }else{
                if($lo_empmdl->save(array('hhrempcodext' => $lv_row['hhrempcodext'], 'hhremptxt' => $lv_row['hhremptxt'], 'docsts'=>$lv_empdocsts, 'sysdocclscod'=>$lv_empsysdocclscod), false)){
                  $lv_row['hhrempcod'] = $lo_empmdl->hhrempcod;
                  $lv_emp[$lo_empmdl->hhrempcod] = $lv_row['hhrempcodext'];
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_empmdl->errtyp,'errcod'=>$lo_empmdl->errcod,'errtxt'=>$lo_empmdl->errtxt) );
                }
              }
            }
            
            // grabo lugar
            if($lo_post['updplc'] && !$lv_row['wrkplccod']){
              $lv_wrkplccod = array_search($lv_row['wrkplctxt'], $lv_plc);
              // recupero el id si ya lo tengo
              if($lv_wrkplccod){
                $lv_row['wrkplccod'] = $lv_wrkplccod;
              }else{
                if($lo_plcmdl->save(array('wrkplctxt' => $lv_row['wrkplctxt'], 'docsts'=>'A', 'sysdocclscod'=>$lv_wkpsysdocclscod), false)){
                  $lv_row['wrkplccod'] = $lo_plcmdl->wrkplccod;
                  $lv_plc[$lo_plcmdl->wrkplccod] = $lv_row['wrkplctxt'];
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_plcmdl->errtyp,'errcod'=>$lo_plcmdl->errcod,'errtxt'=>$lo_plcmdl->errtxt) );
                }
              }
            } 
            
            // grabo horario
            if($lo_post['updtme'] && !$lv_row['hhrtmerngcod']){
              $lv_hhrtmerngtxt = $lv_row['tmeseq'].$lv_row['hhrtmerngwekhrs'].$lv_row['hhrtmerngfrq'];
              $lv_hhrtmerngcod = array_search($lv_hhrtmerngtxt, $lv_tme);
              
              // recupero el id si ya lo tengo
              if($lv_hhrtmerngcod){
                $lv_row['hhrtmerngcod'] = $lv_hhrtmerngcod;
              }else{
                if($lo_tmemdl->save(array('hhrtmerngtxt' => $lv_hhrtmerngtxt, 'hhrtmerngatr'=>json_encode($lv_row['hhrtmerngatr']), 'docsts'=>'A', 'hhrtmerngwekhrs'=>$lv_row['hhrtmerngwekhrs'], 'hhrtmerngfrq'=>$lv_row['hhrtmerngfrq'] ))){
                  $lv_row['hhrtmerngcod'] = $lo_tmemdl->hhrtmerngcod;
                  $lv_tme[$lo_tmemdl->hhrtmerngcod] = $lv_hhrtmerngtxt;
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_tmemdl->errtyp,'errcod'=>$lo_tmemdl->errcod,'errtxt'=>$lo_tmemdl->errtxt) );
                }
              }
            }
            
            // grabo departamento
            if(!$lv_row['wrkstedptocod'] && $lv_row['departamento']){
              $lv_wrkstedptocod = array_search($lv_row['departamento'], $lv_dpto);
              
              if($lv_wrkstedptocod){
                $lv_row['wrkstedptocod'] = $lv_wrkstedptocod;
              }else{
                if($lo_wrkstemdl->save(array('wrkstetxt' => $lv_row['departamento'], 'wrkstetyp'=>'D', 'docsts'=>'A' ))){
                  $lv_row['wrkstedptocod'] = $lo_wrkstemdl->wrkstecod;
                  $lv_dpto[$lo_wrkstemdl->wrkstecod] = $lv_row['departamento'];
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_wrkstemdl->errtyp,'errcod'=>$lo_wrkstemdl->errcod,'errtxt'=>$lo_wrkstemdl->errtxt) );
                } 
              }
            } 
            
            // grabo servicio
            if(!$lv_row['wrkstesrvcod'] && $lv_row['servicio']){
              $lv_wrkstesrvcod = array_search($lv_row['servicio'], $lv_srv);
              
              if($lv_wrkstesrvcod){
                $lv_row['wrkstesrvcod'] = $lv_wrkstesrvcod;
              }else{
                if($lo_wrkstemdl->save(array('wrkstetxt' => $lv_row['servicio'], 'wrkstetyp'=>'S', 'docsts'=>'A' ))){
                  $lv_row['wrkstesrvcod'] = $lo_wrkstemdl->wrkstecod;
                  $lv_srv[$lo_wrkstemdl->wrkstecod] = $lv_row['servicio'];
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_wrkstemdl->errtyp,'errcod'=>$lo_wrkstemdl->errcod,'errtxt'=>$lo_wrkstemdl->errtxt) );
                }
              }
            } 
            
            // grabo función
            if(!$lv_row['wrkstefnccod'] && $lv_row['funcion']){
              $lv_wrkstefnccod = array_search($lv_row['funcion'], $lv_fnc);
              
              if($lv_wrkstefnccod){
                $lv_row['wrkstefnccod'] = $lv_wrkstefnccod;
              }else{
                if($lo_wrkstemdl->save(array('wrkstetxt' => $lv_row['funcion'], 'wrkstetyp'=>'F', 'docsts'=>'A' ))){
                  $lv_row['wrkstefnccod'] = $lo_wrkstemdl->wrkstecod;
                  $lv_fnc[$lo_wrkstemdl->wrkstecod] = $lv_row['funcion'];
                }else{
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_wrkstemdl->errtyp,'errcod'=>$lo_wrkstemdl->errcod,'errtxt'=>$lo_wrkstemdl->errtxt) );
                }
              }
            } 
            
            // armo matriz de dpto x servicio x funcion x empleados
            $lv_dptocod = $lv_row['wrkstedptocod'];
            $lv_srvcod = $lv_row['wrkstesrvcod'];
            $lv_fnccod = $lv_row['wrkstefnccod'];
            
            if($lv_empdocsts == 'A'){
              if($lv_dptocod>0){// descarto los casos en donde no hay departamento
                if(!isset($lv_org[$lv_dptocod])){ $lv_org[$lv_dptocod] = array(); }

                if($lv_srvcod){
                  if(!isset($lv_org[$lv_dptocod]['SRV_'.$lv_srvcod])){ 
                    $lv_org[$lv_dptocod]['SRV_'.$lv_srvcod] = array(); 
                  }
                  $lv_org_fnc = &$lv_org[$lv_dptocod]['SRV_'.$lv_srvcod];
                }else{
                  $lv_org_fnc = &$lv_org[$lv_dptocod];
                }

                if($lv_fnccod){
                  if(!isset($lv_org_fnc['FNC_'.$lv_fnccod])){ 
                    $lv_org_fnc['FNC_'.$lv_fnccod] = array(); 
                  }
                  $lv_org_fnc = &$lv_org_fnc['FNC_'.$lv_fnccod];
                }
                
                $lv_row['hhremptmestr'] = isset($lv_row['hhremptmestr']) && $lv_row['hhremptmestr'] ? $lv_row['hhremptmestr'] : '01/07/2023';
                $lv_row['hhremptmestr'] = $this->co_reg->db->sqldte($lv_row, 'hhremptmestr');
                $lv_org_fnc[] = '<asgrow><hhrempcod>'.$lv_row['hhrempcod'].'</hhrempcod><hhrtmerngcod>'.$lv_row['hhrtmerngcod'].'</hhrtmerngcod><hhremptmestr>'.$lv_row['hhremptmestr'].'</hhremptmestr><wrkplccod>'.$lv_row['wrkplccod'].'</wrkplccod><wrkstepft>'.($lv_row['hhrtmerngwekhrs'] ? 1 : ($lv_row['tmeseq'] ? 1 : 0)).'</wrkstepft></asgrow>';
              }
              
            }else if($lv_row['hhremptmecod']){
              // si se le da de baja el cargo, elimino el horario
              if(!$lo_emptmemdl->delete(array('hhremptmecod' => $lv_row['hhremptmecod']))){
        				return $this->co_reg->document->getJson( array('errtyp'=>$lo_emptmemdl->errtyp,'errcod'=>$lo_emptmemdl->errcod,'errtxt'=>$lo_emptmemdl->errtxt) );        
              }
            }
        	}
          
          // recorro matriz dpto x servicio x función x asignaciones de puestos para armar tags de nodos
          $lv_nodes = '';
					
          // recorro departamentos
          foreach($lv_org as $lv_dptoid=>$lv_dpto){
            $lv_dptodata = '<row><wrkstecod>'.$lv_dptoid.'</wrkstecod>';
            $lv_asgdpto = '';
            $lv_subdata = '';

            // el dpto tiene un servicio o función
            foreach($lv_dpto as $lv_subkey => $lv_sub){
              if(strpos($lv_subkey, 'SRV')===false && strpos($lv_subkey, 'FNC')===false){ 
                // empleados asignados al dpto
                $lv_asgdpto .= $lv_sub;

              }else{
                $lv_subdata .= '<row><wrkstecod>'.explode('_',$lv_subkey)[1].'</wrkstecod>'
                              .'<wrkstehghcod>DPTO_'.$lv_dptoid.'</wrkstehghcod>';
                $lv_asgsub = '';
                $lv_subsubdata = '';

                foreach($lv_sub as $lv_subsubkey => $lv_subsub){
                  if(strpos($lv_subsubkey, 'FNC') !== false){
                    $lv_subsubdata .= '<row><wrkstecod>'.explode('_',$lv_subsubkey)[1].'</wrkstecod>'
                                    .'<wrkstehghcod>DPTO_'.$lv_dptoid.$lv_subkey.'</wrkstehghcod>'
                                    .'<asg>';
                    
                    foreach($lv_subsub as $lv_emp){
                      $lv_subsubdata .= $lv_emp;
                    }
                    
                    $lv_subsubdata .= '</asg></row>';
                    
                  }else{  
                    // empleados asignados al dpto->(servicio/función)
                    $lv_asgsub .= $lv_subsub;
                  }
                }

                // concateno los empleados al nodo actual
                if($lv_asgsub){
                  $lv_subdata.='<asg>'.$lv_asgsub.'</asg>';
                }
								
                $lv_subdata .= '</row>';
                
                // luego concateno las funciones, si las tiene
                if($lv_subsubdata){
                  $lv_subdata .= $lv_subsubdata;
                }

              }
            }

            if($lv_asgdpto){
              $lv_dptodata .= '<asg>'.$lv_asgdpto.'</asg>';
            }

            $lv_dptodata .= '</row>';
            
            if($lv_subdata){
              $lv_dptodata .= $lv_subdata;
            }

            $lv_nodes .= $lv_dptodata;
          }
          
          $lv_orgdata = array('hhrorgchtcod' =>$lv_hhrorgchtcod, 'hhrorgchtwrk'=>$lv_nodes);
          
          if(!$lo_orgwrkmdl->massiveSave($lv_orgdata)){
            return $this->co_reg->document->getJson( array('errtyp'=>$lo_orgwrkmdl->errtyp,'errcod'=>$lo_orgwrkmdl->errcod,'errtxt'=>$lo_orgwrkmdl->errtxt) );
          }
         
        }
        
        break;
		}
	}
}
?>