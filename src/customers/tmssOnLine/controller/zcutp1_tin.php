<?php 
final class zcutp1_tinController extends tmssController {
	const MODEL = 'zcutp1_tin';
	const VIEW  = 'zcutp1_tin';
	const ID = '';
  protected $co_reg; 
	private $lo_mdl;
  private $data = array();  
 
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		if ( $lp_act!='C1' && $lp_act!='C2' ) {
			$this->co_reg->request->post['ajax']='1';
			$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		}

		// load model
		//		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$lo_mdlevl = $this->co_reg->load->model( 'hltpatevl' );

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

    	//    D A S H B O A R D    -  R A Q U I T I S M O 
			case '#dshraq':
				$lo_post = $this->co_reg->request->post;
				$lo_data['selyth']=isset($lo_post['selyth'])?$lo_post['selyth']:'2020';
	    	$lv_dtefrm = new DateTime($lo_data['selyth']. "/01/01");
				$lv_dteto = new DateTime($lo_data['selyth']."/12/31");
				return $this->ShowDashBoard(array('ttlevltxt'=>'Aplicaciones',
																					'ttlbarra2'=>'Evolucion de Aplicaciones',
																					'ttldsh'=>'Dashboard Raquitismo',
																					'selyth'=>$lo_data['selyth'],
																					'dtefrm'=>$lv_dtefrm,
																					'dteto'=>$lv_dteto,
																					'hltdisclscod'=>'HIP',
																					'spcextcod'=>'RAQ'));
				break;
			 
			case '#dshprs':
        /*
        1 - BUSCO LAS EVOLUCIONES DEL PRESTADOR EN EL MES. 
        2 - BUSCO LAS PLANIFICACIONES EL PRESTADOR EN EL MES. 
        2.1 - ARMO UN ARRAY CON LOS PACIENNTES DE DICHAS EVOLUCIONES. 
        2.2 - ARMO UN ARRAY CON LOS ID DE LAS FECHAS DE PLANIFICACION. 
        3 - OBTENGO LAS LIQUIDACIONES CREADAS EN EL MES. 
        3.1 - OBTENGO LOS DOCUMENTOS DE CADA LIQUIDACION. 
        3.2 - OBTENGO LOS GASTOS DE CADA LIQUIDACION. 
        3.3 - OBTENGO LOS DOCUMENTOS NO PRESENTES EN NINGUNA LIQUIDACION EN EL MES. 
        3.4 - OBTENGO LOS GASTOS NO PRESENTES EN NINGUNA LIQUIDACION EN EL MES. 
        4 - OBTENGO LOS PACIENTES DE LAS PLANIFICACIONES CON EL ARRAY DEL PUNTO 2.1. 
        4.1 - ARMO UN ARRAY CON LA ASOCIACION DE CODIGO DE PACIENTE Y CLIENTE. 
        5 - OBTENGO LAS IMPUTACIONES DE LOS GASTOS DE LOS GASTOS DEL PUNTO 3.2 Y 3.4. 
        5.1 - ARMO UN ARRAY CON LA ASOCIACION DE CODIGO DE GASTO Y EL PACIENTE.
        */
        $lo_post = $this->co_reg->request->post;
        $lo_data = array();
        $lo_data['lqdcuslst']=array();
        $lo_data['prslqdsts']=array();
        $lo_data['patplnlst']=array();
        $lo_data['plnpenls']=array();
        $lo_data['impcus']=array();
        $lo_data['patcus']=array();
        $lo_data['prslqd']=array();
        $lo_data['prssub']=array(); 
        $lo_data['evllst']=array();
        $lo_data['plnlst']=array();
        $lo_data['data_sqlstm']=array();
        
        $lo_data['prscod'] = (isset($lo_post['prscod'])?$lo_post['prscod']:'');
        $lo_data['prstxt'] = (isset($lo_post['prstxt'])?$lo_post['prstxt']:'');
        
        $lo_data['plnmthyth'] = (isset($lo_post['plnmthyth']) && $lo_post['plnmthyth']!=''?$lo_post['plnmthyth']:date('m/Y'));
        $lo_data['plnyth'] = explode('/', $lo_data['plnmthyth'])[1];
        $lo_data['plnmth'] = explode('/', $lo_data['plnmthyth'])[0];
        
        $lo_data['selyth']=isset($lo_post['selyth'])?$lo_post['selyth']:$lo_data['plnyth'];
        
	    	$lv_dtefrm = new DateTime(trim($lo_data['selyth']). '/'.trim($lo_data['plnmth']).'/01');
				$lv_dteto = new DateTime(trim($lo_data['selyth']). '/'.trim($lo_data['plnmth']).'/01');
				$lv_dteto->modify('last day of this month');
        
