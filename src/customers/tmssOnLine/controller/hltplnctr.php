<?php
final class hltplnctrController extends tmssController {
	const MODEL = 'hltplnctr';					
	const VIEW  = 'hltplnctr';					
	const ID = 'hltplnctrcod';					
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  // INDEX. metodo principal
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


      // SAVE
      case '#00': 
        $lo_post = $this->co_reg->request->post;
        $lv_buffer = $lo_post['hltplncrtdte'] ? json_decode(html_entity_decode($lo_post['hltplncrtdte']), true) : '';
        if($lv_buffer != ''){
          if ( $this->lo_mdl->save() ) {
            // grabar todas las planificaciones
            $lo_docdte = $this->co_reg->load->model('hltplnctrdte');
            foreach( $lv_buffer as $lv_row ) {
              $lv_row['hltplnctrcod'] = $this->lo_mdl->hltplnctrcod;
              $lv_row['plnyth'] = $lo_post['plnyth'];
              $lv_row['plnmth'] = $lo_post['plnmth'];
              $lv_row['docsts'] = 'A';
              if ($lo_docdte->save( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_docdte->errtyp,'errcod'=>$lo_docdte->errcod,'errtxt'=>$lo_docdte->errtxt) );
              } else {
                $lv_row['hltplnctrdtecod'] = $lo_docdte->hltplnctrdtecod;
              }
              if ( isset($lv_row['cancel']) && $lv_row['cancel'] ) { 
                if ($lo_docdte->cancel( $lv_row )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_docdte->errtyp,'errcod'=>$lo_docdte->errcod,'errtxt'=>$lo_docdte->errtxt) );							
                } 
              }
              if ( isset($lv_row['deleted']) ) { 
                if ($lo_docdte->delete( $lv_row )==false) {

                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_docdte->errtyp,'errcod'=>$lo_docdte->errcod,'errtxt'=>$lo_docdte->errtxt) );							
                }
              }
            }
            
            // cargo los datos de cabecera
            $lv_key = array( 'hltplnctrcod' => $this->lo_mdl->hltplnctrcod );
            if ( $this->lo_mdl->load($lv_key)==false ) {
              return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
            }

            // cargo parámetro de fecha de control
            $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
            $lo_prmmdl->load(array('mdlcod'=>'HLT'));
            $this->lo_mdl->dteprm = $this->co_reg->document->getTagValue(strtoupper($lo_prmmdl->mdlatrval001),'STS_CTR_PLN_DTE');
            
            return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
          } else {
            return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          }
          
        }
        return $this->index('03', $lp_prm);
        
        break;
			
			
      // CHANGE - DISPLAY
      case '#02': case '#03':
        if(isset($lp_prm[self::ID]) && $lp_prm[self::ID]){
        	// cargo control
          if ( $this->lo_mdl->load(array(self::ID=>$lp_prm[self::ID]))==false ) {
          	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          }
        }else{
        	$lo_post = $this->co_reg->request->post;
          $lv_data = array('plndte'=>DateTime::createFromFormat('Y-m-d',($lp_prm['plnyth']??$lo_post['plnyth']).'-'.($lp_prm['plnmth']??$lo_post['plnmth']).'-01'), 
													'plnyth'=>$lp_prm['plnyth']??$lo_post['plnyth'],
													'plnmth'=>$lp_prm['plnmth']??$lo_post['plnmth'],
													'docsts'=>'A'); 

					// cargo datos de paciente
          $lo_patmdl = $this->co_reg->load->model('hltpat');
					$lo_patmdl->load(array('patcod'=>$lp_prm['patcod']??$lo_post['patcod']));
					$lv_data['patcod'] = $lo_patmdl->patcod;
					$lv_data['pattxt'] = $lo_patmdl->pattxt;
					$lv_data['cuscod'] = $lo_patmdl->cuscod;
					$lv_data['custxt'] = $lo_patmdl->custxt;
					
					// cargo datos de especialidad
					$lo_spcmdl = $this->co_reg->load->model('hltspc');
					$lo_spcmdl->load(array('spccod'=>$lp_prm['spccod']??$lo_post['spccod']));
					$lv_data['spccod'] = $lo_spcmdl->spccod;
					$lv_data['spctxt'] = $lo_spcmdl->spctxt;
					$lv_data['spcctrtyp'] = $lo_spcmdl->spcctrtyp;	// tipo de control: define columnas entrada/salida/diferencia (1) o sesiones (2)

					// cargo detalle de control pendiente
          $lo_dtemdl = $this->co_reg->load->model('hltplnctrdte');
          $lv_prm = array('plnyth' => $lp_prm['plnyth']??$lo_post['plnyth'],
                          'plnmth' => $lp_prm['plnmth']??$lo_post['plnmth'],
                          'patcod' => $lp_prm['patcod']??$lo_post['patcod'],
                          'spccod' => $lp_prm['spccod']??$lo_post['spccod']);
          $lv_data['hltplnctrdtelst'] = $lo_dtemdl->getPending(array(), $lv_prm);

          $this->lo_mdl->setData($lv_data);
        }
				
        // cargo parámetro de fecha de control
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
        $lo_prmmdl->load(array('mdlcod'=>'HLT'));
        $this->lo_mdl->dteprm = $this->co_reg->document->getTagValue(strtoupper($lo_prmmdl->mdlatrval001),'STS_CTR_PLN_DTE');
        
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;


			// CONTABILIZAR
      case '#09':
				$this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
        
      // DESCOTABILIZAR
      case '#29':
        $this->lo_mdl->accountingcancel();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;

        
      //REALIZAR UN CONTROL (desde el calendario)
			case '#ctrcal':
        $lo_post = $this->co_reg->request->post;
        $lv_date = DateTime::createFromFormat('d/m/Y', $lo_post['hltplndte']);
        $lo_post['plnyth'] = $lv_date->format('Y');
        $lo_post['plnmth'] = $lv_date->format('m');
				$lo_post['docsts'] = 'A';
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_patmdl->load(array('patcod'=>$lo_post['patcod']));
        $lo_post['cuscod'] = $lo_patmdl->cuscod;
        
        if($this->lo_mdl->save($lo_post)==false){
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }else{
          $lo_plnctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
          $lv_plndteprm = array();
          $lv_plndteprm['hltplnctrcod'] = $this->lo_mdl->hltplnctrcod;
          $lv_plndteprm['plnid'] = $lo_post['plnid'];
          $lv_plndteprm['plndteid'] = $lo_post['plndteid'];
          $lv_plndteprm['hltplnctrdte'] = $lo_post['hltplndte'];
          $lv_plndteprm['hltplnctrinbdte'] = $lo_post['plninbdte'];
          $lv_plndteprm['hltplnctroutdte'] = $lo_post['plnoutdte'];
          $lv_plndteprm['hltplnctrqty'] = $lo_post['plnqty'];
          $lv_plndteprm['hltplnctrtme'] = $lo_post['plntme'];
          $lv_plndteprm['spccod'] = $lo_post['spccod'];
          $lv_plndteprm['prscod'] = $lo_post['prscod'];
          $lv_plndteprm['plnyth'] = $lv_date->format('Y');
          $lv_plndteprm['plnmth'] = $lv_date->format('m');
          $lv_plndteprm['hltplnctrcmt'] = (isset($lo_post['plncmt']) ? $lo_post['plncmt'] : '');
          $lv_plndteprm['docsts'] = 'A';
          
          if($lo_plnctrdtemdl->save($lv_plndteprm)==false){
            return $this->co_reg->document->getJson( array('errtyp'=>$lo_plnctrdtemdl->errtyp,'errcod'=>$lo_plnctrdtemdl->errcod,'errtxt'=>$lo_plnctrdtemdl->errtxt) );
          }else{
            if (isset($lo_post['cancel'])) {
              $lv_plndteprm['hltplnctrdtecod'] = $lo_plnctrdtemdl->hltplnctrdtecod;
              if ($lo_plnctrdtemdl->cancel( $lv_plndteprm )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_plnctrdtemdl->errtyp,'errcod'=>$lo_plnctrdtemdl->errcod,'errtxt'=>$lo_plnctrdtemdl->errtxt) );							
              }
            }
            return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') ); 
          }
        }
        break;
       
			 
      // FILTRO PERSONALIZADO.
      case '#plnflt':
        $lo_post = $this->co_reg->request->post;
        $lo_dte_mdl = $this->co_reg->load->model('hltplnctrdte');
        
        //CONDICION FILTRO.
        $lp_fldflt = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
				$lp_vewmaxrec = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'100');
        
				$lv_vew = array('vewfldflt' => $lp_fldflt,				
												'vewmaxrec' => $lp_vewmaxrec );
        
        if($lo_post[self::ID] == ''){
          $lv_prm = array('plnyth' => (isset($lo_post['plnyth'])?$lo_post['plnyth']:''),
                          'plnmth' => (isset($lo_post['plnmth'])?$lo_post['plnmth']:''),
                          'patcod' => (isset($lo_post['patcod'])?$lo_post['patcod']:''),
                          'spccod' => (isset($lo_post['spccod'])?$lo_post['spccod']:'') );
          
        	$lo_data = $lo_dte_mdl->getPending($lv_vew, $lv_prm);
        }else{
          $lv_prm[self::ID] = $lo_post[self::ID];
          $lo_data = $lo_dte_mdl->getList($lv_vew, $lv_prm);
        }
        
        return $this->co_reg->document->getJson( $lo_data );		
        break;
        
      case "#pnd":
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        $lp_prm['vewcod'] = 'VEW_HLT_PLN_CTR_PND';
        $lp_prm['srcmtd'] = 'getPending';
        //$lp_prm['vewfldord'] = 'YEAR(pd.plndte) DESC, MONTH(pd.plndte) DESC, a.pattxt';
        //$lp_prm['vewfldgrp'] = 'YEAR(pd.plndte), MONTH(pd.plndte), p.patcod, a.pattxt, c.cuscod, c.custxt, p.spccod, s.spctxt, s.spcctrtyp';
        //$lp_prm['vewfldgrpcal'] = 'MIN(pd.plnid) as plnid, YEAR(pd.plndte) as plnyth, MONTH(pd.plndte) as plnmth';
        return $lo_vew->index( '00', $lp_prm );
        break;
    }
  }
}
?>