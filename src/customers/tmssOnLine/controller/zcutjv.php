<?php
final class zcutjvController extends tmssController {
	const VIEW  = 'zcutjv';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
 
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

 
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model('syssecusr');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			//   D A S H B O A R D
      case '#dsh':
        $lo_post = $this->co_reg->request->post;
        $lv_reqstr = '0'.chr(10).'1';
				
        if(($lo_post['typ']??'')!=''){
					$lo_cntmdl=$this->co_reg->load->model('crmcnt');
        	$lv_prm=array('vewfldflt'=>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
          switch( $lo_post['typ'] ){
          	case 'status':	// POR ESTADO
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
                									.($lo_post['vewfldflt'] ?? '');
							$lv_prm['vewfldgrp']='s.crmcntststxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
          	
            case 'recent':	// TICKETS CERRADOS (ÚLTIMOS 3 MESES AÑO ACTUAL/AÑO PASADO)
              $lv_mthfst_actyer = new DateTime('first day of this month'); //Calculo el inicio del mes actual.
              $lv_dteend_actyer = (clone $lv_mthfst_actyer)->modify('last day of this month'); //Calculo el fin del período.
              $lv_dteint = new DateInterval('P1Y'); //Creo un intervalo de un año.
              $lv_dteend_prvyer = (clone $lv_dteend_actyer)->sub($lv_dteint); //Calculo el fin del período, un año antes.
              $lv_dteint = new DateInterval('P2M'); //Actualizo el intervalo a uno de 3 meses.
              $lv_dtesrt_actyer = (clone $lv_mthfst_actyer)->sub($lv_dteint); //Calculo el inicio del período de este año.
              $lv_dtesrt_prvyer = ((clone $lv_dteend_prvyer)->sub($lv_dteint))->modify('first day of this month'); //Calculo el inicio del período del año anterior.
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9)
                									.	'[~fltrow~](c.ctedte BETWEEN ^'.$lv_dtesrt_actyer->format('Y-m-d').'^ AND ^'.$lv_dteend_actyer->format('Y-m-d').'^)'
                									.' OR (c.ctedte BETWEEN ^'.$lv_dtesrt_prvyer->format('Y-m-d').'^ AND ^'.$lv_dteend_prvyer->format('Y-m-d').'^)'.chr(9).'ZZ'.chr(9).''.chr(9).''.chr(9).chr(9);
              $lv_prm['vewfldgrp']='c.ctedte,s.crmcntststxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break; 
              
            case 'contacted':
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntststxt'.chr(9).'!='.chr(9).chr(9).'16-FIRMADO'.chr(9).chr(9)
                									.($lo_post['vewfldflt'] ?? '');
							$lv_prm['vewfldgrp']='s.crmcntststxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
              
            case 'active':	// POR USUARIOS
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'IN'.chr(9).chr(9).$lv_reqstr.chr(9).chr(9)
                										.($lo_post['vewfldflt'] ?? '');
							$lv_prm['vewfldgrp']='c.usrcod,s.crmcntststxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
              
            case 'form':	// POR AÑO DE EGRESO
							// obtengo tickets no cerrados
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
                									.($lo_post['vewfldflt'] ?? '');
							$lv_prm['vewfldgrp']='s.crmcntststxt,c.crmcntcod';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
          }

					// se obtienen registros
					$lo_rs = $lo_cntmdl->getList($lv_prm, null, null, false);

					// para reporte x año de egreso
          if ($lo_post['typ']=='form'){
						// se obtienen los ids de los tickets
						$lv_str = '';
						foreach($lo_rs as $lv_row){ $lv_str.=$lv_row['crmcntcod'].chr(10); }
						
						// se recuperan los formularios de esos tickets
						$lo_frmmdl = $this->co_reg->load->model('grldatfrmfld');
						$lv_prm2=array('vewfldflt'=>'[~fltrow~]f.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CRM_CNT'.chr(9).chr(9)
																			.'[~fltrow~]f.srcobjcod001'.chr(9).'IN'.chr(9).chr(9).$lv_str.chr(9).chr(9)
																			.'[~fltrow~]sff.sysdocfrmfldcodext'.chr(9).'='.chr(9).chr(9).'EGRESO'.chr(9).chr(9)
													);
						$lo_rsfrm = $lo_frmmdl->getList($lv_prm2,null,null);
						
						// se combinan tablas
						foreach($lo_rs as &$lv_row){
							$lv_row['egreso'] = '';
							foreach($lo_rsfrm as $lv_rowfrm){
								if($lv_row['crmcntcod']==$lv_rowfrm['srcobjcod001']){
									$lv_row['egreso'] = $lv_rowfrm['frmdatval'];
									break;
								}
							}
						}
          }

					// se devuelve resultado
					return $this->co_reg->document->getJson( $lo_rs );					
        }
				