        /*
        */
        // recupero novedades
        $lv_nws_mdl = $this->co_reg->load->model('grlnws');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]n.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_data['nws'] = $lv_nws_mdl->getList($lv_prm, null, null, false);
        $lo_data['data_sqlstm']['NWS']=$lv_nws_mdl->getsysdata('sqlstm');
        // cargo datos de cada novedad
        foreach($lo_data['nws'] as &$lv_row){
          $lv_nws_mdl->load(array('nwscod'=>$lv_row['nwscod']), false);
          $lv_row = $lv_nws_mdl->getData();
        }
        unset($lv_row);
        
        // PERMISOS: DETERMINAMOS SI EL USUARIO ES APTO PARA LA VISUALIZACION DE VARIOS PRESTADORES
        // BUSCAMOS PARAMETROS DE EMPRESA
        
        $lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'dshprsper'));
				$lo_usrcodlstlst=explode(';',$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'usrcodlst'));
        if(!in_array(strtoupper($this->co_reg->sec->usrcod),$lo_usrcodlstlst)){
          // PARAMETRO DE USUARIO: BUSCAMOS EL PRESTADOR ASOCIADO AL USUARIO
          $lv_usrprmflt= '';
          $lo_mdlusrprm = $this->co_reg->load->model('syssecusrprm');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
                                        '[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).'2'.chr(9).chr(9) );
          $lo_rsprm = $lo_mdlusrprm->getList( $lv_prm );
          $lo_data['data_sqlstm']['PRM']=$lo_mdlusrprm->getsysdata('sqlstm');
          foreach( $lo_rsprm as $lv_row ) {
             $lv_usrprmflt .= ($lv_usrprmflt==''?'':chr(10)).$lv_row['prmval']; 
          }
          $lo_data['pervewprs']=false;
        }else{
          if(!$this->co_reg->sec->hasPermission('HLT', 'PRS', '02')){
            $lo_data['pervewprs']=false;
            return $this->co_reg->document->getView('zcutp1_tindshprs', array('data'=>$lo_data, 'model' => self::MODEL, 'actcod'=>$this->data['actcod']));
          }
          $lo_data['pervewprs']=true;
          if($lo_data['prscod']==''){
            return $this->co_reg->document->getView('zcutp1_tindshprs', array('data'=>$lo_data, 'model' => self::MODEL, 'actcod'=>$this->data['actcod']));
          }
          $lo_rsprm=array('prscod'=>$lo_data['prscod']);
          $lv_usrprmflt=$lo_data['prscod'];        
        }
        
        // EVOLUCIONES
        $lo_mdlevl = $this->co_reg->load->model('hltpatevl');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).$lv_dteto->format('Y-m-d').chr(9).
              			(count($lo_rsprm)>0?('[~fltrow~]e.PrsCod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9)):''),
													'vewfldord' => 'e.evldte desc'
												);
				$lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false );
        $lo_data['data_sqlstm']['EVL']=$lo_mdlevl->getsysdata('sqlstm');
        $lo_data['evllst']=$lo_rsevl;
        
        // PLANIFICACIONES
        $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).$lv_dteto->format('Y-m-d').chr(9).
																			'[~fltrow~]pl.PrsCod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9));
        $lo_rs_pln = $lo_plndtemdl->getList($lv_prm);
        $lo_data['data_sqlstm']['PLN']=$lo_plndtemdl->getsysdata('sqlstm');
        $lo_data['plnlst']=$lo_rs_pln;
        $lo_patplnlst=array();
        $lo_plnpenlst=array();
        foreach($lo_rs_pln as $lo_rowpln){
          if(!in_array($lo_rowpln['patcod'],$lo_patplnlst)){
            $lo_patplnlst[]=$lo_rowpln['patcod'];
          }
          if($lo_rowpln['evlcod']==''){
            $lo_plnpenlst[]=$lo_rowpln['plndteid'];
          }
        }        
        $lo_data['patplnlst']=$lo_patplnlst;
        $lo_data['plnpenls']=$lo_plnpenlst;

        // CLASE DE DOCUMENTO. obtengo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = '';
        $lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).''.chr(9).'LQD_EV'.chr(9).chr(9).chr(9).
                                      '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      );
        $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
        if ( count($lv_docclsarr)>0 ) {											// si hay solo una la tomo como default
          $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
        }
        $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) );   

				// LIQUIDACIONES. obtengo liquidaciones
				$lo_prslqdmdl = $this->co_reg->load->model('hltprslqd');
				$lv_fltopt = array();
        $lo_data['prslqd']=array();
        $lo_data['prssub']=array();
        $lv_fltopt = array('vewfldflt' =>'[~fltrow~]l.PrsCod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9).
                           							 '[~fltrow~]convert(smalldatetime,dbo.gettagvalue(^strdte^,l.HltPrsLqdAtr001),103)'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).$lv_dteto->format('Y-m-d').chr(9)
                          );
				$lo_rslqd = $lo_prslqdmdl->getList( $lv_fltopt, null, null, false );
        $lo_data['data_sqlstm']['LQD'][]=$lo_prslqdmdl->getsysdata('sqlstm');
        $lo_data['prslqdsts']=array();
        foreach($lo_rslqd as $lo_rowlqd){
          $lo_data['prslqdsts'][$lo_rowlqd['hltprslqdcod']]=$lo_rowlqd['docsts'];
					
					// servicios liquidados
        	$lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltprslqdcod'.chr(9).'='.chr(9).chr(9).$lo_rowlqd['hltprslqdcod'].chr(9).chr(9) );
          $lv_prm = array('hltprslqdcod'=>$lo_rowlqd['hltprslqdcod']);
          $lo_rs = $lo_prslqdmdl->getServices( $lv_fltopt, $lv_prm );
          $lo_data['data_sqlstm']['LQD'][]=$lo_prslqdmdl->getsysdata('sqlstm');
          $lo_data['prslqd'] = array_merge($lo_data['prslqd'], $lo_rs);
					
					// gastos liquidados
          $lv_prm = array('hltprslqdcod'=>$lo_rowlqd['hltprslqdcod']);
          $lo_rs = $lo_prslqdmdl->getExpenses( $lv_fltopt, $lv_prm );
          $lo_data['data_sqlstm']['SUB'][]=$lo_prslqdmdl->getsysdata('sqlstm');
          $lo_data['prssub'] = array_merge($lo_data['prssub'], $lo_rs);
        }
        
				// servicios NO liquidados
        $lv_fltopt = array();
        $lv_prm = array('prscod'=>$lv_usrprmflt, 
												'hltprslqdstrdte'=>$lv_dtefrm->format('d/m/Y'), 
												'hltprslqdenddte'=>$lv_dteto->format('d/m/Y'), 
												'sysdocclscod'=>$lo_docclsmdl->sysdocclscod 
											 );
        $lo_rs = $lo_prslqdmdl->getOpenServices( $lv_fltopt, $lv_prm );
        $lo_data['data_sqlstm']['LQD'][]=$lo_prslqdmdl->getsysdata('sqlstm');
        $lo_data['prslqd'] = array_merge($lo_data['prslqd'], $lo_rs);
        
        // Gastos NO liquidados
        $lv_prm = array('prscod'=>$lv_usrprmflt, 
                        'hltprslqdstrdte'=>$lv_dtefrm->format('d/m/Y'), 
                        'hltprslqdenddte'=>$lv_dteto->format('d/m/Y') 
                       );
        $lo_rs = $lo_prslqdmdl->getOpenExpenses( $lv_fltopt, $lv_prm );
        $lo_data['data_sqlstm']['SUB'][]=$lo_prslqdmdl->getsysdata('sqlstm');
        $lo_data['prssub'] = array_merge($lo_data['prssub'], $lo_rs);
        $lo_data['lqdcuslst'] =array();
        
        // PACIENTES
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_rs_pat = $lo_patmdl->getList(null,null,null,false);
        $lo_data['data_sqlstm']['PAT'][]=$lo_patmdl->getsysdata('sqlstm');
        $lo_patcuslst=array();
        foreach($lo_rs_pat as $lo_rowpat){
          $lo_patcuslst[$lo_rowpat['patcod']]=$lo_rowpat['custxt'];
        }
        $lo_data['patcus']=$lo_patcuslst;
        
        // IMPUTACION DE GASTOS
        $lv_subcodlst = array();
        foreach($lo_data['prssub'] as $lo_rowsub){
          if(!in_array($lo_rowsub['refobjcod001'],$lv_subcodlst)){
          	$lv_subcodlst[]=$lo_rowsub['refobjcod001'];
          }
        }
        $lo_buyimpmdl = $this->co_reg->load->model('buyexp');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]ei.buyexpcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_subcodlst) .chr(9).chr(9) );
        $lo_rs_imp = $lo_buyimpmdl->getListImp($lv_prmflt);
        $lo_data['data_sqlstm']['IMP']=$lo_buyimpmdl->getsysdata('sqlstm');
        
        $lo_ipmcuslst = array();
        foreach($lo_rs_imp as $lo_rowimp){
          $lv_expdoccod=$lo_rowimp['buyexpdoccod'];
          $lo_ipmcuslst[$lv_expdoccod]=$lo_patcuslst[$lo_rowimp['srcobjcod001']]??'';
        }
        $lo_data['impcus']=$lo_ipmcuslst;
        return $this->co_reg->document->getView('zcutp1_tindshprs', array('data'=>$lo_data, 'model' => self::MODEL, 'actcod'=>$this->data['actcod']));
        
        break;
			case '#tinrptevl':
				$this->lo_mdl = array();
				return $this->getView( 'zcutp1_tinrptevl' );
				break;
        
      case '#tinencrpt':
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M');
        $lv_frmcodext='EST01';
        
        // BUSCO LA DEFINICION DEL FORMULARIO
        $lo_sysfrmmdl = $this->co_reg->load->model('sysdocfrm');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]sysdocfrmcodext'.chr(9).'='.chr(9).chr(9).$lv_frmcodext.chr(9).chr(9)
                       );
				$lo_rs_sysfrm = $lo_sysfrmmdl->getList( $lv_prm );
        $lv_data_sqlstm[] = $lo_sysfrmmdl->getsysdata('sqlstm');  
        $lv_sysfrmlst=array();
        foreach($lo_rs_sysfrm as $lo_frm){
          $lv_sysfrmlst[$lo_frm['sysdocfrmcodext']]=$lo_frm['sysdocfrmcod'];
        }
        
        // DEFINICION DE CAMPOS DEL FORMULARIO
        $lo_sysfrmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'='.chr(9).chr(9).$lv_sysfrmlst[$lv_frmcodext].chr(9).chr(9)
                       );
				$lo_rs_flddef = $lo_sysfrmfldmdl->getList( $lv_prm );
        $lv_data_sqlstm[] = $lo_sysfrmfldmdl->getsysdata('sqlstm');
        $lv_flddeflst = array();
				$lv_flddefflt='';
        foreach($lo_rs_flddef as $lo_rowfld){
          if($lo_rowfld['sysfldinptyp']!='LABEL'){
            $lv_keyfld=$lo_rowfld['sysdocfrmfldcod'];
          	$lv_flddefflt .= ($lv_flddefflt==''?'':chr(10)).$lv_keyfld; 
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
              $lo_datcbolst=explode("\n", $lv_fldatrlst['23']);//en prd es 21 por que???
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
        
        //FORMULARIO
        $lo_datfrmmdl = $this->co_reg->load->model('grldatfrm');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'='.chr(9).chr(9).$lv_sysfrmlst[$lv_frmcodext].chr(9).chr(9)
                       );
				$lo_rsdatfrm = $lo_datfrmmdl->getList( $lv_prm );
        $lv_data_sqlstm[] = $lo_datfrmmdl->getsysdata('sqlstm');                        
                      
        //DATOS DEL FORMULARIO
        $lo_datfrmfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]frmdocfldcod'.chr(9).'IN'.chr(9).chr(9).$lv_flddefflt.chr(9).chr(9)
                       );
        $lo_rsdatfld = $lo_datfrmfldmdl->getList( $lv_prm );
        $lv_data_sqlstm[] = $lo_datfrmfldmdl->getsysdata('sqlstm');  
        $lv_data_sqlstm[] = $lv_flddeflst;
        $lv_ret=array();
        
        foreach($lo_rsdatfrm as $lo_rowfrm){
          $lv_fldret=array();
          foreach($lo_rsdatfld as $lo_rowfld){
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
          $lv_ret[]=$lv_fldret;
        }
        
        ini_set('memory_limit', $lv_lmtmem);
        
        //return $lv_data_sqlstm;
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        return $lv_ret;
				break;
      case '#tinfrmrpt':
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
        $lv_memlmt='2048';
        ini_set('memory_limit', $lv_memlmt.'M');
        
        $lv_crmmtvls = str_replace(',',chr(10),$lp_prm['cntmtv']);
        
        /*
        //BUSCO LOS MOTIVOS (para obtener las clases de documeto de los mismos) 
        $lo_mtvmdl = $this->co_reg->load->model('crmcntmtv');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]m.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9),
													 'vewfldord' =>'m.crmcntmtvcod desc'
													);
        $lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt,null,null,false);//$lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt, null, null, false);//seguridad CRM
        $lv_data_sqlstm[]=$lo_mtvmdl->getSysData('sqlstm');       
        */
        
        //BUSCO LOS WORKFLOWS ASOCIADOS A LAS CLASES DE DOCUMETO
        $lo_clswrkmdl = $this->co_reg->load->model('sysdocclswrk');
        
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        //Filtros CONTACTOS CRM 
        if(!isset($lo_post['vewfldflt'])){
          $lo_post['vewfldflt']='';
        }
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';lr.lndregtxt;pdc.hltdisclstxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
																				 '[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9).
                           							 '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntmtvcod desc'
													);
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);//$lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt, null, null, false);//seguridad CRM
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lo_cntlst=array();
        //$lo_cntkeydata=array();
        foreach($lo_crmcnt_rs as $lo_rowcnt){
          $lv_key=$lo_rowcnt['crmcntcod'];
          if(!in_array($lv_key, $lo_cntlst)){
            $lo_cntlst[]=$lo_rowcnt['crmcntcod'];
          }
          //$lo_cntkeydata[$lv_key]=array();
        }
        
        // WORK FLOW
        $lo_wrkmdl = $this->co_reg->load->model('grldatwrk');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]dw.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_cntlst) .chr(9).chr(9).
                           							 '[~fltrow~]relsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
                           							 '[~fltrow~]dw.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'CRM_CNT'.chr(9).chr(9),
													 'vewfldord' => 'dw.srcobjcod001'
													);
        
        $lo_wrk_rs= $lo_wrkmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_wrkmdl->getSysData('sqlstm');
        $lo_wrklst=array();
        $lo_wrkcntlst=array();
        $lo_wrkcnt=array();
        foreach($lo_wrk_rs as $lo_rowwrk){
          $lv_key=$lo_rowwrk['wrkflwdatcod'];
          if(!in_array($lv_key, $lo_wrklst)){
            $lo_wrklst[]=$lo_rowwrk['wrkflwdatcod'];
          }
          $lo_wrkcntlst[$lv_key]=$lo_rowwrk['srcobjcod001'];
          $lo_wrkcnt[]=$lo_rowwrk['srcobjcod001'];
        }
        //$lv_data_sqlstm[]=$lo_wrkcntlst;
        
        //WORK FLOW STEPS
        $lo_wrkstpmdl = $this->co_reg->load->model('grldatwrkstp');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]ws.wrkflwdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrklst) .chr(9).chr(9),
													 'vewfldord' => 'ws.wrkflwdatcod'
													);        
        $lo_wrkstp_rs= $lo_wrkstpmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_wrkstpmdl->getSysData('sqlstm');
        $lo_wrkstplst=array();
        $lo_stpcntlst=array();
        foreach($lo_wrkstp_rs as $lo_rowwrkstp){
          $lv_key=$lo_rowwrkstp['wrkflwstpdatcod'];
          if(!in_array($lv_key, $lo_wrkstplst)){
            $lo_wrkstplst[]=$lv_key;
          }
          if(isset($lo_wrkcntlst[$lo_rowwrkstp['wrkflwdatcod']])){            
	          $lo_stpcntlst[$lv_key]=$lo_wrkcntlst[$lo_rowwrkstp['wrkflwdatcod']];
          }
        }
        //$lv_data_sqlstm[]=$lo_stpcntlst;
        
        //DATOS FROMULARIOS
        $lo_datfrmmdl = $this->co_reg->load->model('grldatfrm');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrkstplst) .chr(9).chr(9),
													 'vewfldord' => 'srcobjcod001'
													);
        $lo_datfrm_rs= $lo_datfrmmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfrmmdl->getSysData('sqlstm');
        $lo_frmlst=array();
        $lo_datcodlst=array();
        $lo_frmcntlst=array();
        foreach($lo_datfrm_rs as $lo_rowfrm){
          $lv_key=$lo_rowfrm['sysdocfrmcod'];
          if(!in_array($lv_key, $lo_frmlst)){
            $lo_frmlst[]=$lv_key;
          }
          
          $lv_key=$lo_rowfrm['frmdatcod'];
          if(!in_array($lv_key, $lo_datcodlst)){
            $lo_datcodlst[]=$lv_key;
          }if(isset($lo_stpcntlst[$lo_rowfrm['srcobjcod001']])){
          	$lo_frmcntlst[$lv_key]=$lo_stpcntlst[$lo_rowfrm['srcobjcod001']];
          }
        }
        //$lv_data_sqlstm[]=$lo_frmcntlst;
        
        //DATOS CAMPOS  FROMULARIOS
        $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]f.frmdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_datcodlst) .chr(9).chr(9),
													 'vewfldord' => 'f.frmdatcod'
													);
        $lo_datfld_rs= $lo_datfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfldmdl->getSysData('sqlstm');
        
        //DEFINICION FROMULARIOS 
        $lo_deffrmmdl = $this->co_reg->load->model('sysdocfrm');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffrm_rs= $lo_deffrmmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_deffrmmdl->getSysData('sqlstm');
        
        // DEFINICION FROMULARIOS CAMPOS
        $lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffld_rs= $lo_frmfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_frmfldmdl->getSysData('sqlstm');
        $lo_frmlst=array();
        
        $lo_rs_data=$this->getformData($lo_deffld_rs,$lo_datfrm_rs,$lo_datfld_rs);
        //$lv_data_sqlstm['frmdat']=$lo_rs_data;            
        
        //SE PREPARA LA SALIDA
      	foreach($lo_crmcnt_rs as $lo_rowcnt){
          //$lo_wrklst
          if(!in_array($lo_rowcnt['crmcntcod'], $lo_wrkcnt)){
            continue;
          }
          $lo_mrgfrmdat=array();
          foreach($lo_rs_data as $lp_keyfrm=>$lp_valcnt ){
            if($lo_frmcntlst[$lp_keyfrm]==$lo_rowcnt['crmcntcod']){
              $lo_mrgfrmdat=$lo_mrgfrmdat+$lp_valcnt;
            }
          }
          $lv_ret[]=$lo_rowcnt+$lo_mrgfrmdat;
        }
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        return $lv_ret;
        break;
        
      case '#tinfrmsturpt':
        $lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
        $lv_memlmt='2048';
        ini_set('memory_limit', $lv_memlmt.'M');
        
        $lv_crmmtvls = str_replace(',',chr(10),$lp_prm['cntmtv']);
        $lv_relstsls = str_replace(',',chr(10),isset($lp_prm['relsts'])?$lp_prm['relsts']:'A');
        
        /*
        // BUSCO LOS MOTIVOS (para obtener las clases de documeto de los mismos)
        $lo_mtvmdl = $this->co_reg->load->model('crmcntmtv');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]m.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9),
													 'vewfldord' =>'m.crmcntmtvcod desc'
													);
        $lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt,null,null,false);//$lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt, null, null, false);//seguridad CRM
        $lv_data_sqlstm[]=$lo_mtvmdl->getSysData('sqlstm');       
        
        */
        //BUSCO LOS WORKFLOWS ASOCIADOS A LAS CLASES DE DOCUMETO 
        
        //$lo_clswrkmdl = $this->co_reg->load->model('sysdocclswrk');
        
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        // Filtros CONTACTOS CRM  
        if(!isset($lo_post['vewfldflt'])){
          $lo_post['vewfldflt']='';
        }
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';lr.lndregtxt;pdc.hltdisclstxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
																				 '[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9).
                           							 '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntmtvcod desc'
													);
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);//$lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt, null, null, false);//seguridad CRM
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lo_cntlst=array();
        $lo_patlst=array();
        //$lo_cntkeydata=array();
        foreach($lo_crmcnt_rs as $lo_rowcnt){
          
          // Guardo una lista de los codigos de contactos CRM
          $lv_key=$lo_rowcnt['crmcntcod'];
          if(!in_array($lv_key, $lo_cntlst)){
            $lo_cntlst[]=$lo_rowcnt['crmcntcod'];
          }
          
          // Guardo una lista de los codigos de PACIENTES de los contactos CRM
          if($lo_rowcnt['crmcntsrctyp']=='HLT_PAT'){
            $lv_keypat=$lo_rowcnt['crmcntsrccod'];
            if(!in_array($lv_keypat, $lo_patlst)){
              $lo_patlst[]=$lo_rowcnt['crmcntsrccod'];
            }
          }      
        }
        
        // PACIENTES
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_patlst) .chr(9).chr(9),
													 'vewfldord' => 'p.patcod'
													);
        
        $lo_pat_rs= $lo_patmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_patmdl->getSysData('sqlstm');
        $lo_patlstinf = [];
        foreach($lo_pat_rs as $lo_rorpat){
          $lo_patlstinf[$lo_rorpat['patcod']]=$lo_rorpat;
        }
        
        // WORK FLOW 
        $lo_wrkmdl = $this->co_reg->load->model('grldatwrk');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]dw.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_cntlst) .chr(9).chr(9).
                           							 '[~fltrow~]relsts'.chr(9).'IN'.chr(9).chr(9).$lv_relstsls.chr(9).chr(9).
                           							 '[~fltrow~]dw.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'CRM_CNT'.chr(9).chr(9),
													 'vewfldord' => 'dw.srcobjcod001'
													);
        
        $lo_wrk_rs= $lo_wrkmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_wrkmdl->getSysData('sqlstm');
        $lo_wrklst=array();
        $lo_wrkcntlst=array();
        $lo_wrkcnt=array();
        foreach($lo_wrk_rs as $lo_rowwrk){
          $lv_key=$lo_rowwrk['wrkflwdatcod'];
          if(!in_array($lv_key, $lo_wrklst)){
            $lo_wrklst[]=$lo_rowwrk['wrkflwdatcod'];
          }
          if(isset($lo_rowwrk['srcobjcod001'])){
          	$lo_wrkcntlst[$lv_key]=$lo_rowwrk['srcobjcod001'];
          	$lo_wrkcnt[]=$lo_rowwrk['srcobjcod001'];
          }
        }
        //$lv_data_sqlstm[]=$lo_wrkcntlst;
        
        // WORK FLOW STEPS 
        $lo_wrkstpmdl = $this->co_reg->load->model('grldatwrkstp');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]ws.wrkflwdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrklst) .chr(9).chr(9),
													 'vewfldord' => 'ws.wrkflwdatcod'
													);        
        $lo_wrkstp_rs= $lo_wrkstpmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_wrkstpmdl->getSysData('sqlstm');
        $lo_wrkstplst=array();
        $lo_stpcntlst=array();
        foreach($lo_wrkstp_rs as $lo_rowwrkstp){
          $lv_key=$lo_rowwrkstp['wrkflwstpdatcod'];
          if(!in_array($lv_key, $lo_wrkstplst)){
            $lo_wrkstplst[]=$lv_key;
          }
          if(isset($lo_wrkcntlst[$lo_rowwrkstp['wrkflwdatcod']])){
          	$lo_stpcntlst[$lv_key]=$lo_wrkcntlst[$lo_rowwrkstp['wrkflwdatcod']];
          }
        }
        //$lv_data_sqlstm[]=$lo_stpcntlst;
        
        // DATOS FROMULARIOS 
        $lo_datfrmmdl = $this->co_reg->load->model('grldatfrm');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]srcobjcod002'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrkstplst) .chr(9).chr(9),
													 'vewfldord' => 'srcobjcod002'
													);
        $lo_datfrm_rs= $lo_datfrmmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfrmmdl->getSysData('sqlstm');
        $lo_frmlst=array();
        $lo_datcodlst=array();
        $lo_frmcntlst=array();
        foreach($lo_datfrm_rs as $lo_rowfrm){
          $lv_key=$lo_rowfrm['sysdocfrmcod'];
          if(!in_array($lv_key, $lo_frmlst)){
            $lo_frmlst[]=$lv_key;
          }
          
          $lv_key=$lo_rowfrm['frmdatcod'];
          if(!in_array($lv_key, $lo_datcodlst)){
            $lo_datcodlst[]=$lv_key;
          }
          if(isset($lo_stpcntlst[$lo_rowfrm['srcobjcod001']])){
          	$lo_frmcntlst[$lv_key]=$lo_stpcntlst[$lo_rowfrm['srcobjcod001']];
            
          }
        }
        //$lv_data_sqlstm[]=$lo_frmcntlst;
        
        // DATOS CAMPOS  FROMULARIOS 
        $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]f.frmdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_datcodlst) .chr(9).chr(9),
													 'vewfldord' => 'f.frmdatcod'
													);
        $lo_datfld_rs= $lo_datfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfldmdl->getSysData('sqlstm');
        
        // DEFINICION FROMULARIOS 
        $lo_deffrmmdl = $this->co_reg->load->model('sysdocfrm');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffrm_rs= $lo_deffrmmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_deffrmmdl->getSysData('sqlstm');
        
        // DEFINICION FROMULARIOS CAMPOS
        $lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffld_rs= $lo_frmfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_frmfldmdl->getSysData('sqlstm');
        $lo_frmlst=array();
        
        $lo_rs_data=$this->getformData($lo_deffld_rs,$lo_datfrm_rs,$lo_datfld_rs);
        //$lv_data_sqlstm['frmdat']=$lo_rs_data;            
        
        // SE PREPARA LA SALIDA
        $lv_ret= array();
      	
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        return $lv_ret;
        break;
        
			case '#tinrptevldat':
				$lo_mdlevl = $this->co_reg->load->model('hltpatevl');
				$lo_mdlrls = $this->co_reg->load->model('hltpatprsrls');
				$lo_mdlpat = $this->co_reg->load->model('hltpat');
				$lo_mdlusrprm = $this->co_reg->load->model('syssecusrprm');
				$lo_post = $this->co_reg->request->post;
				$lv_prm=array();
				$lv_patcodlst=array();
				$lv_patflt= '';
				
				$lv_usrprmflt= '';

				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]p.UsrPrmFltKey'.chr(9).'='.chr(9).chr(9).'233'.chr(9).chr(9) );
				$lo_rsprm = $lo_mdlusrprm->getList( $lv_prm );
				foreach( $lo_rsprm as $lv_row ) {
					 $lv_usrprmflt .= ($lv_usrprmflt==''?'':chr(10)).$lv_row['prmval']; 
        }				

				/* EVOLUCIONES */
				/* Filtros */					
				$lv_evlcncmtv= array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS','IN'=>'INSTITUCION','TR'=>'TRASLADO','PA'=>'PACIENTE','LSDM'=>'LSDM');
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
	    	
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );			
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';e.evlcod;e.evldte;e.patcod;e.pattxt;e.prscod;e.prstxt;e.spctxt;e.docsts;evlcncmtv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						$lv_maxrec = true;
						unset($lv_fltarrevl[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrevl[$i]);
						if ($lv_flt[1]=='EE'){
							unset($lv_fltarrevl[$i]);
							$lv_fltevlee=true;

						}elseif ($lv_flt[1]=='NE') {
							$lv_fltevlne=true;
							unset($lv_fltarrevl[$i]);
						}else{
							if ($lv_flt[0]=='evlcncmtv') {
								$lv_flt[0]= 'dbo.GetTagValue(^evlcncmtv^,evlobj)';
								$lv_fltin=array();
								foreach ($lv_evlcncmtv as $key => $value) {
									if(strpos(strtoupper($value), strtoupper($lv_flt[2]))!==false){
										$lv_fltin[]=$key;
									}
								}
								$lv_flt[1]='IN';
								$lv_flt[2]='';
								$lv_flt[3]=implode(chr(10),$lv_fltin);;
								$lv_fltarrevl[$i]=implode(chr(9),$lv_flt);
							}
						}
					}
				}
				
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):'').
																				 (count($lo_rsprm)>0?('[~fltrow~]c.cuscod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9)):''),
													'vewfldord' => 'e.evldte desc'
												);
				if($lv_maxrec==false){
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}

				$lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false );
				$lv_data_sqlstm = array();
				$lv_data_sqlstm[] = $lo_mdlevl->getsysdata('sqlstm');

				foreach($lo_rsevl as $lv_row) {
					if(!in_array($lv_row['patcod'],$lv_patcodlst)){
						array_push($lv_patcodlst,$lv_row['patcod']) ;
						$lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['patcod'];
					}
				}

				/* PACIENTES */
				/* Filtros*/
				$lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrpat)-1; $i>0; $i--){
					if(stripos(';lr.lndregtxt;pdc.hltdisclstxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
						unset($lv_fltarrpat[$i]);
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																				(count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
																				
													'vewfldord' => 'p.PatCod');
				$lo_rspat = $lo_mdlpat->getList($lv_prm, null, null, false);
				$lv_data_sqlstm[]= $lo_mdlpat->getsysdata('sqlstm');

				/*RELACION MED. DERIVADOR */
				/*Filtro*/
				$lv_fltarrmedder = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrmedder)-1; $i>0; $i--){
					if(stripos(';m.patprsrlstxt;',';'.explode(chr(9),$lv_fltarrmedder[$i])[0].';')===false){
						unset($lv_fltarrmedder[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrmedder[$i]);
						if($lv_flt[0]=='m.patprsrlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrmedder[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																			(count($lv_fltarrmedder)>0?implode('[~fltrow~]',$lv_fltarrmedder):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rls_rs = $lo_mdlrls->getList($lv_prm);
				$lv_data_sqlstm[]=$lo_mdlrls->getsysdata('sqlstm');

				/*RELACION COORDINADOR*/
				/*Filtro*/
				$lv_fltarrcoo = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrcoo)-1; $i>0; $i--){
					if(stripos(';c.patprsrlstxt;',';'.explode(chr(9),$lv_fltarrcoo[$i])[0].';')===false){
						unset($lv_fltarrcoo[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrcoo[$i]);
						if($lv_flt[0]=='c.patprsrlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrcoo[$i]=implode(chr(9),$lv_flt);
						}

					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'COORD'.chr(9).chr(9).
																			(count($lv_fltarrcoo)>0?implode('[~fltrow~]',$lv_fltarrcoo):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rlscoo_rs = $lo_mdlrls->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');
				$lo_ret= array();
				/*Evaluaciones*/
				for ($i = 0; $i < count($lo_rsevl); $i++) {
					$lv_fndpat = false;
					$lv_fndrelcoo = false;
					$lv_fndrlsder = false;
					$lo_rsevl[$i]['rlstxt'] = '';
					$lo_rsevl[$i]['rlstxtcoo'] = '';
					$lo_rsevl[$i]['hltdisclstxt'] =  '';
					$lo_rsevl[$i]['lndregtxt'] = '';
					$lo_rsevl[$i]['evldtecnv'] =$lo_rsevl[$i]['evldte']->format('d-m-Y') ;
					$lo_rsevl[$i]['evlcncmtvtxt']= $lv_evlcncmtv[$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlobj'], 'row'),'evlcncmtv')];
					/* Med. Cabecera */
					foreach($lo_rls_rs as $lv_rowrls) {
						if($lo_rsevl[$i]['patcod']==$lv_rowrls['patcod']){
							$lo_rsevl[$i]['rlstxt']=$this->co_reg->document->getTagValue($lv_rowrls['patprsrlsatr001'] , 'patprsrlstxt');
							$lv_fndrlsder = true;
							break;
						}
					}
					/* Coordinador */
					foreach($lo_rlscoo_rs as $lv_rowrls) {
						if($lo_rsevl[$i]['patcod']==$lv_rowrls['patcod']){
							$lo_rsevl[$i]['rlstxtcoo']=$this->co_reg->document->getTagValue($lv_rowrls['patprsrlsatr001'] , 'patprsrlstxt');
							$lv_fndrelcoo = true;
							break;
						}
					}
					/* Paciente */
					foreach($lo_rspat as $lv_row) {
						if($lo_rsevl[$i]['patcod']==$lv_row['patcod']){
							$lo_rsevl[$i]['hltdisclstxt'] = $lv_row['hltdisclstxt'];
							$lo_rsevl[$i]['lndregtxt'] = $lv_row['lndregtxt'];
							$lv_fndpat = true;
							break;
						}
					}
					// if(count($lv_fltarrpat)>0 && $lv_fndpat == false){continue;}
					// if(count($lv_fltarrmedder)>0 && $lv_fndrlsder == false){continue;}
					// if(count($lv_fltarrcoo)>0 && $lv_fndrelcoo == false){continue;}

					/* Filtro motivo no infusion vacio */
					if($lo_rsevl[$i]['evlcncmtvtxt']!='' && $lv_fltevlee==true ) { continue;}

					/* Filtro motivo no infusion no vacio */
					if($lo_rsevl[$i]['evlcncmtvtxt']=='' && $lv_fltevlne==true) { continue;}

					$lo_ret[]=$lo_rsevl[$i];
				}
				return $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lo_ret),'data_sqlstm'=>$lv_data_sqlstm) );
				break;
			
			// REPORTES DE EVOLUCIONES
			case '#evrpt':
        $lo_mdlusrprm = $this->co_reg->load->model('syssecusrprm');
				$lo_post = $this->co_reg->request->post;
				//$lv_prm=array();
				$lv_patflt= '';
				$lv_usrprmflt= '';
        $v_memlmt=isset($lp_prm['memlmt'])?$lp_prm['memlmt']:'2048';
        $lv_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', $v_memlmt.'M');
        //return array('mem'=>$v_memlmt);
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]p.PrmCod'.chr(9).'='.chr(9).chr(9).'4'.chr(9).chr(9) );
				$lo_rsprm = $lo_mdlusrprm->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlusrprm->getsysdata('sqlstm');
				foreach( $lo_rsprm as $lv_row ) {
          $lv_usrprmflt .= ($lv_usrprmflt==''?'':chr(10)).$lv_row['prmval']; 
        }

				/* EVOLUCIONES */
				$lo_mdlevl = $this->co_reg->load->model('hltpatevl');
				
        /* Filtros */					
				//$lv_evlcncmtv= array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS','IN'=>'INSTITUCION','TR'=>'TRASLADO','PA'=>'PACIENTE','LSDM'=>'LSDM');
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }
        $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
        $lv_dat = simplexml_load_string($lv_atrusr);
        $lv_evlcncmtv = [];
				foreach($lv_dat as $lv_key=>$lv_val){
          $lv_key= str_replace("CUS_", "", $lv_key);
         	$lv_cncmtvrow = explode(";", $lv_val);
          $lv_evlcncmtv[$lv_key]=[];
          foreach($lv_cncmtvrow as $lv_rowmtv){
            $lv_a = explode(",", $lv_rowmtv);
            $lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
          }
				}
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
	    	
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );			
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evlcod;evldtecnv;evldte;patcod;pattxt;prscod;prstxt;spctxt;docsts;evlcncmtv;cteusr;custxt;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						$lv_maxrec = true;
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evlcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcod','e.patcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('pattxt','e.pattxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','e.prscod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','e.prstxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('spctxt','e.spctxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('docsts','e.docsts',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('cteusr','e.cteusr',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('custxt','c.custxt',$lv_fltarrevl[$i]);
            
						$lv_flt=explode(chr(9),$lv_fltarrevl[$i]);
						if ($lv_flt[1]=='EE'){
							unset($lv_fltarrevl[$i]);
							$lv_fltevlee=true;
						}elseif ($lv_flt[1]=='NE') {
							$lv_fltevlne=true;
							unset($lv_fltarrevl[$i]);
						}else{
							if ($lv_flt[0]=='evlcncmtv') {
								$lv_flt[0]= 'dbo.GetTagValue(^evlcncmtv^,EVLATR001)';
								$lv_fltin=array();
                foreach ($lv_evlcncmtv as $rowMtvCus) {
                  foreach ($rowMtvCus as $key => $value) {
                    if(strpos(strtoupper($value), strtoupper($lv_flt[2]))!==false){
                      $lv_fltin[]=$key;
                    }
                  }
                }
								$lv_flt[1]='IN';
								$lv_flt[2]='';
								$lv_flt[3]=implode(chr(10),$lv_fltin);
								$lv_fltarrevl[$i]=implode(chr(9),$lv_flt);
							}
						}
					}
				}
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):'').
																				 (count($lo_rsprm)>0?('[~fltrow~]c.cuscod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9)):''),
													'vewfldord' => 'e.evldte desc'
												);
				if($lv_maxrec==false){
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
				if(isset($lp_prm['evlnotpln'])){ 
        	$lv_prmflt['vewfldflt'].='[~fltrow~]isnull(e.plnid,0)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9); 
        }
        
				$lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false); 
        $lv_sqlstm[]= $lo_mdlevl->getsysdata('sqlstm');
				$lv_patcodlst=array();
        $lv_evllst=array();
				foreach($lo_rsevl as $lv_row) {
          if(!in_array($lv_row['evlcod'],$lv_evllst)){
						array_push($lv_evllst,$lv_row['evlcod']) ;
					}
					if(!in_array($lv_row['patcod'],$lv_patcodlst)){
						array_push($lv_patcodlst,$lv_row['patcod']) ;
						$lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['patcod'];
					}
				}
        /* MATERIALES */
        $lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
        $lv_evlflt= implode(chr(10),$lv_evllst);
        $lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlcod'.chr(9).'IN'.chr(9).chr(9).$lv_evlflt.chr(9).chr(9),
													'vewfldord' => 'e.evlcod');
        
				$lo_rsevlmat = $lo_evlmatmdl->getList($lv_prm);
        $lv_sqlstm[]= $lo_evlmatmdl->getsysdata('sqlstm');    

        $lo_evlmatlst=array();
        foreach($lo_rsevlmat as $lv_rowmat){
          $lv_keymat=$lv_rowmat['evlcod'];
          if (!array_key_exists($lv_keymat, $lo_evlmatlst)) {
						$lo_evlmatlst[$lv_keymat]=array('matbchcodext'=>'','matbchduedte'=>'','mattxt'=>'','matqty'=>'');
					}
          $lo_evlmatlst[$lv_keymat]['mattxt'] .= ($lo_evlmatlst[$lv_keymat]['mattxt']==''?'':' | ').$lv_rowmat['mattxt']; 
          $lo_evlmatlst[$lv_keymat]['matbchcodext'] .= ($lo_evlmatlst[$lv_keymat]['matbchcodext']==''?'':' | ').$lv_rowmat['matbchcodext']; 
          if ($lv_rowmat['matbchduedte'] instanceof DateTime) {
            $lv_rowmat['matbchduedte'] = $lv_rowmat['matbchduedte']->format('d-m-Y');
          }
          $lo_evlmatlst[$lv_keymat]['matbchduedte'] .= ($lo_evlmatlst[$lv_keymat]['matbchduedte']==''?'':' | ').$lv_rowmat['matbchduedte']; 
          $lv_rowmat['matqty']=number_format($lv_rowmat['matqty'], 2, '.', '');
          $lv_rowmat['matqty'] = (isset(explode(".",$lv_rowmat['matqty'])[1]) && str_replace('0','',explode(".",$lv_rowmat['matqty'])[1])!='')?$lv_rowmat['matqty']:explode(".",$lv_rowmat['matqty'])[0];
          $lo_evlmatlst[$lv_keymat]['matqty'] .=  ($lo_evlmatlst[$lv_keymat]['matqty']==''?'':' | ').$lv_rowmat['matqty'];  //$lv_rowmat['matqty'];
        }
        

				/* PACIENTES */
        $lo_mdlpat = $this->co_reg->load->model('hltpat');
				/* Filtros*/
				$lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $lv_fltpat=false;
				for($i=count($lv_fltarrpat)-1; $i>0; $i--){
					if(stripos(';lndregtxt;hltdisclstxt;adrtwntxt;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
						unset($lv_fltarrpat[$i]);
					}else{
						$lv_fltpat=true;
            $lv_fltarrpat[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarrpat[$i]);
            //$lv_fltarrpat[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('adrtwntxt','a.adrtwn',$lv_fltarrpat[$i]);
            
            $lv_fltarrpat[$i] = str_replace('custxt','c.custxt',$lv_fltarrpat[$i]);
          }
				}
        $lv_prm = array('vewfldflt' =>(count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
												'vewfldord' => 'p.PatCod');
				$lo_rspat = $lo_mdlpat->getList($lv_prm, null, null, false);
        $lv_sqlstm[]= $lo_mdlpat->getsysdata('sqlstm');
        
        //DATOS PERSONALES
        
        $lo_permdl = $this->co_reg->load->model('grldatper');
				//Filtro
				$lv_fltarrdatper = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrdatper)-1; $i>0; $i--){
					if(stripos(';persex;',';'.explode(chr(9),$lv_fltarrdatper[$i])[0].';')===false){
						unset($lv_fltarrdatper[$i]);
					}else{
            $lv_fltnedder=true;
						$lv_flt=explode(chr(9),$lv_fltarrdatper[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrdatper[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]persrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																			(count($lv_fltarrdatper)>0?implode('[~fltrow~]',$lv_fltarrdatper):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
        
				//RELACION MED. DERIVADOR 
        $lo_mdlrls = $this->co_reg->load->model('hltpatprsrls');
				//Filtro 
				$lv_fltarrmedder = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrmedder)-1; $i>0; $i--){
					if(stripos(';rlstxt;',';'.explode(chr(9),$lv_fltarrmedder[$i])[0].';')===false){
						unset($lv_fltarrmedder[$i]);
					}else{
            $lv_fltnedder=true;
						$lv_flt=explode(chr(9),$lv_fltarrmedder[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrmedder[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																			(count($lv_fltarrmedder)>0?implode('[~fltrow~]',$lv_fltarrmedder):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rls_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');

				//RELACION COORDINADOR
				//Filtro
				$lv_fltarrcoo = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $lv_fltcoo=false;
				for($i=count($lv_fltarrcoo)-1; $i>0; $i--){
					if(stripos(';rlstxtcoo;',';'.explode(chr(9),$lv_fltarrcoo[$i])[0].';')===false){
						unset($lv_fltarrcoo[$i]);
					}else{
            $lv_fltcoo=true;
						$lv_flt=explode(chr(9),$lv_fltarrcoo[$i]);
						if($lv_flt[0]=='rlstxtcoo'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrcoo[$i]=implode(chr(9),$lv_flt);
						}
					}
				}
				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'COORD'.chr(9).chr(9).
																			(count($lv_fltarrcoo)>0?implode('[~fltrow~]',$lv_fltarrcoo):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
        /*
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'COORD'.chr(9).chr(9).
																			(count($lv_fltarrcoo)>0?implode('[~fltrow~]',$lv_fltarrcoo):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
        */
				$lo_rlscoo_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');
        //return $lv_sqlstm;
				$lo_ret= array();
				/*Evoluciones*/
				for ($i = 0; $i < count($lo_rsevl); $i++) {
          $lv_evlcod=$lo_rsevl[$i]['evlcod'];
					$lv_rtn=array('evlcod'=>$lo_rsevl[$i]['evlcod'],
												'evldte'=>new DateTime($lo_rsevl[$i]['evldte']->format('Y-m-d')) ,
                        //'evldte'=>new DateTime("now"),
												'patcod'=>'',
                        'patcodext'=>'',
												'pattxt'=>$lo_rsevl[$i]['pattxt'],
												'lndregtxt'=>'',
												'hltdisclstxt'=>'',
												'prscod'=>$lo_rsevl[$i]['prscod'],
                        'prscodext'=>'',
												'prstxt'=>$lo_rsevl[$i]['prstxt'],
												'spctxt'=>$lo_rsevl[$i]['spctxt'],
												'rlstxt'=>'',
												'rlstxtcoo'=>'',
												'docsts'=>$lo_rsevl[$i]['docsts']=='A'?'SI':'NO',
												'evlcncmtvtxt'=>'',
                        'evlcncmtv'=>'',
                        'custxt'=>'',
												'mattxt'=>isset($lo_evlmatlst[$lv_evlcod]['mattxt'])?$lo_evlmatlst[$lv_evlcod]['mattxt']:'',
                        'matbchcodext'=>isset($lo_evlmatlst[$lv_evlcod]['matbchcodext'])?$lo_evlmatlst[$lv_evlcod]['matbchcodext']:'',
                        'matbchduedte'=>isset($lo_evlmatlst[$lv_evlcod]['matbchduedte'])?$lo_evlmatlst[$lv_evlcod]['matbchduedte']:'',
                        'matqty'=>isset($lo_evlmatlst[$lv_evlcod]['matqty'])?$lo_evlmatlst[$lv_evlcod]['matqty']:'',
                        'adrtwntxt'=>'',
                        'adrctytxt'=>'',
                        'matdos'=>'',
                        'patsex'=>'',
                        'patwgt'=>'', 
                        'patage'=>'',
                        'evlctedte'=>$lo_rsevl[$i]['ctedte'],
                        'evlcteusr'=>$lo_rsevl[$i]['cteusr'],
                        'hhrmedcovtxt'=>'',
                        'dtesrv'=>$this->co_reg->document->gettagvalue($lo_rsevl[$i]['evlatr001'],'dtesrv'),
                        'reqcc'=>$this->co_reg->document->gettagvalue($lo_rsevl[$i]['evlatr001'],'reqcc'),
                        'apinroref'=>$this->co_reg->document->gettagvalue($lo_rsevl[$i]['evlatr001'],'apinroref'),
                        'mevlmd'=>$this->co_reg->document->gettagvalue($lo_rsevl[$i]['evlatr001'],'mevlmd'),
												'cteusr'=>$lo_rsevl[$i]['cteusr'],
												'evlevl'=>$lo_rsevl[$i]['evlevl']
											);
					$lv_fndpat = false;
					$lv_fndrelcoo = false;
					$lv_fndrlsder = false;
					//$lo_rsevl[$i]['rlstxt'] = '';
					//$lo_rsevl[$i]['rlstxtcoo'] = '';
					//$lo_rsevl[$i]['hltdisclstxt'] =  '';
					//$lo_rsevl[$i]['lr.lndregtxt'] = '';
					//$lo_rsevl[$i]['evldtecnv'] =$lo_rsevl[$i]['evldte']->format('d-m-Y') ;
					//$lo_rsevl[$i]['evlcncmtv']= $lv_evlcncmtv[$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv')];
          $lv_cuscod = $lo_rsevl[$i]['cuscod'];
          if($lv_rtn['docsts']=='NO'){
            $lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv');
            if($lv_evlcncmtvcod!=''){
              //$lv_rtn['evlcncmtvcod']=$lv_evlcncmtvcod;
              $lv_rtn['evlcncmtv']=isset($lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod]:(isset($lv_evlcncmtv['ALL'][$lv_evlcncmtvcod])?$lv_evlcncmtv['ALL'][$lv_evlcncmtvcod]:'ERROR: CODIGO '.$lv_evlcncmtvcod);
            }
          }
          
					//$lv_rtn['evlcncmtv']= $lv_evlcncmtv[$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv')];
          
					$lv_rtn['patwgt']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'patwgt');
          $lv_rtn['matdos']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'matdos');
          
					// Paciente
					foreach($lo_rspat as $lv_rowpat) {
						if($lo_rsevl[$i]['patcod']==$lv_rowpat['patcod']){
							//$lo_rsevl[$i]['hltdisclstxt'] = $lv_row['hltdisclstxt'];
							//$lo_rsevl[$i]['lr.lndregtxt'] = $lv_row['lndregtxt'];
							$lv_rtn['hltdisclstxt']=$lv_rowpat['hltdisclstxt'];
							$lv_rtn['lndregtxt']=$lv_rowpat['lndregtxt'];
              $lv_rtn['patcod']=$lv_rowpat['patcod'];
              $lv_rtn['patcodext']=$lv_rowpat['patcodext'];
              $lv_rtn['custxt']=$lv_rowpat['custxt'];
							$lv_rtn['patpro']=$lv_rowpat['patpro'];//PatBrnDte							
              $lv_rtn['patsex']=$lv_rowpat['persex'];
              $lv_rtn['adrtwntxt']=$lv_rowpat['adrtwn'];
              $lv_rtn['adrctytxt']=$lv_rowpat['adrcty'];
              $lv_rtn['hhrmedcovtxt']=$lv_rowpat['hhrmedcovtxt'];
              //$lv_rtn['patsex']=$lo_datperlst[$lv_rowpat['patcod']]['persex'];
              //$lv_curdte = new DateTime(date("d-m-Y H:i:s"));
							
              //$lv_diff = $lv_curdte->diff($lv_rowpat['patbrndte']);
              //$lv_rtn['patage']=$lv_diff->days;
              
              if(!isset($lv_rowpat['perbrndte'])){
              	$lv_rtn['patage']='';
              }else{
                $fecha_nacimiento = $lv_rowpat['perbrndte']->format('d-m-Y');
                $dia_actual = date('Y-m-d');
                $lv_age = date_diff(date_create($fecha_nacimiento), date_create($dia_actual));
                $lv_agestr = ($lv_age->y>0?$lv_age->y.' '.$this->co_reg->language->years:'').($lv_age->y<5 && $lv_age->m>0?' '.$lv_age->m.' '.$this->co_reg->language->months:'').($lv_age->y<1?' '.$lv_age->d.' '.$this->co_reg->language->days:'');
                $lv_rtn['patage']=$lv_agestr;
              }
							$lv_fndpat = true;
							break;
						}
					}
          /* Med. Cabecera */
					foreach($lo_rls_rs as $lv_rowmed) {
						if($lo_rsevl[$i]['patcod']==$lv_rowmed['patcod']){
              $lv_cabprs=$lv_rowmed['prstxt'];
							$lv_cabtxt=$this->co_reg->document->getTagValue($lv_rowmed['patprsrlsatr001'] , 'patprsrlstxt');
							$lv_rtn['rlstxt']=$lv_cabprs==''?$lv_cabtxt:$lv_cabprs;
							$lv_fndrlsder = true;
							break;
						}
					}
					// Coordinador 
					foreach($lo_rlscoo_rs as $lv_rowcoo) {
						if($lo_rsevl[$i]['patcod']==$lv_rowcoo['patcod']){
              $lv_cooprs=$lv_rowcoo['prstxt'];
							$lv_cootxt=$this->co_reg->document->getTagValue($lv_rowcoo['patprsrlsatr001'] , 'patprsrlstxt');
              $lv_rtn['rlstxtcoo']=$lv_cooprs==''?$lv_cootxt:$lv_cooprs;
							$lv_fndrelcoo = true;
							break;
						}
					}
          
					// if(count($lv_fltarrpat)>0 && $lv_fndpat == false){continue;}
					// if(count($lv_fltarrmedder)>0 && $lv_fndrlsder == false){continue;}
					// if(count($lv_fltarrcoo)>0 && $lv_fndrelcoo == false){continue;} 
          // if($lv_rtn['rlstxt']!='' && $lv_fndrlsder==true ) { continue;}
          // if($lv_rtn['rlstxtcoo']!='' && $lv_fndrelcoo==true ) { continue;}
          if($lv_rtn['rlstxt']=='' && $lv_fltnedder==true ) { continue;}
          if($lv_rtn['rlstxtcoo']=='' && $lv_fltcoo==true ) { continue;}
          
          // FILTRO EVOLUCIONES SIN PACIENTES
          if($lv_rtn['patcod'] =='' && $lv_fltpat == true){continue;}

					// Filtro motivo no infusion vacio
					if($lv_rtn['evlcncmtv']!='' && $lv_fltevlee==true ) { continue;}

					// Filtro motivo no infusion no vacio
					if($lv_rtn['evlcncmtv']=='' && $lv_fltevlne==true) { continue;}

					//$lo_ret[]=$lo_rsevl[$i];
					$lo_ret[]=$lv_rtn;
				}
        $lo_ret[0]['sqlstm']=$lv_sqlstm;
        
        //var_dump($lv_sqlstm);
        ini_set('memory_limit', $lv_lmtmem);
        $lo_ret[0]['sqlstm']=$lv_sqlstm;
				return $lo_ret;
				break;
      // REPORTES DE EVOLUCIONS
			case '#evrptfle':
        $lo_post = $this->co_reg->request->post;
        /*
        $lv_fltarr=[];
        $lv_fltarrdoc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
                         
				for($i=count($lv_fltarrdoc)-1; $i>0; $i--){
					if(stripos(';e.evldtecnv;',';'.explode(chr(9),$lv_fltarrdoc[$i])[0].';')===false){
						unset($lv_fltarrdoc[$i]);
          }
				}
        */
        
        /* Buscamos los pacientes */ 
        /* Filtro de pacientes */
        $lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrpat)-1; $i>0; $i--){
          if(stripos(';patcod;patcodext;pattxt;cuscod;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
            unset($lv_fltarrpat[$i]);
          }else{ 
            $lv_fltarrpat[$i] = str_replace('patcod'   ,'p.patcod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('patcodext','p.patcodext',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('pattxt'	 ,'p.pattxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('cuscod' ,'p.cuscod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('custxt' ,'c.custxt',$lv_fltarrpat[$i]);
          }
        }
        
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prmpat = array('vewfldflt' =>'[~fltrow~]1'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                           							 (count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
													 //'vewmaxrec'=>'2',
                           'vewfldord' => 'p.patcod'
													 );
        
        $lv_rspat=$lo_patmdl->getList($lv_prmpat, null, null, false);
        $lv_sqlstm[]=$lo_patmdl->getSysData('sqlstm');  
        
        $lv_patlst=[];
        foreach($lv_rspat as $lo_rowPat){
          $lv_patkey = $lo_rowPat['patcod'];
          if (!array_key_exists($lv_patkey,$lv_patlst)) {
              $lv_patlst[$lv_patkey]=[];
          }
          $lv_patlst[$lv_patkey][]=$lo_rowPat;
        }
        
        /* Buscamos las Evoluciones */
        /* Filtros de evoluciones */
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
          
          if(explode(chr(9),$lv_fltarrevl[$i])[0]=='evldte'){
            $lv_fltarrevl[]=str_replace('evldte','pl.plndte',$lv_fltarrevl[$i]);
          }
          if(stripos(';custxt;cuscod;pattxt;patcod;evldte;pl.plndte;evlcod;prscod;prstxt;spccod;spctxt;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
            unset($lv_fltarrevl[$i]);
          }else{
            
            //$lv_fltarrevl[$i] = str_replace('e.pattxt','p.pattxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('e.evldtecnv','evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('pattxt','p.pattxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcod','e.patcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evlcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','e.prscod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','e.prstxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('spccod','e.spccod',$lv_fltarrevl[$i]);   
            $lv_fltarrevl[$i] = str_replace('spctxt','e.spctxt',$lv_fltarrevl[$i]);   
          } 
        }
        
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lv_prmevl = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]E.PLNDTEID IN (SELECT PLNDTEID FROM HLT_PLN_CTR_DTE cd  WHERE cd.DELDTE IS NULL and cd.docsts in (^A^,^C^)) '.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                           							 (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													 'vewfldord' => 'e.patcod,e.spctxt,pl.plndte asc');
        $lv_rsevl=$lo_evlmdl->getList($lv_prmevl, null, null, false);
        
        $lv_sqlstm[]=$lo_evlmdl->getSysData('sqlstm');
        $lv_ret=[];
        foreach($lv_rsevl as $lo_evlRow){
          if(isset($lv_patlst[$lo_evlRow['patcod']])){
          $lv_ret[]=array_merge($lo_evlRow,$lv_patlst[$lo_evlRow['patcod']]);
            
          }else{
            $lv_ret[]=$lo_evlRow;
          }
        }
        $lv_ret[0]['sqlstm']=$lv_sqlstm;
        return $lv_ret;
				break;
				
			 // REPORTES DE EVOLUCIONES
			case '#evlrpt':
        $lo_mdlusrprm = $this->co_reg->load->model('syssecusrprm');
				$lo_post = $this->co_reg->request->post;
				$lv_prm=array();
        $lv_patcodlst=array();
				$lv_patflt= '';
				$lv_usrprmflt= '';
        $v_memlmt=isset($lp_prm['memlmt'])?$lp_prm['memlmt']:'2048';
        $lv_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', $v_memlmt.'M');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]p.PrmCod'.chr(9).'='.chr(9).chr(9).'4'.chr(9).chr(9) );
				$lo_rsprm = $lo_mdlusrprm->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlusrprm->getsysdata('sqlstm');
				foreach( $lo_rsprm as $lv_row ) {
          $lv_usrprmflt .= ($lv_usrprmflt==''?'':chr(10)).$lv_row['prmval']; 
        }
        
        // RELACION MED. DERIVADOR 
        $lo_mdlrls = $this->co_reg->load->model('hltpatprsrls');
				// Filtro
				$lv_fltarrmedder = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrmedder)-1; $i>0; $i--){
					if(stripos(';rlstxt;patcod;pattxt;',';'.explode(chr(9),$lv_fltarrmedder[$i])[0].';')===false){
						unset($lv_fltarrmedder[$i]);
					}else{
            $lv_fltnedder=true;
            $lv_fltarrmedder[$i] = str_replace('e.patcod','a.patcod',$lv_fltarrmedder[$i]);
            $lv_fltarrmedder[$i] = str_replace('e.pattxt','a.pattxt',$lv_fltarrmedder[$i]);
						$lv_flt=explode(chr(9),$lv_fltarrmedder[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= '(dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)+isnull(PR.PRSTXT,^^))';
							$lv_fltarrmedder[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																			(count($lv_fltarrmedder)>0?implode('[~fltrow~]',$lv_fltarrmedder):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rls_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');
        //echo $lo_mdlrls->getsysdata('sqlstm');
        //$lv_patcodlst=array();
        if($lv_fltnedder){
          foreach($lo_rls_rs as $lo_rowrel){
            if(!in_array($lo_rowrel['patcod'], $lv_patcodlst)){
            	$lv_patcodlst[]=$lo_rowrel['patcod'];
            }
          }
        }

				// RELACION COORDINADOR
				// Filtro
				$lv_fltarrcoo = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $lv_fltcoo=false;
				for($i=count($lv_fltarrcoo)-1; $i>0; $i--){
					if(stripos(';rlstxtcoo;',';'.explode(chr(9),$lv_fltarrcoo[$i])[0].';')===false){
						unset($lv_fltarrcoo[$i]);
					}else{
            $lv_fltcoo=true;
            $lv_fltarrcoo[$i] = str_replace('e.patcod','a.patcod',$lv_fltarrcoo[$i]);
            $lv_fltarrcoo[$i] = str_replace('e.pattxt','a.pattxt',$lv_fltarrcoo[$i]);
						$lv_flt=explode(chr(9),$lv_fltarrcoo[$i]);
						if($lv_flt[0]=='rlstxtcoo'){
							$lv_flt[0]= '(dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)+isnull(PR.PRSTXT,^^))';
							$lv_fltarrcoo[$i]=implode(chr(9),$lv_flt);
						}

					}
				}
        // Ver la convercion de los filtos a ZZ 
				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'COORD'.chr(9).chr(9).
																			(count($lv_fltarrcoo)>0?implode('[~fltrow~]',$lv_fltarrcoo):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rlscoo_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');  
        if($lv_fltcoo){
          foreach($lo_rlscoo_rs as $lo_rowrel){
            if(!in_array($lo_rowrel['patcod'], $lv_patcodlst)){
              $lv_patcodlst[]=$lo_rowrel['patcod'];
            }
          }
        }
        $lv_patflt= implode(chr(10),$lv_patcodlst);
        $lv_sqlstm[]=$lv_patflt;
        
        // EVOLUCIONES 
				$lo_mdlevl = $this->co_reg->load->model('hltpatevl');
				// Filtros 				
        
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }
        $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
        $lv_dat = simplexml_load_string($lv_atrusr);
        $lv_evlcncmtv = [];
				foreach($lv_dat as $lv_key=>$lv_val){
          $lv_key= str_replace("CUS_", "", $lv_key);
         	$lv_cncmtvrow = explode(";", $lv_val);
          $lv_evlcncmtv[$lv_key]=[];
          foreach($lv_cncmtvrow as $lv_rowmtv){
            $lv_a = explode(",", $lv_rowmtv);
            $lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
          }
				}
				//$lv_evlcncmtv= array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS','IN'=>'INSTITUCION','TR'=>'TRASLADO','PA'=>'PACIENTE','LSDM'=>'LSDM');
				$lv_maxrec = true;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
	    	
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );			
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evlcod;evldtecnv;evldte;patcod;pattxt;prscod;prstxt;spctxt;docsts;evlcncmtv;cteusr;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						$lv_maxrec = true;
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldtecnv','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcod','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('pattxt','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('spctxt','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('docsts','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evlcncmtv','evlcncmtv',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('cteusr','e.cteusr',$lv_fltarrevl[$i]);
            
            
						$lv_flt=explode(chr(9),$lv_fltarrevl[$i]);
						if ($lv_flt[1]=='EE'){
							unset($lv_fltarrevl[$i]);
							$lv_fltevlee=true;

						}elseif ($lv_flt[1]=='NE') {
							$lv_fltevlne=true;
							unset($lv_fltarrevl[$i]);
						}else{
							if ($lv_flt[0]=='evlcncmtv') {
								$lv_flt[0]= 'dbo.GetTagValue(^evlcncmtv^,EVLATR001)';
								$lv_fltin=array();
								foreach ($lv_evlcncmtv as $key => $value) {
									if(strpos(strtoupper($value), strtoupper($lv_flt[2]))!==false){
										$lv_fltin[]=$key;
									}
								}
								$lv_flt[1]='IN';
								$lv_flt[2]='';
								$lv_flt[3]=implode(chr(10),$lv_fltin);;
								$lv_fltarrevl[$i]=implode(chr(9),$lv_flt);
							}
						}
					}
				}
        
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):'').
																				 (count($lo_rsprm)>0?('[~fltrow~]c.cuscod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9)):''),
													'vewfldord' => 'e.evldte desc',
                          'vewmaxrec'=>$lo_post['vewmaxrec']
												);         
        if($lv_fltcoo || $lv_fltnedder){
          $lv_prmflt['vewfldflt'].='[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9);
        }

				$lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false); 
        $lv_sqlstm[]= $lo_mdlevl->getsysdata('sqlstm');
        

        $lv_evllst=array();
        $lv_patcodlst=array();
				foreach($lo_rsevl as $lv_row) {
          if(!in_array($lv_row['evlcod'],$lv_evllst)){
						array_push($lv_evllst,$lv_row['evlcod']) ;
					}
					if(!in_array($lv_row['patcod'],$lv_patcodlst)){
            $lv_patcodlst[]=$lv_row['patcod'];
					}
				}
        $lv_patflt= implode(chr(10),$lv_patcodlst);  
        /* MATERIALES */
        $lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
        $lv_evlflt= implode(chr(10),$lv_evllst);
        $lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlcod'.chr(9).'IN'.chr(9).chr(9).$lv_evlflt.chr(9).chr(9),
													'vewfldord' => 'e.evlcod');
        
				$lo_rsevlmat = $lo_evlmatmdl->getList($lv_prm);
        $lv_sqlstm[]= $lo_evlmatmdl->getsysdata('sqlstm');    

        $lo_evlmatlst=array();
        foreach($lo_rsevlmat as $lv_rowmat){
          $lv_keymat=$lv_rowmat['evlcod'];
          if (!array_key_exists($lv_keymat, $lo_evlmatlst)) {
						$lo_evlmatlst[$lv_keymat]=array('matbchcodext'=>'','mattxt'=>$lv_rowmat['mattxt'],'matqty'=>0);
					}
          $lo_evlmatlst[$lv_keymat]['matbchcodext'] .= ($lo_evlmatlst[$lv_keymat]['matbchcodext']==''?'':' | ').$lv_rowmat['matbchcodext']; 
          $lo_evlmatlst[$lv_keymat]['matqty'] += $lv_rowmat['matqty'];
        }       

				// PACIENTES */
        $lo_mdlpat = $this->co_reg->load->model('hltpat');
				// Filtros*/
				$lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
				for($i=count($lv_fltarrpat)-1; $i>0; $i--){
					if(stripos(';lndregtxt;hltdisclstxt;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
						unset($lv_fltarrpat[$i]);
					}else{
            $lv_fltarrpat[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('custxt','c.custxt',$lv_fltarrpat[$i]);
          }
				}
        $lv_prm = array('vewfldflt' =>(count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
													'vewfldord' => 'p.PatCod');
				$lo_rspat = $lo_mdlpat->getList($lv_prm, null, null, false);
        $lv_sqlstm[]= $lo_mdlpat->getsysdata('sqlstm');
        
        //DATOS PERSONALES
        
        $lo_permdl = $this->co_reg->load->model('grldatper');
				//Filtro
				$lv_fltarrdatper = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrdatper)-1; $i>0; $i--){
					if(stripos(';persex;',';'.explode(chr(9),$lv_fltarrdatper[$i])[0].';')===false){
						unset($lv_fltarrdatper[$i]);
					}else{
            $lv_fltnedder=true;
						$lv_flt=explode(chr(9),$lv_fltarrdatper[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrdatper[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]persrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																			(count($lv_fltarrdatper)>0?implode('[~fltrow~]',$lv_fltarrdatper):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
        
        // SE PREPARA LA SALIDA 

				// Evaluaciones
				for ($i = 0; $i < count($lo_rsevl); $i++) {
          $lv_evlcod=$lo_rsevl[$i]['evlcod'];
					$lv_rtn=array('evlcod'=>$lo_rsevl[$i]['evlcod'],
												'evldtecnv'=>$lo_rsevl[$i]['evldte']->format('d/m/Y') ,
												'patcod'=>$lo_rsevl[$i]['patcod'],
                        //'patcod'=>'',
                        'cuscod'=>$lo_rsevl[$i]['cuscod'],
												'pattxt'=>$lo_rsevl[$i]['pattxt'],
												'lndregtxt'=>'',
												'hltdisclstxt'=>'',
												'prscod'=>$lo_rsevl[$i]['prscod'],
                        'prscodext'=>'',
												'prstxt'=>$lo_rsevl[$i]['prstxt'],
												'spctxt'=>$lo_rsevl[$i]['spctxt'],
												'rlstxt'=>'',
												'rlstxtcoo'=>'',
												'docsts'=>$lo_rsevl[$i]['docsts']=='A'?'SI':'NO',
												'evlcncmtvtxt'=>'',
                        'evlcncmtv'=>'',
                        'evlcncmtvcod'=>'',
                        'c.custxt'=>'',
												'mattxt'=>isset($lo_evlmatlst[$lv_evlcod]['mattxt'])?$lo_evlmatlst[$lv_evlcod]['mattxt']:'',
                        'matbchcodext'=>isset($lo_evlmatlst[$lv_evlcod]['matbchcodext'])?$lo_evlmatlst[$lv_evlcod]['matbchcodext']:'',
                        'matqty'=>isset($lo_evlmatlst[$lv_evlcod]['matqty'])?$lo_evlmatlst[$lv_evlcod]['matqty']:'',
                        'adrtwntxt'=>'',
                        'adrtwntxt'=>'',
                        'patsex'=>'',
                        'patwgt'=>'', 
                        'patage'=>'', 
												'cteusr'=>$lo_rsevl[$i]['cteusr']								 				
											);
					$lv_fndpat = false;
					$lv_fndrelcoo = false;
					$lv_fndrlsder = false;
          $lv_cuscod = $lo_rsevl[$i]['cuscod'];
          if($lv_rtn['docsts']=='NO'){
            $lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv');
            if($lv_evlcncmtvcod!=''){
              $lv_rtn['evlcncmtvcod']=$lv_evlcncmtvcod;
              $lv_rtn['evlcncmtv']=isset($lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod]:(isset($lv_evlcncmtv['ALL'][$lv_evlcncmtvcod])?$lv_evlcncmtv['ALL'][$lv_evlcncmtvcod]:'ERROR: CODIGO '.$lv_evlcncmtvcod);
              $lv_rtn['evlcncmtvtxt']= '';
            }
          }
          
          //$lo_rsevl[$i]['evlcncmtv']= $lv_rtn['evlcncmtv'];//$lv_evlcncmtv[$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv')];
					$lv_rtn['patwgt']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'patwgt');
          // Med. Cabecera 
					foreach($lo_rls_rs as $lv_rowmed) {
						if($lo_rsevl[$i]['patcod']==$lv_rowmed['patcod']){
              $lv_cabprs=$lv_rowmed['prstxt'];
							$lv_cabtxt=$this->co_reg->document->getTagValue($lv_rowmed['patprsrlsatr001'] , 'patprsrlstxt');
							$lv_rtn['rlstxt']=$lv_cabprs==''?$lv_cabtxt:$lv_cabprs;
							$lv_fndrlsder = true;
							break;
						}
					}
					// Coordinador 
					foreach($lo_rlscoo_rs as $lv_rowcoo) {
						if($lo_rsevl[$i]['patcod']==$lv_rowcoo['patcod']){
              $lv_cooprs=$lv_rowcoo['prstxt'];
							$lv_cootxt=$this->co_reg->document->getTagValue($lv_rowcoo['patprsrlsatr001'] , 'patprsrlstxt');
              $lv_rtn['rlstxtcoo']=$lv_cooprs==''?$lv_cootxt:$lv_cooprs;
							$lv_fndrelcoo = true;
							break;
						}
					}
					// Paciente 
					foreach($lo_rspat as $lv_rowpat) {
						if($lv_rtn['patcod']==$lv_rowpat['patcod']){
							$lv_rtn['hltdisclstxt']=$lv_rowpat['hltdisclstxt'];
							$lv_rtn['lndregtxt']=$lv_rowpat['lndregtxt'];
              $lv_rtn['patcod']=$lv_rowpat['patcod'];
              $lv_rtn['patcodext']=$lv_rowpat['patcodext'];
              $lv_rtn['custxt']=$lv_rowpat['custxt'];
							$lv_rtn['patpro']=$lv_rowpat['patpro'];//PatBrnDte							
              $lv_rtn['patsex']=$lv_rowpat['persex'];
              $lv_rtn['adrtwntxt']=$lv_rowpat['adrtwn'];
              if(!isset($lv_rowpat['perbrndte'])){
              	$lv_rtn['patage']='';
              }else{
                $fecha_nacimiento = $lv_rowpat['perbrndte']->format('d-m-Y');
                $dia_actual = date('Y-m-d');
                $lv_age = date_diff(date_create($fecha_nacimiento), date_create($dia_actual));
                $lv_agestr = ($lv_age->y>0?$lv_age->y.' '.$this->co_reg->language->years:'').($lv_age->y<5 && $lv_age->m>0?' '.$lv_age->m.' '.$this->co_reg->language->months:'').($lv_age->y<1?' '.$lv_age->d.' '.$this->co_reg->language->days:'');
                $lv_rtn['patage']=$lv_agestr;
              }
							$lv_fndpat = true;
							break;
						}
					}
					//if(count($lv_fltarrpat)>0 && $lv_fndpat == false){continue;}
					//if(count($lv_fltarrmedder)>0 && $lv_fndrlsder == false){continue;}
					//if(count($lv_fltarrcoo)>0 && $lv_fndrelcoo == false){continue;}
          
          //if($lv_rtn['rlstxt']!='' && $lv_fndrlsder==true ) { continue;}
          //if($lv_rtn['rlstxtcoo']!='' && $lv_fndrelcoo==true ) { continue;}
          
          if($lv_rtn['rlstxt']=='' && $lv_fltnedder==true ) { continue;}
          if($lv_rtn['rlstxtcoo']=='' && $lv_fltcoo==true ) { continue;}
          
          //FILTRO EVOLUCIONES SIN PACIENTES
          if($lv_rtn['patcod'] ==''){continue;}

					// Filtro motivo no infusion vacio 
					if($lv_rtn['evlcncmtv']!='' && $lv_fltevlee==true ) { continue;}

					// Filtro motivo no infusion no vacio 
					if($lv_rtn['evlcncmtv']=='' && $lv_fltevlne==true) { continue;}
          

          /*
          */
					//$lo_ret[]=$lo_rsevl[$i];
					$lo_ret[]=$lv_rtn;
				}
        $lo_ret[0]['sqlstm']=$lv_sqlstm;
        
        //var_dump($lv_sqlstm);
        ini_set('memory_limit', $lv_lmtmem);
        
				return $lo_ret;
				break;
        
			//  I M P R E S I O N   -    E V O L U C I O N
			case '#hltpatevlprn':

				// obtengo el numero de evolucion
				$lv_evlcod = (isset($this->co_reg->request->post['lstevlcod'])?$this->co_reg->request->post['lstevlcod']:$lp_prm['lstevlcod']);

				// cargo los modelos
				$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');

				$evlcodlst = explode( ',',$lv_evlcod);
				$evllst= array();
				foreach($evlcodlst as $lv_rowcod) {
					$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
					$lo_patevlmdl->load( array('evlcod'=>$lv_rowcod), false );
					$lv_lstevl = array('evldte'  => $lo_patevlmdl->evldte,
															'patcod' => $lo_patevlmdl->patcod,
															'pattxt' => $lo_patevlmdl->pattxt,
															'prstxt' => $lo_patevlmdl->prstxt,
															'spccod' => $lo_patevlmdl->spccod,
															'spccodext' => $lo_patevlmdl->spccodext,
															'spctxt' => $lo_patevlmdl->spctxt,
															'evlspc' => $lo_patevlmdl->evlspc,
															'evlatr' => $lo_patevlmdl->evlatr,
															'evlevl' => $lo_patevlmdl->evlevl,
															'evlmat' => $lo_patevlmdl->evlmat
															);
					array_push($evllst,$lv_lstevl);
				}
				$lv_buffer = 	$this->getView('zcutp1_hltpatevlpntlst', array('data' => $evllst));
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
              
        
			//   P A C I E N T E S    -    C U A D R O    D E    I N F O R M A C I O N
	    case '#39':
				$lv_buffer = '';
				
				// recupero datos de paciente
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$lp_prm['patcod']), false );
				
				// recupero clase de documento de contacto CRM
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'CRMPAT'.chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_docclsmdl->getList($lv_prm);
				$lv_sysdocclscod = '';
				if(count($lo_rs)>0){ $lv_sysdocclscod = $lo_rs[0]['sysdocclscod']; }
				$lo_patmdl->crmdocclscod = $lv_sysdocclscod;
				
				return $this->getView( 'zcutp1_tinhltpat_infobox', array('data'=>$lo_patmdl) );
				break;
			
			
			//    A L U M N O    -    V A L I D A C I O N
      case '#26':
				$lv_ret = '';
        if (isset($lp_prm['data']['lndregcod'],$lp_prm['data']['adrstr'], $lp_prm['data']['adrstrnum'], $lp_prm['data']['adrstrflr'], $lp_prm['data']['adrstrbld'])){
          
          if ($lp_prm['data']['cuscod']=='') {$lv_ret='Debe indicar un Financiador';}
          if ($lp_prm['data']['lndregcod']=='') {$lv_ret='Debe indicar una region';}

          if($lp_prm['action']=='UPDATE'){
            //Mail Notificacion de cambio de direccion
            $lv_changes = array();
            $lv_change = false;
            if( isset($lp_prm['data']['patcod']) && $lp_prm['data']['patcod'] != '' ){
              //obtiene los datos actuales del contacto
              $lo_olddat = $this->co_reg->load->model('hltpat');
              $lo_olddat->load( array( 'patcod' => $lp_prm['data']['patcod'] ), false );

              // Calle
              if( $lp_prm['data']['adrstr'] != $lo_olddat->adr->adrstr ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrstr, 'new' => $lp_prm['data']['adrstr'], 'name' => 'Calle' ) ); }
              // Numero
              if( $lp_prm['data']['adrstrnum'] != $lo_olddat->adr->adrstrnum ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrstrnum, 'new' => $lp_prm['data']['adrstrnum'], 'name' => 'Numero' ) ); }
              // Piso
              if( $lp_prm['data']['adrstrflr'] != $lo_olddat->adr->adrstrflr ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrstrflr, 'new' => $lp_prm['data']['adrstrflr'], 'name' => 'Piso' ) ); }
              // Edificio
              if( $lp_prm['data']['adrstrbld'] != $lo_olddat->adr->adrstrbld ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrstrbld, 'new' => $lp_prm['data']['adrstrbld'], 'name' => 'Edificio' ) );}
              // Zona
              // se comenta la linea dado que no se uitiliza en logindoor el campo zona (que se utiliza para facturacion en tinfusion)
              //if( $lp_prm['data']['adrzon'] != $lo_olddat->adr->adrzon ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrzon, 'new' => $lp_prm['data']['adrzon'], 'name' => 'Zona' ) ); }
              // Localidad
              //Se quita el campo porque ya no viene mas desde el front (GRUSSO=>07/09/2023)👇 
              //if( $lp_prm['data']['adrtwntxt'] != $lo_olddat->adr->adrtwntxt ){ array_push( $lv_changes, array( 'old' => $lo_olddat->adr->adrtwntxt, 'new' => $lp_prm['data']['adrtwntxt'], 'name' => 'Localidad' ) ); }

              if(strtoupper( $lp_prm['data']['docsts']) != strtoupper($lo_olddat->docsts) ){ array_push( $lv_changes, array( 'old' => $lo_olddat->docsts, 'new' => $lp_prm['data']['docsts'], 'name' => 'Estado' ) ); }
            }
              // ENVÍO DEL MAIL
            if (count($lv_changes) > 0) {
                // Carga modelo de texto del mail
                $lo_txtmdl = $this->co_reg->load->model('grldattxt');

                // Variables para cambios domicilio o estado
                $has_docsts_change = false;
                $has_address_change = false;

                foreach ($lv_changes as $lv_row) {
                    if ($lv_row['name'] === 'Estado') {
                        $has_docsts_change = true;
                    } else {
                        $has_address_change = true;
                    }
                }

                $lv_env = $this->co_reg->config->get('environmet');
                // Si cambia el estado (CNTADRMOD2)
                if ($has_docsts_change) {
                    /*
                    $lv_prm = array(
                        'vewfldflt' => '[~fltrow~]t.txtcodext' . chr(9) . '=' . chr(9) . chr(9) . 'CNTADRMOD2' . chr(9) . chr(9) .
                            '[~fltrow~]t.lngcod' . chr(9) . '=' . chr(9) . chr(9) . 'ES' . chr(9) . chr(9) .
                            '[~fltrow~]t.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9)
                    );
                    $lo_rs = $lo_txtmdl->getList($lv_prm);
                    if ($lo_rs != array()) {
                        $lo_rs[0]['txttxt'] = html_entity_decode($lo_rs[0]['txttxt']);
                    }
                    */
                    // obtengo mensaje de notificacion
                    $lo_rs=[];
                    $lo_rs[]=array('txttxt'=>'');
                    $lv_txtcodext = 'CNTADRMOD2';
                    $lo_txtmdl = $this->co_reg->load->model('grldattxt');

                    if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
                      $lv_usrmsg = $lo_txtmdl->txttxt;
                      $lo_rs[0]['txttxt'] = html_entity_decode($lo_txtmdl->txttxt);
                    }

                    $lo_eml = new tmssMail();
                    $lv_emlprm['from'] = array(array('address' => 'noreply@temasis.com.ar', 'name' => 'Sistemas Team Medical Group'));
                    $lv_emlprm['subject'] = utf8_decode('Modificación de estado del paciente');

                    // Defino destinatario según entorno
                    if ($lv_env == 'dev') {
                        $lv_emlprm['to'] = array(array('address' => 'sistemas@logindoor.com.ar'));
                    } else if ($lv_env == 'prd') {
                        $lv_emlprm['to'] = array(array('address' => 'inactivaciones@logindoor.com.ar'));
                    }

                    // cuerpo del mail para cambio de estado
                    $lv_msgchanges = '';
                    foreach ($lv_changes as $lv_row) {
                        $lv_msgchanges .= $lv_row['name'] . ': ' . ($lv_row['old'] != '' ? $lv_row['old'] : '" "') . ' => ' .
                            ($lv_row['new'] != '' ? '<b>' . $lv_row['new'] . '</b>' : '" "') . '<br>';
                    }
                    $lo_rs[0]['txttxt'] = str_replace(
                        array('[%1]', '[%2]'),
                        array('<strong>' . $this->co_reg->sec->bustxt . '</strong><br><b>#' . $lp_prm['data']['patcod'] . ' ' . $lp_prm['data']['pattxt'] . '</b>', $lv_msgchanges),
                        $lo_rs[0]['txttxt']
                    );

                    $lv_msg = ($lo_rs != array() ? $lo_rs[0]['txttxt'] : 'Mensaje no encontrado');
                    $lv_emlprm['bodyhtml'] = utf8_decode($lv_msg);

                    // Enviar mail
                    $lo_eml->send($lv_emlprm);
                }

                // Si cambia la dirección (CNTADRMOD)
                if ($has_address_change) {
                  /*
                    $lv_prm = array(
                        'vewfldflt' => '[~fltrow~]t.txtcodext' . chr(9) . '=' . chr(9) . chr(9) . 'CNTADRMOD' . chr(9) . chr(9) .
                            '[~fltrow~]t.lngcod' . chr(9) . '=' . chr(9) . chr(9) . 'ES' . chr(9) . chr(9) .
                            '[~fltrow~]t.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9)
                    );
                    $lo_rs = $lo_txtmdl->getList($lv_prm);
                    if ($lo_rs != array()) {
                        $lo_rs[0]['txttxt'] = html_entity_decode($lo_rs[0]['txttxt']);
                    }

                  */
                    // obtengo mensaje de notificacion
                    $lv_txtcodext = 'CNTADRMOD';
                    $lo_txtmdl = $this->co_reg->load->model('grldattxt');

                    if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
                      $lv_usrmsg= html_entity_decode($lo_txtmdl->txttxt);
                    } 
                    $lo_eml = new tmssMail();
                    $lv_emlprm['from'] = array(array('address' => 'noreply@temasis.com.ar', 'name' => 'Sistemas Team Medical Group'));
                    $lv_emlprm['subject'] = utf8_decode('Modificación de la dirección de un contacto');

                    // Defino destinatario según entorno
                    if ($lv_env == 'dev') {
                        $lv_emlprm['to'] = array(array('address' => 'sistemas@lsdm.global'));
                    } else if ($lv_env == 'prd') {
                        $lv_emlprm['to'] = array(array('address' => 'cambio-domicilio@logindoor.com.ar'));
                    }

                    //cuerpo del mail para cambio de domicilio
                    $lv_msgchanges = '';
                    foreach ($lv_changes as $lv_row) {
                        $lv_msgchanges .= $lv_row['name'] . ': ' . ($lv_row['old'] != '' ? $lv_row['old'] : '" "') . ' => ' .
                            ($lv_row['new'] != '' ? '<b>' . $lv_row['new'] . '</b>' : '" "') . '<br>';
                    }
                    /*$lo_rs[0]['txttxt'] = str_replace(
                        array('[%1]', '[%2]'),
                        array('<strong>' . $this->co_reg->sec->bustxt . '</strong><br><b>#' . $lp_prm['data']['patcod'] . ' ' . $lp_prm['data']['pattxt'] . '</b>', $lv_msgchanges),
                        $lo_rs[0]['txttxt']
                    );*/
                    $lo_txtmdl->txttxt= str_replace(
                        array('[%1]', '[%2]'),
                        array('<strong>' . $this->co_reg->sec->bustxt . '</strong><br><b>#' . $lp_prm['data']['patcod'] . ' ' . $lp_prm['data']['pattxt'] . '</b>', $lv_msgchanges),
                        $lo_txtmdl->txttxt
                    );

                    $lv_msg = $lo_txtmdl->txttxt ;//($lo_rs != array() ? $lo_txtmdl->txttxt : 'Mensaje no encontrado'); 
                    $lv_emlprm['bodyhtml'] = utf8_decode($lv_msg);

                    // Enviar mail
                    $lo_eml->send($lv_emlprm);
                }

                // Eliminación de la zona de transporte
                $lp_prm['data']['trazoncod'] = '';
            }
          }
        }
        // FIN UPDATE
        if($lv_ret!=''){
          return array( 'errtyp'=>'E', 'errcod'=>-10, 'errtxt'=>$lv_ret );
        	break; 
        }
				return array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'' );
				break;
        
        
        
      
			// --------------------------------------------------------------------
			//
			// NOVARTIS
			//
			// --------------------------------------------------------------------
			
        
        
        
        
      //  EVOLUCION XOLAIR - IMPRESION. devuelve formulario pdf de impresion de evolución
			case '#hltpatevlxolprn':
				$lo_post = $this->co_reg->request->post;
        
				// cargo evolución
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_evlmdl->load( array('evlcod'=>$lp_prm['evlcod']), false );
        
        // cargo paciente
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_patmdl->load( array('patcod'=>$lo_evlmdl->patcod), false );
        $lo_evlmdl->pat = $lo_patmdl;
        
				// devuevlo pantalla
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutp1_tinhltpatevlxolpnt', array('data'=>$lo_evlmdl) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
      
      //  EVOLUCION XOLAIR. devuelve formulario de evaluacion 
			case '#hltpatevlxol': case '#hltpatevlxol02':{
        
        //Instanciamos los modelos
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				//Obtenemos los parametros post
				$lv_evlcod = $this->co_reg->request->post['evlcod']??'';//(isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');

        //
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }      
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        
        $PatChgDte = '';
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod;
        //--
        /* ------------------------------------------------ */
        /* obtengo clase de documento 											*/
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
          } else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
          }
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
        } else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        /* ------------------------------------------------ */         
        /* Buscar datos sugerencia de material */
        /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
         $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt));
        }

        /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
        $lo_patmdl = $this->co_reg->load->model('hltpat');	
        if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
        }

        /*3. Busco el material */
        $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
        $lo_plndtemdl->mattxt = '';
        $lo_plndtemdl->matcod = '';
        $lo_matmdl = $this->co_reg->load->model('stkmat');	
        if($lv_matcod !=''){
          if(!$lo_matmdl->load(array('matcod'=>$lv_matcod),false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
          }
        }
        $lo_plndtemdl->matcod = $lo_matmdl->matcod;
        $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
        $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
        //
        				
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  

          
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					//$lo_plndtemdl->hhcc=$lv_hhcc;
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
												//,model' => self::MODEL
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				// VER EVOLUCION
				} else {
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );   
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          $lo_plndtemdl->matuntcod = '';//'Gustavo';

					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
                          //'model' => self::MODEL,
													'rsplndte'=>array(),
													);
				}
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdlmtv = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdlmtv->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdlmtv->errcod,'errtxt'=>$lo_prmmdlmtv->errtxt) );
        }
        $lv_mtvarr=$this->getServiceNonExecutionReasons(array('mdlcod'=>'EVLCNCMTVLST','prmmdl'=>$lo_prmmdlmtv));
        $lv_prm['data']->evlcncmtvlst = array_key_exists($lo_plndtemdl->cuscod,$lv_mtvarr)?$lv_mtvarr[$lo_plndtemdl->cuscod]:$lv_mtvarr['ALL'];
        $lv_prm['data']->evlcncmtvlst2=$this->getServiceNonExecutionReasons(array('mdlcod'=>'EVLCNCMTVLST','prmmdl'=>$lo_prmmdlmtv,'prmkey'=>'EVLCNCMTVLST2'));
				$lv_prm['data']->hhcc=$lv_hhcc;
        $lv_prm['data']->fldrec=$lv_fldrec;
        
        //Buscamos los textos          
				$lv_txttypcod = $this->co_reg->document->gettagvalue($lo_prmmdlmtv->mdlatrval001,'txttypcod');
        $lo_grldattxtmdl = $this->co_reg->load->model('grldattxt');
        $lv_prmtxt = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp '.chr(9).'='.chr(9).chr(9).'hlt_pln'.chr(9).chr(9).
                                         '[~fltrow~]t.txttypcod '.chr(9).'='.chr(9).chr(9).$lv_txttypcod.chr(9).chr(9).
                             						 '[~fltrow~]t.txtsrccod '.chr(9).'='.chr(9).chr(9).$lv_plnid.chr(9).chr(9));
        $lv_rstxt=$lo_grldattxtmdl->getList( $lv_prmtxt);
        $lv_prm['data']->txttxt='';
        if(count($lv_rstxt)>0){
					$lv_prm['data']->matdos=strip_tags($lv_rstxt[0]['txttxt']); 
        }
        //$lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
				$lv_prm['data']->hhcc=$lv_hhcc;
        $lv_prm['data']->fldrec=$lv_fldrec;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
        $lv_prm['data']->matcod = $lo_matmdl->matcod;
        $lv_prm['data']->mattxt = $lo_matmdl->mattxt;
        $lv_prm['data']->matuntcod = $lo_matmdl->matuntcod;
        $lv_prm['data']->endpoint=self::VIEW;
        
        // devuelvo vista
				return $this->co_reg->document->getView( 'zcutp1_tinhltpatevlxol', $lv_prm); 
				break;
      }
      //  EVOLUCION XOLAI - GRABAR. graba la evolución y devuelve vista
      case '#hltpatevlxolsve':
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
        
        
        /* DATOS DEL PACINTE */
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_oldval = $lo_patdl->patwgt;
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );
        
        
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc; 
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
        $lv_buf_arr['evlevl']= $lv_buf_arr['evlcod']==''?$lv_buf_arr['evlevl']:'';
				//$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];z
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        //<Nuevos campos>
        $lv_buf_arr['evlatr001'].= '<infprg>'.$lv_buf_arr['infprg'].'</infprg>';
        $lv_buf_arr['evlatr001'].= '<infexe>'.$lv_buf_arr['infexe'].'</infexe>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv2>'.$lv_buf_arr['evlcncmtv2'].'</evlcncmtv2>';
        //</Nuevos campos>
        $lv_buf_arr['evlatr001'].= '<matdos>'.$lv_buf_arr['matdos'].'</matdos>';
        //$lv_buf_arr['evlatr001'].= '<matuntcod>'.$lv_buf_arr['matuntcod'].'</matuntcod>';
        $lv_buf_arr['evlatr001'].='</row>';
        if($lv_buf_arr['evlcod']==''){
					$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
        }
				//$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				//Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
          // elimino los materiales 
          $lvMatDelLst = html_entity_decode($this->co_reg->request->post['evlmatdel']);
          $lvMatDelArr = explode(";",$lvMatDelLst);//json_decode($lv_buffer,true);
          foreach( $lvMatDelArr as $lv_row ) {
            if ($lo_evlmatmdl->delete(array('evlmatcod'=>$lv_row))==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
            }
          }
          
					// EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
          /*
					if ($lv_buffer!='') {
            
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
              if( !isset($lv_row['matcod']) || $lv_row['matcod']==''|| $lv_row['matcod']=='0'){
                continue;
              }
							$lv_arr = $lv_row;
              //$lv_arr['matqty']=number_format($lv_arr['matqty'], 2, '.', '');
              //$lv_arr['matqty'] = (isset(explode(".",$lv_arr['matqty'])[1]) && str_replace('0','',explode(".",$lv_arr['matqty'])[1])!='')?$lv_arr['matqty']:explode(".",$lv_arr['matqty'])[0];
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
          */
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if( $lv_buf_arr['evlcod']=='' && ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;//$lo_patdl->custxt??'error';
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $this->sendMailFarma($lvDataFarma);
          /*
          // obtengo texto del mensaje
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                        '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
          $lo_rs = $lo_txtmdl->getList($lv_prm);
          if( count($lo_rs)!=0 ) {
            $lv_usrmsg = $lo_rs[0]['txttxt'];
          } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontró el texto del mensaje.';
          } 
          // determino destinatarios
          //$lv_intval['cuscod']= $lo_patmdl->cuscod;
          $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
          if ( $lo_appprmmdl->load(array('mdlcod'=>'CNFEMLFMV')) == false ) {
            $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
            return $lv_buffer;
            break;
          }
          
          $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,$lo_patdl->cuscod);	// MAILS
          if($lv_sndeml==''){
            $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'*');	// MAILS
          }
          
          $lv_mailtoarr = explode(';',$lv_sndeml);
          foreach( $lv_mailtoarr as $lv_val) {
            $lv_mailto[] = array('address'=>$lv_val);
          }
          // envío mail
          if ( $lv_usrmsg!='') {
            $lo_eml = new tmssMail();
            $lv_emlprm= array();
            $lv_emlprm['to'] = $lv_mailto;
            $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Infusion') );
            $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
            $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
            $lv_usrmsg = str_replace( '[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia' , $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lv_buf_arr['patcod'] . ' ) <strong>'.   utf8_decode($lo_patdl->pattxt). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Financiador : ( #'. $lv_buf_arr['cuscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['custxt']). '</strong><br/>[%3]', $lv_usrmsg);			  
            $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lo_evlmdl->evlcod . ' ) <strong>'. $lv_buf_arr['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lv_buf_arr['prscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lv_buf_arr['spccod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['spctxt']) .'</strong>', $lv_usrmsg);
            $lv_emlprm['bodyhtml'] = $lv_usrmsg;
            if ( $lo_eml->send( $lv_emlprm ) ) {
              $lv_errcod = '';
              $lv_errtxt = '';
            } else {
              $lv_errcod = '-1';
              $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
            }
          }
          */
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
				
      
      //  EVOLUCION XOLAI - ELIMINAR. graba la evolución
      case '#hltpatevlxoldel':
        
        $lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
					$lv_ret = array('errtyp'=>"E", 'errcod'=>-4, 'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');//'<errcod>-4</errcod><errtxt>No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']</errtxt>';
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false )==false ) {
						$lv_ret = array('errtyp'=>"E", 'errcod'=>$lo_evlmdl->errcod, 'errtxt'=>$lo_evlmdl->errtxt );//'<errcod>'.$lo_evlmdl->errcod.'</errcod><errtxt>'.$lo_evlmdl->errtxt.'</errtxt>';
					} else {
            // GRABO EL ICONO EN LA PLANIFICACION
            // OBTEGO LA PLANIFICACION
            $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
            $lo_plndtearr= array();
            $lo_plndtearr['plndteid']=$this->co_reg->request->post['plndteid'];
            $lo_plndtearr['plnid']=$this->co_reg->request->post['plnid'];;
            if (!$lo_plndtemdl->load($lo_plndtearr)) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
            }
            $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
            $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
            $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
            $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
            $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
            $lo_plndtearr['serid']=$lo_plndtemdl->serid;
            $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
            $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
            $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
            $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
            $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
            $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
            $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
            $lo_plndtearr['hltplndteatrusricn']='';
            if (!$lo_plndtemdl->save($lo_plndtearr)) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
            }
						$lv_ret = array('errtyp'=>"S", 'errcod'=>0, 'errtxt'=>'');
					}
				}
        return $this->co_reg->document->getJson($lv_ret);
				//return $lv_ret;
        break;
      //  EVOLUCION XOLAIR - REPORTE. devuelve listado de evoluciones para reporte
			case '#hltpatevlxolrpt':
				$lo_post = $this->co_reg->request->post;
                
				// cargo evolución
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lv_prm =array('vewfldflt' =>'[~fltrow~]e.spctxt'.chr(9).''.chr(9).'XOLAIR'.chr(9).chr(9).chr(9),
                       'vewfldord'=>'',
                       'vewmaxrec'=>'100');
        $lv_prm['vewfldflt'] .= (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
        $lv_prm['vewfldord'] .= (isset($lo_post['vewfldord'])?$lo_post['vewfldord']:'');
        $lv_prm['vewmaxrec'] = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'100');
        $lo_rs = $lo_evlmdl->getList( $lv_prm, null, null, false );
        foreach($lo_rs as &$lv_row){
          $lv_row['evlatrrea'] = $this->co_reg->document->getTagValue($lv_row['evlatr001'],'rea');
          $lv_row['evlatrprf'] = $this->co_reg->document->getTagValue($lv_row['evlatr001'],'prf');
          $lv_row['evlatrmeddss'] = $this->co_reg->document->getTagValue($lv_row['evlatr001'],'meddss');
          $lv_row['evlatrmedbch'] = $this->co_reg->document->getTagValue($lv_row['evlatr001'],'medbch');
          $lv_row['evldtecnv'] = $lv_row['evldte']->format('d/m/Y');
        }
        unset($lv_row);
        
				// devuevlo pantalla
				return $lo_rs;
				break;
			
      
      // PACIENTES XOLAIR. envia mail si se esta creando un nuevo paciente
      case '#hltpatxoleml':
        //$lo_post = $this->co_reg->request->post;
        $lo_post = $lp_prm;
        if($lo_post['action']!='NEW'){ return ''; }

        // obtengo mensaje de notificacion
        $lvTxtCodExt='HLTPATNTF';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => $lvTxtCodExt, 'txtsys' => 1), false) ){
        	$lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
          $lv_errcod .= -1003;
          $lv_errtxt .= ' No se pudo cargar el texto de notificacion de errores ['.$lvTxtCodExt.']. ';
        }
				
        // DESTINATARIOS. determino destinatarios segun entorno
        $lv_env = $this->co_reg->config->get('environmet');
        $lv_mailto = array();
        if($lv_env=='dev'){
        //$lv_mailto[] = array('address'=>'mdominguez@temasis.ar');
          $lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        $lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
        }else if($lv_env=='prd'){
          $lv_mailto[] = array('address'=>'aarias@lsdm.global');
          $lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
        }
				
        // TABLA DE DATOS. Visualizacion de datos cargados
        $lv_tab =	'';
										
        //MAIL. Envío mail
        if ( $lv_usrmsg!='' && count($lv_mailto)>0 ) {
          $lo_eml = new tmssMail();
          $lv_emlprm['to'] = $lv_mailto;
          $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Infusion ') );
          $lv_emlprm['subject'] = 'Alta de paciente NOVARTIS';
          $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%2]', 'Nuevo Paciente' , $lv_usrmsg);
          $lv_usrmsg = str_replace( '[%3]', $lo_post['data']['patcod'], $lv_usrmsg);
          $lv_usrmsg = str_replace( '[%4]', $lv_tab, $lv_usrmsg);
          $lv_usrmsg = str_replace( '[%9]', 'https://temasis.com.ar/clientes/teaminfusionar/', $lv_usrmsg );
          $lv_emlprm['bodyhtml'] = $lv_usrmsg;
          if ( $lo_eml->send( $lv_emlprm ) ) {
            return '';
          } else {
            $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
            //r_dump($lv_errtxt);
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>$lv_errtxt) );
          }
        }					
        break;      
			// --------------------------------------------------------------------
			//
			// ROCHE
			//
			// --------------------------------------------------------------------		
				
				
				// DASHBOARD

				// LISTA DE PACIENTES 
				case "#rchdsh":					
					// Obtengo lista de pacientes de clase de documento prospect
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]dc.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'PRO'.chr(9).chr(9) );
					$lo_rs = $lo_patmdl->getList($lv_prm, null, null, false);
					return $this->getView( 'zcutp1_tin_rchdsh', array('patlst'=>$lo_rs) );
					break;
				
				
				
				//CARGA PACIENTE. Se carga nuevo paciente en el formulario roche
				case "#rchfrm01":
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->create();
					$this->lo_mdl = $lo_patmdl;
					return $this->getView( 'zcutp1_tin_rchfrm', array( "actcod" => '01') );
					break;
				
				//VER PACIENTE. Se visualiza datos del paciente
				case "#rchfrm03":
					$lp_patcod = $_GET['prm_patcod'];
					
					$lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'='.chr(9).chr(9).$lp_patcod.chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_patprsrlsmdl->getList($lv_prm);
					if(count($lo_rs)>0){
						$lv_patprsrlscod = $lo_rs[0]['patprsrlscod'];
						$lo_patprsrlsmdl->load( array('patprsrlscod' => $lv_patprsrlscod));
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error al cargar datos del rol</errtxt>';
					}

					$lo_patmdl = $this->co_reg->load->model('hltpat');					
					if($lo_patmdl->load( array( 'patcod' => $lp_patcod),false ) == false){
						return '<errtyp>E</errtyp><errcod>'.$lo_patmdl->errcod.'</errcod><errtxt>'.$lo_patmdl->errtxt.'</errtxt>';
					};
					
					$lo_patmdl->patprsrlsatr001 = $lo_patprsrlsmdl->patprsrlsatr001;
					$this->lo_mdl = $lo_patmdl;
					return $this->getView( 'zcutp1_tin_rchfrm', array( "actcod" => '03') );
					break; 
				
				//GRABADO PACIENTES. 
				// 1- Se graba paciente 
				// 2- Se crea contacto
				// 3- Se envia un mail de confirmacion
				case "#rchfrmsve":
					$lo_post = $this->co_reg->request->post;

					// CLASE DE DOCUMENTO. Se obtiene clase de documento PROSPECT
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'PRO'.chr(9).chr(9).
																				'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_docclsmdl->getList($lv_prm);
					$lv_sysdocclscod = '';
					if(count($lo_rs)>0){ 
						$lv_sysdocclscod = $lo_rs[0]['sysdocclscod']; 
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener la clase de documento [cod:PRO]</errtxt>';
					}

					// MOTIVO DE CONTACTO. Obtengo motivo de contacto ROCHE
					$lo_cntmtvmdl = $this->co_reg->load->model('crmcntmtv');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]m.crmcntmtvcodext'.chr(9).'='.chr(9).chr(9).'ROCHE'.chr(9).chr(9).
																				'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_cntmtvmdl->getList($lv_prm, null, null, false);//$lo_rs = $lo_cntmtvmdl->getList($lv_prm, null, null, false);//seguridad CRM
					foreach($lo_rs as $lv_row){
						$lo_post['crmcnttypcod'] = $lv_row['crmcnttypcod'];					
						$lo_post['crmcntmtvcod'] = $lv_row['crmcntmtvcod'];					
						$lo_post['crmcntprtcod'] = $lv_row['crmcntprtcod'];					
						$lo_post['crmcntstscod'] = $lv_row['crmcntstscod'];					
					}	

					// ROLES. Obtengo rol de medico
					$lo_rlsmdl = $this->co_reg->load->model('hltprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																				'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_rlsmdl->getList($lv_prm);//$lo_rs = $lo_rlsmdl->getList($lv_prm, null, null, false);//seguridad CRM
					if(count($lo_rs)>0){
						$lv_rlscod = $lo_rs[0]['prsrlscod'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener el rol [cod:MEC]</errtxt>';
					}

					// FINANCIADOR. se determina el financiador
					$lo_cusmdl = $this->co_reg->load->model('slscus');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cuscodext'.chr(9).'='.chr(9).chr(9).'ROCHE'.chr(9).chr(9).
																				'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_cusmdl->getList($lv_prm, null, null, false);
					if(count($lo_rs)>0){
						$lv_cuscod = $lo_rs[0]['cuscod'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener el financiador [cod:ROCHE]</errtxt>';
					}
					
					//PACIENTES. Grabo paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_post['sysdocclscod'] = $lv_sysdocclscod;	
					$lo_post['cuscod'] = $lv_cuscod;
					//Fecha actual de solicitud
					$lo_post['patreqdte'] = date('d/m/Y');
					if( $lo_patmdl->save( $lo_post )==false ) {
						return '<errtyp>E</errtyp><errcod>'.$lo_patmdl->errcod.'</errcod><errtxt>'.$lo_patmdl->errtxt.'</errtxt>';
					}

					//MEDICO ROL. Grabo el medico con su respectivo rol asignado
					$lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
					$lo_post['patprsrlscod'] = '';
					$lo_post['prsrlscod'] = $lv_rlscod;
					$lo_post['patcod'] = $lo_patmdl->patcod;
					$lo_post['patprsrlsatr001'] = '<patprsrlstxt>'.$lo_post['patprsrlstxt'].'</patprsrlstxt>'.
																				'<patprsrlsphn>'.$lo_post['patprsrlsphn'].'</patprsrlsphn>';
					$lo_post['docsts'] = 'A';
					if( $lo_patprsrlsmdl->save($lo_post)==false ) {
						return '<errtyp>E</errtyp><errcod>'.$lo_patprsrlsmdl->errcod.'</errcod><errtxt>'.$lo_patprsrlsmdl->errtxt.'</errtxt>';
					}					

					// CONTACTO PACIENTE. Grabo contacto crm
					$lo_cntmdl = $this->co_reg->load->model('crmcnt');
					$lo_post['crmcnttxt'] = 'Paciente Roche';
					$lo_post['crmcntsrctyp'] = 'HLT_PAT';
					$lo_post['crmcntsrccod'] = $lo_patmdl->patcod;
					$lo_post['crmcntdte'] = $lo_post['patreqdte'];
					if( $lo_cntmdl->save($lo_post,false)==false ) {//if( $lo_cntmdl->save($lo_post, false)==false ) {//seguridad CRM
						return '<errtyp>E</errtyp><errcod>'.$lo_cntmdl->errcod.'</errcod><errtxt>'.$lo_cntmdl->errtxt.'</errtxt>';
					}

					//CONTACTO MEDICO. Grabo contacto crm
					$lo_post['crmcnttxt'] = 'MED: '.$lo_post['patprsrlstxt'].' TEL: '.$lo_post['patprsrlsphn'];
					$lo_post['crmcntsrctyp'] = 'HLT_PAT';
					$lo_post['crmcntsrccod'] = $lo_patmdl->patcod;
					$lo_post['crmcntdte'] = $lo_post['patreqdte'];
					if( $lo_cntmdl->save($lo_post,false)==false ) {//if( $lo_cntmdl->save($lo_post, false)==false ) {//seguridad CRM
						return '<errtyp>E</errtyp><errcod>'.$lo_cntmdl->errcod.'</errcod><errtxt>'.$lo_cntmdl->errtxt.'</errtxt>';
					}

					// obtengo mensaje de notificacion
          $lv_txtcodext = 'HLTPATNTF';
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');

          if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
              $lv_usrmsg = $lo_txtmdl->txttxt;
          } else {
              $lv_errcod .= -1003;
              $lv_errtxt .= ' No se pudo cargar el texto de notificacion de errores ['.$lv_txtcodext.']. ';
          }

					// DESTINATARIOS. determino destinatarios segun entorno
					$lv_env = $this->co_reg->config->get('environmet');
					$lv_mailto = array();
					if($lv_env=='dev'){
						//$lv_mailto[] = array('address'=>'chisas@temasis.com.ar');
						//$lv_mailto[] = array('address'=>'mdominguez@temasis.com.ar');
            $lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
						$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
					}else if($lv_env=='prd'){
						$lv_mailto[] = array('address'=>'coordinacion@teaminfusion.com');
						$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');

					}

					// TABLA DE DATOS. Visualizacion de datos cargados
					$lv_phn = ($lo_post['adrphn001'] != '' && $lo_post['adrphn002'] != '') ? $lo_post['adrphn001'].'/'.$lo_post['adrphn002'] : ( ($lo_post['adrphn001'] == '') ? ( ($lo_post['adrphn002'] == '') ? '-' : $lo_post['adrphn002'] ) : $lo_post['adrphn001'] ) ;

					$lv_tab =	'<table width="100%" cellpadding=3 cellspacing=3 border=0>'.
											'<tbody>'.
												'<tr><td width="100">Protocolo</td><td><b>'.$lo_post['patpro'].'</b></td></tr>'.
												'<tr><td width="100">Tel&eacute;fono</td><td><b>'.$lv_phn.'</b></td></tr>'.
												'<tr><td width="100">Celular</td><td><b>'.($lo_post['adrmblphn'] == '' ? '-': $lo_post['adrmblphn']).'</b></td></tr>'.
												'<tr><td width="100">Email</td><td><b>'.$lo_post['adreml'].'</b></td></tr>'.
												'<tr><td width="100">M&eacute;dico</td><td><b>'.$lo_post['patprsrlstxt'].'</b></td></tr>'.
												'<tr><td width="100">Tel&eacute;fono de contacto</td><td><b>'.$lo_post['patprsrlsphn'].'</b></td></tr>'.
											'</tbody>'.
										'</table>';
										
					//MAIL. Envío mail
					if ( $lv_usrmsg!='' && count($lv_mailto)>0 ) {
						$lo_eml = new tmssMail();
						$lv_emlprm['to'] = $lv_mailto;
						$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Infusion ') );
						$lv_emlprm['subject'] = 'Alta de paciente ROCHE';
						$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
						$lv_usrmsg = str_replace( '[%2]', 'Nuevo Paciente' , $lv_usrmsg);
						$lv_usrmsg = str_replace( '[%3]', $lo_patmdl->patcod, $lv_usrmsg);
						$lv_usrmsg = str_replace( '[%4]', $lv_tab, $lv_usrmsg);
						$lv_usrmsg = str_replace( '[%9]', 'https://temasis.com.ar/clientes/teaminfusionar/', $lv_usrmsg );
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
					break;
				
			//----------------------------------------------------------------------------------------------//
				
				// DASHBOARD - MEDICOS
				case "#rchmeddsh":

					// PARAMETROS. obtengo paráemtro que identifica a prestadores
					$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
					$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
					if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
				
					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																				'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																				, 'vewmaxrec'=>'1');
					$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
					if ( count($lo_usrprmprs_rs)>0 ) { 
						$lv_prscod = $lo_usrprmprs_rs[0]['prmval'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El usuario no tiene asignado ID de prestador.</errtxt>';
					}

					// ROLES. Obtengo rol de medico
					$lo_rlsmdl = $this->co_reg->load->model('hltprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																				'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rls_rs = $lo_rlsmdl->getList($lv_prm);
					if(count($lo_rls_rs)>0){
						$lv_rlscod = $lo_rls_rs[0]['prsrlscod'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener el rol [cod:MEC]</errtxt>';
					}		

					// PACIENTE PRESTADOR. Obtengo lista de pacientes por prestador
					$lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]p.prsrlscod'.chr(9).'='.chr(9).chr(9).$lv_rlscod.chr(9).chr(9).
																				'[~fltrow~]p.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9) );
					$lo_patprsrls_rs = $lo_patprsrlsmdl->getList($lv_prm);
					return $this->getView( 'zcutp1_tin_rchmeddsh', array('patlst'=>$lo_patprsrls_rs) );
					break;
				
				
				
				// FORMULARIOS - PACIENTES
				
				
				
				// ROCHE. MEDICOS. NUEVO PACIENTE.
				case '#rchmedfrm01':
					$lo_post = $this->co_reg->request->post;
					$this->lo_mdl = new stdClass;
					
					// PACIENTE. inicializo datos de paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->create();
					$this->lo_mdl = $lo_patmdl;
					
					// PARAMETROS. obtengo paráemtro que identifica a prestadores
					$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
					$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
					if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
					
					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																				'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																				, 'vewmaxrec'=>'1');
					$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
					if ( count($lo_usrprmprs_rs)>0 ) { 
						$lv_prscod = $lo_usrprmprs_rs[0]['prmval'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El usuario no tiene asignado ID de prestador.</errtxt>';
					}
					
					// PRESTADOR. cargo datos de prestador
					$lo_prsmdl = $this->co_reg->load->model('hltprs');
					$lo_prsmdl->load( array('prscod'=>$lv_prscod) );
					$this->lo_mdl->prs = $lo_prsmdl;
					
					// EVOLUCION. inicializo datos de evolucion
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					$lo_evlmdl->create();
					$this->lo_mdl->evl = $lo_evlmdl;
					
					// RESPUESTA. muestro vista
					return $this->getView('zcutp1_tin_rchmedfrm', array('actcod'=>'01'));
					break;
				
				
				
				// ROCHE. MEDICOS. VISUALIZACION/MODIFICACION PACIENTE.
				case '#rchmedfrm02': case '#rchmedfrm03':
					$lo_post = $this->co_reg->request->post;
					$this->lo_mdl = new stdClass;
					$lv_patcod = (isset($lp_prm['patcod'])?$lp_prm['patcod']:'');
					$lv_evlcod = (isset($lo_post['evlcod'])?$lo_post['evlcod']:'');
					$lv_hhcc = (isset($lo_post['hhcc'])?$lo_post['hhcc']:'');

					// EVOLUCION. cargo datos de primera evolucion
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if( $lv_evlcod!='' ){
						$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );
						$lv_patcod = $lo_evlmdl->patcod;
					}
					
					// PACIENTE. cargo datos de paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->load( array('patcod'=>$lv_patcod), false );
					$this->lo_mdl = $lo_patmdl;
					
					// PARAMETROS. obtengo paráemtro que identifica a prestadores
					$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
					$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
					if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
				
					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lo_prsmdl = $this->co_reg->load->model('hltprs');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																				'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																				, 'vewmaxrec'=>'1');
					$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
					if ( count($lo_usrprmprs_rs)>0 ) { 
						$lv_prscod = $lo_usrprmprs_rs[0]['prmval'];
						$lo_prsmdl->load( array( 'prscod' => $lv_prscod), false );
					} else {
						//return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El usuario no tiene asignado ID de prestador.</errtxt>';
					}
					$this->lo_mdl->prs = $lo_prsmdl;
					
					// ESPECIALIDAD. se determina la especialidad 
					$lo_spcmdl = $this->co_reg->load->model('hltspc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'RCHMEDFRMEVL'.chr(9).chr(9).
																				'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_spcmdl->getList($lv_prm);
					if(count($lo_rs)>0){
						$lv_spccod = $lo_rs[0]['spccod'];
					} else if($lv_act!='#rchmedfrm03'){
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener una especialidad [cod:RCHMEDFRMEVL]</errtxt>';
					}
					
					// EVOLUCION. se carga si no se informo por parámetro
					if($lv_evlcod==''){
						$lv_prm = array('vewfldflt' =>'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
																					'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9).
																					'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9).$lv_spccod.chr(9).chr(9).
																					'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewmaxrec'=> '1',
														'vewfldord' => 'e.ctedte');
						$lo_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
						if(count($lo_rs)>0){
							$lv_evlcod = $lo_rs[0]['evlcod'];
							$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );
						}
					}
					$this->lo_mdl->evl = $lo_evlmdl;
					$this->lo_mdl->evl->hhcc = $lv_hhcc;
					
					// DOCUMENTO FIRMADO. cargo documento firmado
					$lo_sgndocmdl = $this->co_reg->load->model('admsgndoc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]sd.sgndocsrccod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9).
																				'[~fltrow~]sd.sgndocsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																				'[~fltrow~]sd.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
					$lo_sgndocrs = $lo_sgndocmdl->getList($lv_prm);

					// RESPUESTA. devuelvo vista con datos
					return $this->getView( ($lv_hhcc==''?'zcutp1_tin_rchmedfrm':'zcutp1_tin_rchmedfrmevl'), array('actcod'=>($lp_act=='#rchmedfrm03'?'03':'02'), 'sgndoc'=>$lo_sgndocrs) );
					break;
				
				
				
				// ROCHE. MEDICOS. GRABADO de PACIENTE
				// 1-graba los datos del paciente (formulario de pacientes)
				// 2-crea contacto crm
				// 3-envia mail de notificación
				case '#rchmedfrmsve':
					$lo_post = $this->co_reg->request->post;
					// Parametros del modulo
					$lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
					
					// PARAMETROS. obtengo paráemtro que identifica a prestadores
					$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
					$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
					if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
				
					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																				'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																				, 'vewmaxrec'=>'1');
					$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
					if ( count($lo_usrprmprs_rs)>0 ) { 
						$lv_prscod = $lo_usrprmprs_rs[0]['prmval'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El usuario no tiene asignado ID de prestador.</errtxt>';
					}
									
					// CLASE DE DOCUMENTO. obtengo clase de documento de paciente a travez de los  parametros del módulo
					$lo_mdlprm->load( array('mdlcod'=>'PCLS') );
					$lv_sysdocclscod =$this->co_reg->document->getTagValue(strtoupper($lo_mdlprm->mdlatrval001),$lo_post['matcodext'] );
					if($lv_sysdocclscod==''){
						$lv_sysdocclscod= $this->co_reg->document->getTagValue(strtoupper($lo_mdlprm->mdlatrval001),'DEF' );
					}

					if($lv_sysdocclscod==''){
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener la clase de documento [cod:'.$lo_post['matcodext'] .']</errtxt>';
					}


					// ESPECIALIDAD. se determina la especialidad a grabar
					$lo_spcmdl = $this->co_reg->load->model('hltspc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'RCHMEDFRMEVL'.chr(9).chr(9).
																				'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_spcmdl->getList($lv_prm);
					if(count($lo_rs)>0){
						$lv_spccod = $lo_rs[0]['spccod'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener una especialidad [cod:RCHMEDFRMEVL]</errtxt>';
					}
					
					// MOTIVO DE CONTACTO. obtengo info de motivo de contacto con codigo ROCHE
					$lo_cntmtvmdl = $this->co_reg->load->model('crmcntmtv');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]m.crmcntmtvcodext'.chr(9).'='.chr(9).chr(9).'ROCHE'.chr(9).chr(9).
																				'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_cntmtvmdl->getList($lv_prm, null, null, false);//$lo_rs = $lo_cntmtvmdl->getList($lv_prm, null, null, false);//seguridad CRM
					if(count($lo_rs)>0){
						$lo_post['crmcnttypcod'] = $lo_rs[0]['crmcnttypcod'];					
						$lo_post['crmcntmtvcod'] = $lo_rs[0]['crmcntmtvcod'];					
						$lo_post['crmcntprtcod'] = $lo_rs[0]['crmcntprtcod'];					
						$lo_post['crmcntstscod'] = $lo_rs[0]['crmcntstscod'];					
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo determinaro un motivo de contacto [cod:ROCHE]</errtxt>';
					}

					/*  FINANCIADOR. se determina el financiador a travez de los  parametros del módulo */
					$lo_mdlprm->load( array('mdlcod'=>'HLTCU') );
					$lv_cuscod =$this->co_reg->document->getTagValue(strtoupper($lo_mdlprm->mdlatrval001),$lo_post['matcodext'] );
					if($lv_cuscod==''){
						$lv_cuscod= $this->co_reg->document->getTagValue(strtoupper($lo_mdlprm->mdlatrval001),'DEF' );
					}

					if($lv_cuscod==''){
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener el financiador [cod:'.$lo_post['matcodext'] .']</errtxt>';
					}

					



					// ROLES. Obtengo rol de medico
					$lo_rlsmdl = $this->co_reg->load->model('hltprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																				'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_rs = $lo_rlsmdl->getList($lv_prm);
					if(count($lo_rs)>0){
						$lv_rlscod = $lo_rs[0]['prsrlscod'];
					} else {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo obtener el rol [cod:MEC]</errtxt>';
					}
					
					// PACIENTE. grabo datos de paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_post['sysdocclscod'] = $lv_sysdocclscod;
					$lo_post['cuscod'] = $lv_cuscod;
					$lo_post['patreqdte'] = date('d/m/Y'); //Fecha actual de solicitud

					$lo_post['pathgh']= isset($lo_post['pathgh'])?$lo_post['pathgh']:'0';
					$lo_post['patatrval001']= '<patwgt>'.$lo_post['patwgt'].'</patwgt>'.
																		'<pathgh>'.$lo_post['pathgh'].'</pathgh>';
					if( $lo_patmdl->save( $lo_post )==false ) {
						return '<errtyp>E</errtyp><errcod>'.$lo_patmdl->errcod.'</errcod><errtxt>'.$lo_patmdl->errtxt.'</errtxt>';
					}
					$lo_patmdl->load( array('patcod'=>$lo_patmdl->patcod), false );
					$this->lo_mdl = $lo_patmdl;

					// PRESTADOR. cargo datos de prestador
					$lo_prsmdl = $this->co_reg->load->model('hltprs');
					$lo_prsmdl->load( array('prscod'=>$lv_prscod), false ); 
					$this->lo_mdl->prs = $lo_prsmdl;

					// EVOLUCION. grabo evolución de paciente
					$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
					$lo_post['evlcod'] = '';
					$lo_post['patcod'] = $lo_patmdl->patcod;
					$lo_post['spccod'] = $lv_spccod;
					$lo_post['prscod'] = $lv_prscod;
					$lo_post['evldte'] = date('d/m/Y'); 
					$lo_post['docsts'] = 'A';
					$lo_post['evlatr001'] = '<ref>'.$lo_post['evlatrref'].'</ref>'.
																	'<hltdisclstxt>'.$lo_post['hltdisclstxt'].'</hltdisclstxt>'.
																	'<dos>'.$lo_post['evlatrdos'].'</dos>'.
																	'<cntv>'.$lo_post['evlatrcntv'].'</cntv>'.
																	'<drg>'.$lo_post['evlatrdrg'].'</drg>'.
																	'<madm>'.$lo_post['evlatrmadm'].'</madm>'.
																	'<tadm>'.$lo_post['evlatrtadm'].'</tadm>'.
																	'<patwgt>'.$lo_post['patwgt'].'</patwgt>'.																	
																	'<mattxt>'.utf8_decode($lo_post['mattxt']).'</mattxt>'.
																	'<matcodext>'.$lo_post['matcodext'].'</matcodext>'.
																	'<matcod>'.$lo_post['matcod'].'</matcod>'.
																	'<dil>'.$lo_post['evlatrdil'].'</dil>'.
																	'<mattxt>'.$lo_post['mattxt'].'</mattxt>'.
																	'<fre>'.$lo_post['evlatrfre'].'</fre>'.
																	'<her001>'.((isset($lo_post['evlher001']))?$lo_post['evlher001']:'').'</her001>'.
																	'<her002>'.((isset($lo_post['evlher002']))?$lo_post['evlher002']:'').'</her002>'.
																	'<her003>'.((isset($lo_post['evlher003']))?$lo_post['evlher003']:'').'</her003>'.
																	'<apt>'.((isset($lo_post['evlapt']))?$lo_post['evlapt']:'').'</apt>'.
																	'<hta>'.((isset($lo_post['evlatrhta']))?$lo_post['evlatrhta']:'').'</hta>'.
																	'<ci>'.((isset($lo_post['evlatrci']))?$lo_post['evlatrci']:'').'</ci>'.
																	'<sp>'.((isset($lo_post['evlatrsp']))?$lo_post['evlatrsp']:'').'</sp>'.
																	'<epc>'.((isset($lo_post['evlatrepc']))?$lo_post['evlatrepc']:'').'</epc>'.
																	'<irc>'.((isset($lo_post['evlatrirc']))?$lo_post['evlatrirc']:'').'</irc>'.
																	'<epi>'.((isset($lo_post['evlatrepi']))?$lo_post['evlatrepi']:'').'</epi>'. 
																	'<icc>'.((isset($lo_post['evlatricc']))?$lo_post['evlatricc']:'').'</icc>'.
																	'<arrtms>'.((isset($lo_post['evlatrarrtms']))?$lo_post['evlatrarrtms']:'').'</arrtms>'.
																	'<asm>'.((isset($lo_post['evlatrasm']))?$lo_post['evlatrasm']:'').'</asm>'.
																	'<tbq>'.((isset($lo_post['evlatrtbq']))?$lo_post['evlatrtbq']:'').'</tbq>'.
																	'<acv>'.((isset($lo_post['evlatracv']))?$lo_post['evlatracv']:'').'</acv>'.
																	'<alg>'.((isset($lo_post['evlatralg']))?$lo_post['evlatralg']:'').'</alg>'.
																	'<medcro>'.$lo_post['evlatrmedcro'].'</medcro>'.
																	'<drgpardss>'.$lo_post['evlatrdrgpardss'].'</drgpardss>'.
																	'<drgparfrq>'.$lo_post['evlatrdrgparfrq'].'</drgparfrq>'.
																	'<drgdifdss>'.$lo_post['evlatrdrgdifdss'].'</drgdifdss>'.
																	'<drgdiffrq>'.$lo_post['evlatrdrgdiffrq'].'</drgdiffrq>'.
																	'<drgotr001>'.$lo_post['evlatrdrgotr001'].'</drgotr001>'.
																	'<drgotr001dss>'.$lo_post['evlatrdrgotr001dss'].'</drgotr001dss>'.
																	'<drgotr001frq>'.$lo_post['evlatrdrgotr001frq'].'</drgotr001frq>'.
																	'<drgotr002>'.$lo_post['evlatrdrgotr002'].'</drgotr002>'.
																	'<drgotr002dss>'.$lo_post['evlatrdrgotr002dss'].'</drgotr002dss>'.
																	'<drgotr002frq>'.$lo_post['evlatrdrgotr002frq'].'</drgotr002frq>';
					if ( $lo_patevlmdl->save( $lo_post, false )==false ) {
						return '<errcod>'.$lo_patevlmdl->errcod.'</errcod><errtxt>'.$lo_patevlmdl->errtxt.'</errtxt>';
					}
					$lo_patevlmdl->load( array('evlcod'=>$lo_patevlmdl->evlcod), false );
					$this->lo_mdl->evl = $lo_patevlmdl;

					//MEDICO ROL. Grabo el medico con su respectivo rol asignado
					$lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
					$lo_post['patprsrlscod'] = '';
					$lo_post['prsrlscod'] = $lv_rlscod;
					$lo_post['patcod'] = $lo_patmdl->patcod;
					$lo_post['prscod'] = $lv_prscod;
					$lo_post['docsts'] = 'A';
					if( $lo_patprsrlsmdl->save($lo_post)==false ) {
						return '<errtyp>E</errtyp><errcod>'.$lo_patprsrlsmdl->errcod.'</errcod><errtxt>'.$lo_patprsrlsmdl->errtxt.'</errtxt>';
					}

					// CONTACTO. grabo contacto crm
					$lo_cntmdl = $this->co_reg->load->model('crmcnt');
					$lo_post['crmcnttxt'] = 'Paciente Roche DshMed';
					$lo_post['crmcntsrctyp'] = 'HLT_PAT';
					$lo_post['crmcntsrccod'] = $lo_patmdl->patcod;
					$lo_post['crmcntdte'] = $lo_post['patreqdte'];
					if( $lo_cntmdl->save($lo_post,false)==false ) {//if( $lo_cntmdl->save($lo_post, false)==false ) {//seguridad CRM
						return '<errtyp>E</errtyp><errcod>'.$lo_cntmdl->errcod.'</errcod><errtxt>'.$lo_cntmdl->errtxt.'</errtxt>';
					}
					/*
					// TEXTO MENSAJE. obtengo texto del mensaje
					$lo_txtmdl = $this->co_reg->load->model('grldattxt');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTPATNTF'.chr(9).chr(9).
																				'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9),
													'vewmaxrec'=>'1');
					$lo_rs = $lo_txtmdl->getList($lv_prm);
					if( count($lo_rs)!=0 ) {
						$lv_usrmsg = $lo_rs[0]['txttxt'];
					} else {
						// texto por default si no hay texto de mensaje
						$lv_usrmsg = 'Se realizo el alta de paciente [%3].';
					}
          */
        	// obtengo mensaje de notificacion
          $lv_txtcodext = 'HLTPATNTF';
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');

          if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
            $lv_usrmsg = $lo_txtmdl->txttxt;
          } else {
          	// texto por default si no hay texto de mensaje
						$lv_usrmsg = 'Se realizo el alta de paciente [%3].';
          }
					
					// DESTINATARIOS. determino destinatarios segun entorno
					$lv_env = $this->co_reg->config->get('environmet');
					$lv_mailto = array();
					if($lv_env=='dev'){
						//$lv_mailto[] = array('address'=>'chisas@temasis.com.ar');
						//$lv_mailto[] = array('address'=>'mdominguez@temasis.com.ar');
						//$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
						$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
					}else if($lv_env=='prd'){
						$lv_mailto[] = array('address'=>'coordinacion@teaminfusion.com');
						$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
					}
					
					// MAIL. envío mail
					if ( $lv_usrmsg!='' && count($lv_mailto)>0 ) {
						$lo_eml = new tmssMail();
						$lv_emlprm['to'] = $lv_mailto;
						$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Infusion ') );
						$lv_emlprm['subject'] = 'Alta de paciente ROCHE';
						$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
						$lv_usrmsg = str_replace( '[%2]', 'Nuevo Paciente' , $lv_usrmsg);
						$lv_usrmsg = str_replace( '[%3]', $lo_patmdl->patcod, $lv_usrmsg);
						$lv_usrmsg = str_replace( '[%4]', ' ', $lv_usrmsg );						
						$lv_usrmsg = str_replace( '[%9]', 'https://temasis.com.ar/clientes/teaminfusionar/', $lv_usrmsg );						
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
					
					// DOCUMENTO FIRMADO. cargo documento firmado
					$lo_sgndocmdl = $this->co_reg->load->model('admsgndoc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]sd.sgndocsrccod001'.chr(9).'='.chr(9).chr(9).$lo_patevlmdl->evlcod .chr(9).chr(9).
																				'[~fltrow~]sd.sgndocsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																				'[~fltrow~]sd.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
					$lo_sgndocrs = $lo_sgndocmdl->getList($lv_prm);
					
					// RESPUESTA. devuelvo vista con datos
					return $this->getView( 'zcutp1_tin_rchmedfrm', array('actcod'=>'03', 'sgndoc'=>$lo_sgndocrs) );
					break;
				
				
				
				// ROCHE. MEDICOS. IMPRESION
				
				
				
				// ROCHE. MEDICOS. IMPRESION. ORDEN MEDICA
				case '#rchpatevlpnt':
					$lo_post = $this->co_reg->request->post;
					$this->lo_mdl = new stdClass;
					
					// EVOLUCION. Obtengo el codigo de evolucion 
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					$lv_evlcod = (isset($lo_post['evlcod'])?$lo_post['evlcod']:$lp_prm['evlcod']);
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );
					$this->lo_mdl->evl = $lo_evlmdl;

					// PACIENTE. Cargo paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat'); 
					$lo_patmdl->load( array('patcod'=>$lo_evlmdl->patcod), false );
					$this->lo_mdl->pat = $lo_patmdl;

					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lo_prsmdl = $this->co_reg->load->model('hltprs');
					$lo_prsmdl->load( array('prscod'=>$lo_evlmdl->prscod), false );
					/*
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																				'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																				, 'vewmaxrec'=>'1');
					$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
					if ( count($lo_usrprmprs_rs)>0 ) { 
						$lv_prscod = $lo_usrprmprs_rs[0]['prmval'];
						$lo_prsmdl->load( array( 'prscod' => $lv_prscod) );
					} else if(isset($lp_prm['sgndat'])) {
						return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El usuario no tiene asignado ID de prestador.</errtxt>';
					}
					*/					
					$this->lo_mdl->prs = $lo_prsmdl;					

					// FIRMA. obtengo datos para firma de documento
					$lv_sgndat = (isset($lp_prm['sgndat'])?$lp_prm['sgndat']:array());
					$this->lo_mdl->sgndat = $lv_sgndat;

					// RESPUESTA. devuelvo formulario
					$this->co_reg->response->addHeader('Content-type:application/pdf'); 
					return $this->getView('zcutp1_tin_rchpatevlpnt');					
					break;
				
				
				
				// ROCHE. MEDICOS. IMPRESION. HISTORIA CLINICA
				case '#rchpathcpnt':
					$lo_post = $this->co_reg->request->post;
					$this->lo_mdl = new stdclass;
					
					// EVOLUCION. Obtengo el codigo de evolucion 
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					$lv_evlcod = (isset($lo_post['evlcod'])?$lo_post['evlcod']:$lp_prm['evlcod']);
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );
					$this->lo_mdl->evl = $lo_evlmdl;
					
					// PACIENTE. Cargo modelo evolucion de paciente
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->load( array('patcod'=>$lo_evlmdl->patcod), false );
					$this->lo_mdl->pat = $lo_patmdl;

					// FIRMA. obtengo datos para firma de documento
					$lv_sgndat = (isset($lp_prm['sgndat'])?$lp_prm['sgndat']:array());
					$this->lo_mdl->sgndat = $lv_sgndat;

					// RESPUESTA. muestro el pdf
					$this->co_reg->response->addHeader('Content-type:application/pdf');
					return $this->getView('zcutp1_tin_rchpathccpnt');
					break;
				
				
				
				// ROCHE. MEDICOS. IMPRESION. CONSENTIMIENTO INFORMADO
				case '#rchpatcinpnt':
					$lo_post = $this->co_reg->request->post;
					$this->lo_mdl = new stdClass;
					
					// EVOLUCION. cargo evolucion 
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					$lv_evlcod = (isset($lo_post['evlcod'])?$lo_post['evlcod']:$lp_prm['evlcod']);
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );
					$this->lo_mdl->evl = $lo_evlmdl;
					
					// FIRMA. obtengo datos para firma de documento
					$lv_sgndat = (isset($lp_prm['sgndat'])?$lp_prm['sgndat']:array());
					$this->lo_mdl->sgndat = $lv_sgndat;
					
					// PRESTADOR. obtengo el id de prestador que corresponde al usuario actual
					$lo_prsmdl = $this->co_reg->load->model('hltprs');
					$lo_prsmdl->load( array('prscod'=>$lo_evlmdl->prscod), false );
					
        	$this->lo_mdl->prs = $lo_prsmdl;
					
					// PACIENTE. cargo paciente 
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->load( array('patcod' => $lo_evlmdl->patcod), false );
					$this->lo_mdl->pat = $lo_patmdl;
					
					// RESPUESTA. devuelvo formulario
					$this->co_reg->response->addHeader('Content-type:application/pdf');
					return $this->getView('zcutp1_tin_rchpatcinpnt');					
					break;
				
				
			
			
			
			// ---------------------------------------------------------------------
			//
			//	I N T E R F A C E S
			//
			// ---------------------------------------------------------------------
			
			//   P A C I E N T E S    a    C O N T A C T O S    L O G I N D O O R
      case '#PatToLG':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_tin&act=PatToLG_v2
        $lv_ret=array('errtyp'=>'E','errcod'=>0,'errtxt'=>'asta acá');

        /* determino el entorno en el que se está ejecutando */
        $lo_dat = $lp_prm['data'];
				$lo_dat['cntcodext'] = $lo_dat['patcod'];
				$lo_dat['cnttxt'] = $lo_dat['pattxt'];
				
				// obtengo datos de la interfaz
				$lo_itzmdl = $this->co_reg->load->model('sysint');
        if(!$lo_itzmdl->load(array('sysintcodext'=>'PAT_TO_LG'))){
          $lv_ret['errtyp']='S';
          $lv_ret['errcod']='1';
          $lv_ret['errtxt']='error. no se obtuvo la interfaz [PAT_TO_LG]';
          return $this->co_reg->document->getJson( $lv_ret);
        }
        $lo_dat['cntsrctyp'] = 'SLS_CUS';
        /*
        $lo_dat['cntsrccod'] = $lo_itzmdl->sysinatr['cuscod']??'';
        $lo_dat['sysdocclscodcnt'] = $lo_itzmdl->sysinatr['cnttypcod']??'';
        $lo_dat['cntsrccod'] = $lo_itzmdl->sysinatr['cuscod']??'';
        $lo_dat['apires'] = $lo_itzmdl->sysinatr['apiurl']??'';
        $lo_dat['prytkn'] = $lo_itzmdl->sysinatr['apitkn']??'';
        $lo_dat['usrcod'] = $lo_itzmdl->sysinatr['usrcod']??'';
        $lo_dat['usrpwd'] = $lo_itzmdl->sysinatr['usrpwd']??'';
        $lo_dat['endpoint'] = $lo_itzmdl->sysinatr['endpoint']??'';
        */
        $lvg_atr=$this->co_reg->document->getArrayFromXML($lo_itzmdl->sysintatr);
        
        $lo_dat['cntsrccod'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'cuscod');
        $lo_dat['sysdocclscodcnt'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'cnttypcod');
        $lo_dat['cntsrccod'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'cuscod');
        $lo_dat['apires'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'apiurl');
        $lo_dat['prytkn'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'apitkn');
        $lo_dat['usrcod'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'usrcod');
        $lo_dat['usrpwd'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'usrpwd');
        $lo_dat['endpoint'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'endpoint');
        
        $ctrCmd = $this->co_reg->load->controller('zcutp1_cmd');
        //Obtencion de tocken de usuario
        $lo_dat['apires'] = $lo_dat['endpoint'];
        $lo_dat['apires'] = '/';
        $lv_ret = $ctrCmd->callRemoteApi($lo_dat);
        $lv_ret['errtch']='';
        $lv_ret['snddata']='endpoint: ' .$lo_dat['endpoint'].$lo_dat['apires'] .PHP_EOL;
        $lv_ret['snddata'].='proyect-token: ' .$lo_dat['prytkn'] .PHP_EOL;
        $lv_ret['snddata'].='user: '.$lo_dat['usrcod'] .PHP_EOL;
        $lv_ret['snddata'].='password: ' .$lo_dat['usrpwd'] .PHP_EOL;
        $lv_ret['errmsg']=$lv_ret['errmsg']??'';
        $lv_log = array('sysintcod' => $lo_itzmdl->sysintcod,
                        'errtyp' => ($lv_ret['errtyp']??'E'), // error - tipo (E/W/S)
                        'errcod' => ($lv_ret['errcod']??'-1'), // error - codigo
                        'errtxt' => ($lv_ret['errtyp']!='S'?$lv_ret['errmsg']:'GetToken OK'),// error - descripcion
                        'errlog' => ($lv_ret['snddata']??''), // error - log extendido
                        'errtch' => ($lv_ret['errtch']??'') ); // error - log tecnico
        $lo_itzmdl->setRunData( $lv_log );
        if($lv_ret['errtyp']!='S'){
          return array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        }
        //Buscar contacto en el el cliente
        $lo_dat['usrtkn']=$lv_ret['token'];
        $lo_dat['PST']['code'] = $lo_dat['patcod'];
        $lv_grlcntcod='NEW?null'; 
        $lo_dat['PST']['address_zone']='';
        $lv_address_zone='';
        if ($lp_prm['action']=='UPDATE'){
          $lo_dat['apires']='/general-contacts/search?source_type=SLS_CUS&code=LIKE$'.$lo_dat['patcod'];
          $lv_ret = $ctrCmd->callRemoteApi($lo_dat);
          $lv_ret['errtch']='';
          $lv_ret['snddata']='endpoint: ' .$lo_dat['endpoint'].$lo_dat['apires'] .PHP_EOL;
          $lv_ret['snddata'].='proyect-token: ' .$lo_dat['prytkn'].PHP_EOL;
          $lv_ret['snddata'].='user-token: '.$lo_dat['usrtkn'].PHP_EOL;
          $lv_ret['errmsg']=$lv_ret['errmsg']??'';
          $lv_log = array('sysintcod' => $lo_itzmdl->sysintcod,
                          'errtyp' => ($lv_ret['errtyp']??'E'), // error - tipo (E/W/S)
                          'errcod' => ($lv_ret['errcod']??'-1'), // error - codigo
                          'errtxt' => ($lv_ret['errtyp']!='S'?$lv_ret['errmsg']:'List Contacts OK'),// error - descripcion
                          'errlog' => ($lv_ret['snddata']??''), // error - log extendido
                          'errtch' => ($lv_ret['errtch']??'') ); // error - log tecnico
          $lo_itzmdl->setRunData( $lv_log );
          if($lv_ret['errtyp']!='S'){
            return array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
          }
          foreach($lv_ret['data'] as $row_cnt){// Obtengo el codigo del contacto
            if($row_cnt['code']==$lo_dat['cntcodext']){
        			$lv_address_zone=$row_cnt['address_zone'];//$lo_dat['adrzoncod'];
              $lv_grlcntcod=$row_cnt['id'];
              break;
            }
          }
        }
        $lo_dat['grlcntcod']=$lv_grlcntcod;
        $lv_pst = array('documentclass_id' => $lo_dat['sysdocclscodcnt'] ?? '',
                        'source_id' => $lo_dat['cntsrccod'] ?? '',
                        'name' => $lo_dat['pattxt'] ?? '',
                        'source_type' => 'SLS_CUS',
                        'status' => 'A',
                        'code' => $lo_dat['patcod'] ?? '',

                        // DIRECCION
                        'address_street' => $lo_dat['adrstr'] ?? '',
                        'address_number' => $lo_dat['adrstrnum'] ?? '',
                        'address_floor' => $lo_dat['adrstrflr'] ?? '',
                        'address_unity' => $lo_dat['adrstrunt'] ?? '',
                        'address_postal_code' => $lo_dat['adrpstcod'] ?? '',
                        'address_building' => $lo_dat['adrstrbld'] ?? '',
                        'address_city' => $lo_dat['adrcty'] ?? '',
                        'address_town' => $lo_dat['adrtwn'] ?? '',
                        'address_region' => $lo_dat['lndregtxt'] ?? '',
                        'address_region_id' => $lo_dat['lndregcod'] ?? '',
                        'address_country_id' => $lo_dat['lndcod'] ?? '',
                        'address_zone'=>$lv_address_zone,

                        // CONTACTO
                        'address_phone' => $lo_dat['adrphn001'] ?? '',
                        'address_mobile_phone' => $lo_dat['adrmblphn'] ?? '',
                        'address_web' => $lo_dat['adrwebpge'] ?? '',
                        'address_email' => $lo_dat['adreml'] ?? '',

                        // DATOS PERSONALES
                        'borndate' => $lo_dat['perbrndte'] ?? '',
                        'sex' => $lo_dat['persex'] ?? '',
                        'maritalstatus_id' => $lo_dat['civstscod'] ?? '',
                        'nationality_name' => $lo_dat['pernattxt'] ?? '',
                        'nationality_id' => $lo_dat['pernatcod'] ?? '',

                        // COBERTURA MEDICA (default)
                        'medicalcoverage_name' => '',
                        'medicalcoverage_id' => '',
                        'medicalcoverage_plan' => $lo_dat['hhrmedcovaflpln'] ?? '',
                        'medicalcoverage_affiliate' => $lo_dat['hhrmedcovaflnum'] ?? ''
                    );

        // Carga modelo
        $lo_medcovmdl = $this->co_reg->load->model('hhrmedcov');

        if ($lo_medcovmdl->load(array('hhrmedcovcod' => $lo_dat['hhrmedcovcod'] ?? ''), false)) {
            $lv_pst['medicalcoverage_name'] = $lo_medcovmdl->hhrmedcovtxt ?? '';
            $lv_pst['medicalcoverage_id'] = $lo_medcovmdl->hhrmedcovcodext ?? '';
        }
        $lo_dat['PST']=$lv_pst;
        $lo_dat['apires']='/general-contacts/'.$lv_grlcntcod;
        $lv_ret = $ctrCmd->testSendApi($lo_dat);
        
        //Registro de log para el post de el contacto
        $lv_ret['errtch']='Paciente: ('  . $lo_dat['patcod'].') '. $lo_dat['pattxt'] .PHP_EOL;
        $lv_ret['errtch'].='EndPoint: '  . $lo_dat['endpoint']. ($lo_dat['apires']??'') .PHP_EOL;
        
        if($lv_ret['errtyp']!='S'){
          $lv_ret['errtch'].='Error: '  . ($lv_ret['errtxt']??'') .PHP_EOL;
        }
        $lv_ret['errmsg']=($lv_ret['errmsg']??($lv_ret['errtxt']??''));
        $lv_log = array('sysintcod' => $lo_itzmdl->sysintcod,
                        'errtyp' => ($lv_ret['errtyp']??'E'), // error - tipo (E/W/S)
                        'errcod' => ($lv_ret['errcod']??'-1'), // error - codigo
                        'errtxt' => ($lv_ret['errtyp']!='S'?$lv_ret['errmsg']:'set contact data OK'),// error - descripcion
                        'errlog' => ($lv_ret['snddata']??''), // error - log extendido
                        'errtch' => ($lv_ret['errtch']??'') ); // error - log tecnico
        $lo_itzmdl->setRunData( $lv_log );
        
        if(!isset($lv_ret['errtyp']) || $lv_ret['errtyp']=='E'){
          return $lv_ret;
        }
        $lv_ret['errtxt'] =$lo_dat['usrtkn'];
        return $lv_ret;
        break;
			//   P A C I E N T E S    a    C O N T A C T O S    L O G I N D O O R
      case '#PatToLG_old':
				//$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lv_errcod = 0;
				$lv_errtxt = '';
				//FIN UPDATE
				/* determino el entorno en el que se está ejecutando */
				$lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
				if($lv_issisdev === false){
					$lv_buscoddst='LOGIN'; 	
				}else{
					$lv_buscoddst='TEMASIS_LOG';
				}
				
				// obtengo los datos a procesar
				$lo_dat = $lp_prm['data'];
				$lo_datadr = $lp_prm['data'];
        
				$lo_dat['cntcodext'] = $lo_dat['patcod'];
				$lo_dat['cnttxt'] = $lo_dat['pattxt'];
				
				// obtengo datos de la interfaz
				$lo_itzmdl = $this->co_reg->load->model('sysint');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'PAT_TO_LG'.chr(9).chr(9).
																			'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_itzmdl->getList( $lv_prm );
				if(count($lo_rs)==1) {
					$lo_itzmdl->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) );
					$lo_dat['cntsrctyp'] = 'SLS_CUS';
					$lo_dat['cntsrccod'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'cuscod');
					$lo_dat['sysdocclscodcnt'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'cnttypcod');
				} else {
					$lv_errcod = -11;
					$lv_errtxt = 'error. no se obtuvo la interfaz [PAT_TO_LG]';
				}
				
				// obtengo contacto de cliente en destino
				if( $lv_errcod==0 ) {
					$lo_cntdst = $this->co_reg->load->model('grldatcnt');
					$lo_cntdst->setTempBuscod( $lv_buscoddst );
					$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntcodext'.chr(9).'='.chr(9).chr(9).$lp_prm['data']['patcod'] .chr(9).chr(9));
					$lo_rs = $lo_cntdst->getList($lv_prm,null,null,false);
					if( count($lo_rs)==1 ) {
						$lo_dat['cntcod'] = $lo_rs[0]['cntcod'];
					} else if( count($lo_rs)>=2 ) {
						$lv_errcod = -15;
						$lv_errtxt = 'error. se encontraron más de 1 contacto con el mismo código externo ['.$lp_prm['data']['patcod'].'].';
					}
				}
        
        if($lp_prm['action']=='UPDATE'){
          //obtiene los datos actuales del contacto
          $lo_cntdst->load( array( 'cntcod' => $lo_dat['cntcod'] ), false );

          // Calle
          $lo_datadr['adrstr'] = $lo_cntdst->adr->adrstr;
          // Numero
          $lo_datadr['adrstrnum'] = $lo_cntdst->adr->adrstrnum;
          // Piso
          $lo_datadr['adrstrflr'] = $lo_cntdst->adr->adrstrflr;
          // Edificio
          $lo_datadr['adrstrbld'] = $lo_cntdst->adr->adrstrbld;
          // Localidad
          $lo_datadr['adrtwntxt'] = $lo_cntdst->adr->adrtwntxt;
          
          // Partido
          $lo_datadr['adrcty'] = $lo_cntdst->adr->adrcty;
          // Codigo Postal
          $lo_datadr['adrpstcod'] = $lo_cntdst->adr->adrpstcod;
          
          // ZONA
          $lo_datadr['adrzon'] = $lo_cntdst->adr->adrzon;
          
          // Codigo Postal
          $lo_datadr['adrstrunt'] = $lo_cntdst->adr->adrstrunt;
          
          // Transporte
          $lo_datadr['trazoncod'] = $lo_cntdst->adr->trazoncod;
          
          
					if($lo_cntdst->docsts!='I'){
          	$lo_datadr['docsts'] = $lo_cntdst->docsts;
          }
          //return array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'' );
        	//break;
        }
        foreach($lo_datadr as $lv_key=>$lv_val) {
					if ( is_a($lv_val, 'DateTime') ) {
						$lo_dat[$lv_key] = $lv_val->format('d/m/Y');
					} else {
						$lo_dat[$lv_key] = $lv_val;
					}
				}
				
				// garbo contacto
				if( $lv_errcod==0 ) {
					$lo_cntdst->setTempBuscod( $lv_buscoddst );
					if( $lo_cntdst->save( $lo_dat,false )==false ) {
						$lv_errcod = -16;
						$lv_errtxt = 'error. se produjo un error al grabar el contacto en el destino.';
					}
				}
				
        // Registrar los datos de la última ejecución (sysintlstrunsts (E=Error, I=OK, W=Warning) y sysintlstrunlog)
        $lo_itzmdl->setRunData( array('sysintcod'=>$lo_itzmdl->sysintcod,	'errtyp'=>($lv_errcod==0?'I':'E'), 'errlog'=>($lv_errcod==0?'Procesado OK.':$lv_errtxt) ) );
				return true;
				break;
			
			
			//    R E P O R T E    -    R O C H E    1 0 
			case '#rptrch10':
				return $this->getView('zcutp1_ttrrptrch10');
	    	break;
			
			
	    //    R E P O R T E    -    R O C H E    1 0    -    D A T O S 
	    case '#rptrch10dat':
	    	include_once('./view/default/zcutp1_ttrfld.php');
	    	$lo_post = $this->co_reg->request->post;
	    	$lo_submdl = $this->co_reg->load->model('edusub');
	    	$lo_stuevlmdl = $this->co_reg->load->model('edustuevl');
	    	$lo_cntmdl = $this->co_reg->load->model('grldatcnt');
	    	$lo_stumdl = $this->co_reg->load->model('edustu');
	    	$data_sqlstm= array();

				// 1 - MATERIAS
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
																			   'vewfldord' => 'c.ctedte');
				$lo_sub_rs = $lo_submdl->getList($lv_prmflt);
				$lv_subflt ='';
				$lv_sublst =array();
				foreach( $lo_sub_rs as $lv_row ) {
					$lv_sublst[$lv_row['edusubcodext']]=$lv_row['edusubcod'];
				}
				$lv_subflt = $lv_sublst['FEE']; 

				/* 2.2- EVALUACIONES COLOCACION */
				$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';pd.eduplndte;docstscnv;es.edusubtxt;et.tchtxt;eu.stutxt;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]p.edusubcod'.chr(9).'IN'.chr(9).chr(9).$lv_subflt.chr(9).chr(9).
																			   '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
																			   'vewfldord' => 'pd.eduplndte desc,eu.stucod asc,es.edusubcod asc',
													'vewmaxrec'=>$lo_post['vewmaxrec']
												);
				$lo_evl_rs = $lo_stuevlmdl->getControlList( $lv_prmflt, array(), null, false ); 
				
				// 3- EVOLUCIONES
				// 3.1 FILTROS
				$lv_cntfltdata=false;
				$lv_fltfeddte_ee=false;
				$lv_fltfeddte_ne=false;
				$lv_fltarrevlenc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrevlenc)-1; $i>0; $i--){
					if(stripos(';estado;feeddte;feedq1;feedq2;feedq3;feedq4;evatxtcmt;status;motivo;evatxtcmt2;evacmt;',';'.explode(chr(9),$lv_fltarrevlenc[$i])[0].';')===false){
						unset($lv_fltarrevlenc[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrevlenc[$i]);
						if($lv_flt[0]=='estado'||$lv_flt[0]=='feedq1'||$lv_flt[0]=='feedq2'||$lv_flt[0]=='feedq3'||$lv_flt[0]=='feedq4'||$lv_flt[0]=='evatxtcmt'||$lv_flt[0]=='motivo'||$lv_flt[0]=='evatxtcmt2'||$lv_flt[0]=='evacmt'){
							$lv_flt[0]= 'dbo.GetTagValue(^'.$lv_flt[0].'^,EDUEVLATR001+EDUEVLATR002)';
							$lv_fltarrevlenc[$i]=implode(chr(9),$lv_flt);
							$lv_cntfltdata=true;
						}
						if ($lv_flt[0]=='feeddte') {
							if($lv_flt[1]=='EE'){
								$lv_fltfeddte_ee=true;
								$lv_cntfltdata=false;
								unset($lv_fltarrevlenc[$i]);
							}else if($lv_flt[1]=='NE'){
								$lv_fltfeddte_ne=true;
								$lv_cntfltdata=false;
								unset($lv_fltarrevlenc[$i]);
							}else{
								$lv_flt[0]= 'dbo.GetTagValue(^'.$lv_flt[0].'^,EDUEVLATR001+EDUEVLATR002)';
								$lv_fltarrevlenc[$i]=implode(chr(9),$lv_flt);
								$lv_cntfltdata=true;
							}
						}

						if ($lv_flt[0]=='status') {
							$lv_flt[0]= 'dbo.GetTagValue(^'.$lv_flt[0].'^,EDUEVLATR001+EDUEVLATR002)';
							$lv_fltin=array();
							foreach ($lv_fldstatus  as $key => $value) {
								if(strpos(strtoupper($value), strtoupper($lv_flt[2]))!==false){
									$lv_fltin[]=$key;
								}
							}
							$lv_flt[1]='IN';
							$lv_flt[2]='';
							$lv_flt[3]=implode(chr(10),$lv_fltin);;
							$lv_fltarrevlenc[$i]=implode(chr(9),$lv_flt);
							$lv_cntfltdata=true;
						}
				 	} 
				}

				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]e.edusubcod'.chr(9).'IN'.chr(9).chr(9).$lv_subflt.chr(9).chr(9).
																			   '[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			   (count($lv_fltarrevlenc)>0?implode('[~fltrow~]',$lv_fltarrevlenc):'').
																			   '[~fltrow~]e.evlrelsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9),
																			   'vewfldord' => 'e.evldte desc'
													);
				$lo_evl_data_rs = $lo_stuevlmdl->getList( $lv_prmflt, array(), null, false );		

				/* 3.1 - CONTACTOS APM - Traer los contactos de los alumnos ordenados por codigo de alumnos sysdocclscodext=CNTAPM (apm) CNTMED (Medico) */
				/*3.1.1 FILTRO APM */
				$lv_cntfltapm = false;
				$lv_cntfltapm_ee=false;
				$lv_cntfltapm_ne=false;
				$lv_fltarrcntapm = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrcntapm)-1; $i>0; $i--){
					if(stripos(';cnt.cnttxtapm;',';'.explode(chr(9),$lv_fltarrcntapm[$i])[0].';')===false){
						unset($lv_fltarrcntapm[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrcntapm[$i]);
				 		if($lv_flt[0]=='cnt.cnttxtapm'){
				 		 if($lv_flt[1]=='EE'){
								$lv_cntfltapm_ee=true;
								$lv_cntfltapm=false;
								unset($lv_fltarrcntapm[$i]);
							}else if($lv_flt[1]=='NE'){
								$lv_cntfltapm_ne=true;
								$lv_cntfltapm=false;
								unset($lv_fltarrcntapm[$i]);
							}else{
								$lv_cntfltapm = true; 
							}
				 		}
					}
				}
 
				/* 3.1.2 BUSCAR ALUMNOS APM - Traer todos los alumnos */
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcntapm)>0?str_replace('cnt.cnttxtapm','stutxt',implode('[~fltrow~]',$lv_fltarrcntapm)):''),
																			   'vewfldord' => 'p.stucod');
				$lo_stuapm_rs = $lo_stumdl->getList($lv_prmflt, array(), null, false);
				$lv_arrstuapm=array();
				foreach ($lo_stuapm_rs as $lv_rowstuapm) {
					$lv_arrstuapm[$lv_rowstuapm['stucod']]=$lv_rowstuapm['stutxt'];
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]ct.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'CNTAPM'.chr(9).chr(9).
																				 '[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).'EDU_STU'.chr(9).chr(9).
																			   '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
																			   'vewfldord' => 'c.cntsrccod');
				$lo_cntapm_rs = $lo_cntmdl->getList($lv_prmflt, null, null, false);

				/* 3.2 - CONTACTOS MEDICO - Traer los contactos de los alumnos ordenados por codigo de alumnos sysdocclscodext=CNTAPM (apm) CNTMED (Medico) */
				$lv_cntfltmed = false;
				$lv_cntfltmed_ee=false;
				$lv_cntfltmed_ne=false;
				$lv_fltarrcntmed = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrcntmed)-1; $i>0; $i--){
					if(stripos(';cnt.cnttxtmed;',';'.explode(chr(9),$lv_fltarrcntmed[$i])[0].';')===false){
						unset($lv_fltarrcntmed[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrcntmed[$i]);
				 		if($lv_flt[0]=='cnt.cnttxtmed'){
							if($lv_flt[1]=='EE'){
								$lv_cntfltmed_ee=true;
								$lv_cntfltmed=false;
								unset($lv_fltarrcntmed[$i]);
							}else if($lv_flt[1]=='NE'){
								$lv_cntfltmed_ne=true;
								$lv_cntfltmed=false;
								unset($lv_fltarrcntmed[$i]);
							}else{
								$lv_cntfltmed = true; 
							}
				 		}
				 	}
				}

				/* 3.1.2 BUSCAR ALUMNOS MEDICO - Traer todos los alumnos */
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcntmed)>0?str_replace('cnt.cnttxtmed','stutxt',implode('[~fltrow~]',$lv_fltarrcntmed)):''),
																			   'vewfldord' => 'p.stucod');
				$lo_stumed_rs = $lo_stumdl->getList($lv_prmflt, array(), null, false);
				$lv_arrstumed=array();
				foreach ($lo_stumed_rs as $lv_rowstumed) {
					$lv_arrstumed[$lv_rowstumed['stucod']]=$lv_rowstumed['stutxt'];
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]ct.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'CNTMED'.chr(9).chr(9).
																				 '[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).'EDU_STU'.chr(9).chr(9).
																			   '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
																			   'vewfldord' => 'c.cntsrccod');
				$lo_cntmed_rs = $lo_cntmdl->getList($lv_prmflt, null, null, false);

				/*2- ALUMNO*/
				$lv_fltstu = false;
				$lv_cntfltmedcov_ee=false;
				$lv_cntfltmedcov_ne=false;
				$lv_fltarrstu = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrstu)-1; $i>0; $i--){
					if(stripos(';c2.custxt;stumedcovtxt;',';'.explode(chr(9),$lv_fltarrstu[$i])[0].';')===false){
						unset($lv_fltarrstu[$i]);
					}else{
						$lv_flt=explode(chr(9),$lv_fltarrstu[$i]);
						$data_sqlstm[]=$lv_flt ;

				 		if($lv_flt[0]=='c2.custxt'){
				 		 $lv_fltstu = true; 
				 		}

				 		if($lv_flt[0]=='stumedcovtxt'){
				 			if($lv_flt[1]=='EE'){
								$lv_cntfltmedcov_ee=true;
								$lv_fltstu=false;
								unset($lv_fltarrstu[$i]);
							}else if($lv_flt[1]=='NE'){
								$lv_cntfltmedcov_ne=true;
								$lv_fltstu=false;
								unset($lv_fltarrstu[$i]);
							}else{
								$lv_fltstu = true; 
							}
				 		}
				 	}
				}

				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrstu)>0?implode('[~fltrow~]',$lv_fltarrstu):''),
																			   'vewfldord' => 'p.stutxt');
				$lo_stu_rs = $lo_stumdl->getList($lv_prmflt, array(), null, false);
				$lv_arrstu=array();
				foreach ($lo_stu_rs as $row_stu) {
					$lv_arrstu[$row_stu['stucod']]=array('stutxt'=>$row_stu['stutxt'],
															'sysdocclscod'=>$row_stu['sysdocclscod'],
															'sysdocclstxt'=>$row_stu['sysdocclstxt'],
															'stuctedte'=>$row_stu['ctedte']->format('d/m/Y'),
															'stumedcovtxt'=>$row_stu['stumedcovtxt'],
															'adrtwn'=>$row_stu['adrtwn'],
															'lndregtxt'=>$row_stu['lndregtxt'],
															'custxt'=>$row_stu['custxt']
														);
				}

				$lo_ret = array();
				foreach($lo_evl_rs as $lv_row_evl){
					$lo_enc = array();
					$lo_enc['subcod']=$lv_row_evl['edusubcod'];
					$lo_enc['subtxt']=$lv_row_evl['edusubtxt'];
					$lo_enc['stucod']=$lv_row_evl['stucod'];
					$lo_enc['stutxt']=$lv_row_evl['stutxt'];
					$lo_enc['tchtxt']=$lv_row_evl['tchtxt'];
					$lo_enc['evldte']=$lv_row_evl['eduplndtecnv'];
					$lo_enc['docstscnv']=$lv_row_evl['docstscnv'];
					$lo_enc['feeddte']='';
					$lo_enc['feedq1']='';
					$lo_enc['feedq2']='';
					$lo_enc['feedq3']='';
					$lo_enc['feedq4']='';
					$lo_enc['evatxtcmt']='';
					$lo_enc['evacmt']='';
					$lo_enc['motivo']='';
					$lo_enc['evatxtcmt2']='';
					$lo_enc['evacmt']='';
					$lo_enc['status']='';
					$lo_enc['estado']='';
					$lo_enc['cntapm']='';
					$lo_enc['cntmed']='';
					$lo_enc['stumedcovtxt']='';
					$lv_foundcus = false;
					if(isset($lv_row_evl['stucod'])){
						$lo_enc['stumedcovtxt']=$lv_arrstu[$lv_row_evl['stucod']]['stumedcovtxt'];
						$lv_foundcus = true;
					}
					
					/*EVALUACIONES*/
					$lv_founddata = false;
					if($lv_row_evl['evlcod'] !='' && isset($lv_row_evl['evlcod'])){						
						foreach($lo_evl_data_rs as $lv_row_data){
							if ($lv_row_evl['evlcod']==$lv_row_data['evlcod']) {
								$lo_enc['evlatr']=$lv_row_data['eduevlatr001'].$lv_row_data['eduevlatr002'].$lv_row_data['eduevlatr003'].$lv_row_data['eduevlatr004'].$lv_row_data['eduevlatr005']
																	.$lv_row_data['eduevlatr006'].$lv_row_data['eduevlatr007'].$lv_row_data['eduevlatr008'].$lv_row_data['eduevlatr009'];		
								$lo_enc['feeddte']=isset($lv_conque[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'aaa' )])?$lv_conque[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'aaa' )]:'';
								$lo_enc['feeddte']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feeddte' );
								$lo_enc['feedq1']=isset($lv_fldfeedq1[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq1' )])?$lv_fldfeedq1[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq1' )]:'';
								$lo_enc['feedq2']=isset($lv_fldfeedq2[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq2' )])?$lv_fldfeedq2[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq2' )]:'';
								$lo_enc['feedq3']=isset($lv_fldfeedq3[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq3' )])?$lv_fldfeedq3[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq3' )]:'';
								$lo_enc['feedq4']=isset($lv_fldfeedq4[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq4' )])?$lv_fldfeedq4[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'feedq4' )]:'';
								$lo_enc['evatxtcmt']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'evatxtcmt' );
								$lo_enc['evacmt']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'evacmt' );
								$lo_enc['motivo']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'motivo' );
								$lo_enc['evatxtcmt2']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'evatxtcmt2' );
								$lo_enc['evacmt']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'evacmt' );
								$lo_enc['status']=isset($lv_fldstatus[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'status' )])?$lv_fldstatus[$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'status' )]:'';
								$lo_enc['estado']=$this->co_reg->document->getTagValue( $lo_enc['evlatr'],'estado' );
								$lv_founddata=true;
							}
						}
					}
					
					/* C O N T A C T O - A P M */
					$lv_foundapm = false;
					foreach($lo_cntapm_rs as $lv_row_cntapm){
						if($lv_row_cntapm['cntsrccod']==$lv_row_evl['stucod']){
							$lo_enc['cntapm']=isset($lv_arrstuapm[$lv_row_cntapm['cntdstcod']])?$lv_arrstuapm[$lv_row_cntapm['cntdstcod']]:'';
							if($lv_cntfltapm ==true && $lo_enc['cntapm']!=''){
								$lv_foundapm = true;
							}
						}
					}

					/* C O N T A C T O - M E D I C O */
					$lv_foundmed = false;
					$lo_enc['cntmed']='';
					foreach($lo_cntmed_rs as $lv_row_stu){
						if($lv_row_stu['cntsrccod']==$lv_row_evl['stucod']){  
							$lo_enc['cntmed']=isset($lv_arrstumed[$lv_row_stu['cntdstcod']])?$lv_arrstumed[$lv_row_stu['cntdstcod']]:'';
							if($lv_cntfltmed ==true && $lo_enc['cntmed']!=''){
								$lv_foundmed = true;
							}
						}
					}
						
					if($lv_cntfltdata==true && $lv_founddata==false) { continue; }
					if($lv_cntfltmed==true && $lv_foundmed==false) { continue; }
					if($lv_cntfltapm==true && $lv_foundapm==false) { continue; }
					if($lv_fltstu==true && $lv_foundcus==false) {  continue; }
					/* -------Filtros vacios y no vacios--------------- */
					if($lv_fltfeddte_ee==true && $lo_enc['feeddte']!=''){ continue; }
					if($lv_fltfeddte_ne==true && $lo_enc['feeddte']==''){ continue; }
					if($lv_cntfltapm_ee==true && $lo_enc['cntapm']!=''){ continue; }
					if($lv_cntfltapm_ne==true && $lo_enc['cntapm']==''){ continue; }
					if($lv_cntfltmed_ee==true && $lo_enc['cntmed']!=''){ continue; }
					if($lv_cntfltmed_ne==true && $lo_enc['cntmed']==''){ continue; }
					if($lv_cntfltmedcov_ee==true && $lo_enc['stumedcovtxt']!=''){ continue; }
					if($lv_cntfltmedcov_ne==true && $lo_enc['stumedcovtxt']==''){ continue; }
					/*----------------------------------------------------*/

					$lo_ret[]=$lo_enc;
				}

				return $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lo_ret),'data_sqlstm'=> $data_sqlstm) );
	    	break;
      /* 
      	R E P O R T E S   D E   E V O L U C I O N E S   B U  L K 
      */
			case '#evlrptblk':
        
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        
        //GRUSSO-> CONSULTA EVOLUCIONES
         
        
				//Filtros 		
				//$lv_evlcncmtv= array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS');
        //$lv_evlcncmtv= array(''=>'0','SV'=>'Falta de Viales','EN'=>'Enfermo','ND'=>'No estaba','OT'=>'Otros');
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }
        $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
        $lv_dat = simplexml_load_string($lv_atrusr);
        $lv_evlcncmtv = [];
				foreach($lv_dat as $lv_key=>$lv_val){
          $lv_key= str_replace("CUS_", "", $lv_key); 
         	$lv_cncmtvrow = explode(";", $lv_val);
          $lv_evlcncmtv[$lv_key]=[];
          foreach($lv_cncmtvrow as $lv_rowmtv){
            $lv_a = explode(",", $lv_rowmtv);
            $lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
          }
				}
        /*
        */
        $lv_evlmatequi=array(  'ADVATE'=>'Advate (Factor VIII Recombinante)'
                              ,'ELAPRASE'=>'Elaprase (idursulfasa)'
                              ,'FEIBA'=>'Feiba (factores II, IX y X, principalmente no activados, factor VII activado)'
                              ,'FYRAZYR'=>'Firazyr (Icatibant)'
                              ,'NATPARA'=>'Natpara (hormona paratiroidea)'
                              ,'REPLAGAL'=>'Replagal (agalsidasa alfa)'
                              ,'REVESTIVE'=>'Revestive (Tedeglutida)'
                              ,'V-PRIV'=>'VPRIV (velaglucerasa)'
                              ,'ADYNOVATE'=>'Adynovate (Factor VIII Recombinante modificado con pliego)'
                             	,'VIMIZIM'=>'Vimizin'
                             	,'NAGLAZYME'=>'Naglazyme'
															,'SOLIRIS'=>'Soliris'
															,'HYQVIA'=>'HyQvia (Inmunoglobulina IG 10%)'
															,'ENTYVIO'=>'Entyvio Intravenoso (Vedolizumab)'
                             	,'ENTYVIO SC'=>'Entyvio Subcutaneo (Vedolizumab)'
                            	,'X'=>'X');
        
        $lv_disclsmatcod=array('ACO'  =>'REPLAGAL',
                               'AEH'  =>'FYRAZYR',
                               'ASUR' =>'REPLAGAL',
                               'CA'   =>'REPLAGAL',
                               'CAM'  =>'REPLAGAL',
                               'EM'   =>'ADVATE',
                               'HEM'   =>'ADVATE',
                               'FAB'  =>'REPLAGAL',
                               'GAU'  =>'V-PRIV',
                               'HIP'  =>'NATPARA',
                               'HIPO' =>'NATPARA',
                               'HTC'  =>'ADVATE',
                               'LIN'  =>'REPLAGAL',
                               'MM'   =>'REPLAGAL',
                               'MO'   =>'REPLAGAL',
                               'MPS'  =>'ELAPRASE',
                               'MPSIV'=>'VIMIZIM',
                               'MPSVI'=>'NAGLAZYME',
                               'PKU'  =>'REPLAGAL',
                               'SIC'  =>'REVESTIVE',
                               'TIO'  =>'REPLAGAL',
															 'CU'  =>'ENTYVIO',
															 'EDC'  =>'ENTYVIO',
															 'INM'  =>'HYQVIA',
															 'SIC'  =>'REVESTIVE',
                               'HPN'  =>'SOLIRIS');					
        $lv_dismatequi=array();
        foreach( $lv_disclsmatcod as $lv_disclscodext=>$lv_rowdiscls){
          $lv_dismatequi[$lv_disclscodext]=$lv_evlmatequi[$lv_rowdiscls];
        }
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
        $lv_lmtmem= ini_get('memory_limit'); 
        ini_set('memory_limit', '2048M');
        //GRUSSO-> OBTENGO LOS PARAMETROS DE EMPRESA
        $lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'rptblk'));
				$lo_spccodlst=explode(',',$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'spccodlst'));
        $lo_evlusrtxtbre=$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'evlusrtxtbre');
        /*
        //CONSULTA ESPECIALIDAD A EXCLUIR
        $lo_spcmdl = $this->co_reg->load->model('hltspc');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'TDM'.chr(9).chr(9)
												);
        $lo_rs_evl = $lo_spcmdl->getList( $lv_prmflt);
        //var_dump($lo_rs_evl);
        $lv_spclst = array();
        foreach($lo_rs_evl as $lv_rowspc){
          $lv_spclst[$lv_rowspc['spccodext']]=$lv_rowspc['spccod'];
        } 
        */       
        
	    	//RUSSO-> CONSULTA EVOLUCIONES
        
        $lo_mdlevl = $this->co_reg->load->model('hltpatevl');
        
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evldtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evldtecnv','e.evldte',$lv_fltarrevl[$i]);
					}
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]c.custxt'.chr(9).'='.chr(9).chr(9). 'TAKEDA'.chr(9).chr(9).
                           							 '[~fltrow~]e.spccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_spccodlst) .chr(9).chr(9).
                           							 //'[~fltrow~]e.spccod'.chr(9).'<>'.chr(9).chr(9). $lv_spclst['TDM'].chr(9).chr(9).
                           								(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													'vewfldord' => 'e.evldte desc'
												);
				if($lv_maxrec==false){
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        $lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false);

        /*
          GRUSSO-> FILTROS PARA CONSULTAR PACIENTES Y MATERIALES
         */
        $lo_disclsmdl = $this->co_reg->load->model('hltdiscls');
        $lv_patprmflt='';
        $lv_evlprmflt='';
        
        foreach( $lo_rsevl as $lv_row ) {
					$lv_patprmflt .= ($lv_patprmflt==''?'':chr(10)).$lv_row['patcod'];
          $lv_evlprmflt .= ($lv_evlprmflt==''?'':chr(10)).$lv_row['evlcod']; 
        }
        /*
        GRUSSO-> CONSULTA  CLASIF. ENFERMEDADES
        */
        $lo_rspenf=$lo_disclsmdl->getList();
        
        $lo_enflst=array();
        foreach( $lo_rspenf as $lv_rowEnf){
        	$lo_enflst[$lv_rowEnf['hltdisclscod']]=$lv_rowEnf['hltdisclscodext'];
        }
        
        /*
        	GRUSSO-> CONSULTA PACIENTES PARA AGREGAR (COD Y DES CLASIFICACION DE ENFERMEDAD,CODIGO ESTERNO DE PACIENTE E DETERMINAR EL MATERIAL A INFUNDIR DEPENDIENDO DE EL ARRAY[$lv_disclsmatcod])
        */
        $lo_mdlpat = $this->co_reg->load->model('hltpat');
        $lv_prmPatflt = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patprmflt.chr(9).chr(9),
													'vewfldord' => 'p.patcod desc'
												);
        $lo_rspat= $lo_mdlpat->getList($lv_prmPatflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdlevl->getsysdata('sqlstm');
        $lo_patLst=array();
        foreach($lo_rspat as $lv_rowPat){
          $lo_patLst[$lv_rowPat['patcod']]['patcodext']=$lv_rowPat['patcodext'];
          $lo_patLst[$lv_rowPat['patcod']]['custxt']=$lv_rowPat['custxt'];
          $lo_patLst[$lv_rowPat['patcod']]['hltdisclscod']=$lv_rowPat['hltdisclscod'];
          $lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']=isset($lo_enflst[$lv_rowPat['hltdisclscod']])?$lo_enflst[$lv_rowPat['hltdisclscod']]:'';
          $lo_patLst[$lv_rowPat['patcod']]['mattxt']='';
          if(isset($lv_dismatequi[$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']])){
            $lo_patLst[$lv_rowPat['patcod']]['mattxt']=$lv_dismatequi[$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']]; 
          }
          
         // $lo_patLst[$lv_rowPat['patcod']]['mattxt']=$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']==''?'':$lv_dismatequi[$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']];
        }  
        
        /*
        	GRUSSO-> CONSULTO MATERIALES PARA CALCULAR LA CANTIDAD SUMINISTRADA EN LA INFUSION
        */
        $lo_mdlevlmat = $this->co_reg->load->model('hltpatevlmat');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evldtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evldtecnv','e.evldte',$lv_fltarrevl[$i]);
						//$lv_flt=explode(chr(9),$lv_fltarrevl[$i]);
					}
				}
        //$lv_prmPatflt = array('vewfldflt' =>'[~fltrow~]e.evlcod'.chr(9).'IN'.chr(9).chr(9).$lv_evlprmflt.chr(9).chr(9),
         $lv_prmPatflt =array('vewfldflt'=>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                              'vewfldord' => 'e.evlcod desc'
                            	);
        $lo_rsevlmat= $lo_mdlevlmat->getList($lv_prmPatflt);
        $lv_data_sqlstm[] = $lo_mdlevlmat->getsysdata('sqlstm'); 
        $lo_evlmatLst=array();
        foreach($lo_rsevlmat as $lv_rowEvlMat){
          if(!isset( $lo_evlmatLst[$lv_rowEvlMat['evlcod']])){
            $lo_evlmatLst[$lv_rowEvlMat['evlcod']]=array('mattot'=>'0',
            																						'mattxt'=>'');
          }
          $lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattot']+=$lv_rowEvlMat['matqty'];
          
          if( $lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattxt']==''){ 
            if(isset($lv_evlmatequi[$lv_rowEvlMat['mattxt']])){
          		$lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattxt']=$lv_evlmatequi[$lv_rowEvlMat['mattxt']];
            }
          }
        }   
        
        /*
          GRUSSO-> PREPARO LA SALIDA
        */
        $lv_ret=array();
        foreach($lo_rsevl as $lv_row){
          $lv_buf=array('patcodext'=>$lo_patLst[$lv_row['patcod']],
                        'evldtecnv'=>$lv_row['evldte']->format('d/m/Y'),
                        'mattxt'=>'NE',
                        'evlusrtxtbre'=>$lo_evlusrtxtbre,
                        'evlmattot'=>'0',
                        'evlcrs'=>'0',
                        'evlcmt'=>$lv_row['docsts']=='A'?$lv_row['evlevl']:$lv_row['evlsub'],
                        'custxt'=>'0',
                        'evlcod'=>$lv_row['evlcod'],
                        'patcod'=>$lv_row['patcod'],
                        'evlinfprc'=>$lv_row['docsts']=='A'?'SI':'NO',
                        'evlcncmtv'=>'0',
                        'evlcncmtvcod'=>'',
                        //'evlcncmtv'=>$lv_evlcncmtv[$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv')],
                        'matdos'=>$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'matdos'),
                       );
          /*
          */
          
          $lv_cuscod = $lv_row['cuscod'];      
          if($lv_buf['evlinfprc']=='NO'){
          	$lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv');
            $lv_buf['evlcncmtvcod']=$lv_evlcncmtvcod ;
            if($lv_evlcncmtvcod!=''){
              $lv_rtn['evlcncmtvcod']=$lv_evlcncmtvcod;
              $lv_buf['evlcncmtv']=isset($lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod]:(isset($lv_evlcncmtv['ALL'][$lv_evlcncmtvcod])?$lv_evlcncmtv['ALL'][$lv_evlcncmtvcod]:'ERROR: CODIGO '.$lv_evlcncmtvcod);
            }
          }
          
          //$lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv');
          //$lv_buf['evlcncmtv']=$lv_row['docsts']=='A'?'0':(isset($lv_evlcncmtv[$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_evlcncmtvcod]:'');
          if(isset($lo_patLst[$lv_row['patcod']])){
            $lv_buf['patcodext']=$lo_patLst[$lv_row['patcod']]['patcodext'];
            $lv_buf['custxt']=$lo_patLst[$lv_row['patcod']]['custxt'];
          }
          
          if(isset($lo_evlmatLst[$lv_row['evlcod']]['mattxt'])&&$lo_evlmatLst[$lv_row['evlcod']]['mattxt']!=''){
            $lv_buf['mattxt']=$lo_evlmatLst[$lv_row['evlcod']]['mattxt'];
          }else{
            $lv_buf['mattxt']= $lo_patLst[$lv_row['patcod']]['mattxt'];
          }
          
          if(isset($lo_evlmatLst[$lv_row['evlcod']]['mattot'])){
            $lv_buf['evlmattot']=$lo_evlmatLst[$lv_row['evlcod']]['mattot'];
          }
           $lv_ret[]= array_merge($lv_row, $lv_buf);
          
        }
        ini_set('memory_limit', $lv_lmtmem);
        $lv_ret[0]['sqlstm']= $lv_data_sqlstm;
        return $lv_ret;
      	break;
      /* 
      	R E P O R T E S   D E   E V O L U C I O N E S   B U  L K 
      */
			case '#evlrptblkcc':
        
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        
        //GRUSSO-> CONSULTA EVOLUCIONES
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }
        $lv_mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lv_mdlatrval001).
