<?php 
final class sysintController extends tmssController2 {
  function initialize(){
    $this->CONTROLLER='sysint';$this->MODEL='sysint';$this->VIEW='sysint';$this->ID='sysintcod';$this->enable_sysdoccls=false;
  }
  
	function additionalFunctions($lp_act){
  	switch ( $lp_act ) {
      
      // **********************************************************************************************
      // ****** MIGRAR COMO 18 a controlador grldattsk ***************
      // **********************************************************************************************
      // obtengo frecuencias 
      case '#getFrequencyList':
        $lo_post = $this->co_reg->request->post;
        $lo_tskmdl = $this->co_reg->load->model('grldattsk');				
        $lv_prm = array('vewfldflt' =>'[~fltrow~]t.srcobjtyp'.chr(9).''.chr(9).($lo_post['srcobjtyp']??'').chr(9).chr(9).chr(9).
                                      '[~fltrow~]t.srcobjcod001'.chr(9).'='.chr(9).chr(9).($lo_post['srcobjcod']??'').chr(9).chr(9),
                        'vewmaxrec' => '100',	'vewfldord' =>'ctedte asc');
        $lo_rs = $lo_tskmdl->getlist( $lv_prm );
        return $this->co_reg->document->getJson ( $lo_rs );
        break;
      // **********************************************************************************************
			
      
			//   D A S H B O A R D
      case '#dsh':
        $lo_ret =array();

				if(($this->post['typ']??'')!=''){
					$lv_prm = array('vewfldflt'=>	'');
					switch( $this->post['typ'] ){
						case 'active':	// ACTIVOS
							$lv_prm['vewfldflt'].='[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='i.docsts';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'status':	// ESTADOS
              $lv_prm['vewfldflt'].='[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='i.sysintLstRunSts';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'inteface_list':
              $lv_prm['vewfldflt'].='[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
							$lv_prm['vewfldord'] ='i.sysinttxt';
							$lv_prm['vewmaxrec'] = 500;
							break;
					}
					$lo_rs = $this->mdl->getList($lv_prm, null, null, false);					
					return $this->co_reg->document->getJson( $lo_rs );
				}

        // RETURN. devuelve la vista con los datos
        return $this->co_reg->document->getView('sysintdsh', array());
        break;        
      
      
      //  LOG de EJECUCION
      case '#getlog':
        $lo_post = $this->co_reg->request->post;
        $lo_logmdl = $this->co_reg->load->model('sysapplog');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
                                      '[~fltrow~]l.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9),
                        'vewmaxrec'=>100,
                        'vewfldord'=>'l.ctedte desc'
                        );
        $lo_rs = $lo_logmdl->getList( $lv_prm );
        return $this->co_reg->document->getJson( $lo_rs );
        break;
      
      
			// EXECUTE. ejecuta la interfaz
      case '#10':
				$lo_post = $this->co_reg->request->post;
        //$this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_data = array();
				
				// obtiene los datos de la interfaz
				if( $this->mdl->load(array( 'sysintcod'=>($lo_post['sysintcod']??''), 'sysintcodext'=>($lo_post['sysintcodext']??'') ))==false){
					return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				}
				
        // valido URL
				if($this->mdl->sysinturl==''){
          return $this->co_reg->document->getJson( array('errtyp'=>'W','errcod'=>0,'errtxt'=>'No hay URL definida para ejecutar.') );
        }
        
				// llama al controlador de la interfaz
        $lv_prm = $this->co_reg->document->getCallComponents( $this->mdl->sysinturl );

        // valido estructura de URL
        if ( $lv_prm['prg']=='' || $lv_prm['act']=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'W','errcod'=>0,'errtxt'=>'La URL INTERNA que intenta ejecutar no tiene una estructura valida.') );
        }
				
        // asigno datos de interfaz actual (se pasan por POST a parametro SYSINT)
        $this->co_reg->request->post['sysint'] = $this->mdl->getData();
        // convierto los atributos de la interfaz en una array
        $lv_xml = $this->co_reg->request->post['sysint']['sysintatr'];
        $this->co_reg->request->post['sysint']['sysintatr'] = $this->co_reg->document->getArrayFromXML( $lv_xml );

        // ejecuto interfaz
        try{
          $lo_ctr = $this->co_reg->load->controller( $lv_prm['prg'] );
          $lv_dat = $lo_ctr->index( $lv_prm['act'] , $lv_prm['prm'] );
        } catch (Exception $e) {
          $lv_dat = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error no controlado en el programa de interfaz.','errlog'=>$e->getMessage() );
        }

        // verifico la respuesta de la interfaz. debe ser un array
        if( !is_array($lv_dat) ){
          $lv_datret = $lv_dat;
          $lv_dat = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Los datos devuelvos por la interfaz no tienen una estructura de array valida.','errtch'=>'Respuesta: '.(is_null($lv_datret)?'null':$lv_datret) );
        }
				
        // graba el log en el log de aplicaciones
        $lo_intmdl = $this->co_reg->load->model('sysint');
        $lv_log = array();
        $lv_log['sysintcod'] = $this->mdl->sysintcod;
        $lv_log['sysintcodext'] = $this->mdl->sysintcodext;
        $lv_log['sysinttxt'] = $this->mdl->sysinttxt;
        $lv_log['errtyp'] = ($lv_dat['errtyp']??'E'); // error - tipo (E/W/S)
        $lv_log['errcod'] = ($lv_dat['errcod']??'-1'); // error - codigo
        $lv_log['errtxt'] = ($lv_dat['errtxt']??'Respuesta de interfaz invalida.'); // error - descripcion
        $lv_log['errlog'] = ($lv_dat['errlog']??''); // error - log extendido
        $lv_log['errtch'] = ($lv_dat['errtch']??''); // error - log tecnico
        $lo_intmdl->setRunData( $lv_log );
				
        // NOTIFICACION DE ERRORES
        if( $lv_log['errtyp']=='E' && $this->mdl->sysinterrntf!='' ){
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          if( $lo_txtmdl->load( array('txtcodext'=>'SYSINTERRNTF', 'txtsys'=>0)) ){

            $lv_subject = 'ERROR INTERFAZ: '.$this->mdl->sysinttxt;
            
            // armo lista de destinatarios (separados por ;)
            $lv_to = array();
            $lv_ntflst = explode(PHP_EOL, $this->mdl->sysinterrntf);
            foreach( $lv_ntflst as $lv_row){ $lv_to[] = array('address'=>$lv_row); }
            
            // reemplazo variables del mensaje por valoes de $lv_log
            $lv_txt = $lo_txtmdl->txttxt;
            foreach( $lv_log as $lv_key=>$lv_val ){	$lv_txt = str_ireplace( '[%'.$lv_key.']', $lv_val, $lv_txt ); }
            
            if( count($lv_to)>0 ){
              // MAIL. armo y envio mail
              $lo_eml = new tmssMail();
              $lv_emlprm = array( 'to'=>$lv_to, 'subject'=>$lv_subject, 'from'=>array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis Argentina SRL') ), 'bodyhtml'=>$lv_txt);
              if ( !$lo_eml->send( $lv_emlprm ) ) {
                var_dump( $lo_eml->getError() );
                // -******* SE DEBE GRABAR LOS DE NOTIFICACION FALLIDA ??? *****************
                //$lv_ret['errlog'] = 'Error al enviar email a cliente ['.$lv_dat['srcobjcod'].' - '.$lv_dat['srcobjtxt'].']: '.$lo_eml->getError();
              }
            }
            
          }
        }
        
        // devuelve lo devuelto por la interfaz como json???
        return $this->co_reg->document->getJson( $lv_dat );
				break;
    }
  }
}
?>