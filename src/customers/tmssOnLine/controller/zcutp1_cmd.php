 <?php
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//
//	 I N T E R F A C E S    -    T A R E A S    P R O G R A M A D A S
//
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
final class zcutp1_cmdController extends tmssController {
  protected $co_reg; 
  private $data = array();
   
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
		 
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {
	
    // all methods of this class are for logged users
    // check user session
    //$this->co_reg->request->post['ajax']='1';
    //$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    //if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

    // acciones
    switch( $lp_act ) {
			
			
			// ----------------------------------------------------------------------
			//
			//   STOCK BAJO MINIMO - NOTIFICACION AUTOMATICA
			//
			// ----------------------------------------------------------------------
      case 'C1':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=C1&prm_to=grusso@teaminfusion.com
				
        $lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';
				
				// obtengo todos los stocks bajo mínimo
				$lo_stkmatstkmdl = $this->co_reg->load->moMdel('stkmatstk');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        //,'vewfldord'=>'m.mattxt'
												);
				$lo_rs = $lo_stkmatstkmdl->underMinimum( $lv_prm );
        $lv_data_sqlstm = $lo_stkmatstkmdl->getsysdata('sqlstm');
        //echo '<code>'.($lv_data_sqlstm).'</code>';
				//unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if ( count($lo_rs)==0 ) { echo 'No existen stocks bajo mínimo.'; return; }
				
				// obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => 'STKMATSTKMINNTF', 'txtsys' => 1), false) ){
          $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
				/* Consulto las OC realizadas pare los materiales */
        
        $lo_ordmatmdl = $this->co_reg->load->model('buyordmat');
        $lv_matlst = array();
        foreach( $lo_rs as $lo_row) {
        	$lv_matlst[]=$lo_row['matcod'];
        }
        $lv_ordprm=array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_matlst) .chr(9).chr(9).
																			 '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                         							 '[~fltrow~]om.sysdoctrecod'.chr(9).'IN'.chr(9).chr(9). 'N' .chr(9).chr(9)
                        );
        $lo_rsord= $lo_ordmatmdl->getList($lv_ordprm);
        
        $lv_ordmatlst=array();
        foreach( $lo_rsord as $lo_ordrow) {
        	$lv_ordmatlst[$lo_ordrow['matcod']]['buyordcod']=$lo_ordrow['buyordcod'];
          $lv_ordmatlst[$lo_ordrow['matcod']]['matqty']=$lo_ordrow['matqty'];
        }
        
        
				// recorro todos los stocks bajo punto mínimo
				$lv_usrmsgrow = '';
        //echo $lo_ordmatmdl->getsysdata('sqlstm');
        //var_dump($lv_ordmatlst);
				for($i=0; $i<count($lo_rs); $i++) {
          $lv_octxt=isset($lv_ordmatlst[$lo_rs[$i]['matcod']])?('OC: '.$lv_ordmatlst[$lo_rs[$i]['matcod']]['buyordcod'].' Cant: '.$lv_ordmatlst[$lo_rs[$i]['matcod']]['matqty']):'';
          $lv_buyordcod=isset($lv_ordmatlst[$lo_rs[$i]['matcod']])?($lv_ordmatlst[$lo_rs[$i]['matcod']]['buyordcod']):'';
          $lv_matqty=isset($lv_ordmatlst[$lo_rs[$i]['matcod']])?($lv_ordmatlst[$lo_rs[$i]['matcod']]['matqty']):'';
          
					$lv_usrmsgrow .= '<tr>'.
															//'<td>'.$lo_rs[$i]['stkobjtyp'].'</td>'.
															'<td>'.$lo_rs[$i]['stkobjtxt'].'</td>'.
															'<td>'.$lo_rs[$i]['cnttxt'].'</td>'.
															'<td>'.$lo_rs[$i]['matcod'].'</td>'.
															'<td>'.$lo_rs[$i]['matcodext'].'</td>'.
															'<td>'.$lo_rs[$i]['mattxt'].'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatstk'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatlvlmin'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatlvlmax'],2).'</td>'.
															'<td>'.number_format($lo_rs[$i]['stkmatptoped'],2).'</td>'.
            									//'<td>'. $lv_octxt . '</td>'.
            									'<td>'. $lv_buyordcod . '</td>'.
            									'<td>'. $lv_matqty . '</td>'.
														'</tr>';
				}
				// determino destinatarios
				$lv_mailto = array();
        //$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        //$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
				
				// envío mail
				if ( count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
					$lv_emlprm['subject'] = 'Logindoor - Stocks bajo minimo';
					$lv_usrmsgout = $lv_usrmsg;
					$lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%2]', 'Stocks Bajo Minimo', $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%3]', $lv_usrmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
					$lv_emlprm['bodyhtml'] = $lv_usrmsgout;
          //return $lv_usrmsgout;
          //break;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
					}
				}
				
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
			
			
			// ----------------------------------------------------------------------
			//
			//   DOCUMENTACION VENCIDA - NOTIFICACION AUTOMATICA
			//
			// ----------------------------------------------------------------------
      case 'C2':
				$lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';

				// obtengo todos los clientes activos
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_cusrs = $lo_slscusmdl->getList( $lv_prm, null, null, false );
				//unset($lo_cusrs['data_sqltxt']); unset($lo_cusrs['data_sqlprm']); unset($lo_cusrs['data_sqlstm']);
				
				// obtengo todos los proveedores activos
				$lo_buysupmdl = $this->co_reg->load->model('buysup');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_suprs = $lo_buysupmdl->getList( $lv_prm, null, null, false );
				//unset($lo_suprs['data_sqltxt']); unset($lo_suprs['data_sqlprm']); unset($lo_suprs['data_sqlstm']);

				// obtengo la documentación vencida (-1 mes) y NO vencida (+1 mes)
				$lv_curdte = new DateTime(date('Y-m-d'));
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-1 month');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+1 month');
				
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'>='.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'<='.chr(9).chr(9). $lv_enddte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTHABDOC'.chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );
				//unset($lo_flers['data_sqltxt']); unset($lo_flers['data_sqlprm']); unset($lo_flers['data_sqlstm']);
				
				// obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => 'GRLFLEDUEDTENTF', 'txtsys' => 1), false) ){
          $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}

				// recorro todos los clientes
				$lv_cusmsgrow = '';
				foreach($lo_cusrs as $lv_cusrow) {
					$lv_fnd = false;
					foreach($lo_flers as $lv_flerow) {
						if ( $lv_flerow['flesrctyp']=='SLS_CUS' && $lv_flerow['flesrccod']==$lv_cusrow['cuscod'] ) {
							$lv_fnd = true;
							$lv_dtedif = date_diff( $lv_curdte, $lv_flerow['fleduedte'] );							
							if ( $lv_curdte > $lv_flerow['fleduedte'] ) { $lv_dif = -1; } else { $lv_dif = 1; }
							$lv_cusmsgrow .= '<tr>'.
																	'<td>'.$lv_cusrow['cuscod'].'</td>'.
																	'<td>'.$lv_cusrow['custxt'].'</td>'.
																	'<td>'.$lv_flerow['fleduedtecnv'].'</td>'.
																	'<td>'.($lv_dtedif->format('%d')*$lv_dif<0?'Vencida':'').'</td>'.
																	'<td>'.$lv_dtedif->format('%d')*$lv_dif.'</td>'.
																'</tr>';
						}
					}
					if ( $lv_fnd==false ) {
						$lv_cusmsgrow .= '<tr>'.
																'<td>'.$lv_cusrow['cuscod'].'</td>'.
																'<td>'.$lv_cusrow['custxt'].'</td>'.
																'<td>&nbsp;</td>'.
																'<td>No proporcionada</td>'.
																'<td>&nbsp;</td>'.
															'</tr>';
					}
				}

				// recorro todos los clientes
				$lv_supmsgrow = '';
				foreach($lo_suprs as $lv_suprow) {
					$lv_fnd = false;
					foreach($lo_flers as $lv_flerow) {
						if ( $lv_flerow['flesrctyp']=='BUY_SUP' && $lv_flerow['flesrccod']==$lv_suprow['supcod'] ) {
							$lv_fnd = true;
							$lv_dtedif = date_diff( $lv_curdte, $lv_flerow['fleduedte'] );							
							if ( $lv_curdte > $lv_flerow['fleduedte'] ) { $lv_dif = -1; } else { $lv_dif = 1; }
							$lv_supmsgrow .= '<tr>'.
																	'<td>'.$lv_suprow['supcod'].'</td>'.
																	'<td>'.$lv_suprow['suptxt'].'</td>'.
																	'<td>'.$lv_flerow['fleduedtecnv'].'</td>'.
																	'<td>'.($lv_dtedif->format('%d')*$lv_dif<0?'Vencida':'').'</td>'.
																	'<td>'.$lv_dtedif->format('%d')*$lv_dif.'</td>'.
																'</tr>';
						}
					}
					if ( $lv_fnd==false ) {
						$lv_supmsgrow .= '<tr>'.
																'<td>'.$lv_suprow['supcod'].'</td>'.
																'<td>'.$lv_suprow['suptxt'].'</td>'.
																'<td>&nbsp;</td>'.
																'<td>No proporcionada</td>'.
																'<td>&nbsp;</td>'.
															'</tr>';
					}
				}
				
				// determino destinatarios
				$lv_mailto = array();
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val); 
				}
				
				// envío mail
				if ( count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
					$lv_emlprm['subject'] = 'Logindoor - Habilitaciones a vencer/vencidas';
					$lv_usrmsgout = $lv_usrmsg;
					$lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%2]', 'Habilitaciones a vencer/vencfidas', $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%3]', $lv_cusmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%4]', $lv_supmsgrow, $lv_usrmsgout );
					$lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
					$lv_emlprm['bodyhtml'] = $lv_usrmsgout;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
					}
				}
				
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
			
			
      case 'sendcusdocexp':
        $lv_errcod = 0;
				$lv_errtxt = '';
        // obtengo todos los clientes activos
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_cusrs = $lo_slscusmdl->getList( $lv_prm, null, null, false );
        
        $lo_suplst=array();
        foreach( $lo_cusrs as $lv_suprow) {
					$lo_cuslst[$lv_suprow['cuscod']]=$lv_suprow['custxt'];
				}
                
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'GRLFLEDUE'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_FLE'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_msgrs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_msgrs['data_sqlprm']); unset($lo_msgrs['data_sqltxt']); unset($lo_msgrs['data_sqlstm']);
				if( count($lo_msgrs)!=0 ) {
					$lv_usrmsg = $lo_msgrs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        
        
        // obtengo la documentación vencida (-1 mes) y NO vencida (+1 mes)
				$lv_curdte = new DateTime(date('Y-m-d'));
        
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-1 day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+1 month');
        
				
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'>='.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'<='.chr(9).chr(9). $lv_enddte->format('Y-m-d') .chr(9).chr(9).
                        						 '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
																		 '[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTHABDOC'.chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );        
        
        // determino destinatarios
        $lv_mailto = array();
				$lp_prm['to']= isset($lp_prm['to'])?$lp_prm['to']:'';
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
        /*
        $lv_env = $this->co_reg->config->get('environmet');
				if($lv_env=='dev'){
        	$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        }
        */
        $lv_usrmsgout='';
        foreach($lo_flers as $lv_flerow) { 
          
          $lv_custxt=$lo_cuslst[$lv_flerow['flesrccod']];
          $lv_doctxt=$lv_flerow['fletyptxt'];
         	$lv_daydif=  $lv_curdte->diff($lv_flerow['fleduedte'])->days;
          if(($lv_daydif==10 || $lv_daydif==15|| $lv_daydif==20|| $lv_daydif==30|| $lv_daydif==0) && $lv_custxt!='' ){
            // envío mail
            if ( count($lv_mailto)>0 ) {
              $lo_eml = new tmssMail();
              $lv_emlprm['to'] = $lv_mailto;
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Logindoor') );
              $lv_emlprm['subject'] = 'Logindoor - Habilitaciones a vencer/vencidas';
              $lv_usrmsgout = $lv_usrmsg;
              $lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%2]', 'Documentacion a vencer/vencidas', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%3]', '<b>'.$lv_doctxt.'</b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%4]', 'cliente <b>' . $lv_custxt . '</b>' , $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%5]', '<b>'.($lv_daydif>0?'por vencer ':'vencida '). ($lv_daydif>0?'en '. $lv_daydif . ' dias':' ').'<b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
              $lv_emlprm['bodyhtml'] = $lv_usrmsgout;
              if ( $lo_eml->send( $lv_emlprm ) ) {
                $lv_errcod = '0';
                $lv_errtxt = 'Enviado';
              } else {
                $lv_errcod = '-1';
                $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              }
            }
          }
        }  
        $lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
        break;
        
      case 'sendsupdocexp':
        $lv_errcod = 0;
				$lv_errtxt = '';
        
        // obtengo todos los proveedores activos
				$lo_buysupmdl = $this->co_reg->load->model('buysup');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_suprs = $lo_buysupmdl->getList( $lv_prm, null, null, false );
        
        $lo_suplst=array();
        foreach( $lo_suprs as $lv_suprow) {
					$lo_suplst[$lv_suprow['supcod']]=$lv_suprow['suptxt'];
				}
                
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'GRLFLEDUE'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_FLE'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_msgrs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_msgrs['data_sqlprm']); unset($lo_msgrs['data_sqltxt']); unset($lo_msgrs['data_sqlstm']);
				if( count($lo_msgrs)!=0 ) {
					$lv_usrmsg = $lo_msgrs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        
        
        // obtengo la documentación vencida (-1 mes) y NO vencida (+1 mes)
				$lv_curdte = new DateTime(date('Y-m-d'));
        
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-1 day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+1 month');
        
				
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'>='.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9).chr(9).
																		 '[~fltrow~]f.fleduedte'.chr(9).'<='.chr(9).chr(9). $lv_enddte->format('Y-m-d') .chr(9).chr(9).
                        						 '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'BUY_SUP'.chr(9).chr(9).
																		 '[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTHABDOC'.chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );        
        
        // determino destinatarios
        $lv_mailto = array();
				$lp_prm['to']= isset($lp_prm['to'])?$lp_prm['to']:'';
				$lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
        /*
        $lv_env = $this->co_reg->config->get('environmet');
				if($lv_env=='dev'){
        	$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        }
        */
        $lv_usrmsgout='';
        foreach($lo_flers as $lv_flerow) { 
          
         	$lv_daydif=  $lv_curdte->diff($lv_flerow['fleduedte'])->days;
          $lv_suptxt=$lo_suplst[$lv_flerow['flesrccod']];
          $lv_doctxt=$lv_flerow['fletyptxt'];
          if(($lv_daydif==10 || $lv_daydif==15|| $lv_daydif==20|| $lv_daydif==30|| $lv_daydif==0) && $lv_suptxt!='' ){
            // envío mail
            if ( count($lv_mailto)>0 ) {
              $lo_eml = new tmssMail();
              $lv_emlprm['to'] = $lv_mailto;
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
              $lv_emlprm['subject'] = 'Logindoor - Habilitaciones a vencer/vencidas';
              $lv_usrmsgout = $lv_usrmsg;
              $lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%2]', 'Documentacion a vencer/vencidas', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%3]', '<b>'.$lv_doctxt.'</b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%4]', 'cliente <b>' . $lv_suptxt . '</b>' , $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%5]', '<b>'.($lv_daydif>0?'por vencer ':'vencida '). ($lv_daydif>0?'en '. $lv_daydif . ' dias':' ').'<b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
              $lv_emlprm['bodyhtml'] = $lv_usrmsgout;
              if ( $lo_eml->send( $lv_emlprm ) ) {
                $lv_errcod = '0';
                $lv_errtxt = 'Enviado';
              } else {
                $lv_errcod = '-1';
                $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              }
            }
          }
        }  
        $lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
        break;
      /*   */
      case 'senddocexp':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=senddocexp
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=senddocexp&prm_mdlcod=DOCEXPPAT
        //Recordar reemplazar las actividades de clientes y proveedores por esta actividad en logindoor
        $lv_mdlcod = $lp_prm['mdlcod'];
                
        $lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';
        /*Obtengo los parametros de empresa*/
        
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>$lv_mdlcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "'.$lv_mdlcod.'"';
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-100','errtxt'=>'NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "'.$lv_mdlcod.'"'));//$lv_buffer;
          break;
        }
        
        //$lv_fletypcodext 		= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'fletypcodext');						// COD EXT DE TIPO ARCHICO
        $lv_fletypcodext 		= str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'fletypcodext'))); // COD EXT DE TIPO ARCHICO
        
        $lv_objsrctyp 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'objsrctyp');							// OBJETO
        
        //$lv_chkday 					= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkamtday');							// Cantidad días
        
        $lv_chkday 					= str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkamtday'))); 							// Cantidad días
				$lv_sndeml 					= explode(';',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'sendmail'));	// MAILS
        $lv_msgtxtcod 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxtcod');							// CODIGO DE MENSAGE
        $lv_msgtxt 					= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxt'); 								// TEXTO
        $lv_msgemlsub 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgemlsub'); 							// MAIL SUBJECT
        $lv_objmdl 					= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'objmdl'); 								// INDICE PARA OBTENER EL CODIGO DEL OBJETO
        $lv_objcodidx 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'objcodidx'); 							// INDICE PARA OBTENER EL CODIGO DEL OBJETO
        $lv_objtxtidx 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'objtxtidx'); 							// INDICE PARA OBTENER EL TEXTO DEL OBJETO
        $lv_duedtefrm 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'duedtefrm'); 							// DÍAS DESDE
        $lv_duedteto 				= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'duedteto'); 							// DÍAS HASTA 
        $lv_objstsidx 			= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'objstsidx'); 							// INDICE PARA OBTENER EL TEXTO DEL OBJETO

        
        // obtengo la documentación por vencer (-30 dias)
				$lv_curdte = new DateTime(date('Y-m-d'));

        // obtengo todos los proveedores activos        
				$lo_objmdl = $this->co_reg->load->model($lv_objmdl);
				$lv_prm = array('vewfldflt'=>'[~fltrow~]'.$lv_objstsidx.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_objrs = $lo_objmdl->getList( $lv_prm, null, null, false );
        //echo '<textarea>'.$lo_objmdl->getsysdata('sqlstm').'</textarea>';
        
        $lo_objlst=array();
        foreach( $lo_objrs as $lv_obj) {
					$lo_objlst[$lv_obj[$lv_objcodidx]]=$lv_obj[$lv_objtxtidx];
				}
				/*
				*/
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        						 '[~fltrow~] DATEDIFF(day,f.fleduedte,getdate())' .chr(9).'IN'.chr(9).chr(9). $lv_chkday  .chr(9).chr(9).
                        						 '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).$lv_objsrctyp.chr(9).chr(9).
                        						 '[~fltrow~] ft.fletypcodext ' .chr(9).'IN'.chr(9).chr(9). $lv_fletypcodext  .chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );
        
        //echo '<textarea>'.$lo_flemdl->getsysdata('sqlstm').'</textarea>';
        
        
        /* OBTENGO EL MENSAGE A ENVIAR */
        $lv_usrmsg='';
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if ( $lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE EL MENSAGE CON EL CODIGO ' . $lv_msgtxtcod;
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-100','errtxt'=>'NO EXISTE EL MENSAJE CON EL CÓDIGO '.$lv_msgtxtcod));//$lv_buffer;
          break;
        }
        $lv_usrmsg=$lo_txtmdl->txttxt;        
        
        // determino destinatarios
        $lv_mailto = array();
				foreach( $lv_sndeml as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				} 
        $lv_usrmsgout='';
        foreach($lo_flers as $lv_flerow) { 
          
         	$lv_daydif=  $lv_curdte->diff($lv_flerow['fleduedte'])->days;
          if(isset($lo_objlst[$lv_flerow['flesrccod']])){
          	$lv_objtxt=$lo_objlst[$lv_flerow['flesrccod']];
          }else{
            continue;
          }
          $lv_doctxt=$lv_flerow['fletyptxt'];
          // envío mail
            if ( count($lv_mailto)>0 ) {
              $lo_eml = new tmssMail();
              $lv_emlprm['to'] = $lv_mailto;
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=> $this->co_reg->sec->bustxt) );
              $lv_emlprm['subject'] = $lv_msgemlsub;
              $lv_usrmsgout = $lv_usrmsg;
              $lv_usrmsgout = str_replace( '[%4]', '', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%2]', $lv_msgemlsub, $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%3]', '<b>'.$lv_msgtxt.'</b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%4]', '<b>' . $lv_objtxt . '</b>' , $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%5]', $lv_doctxt.' <b>'.($lv_flerow['fleduedte'] > $lv_curdte?'por vencer ':'vencida desde '). ' el día ' . $lv_flerow['fleduedte']->format('d/m/Y').'<b>', $lv_usrmsgout );
              //$lv_usrmsgout = str_replace( '[%5]', $lv_doctxt.' <b>'.($lv_flerow['fleduedte'] < $lv_curdte?'por vencer ':'vencida '). ($lv_flerow['fleduedte'] < $lv_curdte? 'en '. $lv_daydif . ' dias': 'hace '. $lv_daydif . ' dias').'<b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%9]', '', $lv_usrmsgout );
              $lv_emlprm['bodyhtml'] = utf8_decode($lv_usrmsgout);
              //echo $lv_usrmsgout;
              if ( $lo_eml->send( $lv_emlprm ) ) {
                $lv_errcod = '0';
                $lv_errtxt = 'Enviado';
                return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'0','errtxt'=>'Enviado'));
              } else {
                $lv_errcod = '-1';
                echo 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
                $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.'));
              }
            }
          //}
        }  
        $lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
        break;
      /* */
      case 'sendcntexp':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=sendcntexp
        $lv_buffer='';
        // obtengo la documentación vencida (-1 mes) y NO vencida (+1 mes)
				$lv_curdte = new DateTime(date('Y-m-d'));
        //dbo.GetTagValue(^DUEDTE^,c.crmcntatr)
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('+1 day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+1 month');
        /*CONTACTOS VENCIDOS*/
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
				$lv_cntprm = array('vewfldflt'=>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                        '[~fltrow~]CONVERT (datetime, DBO.GETTAGVALUE(^DUEDTE^,C.CRMCNTATR), 103)'.chr(9).'<='.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9).chr(9).
                                        '[~fltrow~] DBO.GETTAGVALUE(^DUEDTE^,C.CRMCNTATR)'.chr(9).'<>'.chr(9).chr(9). '' .chr(9).chr(9),
													 'vewfldord'=>'CONVERT (datetime, DBO.GETTAGVALUE(^DUEDTE^,C.CRMCNTATR), 103)'
												);
				$lo_cnt_rs = $lo_cntmdl->getList( $lv_cntprm, null, null, false );
        
        
        /*E S T A D O S   C O N T A C T O S */
        $lo_cntstsmdl = $this->co_reg->load->model('crmcntsts');
				$lv_cntstsprm = array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           					 		'[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9),
												'vewfldord'=>'s.crmcntstscod'
												);
				$lo_cntsts_rs = $lo_cntstsmdl->getList( $lv_cntstsprm, null, null, false );
        $lo_cntstslst=array();
        foreach($lo_cntsts_rs as $lv_rowsts){
          $lo_cntstslst[]=$lv_rowsts['crmcntstscod'];
          
        }
        
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'GRLFLEDUE'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_FLE'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_msgrs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_msgrs['data_sqlprm']); unset($lo_msgrs['data_sqltxt']); unset($lo_msgrs['data_sqlstm']);
				if( count($lo_msgrs)!=0 ) {
					$lv_usrmsg = $lo_msgrs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        
        // determino destinatarios
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'EDUEM'));
        $lv_mailto = array();
				$lv_mailtoarr = explode(';',$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'eduemlsnd'));
        //var_dump($lv_mailtoarr);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}       
        
        //echo $lo_cntmdl->getsysdata('sqlstm');
        //var_dump($lv_mailto);
        
        $lv_usrmsgout='';
        foreach($lo_cnt_rs as $lv_cntrow) { 
          $lv_strduedte=$this->co_reg->document->gettagvalue($lv_cntrow['crmcntatr'],'duedte');
          $lv_crmcntcod=$lv_cntrow['crmcntcod'];
          $lv_crmcnttxt=$lv_cntrow['crmcnttxt'];
          $lv_crmcntstscls=in_array($lv_cntrow['crmcntstscod'], $lo_cntstslst);
          strtotime($lv_strduedte);
          $lv_duedte = date_create_from_format('d/m/Y', $lv_strduedte);
          //var_dump($lv_duedte);
          //$lv_duedte =  date($lv_strduedte);
          $lv_daydif=  $lv_curdte->diff($lv_duedte)->days;
          //echo  $lv_strduedte . '->' . $lv_daydif ; echo '<br>';
          if(($lv_daydif==2 || $lv_daydif==0)  && !$lv_crmcntstscls){
          	// envío mail
            if ( count($lv_mailto)>0 ) {
              $lo_eml = new tmssMail();
              $lv_emlprm['to'] = $lv_mailto;
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
              $lv_emlprm['subject'] = $this->co_reg->sec->bustxt.' - Contacto CRM a vencer/vencido';
              $lv_usrmsgout = $lv_usrmsg;
              $lv_usrmsgout = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%2]', 'Contacto CRM  a vencer/vencido', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%3]', '<b>('.$lv_crmcntcod.')</b>', $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%4]', '<b>' . $lv_crmcnttxt . '</b>' , $lv_usrmsgout );
              $lv_usrmsgout = str_replace( '[%5]', '<b>'.($lv_daydif>0?'vencida ':'vencida '). ($lv_daydif>0?'hace '. $lv_daydif . ' dias':' ').'<b>', $lv_usrmsgout );
              /*
              $lv_usrmsgout = str_replace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsgout );
              */
              $lv_emlprm['bodyhtml'] = $lv_usrmsgout;
              if ( $lo_eml->send( $lv_emlprm ) ) {
                $lv_errcod = '0';
                $lv_errtxt = 'Enviado';
              } else {
                $lv_errcod = '-1';
                $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              }
            } 
          }
        }
        
        return $lv_buffer;
        break;
      case 'sendmatexp':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=sendmatexp
        $lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';
        /*Obtengo los parametros de empresa*/
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'SMMEX')) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "SMMEX"';
					return $lv_buffer;
          break;
        }

        
        $lv_strloccod = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'strloccod');						// DEPOSITOS
       	$lv_matclscod = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'matclscod'); 						// CLASE DE DOCUMENTO MATERIALES
        $lv_msgtxtcod = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxtcod');						// MENSAGE
				$lv_sndeml 		= explode(';',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'sndeml'));	// MAILS
        $lv_msgemlsub = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgemlsub'); 						// MAIL SUBJECT
        $lv_duedtefrm = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'duedtefrm'); 						// DÍAS DESDE
        $lv_duedteto 	= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'duedteto'); 						// DÍAS HASTA 
        $lv_msgtxt 		= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxt'); 							// TEXTO
        
        $lv_matclscod= str_replace(',', chr(10), $lv_matclscod);
        $lv_strloccod= str_replace(',', chr(10), $lv_strloccod);
        
        // obtengo la documentación por vencer (-30 dias)
				$lv_curdte = new DateTime(date('Y-m-d'));
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-'.$lv_duedtefrm.' day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+'.$lv_duedteto .' day');
        
        /* OBTENGO EL STOCK VENCIDO */
        $lo_matstk = $this->co_reg->load->model('stkmatstk');
        $lv_prmprm = array('vewfldflt' =>'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lv_matclscod  .chr(9).chr(9).
                           							 '[~fltrow~]matbchduedte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte->format('Y-m-d').chr(9).$lv_enddte->format('Y-m-d').chr(9).
                           							 '[~fltrow~]stkobjcod'.chr(9).'IN'.chr(9).chr(9). $lv_strloccod .chr(9).chr(9),
                           'vewfldord' => 'matbchduedte asc'
                          );
        
        $lo_matstkrs=$lo_matstk->getList($lv_prmprm);
        
        $lv_buf='';
        $lv_buf.='<table border="1" cellpadding="5" cellspacing="0">';
        $lv_buf.='<thead>';
        $lv_buf.='<tr style="background-color: #f1f1f1;">';
				$lv_buf.='<th>ID DE MATERIAL</th>';        
        $lv_buf.='<th>CODIGO DE MATERIAL</th>';
        $lv_buf.='<th>DESCRIPCION DEL MATERIAL</th>';
        $lv_buf.='<th>ALMACEN</th>';
        $lv_buf.='<th>CANTIDAD EN STOCK</th>';
        $lv_buf.='<th>NUMERO DE LOTE</th>';
        $lv_buf.='<th>FECHA DE VENCIMIENTO</th>';
        $lv_buf.='</tr>';
        $lv_buf.='</thead>';
       
        $lv_buf.='<tbody>';
         foreach ($lo_matstkrs as $lv_row){
          $lv_buf.='<tr>';
          $lv_buf.='<td align="center">'.$lv_row['matcod'].'</td>';
          $lv_buf.='<td align="center">'.$lv_row['matcodext'].'</td>';
          $lv_buf.='<td align="left">'.$lv_row['mattxt'].'</td>';
          $lv_buf.='<td align="left">'.$lv_row['adrnme001'].'</td>';
          $lv_buf.='<td align="right">'.intval($lv_row['matqty']).'</td>';
          $lv_buf.='<td align="right">'.($lv_row['matsercodext']==''?$lv_row['matbchcodext']:$lv_row['matsercodext']).'</td>';
          $lv_buf.='<td align="center">'.$lv_row['matbchduedte']->format('d/m/Y').'</td>';
          $lv_buf.='</tr>';//
        }
        $lv_buf.='</tbody>';
        $lv_buf.='</table>';
        
        /* OBTENGO EL MENSAGE A ENVIAR */
        $lv_usrmsg='';
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        //$lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod));
        if ( $lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE EL MENSAGE CON EL CODIGO ' . $lv_msgtxtcod;
					return $lv_buffer;
          break;
        }
        $lv_usrmsg=$lo_txtmdl->txttxt;
        
        $lv_mailto 		= array();
				foreach( $lv_sndeml as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				} 

        // envío mail
				if ( $lv_usrmsg!='') {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = $lv_msgemlsub;
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%2]', $lv_msgemlsub, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%3]', $lv_msgtxt, $lv_usrmsg );          
					$lv_usrmsg = str_replace( '[%4]', $lv_buf , $lv_usrmsg);
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
        //echo $lv_usrmsg;
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
        
        
			// ----------------------------------------------------------------------
			//
			// ENVIO DE DATOS MAESTROS DE PACIENTES A MIDLEWARE DYNAMICS
			//
			// ----------------------------------------------------------------------
      case 'sendPacientesToDynamics':
      
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lo_sysint = $this->co_reg->load->model('sysint');
        $lo_hltpat = $this->co_reg->load->model('hltpat');

				// Obtener interfaz
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'PACIENTESTODYNAMICS'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
          $this->data['err'] = array('errcod'=>-1001,'errtxt'=>'No se encontro una interfaz con codigo externo [PacientesToDynamics].');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=>implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat ); 
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}

				// cargar interfaz y atributos
        if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
          $this->data['err'] = array('errcod'=>-1002,'errtxt'=>'No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt);
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }

				// establezco conexión con base de datos
				$lo_db = new tmssDatabase($this->co_reg);
				$lp_inx = 145;
				$lp_db = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_db'); //'Middleware'
				$lp_usr = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_usr'); //'CRM'
				$lp_pwd = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_pwd'); //'Arbol45'
				$lp_srv = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'cnx_srv'); //'tp-gp.cloudapp.net';
				if ( $lp_db=='' || $lp_usr=='' || $lp_pwd=='' || $lp_srv=='' ) {
					$this->data['err'] = array('errcod'=>-1003,'errtxt'=>'Uno o más parámetros de conexión no se han establecido.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;					
				} else {
					$lo_db->set_connection_info( $lp_inx, $lp_db, $lp_usr, $lp_pwd, $lp_srv );
					if ( $lo_db->open_database($lp_inx)==false ) {
						$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo abrir la conexión de base de datos en destino.');
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar sendPacientesToMSDynamics.', 
							'applogtecinf'=> implode('-',$this->data['err']) );
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
						return false;					
					}
				}

        // Obtener el listado de pacientes cuya fechas de creación >= fecha de última ejecución
        $sysintlstrun = $lo_rs[0]['sysintlstrun']; 
        $lp_vewopt = array('vewfldflt' => '[~fltrow~]p.ctedte'.chr(9).'>='.chr(9).chr(9).date_format( ($sysintlstrun==''?'2000-01-01':$sysintlstrun),'yyyymmddHHnnss').chr(9).chr(9) );
				$lo_rs = $lo_hltpat->getList( $lp_vewopt, null, null, false );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']); unset($lo_rs['data_sqlprm']);				
        $lv_pat_qty = 0;
        $lv_pat_errqty = 0;
        $lv_pat_errtxt = '';
				foreach($lo_rs as $lv_row) {
					if($lo_hltpat->load( array('patcod'=>$lv_row['patcod']), false )==false) {
						$lv_pat_errqty++;
						$lv_pat_errtxt.=($lv_pat_errqty==0?'':',').$lo_hltpat->patcod.'(load)';
					} else {
						$lp_sqlstr = 'INSERT INTO Pacientes (paci_Codigo, clie_Codigo, loca_Codigo, pato_Codigo, paci_Nombres, paci_Apellidos, paci_DNI, paci_Direccion1, paci_Ciudad, paci_Estado, paci_Pais, paci_Telefono, paci_Telefono2) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)';
						unset($lp_sqlprm);
						$lp_sqlprm[] = $lo_hltpat->patcod;
						$lp_sqlprm[] = $lo_hltpat->cuscod;
						$lp_sqlprm[] = $lo_hltpat->adr->lndtwncod;
						$lp_sqlprm[] = $lo_hltpat->patdiacod;
						$lp_sqlprm[] = $lo_hltpat->adr->adrfrtnme;
						$lp_sqlprm[] = $lo_hltpat->adr->adrlstnme;
						$lp_sqlprm[] = $lo_hltpat->tax->taxdocnum;
						$lp_sqlprm[] = $lo_hltpat->adr->adrstr;
						$lp_sqlprm[] = $lo_hltpat->adr->adrcty;
						$lp_sqlprm[] = $lo_hltpat->adr->adrtwn;
						$lp_sqlprm[] = $lo_hltpat->adr->lndcod;
						$lp_sqlprm[] = $lo_hltpat->adr->adrphn001;
						$lp_sqlprm[] = $lo_hltpat->adr->adrphn002;
						$lo_rs = $lo_db->sqlquery( $lp_sqlstr, $lp_sqlprm, $lp_inx );
						if( $lo_rs ) {
							$lv_pat_qty++;
							echo '<logtxt>Paciente '.$lo_hltpat->patcod.' transferido.</logtxt>';
						} else {
							$lv_pat_errqty++;
							$lv_pat_errtxt.=($lv_pat_errqty==0?'':',').$lo_hltpat->patcod.'(insert)';
						}
					}
				}

        // Registrar los datos de la última ejecución (sysintlstrunsts (E=Error, I=OK, W=Warning) y sysintlstrunlog)
        $lp_key = array('sysintcod'=>$lo_sysint->sysintcod,
												'errtyp'=>($lv_pat_errqty>0?'E':'I'),
												'errlog'=>'Transferidos ['.$lv_pat_qty.'].'.chr(13).'NO Transferidos ['.$lv_pat_errtxt.'].'.chr(13).'IDs No Transferidos ['.$lv_pat_errtxt.']'
											); 
        if( $lo_sysint->setRunData($lp_key) == false ) {
					$this->data['err'] = array('errcod'=>-1005,'errtxt'=>'Error al ejecutar setRunData.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'Se produjo al menos un error al ejecutar sendPacientesToMSDynamics.', 'applogtecinf'=> implode(' | ',$this->data['err']), 'docsts'=>'E');
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }
          
        // Exito
        $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'sendPacientesToMSDynamics se jecuto correctamente.'.$lp_key['sysintlstrunlog'], 'applogtecinf'=>'', 'docsts'=>'A');
        $lo_logmdl->save( $lv_dat );  
				echo '<errcod>0</errcod><errtxt></errtxt><runlog>'.$lp_key['sysintlstrunlog'].'</runlog>';
        return true;
				break;
			
			
			
			// ----------------------------------------------------------------------
			//
			//   O B T I E N E    C O T I Z A C I O N E S
			//
			// ----------------------------------------------------------------------
			case 'getCotizaciones':
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lv_errcod = 0;
				$lv_errtxt = '';
				
				// Obtener interfaz
				$lo_sysint = $this->co_reg->load->model('sysint');
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'GETCOTIZACIONES'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
					$lv_errcod = -1001;
					$lv_errtxt = ' No se encontro una interfaz con codigo externo [getCotizaciones]. ';
          //$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar getCotizaciones.', 
					//	'applogtecinf'=>implode('-',$this->data['err']) );
					//$lo_logmdl->save( $lv_dat ); 
					//echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					//return false;
					
				// cargar interfaz y atributos	
				} else if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
					$lv_errcod = -1002;
					$lv_errtxt = ' No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt.'. ';
        }
				
				// determino destinatarios de notificacion de errores
				if( $lv_errcod==0) {
					$lv_usrmsg = '';
					$lv_mailto = array();
					$lv_usrlst = explode(',',$this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_errntf'));
					foreach( $lv_usrlst as $lv_row ) {
						if ( $lv_row!='' ) {
							$lv_mailto[] = array('address'=>$lv_row);
						}
					}
				}
				if( count($lv_mailto)==0 ) {
					$lv_mailto[] = array('address'=>'soporte.temasis@temasis.com.ar');
				}
				
				// obtengo mensaje de notificacion
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => 'ITZERRNTF', 'txtsys' => 1), false) ){
          $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
					$lv_errcod .= -1003;
					$lv_errtxt .= ' No se pudo cargar el texto de notificacion de errores [ITZERRNTF]. ';
				}
				
				// obtengo las clases de documento para tipo de cambio comprador y vendedor
				if($lv_errcod==0) {
					$lv_excrteclscpa = 0;
					$lv_excrteclsvta = 0;
					$lo_excrteclsmdl = $this->co_reg->load->model('finexcrtecls');
					$lv_prm = array();
					$lo_rs = $lo_excrteclsmdl->getList( $lv_prm, null, null, false );
					//unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
					foreach( $lo_rs as $lv_row ) {
						if(strtolower($lv_row['excrteclscodext'])=='cpa'){ $lv_excrteclscpa=$lv_row['excrteclscod'];}
						if(strtolower($lv_row['excrteclscodext'])=='vta'){ $lv_excrteclsvta=$lv_row['excrteclscod'];}
					}
					if ($lv_excrteclscpa==0 || $lv_excrteclsvta==0) {
						$lv_errcod .= -1004;
						$lv_errtxt .= 'No se pudo determinar las clases de tipo de cambio Comprador(cpa)/Vendedor(vta). ';
					}
				}
				
				// obtengo T/C
				if($lv_errcod==0) {
					$lv_excrteurl = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_url');
					$lv_curdte = new DateTime(date('Y-m-d'));
					$lv_excrteurl=$lv_excrteurl.'?id=billetes&fecha='.$lv_curdte->format('d/m/Y').'&filtroEuro=1&filtroDolar=1';				
					$lv_data = file_get_contents($lv_excrteurl);
					$doc = new DOMDocument();
					libxml_use_internal_errors(false);
					$doc->loadHTML(mb_convert_encoding($lv_data, 'HTML-ENTITIES', 'UTF-8'));
				}
				
				// determino fecha de cotizaciones
				if($lv_errcod==0) {
					$lo_fnd = new DomXPath($doc);
				}

				// obtengo cotizaciones
				if ($lv_errcod==0) {
					$lo_excrtearr = array();
					$lv_pos = -1;
					$lv_clsnme='table table-bordered cotizador';
					$lo_nodes_query = $lo_fnd->query("//*[contains(@class, '$lv_clsnme')]");
					foreach($lo_nodes_query as $lv_row_query) {
						$lo_nodes_tbody = $lo_fnd->query(".//tbody", $lv_row_query );
						foreach($lo_nodes_tbody as $lv_row_body) {
							$lo_nodes_tr = $lo_fnd->query(".//tr", $lv_row_body );
							foreach( $lo_nodes_tr as $lv_row ) {
								$lo_nodes_td = $lo_fnd->query(".//td", $lv_row );
								
								$lv_curcod = '';
								if($lo_nodes_td->item(0)->nodeValue=='Dolar U.S.A'){ $lv_curcod='USD'; }
								if($lo_nodes_td->item(0)->nodeValue=='Euro'){ $lv_curcod='EUR'; }
								
								$lo_excrtearr[] = array('excrteclscod'=>$lv_excrteclscpa, 'curcodsrc'=>'ARS', 'curcoddst'=>$lv_curcod, 
																				'excrtedtefrm'=>date_create_from_format('d/m/Y',$lo_nodes_td->item(3)->nodeValue)->format('d/m/Y'), 
																				'excrte'=>str_ireplace(',','.',$lo_nodes_td->item(1)->nodeValue), 
																				'excrtedstqty'=>'1', 'docsts'=>'A');
								
								$lo_excrtearr[] = array('excrteclscod'=>$lv_excrteclsvta, 'curcodsrc'=>'ARS', 'curcoddst'=>$lv_curcod, 
																				'excrtedtefrm'=>date_create_from_format('d/m/Y',$lo_nodes_td->item(3)->nodeValue)->format('d/m/Y'), 
																				'excrte'=>str_ireplace(',','.',$lo_nodes_td->item(2)->nodeValue), 
																				'excrtedstqty'=>'1', 'docsts'=>'A');
								
								//var_dump( 'cotiz: '.$lo_nodes_td->item(0)->nodeValue.' comprador '.$lo_nodes_td->item(1)->nodeValue.' vendedor '.$lo_nodes_td->item(2)->nodeValue.' fecha '.$lo_nodes_td->item(3)->nodeValue );
							}
						}
					}
				}
				
				// actualizo las cotizaciones en BD
				$lv_mincurcod_arr = array();
				if ($lv_errcod==0) {
					$lv_mincurcod_arr = explode(',',str_ireplace(' ','',$this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'excrte_mincurcod')));
					$lo_excrtemdl = $this->co_reg->load->model('finexcrte');
					foreach($lo_excrtearr as $lv_row) {
						if( $lo_excrtemdl->save( $lv_row, false )==false ) {
							$lv_errcod .= -1005;
							$lv_errtxt .= ($lv_errtxt!=''?' // ':'').' No se pudo actualizar la cotizacion '.$lv_row['curcoddst'].'. ';
						} else {
							unset($lv_mincurcod_arr[ array_search($lv_row['curcoddst'], $lv_mincurcod_arr) ]);
						}
					}
				}
				
				// verifico si las monedas mínimas establecidas fueron actualizadas
				if( count($lv_mincurcod_arr)>0 ) {
					$lv_errcod .= -1006;
					$lv_errtxt .= ' No se pudieron actualizar las cotizaciones de las siguientes monedas ['.implode(', ',$lv_mincurcod_arr).']. ';
				}
				
				
				// notifico errores
				if ($lv_errcod!=0 && $lv_usrmsg!='' && count($lv_mailto)>0 ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = 'ERROR: '. $this->co_reg->sec->bustxt.' - Interfaz getCotizaciones';
					$lv_usrmsg = str_ireplace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%2]', 'Interfaz getCotizaciones', $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%3]', 'Se produjo un error al ejecutar la interfaz.<br>errcod: '.$lv_errcod.'<br>errtxt: '.$lv_errtxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsg );
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm )==false ) {
						$lv_errcod .= -1008;
						$lv_errtxt .= ' Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'. ';							
					}
				}
				
				$lo_sysint->setRunData( array('sysintcod'=>$lo_sysint->sysintcod,	'errtyp'=>($lv_errcod==0?'I':'E'),	'errlog'=>($lv_errcod==0?'Procesado OK.':$lv_errtxt)) );
				echo '<errcod>'.$lv_errcod.'</errcod><errtxt>'.$lv_errtxt.'</errtxt>';
				return ($lv_errcod==0?true:false);

				break;
			
			
			
			
			
			// ----------------------------------------------------------------------
			//
			//    I N H A B I L I T A R    M A T E R I A L E S
			//    ( costo desactualizado )
			//
			// ----------------------------------------------------------------------
			case 'C6':
				$lo_logmdl = $this->co_reg->load->model('sysapplog');
				$lo_sysint = $this->co_reg->load->model('sysint');
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lo_cstmdl = $this->co_reg->load->model('stkmatcst');
				$lo_matmdl = $this->co_reg->load->model('stkmat');
				$lv_errcod = 0;
				$lv_errtxt = '';
				$lv_mailto = array();

				// Obtener interfaz
				$sysintlstrun = '';
        $lv_prm = array('vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'INHABILITA_MATERIAL'.chr(9).chr(9),'vewmaxrec' => '1');
				$lo_rs = $lo_sysint->getList( $lv_prm );
        //unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ){
          $this->data['err'] = array('errcod'=>-1001,'errtxt'=>'No se encontro una interfaz con codigo externo [INHABILITA_MATERIAL].');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=>implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat ); 
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}

				// cargar interfaz y atributos
        if ( $lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) ) == false ) {
          $this->data['err'] = array('errcod'=>-1002,'errtxt'=>'No se pudo cargar la definición de la interfaz ['.$lo_rs[0]['sysintcod'].']. errcod:'.$lo_sysint->errcod.' / errtxt:'.$lo_sysint->errtxt);
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
        }
				
				// busco texto de mail
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATCSTDUE'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_CST'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm);
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)==0 ) {
          $this->data['err'] = array('errcod'=>-1003,'errtxt'=>'No se pudo cargar texto para mensaje de email [STKMATCSTDUE]. errcod:-1003 / errtxt: No se pudo cargar texto para mensaje de email.');
          $lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				$lv_usrmsg = $lo_rs[0]['txttxt'];
				
				// busco parámetro de antiguedad
				$lv_days = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'lstupdqty'); // lstupdqty
				$lv_days = ($lv_days==''?0:strval($lv_days));
				if($lv_days<=0){
					$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo obtener días de vencimiento [lstupdqty]. errcod:-1004 / errtxt: No se pudo obtener dias de vencimiento.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				
				// busco parámetro de destinatarios
				$lv_dest = $this->co_reg->document->gettagvalue($lo_sysint->sysintatr,'mailto'); // mailto
				$lv_dest_arr = explode(';',$lv_dest);
				for($i=0; $i<count($lv_dest_arr); $i++){
					if($lv_dest_arr[$i]!=''){ $lv_mailto[] = array('address'=>$lv_dest_arr[$i]); }
				}
				if(count($lv_mailto)<=0){
					$this->data['err'] = array('errcod'=>-1004,'errtxt'=>'No se pudo obtener destinatarios de mensajes [mailto]. errcod:-1005 / errtxt: No se pudo obtener destinatarios de mensajes.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se produjo un error al ejecutar INHABILITA_MATERIAL.', 
						'applogtecinf'=> implode('-',$this->data['err']) );
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
				}
				
				// busco materiales con costos desactualizados
				$lv_cstdte= new DateTime();
				$lv_cstdte->modify('-'.$lv_days.' day');	
				$lv_prm = array('vewfldflt' =>'[~fltrow~]isnull(mc.matcstlstupd,^1900-01-01^)'.chr(9).'<'.chr(9).chr(9).$lv_cstdte->format('Y-m-d').chr(9).chr(9).
																			'[~fltrow~]mc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'mc.matcstlstupd DESC');
				$lo_rs = $lo_cstmdl->getList($lv_prm);
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				
				// recorro lista y deshabilito materiales
				$lv_buffer = '';
				foreach($lo_rs as $lv_row){
					$lo_matmdl->load( array('matcod'=>$lv_row['matcod']), false );
					$lv_dat = array();
					$lv_dat = $lo_matmdl->getData();
					$lv_dat['docsts'] = 'I';
					$lo_matmdl->save( $lv_dat, false );
					$lv_buffer .= '<tr><td>'.$lv_row['matcod'].'</td><td>'.$lv_row['mattxt'].'</td><td>'.$lv_row['stkmatcstlstupddte'].'</td></tr>';
				}
				
				// envío notificación
				if ( $lv_buffer!='' ) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = 'Logindoor - Inhabilitacion de Materiales';
					$lv_usrmsg = str_ireplace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%2]', $lv_buffer, $lv_usrmsg );
					$lv_usrmsg = str_ireplace( '[%9]', $this->co_reg->sec->bseurl, $lv_usrmsg );
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'INHABILITA_MATERIAL se jecuto correctamente.', 'applogtecinf'=>'', 'docsts'=>'A');
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>0</errcod><errtxt></errtxt>';
						return true;
					} else {
						$this->data['err'] = array('errcod'=>-1005,'errtxt'=>'Se actualizaron materiales. No se pudo enviar notificacion. errcod:-1005 / errtxt: '.$lo_eml->getError());
						$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'docsts'=>'E', 'applogtxt'=>'Se actualizaron materiales. No se pudo enviar notificacion. ['.str_ireplace('</td>',' / ',str_ireplace('<td>',' - ',str_ireplace('</tr>','<br>',str_ireplace('<tr>','',$lv_buffer)))).']' , 
							'applogtecinf'=> implode('-',$this->data['err']) );
						$lo_logmdl->save( $lv_dat );  
						echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
						return false;
					}
				}	else {
					// no se encontraron materiales desactualizados
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'INHABILITA_MATERIAL se jecuto correctamente. No se encontraron materiales desactualizados', 'applogtecinf'=>'', 'docsts'=>'A');
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>0</errcod><errtxt></errtxt>';
					return true;
				}
				break;
        
        /* M A I L   A U T O M A T I C O   L O T E   Y   V E N C I M I E N T O */
			case 'lngstkmatstklst':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=lngstkmatstklst&prm_to=grusso@teaminfusion.com
        // determino destinatarios
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'rptcov'));
        $lv_mailto = array();
				$lv_matcodlst=$this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'matcodlst');    
      
        $lo_stkmdl = $this->co_reg->load->model('stkmatstk');
				/*Filtro los Materiales */
        //$lv_flt='17,39,93,94,95,98,99,100,101,112,113,144,210,214,231,234,244,260,273,291,315,319,329,330,382,383,384,391,409,439,440,479,503,560,565,679,581,583,605,642,643,668,708,709,1881,2341,1550';
        $lv_flt= str_replace(',', chr(10), $lv_matcodlst);
  			
				$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_flt.chr(9).chr(9));
				$lo_rsmatstk= $lo_stkmdl->getlist($lv_prm);
				$lv_data_sqlstm = $lo_stkmdl->getsysdata('sqlstm');
        //echo '<code>'.($lv_data_sqlstm).'</code>';
        //$lv_buf ='<table >';
        //$lv_buf	='<tr>';
				//$lv_buf.='<th>Lugar</th>';        
        //$lv_buf.='<th>Material</th>';
        //$lv_buf.='<th>Descripcion</th>';
        //$lv_buf.='<th>Lote</th>';
        //$lv_buf.='<th>Vencimiento</th>';
        //$lv_buf.='<th>Serie</th>';
        //$lv_buf.='<th>Cantidad</th>';
        //$lv_buf.='</tr>';
        
        $lv_buf	='<tr>';
				$lv_buf.='<th>Submission Mth</th>';        
        $lv_buf.='<th>Product Code (CFN)</th>';
        $lv_buf.='<th>UOM</th>';
        $lv_buf.='<th>Quantity</th>';
        $lv_buf.='<th>Expiry date</th>';
        $lv_buf.='<th>Location</th>';
        $lv_buf.='<th>Status</th>';
        $lv_buf.='<th>Lot/Serial number (Optional)</th>';
        $lv_buf.='<th>NA1</th>';
        $lv_buf.='<th>NA2</th>';
        $lv_buf.='<th>Comments</th>';
        $lv_buf.='</tr>';
        
        foreach ($lo_rsmatstk as $lv_row){
          $lv_buf.='<tr>';
          //$lv_buf.='<td>'.$lv_row['stkobjtxt'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matcod'].'</td>';
          //$lv_buf.='<td>'.$lv_row['mattxt'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matbchcodext'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matbchduedtecnv'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matsercodext'].'</td>';
          //$lv_buf.='<td>'.$lv_row['matqty'].'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td>'.$lv_row['matcodext'].'</td>';
          $lv_buf.='<td>EA</td>';
          $lv_buf.='<td>'.intval($lv_row['matqty']).'</td>';
          $lv_buf.='<td>'.(is_null($lv_row['matbchduedte'])?'':$lv_row['matbchduedte']->format('d/m/Y')).'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td>S</td>';
          $lv_buf.='<td>'.($lv_row['matsercodext']==''?$lv_row['matbchcodext']:$lv_row['matsercodext']).'</td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td></td>';
          $lv_buf.='<td></td>';
          $lv_buf.='</tr>';//
        }
        
        //$lv_buf .='</table>';
        //echo $lv_buf;
        //var_dump($lo_rsmatstk);
        // obtengo texto del mensaje
				$lv_usrmsg='';
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATSTKLST'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_MAT_STK'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm);
				//$lv_data_sqlstm= $lo_rs['data_sqlstm'];
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)!=0 ) {
					$lv_usrmsg = $lo_rs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        
				//// determino destinatarios
				//$lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
        /*$lv_env = $this->co_reg->config->get('environmet');
				if($lv_env=='dev'){
        */
				//if($lv_issisdev !== false){
        //$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        //$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
        $lv_mailtoarr = explode(';',$lp_prm['to']);
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}

        
				// envío mail
				if ( $lv_usrmsg!='') {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = 'Reporte mensual de stock con lote y vencimiento ';
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_replace( '[%2]', $lv_buf , $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%4]', $this->co_reg->sec->usrtxt, $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%3]', utf8_decode($lo_post['crmcntsrctxt']), $lv_usrmsg);
					//$lo_post['crmcntrqs']=str_replace(chr(13),'<BR>',$lo_post['crmcntrqs']);
					//$lo_post['crmcntrqs']=$lo_post['crmcntrqs'].'<br><br><small>Interacci&oacute;n creada: '.$lv_now->format('d/m/Y').'</small>';
					//$lv_usrmsg = str_replace( '[%5]', utf8_decode($lo_post['crmcntrqs']), $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%6]', utf8_decode($lo_post['crmcntdte']), $lv_usrmsg);
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
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
				break;
      case 'grlcrmcntduentf':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=grlcrmcntduentf
        /*Obtengo los parametros de empresa*/
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'CRMCNTDUEDTENTF')) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "CRMCNTDUEDTENTF"';
					return $lv_buffer;
          break;
        }
        $lv_crmcntmtvexc = str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'crmcntmtvexc')));
        $lv_crmcnttypexc = str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'crmcnttypexc')));
        $lv_chkduedaylst = str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkduedaylst')));
        
        $lv_docstslst 	 = str_replace(',', chr(10),str_replace(';',',',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'docstslst'))); 
        
        $lv_msgtxtcod = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxtcod'); // MENSAGE
        $lv_msgtxt 		= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxt'); 	 // TEXTO
        $lv_msgemlsub = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgemlsub'); // MAIL SUBJECT

        $lo_usrmdl = $this->co_reg->load->model('syssecusr');
        $lo_rs_usr = $lo_usrmdl->getList();
        $lo_usrlst=[];
        foreach($lo_rs_usr as $lo_usr_row){
          //$lo_usrlst[$lo_usr_row['usrcod']]= $lo_usr_row['adreml'];
          $lo_usrlst[$lo_usr_row['usrcod']]['adreml']= $lo_usr_row['adreml'];
          $lo_usrlst[$lo_usr_row['usrcod']]['usrtxt']= $lo_usr_row['usrtxt'];
        }
        
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        $lv_prmprm = array('vewfldflt' =>'[~fltrow~]c.crmcnttypcod'.chr(9).'NI'.chr(9).chr(9). $lv_crmcnttypexc .chr(9).chr(9).
                           							 '[~fltrow~]c.crmcntmtvcod'  .chr(9).'NI'.chr(9).chr(9). $lv_crmcntmtvexc  .chr(9).chr(9).
                           							 '[~fltrow~]c.crmcntstscod' .chr(9).'NI'.chr(9).chr(9). $lv_docstslst  .chr(9).chr(9).
                           							 '[~fltrow~]DBO.GETTAGVALUE(^DUEDTE^,C.CRMCNTATR)'  .chr(9).'<>'.chr(9).chr(9). ''  .chr(9).chr(9).
                           							 '[~fltrow~]DATEDIFF(day,CONVERT(datetime, DBO.GETTAGVALUE(^DUEDTE^,C.CRMCNTATR), 103),getdate())' .chr(9).'IN'.chr(9).chr(9). $lv_chkduedaylst  .chr(9).chr(9),
                           'vewfldord' => 'c.crmcntcod asc'
                          );
        $lo_rs_cnt = $lo_cntmdl->getList($lv_prmprm, null, null, false);
        //echo '<textarea>'.$lo_cntmdl->getSysData('sqlstm').'</textarea>';
        
        /* OBTENGO EL MENSAGE A ENVIAR */
        $lv_usrmsg='';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        //$lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod));
        if ( $lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE EL MENSAGE CON EL CODIGO ' . $lv_msgtxtcod;
          return $lv_buffer;
          break;
        }        
        foreach($lo_rs_cnt as $lo_cnt_row){
          if(isset($lo_usrlst[$lo_cnt_row['usrcod']])&&$lo_usrlst[$lo_cnt_row['usrcod']]!=''){
            $lv_mailto 		= array();
            $lv_mailto[] = array('address'=>$lo_usrlst[$lo_cnt_row['usrcod']]['adreml']);
            // envío mail
        		$lv_usrmsg=$lo_txtmdl->txttxt;
            if ( $lv_usrmsg!='') {
              $lo_eml = new tmssMail();
              $lv_emlprm['to'] = $lv_mailto;
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
              $lv_emlprm['subject'] = $lv_msgemlsub;
              $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
              
              $lv_usrmsg = str_replace( '[%2]', $lv_msgemlsub, $lv_usrmsg );
              
              $lv_usrmsg = str_replace( '[%3]',  '#'.$lo_cnt_row['crmcntcod']. ' - '.$lo_cnt_row['crmcnttxt'], $lv_usrmsg  );          
              
              $lv_usrmsg = str_replace( '[%4]', ' con fecha de vencimiento ' . $this->co_reg->document->gettagvalue($lo_cnt_row['crmcntatr'],'duedte'), $lv_usrmsg );
              $lv_stsduetxt=$lo_cnt_row['crmcntcod'];
              $fecha = date_create_from_format("d/m/Y", $this->co_reg->document->gettagvalue($lo_cnt_row['crmcntatr'],'duedte'));
              $fecha_actual = date("d/m/Y");
              $diff = date_diff($fecha, date_create_from_format("d/m/Y", $fecha_actual));
              if ($diff->format('%R') !== '-') {
                // La fecha en la variable $fecha es anterior o igual a la fecha actual.
                $lv_stsduetxt='vencido';
              } else {
                  // La fecha en la variable $fecha es posterior a la fecha actual.
              	$lv_stsduetxt='por vencer';
              }
              $lv_usrmsg = str_replace( '[%5]',  $lv_stsduetxt, $lv_usrmsg );
              $lv_usrmsg = str_replace( '[%6]', ' '.$lo_usrlst[$lo_cnt_row['usrcod']]['usrtxt'] , $lv_usrmsg );
              
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
          	//echo $lo_usrlst[$lo_cnt_row['usrcod']].'<br>';
          }
        }
        
        //echo '<textarea>'.$lo_cntmdl->getSysData('sqlstm').'</textarea>';
        
        
        break;
      case 'lngchkalrtym':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_cmd&act=lngchkalrtym
        $lv_buffer = '';
				$lv_errcod = '-';
				$lv_errtxt = '-';
        /*Obtengo los parametros de empresa*/
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'CHKALRTYM')) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "SMMEX"';
					return $lv_buffer;
          break;
        }
        
        $lv_chkclsdoc = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkclsdoc');							// ID Clase de Documento
       	$lv_chkstlid 	= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkstlid'); 							// ID de Almacén
        $lv_chkday 		= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkamtday');							// Cantidad días
        $lv_chkmatsts = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkmatsts'); 							// Estado del Recurso
        $lv_chkbchsts = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkbchsts'); 							// Estado del Lote
        $lv_chksersts	= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chksersts'); 							// Estado Número de Serie
        $lv_chkstlsts	= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'chkstlsts'); 							// Estado del Almacén
				$lv_sndeml 		= explode(';',$this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'sendmail'));	// MAILS
        $lv_msgtxtcod = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxtcod');							// MENSAGE
        
        $lv_msgtxt 		= $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgtxt'); 							// TEXTO
        $lv_msgemlsub = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'msgemlsub'); 						// MAIL SUBJECT
        
        $lv_chkclsdoc	= str_replace(',', chr(10), $lv_chkclsdoc);
        $lv_chkstlid	= str_replace(',', chr(10), $lv_chkstlid);
        $lv_chkmatsts	= str_replace(',', chr(10), $lv_chkmatsts);
        $lv_chkbchsts	= str_replace(',', chr(10), $lv_chkbchsts);
        $lv_chksersts	= str_replace(',', chr(10), $lv_chksersts);
        $lv_chkstlsts	= str_replace(',', chr(10), $lv_chkstlsts);
        
        // obtengo la documentación por vencer (-30 dias)
				$lv_curdte = new DateTime(date('Y-m-d'));
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-'.$lv_chkday.' day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+'.$lv_chkday.' day');
        
        //OBTENGO LOS NUMEROS DE SERIE
        $lo_matstk = $this->co_reg->load->model('stkmatser');
        $lv_prmprm = array('vewfldflt' =>'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lv_chkclsdoc  .chr(9).chr(9).
                           							 '[~fltrow~]ms.stkobjcod'  .chr(9).'IN'.chr(9).chr(9). $lv_chkstlid  .chr(9).chr(9).
                           							 //'[~fltrow~]s.stkobjStrdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte->format('Y-m-d').chr(9).$lv_enddte->format('Y-m-d').chr(9).

                           							 '[~fltrow~]datediff(day,s.stkobjStrdte,getdate())'.chr(9).'GE'.chr(9).chr(9).$lv_chkday.chr(9).chr(9).
                           							 '[~fltrow~]m.docsts'      .chr(9).'IN'.chr(9).chr(9). $lv_chkmatsts  .chr(9).chr(9).
                           							 //'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lv_chkbchsts  .chr(9).chr(9).
                           							 '[~fltrow~]s.docsts'.chr(9).'IN'.chr(9).chr(9). $lv_chksersts  .chr(9).chr(9),
                           							 //'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lv_chkstlsts  .chr(9).chr(9),
                           'vewfldord' => 'datediff(day,s.stkobjStrdte,getdate()) desc'
                          );
        
        $lo_matstkrs=$lo_matstk->getList( $lv_prmprm, null, null, false );
        //echo '<textarea>'.$lo_matstk->getSysData('sqlstm').'</textarea>';
        
        $lo_matcodlst=[];
        foreach ($lo_matstkrs as $lv_row){
          if (!in_array($lv_row['matcod'], $lo_matcodlst)) {
          	$lo_matcodlst[]=$lv_row['matcod'];
          }
        }
        
        /* OBTENGO LOS NUMEROS DE SERIE */
        $lo_matmdl = $this->co_reg->load->model('stkmat');
        $lv_prmprm = array('vewfldflt' => '[~fltrow~]s.docsts'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_matcodlst)  .chr(9).chr(9),
                           'vewfldord' => 'matcod asc'
                          );
        
        $lo_matrs=$lo_matmdl->getList( $lv_prmprm, null, null, false );
        
      	$lv_matlst=[];
        foreach($lo_matrs as $lo_matrow){
          $lv_key=$lo_matrow['matcod'];
          if(!array_key_exists($lv_key, $lv_matlst)){
            $lv_matlst[$lv_key]=array('matqty'=>0);
          }
          $lv_matlst[$lv_key]=$lo_matrow;
        }       
        
        $lv_buf='';
        $lv_buf.='<table border="1" cellpadding="5" cellspacing="0">';
        $lv_buf.='<thead>';
        $lv_buf.='<tr style="background-color: #f1f1f1;">';
				$lv_buf.='<th>Origen</th>';        
        $lv_buf.='<th>Contacto</th>';
        $lv_buf.='<th>Clase</th>';
        $lv_buf.='<th>Codigo</th>';
        $lv_buf.='<th>Material</th>';
        $lv_buf.='<th>Descripcion</th>';
        //$lv_buf.='<th>Lote<br>Vencimiento</th>';
        $lv_buf.='<th>Nro. Serie</th>';
        $lv_buf.='<th>Cantidad</th>';
        $lv_buf.='<th>UM</th>';
        $lv_buf.='<th>Desde</th>';
        
        $lv_buf.='</tr>';
        $lv_buf.='</thead>';
       
        $lv_buf.='<tbody>';
         foreach ($lo_matstkrs as $lv_row){
          $lv_buf.='<tr>';
            $lv_buf.='<td align="center">'.$lv_row['stkobjtyptxt'].'</td>';
            $lv_buf.='<td align="center">'.$lv_row['stkobjtxt'].'</td>';
            $lv_buf.='<td align="center">'.$lv_row['sysdocclstxt'].'</td>';//Ver
            $lv_buf.='<td align="center">'.$lv_row['matcod'].'</td>';
            $lv_buf.='<td align="center">'.$lv_row['matcodext'].'</td>';
            $lv_buf.='<td align="center">'.$lv_row['mattxt'].'</td>';
            //$lv_buf.='<td align="center">'.$lv_row['matcod'].'</td>';
            $lv_buf.='<td align="center">'.$lv_row['matsercodext'].'</td>';
            $lv_buf.='<td align="center">1</td>';
           	$lv_matuntcod =$lv_row['matuntcod'];
           	if(isset($lv_matlst[$lv_row['matcod']]['matuntcod'])){
              $lv_matuntcod=$lv_matlst[$lv_row['matcod']]['matuntcod'];
            }
            $lv_buf.='<td align="center">'.$lv_matuntcod .'</td>';
           	/*
           	$lv_sysdocclstxt ='SC';
           	if(isset($lv_matlst[$lv_row['matcod']]['sysdocclstxt'])){
              $lv_sysdocclstxt=$lv_matlst[$lv_row['matcod']]['sysdocclstxt'];
            }
            $lv_buf.='<td align="center">'.$lv_sysdocclstxt.'</td>';
           */
             
          $lv_buf.='<td align="center">'.$lv_row['stkobjstrdte']->format('d-m-Y').'</td>';
          $lv_buf.='</tr>';
        }
        $lv_buf.='</tbody>';
        $lv_buf.='</table>';
        
        // echo $lv_buf;
        // echo '<br><textarea>'.$lo_matstk->getsysdata('sqlstm').'</textarea>';
        // return '';
        // break;
        /*
        break;
        */
        
        /* OBTENGO EL MENSAGE A ENVIAR */
        $lv_usrmsg='';
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        //$lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod));
        if ( $lo_txtmdl->load(array('txtcod'=>$lv_msgtxtcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE EL MENSAGE CON EL CODIGO ' . $lv_msgtxtcod;
					return $lv_buffer;
          break;
        }
        $lv_usrmsg=$lo_txtmdl->txttxt;
        
        $lv_mailto 		= array();
				
        foreach( $lv_sndeml as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
        
        // envío mail
				if ( $lv_usrmsg!='' && count($lo_matstkrs)>0) {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
					$lv_emlprm['subject'] = $lv_msgemlsub;
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%2]', $lv_msgemlsub, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%3]', $lv_msgtxt, $lv_usrmsg );          
					$lv_usrmsg = str_replace( '[%4]', $lv_buf , $lv_usrmsg);
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
				$lv_buffer = $lv_errcod . ': '. $lv_errtxt;
				return $lv_buffer;
        break;
      case 'chgparusr':
        //https://developers.gorse.ar/index.php?prg=zcutp1_cmd&act=chgparusr&prm_usrcodlst=HLT_PRS_156,HLT_PRS_154,HLT_PRS_37,HLT_PRS_26
        $lv_usrCodLst=[];
        if(!empty($lp_prm['usrcodlst'])){
        	$lv_BufUsrCodlst=$lp_prm['usrcodlst']??'';	
        	$lv_usrCodLst=explode(",",$lv_BufUsrCodlst);
        }
        $data=[];
        $data['sqlstm']=[];
        $usrPrmMdl = $this->co_reg->load->model('syssecusrprm');
              
        // Busco las planificaciones
        $PlnDteMdl = $this->co_reg->load->model('hltplndte');
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-90 day');
				$lv_enddte = new DateTime(date('Y-m-d'));
        $lv_enddte->modify('365 day');
        $prmPrm = array('vewfldflt' => '[~fltrow~]pld.docsts'.chr(9).'='.chr(9).chr(9). 'A'  .chr(9).chr(9).
                        							 '[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte->format('Y-m-d').chr(9).$lv_enddte->format('Y-m-d').chr(9),
                        'vewfldord'=>'pl.prscod,pl.patcod',
                        'vewfldgrp'=>'pl.patcod,pl.prscod'
                        //,                     'vewfldgrpcal'=>'count(*) as qty'
                          );
        $rsPlnDte=$PlnDteMdl->getList($prmPrm);
        $data['sqlstm'][]=$PlnDteMdl->getSysData('sqlstm');
        $lo_prs=[];
        foreach($rsPlnDte as $rowPat){
          $lo_prs[$rowPat['prscod']]=($lo_prs[$rowPat['prscod']]??'').','.$rowPat['patcod'];
        }        
        // PACIENTES PARAMETRIZADOS POR USUARIOS
        $prmPrm = array('vewfldflt' =>'[~fltrow~]P.docsts'.chr(9).'='.chr(9).chr(9). 'A'  .chr(9).chr(9).
                        							'[~fltrow~]P.usrcod'.chr(9).'LIKE'.chr(9).'HLT_PRS_'.chr(9).chr(9).chr(9).
                        							 //'[~fltrow~]P.usrcod'.chr(9).'='.chr(9).chr(9). $usrTst  .chr(9).chr(9).
                        							'[~fltrow~]P.prmcod'.chr(9).'='.chr(9).chr(9).'4'.chr(9).chr(9),
                        'vewfldord'=>'P.usrcod asc');
        if(!empty($lv_usrCodLst)&& $lv_usrCodLst!=''){
        	$prmPrm['vewfldflt']=$prmPrm['vewfldflt'].'[~fltrow~]P.usrcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_usrCodLst).chr(9).chr(9);
        }
        $rsUsrPatPrm=$usrPrmMdl->getList($prmPrm);
        $data['sqlstm'][]=$usrPrmMdl->getSysData('sqlstm');
        $usrant='';
        $opr_lst=[];
        $opr_lst['del']=[];
        $opr_lst['add']=[];
        
        
        foreach($rsUsrPatPrm as $rowDat){
          $prsCod = str_ireplace('HLT_PRS_','',$rowDat['usrcod']);
           $prmVal= $lo_prs[$prsCod]??'';;
           $prmUsrPrm=['usrprmcod'=>$rowDat['usrprmcod'],
                        'usrcod'=>$rowDat['usrcod'],
                        'prmcod'=>'4',
                        'prmval'=>$prmVal,
                        //'prmvaldef'=>$rowPrmCod,
                        'prmobjtyp'=>'HLT_PAT',
                        'usrprmfltkey'=>'1',
                        'usrprmfltinc'=>'',
                        'usrprmflttyp'=>'AND'
                       ];
          if($rowDat['usrcod']==$usrant || $usrant==''){
            $opr_lst['del'][]=$prmUsrPrm;
            //$usrPrmMdl->delete($prmUsrPrm);
          }else{
            $opr_lst['add'][]=$prmUsrPrm;
            //$usrPrmMdl->add($prmUsrPrm);
          }
          $usrant=$rowDat['usrcod'];
        }
        $data['opr']=$opr_lst;
				return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-11','errtxt'=>'error','data'=>$data));
        break;
        
      case "mattotp":{
        /*
         * Proceso de sincronización de materiales desde Logistica hacia Salud vía API.
         * 
         * El código obtiene la configuración de la interfaz MAT_TO_TP, se autentica en el sistema remoto,
         * recupera los materiales existentes y la lista de precios vigente, y selecciona los materiales
         * activos que cumplen con las reglas configuradas. Para cada material decide si debe crearlo o
         * actualizarlo en el sistema externo, aplicando conversiones de clases y clasificaciones,
         * asignando precios y unidades, y respetando configuraciones de lote y número de serie.
         * 
         * Al finalizar, retorna un resumen en formato JSON con el resultado de los envíos y el detalle
         * de las sentencias SQL ejecutadas para fines de control y auditoría.
        */
        //https://developers.gorse.ar/index.php?prg=zcutp1_cmd&act=mattotp
        $ret= ['errtyp'=>'S','errcod'=>'0','errtxt'=>'','data'=>[]];
        $lo_dat=[];
        $sqlstmlst=[];
        
        $mdlSysInt = $this->co_reg->load->model('sysint');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'MAT_TO_TP'.chr(9).chr(9).
																			'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $mdlSysInt->getList( $lv_prm );
        $sqlstmlst[]= $mdlSysInt->getsysdata('sqlstm');
				if(count($lo_rs)==1) {
					$mdlSysInt->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) );
					$lo_dat['cntsrctyp'] = 'SLS_CUS';
          $lo_dat['apiresbse'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'apiurl'); //empresa
          $lo_dat['prytkn'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'apitkn'); // Tocken del proyecto
          $lo_dat['usrcod'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'usrcod'); // Usuario
          $lo_dat['usrpwd'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'usrpwd'); //Password
					$lo_dat['sysdocclscoddef'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'sysdocclscod'); //Clase de documeto por defecto
          $lo_dat['sysdocclspaslst'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'sysdocclspaslst'); // Clase de documentos de los materiales a pasar
          $lo_dat['cuscod'] = $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'cuscod'); // Lista de precio
          $lo_dat['endpoint']= $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'endpoint'); // URL de las api
          $lo_dat['clsbchcod']= $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'clsbchcod'); // URL de las api
          $lo_dat['clssercod']= $this->co_reg->document->getTagValue($mdlSysInt->sysintatr , 'clssercod'); // URL de las api
          $lo_dat['sysdocclscnv']=array_column($mdlSysInt->sysintcnv,'sysintcnvout001','sysintcnvinb001');
          $lo_dat['clscnv']=array_column($mdlSysInt->sysintcnv,'sysintcnvout002','sysintcnvinb001');
          $lo_dat['sysdocclspaslst'] = str_replace( ',', chr(10), $lo_dat['sysdocclspaslst']);
				} else {
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']=-11;
          $lv_ret['errtxt']='error. no se obtuvo la interfaz [MAT_TO_TP]';
          return $lv_ret; 
				}
        //Busco el cliente
        $mdlCus = $this->co_reg->load->model('slscus');
        $mdlCus->load(array('cuscod'=>$lo_dat['cuscod']));
        $lo_dat['slsprclstcod']=$mdlCus->slsprclstcod;
        
        // obtengo token de sesion de usuario Nuevo
        $lo_dat['apires'] = $lo_dat['apiresbse'];
        $lo_dat['apires'] = '/';
        $lv_retTkn = $this->callRemoteApi($lo_dat);
        if($lv_retTkn['errtyp']!='S'){
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']=$lv_retTkn['errcod'];
          $lv_ret['errtxt']=$lv_retTkn['errtxt'];
          return $this->co_reg->document->getJson( $ret);
        }
        $lo_dat['usrtkn']=$lv_retTkn['token'];
        
        //	Obtener Los Articulos de TP para obtener el id (Si hay que modificarlos)
        //$lo_dat['apires'] = $lo_dat['apiresbse'] . '/STOCK-MATERIALS/search?status=a';
        $lo_dat['apires'] = '/STOCK-MATERIALS/search?status=a';
        $apiMatlst = $this->callRemoteApi($lo_dat);
        if($apiMatlst['errtyp']!='S'){
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']=$apiMatlst['errcod'];
          $lv_ret['errtxt']=$apiMatlst['errtxt'];
          return $this->co_reg->document->getJson( $ret);
        }
        $srcMatLst = array_column($apiMatlst['data'],'id','code');
        $srcMatUseSer = array_column($apiMatlst['data'],'use_serial','code');
        $srcMatUseBch = array_column($apiMatlst['data'],'use_batch','code');
        
        $srcMatSerPro = array_column($apiMatlst['data'],'serial_profile','code');
        $srcMatBchPro = array_column($apiMatlst['data'],'batch_profile','code');
        
        // Busco la version de la lista de precios
        $mdlSlsPrcVer = $this->co_reg->load->model('slsprcver');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lo_dat['slsprclstcod'].chr(9).chr(9),
                        'vewfldord'=>'slsprclststrdte',
                        'vewmaxrec'=>'1');
				$rsPrcVer = $mdlSlsPrcVer->getList( $lv_prm );
        $sqlstmlst[]= $mdlSlsPrcVer->getsysdata('sqlstm');
        $lo_dat['slsprvercod']='';
        if(count($rsPrcVer)>=1){
          $lo_dat['slsprvercod']=$rsPrcVer[0]['slsprclstvercod'];
        }
        
        // OBTENGO LA LISTA DE PRECIOS 
        $mdlSlsPrcLst = $this->co_reg->load->model('slsprclst');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lo_dat['slsprclstcod'].chr(9).chr(9).
                        							'[~fltrow~]st1.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lo_dat['sysdocclspaslst'] .chr(9).chr(9).
																			'[~fltrow~]pl.slsprclstvercod'.chr(9).'='.chr(9).chr(9).$lo_dat['slsprvercod'].chr(9).chr(9));
				$rsPrcLst = $mdlSlsPrcLst->getList( $lv_prm );
        $sqlstmlst[]= $mdlSlsPrcLst->getsysdata('sqlstm');
        $prcLst = array_column($rsPrcLst,'slsprc','slsprcsrccod');
        $lstMatPrc=array_column($rsPrcLst,'slsprcsrccod','slsprcsrccod');
        
        //OBTENGO LOS MATERIALES DEL ORIGEN
        $mdlMat =$this->co_reg->load->model('stkmat');
        
        $lv_ordprm=array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lstMatPrc) .chr(9).chr(9).
                         								//'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). $lo_dat['sysdocclspaslst'] .chr(9).chr(9).
                                     		'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                      );
        $rsMat=$mdlMat->getList($lv_ordprm);
        $sqlstmlst[]= $mdlMat->getsysdata('sqlstm');
        $pstSndDat=[];
        $pstSndDat['errlst']=[];
        $pstSndDat['oklst']=[];
        foreach( $rsMat as $rowMat) {
          $key = $rowMat['matcod'];
          $matCodDst=array_key_exists($key , $srcMatLst)?$srcMatLst[$key]:null;
          $matPrc=array_key_exists($key , $prcLst)?$prcLst[$key]:'0';
          $pstDat=$lo_dat;
          $pstDat['apires'] = '/STOCK-MATERIALS/'. ($matCodDst??'NEW?null') ;
          $pstDat['grlcntcod']=$matCodDst; 
          $pstDat['PST']['id'] = $matCodDst??''; //$lo_dat['matcod'];
          $pstDat['PST']['code']=$rowMat['matcod'];
          $pstDat['PST']['name']=$rowMat['mattxt'];

          $pstDat['PST']['additional_data']='';
          // Estado
          $pstDat['PST']['status']='A';
          // Categoria
          $pstDat['PST']['category_id']='';// ??
          // - Clase de documento (Conversiones)
          $pstDat['PST']['documentclass_id']=($lo_dat['sysdocclscnv'][$rowMat['sysdocclscod']]??$lo_dat['sysdocclscoddef']);
          // - Jerarquia
          $pstDat['PST']['hierarchy_id']=''; //??
          // - Clasificacion
          $pstDat['PST']['classification_id']=($lo_dat['clscnv'][$rowMat['sysdocclscod']]??'');//'';//??

          $pstDat['PST']['price']=$prcLst[$key];//'1234';//??
          $pstDat['PST']['price_quantity']='1';//??
          $pstDat['PST']['price_currency']='AR';//??
          $pstDat['PST']['price_unit']=$rowMat['matuntcod'];//??

          $pstDat['PST']['use_batch']=($matCodDst==null?$rowMat['matusebch']:$srcMatUseBch[$key]);//Usa Lote
          if($pstDat['PST']['use_batch']=='1'){
            $srcMatBchPro[$key]=$srcMatBchPro[$key]??$lo_dat['clsbchcod'];
            $pstDat['PST']['batch_profile']=($matCodDst==null?$lo_dat['clsbchcod']:$srcMatBchPro[$key]);//Perfil Lote
          }
          
          $pstDat['PST']['use_serial']=($matCodDst==null?$rowMat['matuseser']:$srcMatUseSer[$key]);//Usa Serie
          if($pstDat['PST']['use_serial']=='1'){
          $srcMatSerPro[$key]=$srcMatSerPro[$key]??$lo_dat['clssercod'];
          $pstDat['PST']['serial_profile']=($matCodDst==null?$lo_dat['clssercod']:$srcMatSerPro[$key]);//Perfil serie
            
          }
          // Unidad de medida
          $pstDat['PST']['unit_code']=$rowMat['matuntcod'];
          $apiPst = $this->setDataApiTmss($pstDat);
          if($apiPst['errtyp']=='S'){
             $pstSndDat['oklst'][]=$apiPst;
          }else{
          	$apiPst['data']=$pstDat['PST'];
             $pstSndDat['errlst'][]=$apiPst;
          }
        }
        // Enviar los articulos via api
        $ret['data']=[];
        $ret['data']['sendApi']=$pstSndDat;
        $ret['data']['sql']=$sqlstmlst;
        return $this->co_reg->document->getJson( $ret);
        
        break;
      } // end mattotp
    } // end switch
  } // end  Funcion
  public function testSendApi($lp_prm=array()){
    $curl = curl_init();
		$lv_apiurl = $lp_prm['endpoint'].$lp_prm['apires'];
    //$lv_jsonpost= json_encode($lp_prm['PST']);
    array_walk_recursive($lp_prm['PST'], function (&$v) {
      if (is_string($v)) {
          $v = mb_convert_encoding($v, 'UTF-8', 'ISO-8859-1');
      }
    });
    $lv_jsonpost= json_encode($lp_prm['PST'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    curl_setopt_array($curl, array(
      CURLOPT_URL => $lv_apiurl,
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
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
    // verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
      $lv_ret = json_decode($lo_rs,true);
    }else{
			$lv_ret = array('errtyp'=>'E','errcod'=>$lv_stscod,'errtxt'=>'Server Response:'. $lv_stscod);
    }
    $lv_ret['snddata']= $lv_jsonpost;
    $lv_ret['endpoint']= $lv_apiurl;
    curl_close($curl);
    return $lv_ret;
  }
  public function setDataApiTmss($lp_prm=array()){
    $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','data'=>$lp_prm);
    
    $lv_apiurl = $lp_prm['endpoint'].$lp_prm['apires'];
    $lv_jsonpost= json_encode($lp_prm['PST']);
    $curl = curl_init($lv_apiurl);
    curl_setopt_array($curl, array(	CURLOPT_URL => $lv_apiurl,
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
    curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)');
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
    if( ! $lo_rs = curl_exec($curl)){
      trigger_error(curl_error($curl));
    }
    // verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
      $lv_ret = json_decode($lo_rs,true);
    }else{
			$lv_ret = array('errtyp'=>'E','errcod'=>$lv_stscod,'errtxt'=>'Server Response:'. $lv_stscod);
    }
    $lv_ret['snddata']= $lv_jsonpost;
    $lv_ret['endpoint']= $lv_apiurl;
    curl_close($curl);
    return $lv_ret;
    
  }
  
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
		//$lv_apiurl = 'https://developers.gorse.ar/';
    //$lv_apiurl .= 'api.gorse.php/'.$lp_prm['apires'];
    $lv_apiurl = $lp_prm['endpoint'].$lp_prm['apires'];
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
      $lv_ret = json_decode($lo_rs,true);
    }else{
			$lv_ret = array('errtyp'=>'E','errcod'=>$lv_stscod,'errtxt'=>'Server Response:'. $lv_stscod);
    }
		
		// cierro llamada
    curl_close($lo_cur);
		
		// devuelvo resultado
    $lv_ret['snddata']='';
    $lv_ret['endpoint']= $lv_apiurl;
    $lv_ret['apiurl']=$lv_apiurl;
    return $lv_ret;
	}
   private function getTockenTmss($lp_prm=array()){
    $lo_cur = curl_init();
    $lp_prm['endpoint']=$lp_prm['endpoint']??'https://developers.gorse.ar/api.gorse.php/';
    $lv_apiurl =  $lp_prm['endpoint'].$lp_prm['apires'];
    curl_setopt_array($lo_cur, array(
      CURLOPT_URL => $lv_apiurl,//'https://developers.gorse.ar/api.gorse.php/' . $lp_prm['apires'] . '/',
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_CUSTOMREQUEST => 'GET',
      CURLOPT_HTTPHEADER => array(
        'Content-Type: application/json',
        'crossDomain: true',
        'user: ' . $lp_prm['usrcod'],
        'password: ' . $lp_prm['usrpwd'],
        'proyect-token: ' . $lp_prm['prytkn']
      ),
    ));
    curl_setopt($lo_cur, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)');
    curl_setopt($lo_cur, CURLOPT_CUSTOMREQUEST, 'GET');
    curl_setopt($lo_cur, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($lo_cur, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($lo_cur, CURLOPT_SSL_VERIFYPEER, 0);

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
    $lv_ret['snddata']='';
    $lv_ret['endpoint']= $lv_apiurl;
    $lv_ret['apiurl']=$lv_apiurl;
    return $lv_ret;
  }// end callTmssApi
} // Fin Clase
?>