        // RETURN. devuelve la vista con los datos
        return $this->co_reg->document->getView('zcutjv_dsh', array('data'=>$this->lo_mdl));
      	break;

			
      case '#crmcnt_withforms':
        $lo_post = $this->co_reg->request->post;
        // llamamos a la funcion de contactos con formularios
        return $this->getCrmCntWithForms($lo_post, 'INFO VIAJE', '');
        break;
        
        
      // CRM - CONTACTOS INFO VIAJE + UBICACION Y COMENTARIO
      case '#crmcnt_withforms_extend':
        $lo_post = $this->co_reg->request->post;

        // Llamamos la funcion de contactos con formularios
        $lo_rscnt = $this->getCrmCntWithForms($lo_post, 'INFO VIAJE', 'CNTFAM');
        
        $lo_crncod = array_column($lo_rscnt, 'crmcntcod');
        $lo_crncodarr = '('.implode(',', $lo_crncod).')';
        
        $lo_chgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prmchg = array ('vewfldflt' => '[~fltrow~]dc.chgdocsrctyp'.chr(9).'='.chr(9).chr(9).'CRM_CNT'.chr(9).chr(9).
                            							 '[~fltrow~]dca.chgdocatrnme'.chr(9).'='.chr(9).chr(9).'COMENTARIOS'.chr(9).chr(9).
                            							 '[~fltrow~]dc.chgdocsrccod'.chr(9).'in'.chr(9).$lo_crncodarr.chr(9).chr(9),
                          	'extra' => '<rownumber>2</rownumber>'
                    			 );
        $lo_comentarios = $lo_chgmdl->getVariousDetails($lv_prmchg);
        $lo_ultcmt = [];
        foreach ($lo_comentarios as $lv_rowcmt) {
          $lv_cod = $lv_rowcmt['chgdocsrccod'];
          $lo_ultcmt[$lv_cod] = $lv_rowcmt;
        }
        
        foreach ($lo_rscnt as &$lv_row) {
          // Año de egreso
          if (!empty($lv_row['egreso'])) {
            $lv_egreso = explode('/', $lv_row['egreso']);
            if (count($lv_egreso) === 3) {
              $lv_row['egreso'] = $lv_egreso[2];
            }
          }

          // Última fecha y comentario
          $lv_cod = $lv_row['crmcntcod'] ?? '';
          if (isset($lo_ultcmt[$lv_cod])) {
            $lv_row['chgdocatrnew'] = $lo_ultcmt[$lv_cod]['chgdocatrnew'];
            $lv_row['fecha'] = $lo_ultcmt[$lv_cod]['ctedte']->format('d/m/Y H:i');
          }
        }

        return $lo_rscnt;
        break;
        

