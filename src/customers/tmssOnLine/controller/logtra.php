<?php
final class logtraController extends tmssController2 {
  
  function initialize(){
    $this->CONTROLLER = 'logtra';
    $this->MODEL = 'logtra';
    $this->VIEW = 'logtra';
		$this->ID = 'tracod';
    $this->OBJTYP = 'LOG_TRA';
    $this->enable_sysdoccls=true;
  }
	
  function beforeGetList(){
    if(!isset($this->prm['vewfldflt'])){$this->prm['vewfldflt']='';}
		if(isset($this->prm['objtyp'])) {$this->prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$this->prm['objtyp'].chr(9).chr(9); }
  }
  
  function beforeLoad(){
    if (!isset($this->prm[$this->ID]) && !isset($this->post[$this->ID])) {
      $this->err = [
        'errtyp'=>'E',
        'errcod'=>-1,
        'errtxt'=>'No se indico parametro ['.$this->ID.'].'
      ];
      return;
    }

    $lv_objtyp = ($this->prm['prgcod'] ?? 'tra') != 'tra' ? 'LOG_TRK' : $this->OBJTYP;
    $this->prm['objtyp'] = $lv_objtyp;
  }
  
  function afterCopy(){
    $this->mdl->tracod = '';
    $this->mdl->ctedte = '';
    $this->mdl->cteusr = '';
    $this->mdl->upddte = '';
    $this->mdl->updusr = '';
    $this->mdl->dlv = '';
    $this->mdl->trastrdte = '';
    $this->mdl->traenddte = '';
    
    if (($this->prm['vewcod'] ?? '') == "vew_log_tra_trk") {
        $this->VIEW = 'logtratrk';
    }
  }
  
public function view() {
    if (($this->prm['vewcod'] ?? '') == "vew_log_tra_trk") {
        $this->VIEW = 'logtratrk';
    }

    return parent::view();
}
	
  public function modify() {
    return $this->view();  
  }
  
	  function additionalFunctions($lp_act){
	    switch ( $lp_act ) {

	      // SET TRANSPORT DATES
      case '#25':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_post = $this->post;
        $this->mdl->setDates( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        break;
			
			
			// DELIVERY ADD
			case '#21':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_post = $this->post;
				
				// cargo las clases de documento relevantes para transporte
				$lo_docmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dbo.gettagvalue(^logtrarel^, sysdocclsatr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'d.sysdocclstxt');
				$lo_rs = $lo_docmdl->getList( $lv_prm );
				
				// obtengo datos de la ruta
				$lo_roumdl = $this->co_reg->load->model('logtrarou');
				$lo_roumdl->load( array('traroucod'=>$lo_post['traroucod']), false );
				$this->mdl->trarou = $lo_roumdl;
				
				$this->mdl->refarr = $lo_post['refarr'];
				return $this->co_reg->document->getView('logtradlvadd',array('data'=>$this->mdl, 'doccls' => $lo_rs, 'actcod'=>$lp_act, 'model' => $this->MODEL));
        break;
        
			// DELIVERY FIND
			case '#27':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_post = $this->post;
				
				$lv_strdte = $this->co_reg->db->sqldate($lo_post['docfndstrdte']);
				$lv_strdte = substr($lv_strdte,0,4).'-'.substr($lv_strdte,4,2).'-'.substr($lv_strdte,6,2);
				$lv_enddte = $this->co_reg->db->sqldate($lo_post['docfndenddte']);
				$lv_enddte = substr($lv_enddte,0,4).'-'.substr($lv_enddte,4,2).'-'.substr($lv_enddte,6,2);
				
				if ($lo_post['refarr']=='') {
					$lo_refarr = array();
				} else {
					$lo_refarr = json_decode(html_entity_decode($lo_post['refarr']),true);
				}
  
				// obtengo entregas NO inactivas, NO confirmadas/NO relevantes para confirmación
				$lo_dlvmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]d.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																		($lo_post['docfndcod']!=''?'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
                        						($lo_post['docfndcod']!=''?'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
																		($lo_post['docfndcodext']!=''?'[~fltrow~]d.stkmovdoccodext'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcodext'].chr(9).chr(9):'').
																		'[~fltrow~]dbo.gettagvalue(^cnftyp^, d.stkmovdoccnf)'.chr(9).'<>'.chr(9).chr(9).'SI'.chr(9).chr(9).
																		'[~fltrow~]d.traroucod'.chr(9).'='.chr(9).chr(9).$lo_post['traroucod'].chr(9).chr(9).
																		'[~fltrow~]d.stkmovdocdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																		'[~fltrow~]d.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
												'vewfldord'=>'d.stkmovdocdte');
				$lo_rs = $lo_dlvmdl->getList( $lv_prm, null, null, false );
				// obtengo entregas de transportes NO finalizados
				$lo_tradlvmdl = $this->co_reg->load->model('logtradlv');
				$lv_prm = array('vewfldflt'=>'[~fltrow~]isnull(t.traenddte,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9).
																		 '[~fltrow~]t.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9) );
				$lo_rstradlv = $lo_tradlvmdl->getList( $lv_prm );
				
				// devuelvo entregas no asignadas al transporte actual
				$lo_ret = array();
				foreach($lo_rs as $lv_row){
					$lv_found = false;
					// NO devuelvo las entregas ya incluidas en la planificación actual
					foreach($lo_refarr as $lv_rowref) {
            if ( $lv_row['stkmovdoccod']==$lv_rowref ) { $lv_found = true; break; }
					}
					// NO devuelvo las entregas de transportes existentes y no finalizados
					foreach($lo_rstradlv as $lv_rowtra) {
						if ( $lv_row['stkmovdoccod']==$lv_rowtra['stkmovdoccod'] ) { $lv_found = true; break; }
					}
					if($lv_found==false){
						$lo_ret[] = array('doccod'=>$lv_row['stkmovdoccod'],
                              'stkmovdoccod'=>$lv_row['stkmovdoccod'],
															'doccodext'=>$lv_row['stkmovdoccodext'],
															'docdte'=>$lv_row['stkmovdocdtecnv'],
															'docatr'=>$lv_row['dstobjtxt'],
															'srcobjtxt'=>$lv_row['srcobjtxt'],
															'srccnttxt'=>$lv_row['srccnttxt'],
                              'srcobjcod'=>$lv_row['srcobjcod'],
                              'srccntcod'=>$lv_row['srccntcod'],
                              'srcobjtyp'=>$lv_row['srcobjtyp'],
															'dstobjtxt'=>$lv_row['dstobjtxt'],
                              'dstobjcod'=>$lv_row['dstobjcod'],
															'dstcnttxt'=>$lv_row['dstcnttxt'],
                              'dstcntcod'=>$lv_row['dstcntcod'],
                              'dstobjtyp'=>$lv_row['dstobjtyp'],
                              'srcobjmapgeo'=>$lv_row['srcobjmapgeo']??'', 
                              'srccntmapgeo'=>$lv_row['srccntmapgeo']??'',
                              'dstobjmapgeo'=>$lv_row['dstobjmapgeo']??'',
                              'dstcntmapgeo'=>$lv_row['dstcntmapgeo']??'',
                            	'ctedte'=>$lv_row['ctedte']->format('d/m H:i'),
                              'accdte'=> (!empty($lv_row['accdte']) && method_exists($lv_row['accdte'],'format')) ? $lv_row['accdte']->format('d/m H:i') : '',
                              'docsts'=>$lv_row['docsts']);
					}
				}
				
        return $this->co_reg->document->getJson( $lo_ret );
				break;
    }
  }
}
?>
