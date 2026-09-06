<?php
final class zcutmsController extends tmssController {
	const MODEL = 'zcutms';
	const VIEW  = 'zcutms';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {
    //header('Access-Control-Allow-Origin: https://temasis.ar');	//IMPORTANTE: PERMITE CONEXIÓN CON EL SERVIDOR TEMASIS.AR
    
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;

    switch( $lp_act ) {
			
			
			// ----------------------------------------------------------------------
			//
			//    F O R M U L A S
			//
			// ----------------------------------------------------------------------
			
			
			
			
			
			//    S U E L D O    B A S I C O
			//    calcula el proporcional del sueldo basico segun la fecha de ingreso/egreso
			case '#forSUELDOBASICO':
				$lo_ret = array();
				$lv_dif = 0;
				$lv_period = 30;	// constante que indica el período liquidado
				
				// convierto las fechas
				$lv_strdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdstrdte'] );
				$lv_enddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdenddte'] );
				$lv_chrstrdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdtestr'] );

				// si tiene fecha de ingreso mayor al inicio del periodo liquidado y toma el proporcional
				if( intval(date_format($lv_strdte,'Ym'))==intval(date_format($lv_chrstrdte,'Ym')) ){
					if( intval(date_format($lv_strdte,'d'))<intval(date_format($lv_chrstrdte,'d')) ){
						//$lv_dif += intval(date_format($lv_enddte,'d'))-intval(date_format($lv_chrstrdte,'d'));
						$lv_dif = date_diff( $lv_enddte, $lv_chrstrdte )->days + 1;
						//$lv_dif = 1;
					}
				}				
				
				// si tiene fecha de egreso menor al fin del periodo liquidado se toma el proporcional				
				if($lp_prm['dochdr']['hhrchrasgdteend']!=''){
					$lv_chrenddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdteend'] );
					if( intval(date_format($lv_enddte,'Ym'))==intval(date_format($lv_chrenddte,'Ym')) ){
						if( intval(date_format($lv_enddte,'d'))>intval(date_format($lv_chrenddte,'d')) ){
							$lv_dif += intval(date_format($lv_chrenddte,'d'))-intval(date_format($lv_strdte,'d'));
							$lv_dif = date_diff( $lv_strdte, $lv_chrenddte )->days + 1;
						//$lv_dif = 2;
						}
					}
				}
				
				if($lv_dif!=0){
					//$lo_ret['prccndval'] = $lv_prccndval
					$lo_ret['prccndqty'] = $lv_dif;
					$lo_ret['prccndtot'] = floatval($lp_prm['docprc']['prccndval']) / $lv_period * $lv_dif;
				}
				return $this->co_reg->document->getJson( $lo_ret );
				break;
			
			
      
			//    R E D O N D E O
			//    redondea en funcion de los totales para que de sin decimales
			case '#forRND':
				$lo_ret = array();
				$lv_tot = floatval($lp_prm['docprc']['prccndval']);
				foreach($lp_prm['docsch'] as $lv_row){
					$lv_row['prccndtxt'] = strtoupper(trim($lv_row['prccndtxt']??''));
					if($lv_row['prccndtxt']=='TOTAL REMUNERATIVO' || $lv_row['prccndtxt']=='TOTAL DESCUENTOS' || $lv_row['prccndtxt']=='TOTAL NO REMUNERATIVO'){
						$lv_tot+= $lv_row['prccndtot'] * ($lv_row['prccndtxt']=='TOTAL DESCUENTOS'?-1:1);
					}
				}
				if( ceil($lv_tot)!=$lv_tot ){
					$lo_ret['prccndval'] = $lv_tot;
					$lo_ret['prccndtot'] = ceil($lv_tot) - $lv_tot;
				}
        return $this->co_reg->document->getJson( $lo_ret );
				break;
			
			
			
			//    S A C
			//    calcula el SAC o el SAC proporcional por despido/renuncia
			case '#forSAC':
				$lo_ret = array();

				$lv_prccndqty = floatval($lp_prm['docprc']['prccndqty']);				
				$lv_strdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdstrdte'] );
				$lv_enddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdenddte'] );
				$lv_strsem = '01/' . (intval(date_format($lv_enddte,'m'))<=6?'01':'07').'/'.date_format($lv_enddte,'Y');
				$lv_endsem = (intval(date_format($lv_enddte,'m'))<=6 ? '30/06':'31/12').'/'.date_format($lv_enddte,'Y');
				$lv_daysem = date_diff( date_create_from_format('d/m/Y',$lv_strsem), date_create_from_format('d/m/Y',$lv_endsem) );
				$lv_chrstrdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdtestr'] );
				$lv_chrenddte = null;
				$lv_mth = 12 * $lv_prccndqty / 100;

				// si se cargo el 50% del SAC se calculan en general los 6 meses ( 12 * 50% / 100 = 6 )
				// si no se cargo y es una liquidacion final (por despido/renuncia), tambien se calcula
				if( $lv_prccndqty==0 && $lp_prm['dochdr']['hhrchrasgdteend']!='' ){
					$lv_prccndqty=50;
					$lv_chrenddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdteend'] );
				}
				
				// se activa si la cantidad (50%) se fijo por registro de condición cada 6 meses
				if( $lv_prccndqty!=0 ) {
					// obtengo las liquidaciones de los últimos 6 meses
					$lo_lqdmdl = $this->co_reg->load->model('hhrlqd');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'HHR_EMP' .chr(9).chr(9).
																				'[~fltrow~]l.srcobjcod'.chr(9).'='.chr(9).chr(9). $lp_prm['dochdr']['srcobjcod'] .chr(9).chr(9).
																				($lp_prm['dochdr']['hhrlqdcod']!=''?'[~fltrow~]l.hhrlqdcod'.chr(9).'<>'.chr(9).chr(9). $lp_prm['dochdr']['hhrlqdcod'] .chr(9).chr(9):'').
																				'[~fltrow~]l.hhrlqdstrdte >= dateadd(MONTH, -'.$lv_mth.', ^'. $lv_strdte->format('Y-m-d').'^)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
													);
					$lo_lqdrs = $lo_lqdmdl->getList( $lv_prm,false );
					
					// armo array de IDs de liquidaciones
					$lv_lqdids='';
					foreach($lo_lqdrs as $lv_row){ 
						if(stripos(';'.$lv_lqdids.';',';'.$lv_row['hhrlqdcod'].';')===false){ 
							$lv_lqdids.=($lv_lqdids==''?'':';').$lv_row['hhrlqdcod']; 
						} 
					}
					
					// para las liquidaciones obtengo el TOTAL remunerativo
					$lo_prcmdl = $this->co_reg->load->model('grldatprc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'HHR_LQD' .chr(9).chr(9).
																				'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). str_ireplace(';',chr(10),$lv_lqdids) .chr(9).chr(9).
																				'[~fltrow~]p.prccndtxt'.chr(9).'='.chr(9).chr(9). 'TOTAL REMUNERATIVO' .chr(9).chr(9)
													);
					$lo_prcrs = $lo_prcmdl->getList( $lv_prm );
					
					// para las liquidaciones obtengo el SAC (para descontarlo del total remunerativo)
					$lo_prcmdl = $this->co_reg->load->model('grldatprc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'HHR_LQD' .chr(9).chr(9).
																				'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). str_ireplace(';',chr(10),$lv_lqdids) .chr(9).chr(9).
																				'[~fltrow~]p.prccndtxt'.chr(9).'='.chr(9).chr(9). 'SAC' .chr(9).chr(9)
													);
					$lo_sacrs = $lo_prcmdl->getList( $lv_prm );
          
					// obtengo la mayor remuneracion de la persona
					$lv_maxrem=$lp_prm['docprc']['prccndval'];
					foreach($lo_prcrs as $lv_row){
            $lv_tot = $lv_row['prccndtot'];
            foreach($lo_sacrs as $lv_sacrow){
              if( $lv_sacrow['srcobjcod001']==$lv_row['srcobjcod001'] ){ $lv_tot = $lv_tot - $lv_sacrow['prccndtot']; break; }
            }
						if($lv_tot>$lv_maxrem){ $lv_maxrem = $lv_tot; }
					}

					// determino proporcional de dias para SAC
					
					// ingreso año anterior Y sin egreso o egreso mismo año fecha inicio 01.01 ó 01.07
					// diferencia entre inicio de cargo y fecha de fin de liquidacion o fin de cargo
					$lv_difstr = date_diff($lv_chrstrdte, ($lv_chrenddte==null?$lv_enddte:$lv_chrenddte) );
					$lv_difday = 0;
					$lv_same_year = date_format($lv_strdte,'y')==date_format($lv_chrstrdte,'y');
					
					// si el ignreso fue el año pasado Y no tiene fecha egreso
					if( !$lv_same_year && $lv_chrenddte==null ) {
						$lv_dif = date_diff( date_create_from_format('d/m/Y',$lv_strsem) , $lv_enddte );
						$lv_difday = $lv_dif->days+1;
					
					// si el ingreso fue el año pasado Y tiene egreso
					// determino la cantidad de días desde el inicio del semestre hasta la fecha de egreso
					} else if( !$lv_same_year && $lv_chrenddte!=null ) {
						$lv_dif = date_diff( date_create_from_format('d/m/Y',$lv_strsem) , $lv_chrenddte );
						$lv_difday = $lv_dif->days+1; //($lv_dif->m * 30) + $lv_dif->d;
						
					// si ingreso este año y no tiene egreso
					// calculo proporcional desde ingreso hasta final de liquidacion
					// si es mas de 6 meses se toman 180 días para el SAC
					} else if( $lv_same_year && $lv_chrenddte==null ) {
						if( intval(date_diff( $lv_chrstrdte, $lv_enddte )->format('%m'))>=6 ){
							$lv_dif = date_diff( date_create_from_format('d/m/Y',$lv_strsem) , $lv_enddte );
						} else {
							$lv_dif = date_diff( $lv_chrstrdte, $lv_enddte );
						}
						$lv_difday = $lv_dif->days+1;
					
					// si ingreso este año y egreso este año
					// calculo proporcional desde ingreso hasta egreso
					} else if( $lv_same_year && $lv_chrenddte!=null ) {
						// si entro iniciado el semestre, calculo desde el inicio del cargo
						if( date_format($lv_chrstrdte,'m')>date_format( date_create_from_format('d/m/Y',$lv_strsem) ,'m') ){
							$lv_dif = date_diff( $lv_chrstrdte, $lv_chrenddte );
						// si entro antes de iniciado el semestre, calculo desde el inicio del semestre
						} else {
							$lv_dif = date_diff( date_create_from_format('d/m/Y',$lv_strsem) , $lv_chrenddte );
						}
						$lv_difday = $lv_dif->days+1; //($lv_dif->m * 30) + $lv_dif->d;

					}
					
					// obtengo remuneración actual (sueldo basico)
					$lv_prccndval = 0;
					foreach($lp_prm['docsch'] as $lv_row){
						if( $lv_row['prccndrow'] = '10') { $lv_prccndval=$lv_row['prccndval']; break;}
					}
					if($lv_prccndval>$lv_maxrem){ $lv_maxrem = $lv_prccndval; }
					
					// sueldo * 0,5 / 180 * dias trabajados (en multiplos de 30 si es mes completo)
					$lv_prccndtot = $lv_maxrem * ($lv_prccndqty/100) / ($lv_daysem->days+1) * $lv_difday;
					if($lv_maxrem!=0){
						$lo_ret['prccndval'] = $lv_maxrem;
						$lo_ret['prccndqty'] = $lv_difday; // $lv_prccndqty;
						$lo_ret['prccnduntcod'] = 'UN'; // '%';
						$lo_ret['prccndcurcod'] = 'ARS';
						$lo_ret['prccndtot'] = $lv_prccndtot;
					}
				}

        return $this->co_reg->document->getJson( $lo_ret );
				break;
			
			
			
			//    I N D E M N I Z A C I O N
			//    calcula el monto de indemnización si el motivo fue despido
			case '#forINDEMNIZACION':
				$lo_ret = array();
				$lv_dif = 0;
				$lv_difyth=0;
				
				// convierto las fechas
				$lv_strdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdstrdte'] );
				$lv_enddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrlqdenddte'] );
				$lv_chrstrdte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdtestr'] );
				if($lp_prm['dochdr']['hhrchrasgdteend']!=''){
					$lv_chrenddte = date_create_from_format( 'd/m/Y', $lp_prm['dochdr']['hhrchrasgdteend'] );				
					// si tiene fecha de egreso menor al fin del periodo liquidado se toma el proporcional				
					if( intval(date_format($lv_enddte,'Ym'))==intval(date_format($lv_chrenddte,'Ym')) ){
						// determinar si es por DESPIDO
						if($lp_prm['docpos']['hhrchrasg']['hhroutrsncodext']=='DESPIDO'){			
							if(date_format($lv_chrenddte,'Y')!=intval(date_format($lv_chrstrdte,'Y'))){
								$lv_dif = (intval(date_format($lv_chrenddte,'Y'))-intval(date_format($lv_chrstrdte,'Y'))-1)*12;
							}
							$lv_dif += (intval(date_format($lv_chrstrdte,'m'))<intval(date_format($lv_chrenddte,'m')) 
														? intval(date_format($lv_chrenddte,'m'))-intval(date_format($lv_chrstrdte,'m')) 
														: 12-intval(date_format($lv_chrstrdte,'m'))+intval(date_format($lv_chrenddte,'m'))
													);
							// calcular 1 UN x cada año trabajado, siendo que a partir del 3er mes se considera 1 año mas
							$lv_difyth = (int)($lv_dif/12) + ($lv_dif % 12 >= 3 ? 1 : 0) + 1;
						}
					}
				}
				if($lv_difyth!=0){
					//$lo_ret['prccndval'] = 
					$lo_ret['prccndqty'] = $lv_difyth;
					//$lo_ret['prccndtot'] = ;
				}
				return $this->co_reg->document->getJson( $lo_ret );
				break;
			
			
			
			
			
			// ----------------------------------------------------------------------
			//
			//    I M P R E S I O N E S
			//
			// ----------------------------------------------------------------------
			
			
			
			
			
			//    F A C T U R A
			//    impresion del fromulario de factura/nota de credito/nota de debito
			case '#slsinvpnt':
				$lo_post = $this->co_reg->request->post;
				$lv_slsinvcod = ($lo_post['slsinvcod']??$lp_prm['slsinvcod']);
				
				// FACTURA. cargo datos de factura
				$lo_invmdl = $this->co_reg->load->model('slsinv');
				$lo_invmdl->load( array('slsinvcod'=>$lv_slsinvcod), false );
				
				// CHECK
				if( $lo_invmdl->docsts!='C' ){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'El documento debe estar contabilizado.') );
				}

				// EMPRESA. cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );

				// FACTURA ELECTRONICA. cargo datos de factura electronica (puede no tener si es interna)
				$lo_fcemdl = $this->co_reg->load->model('slsinvfce');
				$lo_fcemdl->load( array('slsinvcod'=>$lv_slsinvcod) );
				
				// CLIENTE. contactos del cliente - cuenta pagadora
				$lo_cusmdl = $this->co_reg->load->model('slscus');
				$lo_cntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjtyp .chr(9).chr(9).
																			'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjcod .chr(9).chr(9).
																			'[~fltrow~]dbo.getTagValue(^invadr^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9). 'X' .chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_cntmdl->getList($lv_prm,null,null,false);
				if(count($lo_rs)>0){
					if( $lo_rs[0]['cntdsttyp']=='SLS_CUS' ) {
						$lo_cusmdl->load( array('cuscod'=>$lo_rs[0]['cntdstcod']), false );
						$lo_cusmdl2 = $lo_cusmdl;
					} else {
						$lo_cntmdl->load( array('cntcod'=>$lo_rs[0]['cntcod']), false );
						$lo_cntmdl->custxt = $lo_cntmdl->cnttxt;
						$lo_cusmdl2 = $lo_cntmdl;
					}
				} else {
					$lo_cusmdl->load( array('cuscod'=>$lo_invmdl->dstobjcod), false );
					$lo_cusmdl2 = $lo_cusmdl;
				}
				
				// LOCALIZACION ARGENTINA. cargo datos de localizacion Argentina
				$lo_posmdl = $this->co_reg->load->model('finlocargpos');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsposcod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->slsposcod .chr(9).chr(9).
																			'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->sysdocclscod .chr(9).chr(9).
																			'[~fltrow~]p.argltrcodext'.chr(9).'='.chr(9).chr(9).$this->co_reg->document->getTagValue($lo_fcemdl->slsinvfceatr,'argltrcodext') .chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_posmdl->getList($lv_prm, null, null, false);
				if(count($lo_rs)>0){
					$lo_posmdl->load( array('argposcod'=>$lo_rs[0]['argposcod']), false);
				}				
				
				$lv_buffer = 	$this->co_reg->document->getView('zcutms_slsinvpnt', array('bus'=>$lo_busmdl,'cus'=>$lo_cusmdl2,'inv'=>$lo_invmdl,'fce'=>$lo_fcemdl,'pos'=>$lo_posmdl,'actcod'=>$this->data['actcod'],'getbuffer'=>($lv_prm['getbuffer']??'')) );
				if( ($lv_prm['getbuffer']??'')=='') { $this->co_reg->response->addHeader('Content-type:application/pdf'); }
				return $lv_buffer;
				break;
			
			
			
			//    R E C I B O    D E    S U E L D O
			//		impresion del recibo de sueldos
			case '#hhrlqdrecpnt':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lv_hhrlqdcod = ($lo_post['hhrlqdcod']??$lp_prm['hhrlqdcod']);
				
				// RECIBO. cargo datos de la liquidación
				$lo_recmdl = $this->co_reg->load->model('hhrlqd');
				if( !$lo_recmdl->load( array('hhrlqdcod'=>$lv_hhrlqdcod),false ) ){
					$lv_ret['errtyp']='E';
					$lv_ret['errcod']=-1;
					$lv_ret['errtxt']='El documento ['.$lv_hhrlqdcod.'] no existe.';
					return $this->co_reg->document->getJson( $lv_ret );
				}

				// EMPRESA. cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$lo_recmdl->bus = $lo_busmdl;
				
				// EMPRESA LOGO. recupero el logo de la empresa
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				if( $lo_flemdl->getMainPhoto( array('flesrctyp'=>'ADM_BUS','flesrccod'=>$this->co_reg->sec->buscod)) ){
					$lo_rs = $lo_flemdl->getData();
					$lo_recmdl->bus->busimgtyp = $lo_rs[0]['fletyp'];
					$lo_recmdl->bus->busimg = $lo_flemdl->getFileContents( array('flecod'=>$lo_rs[0]['flecod']) );
				}				
				
				// ASIGNACION CARGO. cargo los datos de la asignación del cargo
				$lo_chamdl = $this->co_reg->load->model('hhrchrasg');
				$lo_chamdl->load( array('hhrchrasgcod'=>$lo_recmdl->hhrchrasgcod), false );
				$lo_chamdl->hhrchrasginbdte = $lo_chamdl->hhrchrasgdtestr;
				$lo_chamdl->hhrchrasgoutdte = $lo_chamdl->hhrchrasgdteend;
				$lo_recmdl->chrasg = $lo_chamdl;
				
				// TEXTO. cargo leyendas para recibo
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_CHA' .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_chamdl->hhrchrasgcod .chr(9).chr(9) );
				$lo_recmdl->grltxt = $lo_txtmdl->getList( $lv_prm, null, null, false );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_LQD' .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lv_hhrlqdcod .chr(9).chr(9) );
				$lo_recmdl->grltxt2 = $lo_txtmdl->getList( $lv_prm, null, null, false  );
				
				// EMPLEADO. cargo los datos del empleado
				if($lo_recmdl->srcobjtyp=='EDU_TCH'){
					$lo_srcmdl = $this->co_reg->load->model('edutch');
					$lo_srcmdl->load( array('tchcod'=>$lo_recmdl->srcobjcod001), false );
					$lo_srcmdl->hhrempinbdte = $lo_srcmdl->tchinbdte;
					$lo_srcmdl->hhrempoutdte = $lo_srcmdl->tchoutdte;
					$lo_recmdl->emp = $lo_srcmdl;
				} else if($lo_recmdl->srcobjtyp=='HHR_EMP'){
					$lo_srcmdl = $this->co_reg->load->model('hhremp');
					$lo_srcmdl->load( array('hhrempcod'=>$lo_recmdl->srcobjcod001), false );
					$lo_recmdl->emp = $lo_srcmdl;
				}
				
				// CHECK
        if( $lo_recmdl->docsts!='C' ){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'El documento debe estar contabilizado.') );
				}
				
				// VISTA
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutms_hhrlqdrecpnt', array('data'=>$lo_recmdl,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
			
			
      //		G R U P O   D E   R E C I B O S   C O M P R I M I D O S
			case '#hhrlqdrecgrppnt':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lv_hhrlqdgrpcod = ($lo_post['hhrlqdgrpcod']??$lp_prm['hhrlqdgrpcod']);
        
				
				// RECIBO. cargo datos de la liquidación
				$lo_recmdl = $this->co_reg->load->model('hhrlqdgrp');
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]gd.hhrlqdgrpcod'.chr(9).'='.chr(9).chr(9).$lv_hhrlqdgrpcod.chr(9).chr(9));
				if( !$lo_recmdl->getDocuments( $lv_prm ) ){
					$lv_ret['errtyp']='E';
					$lv_ret['errcod']=-1; 
					$lv_ret['errtxt']='El documento ['.$lv_hhrlqdcod.'] no existe.';
					return $this->co_reg->document->getJson( $lv_ret );
				}
        
        // Preparo el pdf
        $lo_file = @tempnam('tmp', 'zip');
        $lo_zip = new ZipArchive();
        $lo_zip->open($lo_file, ZipArchive::OVERWRITE);
        
        foreach($lo_recmdl->getData() as &$lv_row){
          //$lv_tmprow = (object) $lv_row;
					
					// RECIBO. cargo los datos del recibo
					$lv_tmprow = $this->co_reg->load->model('hhrlqd');
					$lv_tmprow->load( array('hhrlqdcod'=>$lv_row['hhrlqdcod']),false );
					$lv_srcobjtxt = $this->co_reg->document->getTagValue($lv_tmprow->hhrlqdatr001,'srcobjtxt');
					
          // EMPRESA. cargo datos de empresa
          $lo_busmdl = $this->co_reg->load->model('admbus');
          $lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
          $lv_tmprow->bus = $lo_busmdl;

					// EMPRESA LOGO. recupero el logo de la empresa
					$lo_flemdl = $this->co_reg->load->model('grldatupl');
					if( $lo_flemdl->getMainPhoto( array('flesrctyp'=>'ADM_BUS','flesrccod'=>$this->co_reg->sec->buscod)) ){
						$lo_rs = $lo_flemdl->getData();
						$lv_tmprow->bus->busimgtyp = $lo_rs[0]['fletyp'];
						$lv_tmprow->bus->busimg = $lo_flemdl->getFileContents( array('flecod'=>$lo_rs[0]['flecod']) );
					}

          // ASIGNACION CARGO. cargo los datos de la asignación del cargo
          $lo_chamdl = $this->co_reg->load->model('hhrchrasg');
          $lo_chamdl->load( array('hhrchrasgcod'=>$lv_row['hhrchrasgcod']), false );
          $lo_chamdl->hhrchrasginbdte = $lo_chamdl->hhrchrasgdtestr;
          $lo_chamdl->hhrchrasgoutdte = $lo_chamdl->hhrchrasgdteend;
          $lv_tmprow->chrasg = $lo_chamdl;

					// TEXTO. cargo leyendas para recibo
					$lo_txtmdl = $this->co_reg->load->model('grldattxt');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_CHA' .chr(9).chr(9).
																				'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_chamdl->hhrchrasgcod .chr(9).chr(9) );
					$lv_tmprow->grltxt = $lo_txtmdl->getList( $lv_prm, null, null, false  );
					$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_LQD' .chr(9).chr(9).
																				'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lv_row['hhrlqdcod'] .chr(9).chr(9) );
					$lv_tmprow->grltxt2 = $lo_txtmdl->getList( $lv_prm, null, null, false  );
				
          // EMPLEADO. cargo los datos del empleado
          if($lv_tmprow->srcobjtyp=='EDU_TCH'){
            $lo_srcmdl = $this->co_reg->load->model('edutch');
            $lo_srcmdl->load( array('tchcod'=>$lv_row['srcobjcod001']), false );
            $lo_srcmdl->hhrempinbdte = $lo_srcmdl->tchinbdte;
            $lo_srcmdl->hhrempoutdte = $lo_srcmdl->tchoutdte;
            $lv_tmprow->emp = $lo_srcmdl;
          } else if($lv_tmprow->srcobjtyp=='HHR_EMP'){
            $lo_srcmdl = $this->co_reg->load->model('hhremp');
            $lo_srcmdl->load( array('hhrempcod'=>$lv_row['srcobjcod001']), false );
            $lv_tmprow->emp = $lo_srcmdl;
					}
          
          $lv_buffer = 	$this->co_reg->document->getView( 'zcutms_hhrlqdrecpnt', array('data'=>$lv_tmprow,'actcod'=>$this->data['actcod']) );
          //$this->co_reg->response->addHeader('Content-type:application/pdf');

          // Agrego el pdf al archivo comprimido
          $lo_zip->addFromString($lv_tmprow->hhrlqddte->format('Y-m'). ' - '. $lv_srcobjtxt. ' - '. $lv_tmprow->hhrchrasgcod.'.pdf', $lv_buffer);

        }
        
        // Cerrar y enviar zip
        $lo_zip->close();
        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="Recibos '.$lo_recmdl->getData()[0]['buscod'].' - '.$lo_recmdl->getData()[0]['hhrlqddte']->format('d.m.Y').'.zip"');
        readfile($lo_file);
        unlink($lo_file); 
				break;			
			
			
			
			//    C O N T R A T O    D E    S E R V I C I O
			//		impresion del contrato de servicios
			case '#slssvcpnt':
				$lo_post = $this->co_reg->request->post;
				$lv_slssvccod = ($lo_post['slssvccod']??$lp_prm['slssvccod']);

				// cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				
				// cargo datos del contrato
				$lo_svcmdl = $this->co_reg->load->model('slssvc');
				$lo_svcmdl->load( array('slssvccod'=>$lv_slssvccod), false );
				
				$lv_buffer = 	$this->co_reg->document->getView('zcutms_slssvcpnt', array('bus'=>$lo_busmdl,'svc'=>$lo_svcmdl,'actcod'=>$this->data['actcod'], 'getbuffer'=>($lv_prm['getbuffer']??'')) );
				if( ($lv_prm['getbuffer']??'')=='') { $this->co_reg->response->addHeader('Content-type:application/pdf'); }
				return $lv_buffer;
				break;
			
			
			
			//    C O T I Z A C I O N E S
			//		impresion del formulario de cotizaciones
			case '#slsqtapnt':
				$lo_post = $this->co_reg->request->post;
				$lv_slsordcod = ($lo_post['slsordcod']??$lp_prm['slsordcod']);

				// cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				
				// cargo datos de la cotizacion
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				$lo_ordmdl->load( array('slsordcod'=>$lv_slsordcod), false );
				
				// cargo textos de cotizacion
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'SLS_QTA' .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_ordmdl->slsordcod .chr(9).chr(9) );
				$lo_txtrs = $lo_txtmdl->getList( $lv_prm, null, null, false );
				
				$lv_buffer = 	$this->co_reg->document->getView('zcutms_slsqtapnt', array('bus'=>$lo_busmdl,'ord'=>$lo_ordmdl,'txt'=>$lo_txtrs,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
			
			
			//    C E R T I F I C A D O    D E    T R A B A J O
			//		impresion del certificado de trabajo
			case '#hhrempcrt':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lv_hhrempcod = ($lo_post['hhrempcod']??$lp_prm['hhrempcod']);
				
				// EMPLEADO. cargo datos del empleado
				$lo_empmdl = $this->co_reg->load->model('hhremp');
				if( !$lo_empmdl->load( array('hhrempcod'=>$lv_hhrempcod), false ) ){
					$lv_ret['errtyp']='E';
					$lv_ret['errcod']=-1;
					$lv_ret['errtxt']='El emppleado ['.$lv_hhrempcod.'] no existe.';
					return $this->co_reg->document->getJson( $lv_ret );
				}

				// EMPRESA. cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$lo_empmdl->bus = $lo_busmdl;
				
				// EMPRESA LOGO. recupero el logo de la empresa
				/*
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				if( $lo_flemdl->getMainPhoto( array('flesrctyp'=>'ADM_BUS','flesrccod'=>$this->co_reg->sec->buscod)) ){
					$lo_rs = $lo_flemdl->getData();
					$lo_empmdl->bus->busimgtyp = $lo_rs[0]['fletyp'];
					$lo_empmdl->bus->busimg = $lo_flemdl->getFileContents( array('flecod'=>$lo_rs[0]['flecod']) );
				}
*/				
				// ASIGNACION CARGO. cargo los datos de la asignación del cargo
				$lo_chamdl = $this->co_reg->load->model('hhrchrasg');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]getdate() BETWEEN ca.hhrchrasgdtestr AND isnull(ca.hhrchrasgdteend,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~]ca.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
																			'[~fltrow~]ca.srcobjcod'.chr(9).'='.chr(9).chr(9).$lv_hhrempcod.chr(9).chr(9).
																			'[~fltrow~]ca.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewmaxrec' =>'1' );
				$lo_empmdl->chrasg = $lo_chamdl->getList( $lv_prm, null, null, false );
				/*
				$lo_chamdl->load( array('hhrchrasgcod'=>$lo_recmdl->hhrchrasgcod) );
				$lo_chamdl->hhrchrasginbdte = $lo_chamdl->hhrchrasgdtestr;
				$lo_chamdl->hhrchrasgoutdte = $lo_chamdl->hhrchrasgdteend;
				$lo_recmdl->chrasg = $lo_chamdl;
				
				// TEXTO. cargo leyendas para recibo
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_CHA' .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_chamdl->hhrchrasgcod .chr(9).chr(9) );
				$lo_recmdl->grltxt = $lo_txtmdl->getList( $lv_prm );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_LQD' .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lv_hhrlqdcod .chr(9).chr(9) );
				$lo_recmdl->grltxt2 = $lo_txtmdl->getList( $lv_prm );
				*/
				
				// CHECK
        //if( $lo_recmdl->docsts!='C' ){
        //  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'El documento debe estar contabilizado.') );
				//}
				
				// VISTA
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutms_hhrempcrtpnt', array('data'=>$lo_empmdl,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
      
			
			
			
			
      // ----------------------------------------------------------------------
			//
			//    E N V I O    D E    M A I L S 
 			//
			// ----------------------------------------------------------------------
      
      
			
      
      
      //    F A C T U R A S    V E N C I D A S
      //    envia mail notificando facturas vencidas / proximas a vencer
      case '#eml_facturasvencimiento':
        $lo_post = $this->co_reg->request->post;
        $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        $lo_docmdl = $this->co_reg->load->model('finsumdoc');
				$lo_tms = $this->co_reg->load->controller('zcutms');
        $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','errlog'=>'','errtch'=>'');

				// VALIDACION. verifico ejecucion de interfaz
        if( !isset($lo_post['sysint']) ){
					$lv_ret['errtyp']='E'; $lv_ret['errtxt']='Falta indicar sysint (post). Interfaz no ejecutada desde interfaces.'; $lv_ret['errlog']=$lp_act;
					return $lv_ret;
				}
				
				// INTERFAZ. obtengo atributos de interfaz
        //$lv_atr = $this->co_reg->document->getArrayFromXML( $lo_post['sysint']['sysintatr'] );
        $lv_atr = ( $lo_post['sysint']['sysintatr'] ?? array() );
				$lv_subject = ($lv_atr['subject']??'');
				$lv_to = ($lv_atr['to']??'');
        if($lv_to!=''){ $lv_to_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_to)); } else { $lv_to_arr = array(); }
				$lv_cc = ($lv_atr['cc']??'');
        if($lv_cc!=''){ $lv_cc_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_cc)); } else { $lv_cc_arr = array(); }
				$lv_bcc = ($lv_atr['bcc']??'');
        if($lv_bcc!=''){ $lv_bcc_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_bcc)); } else { $lv_bcc_arr = array(); }
				$lv_cuscod = ($lv_atr['cuscod']??'');
        if( $lv_cuscod!='' ){ $lo_post['cuscod']=$lv_cuscod; }
				$lv_attach = ($lv_atr['attach']??'');
        $lv_slsinvcod = ($lv_atr['slsinvcod']??''); if( $lv_slsinvcod!='' ){ $lo_post['slsinvcod']=$lv_slsinvcod; }
				$lv_txtnme = ($lv_atr['texto']??'');
				if( $lv_txtnme=='' ){
					$lv_ret['errtyp']='E'; $lv_ret['errtxt']='Falta indicar atributo [texto] que es el codigo externo del texto a enviar como contenido de mail.'; $lv_ret['errlog']=$lp_act;
					return $lv_ret;
				}
				
        // TEXTO. recupero texto del mail
        $lo_txtmdl->load( array('txtcodext'=>$lv_txtnme) );
				$lv_txt =  html_entity_decode($lo_txtmdl->txttxt);
        if( $lv_txt=='' ){
          $lv_ret['errtyp']='E'; $lv_ret['errtxt']='No se encontro el texto con codigo externo ['.$lv_txtnme.'] para enviar como contenido de mail.'; $lv_ret['errlog']=$lp_act; $lv_ret['errtch']=$lo_txtmdl->getsysdata('sqlstm');
          return $lv_ret;
        }
        
        // FACTURAS. recupero facturas pendientes
        $lv_prm = array('vewfldflt' =>'[~fltrow~]fd.finsumdoctotrst'.chr(9).'>'.chr(9).chr(9).'0'.chr(9).chr(9).
                        							'[~fltrow~]fd.impobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_INV'.chr(9).chr(9).
                        							'[~fltrow~]f.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
                        							($lo_post['cuscod']??''!=''?
																				'[~fltrow~]f.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
																				'[~fltrow~]f.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['cuscod'].chr(9).chr(9)
																				:'').
                        							($lo_post['slsinvcod']??''!=''?
                                       	'[~fltrow~]fd.docobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_INV'.chr(9).chr(9).
                                        '[~fltrow~]fd.docobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['slsinvcod'].chr(9).chr(9)
                                       :'').
                                      '[~fltrow~]fd.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                        'vewfldord'=>'f.srcobjtyp, f.srcobjcod, fd.refobjtyp, fd.refobjcod, fd.docobjduedte');
        $lo_rs = $lo_docmdl->getList( $lv_prm );
				if( $lo_docmdl->errtyp=='E' ){
          $lv_ret['errtyp']='E'; $lv_ret['errtxt']=$lo_docmdl->errtxt; $lv_ret['errtch']=$lo_docmdl->getsysdata('sqlstm');
          return $lv_ret;
        }
        
        // envio mails a cada cliente (responsable de pago)
				$lv_now = new DateTime(); 
        $lv_totinv = count($lo_rs);
				$lv_totcus = 0;  $lv_totsnd = 0;
        $lv_tblnxt = ''; $lv_tblsumnxt = 0;
				$lv_tbldue = ''; $lv_tblsumdue = 0;
				$lv_attachArr = array();
        for($i=0; $i<$lv_totinv; $i++){
        	$lv_dat = $lo_rs[$i];
          $lv_duedte = ( $lv_dat['docobjduedte'] instanceof DateTime ? $lv_dat['docobjduedte']->format('d/m/Y') : '-' );
					
					// agrego fila a facturas por vencer
					if($lv_now < $lv_dat['docobjduedte']){
					
            if( $lv_attach!='' ){
              $lv_file = $lo_tms->index('slsinvpnt', array('slsinvcod'=>$lv_dat['impobjcod'] , 'getbuffer'=>'X'));
              //if( $lv_file!='' ){ $lv_attachArr[] = array('filename'=>$lv_dat['refobjtxt'].'_'.$lv_dat['docobjcodext'].'_'.$lv_dat['docobjduedte']->format('Ym').'.pdf', 'file'=>$lv_file); }
              if( $lv_file!='' ){ $lv_attachArr[] = array('file'=>$lv_file,
																													'fileFormat'=>'base64',
																													'fileName'=>$lv_dat['refobjtxt'].'_'.$lv_dat['docobjcodext'].'_'.$lv_dat['docobjduedte']->format('Ym').'.pdf', 
																													'mimeType'=>'application/pdf'); }
            }
            
						$lv_tblnxt.='<tr><td>'.($lv_dat['docobjcodext']??'').'</td><td>'.$lv_duedte.'</td><td>'.($lv_dat['refobjtxt']??'').'</td><td style="text-align:right;">$ '.number_format($lv_dat['finsumdoctotrst']??0,2,',','.').'</td></tr>';
						$lv_tblsumnxt += $lv_dat['finsumdoctotrst'];
					// agrego fila a facturas vencidas
					} else {
						$lv_tbldue.='<tr><td>'.($lv_dat['docobjcodext']??'').'</td><td>'.$lv_duedte.'</td><td>'.($lv_dat['refobjtxt']??'').'</td><td style="text-align:right;">$ '.number_format($lv_dat['finsumdoctotrst']??0,2,',','.').'</td></tr>';
						$lv_tblsumdue += $lv_dat['finsumdoctotrst'];
					}
          
					// CORTE DE CONTROL. si el siguiente registro es el ultimo o cambia el pagador, envio el mail
          $lv_send = ( $i==$lv_totinv-1 ? 1 : ( $lv_dat['srcobjcod']!=$lo_rs[$i+1]['srcobjcod'] ? 1 : 0 ));
          if($lv_send==1){
		        $lv_txt = html_entity_decode($lo_txtmdl->txttxt);
            
						// si se indico destinatario fijo, no busco el pagador
						if( count($lv_to_arr??array())>0 ){
							$lv_eml_to = $lv_to_arr;
						} else {
							// DESTINATARIO DE FACTURA. recupero destinatarios de email del pagador
							$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lv_dat['srcobjtyp'].chr(9).chr(9).
																						'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lv_dat['srcobjcod'].chr(9).chr(9).
																						'[~fltrow~]dbo.gettagvalue(^invdst^,ct.sysdocclsatr)'.chr(9).'<>'.chr(9).chr(9).''.chr(9).chr(9),
															'vewmaxrec'=>'10');
							$lo_rseml = $lo_cntmdl->getList( $lv_prm );
							$lv_eml_to = array();
							foreach( $lo_rseml as $lv_roweml ){ 
								if($lv_roweml['adreml']??''!=''){ $lv_eml_to[] = array('address' => $lv_roweml['adreml'] ); }
							}
						}
            
						// verifico si hay destinatario de facturas para enviar el mail
            if(count($lv_eml_to)==0){
              $lv_ret['errlog'].= 'Cliente ['.$lv_dat['srcobjcod'].' - '.$lv_dat['srcobjtxt'].'] sin destinatarios de facturas.&#13;&#10;';
            } else {
							$lv_totcus++;
              $lv_ret['errlog'].= 'Cliente ['.$lv_dat['srcobjcod'].' - '.$lv_dat['srcobjtxt'].'] con destinatario de factura ('.$this->co_reg->document->getJson($lv_eml_to).').';

              // DATOS. actualizo datos del cuerpo del mail y el subject
							$lv_meses = array(1=>'Enero',2=>'Febrero',3=>'Marzo',4=>'Abril',5=>'Mayo',6=>'Junio',7=>'Julio',8=>'Agosto',9=>'Septiembre',10=>'Octubre',11=>'Noviembre',12=>'Diciembre');
              $lv_datos = array('textoPeriodo' => $lv_meses[ intval($lv_now->format('m')) ].' '.$lv_now->format('Y'), 
																'nombrePagador' => ($lv_dat['srcobjtxt']??''), 
                                'fechaActual' => $lv_now->format('d/m/Y'), 
																'introVencimiento' => ( $lv_tbldue=='' ? '' : 'Asimismo, le informamos que seg&uacute;n nuestros registros, al d&iacute;a de la fecha <b>'.$lv_now->format('d/m/Y').'</b>' ),
                                'facturasVencidas' => ( $lv_tbldue=='' ? '' : '<p>Existe un <b>saldo pendiente</b> en su cuenta de <b>$ '.number_format($lv_tblsumdue,2,',','.').'.</b></p><br><table width="100%" border=1 cellpadding=5><thead><tr style="background-color:#F09B59; color:white;"><th>N&uacute;mero</th><th>Vencimiento</th><th>Cuenta</th><th>Importe</th></tr></thead><tbody>'.$lv_tbldue.'<tr style="font-weight:bold; text-align:right; background-color:#F09B59; color:white;"><td colspan=3>TOTAL</td><td>$ '.number_format($lv_tblsumdue,2,',','.').'</td></tr></tbody></table>'),
                               	'facturasAVencer' => ( $lv_tblnxt=='' ? '' : '<p>Las siguientes facturas estan pr&oacute;ximas a vencer:</p><br><table width="100%" border=1 cellpadding=5><thead><tr style="background-color:#f1f1f1;"><th>N&uacute;mero</th><th>Vencimiento</th><th>Cuenta</th><th>Importe</th></tr></thead><tbody>'.$lv_tblnxt.'<tr style="font-weight:bold; text-align:right; background-color:#f1f1f1;"><td colspan=3>TOTAL</td><td>$ '.number_format($lv_tblsumnxt,2,',','.').'</td></tr></tbody></table>')
                               );
              foreach( $lv_datos as $lv_keyrow=>$lv_datrow ){
								$lv_txt = str_ireplace( '[%'.$lv_keyrow.']', $lv_datrow, $lv_txt );
								$lv_subject = str_ireplace( '[%'.$lv_keyrow.']', $lv_datrow, $lv_subject );
							}
              							
              // MAIL. armo y envio mail
              $lo_eml = new tmssMail();
              $lv_emlprm = array( 'to'=>$lv_eml_to,
                              		'cc'=>($lv_cc_arr??array()),
                                	'bcc'=>($lv_bcc_arr??array()),
                                	'subject'=>$lv_subject,
              										'from'=>array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ),
              										'bodyhtml'=>$lv_txt,
                                	'attachmentsString'=>$lv_attachArr);
              if ( !$lo_eml->send( $lv_emlprm ) ) {
                $lv_ret['errlog'] = 'Error al enviar email a cliente ['.$lv_dat['srcobjcod'].' - '.$lv_dat['srcobjtxt'].']: '.$lo_eml->getError();
              } else {
                $lv_totsnd++;
              }
            	$lv_tblnxt = ''; $lv_tblsumnxt = 0;
							$lv_tbldue = ''; $lv_tblsumdue = 0;
							$lv_attachArr = array();
            }
          }
        }

				$lv_ret['errlog'] .= 'Copia oculta: ('.$this->co_reg->document->getJson($lv_bcc_arr).')&#13;&#10;';
        
        if($lv_totinv==0){
          $lv_ret['errtxt']='No se encontraron documentos para enviar.';
          $lv_ret['errtch']=$lo_docmdl->getsysdata('sqlstm');
      	} else if($lv_totsnd==0 ) {
          $lv_ret['errtyp'] = 'E';
          $lv_ret['errcod'] = -1;
          $lv_ret['errtxt'] = 'No se pudo enviar ninguna factura.';
          $lv_ret['errtch'] = $this->co_reg->document->getJson( $lo_rs );
      	} else if($lv_totsnd<$lv_totcus-1 ) {
          $lv_ret['errtyp'] = 'W';
          $lv_ret['errcod'] = -1;
          $lv_ret['errtxt'] = 'Al menos una factura no pudo ser enviada. Emails a clientes enviados ['.$lv_totsnd.'/'.$lv_totcus.'].';
          $lv_ret['errtch'] = $this->co_reg->document->getJson( $lo_rs );
        } else {
          $lv_ret['errtxt'] = '['.$lv_totsnd.'] emails enviados.';
				}
        return $lv_ret;
        break;
			
			
			
    	//	CONTRATOS DE SERVICIO	
			// envio de mail con contrato de servicio adjunto
			case '#eml_contratosservicio':
        $lo_post = $this->co_reg->request->post;
        $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        $lo_docmdl = $this->co_reg->load->model('slssvc');
				$lo_tms = $this->co_reg->load->controller('zcutms');
        $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','errlog'=>'','errtch'=>'');

				// VALIDACION. verifico ejecucion de interfaz
        if( !isset($lo_post['sysint']) ){
					$lv_ret['errtyp']='E'; $lv_ret['errtxt']='Falta indicar sysint (post). Interfaz no ejecutada desde interfaces.'; $lv_ret['errlog']=$lp_act;
					return $lv_ret;
				}
				
				// INTERFAZ. obtengo atributos de interfaz
        //$lv_atr = $this->co_reg->document->getArrayFromXML( $lo_post['sysint']['sysintatr'] );
        $lv_atr = ( $lo_post['sysint']['sysintatr'] ?? array() );
				$lv_subject = ($lv_atr['subject']??'');
				$lv_to = ($lv_atr['to']??'');
        if($lv_to!=''){ $lv_to_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_to)); } else { $lv_to_arr = array(); }
				$lv_cc = ($lv_atr['cc']??'');
        if($lv_cc!=''){ $lv_cc_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_cc)); } else { $lv_cc_arr = array(); }
				$lv_bcc = ($lv_atr['bcc']??'');
        if($lv_bcc!=''){ $lv_bcc_arr = array_map( fn($email) => ['address'=>trim($email)], explode(';', $lv_bcc)); } else { $lv_bcc_arr = array(); }
				$lv_cuscod = ($lv_atr['cuscod']??'');
        if( $lv_cuscod!='' ){ $lo_post['cuscod']=$lv_cuscod; }
				$lv_attach = ($lv_atr['attach']??'');
        $lv_slssvccod = ($lv_atr['slssvccod']??''); if( $lv_slssvccod!='' ){ $lo_post['slssvccod']=$lv_slssvccod; }
				$lv_txtnme = ($lv_atr['texto']??'');
				if( $lv_txtnme=='' ){
					$lv_ret['errtyp']='E'; $lv_ret['errtxt']='Falta indicar atributo [texto] que es el codigo externo del texto a enviar como contenido de mail.'; $lv_ret['errlog']=$lp_act;
					return $lv_ret;
				}
				$lv_fecha = ($lv_atr['fecha']??'');
				if( $lv_fecha=='' ){
					$lv_ret['errtyp']='E'; $lv_ret['errtxt']='Falta indicar atributo [fecha] que es la fecha para buscar contratos vigentes en la fecha indicada.'; $lv_ret['errlog']=$lp_act;
					return $lv_ret;
				} else {
					$lv_fecha2 = DateTime::createFromFormat('d/m/Y', $lv_fecha);
					if (!$lv_fecha2 || $lv_fecha2->format('d/m/Y') !== $lv_fecha) {
						$lv_ret['errtyp']='E'; $lv_ret['errtxt']='La fecha del atributo [fecha] es invalida. Debe tener formato [d/m/Y].'; $lv_ret['errlog']=$lp_act;
						return $lv_ret;
					}
				}
				
				
        // TEXTO. recupero texto del mail
        $lo_txtmdl->load( array('txtcodext'=>$lv_txtnme) );
				$lv_txt =  html_entity_decode($lo_txtmdl->txttxt);
        if( $lv_txt=='' ){
          $lv_ret['errtyp']='E'; $lv_ret['errtxt']='No se encontro el texto con codigo externo ['.$lv_txtnme.'] para enviar como contenido de mail.'; $lv_ret['errlog']=$lp_act; $lv_ret['errtch']=$lo_txtmdl->getsysdata('sqlstm');
          return $lv_ret;
        }
        
        // CONTRATO DE SERVICIO. recupero contratos de servicio vigentes
        $lv_prm = array('vewfldflt' =>'[~fltrow~]^'.$lv_fecha2->format('Y-m-d').'^ between o.slssvcstrdte and o.slssvcenddte'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                        							($lo_post['cuscod']??''!=''?
																				'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
																				'[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['cuscod'].chr(9).chr(9)
																				:'').
                        							($lo_post['slssvccod']??''!=''?
                                        '[~fltrow~]o.slssvccod'.chr(9).'='.chr(9).chr(9).$lo_post['slssvccod'].chr(9).chr(9)
                                       :'').
                                      '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                        'vewfldord'=>'o.dstobjtyp, o.dstobjcod, o.slssvcdte');
        $lo_rs = $lo_docmdl->getList( $lv_prm );
				if( $lo_docmdl->errtyp=='E' ){
          $lv_ret['errtyp']='E'; $lv_ret['errtxt']=$lo_docmdl->errtxt; $lv_ret['errtch']=$lo_docmdl->getsysdata('sqlstm');
          return $lv_ret;
        }
        
        // envio mails a cada cliente (responsable de pago)
				$lv_now = new DateTime(); 
        $lv_totsvc = count($lo_rs);
				$lv_attachArr = array();
        for($i=0; $i<$lv_totsvc; $i++){
        	$lv_dat = $lo_rs[$i];
					
					$lv_file = $lo_tms->index('slssvcpnt', array('slssvccod'=>$lv_dat['slssvccod'] , 'getbuffer'=>'X'));
					if( $lv_file!='' ){ $lv_attachArr[] = array('file'=>$lv_file,
																											'fileFormat'=>'base64',
																											'fileName'=>'Contrato de Servicio '.$lv_dat['dstobjtxt'].' - '.$lv_dat['slssvctxt'].'.pdf', 
																											'mimeType'=>'application/pdf'); }
          
					// CORTE DE CONTROL. si el siguiente registro es el ultimo o cambia el pagador, envio el mail
          $lv_send = ( $i==$lv_totsvc-1 ? 1 : ( $lv_dat['dstobjcod']!=$lo_rs[$i+1]['dstobjcod'] ? 1 : 0 ));
          if($lv_send==1){
		        $lv_txt = html_entity_decode($lo_txtmdl->txttxt);
            
						// si se indico destinatario fijo, no busco el pagador
						if( count($lv_to_arr??array())>0 ){
							$lv_eml_to = $lv_to_arr;
						} else {
							// DESTINATARIO DE FACTURA. recupero destinatarios de email del pagador
							$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lv_dat['dstobjtyp'].chr(9).chr(9).
																						'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lv_dat['dstobjcod'].chr(9).chr(9).
																						'[~fltrow~]dbo.gettagvalue(^invdst^,ct.sysdocclsatr)'.chr(9).'<>'.chr(9).chr(9).''.chr(9).chr(9),
															'vewmaxrec'=>'10');
							$lo_rseml = $lo_cntmdl->getList( $lv_prm );
							$lv_eml_to = array();
							foreach( $lo_rseml as $lv_roweml ){ 
								if($lv_roweml['adreml']??''!=''){ $lv_eml_to[] = array('address' => $lv_roweml['adreml'] ); }
							}
						}
            
						// verifico si hay destinatario de facturas para enviar el mail
            if(count($lv_eml_to)==0){
              $lv_ret['errlog'].= 'Cliente ['.$lv_dat['dstobjcod'].' - '.$lv_dat['dstobjtxt'].'] sin destinatarios de facturas.&#13;&#10;';
            } else {
							$lv_totcus++;
              $lv_ret['errlog'].= 'Cliente ['.$lv_dat['dstobjcod'].' - '.$lv_dat['dstobjtxt'].'] con destinatario de factura ('.$this->co_reg->document->getJson($lv_eml_to).').';

              // DATOS. actualizo datos del cuerpo del mail y el subject
							$lv_meses = array(1=>'Enero',2=>'Febrero',3=>'Marzo',4=>'Abril',5=>'Mayo',6=>'Junio',7=>'Julio',8=>'Agosto',9=>'Septiembre',10=>'Octubre',11=>'Noviembre',12=>'Diciembre');
              $lv_datos = array('textoPeriodo' => $lv_meses[ intval($lv_now->format('m')) ].' '.$lv_now->format('Y'), 
																'nombrePagador' => ($lv_dat['dstobjtxt']??''), 
                                'fechaActual' => $lv_now->format('d/m/Y')
                               );
              foreach( $lv_datos as $lv_keyrow=>$lv_datrow ){
								$lv_txt = str_ireplace( '[%'.$lv_keyrow.']', $lv_datrow, $lv_txt );
								$lv_subject = str_ireplace( '[%'.$lv_keyrow.']', $lv_datrow, $lv_subject );
							}
              							
              // MAIL. armo y envio mail
              $lo_eml = new tmssMail();
              $lv_emlprm = array( 'to'=>$lv_eml_to,
                              		'cc'=>($lv_cc_arr??array()),
                                	'bcc'=>($lv_bcc_arr??array()),
                                	'subject'=>$lv_subject,
              										'from'=>array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ),
              										'bodyhtml'=>$lv_txt,
                                	'attachmentsString'=>$lv_attachArr);
              if ( !$lo_eml->send( $lv_emlprm ) ) {
                $lv_ret['errlog'] = 'Error al enviar email a cliente ['.$lv_dat['dstobjcod'].' - '.$lv_dat['dstobjtxt'].']: '.$lo_eml->getError();
              } else {
                $lv_totsnd++;
              }
							$lv_attachArr = array();
            }
          }
        }

				$lv_ret['errlog'] .= 'Copia oculta: ('.$this->co_reg->document->getJson($lv_bcc_arr).')&#13;&#10;';
        
        if($lv_totsvc==0){
          $lv_ret['errtxt']='No se encontraron documentos para enviar.';
          $lv_ret['errtch']=$lo_docmdl->getsysdata('sqlstm');
      	} else if($lv_totsnd==0 ) {
          $lv_ret['errtyp'] = 'E';
          $lv_ret['errcod'] = -1;
          $lv_ret['errtxt'] = 'No se pudo enviar ningun contrato de servicios.';
          $lv_ret['errtch'] = $this->co_reg->document->getJson( $lo_rs );
      	} else if($lv_totsnd<$lv_totcus-1 ) {
          $lv_ret['errtyp'] = 'W';
          $lv_ret['errcod'] = -1;
          $lv_ret['errtxt'] = 'Al menos un contrato de servicios no pudo ser enviada. Emails a clientes enviados ['.$lv_totsnd.'/'.$lv_totcus.'].';
          $lv_ret['errtch'] = $this->co_reg->document->getJson( $lo_rs );
        } else {
          $lv_ret['errtxt'] = '['.$lv_totsnd.'] emails enviados.';
				}
        return $lv_ret;			
				break;
      
			
			
			//		C R M
			//		notificaciones de mail de CRM
      case '#crmcnteml':
        // tipos de usuarios
        // usrntf ; usrreq ; usrasg ; usrmen
        // tipos de motivo
        // newres ; chgsts ; newcnt
        
        //cargo chkntf
        $lo_crmcntmdl = $this->co_reg->load->model('crmcnt');
        $lo_crmcntmdl->setData( $lp_prm['data'] );
        $lp_prm['chkntf']=$lo_crmcntmdl->checkNotification($lp_prm['mdlprv'], $lo_crmcntmdl);
        
        // Para cada caso recupero texto
        // NUEVO CONTACTO. Se recupera texto del nuevo contacto
        if (!empty($lp_prm['chkntf']['usrntf'])){
          $lp_prm['data']['crmcnttxt'] = html_entity_decode($lp_prm['data']['crmcnttxt']);
          //Recuperar comentarios
        	
          // flags de cambio de estado, comentarios, y responsable. Se usa para marcar en negrita lo que corresponda
          $lv_chgstsflg = (($lp_prm['data']['crmcntstscod']??'') == $lp_prm['mdlprv']->crmcntstscod ? false : true );
          $lv_chgresflg = (($lp_prm['data']['usrcod']??'') == $lp_prm['mdlprv']->usrcod ? false : true );
          $lv_chgcmtflg = (($lp_prm['data']['crmcntcmt']??'') == $lp_prm['mdlprv']->crmcntcmt ? false : true );
          
					// nuevo contacto
          if( isset($lp_prm['chkntf']['mtvntf']['newcnt'])){

            // Armo la estructura del mail incluyendo a los notificados (requester)
            $lv_mailto = array();
            $lv_mailcco = array();

            foreach($lp_prm['chkntf']['usrntf'] as $lv_row){
              if ($lv_row['ntftyp']=='usrreq'){
                $lv_mailto[] = array('address' => $lv_row['adreml']);
              }
            }
            
            //Si hay solicitante
            if (!empty($lv_mailto)){
            	// TEXTO DE MAIL. Obtengo texto del mensaje
              $lv_usrmsg='';
              $lo_txtmdl = $this->co_reg->load->model('grldattxt');
              if( $lo_txtmdl->load(array('txtcodext' => 'CRMCNTNTFNEW', 'txtsys'=>0), false) ){
                $lv_usrmsg = html_entity_decode($lo_txtmdl->txttxt);
              }else{
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error de configuraci&oacute;n. No se encontr&oacute; el texto ['.($lp_oldmdl->crmcntstscod=='' ? $lv_crmcntntfnew : $lv_crmcntntfupd ).']' ) );
              }

              //MAIL. Envío mail
              if ( $lv_usrmsg!= '' && count($lp_prm['chkntf'])>0 ) {
                $lo_eml = new tmssMail();
                $lv_emlprm['to'] = $lv_mailto;

                $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ); 
                $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');  
							$lv_emlprm['subject'] = 'Nuevo contacto #'.$lp_prm['data']['crmcntcod'].' - '.$lp_prm['data']['crmcnttxt'];
                $lv_usrmsg = str_replace( '[%1]', $lp_prm['data']['crmcnttxt'], $lv_usrmsg );
                $lv_usrmsg = str_replace( '[%2]', $lp_prm['data']['crmcntsrccntcod'] == '' ? $lp_prm['data']['crmcntsrctxt'] : $lp_prm['data']['crmcntsrccnttxt'], $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%3]', $lp_prm['data']['crmcntcod'], $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%4]', 'Temasis Argentina SRL', $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%9]', '', $lv_usrmsg );            
              }

              $lv_emlprm['bodyhtml'] = $lv_usrmsg;
              if ( !$lo_eml->send( $lv_emlprm ) ) {
                return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml->getError()) );
              } 
            }
          }
          
					//Cambio de estado
          if(isset($lp_prm['chkntf']['mtvntf']['chgsts']) || isset($lp_prm['chkntf']['mtvntf']['newres'])){

            // Armo la estructura del mail incluyendo a los notificados (responsable, requester, notificados)
            $lv_mailto = array();
            $lv_mailcco = array();
            $lv_mailasg = array();
            $lv_reqflg = false;
            foreach($lp_prm['chkntf']['usrntf'] as $lv_row){
              // Se le envía el mail al requester si solamente se cambia de estado o si se cambia tanto de estado como de responsable
              // No se envía si solo se cambia de resopnsable
              if ($lv_row['ntftyp']=='usrreq' && isset($lp_prm['chkntf']['mtvntf']['chgsts']) ){
                $lv_reqflg = true;
                $lv_mailto[] = array('address' => $lv_row['adreml']);
              }else if($lv_row['ntftyp']=='usrasg'){
                $lv_mailasg[] = array('address' => $lv_row['adreml']);
              }else if($lv_row['ntftyp']=='usrntf'){
                $lv_mailcco[] = array('address' => $lv_row['adreml']);
              }
            }

            // TEXTO DE MAIL. Obtengo texto del mensaje
            $lv_usrmsg='';
            $lo_txtmdl = $this->co_reg->load->model('grldattxt');
            if( $lo_txtmdl->load(array('txtcodext' => 'CRMCNTNTFUPD', 'txtsys'=>0), false) ){
              $lv_msg = html_entity_decode($lo_txtmdl->txttxt);
            } else {
              return $this->co_reg->document->getJson( array( 'errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'Error de configuraci&oacute;n. No se encontr&oacute; el texto ['.($lp_oldmdl->crmcntstscod=='' ? $lv_crmcntntfnew : $lv_crmcntntfupd ).']' ) );
            }


            //MAIL. Envío mail
            if ( $lv_msg!= '' && count($lp_prm['chkntf'])>0){
              $lv_usrmsg = $lv_msg;
              
              //Texto de cambio de estado para solicitante. Hay uno para cambio de estado y otro para estado finalizado
              if($lv_reqflg) {
  
                $datatbl = '<table>
                            <thead><tr></tr><tr></tr></thead>
                            <tbody>
                              <tr style="padding-bottom: 1em;"><td>Estado: </td><td>'.($lv_chgstsflg == true ? '<b>' : '').$lp_prm['data']['crmcntststxt'].($lv_chgstsflg == true ? '</b>' : '').'</td></tr>
                              <tr><td style="vertical-align: top;">Comentarios: </td><td>'.($lv_chgcmtflg == true ? '<b>' : '').html_entity_decode($lp_prm['data']['crmcntcmt']).($lv_chgcmtflg == true ? '</b>' : '').'</td></tr>
                            </tbody></table>';


                $lo_eml = new tmssMail();
                $lv_emlprm['to']  = $lv_mailto;

                $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ); 
                $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');  
                $lv_emlprm['subject'] = 'Contacto '.(isset($lp_prm['chkntf']['mtvntf']['stscls']) ? 'finalizado' : 'actualizado' ).' #'.$lp_prm['data']['crmcntcod'].' - '.$lp_prm['data']['crmcnttxt'];
                $lv_usrmsg = str_replace( '[%1]', $lp_prm['data']['crmcnttxt'], $lv_usrmsg );
                $lv_usrmsg = str_replace( '[%2]', $lp_prm['data']['crmcntsrccntcod'] == '' ? $lp_prm['data']['crmcntsrctxt'] : $lp_prm['data']['crmcntsrccnttxt'], $lv_usrmsg);
                $lv_usrmsg = (isset($lp_prm['chkntf']['mtvntf']['stscls']) ? str_replace( '[%3]', 'finaliz&oacute;', $lv_usrmsg) : str_replace( '[%3]', 'modific&oacute;', $lv_usrmsg) );
                $lv_usrmsg = str_replace( '[%4]', $lp_prm['data']['crmcntcod'], $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%5]', $datatbl, $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%6]', 'Temasis Argentina SRL', $lv_usrmsg);
                $lv_usrmsg = str_replace( '[%9]', '', $lv_usrmsg );            

                $lv_emlprm['bodyhtml'] = $lv_usrmsg;
                if ( !$lo_eml->send( $lv_emlprm ) ) {
                  return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml->getError()) );
                }
              }
              //Envío de mails para responsable y resto de usuarios notificados
              $lv_usrmsg2 = $lv_msg;
              $datatbl2 = '<table>
                          <thead><th></th><th></th></thead>
                          <tbody>
                            <tr style="padding-bottom: 1em;"><td>Estado: </td><td>'.($lv_chgstsflg == true ? '<b>' : '').$lp_prm['data']['crmcntststxt'].($lv_chgstsflg == true ? '</b>' : '').'</td></tr>
                            <tr style="padding-bottom: 1em;"><td>Responsable: </td><td>'.($lv_chgresflg == true ? '<b>' : '').strtoupper($lp_prm['data']['usrcod']).($lv_chgresflg == true ? '</b>' : '').'</td></tr>
                            <tr><td style="vertical-align: top;">Comentarios: </td><td>'.($lv_chgcmtflg == true ? '<b>' : '').html_entity_decode($lp_prm['data']['crmcntcmt']).($lv_chgcmtflg == true ? '</b>' : '').'</td></tr>
                          </tbody></table>';

              $lo_eml2 = new tmssMail();
              $lv_emlprm2['to']  = (empty($lv_mailasg) ? array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL')) : $lv_mailasg );
              $lv_emlprm2['bcc'] = $lv_mailcco;

              $lv_emlprm2['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ); 
              $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');  
              $lv_emlprm2['subject'] = 'Contacto actualizado #'.$lp_prm['data']['crmcntcod'].' - '.$lp_prm['data']['crmcnttxt'];
              $lv_usrmsg2 = str_replace( '[%1]', $lp_prm['data']['crmcnttxt'], $lv_usrmsg2 );
              $lv_usrmsg2 = str_replace( '[%2]', $lp_prm['data']['usrcod'], $lv_usrmsg2);
              $lv_usrmsg2 = str_replace( '[%3]', 'actualiz&oacute;', $lv_usrmsg2);
              $lv_usrmsg2 = str_replace( '[%4]', $lp_prm['data']['crmcntcod'], $lv_usrmsg2);
              $lv_usrmsg2 = str_replace( '[%5]', $datatbl2, $lv_usrmsg2);
              $lv_usrmsg2 = str_replace( '[%6]', 'Temasis Argentina SRL', $lv_usrmsg2);
              $lv_usrmsg2 = str_replace( '[%9]', '', $lv_usrmsg2 );

              $lv_emlprm2['bodyhtml'] = $lv_usrmsg2;
              if ( !$lo_eml2->send( $lv_emlprm2 ) ) {
                return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml2->getError()) );
              }
          	}
          }
          
          //Envío de mail a usuarios mencionados
          if( isset($lp_prm['chkntf']['mtvntf']['newmen']) ){
            
          // Armo la estructura del mail incluyendo a los notificados (responsable, requester, notificados)
            $lv_mailcco = array();
            $lv_mailmen = array();
            $lv_reqflg = false;
            
            //Se arma array solo con los mencionados
            foreach($lp_prm['chkntf']['usrntf'] as $lv_row){
              if ($lv_row['ntftyp']=='usrmen'){
                $lv_mailmen[] = $lv_row['adreml'];
              }
            }
            
            //Se comprueba por cada mencionado si corresponde mandarle un mail con la siguiente lógica:
            // No se debe enviar el mail al mencionar al solicitante si se hizo un cambio de estado, 
            // al responsable si se hizo un cambio de estado o de responsable,
            // ni a los notificados si se hizo cambio de estado o responsable, porque ya reciben mail
            
            foreach($lv_mailmen as $lv_row){
              $escapeflg = false;
            	foreach($lp_prm['chkntf']['usrntf'] as $lv_row2){
                if ($lv_row == $lv_row2['adreml']){
                  if ($lv_row2['ntftyp']=='usrreq' && isset($lp_prm['chkntf']['mtvntf']['chgsts'])){
										$escapeflg = true;
                  }else if (($lv_row2['ntftyp']=='usrasg' || $lv_row2['ntftyp']=='usrntf') && ( isset($lp_prm['chkntf']['mtvntf']['chgsts']) || isset($lp_prm['chkntf']['mtvntf']['newres']) ) ){
                    $escapeflg = true;
                  }
                }
              }
              if(!$escapeflg){
              	$lv_mailcco[] = array('address' => $lv_row); 
              }
            }

            // TEXTO DE MAIL. Obtengo texto del mensaje
            $lv_usrmsg='';
            $lo_txtmdl = $this->co_reg->load->model('grldattxt');
            if( $lo_txtmdl->load(array('txtcodext' => 'CRMCNTNTFUPD', 'txtsys'=>0), false) ){
              $lv_msg = html_entity_decode($lo_txtmdl->txttxt);
            } else {
              return $this->co_reg->document->getJson( array( 'errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'Error de configuraci&oacute;n. No se encontr&oacute; el texto ['.($lp_oldmdl->crmcntstscod=='' ? $lv_crmcntntfnew : $lv_crmcntntfupd ).']' ) );
            }

            //MAIL. Envío mail
            if ( $lv_msg!= '' && count($lv_mailcco)>0){
              $datatbl = '<table>
                          <thead><tr></tr><tr></tr></thead>
                          <tbody>
                            <tr style="padding-bottom: 1em;"><td>Estado: </td><td>'.($lv_chgstsflg == true ? '<b>' : '').$lp_prm['data']['crmcntststxt'].($lv_chgstsflg == true ? '</b>' : '').'</td></tr>
                            <tr><td style="vertical-align: top;">Comentarios: </td><td>'.($lv_chgcmtflg == true ? '<b>' : '').html_entity_decode($lp_prm['data']['crmcntcmt']).($lv_chgcmtflg == true ? '</b>' : '').'</td></tr>
                          </tbody></table>';

              $lo_eml = new tmssMail();
              
              //Si se usa como nombre de variable $lv_emlprm, entra en conflicto con los bcc al cambiar de estado
              $lv_emlprm3['to']  = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL'));
              $lv_emlprm3['bcc'] = $lv_mailcco;

              $lv_emlprm3['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ); 
              $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');  
              $lv_emlprm3['subject'] = 'Ha sido mencionado en el contacto #'.$lp_prm['data']['crmcntcod'].' - '.$lp_prm['data']['crmcnttxt'];
              $lv_usrmsg = str_replace( '[%1]', $lp_prm['data']['crmcnttxt'], $lv_msg );
              $lv_usrmsg = str_replace( '[%2]', '', $lv_usrmsg);
              $lv_usrmsg = str_replace( '[%3]', 'actualiz&oacute;', $lv_usrmsg);
              $lv_usrmsg = str_replace( '[%4]', $lp_prm['data']['crmcntcod'], $lv_usrmsg);
              $lv_usrmsg = str_replace( '[%5]', $datatbl, $lv_usrmsg);
              $lv_usrmsg = str_replace( '[%6]', 'Temasis Argentina SRL', $lv_usrmsg);
              $lv_usrmsg = str_replace( '[%9]', '', $lv_usrmsg );            
              $lv_emlprm3['bodyhtml'] = $lv_usrmsg;
              if ( !$lo_eml->send( $lv_emlprm3 ) ) {
                return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml->getError()) );
              }
            }
          }
        }
      	break;
			
			// COMPRESS IMAGE
			case '#compress_image':
			
				// TINFUSIONAR (ultimo archivo procesado 67139)
				// TINFUSIONCL (utlimo archivo procesado 76833)
				// LOGIN (utlimo archivo procesado 68003)
				// TMG (utlimo archivo procesado 76516)
				// TTRAINNING (ultimo archivo procesado 76845)
				// TPEDIATRICO (ultimo archivo procesado 54295)
				
				//set_time_limit(1800);
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

				// https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutms&act=compress_image
				$lv_path = '..\..\..\SSLfiles\/' . $this->co_reg->sec->buscod . '\/';
				$lv_quality = 50;
				
				// obtengo los archivos de tipo IMAGE/JPEG
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]f.fletyp'.chr(9).'='.chr(9).chr(9).'IMAGE/JPEG'.chr(9).chr(9).
																			'[~fltrow~]f.flecod'.chr(9).'>'.chr(9).chr(9).'2735'.chr(9).chr(9). 
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewmaxrec'=>'99999');
				$lo_rs = $lo_flemdl->getList($lv_prm);
				var_dump('archivos recuperados '.count($lo_rs));
				var_dump($lo_flemdl->getsysdata('sqlstm'));
				
				// recorro cada uno y armo salida
				foreach( $lo_rs as $lv_row){
					$lv_dbfile = $lv_path . $lv_row['flecod'] . '.tmss';
					$lv_dbbackupfile = $lv_path . 'backup\/' . $lv_row['flecod'] . '.tmss';
					if( file_exists($lv_dbfile) ){
						// hago copia de seguridad (para mantener el original)
						if (!copy($lv_dbfile, $lv_dbbackupfile)) {
							var_dump('ERROR al copiar archivo ['.$lv_dbfile.']->['.$lv_dbbackupfile.']');
						} else {
							// creo imagen a partir de un archivo
							$lv_img = imagecreatefromjpeg($lv_dbfile);
							if(!$lv_img){
								var_dump('ERROR al crear imagen desde archivo ['.$lv_dbfile.']');
							} else {
								// guardo nueva imagen
								if( !imagejpeg($lv_img, $lv_dbfile, $lv_quality) ){
									var_dump('ERROR al grabar imagen con nueva calidad ['.$lv_dbfile.']');
								} else {
									var_dump('OK ['.$lv_dbfile.']');
								}
							}
						}
					// si no existe el archivo borro el puntero en base de datos
					} else {
						$lv_ret = $lo_flemdl->delete( array('flecod'=>$lv_row['flecod']) );
						var_dump('BORRANDO archivo ['.$lv_dbfile.']');
						var_dump($lv_ret);
					}
				}
				
				// recorro cada uno y armo salida
				//$sourceFile = '..\..\..\SSLfiles\TINFUSIONAR\30475.tmss';
				//$outputFile = '..\..\..\SSLfiles\TINFUSIONAR\compressed-30475.jpg';
				//$outputQuality = 50;
				//$imageLayer = imagecreatefromjpeg($sourceFile);
				//imagejpeg($imageLayer, $outputFile, $outputQuality);
				//imagepng($imageLayer, $outputFile, $outputQuality)
				//imagegif($imageLayer, $outputFile, $outputQuality);
				//imagewbmp($imageLayer, $outputFile, $outputQuality);
				
				ini_set('memory_limit', $lv_lmtmem);
				break;			
		}
	}
}
?>