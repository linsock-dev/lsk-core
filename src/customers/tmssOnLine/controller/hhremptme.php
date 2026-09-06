<?php
final class hhremptmeController extends tmssController {
	const MODEL = 'hhremptme';
	const VIEW  = 'hhremptme';
	const ID = 'hhremptmecod';
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
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;				
				$lv_buffer = $lo_post['hhremptme'];
				if ($lv_buffer!='') {
					$i=0;
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_tmearr = json_decode($lv_buffer,true);
					foreach( $lv_tmearr as $lv_row ) {
						$lv_row['hhrempcod'] = $lo_post['hhrempcod'];
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'row'=>$i) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'row'=>$i) );
						}
						$i++;
					}
				}
				
				// cargo horarios
				$lo_tmemdl = $this->co_reg->load->model('hhremptme');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]et.hhrempcod'.chr(9).'='.chr(9).chr(9).$lo_post['hhrempcod'].chr(9).chr(9).
																			'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => ' wp.wrkplctxt, ws.wrkstetxt, tr.hhrtmerngtxt ' );		
				$lo_rs = $lo_tmemdl->getList( $lv_prm );
				$this->lo_mdl->hhremptme = $lo_rs;
				
				$this->lo_mdl->hhrempcod = $lo_post['hhrempcod'];
				$this->data['actcod'] = '02';
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
			case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
				
				// cargo horarios
				$lo_tmemdl = $this->co_reg->load->model('hhremptme');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]et.hhrempcod'.chr(9).'='.chr(9).chr(9).$lo_post['hhrempcod'].chr(9).chr(9).
																			'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => ' wp.wrkplctxt, ws.wrkstetxt, tr.hhrtmerngtxt ' );		
				$lo_rs = $lo_tmemdl->getList( $lv_prm );
				$this->lo_mdl->hhremptme = $lo_rs;
				
				$this->lo_mdl->hhrempcod = $lo_post['hhrempcod'];
				$this->data['actcod'] = '02';
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
        
        
			// LIST by WORK STATION
      case '#18': 
				$lo_post = $this->co_reg->request->post;
        $lv_hhremptmedte = "";
        if(isset($lo_post['hhremptmedte'])){
          $lv_hhremptmedte = str_replace('/', '-', $lo_post['hhremptmedte']);
          $lv_hhremptmedte = date('Y-m-d', strtotime($lv_hhremptmedte));
        }
        
        $lv_prm = array('vewfldflt' => (isset($lp_prm['wrkstecod'])?'[~fltrow~]et.wrkstecod'.chr(9).'='.chr(9).chr(9).$lp_prm['wrkstecod'].chr(9).chr(9):'').
                        							($lv_hhremptmedte?'[~fltrow~]et.hhremptmestr'.chr(9).'<='.chr(9).chr(9).$lv_hhremptmedte.chr(9).chr(9):'').
																			($lv_hhremptmedte?'[~fltrow~]et.hhremptmeend'.chr(9).'>='.chr(9).chr(9).$lv_hhremptmedte.chr(9).chr(9):'').
																			'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);	
        
        if(!isset($lo_post['nomaxrec'])){
          $lv_prm['vewmaxrec'] = '10';
        }
					
        
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'data'=>$lo_data) );
        break;	
			
        
			// TIME GRID. muestra vista de horarios de empleados
			case '#timegrid':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				
				// FECHAS. determino las fechas iniciales de inicio y fin
				$this->lo_mdl->curdte = new DateTime();
				$this->lo_mdl->strdte = new DateTime('first day of this month');
				$this->lo_mdl->enddte = new DateTime('first day of this month');
				$this->lo_mdl->enddte->modify('+1 month')->modify('-1 day');
				
				return $this->co_reg->document->getView( 'hhremptmegrd', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			// TIME GRID - DATA. devuelve los datos para la grilla de tiempos
			case '#timegrid_data':
				$lo_post = $this->co_reg->request->post;
        $lv_flt = json_decode(html_entity_decode($lo_post['vewfld']??''),true);
        $lv_flt = (is_array($lv_flt)?$lv_flt:array('fltstr'=>'','maxrec'=>'1000'));
				$lv_1day = new DateInterval('P1D');
				$lv_1mth = new DateInterval('P1M');
				$this->lo_mdl->create();
				
				// FECHAS. determino primer dia y ultimo dia del mes
				$lv_strdte = date_create_from_format('Y-m-d',$lo_post['plnyth'].'-'.$lo_post['plnmth'].'-01');
				$lv_enddte = clone $lv_strdte;
				$lv_enddte->add( $lv_1mth );
				$lv_enddte->sub( $lv_1day );
				
				// CALENDARIO. Recuperar Calendario de la Empresa (para saber el horario laboral)
				$lo_calasgmdl = $this->co_reg->load->model('grlcalasg');
				$lo_calmdl = $this->co_reg->load->model('grlcal');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ca.srcobjtyp'.chr(9).'='.chr(9).chr(9).'ADM_BUS'.chr(9).chr(9).
																			'[~fltrow~]ca.srcobjcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9),
																			'[~fltrow~]ca.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));		
				$lo_rs = $lo_calasgmdl->getList( $lv_prm );
				// si la empresa tiene calendario asociado lo cargo
				if(count($lo_rs)>0){ $lo_calmdl->load( array('grlcalcod'=>$lo_rs[0]['grlcalcod']) ); }
				$lo_rscal = $lo_calmdl->getData();
				
				// FERIADOS. Recuperar Feriados Nacionales (del país del lugar de trabajo)
				$lo_calhldmdl = $this->co_reg->load->model('admhldmov');
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]hm.hldmovday'.chr(9).'BT'.chr(9).chr(9).$lo_post['strdte'].chr(9).$lo_post['enddte'].chr(9).
																			'[~fltrow~]h.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'hm.hldmovday' );
				$lo_rshld = $lo_calhldmdl->getList( $lv_prm );				
				
				// EMPLEADOS. Recuperar empleados activos
				$lo_empmdl = $this->co_reg->load->model('hhremp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]isnull(p.hhrempoutdte,getdate()) >= getdate()'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~]p.hhrempinbdte <= getdate()'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			$lv_flt['fltstr'],
												'vewmaxrec'=> $lv_flt['maxrec'],
                        'vewfldord' => ' p.hhremptxt',
                       	'extra' => ('<avoiduserrestrictions>X</avoiduserrestrictions>'));		
				$lo_rsemp = $lo_empmdl->getList( $lv_prm, null, null, false);
				// armo array con clave de empleados
				$lv_emp = array();
				foreach($lo_rsemp as $lv_row){
					$lv_emp[$lv_row['hhrempcod']] = array('emp'=>$lv_row,'trn'=>array(),'lic'=>array(),'ass'=>array());
				}
				// TURNOS. Recuperar horarios de cada empleado
				$lo_tmemdl = $this->co_reg->load->model('hhremptme');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]et.hhremptmestr'.chr(9).'<='.chr(9).chr(9).date_format($lv_enddte,'Ymd').chr(9).chr(9).
																			'[~fltrow~]et.hhremptmeend'.chr(9).'>='.chr(9).chr(9).date_format($lv_strdte,'Ymd').chr(9).chr(9).
																			'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							$lv_flt['fltstr'],
												'vewmaxrec'=> $lv_flt['maxrec'],
												'vewfldord' => ' p.hhremptxt ' );		
				$lo_rsemptme = $lo_tmemdl->getList( $lv_prm );
				// asigna los turnos por cada empleado recuperado
        foreach($lo_rsemptme as $lv_row){
					if(isset($lv_emp[$lv_row['hhrempcod']])){
						$lv_emp[$lv_row['hhrempcod']]['trn'][] = $lv_row;
					}
				}
				// LICENCIAS. Recuperar Licencias de cada empleado
				$lo_licmdl = $this->co_reg->load->model('hhrlic');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]l.hhrlicdtestr'.chr(9).'<='.chr(9).chr(9).date_format($lv_enddte,'Y-m-d').chr(9).chr(9).
																			'[~fltrow~]l.hhrlicdteend'.chr(9).'>='.chr(9).chr(9).date_format($lv_strdte,'Y-m-d').chr(9).chr(9).
																			'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
                                      '[~fltrow~]gw.relsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => ' a.adrnme001 ' );
				$lo_rsemplic = $lo_licmdl->getlist( $lv_prm, null, null, false );
				foreach($lo_rsemplic as $lv_row){
					if(isset($lv_emp[$lv_row['srcobjcod']])){
						$lv_emp[$lv_row['srcobjcod']]['lic'][] = $lv_row;
					}
				}
				
				// FICHADAS. recupero las fichadas del mes
				$lo_assmdl = $this->co_reg->load->model('hhrass');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]l.hhrassdte'.chr(9).'<='.chr(9).chr(9).date_format($lv_enddte,'Y-m-d').chr(9).chr(9).
																			'[~fltrow~]l.hhrassdte'.chr(9).'>='.chr(9).chr(9).date_format($lv_strdte,'Y-m-d').chr(9).chr(9).
																			'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );		
				$lo_rstmeass = $lo_assmdl->getList( $lv_prm, null, null, false );
				foreach($lo_rstmeass as $lv_row){
					if(isset($lv_emp[$lv_row['srcobjcod']])){
						$lv_emp[$lv_row['srcobjcod']]['ass'][] = $lv_row;
					}
				}
				
				return $this->co_reg->document->getJson( array('emparr'=>$lv_emp, 'cal'=>$lo_rscal, 'hld'=>$lo_rshld, 'strdte'=>$lv_strdte, 'enddte'=>$lv_enddte) );
				break;
					
    }
  }
}
?>