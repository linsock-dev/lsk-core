<?php
final class cnssteevtController extends tmssController {
	const CONTROLLER = 'cnssteevt';
	const MODEL = 'cnssteevt';
	const VIEW  = 'cnssteevt';
	const ID = 'steevtcod';
	const OBJTYP = 'CNS_EVT';
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
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

    // recupero parámetros
    $lo_post = $this->co_reg->request->post;
    $lv_view_arr = array();
    $lv_view_arr['dateOnly'] = (isset($lp_prm['dateOnly']) ? $lp_prm['dateOnly'] : (isset($lo_post['dateOnly']) ? $lo_post['dateOnly'] : ''));
    $lv_view_arr['title'] = (isset($lp_prm['title']) ? $lp_prm['title'] : (isset($lo_post['title']) ? $lo_post['title'] : ''));
    $lv_view_arr['subtitle'] = (isset($lp_prm['subtitle']) ? $lp_prm['subtitle'] : (isset($lo_post['subtitle']) ? $lo_post['subtitle'] : ''));
    
    
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
        $lo_post['steevtcod'] = (($lo_post['steevtcod'] != "") ? $lo_post['steevtcod']: $this->co_reg->request->get['prm_steevtcod']);
        if ( $this->lo_mdl->save( $lo_post ) ) {
          
					// grabado de documentos
					$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
					if( (isset($lo_post['steevtdocdat'])?$lo_post['steevtdocdat']:'')!=''){
            
						$lv_arr = json_decode(htmlspecialchars_decode($lo_post['steevtdocdat']),true);
            
						foreach($lv_arr as $lv_row){
							$lv_row['steevtcod'] = $this->lo_mdl->steevtcod;
							$lv_row['docsts'] = 'A';
							if ($lo_docmdl->save($lv_row)==false){
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						}
					}
					// quito documentos no incluidos en ningun presupuesto
					if( (isset($lo_post['steevtdocdatdel'])?$lo_post['steevtdocdatdel']:'')!=''){
						$lv_arr = json_decode(htmlspecialchars_decode($lo_post['steevtdocdatdel']),true);
						foreach($lv_arr as $lv_row){
							if ($lo_docmdl->delete( array('steevtdoccod'=>$lv_row) )==false){
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						}
					}
					
          //cargo el documento
					$this->lo_mdl->load( array(	'steevtcod'=>$this->lo_mdl->steevtcod) );
          
          // obtengo toda la info de la clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          }
          
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );	
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve vista en modo creación               
      case '#01':
				$lo_post = $this->co_reg->request->post; 
				$this->lo_mdl->create();
        $lv_mdlcod = explode('_',self::OBJTYP)[0];
				$lv_prgcod = explode('_',self::OBJTYP)[1];
        
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). self::OBJTYP .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				if (isset($lo_post['stecod'])){
          $this->lo_mdl->stecod = $lo_post['stecod'];
          $lv_cnsstemdl = $this->co_reg->load->model('cnsste');
          $lv_cnsstemdl->load( array('stecod'=>($this->lo_mdl->stecod)), false );
          $this->lo_mdl->stetxt = $lv_cnsstemdl->stetxt;
        }
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualizacion
      case '#02': case '#03':	case '#001':
        $lv_key = array(); 
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( $lp_prm[self::ID] ?? $this->co_reg->request->post[self::ID] ));

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->steevtcod = '';
          $this->lo_mdl->steevtdoccod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
        // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra un documento
      case '#04':
				$lo_post = $this->co_reg->request->post;
        if ($lo_post['steevtcod'] == ""){
          $lo_post['steevtcod'] = $this->co_reg->request->get['prm_steevtcod'];
        }
        $this->lo_mdl->delete($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// FORMULARIO. devuelve el formulario estandard de control
			case '#getForm';
				$lo_post = $this->co_reg->request->post;
				$this->data['actcod'] = (isset($lo_post['actcod'])?$lo_post['actcod']:'');
				
				$this->lo_mdl->create();
				$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
        $lv_vew = '';
        
        // determino si para la obra/fecha existe un evento
        if((isset($lo_post['stecod'])?$lo_post['stecod']:'')!=''){
          $lv_prm = array('vewfldflt' =>'[~fltrow~]se.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
                                        '[~fltrow~]se.stecod'.chr(9).'='.chr(9).chr(9).$lo_post['stecod'].chr(9).chr(9));

          if((isset($lo_post['steevtdte'])?$lo_post['steevtdte']:'')!=''){
            $lv_prm['vewfldflt'] .= '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_post['steevtdte']) .chr(9).chr(9);
          }

          $lo_rs = $this->lo_mdl->getList( $lv_prm );
          if( count($lo_rs)>0 ){
            $this->lo_mdl->load( array('steevtcod'=>$lo_rs[0]['steevtcod']) ); 
          } else {
            $this->lo_mdl->evtdoc = array();
          }
        }
        
        switch(strtolower($lp_prm['frm'])){
          case 'cnssteevttme':
						// ASISTENCIA
            // obengo los empleados asignados a la obra
            $lo_cnsmatmdl = $this->co_reg->load->model('cnsbudmat');
            $lv_prm = array('vewfldflt' =>'[~fltrow~]s.stecod'.chr(9).'='.chr(9).chr(9).(isset($lo_post['stecod'])?$lo_post['stecod']:'').chr(9).chr(9).
                                          '[~fltrow~]bm.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]isnull(b.deldte,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9).
                                          '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewfldord' =>'bm.srcobjtxt',
                            'vewgrp' => 'bm.srcobjtyp, bm.srcobjcod001, bm.srcobjcodext, bm.srcobjtxt'
                            );
            $lo_rs = $lo_cnsmatmdl->getList( $lv_prm );

            // armo nueva lista - quito duplicados
            $lo_budmatrs = array();
            foreach($lo_rs as $lv_row){
              if( !isset($lo_budmatrs[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']]) ){
                $lo_budmatrs[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']] = $lv_row;
              }
            }

            $this->lo_mdl->cnsbudmat = $lo_budmatrs;
            return $this->co_reg->document->getView( 'cnssteevttme', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
				
            break;
            
          case 'cnssteevtprg':
            // AVANCE
            // determino si para la obra/fecha (menos un día) existe un evento de avance
            $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
            if( (isset($lo_post['steevtdte'])?$lo_post['steevtdte']:'')!='' && (isset($lo_post['stecod'])?$lo_post['stecod']:'')!='' ) {
              $lv_dte = date_create_from_format( 'd/m/Y', $lo_post['steevtdte'] );
              $lv_dte = date_sub( $lv_dte, new DateInterval('P1D') );
              $lv_dte = $lv_dte->format('d/m/Y');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]se.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lv_dte) .chr(9).chr(9).
                                            '[~fltrow~]se.stecod'.chr(9).'='.chr(9).chr(9).$lo_post['stecod'].chr(9).chr(9) );
              $lo_rs = $lo_evtmdl->getList( $lv_prm );
              if( count($lo_rs)>0 ){
                $lo_evtmdl->load( array('steevtcod'=>$lo_rs[0]['steevtcod']) ); 
                $this->lo_mdl->evtdocprv = $lo_evtmdl->evtdoc;
              } else {
                $this->lo_mdl->evtdocprv = array();
              }
            } 

            // obtengo lista de tareas de todos los presupuestos (relevantes para progreso)
            $lo_cnsmatmdl = $this->co_reg->load->model('cnsbudmat');
            $lv_prm = array('vewfldflt' =>'[~fltrow~]s.stecod'.chr(9).'='.chr(9).chr(9).(isset($lo_post['stecod'])?$lo_post['stecod']:'').chr(9).chr(9).
                                          '[~fltrow~]bm.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]isnull(b.deldte,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9).
                                          '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]dbo.gettagvalue(^regprg^,tc.cnstskclsatr)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9),
                            'vewfldord' =>'bm.budcod, bm.budmatrow'
                            );
            $lo_rs = $lo_cnsmatmdl->getList( $lv_prm );

            // armo nueva lista - quito duplicados
            $lo_budmatrs = array();
            foreach($lo_rs as $lv_row){
              if( !isset($lo_budmatrs[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']]) ){
                $lo_budmatrs[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']] = $lv_row;
              }
            }

            $this->lo_mdl->cnsbudmat = $lo_budmatrs;
            return $this->co_reg->document->getView( 'cnssteevtprg', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
					
            break;       
          default:
            return '';
        }
        
        break;
    }
  }
}
?>