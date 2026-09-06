<?php 
final class sysappdshController extends tmssController {
	const MODEL = '';
	const VIEW  = 'sysappdsh';
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
		
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// D A S H B O A R D
      case '#dsh':
				$lo_post = $this->co_reg->request->post;
				$lv_typ = ($lo_post['typ']??'');
				
				$lv_strdte = new DateTime();
				$lv_strdte->sub( new DateInterval('P30D') );
				
				$lv_strdte180 = new DateTime();
				$lv_strdte180->sub( new DateInterval('P180D') );
				
				$lv_strdte90 = new DateTime();
				$lv_strdte90->sub( new DateInterval('P90D') );
				
				if( $lv_typ=='sublst' ){	// suscripciones
					$lo_submdl = $this->co_reg->load->model('sysfncsub');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cuscodext'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->buscod .chr(9).chr(9).
																				'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9).
																				'[~fltrow~]getdate() between s.sysfncsubstrdte and s.sysfncsubenddte'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
																				);
					$lo_rs = $lo_submdl->getList( $lv_prm );
					return $this->co_reg->document->getJson( $lo_rs );
				}
				
				// ESTADISTICAS. obtener estadística de acceso de los últimos 30 días
				if( $lv_typ=='stdnav' || $lv_typ=='stddev' || $lv_typ=='stdoss' || $lv_typ=='stdtme' ){
					$lo_usrlogmdl = $this->co_reg->load->model('syssecusrlog');
					switch( $lv_typ ){
						case 'stdnav':		// por Navegador
							$lv_prm = array('vewfldflt' =>'[~fltrow~]l.usrlogdte'.chr(9).'>='.chr(9).chr(9).$lv_strdte->format('Y-m-d') .chr(9).chr(9),
															'vewfldgrp'=>'dbo.getTagValue(^BROWSER^,l.usrlogatrval001)',
															'vewfldgrpcal'=>'dbo.getTagValue(^BROWSER^,l.usrlogatrval001) as NavNme, Count(*) as NavQty',
															'vewfldord'=>'count(*) desc'
															);
							$lo_rs = $lo_usrlogmdl->getList($lv_prm);
							return $this->co_reg->document->getJson( $lo_rs );
							break;
						
						case 'stddev':		// por Tipo de Dispositivo
							$lv_prm = array('vewfldflt' =>'[~fltrow~]l.usrlogdte'.chr(9).'>='.chr(9).chr(9).$lv_strdte->format('Y-m-d') .chr(9).chr(9),
															'vewfldgrp'=>'dbo.getTagValue(^DEVICE_TYPE^,l.usrlogatrval001)',
															'vewfldgrpcal'=>'dbo.getTagValue(^DEVICE_TYPE^,l.usrlogatrval001) as DevNme, Count(*) as DevQty',
															'vewfldord'=>'count(*) desc'
															);
							$lo_rs = $lo_usrlogmdl->getList($lv_prm);
							return $this->co_reg->document->getJson( $lo_rs );
							break;
						
						case 'stdoss':		// por Sistema Operativo
							$lv_prm = array('vewfldflt' =>'[~fltrow~]l.usrlogdte'.chr(9).'>='.chr(9).chr(9).$lv_strdte->format('Y-m-d') .chr(9).chr(9),
															'vewfldgrp'=>'dbo.getTagValue(^PLATFORM^,l.usrlogatrval001)',
															'vewfldgrpcal'=>'dbo.getTagValue(^PLATFORM^,l.usrlogatrval001) as OSSNme, Count(*) as OSSQty',
															'vewfldord'=>'count(*) desc'
															);
							$lo_rs = $lo_usrlogmdl->getList($lv_prm);
							return $this->co_reg->document->getJson( $lo_rs );
							break;
						
						case 'stdtme':		// por Hora de Acceso
							$lv_prm = array('vewfldflt' =>'[~fltrow~]l.usrlogdte'.chr(9).'>='.chr(9).chr(9).$lv_strdte->format('Y-m-d') .chr(9).chr(9),
															'vewfldgrp'=>'datepart(hour,l.usrlogdte)',
															'vewfldgrpcal'=>'datepart(hour,l.usrlogdte) as AccTme, Count(*) as AccQty'
															);
							$lo_rs = $lo_usrlogmdl->getList($lv_prm);
							return $this->co_reg->document->getJson( $lo_rs );
							break;
					}
				}
				
				// DATOS. cliente / facturas / mensajes / tickets / log de cambios 
				if( $lv_typ=='cusdat' || $lv_typ=='invlst' || $lv_typ=='msglst' || $lv_typ=='tktlst' || $lv_typ=='loglst' ){

					// NOTA: en los parametros la clave debe ser guardada con encriptacion de doble sentido
					//       para luego poder utilizarla en la llamada API. Utilizamos lv_key como constante
					//       para encriptar/desencriptar la clave
          // 			 $this->co_reg->sec->encrypt('fWyt/QWG9qtEq643Aw==',$lv_key);
					
					$lv_key = 'gALixb4AXrxoV8Y';
					
					// obtengo parametros de conexion
          $lo_submdl = $this->co_reg->load->model('sysappmdlprm');
					$lv_prm = array('vewfldflt' => '[~fltrow~]mdlcod'.chr(9).'='.chr(9).chr(9). 'SYS' .chr(9).chr(9) );
					$lo_rs = $lo_submdl->getList( $lv_prm );
					
					// recupero parametros
          $lv_data = (count($lo_rs)>0?$lo_rs[0]['mdlatrval001']:'');
					$lv_prm_buscod = $this->co_reg->document->getTagValue($lv_data,'APP-DSH-BUSCOD');
					$lv_prm_prytkn = $this->co_reg->document->getTagValue($lv_data,'APP-DSH-PROYECT-TOKEN');
					$lv_prm_usrcod = $this->co_reg->document->getTagValue($lv_data,'APP-DSH-USRCOD');
					$lv_prm_usrpsw = $this->co_reg->document->getTagValue($lv_data,'APP-DSH-USRPSW');

					// verifico que los parametros esten informados
					if( $lv_prm_buscod=='' || $lv_prm_prytkn=='' || $lv_prm_usrcod=='' || $lv_prm_usrpsw=='' ){
						return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'Datos de conexion a Temasis no proporcionados.') );
					}
          
					// obtengo token de sesion de usuario
					$lo_pryctr = $this->co_reg->load->controller('sysapppry');
					$lv_prm = array('apires'=>$lv_prm_buscod, 'prytkn'=>$lv_prm_prytkn, 'usrcod'=>$lv_prm_usrcod, 'usrpwd'=>$this->co_reg->sec->decrypt($lv_prm_usrpsw, $lv_key));
					$lv_ret = $lo_pryctr->callRemoteApi( $lv_prm );
					if($lv_ret['errtyp']=='S'){ $lv_prm['usrtkn'] = $lv_ret['token']; } else { return $this->co_reg->document->getJson($lv_ret); }
					
					// obtengo datos de cliente (codigo externo = BUSCOD)
					if($lv_ret['errtyp']=='S'){
						$lv_prm['apires'] = $lv_prm_buscod.'/sales-customers/search?code=EQ$'.$this->co_reg->sec->buscod;
						$lv_ret = $lo_pryctr->callRemoteApi( $lv_prm );
						$lv_cuscod = $lv_ret['data'][0]['id']??'';
					}
					
					switch( $lv_typ ){
						case 'cusdat':		// datos del cliente
							return $this->co_reg->document->getJson( $lv_ret );
							break;
						
						case 'invlst':		// facturas
							$lv_prm['apires'] = $lv_prm_buscod.'/sales-invoices/search?destination_type=EQ$sls_cus&destination_id=EQ$'.$lv_cuscod.'&status=EQ$c&date=GT$'.$lv_strdte90->format('Y-m-d').'&_order=date_desc';
							$lv_ret = $lo_pryctr->callRemoteApi( $lv_prm );
							foreach($lv_ret['data'] as &$lv_row){
								$lv_row['datestr'] = substr($lv_row['date']['date'], 0, 10);
								$lv_row['duedatestr'] = substr($lv_row['duedate']['date'], 0, 10);
							}
							return $this->co_reg->document->getJson( $lv_ret );
							break;
						
						case 'tktlst':		// tickets
							$lv_prm['apires'] = $lv_prm_buscod.'/crm-contacts/search?status_closed=EQ$0&contact_type=EQ$sls_cus&source_id=EQ$'.$lv_cuscod.'&_order=crmcntdte_desc';
							$lv_ret = $lo_pryctr->callRemoteApi( $lv_prm );
							return $this->co_reg->document->getJson( $lv_ret );
							break;
						
						case 'loglst':		// log de cambios
							$lv_prm['apires'] = $lv_prm_buscod.'/crm-contacts/search?status_closed=EQ$1&last_update=GT$'.$lv_strdte->format('Y-m-d').'&type_name=EQ$sistema&motive_name=IN$error;mejora&_order=date_desc';
							$lv_ret = $lo_pryctr->callRemoteApi( $lv_prm );
							return $this->co_reg->document->getJson( $lv_ret );
							break;
					}
				}
				
				return $this->co_reg->document->getView( 'sysappdsh' );
        break;
		}
  }
}
?>