</document>
XML;
        $lv_dat = simplexml_load_string($lv_atrusr);
        $lv_evlcncmtv = [];
        $lv_evlcncmtv2lst = [];
				foreach($lv_dat as $lv_key=>$lv_val){
          if($lv_key=='EVLCNCMTVLST2'){
            $lv_cncmtvrow = explode(";", $lv_val);
            //$lv_evlcncmtv2lst[$lv_key]=[];
            foreach($lv_cncmtvrow as $lv_rowmtv){
              $lv_a = explode(",", $lv_rowmtv);
              $lv_key2=$lv_a[0];
              $lv_value2 = $lv_a[1];//$lv_value2 = $lv_a[1]??('ERR-'.$lv_a[0]);
              $lv_evlcncmtv2lst[$lv_key2]=$lv_value2;
            }
            
            
          }
          if($lv_key!='ALL'  && !str_starts_with($lv_key, 'CUS')){
            continue;
          }
          //if($lv_key=='TXTTYPCOD'){
          //  continue;
          //}
          $lv_key= str_replace("CUS_", "", $lv_key); 
         	$lv_cncmtvrow = explode(";", $lv_val);
          $lv_evlcncmtv[$lv_key]=[];
          foreach($lv_cncmtvrow as $lv_rowmtv){
            $lv_a = explode(",", $lv_rowmtv);
        		$lv_key2=$lv_a[0];
						$lv_value2 = $lv_a[1];//$lv_value2 = $lv_a[1]??('ERR-'.$lv_a[0]);
            $lv_evlcncmtv[$lv_key][$lv_key2]=$lv_value2;
          }
				}
        //return $lv_evlcncmtv;
        
        $lv_evlmatequi=array(  'ADVATE'=>'Advate (Factor VIII Recombinante)'
                              ,'ELAPRASE'=>'Elaprase (idursulfasa)'
                              ,'FEIBA'=>'Feiba (factores II, IX y X, principalmente no activados, factor VII activado)'
                              ,'FYRAZYR'=>'Firazyr (Icatibant)'
                              ,'NATPARA'=>'Natpara (hormona paratiroidea)'
                              ,'REPLAGAL'=>'Replagal (agalsidasa alfa)'
                              ,'REVESTIVE'=>'Revestive (Tedeglutida)'
                              ,'V-PRIV'=>'VPRIV (velaglucerasa)'
                              ,'ADYNOVATE'=>'Adynovate (Factor VIII Recombinante modificado con pliego)'
                             	,'VIMIZIM'=>'Vimizin'
                             	,'NAGLAZYME'=>'Naglazyme'
															,'SOLIRIS'=>'Soliris'
															,'HYQVIA'=>'HyQvia (Inmunoglobulina IG 10%)'
															,'ENTYVIO'=>'Entyvio Intravenoso (Vedolizumab)'
                             	,'ENTYVIO SC'=>'Entyvio Subcutaneo (Vedolizumab)'
                            	,'X'=>'X');
        
        $lv_disclsmatcod=array('ACO'  =>'REPLAGAL',
                               'AEH'  =>'FYRAZYR',
                               'ASUR' =>'REPLAGAL',
                               'CA'   =>'REPLAGAL',
                               'CAM'  =>'REPLAGAL',
                               'EM'   =>'ADVATE',
                               'HEM'   =>'ADVATE',
                               'FAB'  =>'REPLAGAL',
                               'GAU'  =>'V-PRIV',
                               'HIP'  =>'NATPARA',
                               'HIPO' =>'NATPARA',
                               'HTC'  =>'ADVATE',
                               'LIN'  =>'REPLAGAL',
                               'MM'   =>'REPLAGAL',
                               'MO'   =>'REPLAGAL',
                               'MPS'  =>'ELAPRASE',
                               'MPSIV'=>'VIMIZIM',
                               'MPSVI'=>'NAGLAZYME',
                               'PKU'  =>'REPLAGAL',
                               'SIC'  =>'REVESTIVE',
                               'TIO'  =>'REPLAGAL',
															 'CU'  =>'ENTYVIO',
															 'EDC'  =>'ENTYVIO',
															 'INM'  =>'HYQVIA',
															 'SIC'  =>'REVESTIVE',
                               'HPN'  =>'SOLIRIS');					
        $lv_dismatequi=array();
        foreach( $lv_disclsmatcod as $lv_disclscodext=>$lv_rowdiscls){
          $lv_dismatequi[$lv_disclscodext]=$lv_evlmatequi[$lv_rowdiscls];
        }
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
        $lv_lmtmem= ini_get('memory_limit'); 
        ini_set('memory_limit', '2048M');
        // OBTENGO LOS PARAMETROS DE EMPRESA //
        
        //$lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				//$lo_txtmdl->load(array('mdlcod'=>'rptblkCC'));
				//$lo_spccodlst=explode(',',$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'spccodlst'));
        //$lo_cuscodlst=explode(',',$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'cuscodlst'));
        //$lo_evlusrtxtbre=$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'evlusrtxtbre');     
        $lo_spccodlst=explode(',',($lp_prm['spccodlst']??''));
        $lo_cuscodlst=explode(',',($lp_prm['cuscodlst']??''));
        
	    	//RUSSO-> CONSULTA EVOLUCIONES
        
        $lo_mdlevl = $this->co_reg->load->model('hltpatevl');
        
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evldtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evldtecnv','e.evldte',$lv_fltarrevl[$i]);
					}
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]c.cuscod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_cuscodlst) .chr(9).chr(9).
                           							 '[~fltrow~]e.spccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_spccodlst) .chr(9).chr(9).
                           							 //'[~fltrow~]e.spccod'.chr(9).'<>'.chr(9).chr(9). $lv_spclst['TDM'].chr(9).chr(9).
                           								(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													'vewfldord' => 'e.evldte desc'
												);
				if($lv_maxrec==false){
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        $lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false);
        // GRUSSO-> FILTROS PARA CONSULTAR PACIENTES Y MATERIALES
        $lo_disclsmdl = $this->co_reg->load->model('hltdiscls');
        $lv_patprmflt='';
        $lv_evlprmflt='';
        
        foreach( $lo_rsevl as $lv_row ) {
					$lv_patprmflt .= ($lv_patprmflt==''?'':chr(10)).$lv_row['patcod'];
          $lv_evlprmflt .= ($lv_evlprmflt==''?'':chr(10)).$lv_row['evlcod']; 
        }
        
        //GRUSSO-> CONSULTA  CLASIF. ENFERMEDADES
        $lo_rspenf=$lo_disclsmdl->getList();
        
        $lo_enflst=array();
        foreach( $lo_rspenf as $lv_rowEnf){
        	$lo_enflst[$lv_rowEnf['hltdisclscod']]=$lv_rowEnf['hltdisclscodext'];
        }
        //GRUSSO-> CONSULTA PACIENTES PARA AGREGAR (COD Y DES CLASIFICACION DE ENFERMEDAD,CODIGO ESTERNO DE PACIENTE E DETERMINAR EL MATERIAL A INFUNDIR DEPENDIENDO DE EL ARRAY[$lv_disclsmatcod])
        $lo_mdlpat = $this->co_reg->load->model('hltpat');
        $lv_prmPatflt = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).$lv_patprmflt.chr(9).chr(9),
													'vewfldord' => 'p.patcod desc'
												);
        $lo_rspat= $lo_mdlpat->getList($lv_prmPatflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdlevl->getsysdata('sqlstm');
        $lo_patLst=array();
        foreach($lo_rspat as $lv_rowPat){
          $lo_patLst[$lv_rowPat['patcod']]['patcodext']=$lv_rowPat['patcodext'];
          $lo_patLst[$lv_rowPat['patcod']]['custxt']=$lv_rowPat['custxt'];
          $lo_patLst[$lv_rowPat['patcod']]['hltdisclscod']=$lv_rowPat['hltdisclscod'];
          $lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']=isset($lo_enflst[$lv_rowPat['hltdisclscod']])?$lo_enflst[$lv_rowPat['hltdisclscod']]:'';
          $lo_patLst[$lv_rowPat['patcod']]['mattxt']='';
          if(isset($lv_dismatequi[$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']])){
            $lo_patLst[$lv_rowPat['patcod']]['mattxt']=$lv_dismatequi[$lo_patLst[$lv_rowPat['patcod']]['hltdisclscodext']]; 
          }
        }  
        //GRUSSO-> CONSULTO MATERIALES PARA CALCULAR LA CANTIDAD SUMINISTRADA EN LA INFUSION
        $lo_mdlevlmat = $this->co_reg->load->model('hltpatevlmat');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evldtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evldtecnv','e.evldte',$lv_fltarrevl[$i]);
					}
				}
         $lv_prmPatflt =array('vewfldflt'=>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                              'vewfldord' => 'e.evlcod desc'
                            	);
        $lo_rsevlmat= $lo_mdlevlmat->getList($lv_prmPatflt);
        $lv_data_sqlstm[] = $lo_mdlevlmat->getsysdata('sqlstm'); 
        $lo_evlmatLst=array();
        foreach($lo_rsevlmat as $lv_rowEvlMat){
          if(!isset( $lo_evlmatLst[$lv_rowEvlMat['evlcod']])){
            $lo_evlmatLst[$lv_rowEvlMat['evlcod']]=array('mattot'=>'0',
            																						'mattxt'=>'');
          }
          $lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattot']+=$lv_rowEvlMat['matqty'];
          
          if( $lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattxt']==''){ 
            if(isset($lv_evlmatequi[$lv_rowEvlMat['mattxt']])){
          		$lo_evlmatLst[$lv_rowEvlMat['evlcod']]['mattxt']=$lv_evlmatequi[$lv_rowEvlMat['mattxt']];
            }
          }
        }   
        
        //GRUSSO-> PREPARO LA SALIDA
        $lv_ret=array();
        foreach($lo_rsevl as $lv_row){
          $lv_buf=array('patcodext'=>$lo_patLst[$lv_row['patcod']],
                        'evldtecnv'=>$lv_row['evldte']->format('d/m/Y'),
                        'mattxt'=>'NE',
                        //'evlusrtxtbre'=>$lo_evlusrtxtbre,
                        'evlmattot'=>'0',
                        'evlcrs'=>'NO',
                        'evlcmt'=>substr(($lv_row['docsts']=='A'?$lv_row['evlevl']:$lv_row['evlsub']),0, 255),//'evlcmt'=>$lv_row['docsts']=='A'?$lv_row['evlevl']:$lv_row['evlsub'],
                        'custxt'=>'0',
                        'spctxt'=>$lv_row['spctxt'],
                        'spccod'=>$lv_row['spccod'],
                        'cuscod'=>$lv_row['cuscod'],
                        'evlcod'=>$lv_row['evlcod'],
                        'patcod'=>$lv_row['patcod'],
                        'evlinfprc'=>$lv_row['docsts']=='A'?'SI':'NO',
                        'evlcncmtv'=>'0',
                        'evlcncmtvcod'=>'',
                        'matdos'=>$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'matdos'),
                        'infprg'=>$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'infprg'),
                        'infexe'=>$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'infexe'),
                        'evlcncmtv2cod'=>$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv2'),
                        'evlcncmtv2'=>'0',//$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv2'),
                        'evlade'=>'0'
                       );
          $lv_buf['evlcrs']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'fvrpt')=='off'?'NO':'SI';
          $lv_cuscod = $lv_row['cuscod'];      
          if($lv_buf['evlinfprc']=='NO'){
            continue;
          	$lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv');            
            $lv_buf['evlcncmtvcod']=$lv_evlcncmtvcod;
            if($lv_evlcncmtvcod!=''){
              $lv_rtn['evlcncmtvcod']=$lv_evlcncmtvcod;
              $lv_buf['evlcncmtv']=isset($lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod]:(isset($lv_evlcncmtv['ALL'][$lv_evlcncmtvcod])?$lv_evlcncmtv['ALL'][$lv_evlcncmtvcod]:'ERROR: CODIGO '.$lv_evlcncmtvcod);
            }
          }
          if($lv_buf['infprg']!=$lv_buf['infexe']){
            $lv_evlcncmtv2= $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lv_row['evlatr001'], 'row'),'evlcncmtv2'); 
            if($lv_evlcncmtv2!=''){
              $lv_buf['evlcncmtv2']=isset($lv_evlcncmtv2lst[$lv_evlcncmtv2])?$lv_evlcncmtv2lst[$lv_evlcncmtv2]:(isset($lv_evlcncmtv2lst[$lv_evlcncmtv2])?$lv_evlcncmtv2lst[$lv_evlcncmtv2]:'ERROR: CODIGO '.$lv_evlcncmtv2);
            }
          }
          if($lv_buf['spccod']=='88'){
            $lv_buf['infprg']='0';
            $lv_buf['infexe']='0';
            $lv_buf['evlcncmtv2']='0';
            $lv_buf['evlcrs']='0';
            
          }
          
          if(isset($lo_patLst[$lv_row['patcod']])){
            $lv_buf['patcodext']=$lo_patLst[$lv_row['patcod']]['patcodext'];
            $lv_buf['custxt']=$lo_patLst[$lv_row['patcod']]['custxt'];
          }
          
          if(isset($lo_evlmatLst[$lv_row['evlcod']]['mattxt'])&&$lo_evlmatLst[$lv_row['evlcod']]['mattxt']!=''){
            $lv_buf['mattxt']=$lo_evlmatLst[$lv_row['evlcod']]['mattxt'];
          }else{
            $lv_buf['mattxt']= $lo_patLst[$lv_row['patcod']]['mattxt'];
          }
          
          if(isset($lo_evlmatLst[$lv_row['evlcod']]['mattot'])){
            $lv_buf['evlmattot']=$lo_evlmatLst[$lv_row['evlcod']]['mattot'];
          }
           $lv_ret[]= array_merge($lv_row, $lv_buf);
          
        }
        ini_set('memory_limit', $lv_lmtmem);
        $lv_ret[0]['sqlstm']= $lv_data_sqlstm;
        $lv_ret[0]['mtvlstprm']= $lv_evlcncmtv2lst;
        return $lv_ret;
      	break;
      
      //R E P O R T E S   D E   L I U I D A C I O N E S   A S A N T E
			case '#lqdrptasa':
				
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_dismatequi=array();
        $lv_evlinfprc= array('0'=>'NO','1'=>'SI',''=>'NO');
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M');
        
	    	/*RUSSO-> CONSULTA LIQUI*/
				$lv_prmflt = array();
				if($lv_maxrec==false){ 
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'l.hltprslqddte desc';
        //$lv_vewfldord =str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_vewfldord);
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltprslqdgrpcod;hltprslqdtxt;hltprslqdcod;hltprslqddtecnv;hltprslqddte;prscod;prstxt;docsts;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqdcod','l.hltprslqdcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqdtxt','l.hltprslqdtxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('docsts','l.docsts',$lv_fltarrevl[$i]);
          }
				}
        
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                                        'vewmaxrec'=>$lo_post['vewmaxrec'],
                                        'vewfldord' => $lv_vewfldord
                                        );
        $lo_rslqd = $lo_mdllqd->getList( $lv_prmflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdllqd->getsysdata('sqlstm');
        
        /* IMPUESTOS */
				/* Filtros*/
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9));
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
				//$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        $lo_taxLst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxLst[$lv_rowtax['taxsrccod']]=$lv_rowtax['taxdocnum'];
        }  
        
        /*
          GRUSSO-> PREPARO LA SALIDA
        */
        $lv_ret=array();
        
        foreach($lo_rslqd as $lv_row){
          $lv_row['hltprslqdtot']=number_format($lv_row['hltprslqdtot'], 2, ',', '');
          $lv_buf['taxcod001']='';
          if(isset($lo_taxLst[$lv_row['prscod']])){
            $lv_buf['taxcod001']=$lo_taxLst[$lv_row['prscod']];
          }
          /*
          $lv_buf['subfacg']=$lv_row['hltprslqddoctot']>=0?$lv_row['hltprslqddoctot']:0;
          $lv_buf['hondebg']=$lv_row['hltprslqddoctot']>=0?$lv_row['hltprslqddoctot']:0;
          $lv_buf['honhabg']=$lv_row['hltprslqddoctot']<0?$lv_row['hltprslqddoctot']:0;
          */
          $lv_ret[]=array_merge($lv_row,$lv_buf);
        }
        $lv_ret[0]['sqlsmt']=$lv_data_sqlstm;
        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret;
      	break;
		 /* 
      R E P O R T E S   D E   L I U I D A C I O N E S   A S A N T E
      */
			case '#tplqdrptasa':
				
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_dismatequi=array();
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M');
        
        
	    	/* RUSSO-> CONSULTA CABECERA DE LIQUIDACION */
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
        
				$lv_prmflt = array();
				if($lv_maxrec==false){ 
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'hltprslqddtecnv desc';
        $lv_vewfldord =str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_vewfldord);
        
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltprslqdcod;hltprslqddtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqdcod','l.hltprslqdcod',$lv_fltarrevl[$i]);
          }
				}        
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													'vewmaxrec'=>$lo_post['vewmaxrec'],
                          'vewfldord' => $lv_vewfldord
												);
        $lo_rslqd = $lo_mdllqd->getList( $lv_prmflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdllqd->getsysdata('sqlstm');
        
        /* IMPUESTOS */
				/* Filtros*/
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9));
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
				//$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        $lo_taxLst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxLst[$lv_rowtax['taxsrccod']]=$lv_rowtax['taxdocnum'];
        }  
        
        /*
          GRUSSO-> PREPARO LA SALIDA
        */
        $lv_ret=array();
        $lo_lqdlst=[];
        foreach($lo_rslqd as $lv_row){
          $lv_row['hltprslqdtot']=number_format($lv_row['hltprslqdtot'], 2, ',', '');
          $lv_buf['taxcod001']='';
          if(isset($lo_taxLst[$lv_row['prscod']])){
            $lv_buf['taxcod001']=$lo_taxLst[$lv_row['prscod']];
          }
          $lv_ret[]=array_merge($lv_row,$lv_buf);
           $lo_lqdlst[] = $lv_row['hltprslqdcod'];
        }
        $lv_ret[0]['sqlsmt']=$lv_data_sqlstm;
        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret;
      	break;
        
     //    C O T I Z A C I O N E S
     // impresion del formulario de cotizaciones
     case '#slsqtapnt':
       $lo_post = $this->co_reg->request->post;
       $lv_slsordcod = (isset($lo_post['slsordcod'])?$lo_post['slsordcod']:$lp_prm['slsordcod']);

       // cargo datos de empresa
       $lo_busmdl = $this->co_reg->load->model('admbus');
       $lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod),false );

       // cargo datos de la cotizacion
       $lo_ordmdl = $this->co_reg->load->model('slsord');
       $lo_ordmdl->load( array('slsordcod'=>$lv_slsordcod), false );

       // cargo textos de cotizacion
       $lo_txtmdl = $this->co_reg->load->model('grldattxt');
       $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'SLS_QTA' .chr(9).chr(9).
       								 							 '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_ordmdl->slsordcod .chr(9).chr(9) );
       $lo_txtrs = $lo_txtmdl->getList( $lv_prm );
        
       // cargo clase de documento para recuperar la fila de la condición de precios que se debe mostrar como subtotal de cada posición
       $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
       if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_ordmdl->sysdocclscod) ) ) {
         $lv_prcschcndrow = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr, 'prcschcndrow');
       } else {
         echo 'No se pudieron cargar los datos de la clase de documento.';
       }

       $lv_buffer = $this->co_reg->document->getView('zcutp1_tinslsordpnt', array('bus'=>$lo_busmdl,'ord'=>$lo_ordmdl,'txt'=>$lo_txtrs, 'prcschcndrow'=>$lv_prcschcndrow, 'actcod'=>$this->data['actcod']) );
       $this->co_reg->response->addHeader('Content-type:application/pdf');
       return $lv_buffer;
       break;
      
      //    R E P O R T E    -    L I Q U I D A C I O N E S
      case '#tinrptlqd':
        $lv_prm = array('lang' 	=> $this->co_reg->language,
                          'input' => $this->co_reg->input,
                          'sec' 	=> $this->co_reg->sec,
                          'load'  => $this->co_reg->load,
                          'data' => array(),
                          'actcod'=> $this->data['actcod'],
                          'model' => self::MODEL
                          );
          $lv_buffer = 	$this->co_reg->load->view('zcutp1_tin_lqdlst', $lv_prm);
          return $lv_buffer;
        break;
        
      //    R E P O R T E    -    L I Q U I D A C I O N E S   -    D A T O S 
	    case '#tinrptlqddat':
	    	$lo_post = $this->co_reg->request->post;
	    	$lo_prslqd = $this->co_reg->load->model('hltprslqd');
        
        $lv_vewfldflt = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
												'vewmaxrec' => $lv_vewmaxrec);
        
        $lo_rsevl = $lo_prslqd->getList( $lv_prm, null, null, false );
        
	    	$lo_ret=$lo_rsevl;
        
        $lv_retjsn = json_encode( array('datlst'=>$this->co_reg->document->array_utf8_converter($lo_ret) ));
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_sub_rs);
				}
	    	break;
        
        
        
        
      	//  R E P O R T E S   D E   L I Q U I D A C I O N E S   D E T A L L A D O
    	case '#lqdrpt':
        $lo_post = $this->co_reg->request->post;
	    	$lo_hltlqd = $this->co_reg->load->model('hltlqddoc');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'h.hltlqdcod desc';
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltlqdcod;patcodext;evldte;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltlqdcod','h.hltlqdcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcodext','a.patcodext',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
          }
				}
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]h.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
												(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                        'vewmaxrec'=>$lo_post['vewmaxrec'],
                        'vewfldord' => $lv_vewfldord
                       );

                        $lo_rsevl = $lo_hltlqd->getListData($lv_prm, null, null, false);
        foreach ($lo_rsevl as &$lv_row) {
          if ($lv_row['evldte'] != null) {
            $lv_row['evldte']=$lv_row['evldte']->format('d/m/Y');
          } 
          $lv_row['adrzon'] = ($lv_row['adrzoncod']!=0?$lv_row['adrzontxt']:$lv_row['adrzon']);
        }
        unset($lv_row);
        return $lo_rsevl;
       
        break;
        
        //  R E P O R T E S   D E   L I Q U I D A C I O N E S   A G R U P A D O
        case '#lqdagr':
        $lo_post = $this->co_reg->request->post;
	    	$lo_hltlqd = $this->co_reg->load->model('hltlqddoc');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'h.hltlqdcod desc';
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltlqdcod;patcodext;lndregtxt;patcod;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltlqdcod','h.hltlqdcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcodext','a.patcodext',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcod','p.patcod',$lv_fltarrevl[$i]);
          }
				}
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]h.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
												(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                        'vewmaxrec'=>$lo_post['vewmaxrec'],
                        'vewfldord' => $lv_vewfldord,
                        'vewfldgrp' => 'p.patcod,h.hltlqdcod, a.patcodext, a.patpro, a.pattxt, sc.custxt, dc.hltdisclstxt, aa.adrcty, lr.lndregtxt, h.hltlqddocprc, h.hltlqddocqty, gp.hhrmedcovtxt, aa.adrzon, aa.adrzoncod, dz.adrzontxt,p.SpcCod',
                        'vewfldgrpcal' => 'sum(h.hltlqddocqty) as grpqty'
                       );

        $lo_rsevl = $lo_hltlqd->getListData($lv_prm, null, null, false);
        foreach ($lo_rsevl as &$lv_row) {
          $lv_row['rowtot'] = strval ($lv_row['grpqty'] * $lv_row['hltlqddocprc']);
          $lv_row['grpqty'] = number_format ($lv_row['grpqty']);
          $lv_row['adrzon'] = ($lv_row['adrzoncod']!=0?$lv_row['adrzontxt']:$lv_row['adrzon']);
        } 
        unset($lv_row);
        return $lo_rsevl;       
        break;
        
        
        //    R E P O R T E    -    TMG 01    -    D A T O S 
        case '#tmgrpt01rpt':
        	$lv_lmtmem= ini_get('memory_limit');
          ini_set('memory_limit', '2048M');
					
          $lo_post = $this->co_reg->request->post;
          $lo_hltpat = $this->co_reg->load->model('hltpat');
          $lo_ret=array();
          $lv_sqlstm=array();
					
					
					// filtros de cabecera. Armo array con los filtros aplicados a la cabecera de gastos
          $lo_buyexpimp = $this->co_reg->load->model('buyexp');
          $lv_cntfltexp = false;
          $lv_fltarrexp = explode('[~fltrow~]',$lo_post['vewfldflt'] );
          for($i=count($lv_fltarrexp)-1; $i>0; $i--){
            if(stripos(';buyexpcod;buyexpdte;buyexptxt;',';'.explode(chr(9),$lv_fltarrexp[$i])[0].';')===false){
              unset($lv_fltarrexp[$i]);
            }else{
              $lv_cntfltexp = true; 
              $lv_fltarrexp[$i] = str_replace('buyexpcod','e.buyexpcod',$lv_fltarrexp[$i]);
              $lv_fltarrexp[$i] = str_replace('buyexpdte','e.buyexpdte',$lv_fltarrexp[$i]);
              $lv_fltarrexp[$i] = str_replace('buyexptxt','e.buyexptxt',$lv_fltarrexp[$i]);
            }
          }
				 
				
					// 1- IMPUTACIONES. obtengo imputaciones no activas
					// PENDIENTE: esto no es performante. debería ser por período obligatorio
          $lv_prmflt = array('vewfldflt' =>'[~fltrow~]ei.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
                                           (count($lv_fltarrexp)>0?implode('[~fltrow~]',$lv_fltarrexp):''),
                                           'vewfldord' => 'e.buyexpcod desc,e.buyexpdte desc');
          $lo_rs_expimp=$lo_buyexpimp->getListImp($lv_prmflt);
	        $lv_sqlstm[]=$lo_buyexpimp->getsysdata('sqlstm');
        
					// 2. PACIENTES. creo array de pacientes que están en imputaciones
          $lo_patcodarr = array();
          foreach ($lo_rs_expimp as $lv_row) {
            if($lv_row['srcobjtyp']=='HLT_PAT' && isset($lv_row['srcobjcod001'])){
            	array_push($lo_patcodarr,$lv_row['srcobjcod001']);
            }
          }
        
      	  // 2.1 FILTROS
          $lv_cntfltpat = $lv_cntfltexp; //false -> por default arrastro el indicador de filtro anterior
          $lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );
          for($i=count($lv_fltarrpat)-1; $i>0; $i--){
            if(stripos(';patcodext;pattxt;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
              unset($lv_fltarrpat[$i]);
            }else{
              $lv_cntfltpat = true; 
              $lv_fltarrpat[$i] = str_replace('patcodext','p.patcodext',$lv_fltarrpat[$i]);
              $lv_fltarrpat[$i] = str_replace('pattxt','p.pattxt',$lv_fltarrpat[$i]);
              $lv_fltarrpat[$i] = str_replace('custxt','c.custxt',$lv_fltarrpat[$i]);
            }
          }
					
          // recupero pacientes que están en las imputaciones
          $lv_prmflt=array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9).
                                      	 '[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_patcodarr) .chr(9).chr(9).
                           							 (count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
                      );
          $lo_rs_hltpat = $lo_hltpat->getList( $lv_prmflt, null, null, false );
          $lv_sqlstm[]=$lo_hltpat->getsysdata('sqlstm');
        
        	// recorro imputaciones y agrego datos de paciente
        	// si se está filtrando por paciente y no se encuentra paciente, se ELIMINA la imputación y se crea un array con posiciones de documento a mostrar
        	$lo_new_rs_expimp = array();
        	$lv_expdoccodarr = array();
        	foreach ($lo_rs_expimp as $lv_row_imp) {
            foreach($lo_rs_hltpat as $lv_row_pat){
              if($lv_row_imp['srcobjtyp'] == 'HLT_PAT' && $lv_row_imp['srcobjcod001'] == $lv_row_pat['patcod'] ){
                $lv_row_imp['patcodext'] = $lv_row_pat['patcodext'];
                $lv_row_imp['custxt'] = $lv_row_pat['custxt'];
                $lv_row_imp['hltdisclstxt'] = $lv_row_pat['hltdisclstxt'];
								break;
              }
            }
            // si hay filtro, verifico que exista el paciente y agrego la posición del documento a un array
            if($lv_cntfltpat){
              if(isset($lv_row_imp['custxt'])){
            		array_push($lv_expdoccodarr,$lv_row_imp['buyexpdoccod']);
              	array_push($lo_new_rs_expimp, $lv_row_imp);
              }
            }else{
              array_push($lo_new_rs_expimp, $lv_row_imp);
            }
          }
        	$lo_rs_expimp = $lo_new_rs_expimp;
        

          // 3- POSICIONES
          $lo_buyexpdoc = $this->co_reg->load->model('buyexp');
          // 3.1 FILTROS
          $lv_fltarrdoc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
          for($i=count($lv_fltarrdoc)-1; $i>0; $i--){
            if(stripos('buyexpcod;impobjtxt;buyexpdocdte;buyexptyptxt;buyexpdoctot;',';'.explode(chr(9),$lv_fltarrdoc[$i])[0].';')===false){
              unset($lv_fltarrdoc[$i]);
            }else{
              $lv_fltarrdoc[$i] = str_replace('buyexpdoc','ed.buyexpdoc',$lv_fltarrdoc[$i]);
              //$lv_fltarrdoc[$i] = str_replace('buyexpdocdte','ed.buyexpdocdte',$lv_fltarrdoc[$i]);
              $lv_fltarrdoc[$i] = str_replace('buyexptyptxt','et.buyexptyptxt',$lv_fltarrdoc[$i]);
              $lv_fltarrdoc[$i] = str_replace('buyexpdoctot','ed.buyexpdoctot',$lv_fltarrdoc[$i]);
              $lv_fltarrdoc[$i] = str_replace('buyexpcod','ed.buyexpcod',$lv_fltarrdoc[$i]);
            }
          }
          $lv_prmflt = array('vewfldflt' =>'[~fltrow~]ed.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
                                           (count($lv_fltarrdoc)>0?implode('[~fltrow~]',$lv_fltarrdoc):'').
                             							 ($lv_cntfltpat ? '[~fltrow~]ed.buyexpdoccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_expdoccodarr) .chr(9).chr(9) : ''),
                            'vewfldord' => 'ed.buyexpcod desc,ed.buyexpdocdte desc'
                            );
          $lo_rs_expdoc=$lo_buyexpdoc->getListDoc($lv_prmflt );
        
        	// 4.0 - ID's de CABECERAS ASOCIADAS A LAS POSICIONES
          $lo_buyexpcodarr = array();
          foreach ($lo_rs_expdoc as $lv_row) {
          	array_push($lo_buyexpcodarr,$lv_row['buyexpcod']);
          }
        

          // 4- CABECERA
          $lo_buyexp = $this->co_reg->load->model('buyexp');
          // 4.1 FILTROS
          $lv_cntfltexp = false;
          $lv_fltarrexp = explode('[~fltrow~]',$lo_post['vewfldflt'] );
          for($i=count($lv_fltarrexp)-1; $i>0; $i--){
            if(stripos(';buyexptxt;srcobjtxt;',';'.explode(chr(9),$lv_fltarrexp[$i])[0].';')===false){
              unset($lv_fltarrexp[$i]);
            }else{
              $lv_cntfltexp = true; 
              $lv_fltarrexp[$i] = str_replace('buyexptxt','e.buyexptxt',$lv_fltarrexp[$i]);
              //v_fltarrexp[$i] = str_replace('srcobjtxt','e.srcobjtxt',$lv_fltarrexp[$i]);
            }
          }
          $lv_prmflt = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
                              						 ($lo_buyexpcodarr ? '[~fltrow~]e.buyexpcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_buyexpcodarr) .chr(9).chr(9) : '').
                                           (count($lv_fltarrexp)>0?implode('[~fltrow~]',$lv_fltarrexp):''),
                                           'vewfldord' => 'e.buyexpcod desc,e.buyexpdte desc');
          $lo_rs_exp=$lo_buyexp->getList($lv_prmflt, null, null, false);
          $lv_sqlstm[]=$lo_buyexp->getsysdata('sqlstm');
        
          // LIQUIDACION. se obtienen las liquidaciones a prestadores de estos gastos
          $lo_lqddocmdl = $this->co_reg->load->model('hltprslqddoc');
          $lo_buydoclst= array();
          foreach ($lo_rs_expdoc as $lv_row) {
            if(!in_array( $lv_row['buyexpdoccod'],$lo_buydoclst)){
              $lo_buydoclst[]=$lv_row['buyexpdoccod'];	
            }
          }
					
          $lv_prmlqd = array('vewfldflt' =>'[~fltrow~]ld.refobjcod002'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_buydoclst).chr(9).chr(9).
                                           '[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_EXP'.chr(9).chr(9),
                                       		 'vewfldord' => 'ld.refobjcod001',
                            							 'vewmaxrec'=>$lo_post['vewmaxrec']
                            );
          $lors_lqddocmdl= $lo_lqddocmdl->getList($lv_prmlqd);
        	$lv_sqlstm[]=$lo_lqddocmdl->getsysdata('sqlstm');

          // POSICIONES DE GASTOS
          foreach ($lo_rs_expdoc as $lv_row_doc) {
            $lo_doc = array();
            $lo_doc['buyexpdoccod']=$lv_row_doc['buyexpdoccod'];
            $lo_doc['buyexpdocdte']=$lv_row_doc['buyexpdocdte']->format('d/m/Y');
            $lo_doc['buyexptyptxt']=$lv_row_doc['buyexptyptxt'];
            $lo_doc['buyexpdoctot']=$lv_row_doc['buyexpdoctot'];
            $lo_doc['impobjtxt']=isset($lv_row_doc['impobjtxt']) ? $lv_row_doc['impobjtxt'] : '';
            $lo_doc['buyexpdocnumdoc']=isset($lv_row_doc['buyexpdocnum']) ? $lv_row_doc['buyexpdocnum'] : '';
            $lo_doc['buyexpdocnum']='';
            // CABECERA DE GASTO
            $lv_foundexp = false;
            foreach ($lo_rs_exp as $lv_row_exp) {
              if($lv_row_doc['buyexpcod']==$lv_row_exp['buyexpcod']){
                $lo_doc['buyexpcod']=$lv_row_exp['buyexpcod'];
                $lo_doc['buyexptxt']=$lv_row_exp['buyexptxt'];
                $lo_doc['buyexpdte']=$lv_row_exp['buyexpdte']->format('d/m/Y');
                $lo_doc['sysdocclstxt']=$lv_row_exp['sysdocclstxt'];
                $lo_doc['srcobjtyp']=$lv_row_exp['srcobjtyp'];
                $lo_doc['objtyptxt']=$lv_row_exp['objtyptxt'];
                $lo_doc['srcobjcod']=$lv_row_exp['srcobjcod'];
                $lo_doc['srcobjtxt']=$lv_row_exp['srcobjtxt'];
                $lv_foundexp = true;
              }
            }

            foreach ($lors_lqddocmdl as $lv_row_lqd) {
              if($lv_row_doc['buyexpdoccod']==$lv_row_lqd['refobjcod002']){
                $lo_doc['buyexpdocnum']=$lv_row_lqd['hltprslqdcod'];
              }
            }

						// solo gastos imputados a pacientes liquidados a prestadores
            if($lo_doc['buyexpdocnum']==''){ continue; }

            if($lv_cntfltexp==true && $lv_foundexp==false) { continue; }
            
            //IMPUTACIÓN. creo una fila por cada imputación. Si no hay imputación, dejo la fila sin datos de imputación
            $lv_impcount = 0;
            foreach($lo_rs_expimp as $lv_row_imp){
              if($lv_row_imp['buyexpdoccod'] == $lv_row_doc['buyexpdoccod']){
                $lv_impcount++;
                $lo_impdoc = $lo_doc;
                $lo_impdoc['custxt'] = (isset($lv_row_imp['custxt'])?$lv_row_imp['custxt']:'');
                $lo_impdoc['hltdisclstxt'] = (isset($lv_row_imp['hltdisclstxt'])?$lv_row_imp['hltdisclstxt']:'');
                $lo_impdoc['patcodext'] = (isset($lv_row_imp['patcodext'])?$lv_row_imp['patcodext']:'');
                $lo_impdoc['pattxt'] = $lv_row_imp['impobjtxt'];
                $lo_impdoc['pattxt'] = $lv_row_imp['impobjtxt'];
                $lv_pct = (float)$lv_row_imp['buyexpdocimpqty'];
                $lo_impdoc['imppct'] = $lv_pct;
                $lo_impdoc['buyexpdoctot'] = (float)$lo_doc['buyexpdoctot'] * ($lv_pct / 100);
            		$lo_ret[]= $lo_impdoc;
              }
            }
            
            if($lv_impcount<1){ 
              $lo_doc['imppct'] = 0;
              $lo_doc['buyexpdoctot'] = (float)$lv_row_doc['buyexpdoctot'];
              $lo_ret[]= $lo_doc; 
            }
          }
        
          //ini_set('memory_limit', $lv_lmtmem);
        	$lo_ret[0]['sqlstm']=$lv_sqlstm;
          return $lo_ret; 

          break;
        case '#chklqdrngdte':
        	$lv_lqdstrdte=$lp_prm['data']['hltprslqdstrdte'];
        	$lv_lqdenddte=$lp_prm['data']['hltprslqdenddte'];
        
          $lv_lqdstrdtemth = explode('/', $lv_lqdstrdte)[1];
          $lv_lqdenddtemth = explode('/', $lv_lqdenddte)[1];
        
        	$lv_ret=array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        	//hltprslqdenddte
        	//hltprslqdenddte
        	
        	if($lv_lqdstrdtemth!=$lv_lqdenddtemth){
          	$lv_ret=array('errtyp'=>'E','errcod'=>'-1000','errtxt'=>'No esposible realizar liquidaciones de periodos en diferente mes');  
          }
        
        	return $lv_ret;
        	
          break;
        case '#chklqdautrngdte':
        	$lv_lqdstrdte=$lp_prm['data']['hltprslqdgrpstrdte'];
        	$lv_lqdenddte=$lp_prm['data']['hltprslqdgrpenddte'];
        
          $lv_lqdstrdtemth = explode('/', $lv_lqdstrdte)[1];
          $lv_lqdenddtemth = explode('/', $lv_lqdenddte)[1];
        
        	$lv_ret=array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        	//hltprslqdenddte
        	//hltprslqdenddte
        	
        	if($lv_lqdstrdtemth!=$lv_lqdenddtemth){
          	$lv_ret=array('errtyp'=>'E','errcod'=>'-1000','errtxt'=>'No esposible realizar liquidaciones de periodos en diferente mes');  
          }
        
        	return $lv_ret;
        	
          break;
        //
        //    Check LQD Data
        //
        case '#chklqddat':
          $lv_prscod=$lp_prm['data']['prscod'];
          $lv_ret=array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
          $lo_prsmdl = $this->co_reg->load->model('hltprs');
          if(!$lo_prsmdl->load(array('prscod'=>$lv_prscod), false)){
            return array('errtyp'=>'E','errcod'=>$lo_prsmdl->errcod,'errtxt'=>$lo_prsmdl->errtxt);  
          }
          $lv_errlst=array();

          if($lo_prsmdl->bnk->bnkacccbu==''){
            $lv_errlst[]=array('errtxt'=>'Falta CBU');
          }  
          if($lo_prsmdl->bnk->bnktxt==''){
            $lv_errlst[]=array('errtxt'=>'Falta Banco');
          }        
          if($lo_prsmdl->tax->idttyptxt!='CUIT'){
            $lv_errlst[]=array('errtxt'=>'Falta CUIT');
          }
          if(count($lv_errlst)>0){
            $lv_ret['errtyp']='E';
            $lv_ret['errcod']=count($lv_errlst)*-100;
            $lv_ret['errtxt']='Faltan datos en el prestador o alguno es erroneo:';
            foreach($lv_errlst as $lo_row_err){
              $lv_ret['errtxt'].='<br>'.$lo_row_err['errtxt'];
            }
          }
          return $lv_ret;
          break;
        case '#chkaccdeldat':
        	$lv_buyexpcod=$lp_prm['data']['buyexpcod'];
          $lv_ret=array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
          $lv_errlst=array();
        	/*BUSCO EL GASTO EN LIQUIDACION A CLIENTE*/
        	$lo_lqddocmdl = $this->co_reg->load->model('hltlqddoc');
        	$lv_prmlqd = array('vewfldflt' =>'[~fltrow~]ld.RefObjCod001'.chr(9).'='.chr(9).chr(9).$lv_buyexpcod.chr(9).chr(9).
                                           '[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_EXP'.chr(9).chr(9)
                            );
          $lo_buyexplst= $lo_lqddocmdl->getList($lv_prmlqd);
        	if(count($lo_buyexplst)>0){
            $lv_errlst[]=array('errtxt'=>'Liq. a cliente ID: '.$lo_buyexplst[0]['hltlqdcod']);
          }
					
        	/*BUSCO EL GASTO EN LIQUIDACION A PRESTADOR*/
        	$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
        	$lv_prmlqd = array('vewfldflt' =>'[~fltrow~]ld.RefObjCod001'.chr(9).'='.chr(9).chr(9).$lv_buyexpcod.chr(9).chr(9).
                                           '[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_EXP'.chr(9).chr(9)
                            );
          $lo_prsbuyexplst= $lo_prslqddocmdl->getList($lv_prmlqd);
        	if(count($lo_prsbuyexplst)>0){
            $lv_errlst[]=array('errtxt'=>'Liq. a prestador ID: '.$lo_prsbuyexplst[0]['hltprslqdcod']);
          }        
        
          if(count($lv_errlst)>0){
            $lv_ret['errtyp']='E';
            $lv_ret['errcod']=count($lv_errlst)*-100;
            $lv_ret['errtxt']='No se puede descontabilizar el gasto ya que se encuentra en al menos una liquidacion:';
            foreach($lv_errlst as $lo_row_err){
              $lv_ret['errtxt'].='<br>'.$lo_row_err['errtxt'];
            }
          }
          return $lv_ret;
          break;
        	case '#evlest':
            /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				
				// CREAR EVOLUCION
        $lv_patcod ='';
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod; 
				if ( $lv_evlcod=='' ) {
          $lv_fldrec='';
          //if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          //  $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
          //}
          
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);
          
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          /* ------------------------------------------------ */         
          /* Buscar datos sugerencia de material */
          /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
           $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
          if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
          }
          
          /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
          $lo_patmdl = $this->co_reg->load->model('hltpat');	
          if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod), false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
          }
          
          /*3. Busco el material */
          $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
          $lo_plndtemdl->mattxt = '';
          $lo_plndtemdl->matcod = '';
          $lo_matmdl = $this->co_reg->load->model('stkmat');	
          if($lv_matcod !=''){
            if(!$lo_matmdl->load(array('matcod'=>$lv_matcod), false)){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
            }
          }
          $lo_plndtemdl->matcod = $lo_matmdl->matcod;
          $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;                
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					//$lo_plndtemdl->hhcc=$lv_hhcc;
					
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
												//,model' => self::MODEL
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );   
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}

					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
                          //'model' => self::MODEL,
													'rsplndte'=>array(),
													);
				}
				
        $lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
        $prmPatRsl = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                           							 '[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
                                      	 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rs = $lo_patprsrlsmdl->getList($prmPatRsl);
        $lv_prm['data']->patprsrlscod='';
        $lv_prm['data']->patprsrlstxt='';
        if(count($lo_rs)>0){
          $lv_prm['data']->patprsrlscod;$lo_rs[0]['prscod'];
        	$lv_prm['data']->patprsrlstxt=$lo_rs[0]['prstxt'];
          //$lv_patprsrlscod = $lo_rs[0]['prscod'];
          //$lv_patprsrlscod = $lo_rs[0]['prscod'];
        } 
        //$lv_patprsrlscod = $lo_patprsrlsmdl->getsysdata('sqlstm');
        
        
				// regreso la vista 
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutp1_tinestgrl', $lv_prm);
				return $lv_buffer;
        break;
        
        //   EVOLUCION - GRABAR
			case '#evlest00':

				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        
        $lv_buf_arr['evlatr001'].= '<reqcc>'.$lv_buf_arr['reqcc'].'</reqcc>';
        $lv_buf_arr['evlatr001'].= '<dtesrv>'.$lv_buf_arr['dtesrv'].'</dtesrv>';
        $lv_buf_arr['evlatr001'].= '<mevlmd>'.$lv_buf_arr['mevlmd'].'</mevlmd>';
        //$lv_buf_arr['evlatr001'].= '<evlmd>'.$lv_buf_arr['evlmd'].'</evlmd>';
        $lv_buf_arr['evlatr001'].= '<ath>'.$lv_buf_arr['ath'].'</ath>'; 
        $lv_buf_arr['evlatr001'].= '<patprsrlscod>'.$lv_buf_arr['patprsrlscod'].'</patprsrlscod>'; 
        $lv_buf_arr['evlatr001'].= '<patprsrlstxt>'.$lv_buf_arr['patprsrlstxt'].'</patprsrlstxt>'; 
        $lv_buf_arr['evlatr001'].='</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];

				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
          $lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1'){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          /* DATOS DEL PACINTE */
          $lo_patdl = $this->co_reg->load->model('hltpat');
          $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;//$lo_patdl->custxt??'error';
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $this->sendMailFarma($lvDataFarma);
          /*
          
          // obtengo texto del mensaje
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                        '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
          $lo_rs = $lo_txtmdl->getList($lv_prm);
          if( count($lo_rs)!=0 ) {
            $lv_usrmsg = $lo_rs[0]['txttxt'];
          } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontró el texto del mensaje.';
          } 
          // determino destinatarios
          $lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
          if($lv_issisdev !== false){
            $lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
            $lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
            $lv_mailto[] = array('address'=>'jrigolino@teaminfusion.com');
          }else{
            $lv_mailto[] = array('address'=>'coordinacion@teaminfusion.com');
            $lv_mailto[] = array('address'=>'estudios@teaminfusion.com');
          }
          // envío mail
          if ( $lv_usrmsg!='') {
            $lo_eml = new tmssMail();
            $lv_emlprm= array();
            $lv_emlprm['to'] = $lv_mailto;
            $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Infusion') );
            $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
            $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
            $lv_usrmsg = str_replace( '[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia' , $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lv_buf_arr['patcod'] . ' ) <strong>'.   utf8_decode($lo_patdl->patpro). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lo_evlmdl->evlcod . ' ) <strong>'. $lv_buf_arr['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lv_buf_arr['prscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lv_buf_arr['spccod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['spctxt']) .'</strong>', $lv_usrmsg);
            $lv_emlprm['bodyhtml'] = $lv_usrmsg;
            if ( $lo_eml->send( $lv_emlprm ) ) {
              $lv_errcod = '';
              $lv_errtxt = '';
            } else {
              $lv_errcod = '-1';
              $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
            }
          }
          */
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
      //   EVOLUCION - BORRAR
			case '#evlest04': 
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lv_ret = array('errtyp'=>'','errcod'=>'0','errtxt'=>'') ;
        

				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret=   array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
          
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
          $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false);
       		$lv_ret=   array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt);
					
				}        
				return $this->co_reg->document->getJson($lv_ret);
				break;
      case '#grlprmcarupd':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_tin&act=grlprmcarupd&prm_mdlcod=TPEVLPRNBL
        $lv_ret = array('errtyp'=>'S','errcod'=>'','errtxt'=>'');
        if(!isset($lp_prm['mdlcod'])){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No se encontro parametro [mdlcod]') );
        }
        $lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
        
        if ( !$lo_txtmdl->load($lp_prm['mdlcod'])) {
          return $lo_txtmdl->document->getJson( array('errtyp'=>'E','errcod'=>$lo_txtmdl->errcod,'errtxt'=>$lo_txtmdl->errtxt) );
        }
        $lv_mdlatrval001='';
        $lv_mdlatrval001.='<dtestr>' . (new DateTime('first day of last month'))->format('Y-m-d') . '</dtestr>' ;
        $lv_mdlatrval001.='<dteend>' . (new DateTime('last day of last month'))->format('Y-m-d'). '</dteend>' ;
        $lv_key['mdlcod']=$lo_txtmdl->mdlcod;
        $lv_key['mdlatrval001']=$lv_mdlatrval001;
        $lv_key['docsts']=$lo_txtmdl->docsts;
        
        if ( !$lo_txtmdl->save($lv_key)) {
          return $lo_txtmdl->document->getJson( array('errtyp'=>'E','errcod'=>$lo_txtmdl->errcod,'errtxt'=>$lo_txtmdl->errtxt) );
        }
        return $this->co_reg->document->getJson($lv_ret);
				break;
        
      case '#rptcrmactpat':
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $lv_data_rs = array();
        $lv_crmmtvls = str_replace(',',chr(10),($lp_prm['cntmtv']??''));
        $lv_crmtypls = str_replace(',',chr(10),($lp_prm['cnttyp']??''));
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        //Filtros CONTACTOS CRM 
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';crmcnttxt;crmcnttyptxt;crmcntsrccnttxt;crmcntsrctxt;crmcntmtvtxt;crmcntcod;crmcntreqdte;crmcntduedte;crmcntststxt;crmcntrqs;usrcod;crmcnttypcod;custxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}else{
            $lv_fltarrcnt[$i]=str_replace('usrcod','c.usrcod',$lv_fltarrcnt[$i]);
            $lv_fltarrcnt[$i]=str_replace('crmcntreqdte','c.crmcntreqdte',$lv_fltarrcnt[$i]);
            //echo $lv_fltarrcnt[$i];
          }
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
                           								'[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                           								'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntreqdte desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
        if($lv_crmmtvls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9);
        }
        if($lv_crmtypls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcnttypcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmtypls.chr(9).chr(9);
        }
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lv_crmcntsrccodlst= array_column($lo_crmcnt_rs, 'crmcntsrccod','crmcntsrccod');
        
        //PACIENTES
        $lo_mdlPat = $this->co_reg->load->model('hltpat');
        //Filtros PACIENTES
				$lv_fltarrPat = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );
        $fltPat=false;
				for($i=count($lv_fltarrPat)-1; $i>0; $i--){
					if(stripos(';patcod;pattxt;lndregtxt;hltdisclstxt;hhrmedcovtxt;patcodext;patpro;',';'.explode(chr(9),$lv_fltarrPat[$i])[0].';')===false){
						unset($lv_fltarrPat[$i]);
					}else{
            $fltPat=true;
            $lv_fltarrPat[$i]=str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrPat[$i]);
            $lv_fltarrPat[$i]=str_replace('patpro','p.patpro',$lv_fltarrPat[$i]);
            
          }
				}
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_crmcntsrccodlst) .chr(9).chr(9).
                           							 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 (count($lv_fltarrPat)>0?implode('[~fltrow~]',$lv_fltarrPat):''),
													 'vewfldord' => 'p.patcod desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
      	$lo_pat_rs= $lo_mdlPat->getlist($lv_prmflt,null,null,false);
        $patDatLst=[];
        foreach($lo_pat_rs as $rowPat){
          $patDatLst[$rowPat['patcod']]=$rowPat;
        }
        $lv_data_sqlstm[]=$lo_mdlPat->getSysData('sqlstm');
        
        //RELACION ENFERMERO
        $lo_mdlrls = $this->co_reg->load->model('hltpatprsrls');
				//Filtro
				$fltArrEnf = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $fltMed=false;
				for($i=count($fltArrEnf)-1; $i>0; $i--){
					if(stripos(';rlstxtmec;',';'.explode(chr(9),$fltArrEnf[$i])[0].';')===false){
						unset($fltArrEnf[$i]);
					}else{
            $fltMed=true;
						$lv_flt=explode(chr(9),$fltArrEnf[$i]);
						if($lv_flt[0]=='rlstxtcoo'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$fltArrEnf[$i]=implode(chr(9),$lv_flt);
						}
					}
				}
				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
                        							'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_crmcntsrccodlst) .chr(9).chr(9).
																			(count($fltArrEnf)>0?implode('[~fltrow~]',$fltArrEnf):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rlscoo_rs = $lo_mdlrls->getList($lv_prm);
        $lv_data_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');      
        $lv_patrlsprs= array_column($lo_rlscoo_rs, 'prstxt','patcod');
        // Parametro de empresa
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'RPTCRMACT'))){
        	return array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt);
        }
         $lv_data_sqlstm[]= $lo_prmmdl->getsysdata('sqlstm');   
        $lv_attr=$lo_prmmdl->mdlatrval001;//str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        
        $lv_ret =[];
        foreach($lo_crmcnt_rs as $rowCnt){
          $lv_patKey= $rowCnt['crmcntsrccod'];
          $lvRow=$rowCnt;
          $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'MTV_'.$rowCnt['crmcntmtvcod']);
          //$lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          if($lvRow['crmcntcuscattxt']==''){
            $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          }
          
          if(array_key_exists($lv_patKey,$patDatLst)){
          	$lvRow=$lvRow+$patDatLst[$lv_patKey];  
          }else{
            continue;
          }
          
          if(array_key_exists($lv_patKey,$lv_patrlsprs)){
          	$lvRow['rlstxtmec']=$lv_patrlsprs[$lv_patKey];  
          }else if($fltPat){
            continue;
          }
          $lv_ret[]=$lvRow;
        }
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        return $lv_ret;
        break;
        
      case '#rptcrmactcus':
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $lv_data_rs = array();
        $lv_crmmtvls = str_replace(',',chr(10),($lp_prm['cntmtv']??''));
        $lv_crmtypls = str_replace(',',chr(10),($lp_prm['cnttyp']??''));
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        //Filtros CONTACTOS CRM 
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';crmcnttxt;crmcnttyptxt;crmcntsrccnttxt;crmcntsrctxt;crmcntmtvtxt;crmcntcod;crmcntreqdte;crmcntduedte;crmcntststxt;crmcntrqs;usrcod;crmcnttypcod;custxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}else{
            $lv_fltarrcnt[$i]=str_replace('usrcod','c.usrcod',$lv_fltarrcnt[$i]);
            $lv_fltarrcnt[$i]=str_replace('crmcntreqdte','c.crmcntreqdte',$lv_fltarrcnt[$i]);
            //echo $lv_fltarrcnt[$i];
          }
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
                           								'[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
                           								'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntreqdte desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
        if($lv_crmmtvls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9);
        }
        if($lv_crmtypls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcnttypcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmtypls.chr(9).chr(9);
        }
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lv_crmcntsrccodlst= array_column($lo_crmcnt_rs, 'crmcntsrccod','crmcntsrccod');
        
        // Parametro de empresa
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'RPTCRMACT'))){
        	return array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt);
        }
        $lv_data_sqlstm[]= $lo_prmmdl->getsysdata('sqlstm');   
        $lv_attr=$lo_prmmdl->mdlatrval001;//str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        
        $lv_ret =[];
        foreach($lo_crmcnt_rs as $rowCnt){
          $lv_cusKey= $rowCnt['crmcntsrccod'];
          $lvRow=$rowCnt;
          $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'MTV_'.$rowCnt['crmcntmtvcod']);
          //$lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          if($lvRow['crmcntcuscattxt']==''){
            $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          }
          
          $lv_ret[]=$lvRow;
        }
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        return $lv_ret;
        break;
        
      case "#parwgtchgrpt":
        $lo_post = $this->co_reg->request->post;
        $lv_sqlstm=[];
        
        /* Buscamos los pacientes */ 
        /* Filtro de pacientes */
        $lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrpat)-1; $i>0; $i--){
          if(stripos(';patcod;patcodext;pattxt;cuscod;custxt;p.docsts;hltdisclstxt;hltpatclstxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
            unset($lv_fltarrpat[$i]);
          }else{ 
            $lv_fltarrpat[$i] = str_replace('patcod'   ,'p.patcod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('patcodext','p.patcodext',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('pattxt'	 ,'p.pattxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('cuscod' ,'p.cuscod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('custxt' ,'c.custxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('p.docsts' ,'p.docsts',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('hltpatclstxt' ,'pcl.hltpatclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('hltdisclstxt' ,'pdc.hltdisclstxt',$lv_fltarrpat[$i]);
          }
        }
         
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prmpat = array('vewfldflt' =>'[~fltrow~]1'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                           							 (count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
                           'vewfldord' => 'p.patcod',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													 );
        
        $lv_rspat=$lo_patmdl->getList($lv_prmpat, null, null, false);
        $lv_sqlstm[]=$lo_patmdl->getSysData('sqlstm');
        $lstPat= array_column($lv_rspat, 'patcod','patcod');
        
        
        // Cambios
        $mdlChg = $this->co_reg->load->model('sysdocchg');
        
        $prmChg = array('vewfldflt' =>'[~fltrow~]dc.chgdocsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                           							 '[~fltrow~]chgdocsrccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lstPat) .chr(9).chr(9).
                           							 '[~fltrow~]dca.chgdocatrnme'.chr(9).'='.chr(9).chr(9).'patwgt'.chr(9).chr(9),
                        'vewfldord' => 'chgdocsrccod desc',
                        'vewfldgrp' => 'chgdocsrccod',
                        'vewfldgrpcal' => 'max(chgdocatrcod) as chgdocatrcod'
													 );
        $rsChg=$mdlChg->getVariousDetails($prmChg, null, null, false);
        $lv_sqlstm[]=$mdlChg->getSysData('sqlstm');
        $lstDocAtrCod= array_column($rsChg, 'chgdocatrcod','chgdocatrcod');
        
        /* Filtro de cambios */
        $lv_fltchg=false;
        $lv_fltarrchg = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrchg)-1; $i>0; $i--){
          if(stripos(';ctechgdte;',';'.explode(chr(9),$lv_fltarrchg[$i])[0].';')===false){
            unset($lv_fltarrchg[$i]);
          }else{ 
            $lv_fltchg=true;
            $lv_fltarrchg[$i] = str_replace('ctechgdte','dca.ctedte',$lv_fltarrchg[$i]);
          }
        }
        
        $prmChg = array('vewfldflt' =>'[~fltrow~]chgdocatrcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lstDocAtrCod) .chr(9).chr(9).
                                      	(count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrchg):''),
                        'vewfldord' => 'chgdocsrccod desc'
													 );
        $rsChg=$mdlChg->getVariousDetails($prmChg, null, null, false);
        $lv_sqlstm[]=$mdlChg->getSysData('sqlstm');
        $datAtrChg=array();
        foreach($rsChg as $rowChg){
          $datAtrChg[$rowChg['chgdocsrccod']]=array('chgdocatrold'=>$rowChg['chgdocatrold']
                                                   ,'chgdocatrnew'=>$rowChg['chgdocatrnew']
                                                    ,'ctechgdte'=>$rowChg['ctedte']
                                                   ,'ctechgusr'=>$rowChg['cteusr']
                                                   );
        }
        $ret=[];
        foreach($lv_rspat as $rowPat){
          $newRow=[];
          if(isset($datAtrChg[$rowPat['patcod']])){
          	$newRow= array_merge($rowPat,$datAtrChg[$rowPat['patcod']]);
          }else{
            $newRow=$rowPat;
          }
          //if($lv_fltchg && (!isset($newRow['ctechgdte']) || $newRow['ctechgdte']=='')){
          if($lv_fltchg && (($newRow['ctechgdte']??'')=='')){
            continue;
          }
        	$ret[]=$newRow;
        }
        $ret[0]['sqlstm']= $lv_sqlstm;
        return $ret;
      // grusso
      //   EVOLUCION - CREAR/VER/MODIFICAR
      case '#evlinf': case '#02':{
				/*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])
          ? $this->co_reg->request->post['evlcod']
          : ($lp_prm['evlcod']??''));
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
        
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }      
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        
        $PatChgDte = '';
        $lv_plndte = $lo_plndtemdl->plndte;
        // En prestaciones no realizadas la planificacion puede no devolver el
        // evlcod, aunque la evolucion exista con estado P. Se conserva primero
        // el codigo recibido y luego se buscan alternativas seguras.
        if($lv_evlcod==''){
          $lv_evlcod = $lo_plndtemdl->evlcod??'';
        }
        if($lv_evlcod=='' && $lv_plnid!='' && $lv_plndteid!=''){
          $lv_evlexistingprm = array(
            'vewfldflt'=>'[~fltrow~]e.plnid'.chr(9).'='.chr(9).chr(9).$lv_plnid.chr(9).chr(9).
                           '[~fltrow~]e.plndteid'.chr(9).'='.chr(9).chr(9).$lv_plndteid.chr(9).chr(9).
                           '[~fltrow~]e.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'P'.chr(9).chr(9),
            'vewfldord'=>'e.evlcod DESC',
            'vewmaxrec'=>'1'
          );
          $lv_evlexistingrs = $lo_evlmdl->getList($lv_evlexistingprm, null, null, false);
          if(count($lv_evlexistingrs)>0){
            $lv_evlcod = $lv_evlexistingrs[0]['evlcod']??'';
          }
        }
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod;
        //--
        /* ------------------------------------------------ */
        /* obtengo clase de documento 											*/
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
          } else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
          }
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
        } else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        /* ------------------------------------------------ */         
        /* Buscar datos sugerencia de material */
        /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
         $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt));
        }

        /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
        $lo_patmdl = $this->co_reg->load->model('hltpat');	
        if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
        }

        /*3. Busco el material */
        $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
        $lo_plndtemdl->mattxt = '';
        $lo_plndtemdl->matcod = '';
        $lo_matmdl = $this->co_reg->load->model('stkmat');	
        if($lv_matcod !=''){
          if(!$lo_matmdl->load(array('matcod'=>$lv_matcod),false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
          }
        }
        $lo_plndtemdl->matcod = $lo_matmdl->matcod;
        $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
        $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm);
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
          // buscar ultimo peso
          
          $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
          $lv_prmchg= array('chgdocsrctyp'=>'HLT_PAT','chgdocsrccod'=>$lo_patmdl->patcod);
          $rsChg=$lo_docchgmdl->getDetail( $lv_prmchg );
          
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);

          // VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          $lo_plndtemdl->matuntcod = '';
					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array(),
													);
				}
				
				// * REGRESO LA VISTA *
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
				$lv_prm['data']->hhcc=$lv_hhcc;
        $lv_prm['data']->fldrec=$lv_fldrec;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
        $lv_prm['data']->matcod = $lo_matmdl->matcod;
        $lv_prm['data']->mattxt = $lo_matmdl->mattxt;
        $lv_prm['data']->matuntcod = $lo_matmdl->matuntcod;
        $lv_prm['data']->endpoint=self::VIEW;
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutp2', $lv_prm); 
				return $lv_buffer;
        break;
      }
			
			//   EVOLUCION - GRABAR
			case '#evlinf00':
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
        // GRABAR PESO DEL PACIENTE
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_oldval = $lo_patdl->patwgt;
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );

        
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlcod']==''?$lv_buf_arr['evlevl']:'';
        
        $lv_buf_arr['fvrpt']=$lv_buf_arr['fvrpt']??'1';//isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        $lv_buf_arr['evlatr001'].= '<matdos>'.$lv_buf_arr['matdos'].'</matdos>';
        $lv_buf_arr['evlatr001'].= '<matuntcod>'.$lv_buf_arr['matuntcod'].'</matuntcod>';
        $lv_buf_arr['evlatr001'].='</row>';
        if($lv_buf_arr['evlcod']==''){
					$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
        }
        
        
				//Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
				// EVOLUCION - grabo los datos de cabecera
				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {
					$lv_err = $this->validateFileSize($lv_docsts);if ( $lv_err ) {    return $this->co_reg->document->getJson( $lv_err );}
					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
          //echo $lo_upltypmdl->getsysdata('sqlstm');
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          // elimino los materiales 
          $lvMatDelLst = html_entity_decode($this->co_reg->request->post['evlmatdel']);
          $lvMatDelArr = explode(";",$lvMatDelLst);//json_decode($lv_buffer,true);
          foreach( $lvMatDelArr as $lv_row ) {
            if ($lo_evlmatmdl->delete(array('evlmatcod'=>$lv_row))==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
            }
          }
          
					// EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
          /*
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr =  json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
              if( !isset($lv_row['matcod']) || $lv_row['matcod']==''|| $lv_row['matcod']=='0'){
                continue;
              }
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
          */
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['evlcod']=='' && ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          /*
          // obtengo texto del mensaje
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                        '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
          $lo_rs = $lo_txtmdl->getList($lv_prm);
          if( count($lo_rs)!=0 ) {
            $lv_usrmsg = $lo_rs[0]['txttxt'];
          } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontró el texto del mensaje.';
          }
          */
          // obtengo mensaje de notificacion
          $lv_txtcodext = 'HLTEVLGRL';
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');

          if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
            $lv_usrmsg = $lo_txtmdl->txttxt;
          } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontró el texto del mensaje.';
          }
          
          $ctlZcuTin = $this->co_reg->load->controller('zcutp1_tin');
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $ctlZcuTin->sendMailFarma($lvDataFarma);
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
			
			//   EVOLUCION - BORRAR
			case '#evlinf04':
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lv_ret = array('errtyp'=>'','errcod'=>'0','errtxt'=>'') ;
        

				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret=   array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
          if($lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false)==false) {
          	$lv_ret=   array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt,'sqlsmt'=> $lo_evlmdl->getsysdata('sqlstm')); // acá esta el erroro  
            return $this->co_reg->document->getJson($lv_ret);
          }
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
					
				}        
				return $this->co_reg->document->getJson($lv_ret);
				break;
      //-fin grusso
       //   EVOLUCION -COAGUCHEK - CREAR/VER
      case '#evlcoa': case '#evlcoa02':{
				/*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        
        //Busco los materiales
        $lo_matmdl = $this->co_reg->load->model('stkmat');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'm.mattxt');
        $lo_mat_rs=$lo_matmdl->getList($lv_prm, null, null, false);
        
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }      
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        $PatChgDte = '';
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod;
        /* ------------------------------------------------ */
        /* obtengo clase de documento 											*/
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
          } else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
          }
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
        } else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        /* ------------------------------------------------ */         
        /* Buscar datos sugerencia de material */
        /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
         $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt));
        }

        /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
        $lo_patmdl = $this->co_reg->load->model('hltpat');	
        if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
        }

        /*3. Busco el material */
        $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
        $lo_plndtemdl->mattxt = '';
        $lo_plndtemdl->matcod = '';
        $lo_matmdl = $this->co_reg->load->model('stkmat');	
        if($lv_matcod !=''){
          if(!$lo_matmdl->load(array('matcod'=>$lv_matcod),false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
          }
        }
        $lo_plndtemdl->matcod = $lo_matmdl->matcod;
        $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
        $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
        
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  
					
          /* ------------------------------------------------ */
          /* obtengo paciente           											*/
          /* ------------------------------------------------ */
          $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
            
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          /* ------------------------------------------------ */
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
          $lo_plndtemdl->custxt = $lo_patmdl->custxt;
					$lo_plndtemdl->docsts = 'P';
					
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
                          'matlst'=>$lo_mat_rs,
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          
					// preparo datos de vista
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
                          'matlst'=>$lo_mat_rs,
													'rsplndte'=>array()
													);
				}
				
				// regreso la vista
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
       // $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;

        // 1. Busco el parametro para obtener los campos obligatorios segun especialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lo_prmmdl->mdlatrval001=str_replace(',',';',$lo_prmmdl->mdlatrval001);
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }     
        $lv_prm['data']->fldrec=$lv_fldrec;
        $lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
        
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
        $lv_prm['data']->matcod = $lo_matmdl->matcod;
        $lv_prm['data']->mattxt = $lo_matmdl->mattxt;
        $lv_prm['data']->matuntcod = $lo_matmdl->matuntcod;
        $lv_prm['data']->endpoint=self::VIEW;
        
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlcoa', $lv_prm);
				return $lv_buffer;
        break;
    	}
			
			//   EVOLUCION -COAGUCHEK - GRABAR
			case '#evlcoa00':{
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				//$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['evlevl']= $lv_buf_arr['evlcod']==''?$lv_buf_arr['evlevl']:'';
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'] .= '<evlcmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcmt']).'</evlcmt>';
        $lv_buf_arr['evlatr001'] .= '<evlmtt>'.utf8_encode($lv_buf_arr['evlmtt']).'</evlmtt>';
        $lv_buf_arr['evlatr001'] .= '<evllug>'.utf8_encode($lv_buf_arr['evllug']).'</evllug>';
        $lv_buf_arr['evlatr001'] .= '<evlpa1>'.utf8_encode($lv_buf_arr['evlpa1']).'</evlpa1>';
        $lv_buf_arr['evlatr001'] .= '<evlpa2>'.utf8_encode($lv_buf_arr['evlpa2']).'</evlpa2>';
        $lv_buf_arr['evlatr001'] .= '<aplenf>'.utf8_encode($lv_buf_arr['aplenf']).'</aplenf>';
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].='</row>';
        if($lv_buf_arr['evlcod']==''){
					$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
        }
				//$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				
        //Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
        /* DATOS DEL PACINTE */
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_oldval = $lo_patdl->patwgt;
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );
        
        
				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
          // elimino los materiales 
          $lvMatDelLst = html_entity_decode($this->co_reg->request->post['evlmatdel']);
          $lvMatDelArr = explode(";",$lvMatDelLst);//json_decode($lv_buffer,true);
          foreach( $lvMatDelArr as $lv_row ) {
            if ($lo_evlmatmdl->delete(array('evlmatcod'=>$lv_row))==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
            }
          }
          
          // EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
          /*
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							if( !isset($lv_row['matcod']) || $lv_row['matcod']==''|| $lv_row['matcod']=='0'){
                continue;
              }
              $lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
          */
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if( $lv_buf_arr['evlcod']=='' && ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';;     
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $ctlZcuTin = $this->co_reg->load->controller('zcutp1_tin');
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $ctlZcuTin->sendMailFarma($lvDataFarma);
        }
        
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
    	}
			
			//   EVOLUCION -COAGUCHEK - BORRAR
			case '#evlcoa04':{
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>''); 
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']') );
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( !$lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
            
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->getsysdata('sqlstm')) );
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
					}
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>'02') );
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>'03') );
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }					
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      
    	}
  		case '#evlamg': case '#evlamg02':{
        /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');
        
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
        /*
        $lv_plnid='16723';
        $lv_plndteid='8407983';
        */
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	 
        // cargo la evolución
        if($lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false){
          /* ESTO SACARLO PARA PASAR A PRODUCCION 
          $lo_plndtemdl->plndte =new DateTime();
          $lo_plndtemdl->evlcod='';
          $lo_plndtemdl->prscod='174'; 
          $lo_plndtemdl->patcod='750';
          */
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
        }
        $PatChgDte = '';
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod;
        //--
        /* ------------------------------------------------ */
        /* obtengo clase de documento 											*/
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
          } else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
          }
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
        } else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        /* ------------------------------------------------ */         

        /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
        $lo_patmdl = $this->co_reg->load->model('hltpat');	
        if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
        }
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm);
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
          
          // buscar ultimo peso
          $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
          $lv_prmchg= array('chgdocsrctyp'=>'HLT_PAT','chgdocsrccod'=>$lo_patmdl->patcod);
          $rsChg=$lo_docchgmdl->getDetail( $lv_prmchg );
          
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);

          // VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          $lo_plndtemdl->matuntcod = '';
					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array(),
													);
				}
				
				// * REGRESO LA VISTA *
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
				$lv_prm['data']->hhcc=$lv_hhcc;
        //$lv_prm['data']->fldrec=$lv_fldrec;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
        $lv_prm['data']->endpoint=self::VIEW;
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutp1_tinevlamg', $lv_prm); 
				return $lv_buffer;
				break;
    	}
      //   EVOLUCION - GRABAR
			case '#evlamg00':{
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
        // GRABAR PESO DEL PACIENTE
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = $lv_evlinfprc=='1'?'A':'P';
        $lv_buf_arr['evlevl']=$lv_buf_arr['evlevl']??''; 
        $lv_buf_arr['evlcmt'] =$lv_buf_arr['evlcmt']??'';
        $lv_buf_arr['evlcnccmt']=$lv_buf_arr['evlcnccmt']??'';
        $lv_buf_arr['evlcncmtv']= $lv_buf_arr['evlcncmtv']??'';
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlsub'].$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlcod']==''?$lv_buf_arr['evlevl']:'';
        
        $lv_buf_arr['fvrpt']=$lv_buf_arr['fvrpt']??'1';//isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';

        $lv_buf_arr['evlatr001'].='</row>';
        if($lv_buf_arr['evlcod']==''){
					$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
        }
				// EVOLUCION - grabo los datos de cabecera
				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}
     
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['evlcod']=='' && ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          //$lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
			}
      //   EVOLUCION - BORRAR
			case '#evlamg04':
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lv_ret = array('errtyp'=>'','errcod'=>'0','errtxt'=>'') ;
        

				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret=   array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
          
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          /*
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          */
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
          if($lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false)==false) {
          	$lv_ret=   array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt,'sqlsmt'=> $lo_evlmdl->getsysdata('sqlstm')); // acá esta el erroro  
          }
					
				}        
				return $this->co_reg->document->getJson($lv_ret);
				break;
    }
  }
  private function validateFileSize($lv_docsts) {
    if ( $lv_docsts!='A' || empty($this->co_reg->request->files) ) {
        return null;
    }
    $lv_total_size = 0;
    $lv_max_total_size = 25165824;
    foreach ( $this->co_reg->request->files as $lv_file_field ) {
        $lv_sizes = isset($lv_file_field['size']) ? (is_array($lv_file_field['size']) ? $lv_file_field['size'] : array($lv_file_field['size'])) : array();
        $lv_errors = isset($lv_file_field['error']) ? (is_array($lv_file_field['error']) ? $lv_file_field['error'] : array($lv_file_field['error'])) : array();
        for ( $i=0; $i<count($lv_sizes); $i++ ) {
            if ( $lv_errors[$i]==UPLOAD_ERR_INI_SIZE || $lv_errors[$i]==UPLOAD_ERR_FORM_SIZE ) {
                return array('errtyp'=>'E','errcod'=>'-20','errtxt'=>'El archivo adjunto supera el tamaño máximo permitido de 20MB.');
            }
            $lv_total_size += $lv_sizes[$i];
        }
    }
    if ( $lv_total_size > $lv_max_total_size ) {
        return array('errtyp'=>'E','errcod'=>'-21','errtxt'=>'El total de archivos adjuntos supera el tamaño máximo permitido de 24MB.');
    }
    return null;
	}
  
  public function sendMailFarma($lpData){
    $lpData['evlcod']=$lpData['evlcod']??'ERR'; 
    $lpData['cuscod']=$lpData['cuscod']??'';
    $lpData['patcod']=$lpData['patcod']??'';
    $lpData['pattxt']=$lpData['pattxt']??'';
    $lpData['spccod']=$lpData['spccod']??'';
    $lpData['spctxt']=$lpData['spctxt']??'';
    $lpData['evlcmt']=$lpData['evlcmt']??'';
    /*
    // Busco el Texto del mensage
    $lo_txtmdl = $this->co_reg->load->model('grldattxt');
    $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                  '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                  '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                  '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                    'vewmaxrec'=>'1');
    $lo_rs = $lo_txtmdl->getList($lv_prm);
    if( count($lo_rs)!=0 ) {
      $lv_usrmsg = $lo_rs[0]['txttxt'];
    } else {
      $lv_usrmsg = '';
      $lv_errcod = '-1';
      $lv_errtxt = 'No se encontró el texto del mensaje.';
    } 
    */
    // obtengo mensaje de notificacion
    $lv_txtcodext = 'HLTEVLGRL';
    $lo_txtmdl = $this->co_reg->load->model('grldattxt');

    if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
      $lv_usrmsg = $lo_txtmdl->txttxt;
    } else {
      $lv_usrmsg = '';
      $lv_errcod = '-1';
      $lv_errtxt = 'No se encontró el texto del mensaje.';
    }
    
    // determino destinatarios
    $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
    if ( $lo_appprmmdl->load(array('mdlcod'=>'CNFEMLFMV')) == false ) {
      $lv_buffer = '-100: NO EXISTE PARAMETRO DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
      return $lv_buffer;
    }

    $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,$lpData['cuscod']);	// MAILS
    if($lv_sndeml==''){
      $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'*');	// MAILS
    }
    $lv_mailtoarr = explode(';',$lv_sndeml);
    foreach( $lv_mailtoarr as $lv_val) {
      $lv_mailto[] = array('address'=>$lv_val);
    }
    // envío mail
    if ( $lv_usrmsg!='') {
      $lo_eml = new tmssMail();
      $lv_emlprm= array();
      $lv_emlprm['to'] = $lv_mailto;
      $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'LSDM') );
      $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
      $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
      $lv_usrmsg = str_replace( '[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia' , $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lpData['patcod'] . ' ) <strong>'.   utf8_decode($lpData['pattxt']). '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Financiador : ( #'. $lpData['cuscod'] . ' ) <strong>'.   utf8_decode($lpData['custxt']). '</strong><br/>[%3]', $lv_usrmsg);			  
      $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lpData['evlcod'] . ' ) <strong>'. $lpData['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lpData['prscod'] . ' ) <strong>'.   utf8_decode($lpData['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lpData['spccod'] . ' ) <strong>'.   utf8_decode($lpData['spctxt']) .'</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Comentarios:<br/>'.utf8_decode($lpData['evlcmt']).'<br/>', $lv_usrmsg);
      $lv_emlprm['bodyhtml'] = $lv_usrmsg;
      if ( $lo_eml->send( $lv_emlprm ) ) {
        $lv_errcod = '';
        $lv_errtxt = '';
      } else {
        $lv_errcod = '-1';
        $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
        return array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt);
      }
    }    
  }

   private function ctectr($lp_prm=array() ){
    //array('evldte'=>'','spccod'=>'','patcod'=>'','prscod'=>'','plnid'=>'','plndteid'=>'')
    $lo_ctrmdl = $this->co_reg->load->model('hltplnctr');
    $lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 
    $lv_ret = array('errcod'=>'0','errtxt'=>'','errtyp'=>'','errdata'=>'');
     // Cargamos el control de prestacion
    $lv_key['plnid'] = $lp_prm['plnid'];
    $lv_key['plndteid'] = $lp_prm['plndteid'];
    $lo_ctrdte_rs = $lo_ctrdtemdl->load($lv_key);
    if(count($lo_ctrdte_rs)>0){
      $lv_ret['errcod']='';
      $lv_ret['errtxt']='';
      $lv_ret['errtyp']='';
    	 return $lv_ret;
    }
    
    //CONTROL DE PRESTACION
    $lo_plnctrprm=array();
    $lo_plnctrprm['plnyth'] =substr($lp_prm['evldte'],6,4);
    $lo_plnctrprm['plnmth']= substr($lp_prm['evldte'],3,2);
    $lo_plnctrprm['spccod'] = $lp_prm['spccod'];
    $lo_plnctrprm['patcod'] = $lp_prm['patcod'];
    $lo_plnctrprm['prscod'] = $lp_prm['prscod'];
    $lo_plnctrprm['docsts'] = 'A'; 
    // CONTROL DE PRESTACION - cabecera
    if($lo_ctrmdl->save($lo_plnctrprm)==false){
      $lv_ret['errcod']=$lo_ctrmdl->errcod;
      $lv_ret['errtxt']=$lo_ctrmdl->errtxt;
      $lv_ret['errtyp']=$lo_ctrmdl->errtyp;
      return $lv_ret;
    }else{
      $lv_plndteprm = array();
      $lv_plndteprm['hltplnctrcod'] = $lo_ctrmdl->hltplnctrcod;
      $lv_plndteprm['plnid'] = $lp_prm['plnid'];
      $lv_plndteprm['plndteid'] = $lp_prm['plndteid'];
      $lv_plndteprm['hltplnctrdte'] = $lp_prm['evldte'];
      $lv_plndteprm['hltplnctrinbdte'] = '00:00';
      $lv_plndteprm['hltplnctroutdte'] = '00:00';
      $lv_plndteprm['hltplnctrqty'] = '1';
      $lv_plndteprm['hltplnctrtme'] = '24:00';
      $lv_plndteprm['spccod'] = $lp_prm['spccod'];
      $lv_plndteprm['prscod'] = $lp_prm['prscod'];
      $lv_plndteprm['hltplnctrcmt'] = 'Evolucion';
      $lv_plndteprm['docsts'] = 'A';
      // CONTROL DE PRESTACION - fechas
      if($lo_ctrdtemdl->save($lv_plndteprm)==false){
        $lv_ret['errcod']=$lo_plnctrdtemdl->errcod;
        $lv_ret['errtxt']=$lo_plnctrdtemdl->errtxt;
        $lv_ret['errtyp']=$lo_plnctrdtemdl->errtyp;
        return $lv_ret;
      }
    }
    
    return $lv_ret;
  }
	private function delctr($lp_prm=array() ){
  	$lv_plnmdl = $this->co_reg->load->model('hltpln');
    $lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
    $lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
    $lv_ret = array('errcod'=>'0','errtxt'=>'','errtyp'=>'','errdata'=>'');
    $lv_key = array();
    $lv_key['plnid'] = $lp_prm['plnid'];
    $lv_key['plndteid'] = $lp_prm['plndteid'];
    /* Cargamos la fecha de planificacion */   
    //if ($lo_plndtemdl->load($lv_key)==false) {
    //  $lv_ret['errcod']=$lv_ctrdtemdl->errcod;
    //  $lv_ret['errcod']=$lv_ctrdtemdl->errtxt;
    //  return $lv_ret;
    //}
    
    // Cargamos el control de prestacion
    $lo_ctrdte_rs = $lo_ctrdtemdl->load($lv_key);  
    //var_dump($lo_ctrdte_rs);
    if(count($lo_ctrdte_rs)>0){
      //  BORRAMOS EL CONTROL
      $lv_key['hltplnctrcod'] = $lo_ctrdte_rs[0]['hltplnctrcod'];
      $lv_key['hltplnctrdtecod'] =$lo_ctrdte_rs[0]['hltplnctrdtecod'];
      $lo_ctrdtemdl->delete($lv_key);
    }       
    return $lv_ret;
  }

	
	
  private function ShowDashBoard($lp_prm = array() ){

  	$lo_vew = $this->co_reg->load->model('grlvew');
		$lo_patmdl = $this->co_reg->load->model('hltpat');
		$lo_adrmdl = $this->co_reg->load->model('grldatadr');
		$lo_regmdl = $this->co_reg->load->model('grladrlndreg');
		$lo_spcmdl = $this->co_reg->load->model('hltspc');
		$lo_plnmdl = $this->co_reg->load->model('hltplndte');
		$lo_dismdl = $this->co_reg->load->model('hltdiscls');
		$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');

  	$lv_prm = array();
  	$lo_data= array();
		
  	/*CONTROL DE PARAMETROS DE ENTRADA*/
  	$lo_data['selyth']=$lp_prm['selyth'];
  	$lo_data['ttlevltxt']=$lp_prm['ttlevltxt'];;
  	$lo_data['ttlbarra2']=$lp_prm['ttlbarra2'];;
  	$lo_data['ttldsh']=$lp_prm['ttldsh'];;

  	/*Clasificacion de enfermedades*/
		$lo_rs_discls = $lo_dismdl->getList();
		$lv_discls=array();
		foreach($lo_rs_discls as $lv_row_cls){
			$lv_discls[$lv_row_cls['hltdisclscodext']]=$lv_row_cls['hltdisclscod'];
		}

		/*Especialidades */
		$lo_rs_spc = $lo_spcmdl->getList();
		$lv_spc=array();
		foreach($lo_rs_spc as $lv_row_spc){
			$lv_spc[$lv_row_spc['spccodext']]=$lv_row_spc['spccod'];
		}

  	/*PACIENTES*/
  	$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
		$lo_rs_pat = $lo_patmdl->getList($lv_prm, null, $lo_vew, false);	
		$lo_data['data_sqlstm']['pat']=$lo_patmdl->getsysdata('sqlstm');
		$lo_data['patqty']=0;
		$lv_patflt ='';
		foreach ($lo_rs_pat as $lv_row) {
			 if($lv_row['hltdisclscod']==$lv_discls[$lp_prm['hltdisclscod']]){
			 	$lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['patcod'];
				$lo_data['patqty']++;
			 }
		}

		/*DIRECCIONES*/
		$lv_prm = array();
		$lv_prm = array('vewfldflt' =>'[~fltrow~]a.AdrSrcCod'.chr(9).'IN'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																	'[~fltrow~]a.AdrSrcTyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																	'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
		$lo_rs_adr = $lo_adrmdl->getList($lv_prm);
		$lo_data['data_sqlstm']['adr']=$lo_adrmdl->getsysdata('sqlstm');
		$lv_retReg= array();
		foreach ($lo_rs_adr as $lo_row) {
			if (!isset($lv_retReg[$lo_row['lndregtxt']])){
				$lv_retReg[$lo_row['lndregtxt']]=0;
			}
			$lv_retReg[$lo_row['lndregtxt']]++;
		}

		/* EVOLUCIONES */
		$lo_data['evllst']= array('01'=>0,'02'=>0,'03'=>0,'04'=>0,'05'=>0,'06'=>0,'07'=>0,'08'=>0,'09'=>0,'10'=>0,'11'=>0,'12'=>0,);

		$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lp_prm['dtefrm']->format('Ymd').chr(9).$lp_prm['dteto']->format('Ymd').chr(9).
																	'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9). $lv_spc[$lp_prm['spcextcod']]   .chr(9).chr(9).
																	'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));

		$lo_rs_evl = $lo_patevlmdl->getList($lv_prm, null, null, false);
		$lo_data['data_sqlstm']['evl']=$lo_patevlmdl->getsysdata('sqlstm');
		$lo_data['evlqty']=0;
		foreach ($lo_rs_evl as $lo_row) {
			$lo_data['evllst'][$lo_row['evldte']->format('m')]++;
			$lo_data['evlqty']++;
		}

		// PLANIFICACIONES
		$lo_data['plnlst']= array('01'=>0,'02'=>0,'03'=>0,'04'=>0,'05'=>0,'06'=>0,'07'=>0,'08'=>0,'09'=>0,'10'=>0,'11'=>0,'12'=>0,);

		$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lp_prm['dtefrm']->format('Ymd').chr(9).$lp_prm['dteto']->format('Ymd').chr(9).
																	'[~fltrow~]pl.spccod'.chr(9).'='.chr(9).chr(9). $lv_spc[$lp_prm['spcextcod']]   .chr(9).chr(9));
		$lo_rs_pln = $lo_plnmdl->getList($lv_prm, null, null, false);
		$lo_data['data_sqlstm']['PLN']=$lo_plnmdl->getsysdata('sqlstm');
		foreach ($lo_rs_pln as $lo_row) {
			$lo_data['plnlst'][$lo_row['plndte']->format('m')]++;
		}
		$lo_data['lndreg']=$lv_retReg;
		
		$this->lo_mdl = $lo_data;
		return $this->getView( 'zcutp1_tindis' );
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
    //$lv_ret= $lv_flddeflst;
    //return $lv_ret;
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
	/**
	 * getView
	 * send screen to client browser
	 */
	private function getView( $lp_vew='', $lp_dat=array() ) {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' => $this->co_reg->sec,
										'doc'		=> $this->co_reg->document,
										'data' => $this->lo_mdl,
										'actcod' => $this->data['actcod']
										);
		if(count($lp_dat)>0){ $lv_prm = array_merge($lv_prm,$lp_dat); }
		$lv_ret = $this->co_reg->load->view( ($lp_vew!=''?$lp_vew: self::VIEW ), $lv_prm );
		return $lv_ret;
	}
  
  
  private function getTmssContact($lp_prm){
  	$lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
    $lo_pryctr = $this->co_reg->load->controller('sysapppry');
    $lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
    if($lv_issisdev === false){
      $lp_prm['apires'] = 'logindoor/general-contacts/search?source_type=SLS_CUS&code=LIKE$'.$lp_prm['data']['PST']['code'];
    }else{
      $lp_prm['apires'] = 'dev_logistica/general-contacts/search?source_type=SLS_CUS&code=LIKE$'.$lp_prm['data']['PST']['code'];
    }
    
		$lv_ret = $lo_pryctr->callRemoteApi($lp_prm);
    return $lv_ret;
    
  }
  private function saveTmssContact2($lp_prm =array()){
    $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
    $lo_pryctr = $this->co_reg->load->controller('sysapppry');
    $lp_prm['apires'] = 'logindoor/general-contacts/'. $lp_prm['grlcntcod'];
		$lv_ret = $lo_pryctr->callRemoteApi($lp_prm);
    return $lv_ret;
  }
  
  private function saveTmssContact($lp_prm =array()){
    $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
    $lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
    if($lv_issisdev === false){
      $lv_baseurl='https://customers.gorse.ar/api.gorse.php/logindoor/general-contacts/'.$lp_prm['grlcntcod']; 	
    }else{
      $lv_baseurl='https://developers.gorse.ar/api.gorse.php/dev_logistica/general-contacts/'.$lp_prm['grlcntcod'];
    }
    $curl = curl_init($lv_baseurl);
    
    $lv_jsonpost= json_encode($lp_prm['data']['PST']);
		curl_setopt_array($curl, array(	CURLOPT_URL => $lv_baseurl,//'https://temasis.com.ar/sysdev/tmssOnLine/api.gorse.php/dev_logistica/general-contacts/'.$lp_prm['grlcntcod'],
                                CURLOPT_RETURNTRANSFER => true,
                                CURLOPT_ENCODING => '',
                                CURLOPT_MAXREDIRS => 10,
                                CURLOPT_TIMEOUT => 0,
                                CURLOPT_FOLLOWLOCATION => true,
                                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                                CURLOPT_SSL_VERIFYHOST=>0,
                                CURLOPT_SSL_VERIFYPEER=>0,
                                CURLOPT_CUSTOMREQUEST => 'POST',
                                CURLOPT_POSTFIELDS =>$lv_jsonpost,
                                CURLOPT_HTTPHEADER => array(
                                                            'Content-Type: application/json',
                                                            'crossDomain: true',
                                                            'proyect-token: '.$lp_prm['prytkn'],
                                                            'user-token: '.$lp_prm['usrtkn'],
                                                          ),
                            ));
    if( ! $lo_rs = curl_exec($curl)){
      trigger_error(curl_error($curl));
    }
                 
    $statusCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    // Manejar la respuesta de cURL
    if ($statusCode == 200) {
      $lv_ret['errtyp']='S';
      $lv_ret['errcod']= ''; 
      $lv_ret['errtxt']=  '';
    	$lv_ret['data'] =$lo_rs;
    }else{
      $lv_ret['errtyp']='E';
      $lv_ret['errcod']= $statusCode; 
      $lv_ret['errtxt']=  'Server Response:'. $statusCode;
      $lv_ret['data']=[];
    }
    curl_close($curl);
    return $lv_ret;
  }
  
  
  private function getTmssApiToken($lp_prm=array()){
    $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');

    // obtengo token de sesion de usuario Nuevo
    $lo_pryctr = $this->co_reg->load->controller('sysapppry');

    $lp_prm['usrcod']=$lp_prm['usrcod'];//;'teste';
    $lp_prm['usrpwd']=$lp_prm['usrpwd'];//'T3S7@123';
    $lv_ret = $lo_pryctr->callRemoteApi( $lp_prm );
    if($lv_ret['errtyp']=='S'){ $lp_prm['user-token'] = $lv_ret['token']; } else { return $this->co_reg->document->getJson($lv_ret); }
    
    $lv_ret['data']=$lp_prm;
    return $lv_ret;
  }
  
  //Decripcion:Trae los motivos de no ejecucion de un estudio,infucion, etc
  //Parametros
  // prmmdl: Modelo del parametro de empresa en dode se buscara la informacion
  // mdlcod: Codigo del parametro de empresa en el que se buscara la informacion, esta parametro se usa para instanciar el modulo en caso de no especificarlo en prmmdl
  // prmkey: Clave del parametro que se decea buscar si no se especifica se retornan los que enpuezan con el string CUS_
  private function getServiceNonExecutionReasons($lp_prm=array()){
    $lp_prm['prmkey']=strtoupper($lp_prm['prmkey']??'');
    //var_dump($lp_prm['prmkey']);
    if(!isset($lp_prm['prmmdl'])){
      $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
      if(!$lo_prmmdl->load(array('mdlcod'=>$lp_prm['mdlcod']))){
        return array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt);
      }
    }else{
      $lo_prmmdl=$lp_prm['prmmdl'];
    }
    
    $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
    $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
    $lv_dat = simplexml_load_string($lv_atrusr);
    $lv_evlcncmtv = [];
    foreach($lv_dat as $lv_key=>$lv_val){
      if( $lp_prm['prmkey']!='' && strtoupper($lv_key) !=strtoupper($lp_prm['prmkey']) ){ continue; }
      if($lp_prm['prmkey']=='' && !str_contains($lv_key,'CUS_') && strtoupper($lv_key) !='ALL'){ continue; }
      $lv_key= str_replace("CUS_", "", $lv_key);
      $lv_cncmtvrow = explode(";", $lv_val);
      $lv_evlcncmtv[$lv_key]=[];
      
      foreach($lv_cncmtvrow as $lv_rowmtv){
        $lv_a = explode(",", $lv_rowmtv);
        if(count($lv_a)==1){
          $lv_evlcncmtv[$lv_key]=$lv_rowmtv;
        }else{
        	$lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
        }
      }
    }
    return $lp_prm['prmkey']!=''?$lv_evlcncmtv[$lp_prm['prmkey']]:$lv_evlcncmtv;
  }
}
?>
