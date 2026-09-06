<?php 
final class hltplnController extends tmssController2 {  
  function initialize(){
    $this->CONTROLLER='hltpln';$this->MODEL='hltpln';$this->VIEW='hltplnedt';$this->ID='plnid';$this->enable_sysdoccls=true;$this->OBJTYP='HLT_PLN'; $this->extraRet = array('objtyp'=>'HLT_PLN');
    //$this->preventCopy = array('buyexpdocimpcod');
  }
  
  
  function getList(){
		// recupero los par metros principales
		$lv_plnvew = ( $this->post['plnvew']  ?? $this->prm['plnvew']  ?? '' );
		$lv_plnid  = ( $this->post['plnid']   ?? $this->prm['plnid']   ?? '' );
		$lv_plndteid=( $this->post['plndteid']?? $this->prm['plndteid']?? '' );
		$lv_patcod = ( $this->post['patcod']  ?? $this->prm['patcod']  ?? '' );
    $lv_delcod = ( $this->post['delcod']  ?? $this->prm['delcod']  ?? '' );  
		$lv_prscod = ( $this->post['prscod']  ?? $this->prm['prscod']  ?? '' );
		$lv_spccod = ( $this->post['spccod']  ?? $this->prm['spccod']  ?? '' );
		$this->mdl->hltdiscls = ( $this->post['hltdiscls'] ?? '' );
		$this->mdl->adrtxt = ( $this->post['adrtxt'] ?? '' );    
    $this->mdl->plnvew = $lv_plnvew;
    $this->post['mdlcod'] = ( $this->post['mdlcod'] ?? $this->prm['mdlcod'] ?? '' ); 
    $this->post['prgcod'] = ( $this->post['prgcod'] ?? $this->prm['prgcod'] ?? '' );

    // M A P A
    if ( $lv_plnvew=='plnmap' ) {
      if ( ($this->prm['rfh']??'')=='1' ) {
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lv_ret = $lo_vew->index( '00', $this->prm );
    	} else {

        // obtengo prestadores
        $lo_prsmdl = $this->co_reg->load->model('hltprs');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrmapgeo'.chr(9).'NE'.chr(9).''.chr(9).chr(9).chr(9).
                                      '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      );
        $lo_rsprs  = $lo_prsmdl->getList($lv_prm, null, null, false);

        // obtengo pacientes
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrmapgeo'.chr(9).'NE'.chr(9).''.chr(9).chr(9).chr(9).
                                      '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      );
        $lo_rspat  = $lo_patmdl->getList($lv_prm, null, null, false);

        return $this->co_reg->document->getView( 'hltplnmap', array('data'=>$this->mdl,'hltprs'=>$lo_rsprs,'hltpat'=>$lo_rspat,'actcod'=>$this->act ) );
      }
      return $lv_ret;

    // S E M A N A L
    } else if ( $lv_plnvew=='plnwek' ) {
      $this->mdl->vewmaxrec = ( $this->post['vewmaxrec'] ?? '100' );
      if( ($this->post['getjson']??'')=='') {

        //Carga la vista semanal
        $this->mdl->plnmth = date("m");
        $this->mdl->plnyth = date("Y");
    		$lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
        $lo_mdlprm->load( array('mdlcod'=>'HLT') );

        // obtengo filtro por default
        $lo_fltmdl = $this->co_reg->load->model('grldocflt');
        $lv_prm = array('vewmaxrec' =>'1',
                        'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).'VEW_HLT_PLN_WEK'.chr(9).chr(9).
                                      '[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
                                      '[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                                      '[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                      	);
        $lo_rs = $lo_fltmdl->getList( $lv_prm );
        if(count($lo_rs)>0){
          $this->mdl->vewfldfltdat = $lo_rs[0]['vewfltdat'];
          $this->mdl->vewfltcod = $lo_rs[0]['vewfltcod'];
        }
        return $this->co_reg->document->getView( 'hltplnwek', array('mdlprm'=>$lo_mdlprm,'data'=>$this->mdl,'actcod'=>$this->act ) );

      } else {
        // calculo periodo mes actual
        $lv_dtefrt = date('d-m-yy', strtotime('01-'.$this->post['plnmth'].'-'.$this->post['plnyth']));
        $lv_dtefrt = date_create_from_format('d-m-yy', $lv_dtefrt);
        $lv_dtelst = date('d-m-yy', strtotime('-1 day',strtotime('+1 month', strtotime('01-'.$this->post['plnmth'].'-'.$this->post['plnyth']))));
        $lv_dtelst = date_create_from_format('d-m-yy', $lv_dtelst); 
        
        // Recupera los datos de la planificacion para mostrar en la vista.
        // mes actual y, si tiene desplazamiento, mes anterior o mes siguiente evolucionado en el mes actual
        $lo_dtemdl = $this->co_reg->load->model('hltplndte'); 
       	$lv_prm = array('vewmaxrec' => $this->mdl->vewmaxrec,
                        'vewfldflt' =>(($this->post['evlplndte']??'')==''?
																				'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrt->format('Y-m-d 00:00:00').chr(9).$lv_dtelst->format('Y-m-d 23:59:59').chr(9)
																			:
                                        '[~fltrow~]'.chr(9).'ZZ'.chr(9).'( ( pld.evldte IS NULL AND pld.plndte BETWEEN ^'.$lv_dtefrt->format('Y-m-d 00:00:00').'^ AND ^'.$lv_dtelst->format('Y-m-d 23:59:59').'^ )'.
                                        ' OR ( pld.evldte IS NOT NULL AND pld.evldte BETWEEN ^'.$lv_dtefrt->format('Y-m-d').'^ AND ^'.$lv_dtelst->format('Y-m-d').'^ ) )'.chr(9).chr(9).chr(9)).
                                      $this->post['vewfldflt'],
                				'vewfldord' => 'p.pattxt, s.spctxt, r.prstxt, pld.plndte');
        $lo_rs = $lo_dtemdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_rs );
      }
    // O T R O S
    }	else {
      $lo_vew = $this->co_reg->load->controller('grlvew');
      $this->prm['model'] = self::MODEL;
      $this->prm['vewactcod'] = '13';
      $this->prm['srcmtd'] = ($lv_plnvew=='plnpat'?'getPatientsList':($lv_plnvew=='plnprs'?'getProvidersList':''));
      return $lo_vew->index( '00', $this->prm );
    }  
  }
  
  
  function afterSave($lp_dat){
  	$this->post['plnid']=$this->mdl->plnid ?? '';
  	$this->post['plndteid']=$this->mdl->plndteid ?? '';
  }
  
  
  //Recupero registros importantes para la vista HltPlnEdt
   function afterLoad(){ 
      $lv_ret = array();
      $lv_plnid = $this->mdl->plnid ?: ($this->post['plnid'] ?? ($this->prm['plnid'] ?? ''));
      $lv_plndteid = $this->mdl->plndteid ?: ($this->post['plndteid'] ?? ($this->prm['plndteid'] ?? ''));

     	$lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
      $lo_dtemdl = $this->co_reg->load->model('hltplndte');
      $lo_mdlpat = $this->co_reg->load->model('hltpat');

      //Cargo modelo de sysapp
      $lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
      if ( $lo_mdlprm->load( array('mdlcod'=>'HLT') )==false ) {
          return array('error' => array('errtyp'=>'E','errcod'=>-1001,'errtxt'=>$lo_mdlprm->errtxt));
      }
     //Si tengo planificacion cargo modelos de fecha y paciente
			if($lv_plnid != '' && $lv_plndteid != ''){
        
        //Cargo control de fechas
      	$lo_ctrdte_rs = $lo_ctrdtemdl->load( array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid) );
        
        //Cargo fechas de planificacion
        if ( $lo_dtemdl->load( array( 'plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid ))==false) {
            return array('error' => array('errtyp'=>'E','errcod'=>-1002,'errtxt'=>$lo_dtemdl->errtxt));
        }
      }
      $lo_dtemdl->ctrdte = $lo_ctrdte_rs?? array();
      $lv_ret = array('dtedat'=>$lo_dtemdl,'mdlprm'=>$lo_mdlprm);
     	$this->act = ($this->act == '00')? '02':$this->act;
      $this->extraRet = array_merge($this->extraRet,$lv_ret); 
  }
  

  function afterCreate(){
    	$this->afterLoad();
  }
  
  
  // INDEX. metodo principal de la clase
  function additionalFunctions($lp_act){
    $lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
    switch( $lp_act ) {
			//   Q U I T A R   de la   S E R I E
      case '#05':        
        $lo_dtemdl = $this->co_reg->load->model('hltplndte');
				// quito de la serie la planificacion
        if ($this->mdl->removeFromSerie()==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				}
        //Cargo la planificacion nueva
        if($this->mdl->load(array('plnid'=>$this->mdl->plnid))==false){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
        }
        $this->post['plnid'] = $this->mdl->plnid;
				return $this->modify();
        break;
        
        
			//   C O N F I R M A R
      case '#07':
        $lo_dtemdl = $this->co_reg->load->model('hltplndte');
				$lo_dtemdl->popup = ($this->prm['popup']??'');
        //Confirmo fecha de planificacion
        if ( $lo_dtemdl->confirm(array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'plncnfdte'=>$this->post['plncnfdte']))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
        //Cargo planificacion confirmada
				} else if ( $lo_dtemdl->load(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al cargar planificacion (header).'.$lo_dtemdl->errtxt) );
				} else {
          return $this->co_reg->document->getView( 'hltplnedt', array('dtedat'=>$lo_dtemdl,'mdlprm'=>$lo_mdlprm,'actcod'=>'02') );
				}
        break;
			
        
			//   R E C H A Z A R
      case '#09':
				// cargo los datos de planificaci n
				if ( $this->mdl->load(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se pudo cargar la planificaci n ['.$lv_plnid.'/'.$lv_plndteid.']') );
				}

				// obteng correo del usuario
				$lo_usr = $this->co_reg->load->model('syssecusr');
				if ( $lo_usr->load(array('usrcod'=>$this->mdl->cteusr))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se puede notificar al usuario ['.$this->mdl->cteusr.']') );
				}

				// obtengo template de nofificacion
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => 'GRLSTDTXT', 'txtsys' => 0), false) ){
          $lv_usrmsghtm = $lo_txtmdl->txttxt;
				} else {
					$lv_usrmsghtm = 'Se ha rechazado una planificaci n.';
				}

				// envio notificacion a quien cree la planificacion
				$lv_usrmsghtm = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%2]','Planificaci n',$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%3]','Plenificaci n Rechazada',$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%4]','La planificaci n del d a <strong>'.$this->mdl->plndte[0]['plndte']->format("d/m/Y").'</strong> ha sido rechazada.<br>Se indic  el siguiente motivo o fecha probable de replanificaci n:<br><strong>'.($this->co_reg->request->post['rejtxt']==''?'(vacio)':$this->co_reg->request->post['rejtxt']).'</strong>',$lv_usrmsghtm);
				$lo_eml = new tmssMail();
				$lv_prm = array('from'		=> array(array('address'=>'noreply@temasis.com.ar','name'=>$this->co_reg->sec->bustxt)),
												'to'			=> array(array('address'=>$lo_usr->adreml,'name'=>$lo_usr->usrtxt)),
												'subject'	=> $this->co_reg->sec->bustxt . ' - ' . $this->co_reg->language->planning,
												'bodyhtml'=> $lv_usrmsghtm,
												);
				if ( $lo_eml->send($lv_prm) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>$lo_eml->getError()) );
				}
        break;



			// *************************************************
			//
			//   C A L E N D A R I O
			//
			// *************************************************
      // MODIFICAR planificaci n	( fecha inicio / hora inicio / hora fin )
      case '#12':
				$lv_key = array();
				$lv_key['plnid'] = $lv_plnid;
				$lv_key['plndteid'] = $lv_plndteid;
				$lo_dtemdl = $this->co_reg->load->model('hltplndte');
        
				if ( $lv_key['plnid']=='' || $lv_key['plndteid']=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro al menos un parametro [PlnId='.$lv_key['plnid'].'/PlnDteId='.$lv_key['plndteid'].'].') );
				} else if ( $lo_dtemdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
				} else {
					// modifico los datos que se actualizaron en el calendario
					// yyyymmddHHnn => dd/mm/yyyy HH:nn:ss
					$lv_dtearr = str_split($this->post['plnstrdte'],2);
					$lv_dtestr = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1];
					$lv_dtetmestr = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1].' '.$lv_dtearr[4].':'.$lv_dtearr[5].':00';
					$lv_dtearr = str_split($this->post['plnenddte'],2);
					$lv_dtetmeend = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1].' '.$lv_dtearr[4].':'.$lv_dtearr[5].':00';

          $lo_data = $lo_dtemdl->getData();
					$lo_data['plndte'] = $lv_dtestr;
          $lo_data['plndteto'] = $lv_dtestr;
          $lo_data['plninbdte'] = $lv_dtetmestr;
          $lo_data['plnoutdte'] = $lv_dtetmeend;
					// grabo la planificaci n
					if ( $dtemdl->save( $lo_data )==true ) {
 	         	return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
          	return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
					}
				}
				break;

        
			// VER planificaci n (calendario)
			case '#13':
				// obtengo filtro por default
				$lo_fltmdl = $this->co_reg->load->model('grldocflt');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).'HLT_PLN_CAL'.chr(9).chr(9).
																			'[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
											);
				$lo_rs = $lo_fltmdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$this->mdl->vewfldfltdef = $lo_rs[0]['vewfltdat'];
					$this->mdl->vewfltcod = $lo_rs[0]['vewfltcod'];
				}			
        
        $lo_mdlprm->load( array('mdlcod'=>'HLT') );
        
		  	return $this->co_reg->document->getView( 'hltplncal', array('data'=>$this->mdl, 'mdlprm'=>$lo_mdlprm, 'actcod'=>$this->act ) );
				break;

        
			// LISTAR planificaci n (calendario)
      case '#18':
				$this->post = $this->co_reg->request->post;
				$lv_prmhltevl = $this->post['evlplndte']??'';
        
				// busco planificaciones del mes actual 
        // o del mes anterior o mes posterior pero su evolución fue hecha en el mes actual
        $lv_dtepre = date_create_from_format('y-m-d', date('y-m-d',strtotime($this->post['hltplnstrdte'])) );
        $lv_dtepre->modify('+1 day');
        $lv_dtenxt = date_create_from_format('y-m-d', date('y-m-d',strtotime($this->post['hltplnenddte'])) ); 
        $lv_dtenxt->modify('-1 day');  
        $lv_dtenxt->modify('first day of this month');
        
        $lv_diff = $lv_dtepre->diff($lv_dtenxt);
        // si la diferencia es de un mes
        if($lv_diff->days > 27){ //ejemplo: muestro mes de mayo
          // calculo si están a 1 o 2 meses de diferencia (no importa que no sean meses enteros)
          $lv_premth = $lv_dtepre->format('Y') * 12 + (int)$lv_dtepre->format('m') - 1;
        	$lv_endmth = $lv_dtenxt->format('Y') * 12 + (int)$lv_dtenxt->format('m') - 1;
          if($lv_endmth-$lv_premth == 1){
            // dtepre y dtenext son abril y mayo, o mayo y junio
            if($lv_dtepre->format('d')==1){ //dtepre es mayo => retrocedo 1 mes
              $lv_dtepre->modify('-1 month');
            }else{
              //dtenext es mayo => avanzo un mes
              $lv_dtenxt->modify('+1 month');
            }
          } // else: diferencia de 2 meses => dtepre y dtenext son abril y junio
        }else{ 
          // se está mostrando un solo día o semanal
          // caso semanal puede ser una semana con días de abril y mayo, solo días de mayo, o días de mayo y junio
          $lv_dtepre->modify('-1 month');
          $lv_dtenxt->modify('+1 month');
        }
      	$lo_dtemdl = $this->co_reg->load->model('hltplndte');

        $lv_prm = array('vewfldflt' =>((isset($this->post['hltplnstrdte']) && isset($this->post['hltplnenddte']))?
                                     '[~fltrow~](pld.plndte'.chr(9).'BT'.chr(9).chr(9).$this->post['hltplnstrdte'].chr(9).$this->post['hltplnenddte'].chr(9).
                                     '[~fltrow~]'.chr(9).'ZZ'.chr(9).'1=1'.($lv_prmhltevl!=''?') OR (pld.evldte BETWEEN ^'.$this->post['hltplnstrdte'].'^ AND ^'.$this->post['hltplnenddte'].'^':'').')'.chr(9).chr(9).chr(9) : '').
                                     '[~fltrow~]isnull(pld.deldte,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9).
                                     $this->post['vewfldflt'],
                      'vewfldord'	=> ($this->post['vewfldord']??''),
                      'vewmaxrec'	=> (($this->post['vewfldflt']??'')!=''?($this->post['vewmaxrec']??'100'):'10000'),
                      'extra' => (($this->post['vewfldflt']??'')!=''?'':'<rownumber>10</rownumber>')
                      );
				$lo_rs = $lo_dtemdl->getList($lv_prm, array('prgcod'=>'PLP','mdlcod'=>'HLT'));
        if($this->mdl->errtyp=='E'){
					return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        }
        
				$lo_data = array();
				foreach($lo_rs as $lv_row) {
					$lv_data = $lv_row;
					// las fechas con control de prestacion no se pueden mover junto a otras fechas de la misma serie, por eso quito el id
					if ($lv_row['hltplnctrdte']=='') { $lv_data['id'] = $lv_row['plnid']; }
					$lo_data[] = $lv_data;
				}
        return $this->co_reg->document->getJson($lo_data);
        break;

        
      //Cargar vista 
      case '#21':
        return $this->co_reg->document->getView( 'VEW_HLT_PAT_CNT',array('a'=>'Test','b'=>'Test','c'=>'Prueba') );
      	break;	
        
        
			//BORRAR FECHA/EVENTO PERTENECIENTE A UNA SERIE
      case '#24':
       	$this->mdl->deleteEvent();
       	return $this->co_reg->document->getJson(array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
			break;
        
        
			// NOTIFICAR PRESTADOR / PACIENTE
			case '#27':
				$lv_to = array();
				$lv_ntftyp = $this->post['ntftyp'];
				if ( $lv_ntftyp=='PRS' ) {
					$lo_prs_mdl = $this->co_reg->load->model('hltprs');
					$lo_prs_mdl->load( array('prscod'=>$this->mdl->prscod), false );
					$lv_to[] = array('address'=>$lo_prs_mdl->adr->adreml,'name'=>$lo_prs_mdl->prstxt);
				} else {
					$lo_pat_mdl = $this->co_reg->load->model('hltpat');
					$lo_pat_mdl->load( array('patcod'=>$this->mdl->patcod), false );
					$lv_to[] = array('address'=>$lo_pat_mdl->adr->adreml,'name'=>$lo_pat_mdl->pattxt);
				}
        
				if ($this->sendPlanningCalendar( array('ntftyp'=>$lv_ntftyp,'to'=>$lv_to) )==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Se produjo un error al enviar la notificaci n. ('.$this->errtxt.')') );
				} else if ( $lo_dtemdl->confirm(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid,
                                              'prsntfdte'=>$this->post['prsntfdte'],
                                              'patntfdte'=>$this->post['patntfdte']))==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
				} else if( $lo_dtemdl->load(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error al cargar la planificaci&oacute;n (header).'.$lo_dtemdl->errtxt) );
        } else {
					// cargo el control de prestacion
					$lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
					$lo_ctrdte_rs = $lo_ctrdtemdl->load( array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid) );
					$lo_dtemdl->ctrdte = $lo_ctrdte_rs;
					$lo_dtemdl->popup = ($this->prm['popup']??'');
					$lo_dtemdl->plnvew = $lv_plnvew;
          
          // obtengo toda la info de la clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_dtemdl->sysdocclscod) ) ) {
            $lo_dtemdl->sysdoccls = $lo_docclsmdl;
          }
          
          return $this->co_reg->document->getView( 'hltplnedt', array('data'=>$lo_dtemdl, 'mdlprm'=>$lo_mdlprm, 'actcod'=>'02') );
				}
				break;
    	}
    }
  
  
	function sendPlanningCalendar( $lp_prm=array() ) {
		$this->errcod = 0;
		$this->errtxt = '';
		$lv_usrmsghtm = '';
		$lv_usrmsgtxt = '';
		$lv_usrmsgmsg = '';

		$lo_txtmdl = $this->co_reg->load->model('grldattxt');

		// NOTIFICACION A PRESTADOR - TEXTOS
		if ( $lp_prm['ntftyp']=='PRS' ) {
      if( $lo_txtmdl->load(array('txtcodext' => 'HLTPLNCALEVTHTMPRS'), false) ){
        $lv_usrmsghtm = $lo_txtmdl->txttxt;
      } else {
        $lv_usrmsghtm = 'Se ha rechazado una planificaci&oacute;n.';
      }

      if( $lo_txtmdl->load(array('txtcodext' => 'HLTPLNCALEVTTXTPRS'), false) ){
        $lv_usrmsgtxt = $lo_txtmdl->txttxt;
      } else {
        $lv_usrmsgtxt = 'Se ha rechazado una planificaci&oacute;n.';
      }

		// NOTIFICACION A PACIENTES - TEXTOS
		} else {
      if( $lo_txtmdl->load(array('txtcodext' => 'HLTPLNCALEVTHTMPAT'), false) ){
        $lv_usrmsghtm = $lo_txtmdl->txttxt;
      } else {
        $lv_usrmsghtm = 'Se ha rechazado una planificaci&oacute;n.';
      }

      if( $lo_txtmdl->load(array('txtcodext' => 'HLTPLNCALEVTTXTPAT'), false) ){
        $lv_usrmsgtxt = $lo_txtmdl->txttxt;
      } else {
        $lv_usrmsgtxt = 'Se ha rechazado una planificaci&oacute;n.';
      }
		}

		// actualizo las variables del mensaje HTML
		$lv_usrmsghtm = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%2]','Planificaci&oacute;n de prestaci&oacute;n',$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%3]',$this->co_reg->request->post['plndte'],$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%4]',$this->co_reg->request->post['plninbdte'].' - '.$this->co_reg->request->post['plnoutdte'],$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%9]',$this->co_reg->sec->bseurl,$lv_usrmsghtm);
		// actualizo las variables del mensaje TXT
		$lv_usrmsgtxt = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%2]','Planificaci&oacute;n de prestaci&oacute;n',$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%3]',$this->co_reg->request->post['plndte'],$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%4]',$this->co_reg->request->post['plninbdte'].' - '.$this->co_reg->request->post['plnoutdte'],$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%9]',$this->co_reg->sec->bseurl,$lv_usrmsgtxt);

		// envio el calendario
		$lo_eml = new tmssMail();
		$lv_inbtme=DateTime::createFromFormat('d/m/Y H:i', $this->co_reg->request->post['plndte'].' '.$this->co_reg->request->post['plninbdte']);
		$lv_outtme=DateTime::createFromFormat('d/m/Y H:i', $this->co_reg->request->post['plndte'].' '.$this->co_reg->request->post['plnoutdte']);
		$lv_prm = array('name'=> $this->co_reg->sec->bustxt,
										'emlttl' => $this->co_reg->sec->bustxt . ' - ' . $this->co_reg->language->planning,
										'emlbdyhtm' => $lv_usrmsghtm,
										'emlbdytxt' => $lv_usrmsgtxt,
										'emlto'			=> $lp_prm['to'],
										'calevtttl' => $this->co_reg->language->planning,
										'calevttxt' => $lv_usrmsgmsg,
										'calevtorg'	=> $this->co_reg->sec->bustxt,
										'calevtloc'	=> 'Consulte sistema de gestión on-line',
										'calevturl' => 'https://temasis.com.ar/gestion',
										'calevtstr' => $lv_inbtme,
										'calevtend' => $lv_outtme
										);
		if ( $lo_eml->sendCalendarEvent($lv_prm) ) {
			return true;
		} else {
			$this->errcod = -1;
			$this->errtxt = $lo_eml->getError();
			return false;
		}
	}
}