      case '#crmcntres':
        $lv_ret = array('errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'');
        if ( trim($lp_prm['data']['usrcod']??'')!='' ) { return $lv_ret; }

				// busco usuario por default en función del ID de origen
				$lv_usrcod = $this->getDefaultUsrcod($lp_prm['data']['crmcntsrccod']??'');
				if ($lv_usrcod!=='') { $lp_prm['data']['usrcod'] = $lv_usrcod; }
        return $lv_ret;
        break;

      case '#crmcntsrcres':
        $lo_post = $this->co_reg->request->post;
				if( ($lo_post['sec']??'')!='' ){ return '/*script*/'; }
				
				// busco usuario por default en función del ID de origen
        $lv_usrcod = $this->getDefaultUsrcod($lo_post['crmcntsrccod']??'');
        $lv_ret = '/*script*/$("#'.$lo_post['sec'].' #usrcod").val("'.$lv_usrcod.'").trigger("change");';
        return $lv_ret;
        break;
		}
	}
  
	private function getDefaultUsrcod($lv_srccod) {
    // Si no hay id del cliente, devuelve vacio
    if ($lv_srccod === '') { return ''; }
    $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
    $lo_prmmdl->load(['mdlcod' => 'CRMUS']);
    $lv_str = strtoupper($lo_prmmdl->mdlatrval001); // Ejemplo: "<13;24;65>DALVAREZ</13;24;65><33>LSAMPAYO</33><62;87>RMONTANER"
		
    // Busca responsable por ID
    $lv_regex = '/<[^>]*\b'.$lv_srccod.'\b[^>]*>([^<]+)/';
    if (preg_match($lv_regex, $lv_str, $lv_match)) {
    	return $lv_match[1]; // [1] Devuelve el responsable
    }
    return '';
	}

  
  private function getCrmCntWithForms($lo_post, $lv_codext, $lv_cntcodext) {
    $lv_ret = array();

    $lv_lmtmem = ini_get('memory_limit');
    ini_set('memory_limit', '2048M');

    // OBTENGO CONTACTOS CRM
    $lo_cntmdl = $this->co_reg->load->model('crmcnt');
    if (!isset($lo_post['vewfldflt'])) {
      $lo_post['vewfldflt'] = '';
    }
    if (!isset($lo_post['vewmaxrec'])) {
      $lo_post['vewmaxrec'] = 100;
    }
    $lv_fltcntcodext = '';
    if ($lv_cntcodext != '') { $lv_fltcntcodext = '[~fltrow~]dccc.sysdocclscodext'.chr(9).'='.chr(9).chr(9).$lv_cntcodext.chr(9).chr(9); }
    $lv_prmflt = array(
      'vewfldflt' => $lo_post['vewfldflt'].'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) . $lv_fltcntcodext,
      'vewfldord' => 'c.ctedte desc',
      'vewmaxrec' => $lo_post['vewmaxrec']
    );
    $lo_crmcnt_rs = $lo_cntmdl->getlist($lv_prmflt, null, null, false);

    // obtengo todos los crmcntcod
    $lo_cntlst = array();
    foreach ($lo_crmcnt_rs as $lo_rowcnt) {
      $lv_key = $lo_rowcnt['crmcntcod'];
      if (!in_array($lv_key, $lo_cntlst)) {
        $lo_cntlst[] = $lv_key;
      }
    }

    // busco todos los formularios completados para los contactos
    $lo_datfrmmdl = $this->co_reg->load->model('grldatfrm');
    $lv_prmflt = array(
      'vewfldflt' => '[~fltrow~]srcobjcod001'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_cntlst).chr(9).chr(9),
      'vewfldord' => 'srcobjcod001'
    );
    $lo_datfrm_rs = $lo_datfrmmdl->getlist($lv_prmflt);

    $lo_frmlst = array();
    $lo_datcodlst = array();
    $lo_frmcntlst = array();

    foreach ($lo_datfrm_rs as $lo_rowfrm) {
      $lv_frm = $lo_rowfrm['sysdocfrmcod'];
      if (!in_array($lv_frm, $lo_frmlst)) {
        $lo_frmlst[] = $lv_frm;
      }

      $lv_dat = $lo_rowfrm['frmdatcod'];
      if (!in_array($lv_dat, $lo_datcodlst)) {
        $lo_datcodlst[] = $lv_dat;
      }

      $lo_frmcntlst[$lv_dat] = $lo_rowfrm['srcobjcod001'];
    }

    // DATOS CAMPOS FORMULARIOS
    $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
    $lv_prmflt = array(
      'vewfldflt' => '[~fltrow~]f.frmdatcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_datcodlst).chr(9).chr(9),
      'vewfldord' => 'f.frmdatcod'
    );
    $lo_datfld_rs = $lo_datfldmdl->getlist($lv_prmflt);

    // DEFINICION FORMULARIOS
    $lo_deffrmmdl = $this->co_reg->load->model('sysdocfrm');
    $lv_prmflt = array(
      'vewfldflt' => '[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_frmlst).chr(9).chr(9),
      'vewfldord' => 'sysdocfrmcod'
    );
    $lo_deffrm_rs = $lo_deffrmmdl->getlist($lv_prmflt);

    // DEFINICION FORMULARIOS
    $lo_deffrmmdl = $this->co_reg->load->model('sysdocfrm');
    $lv_fltcodext = '';
    if ($lv_codext != '') { $lv_fltcodext = '[~fltrow~]sysdocfrmcodext'.chr(9).'='.chr(9).chr(9).$lv_codext.chr(9).chr(9); }
    $lv_prmflt = array(
      'vewfldflt' => $lv_fltcodext .
      							 '[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_frmlst).chr(9).chr(9),
      'vewfldord' => 'sysdocfrmcod'
    );
    // DEFINICION FORMULARIOS CAMPOS
    $lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
    $lv_prmflt = array(
      'vewfldflt' => '[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_frmlst).chr(9).chr(9),
      'vewfldord' => 'sysdocfrmcod'
    );
    $lo_deffld_rs = $lo_frmfldmdl->getlist($lv_prmflt);

    $lo_rs_data = $this->getformData($lo_deffld_rs, $lo_datfrm_rs, $lo_datfld_rs);

    // UNIMOS FORMULARIOS AL CRM
    foreach ($lo_crmcnt_rs as $lo_rowcnt) {
      $lo_mrgfrmdat = array();
      foreach ($lo_rs_data as $lp_keyfrm => $lp_valcnt) {
        if ($lo_frmcntlst[$lp_keyfrm] == $lo_rowcnt['crmcntcod']) {
          $lo_mrgfrmdat = $lo_mrgfrmdat + $lp_valcnt;
        }
      }
      $lv_ret[] = $lo_rowcnt + $lo_mrgfrmdat;
    }

    return $lv_ret;
  }
  
  
  public function getformData($lp_flddef=array(),$lp_datfrm=array(),$lp_datfld=array()){
    $lv_flddeflst = array();
    /* Recorremos las definiciones de los campos*/
    foreach($lp_flddef as $lo_rowfld){
      if($lo_rowfld['sysfldinptyp']!='LABEL'){
        $lv_keyfld=$lo_rowfld['sysdocfrmfldcod'];
        $lv_flddeflst[$lv_keyfld]=array('sysfldinptyp'=>$lo_rowfld['sysfldinptyp']
                                       ,'sysdocfrmfldatr'=>array()
                                       ,'sysfrmfldcboopn'=>array()
                                       );
        $lv_fldatr = json_decode($lo_rowfld['sysdocfrmfldatr'], true);
        $lv_fldatrlst= array();
        foreach($lv_fldatr as $lo_rowatr){
          $lv_fldatrlst[$lo_rowatr['sysdocfrmfldatrcod']]=$lo_rowatr['sysdocfrmfldatrval'];
        }
        $lv_flddeflst[$lv_keyfld]['sysdocfrmfldatr']=$lv_fldatrlst;
        // DETERMINO LOS LAS OPCIONES DEL COMBO
        $lv_sysfrmfldcboopn= array();
        if($lo_rowfld['sysfldinptyp']=='COMBO'){
          $lv_sysfldinpcod='21';
          $lv_env = $this->co_reg->config->get('environmet');
          if($lv_env=='dev'){
          $lv_sysfldinpcod='23';
          }
          $lo_datcbolst=explode("\n", $lv_fldatrlst[$lv_sysfldinpcod]);//en prd es 21 por que??? //seguridad CRM
          $lv_data_sqlstm['cbo'][$lv_keyfld]['lst']=$lo_datcbolst;      
          foreach($lo_datcbolst as $lo_rowcbo){
            $lv_cboopn =explode("|", $lo_rowcbo);
             $lv_data_sqlstm['cbo'][$lv_keyfld]['opn'][]=$lv_cboopn;
            //$lv_sysfrmfldcboopn[]=$lv_cboopn;
            $lv_sysfrmfldcboopn[trim($lv_cboopn[0])]=isset($lv_cboopn[1])?trim($lv_cboopn[1]):'';
          }
          $lv_flddeflst[$lv_keyfld]['sysfrmfldcboopn']=$lv_sysfrmfldcboopn;
        }
      }
    }
    
    $lv_ret=array();
    
    //Recorro la cabecera de los formularios
    foreach($lp_datfrm as $lo_rowfrm){
      $lv_fldret=array();
      //Recorro los campos de los formularios
      foreach($lp_datfld as $lo_rowfld){
        if($lo_rowfrm['frmdatcod'] ==$lo_rowfld['frmdatcod']){
          //Pongo como key el id de la definicion de campo para el codigo de este valor
          $lv_Keyfrmfld=$lv_flddeflst[$lo_rowfld['frmdocfldcod']]['sysdocfrmfldatr']['1'];
          $lv_frmfldtyp=$lv_flddeflst[$lo_rowfld['frmdocfldcod']]['sysfldinptyp'];
          if($lv_frmfldtyp!='COMBO'){
            $lv_fldret[$lv_Keyfrmfld]=$lo_rowfld['frmdatval'];
          }else{
            $lv_val=trim($lo_rowfld['frmdatval']);
            $lv_fldret[$lv_Keyfrmfld]=isset($lv_flddeflst[$lo_rowfld['frmdocfldcod']]['sysfrmfldcboopn'][$lv_val])?$lv_flddeflst[$lo_rowfld['frmdocfldcod']]['sysfrmfldcboopn'][$lv_val]:'';
          }
        }
      }
      $lv_ret[$lo_rowfrm['frmdatcod']]=$lv_fldret;
    }
    return $lv_ret;
    
  }
}
?>