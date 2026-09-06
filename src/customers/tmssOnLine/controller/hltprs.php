<?php
final class hltprsController extends tmssController {
  
	const CONTROLLER = 'hltprs';				
	const MODEL = 'hltprs';							
	const VIEW  = 'hltprs';							
	const ID = 'prscod';								
	const OBJTYP ='HLT_PRS';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  // main method    
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
				$lv_act = ($this->co_reg->request->post['prscod']!=''?'02':'01');
				$lv_prscod = $this->co_reg->request->post['prscod'];
        
        if( $this->lo_mdl->save() ) {
          // graba especialidades de prestador
					$lo_prsspc = $this->co_reg->load->model('hltprsspc');
					$lv_buffer = $this->co_reg->request->post['prsspc'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_prsspc_arr = json_decode($lv_buffer,true);
						foreach( $lv_prsspc_arr as $lv_row ) {
              $lv_row['prscod'] = $this->lo_mdl->prscod;
              $lv_row['docsts'] = 'A';
							$lo_prsspc->setFormData( $lv_row );
              $lv_row['prsspcatr'] = $this->co_reg->request->post['prsspcatr'];
              if ( isset($lv_row['deleted']) ) {
								if ($lo_prsspc->delete($lv_row)==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_prsspc->errtyp,'errcod'=>$lo_prsspc->errcod,'errtxt'=>$lo_prsspc->errtxt) );
								}
							} else {
								if ($lo_prsspc->save($lv_row)==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_prsspc->errtyp,'errcod'=>$lo_prsspc->errcod,'errtxt'=>$lo_prsspc->errtxt) );
								}
							}
						}
					}

          // graba categorización
          $lo_prscat = $this->co_reg->load->model('hltprscat');
					$lv_buffer = $this->co_reg->request->post['prscat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_prscat_arr = json_decode($lv_buffer,true);
						foreach( $lv_prscat_arr as $lv_row ) {
							$lv_row['prscod'] = $this->lo_mdl->prscod;
							if ( isset($lv_row['deleted']) ) {
								if ($lo_prscat->delete($lv_row)==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_prscat->errtyp,'errcod'=>$lo_prscat->errcod,'errtxt'=>$lo_prscat->errtxt) );
								}
							} else {
								if ($lo_prscat->save($lv_row)==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_prscat->errtyp,'errcod'=>$lo_prscat->errcod,'errtxt'=>$lo_prscat->errtxt) );
								}
							}
						}
					}
          
					$this->lo_mdl->load( array(	'prscod'=>$this->lo_mdl->prscod	) );			
          
          // antiguedad
          if($this->lo_mdl->prsinbdte != '' && is_object($this->lo_mdl->prsinbdte)){
            $this->lo_mdl->prsjobpts = (int) $this->lo_mdl->prsinbdte->diff(new DateTime('now'))->format('%y');
          }else if($this->lo_mdl->prsinbdte != '' && is_string($this->lo_mdl->prsinbdte)){
            $this->lo_mdl->prsjobpts = (int) (strtotime($this->lo_mdl->prsinbdte))->diff(new DateTime('now'))->format('%y');
          }else{
            $this->lo_mdl->prsjobpts = 0;
          }
					
          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

        
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				
				// obtengo clase de documento 											
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						$lv_ret = $this->co_reg->document->getview( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );		
						return $lv_ret;
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'actcod'=>$this->data['actcod']) );
				break;
				
        
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();

				// get param (KEY)																																		
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
          
          // recorro la lista de categorizaciones y vacio todos sus ID's
          $lo_prscatmdl = $this->co_reg->load->model('hltprscat');
          $lv_key = array( 'prscod' => $this->lo_mdl->prscod );
          $lo_data = $lo_prscatmdl->load($lv_key); 
          
          foreach($lo_data as &$lv_row){
            $lv_row['hltprscatcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lv_row);
          $this->lo_mdl->prscat = $lo_data;
          
          
					$this->lo_mdl->prscod = '';																										
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
        // antiguedad 
        if($this->lo_mdl->prsinbdte != '' && is_object($this->lo_mdl->prsinbdte)){
          $this->lo_mdl->prsjobpts = (int) $this->lo_mdl->prsinbdte->diff(new DateTime('now'))->format('%y');
        }else if($this->lo_mdl->prsinbdte != '' && is_string($this->lo_mdl->prsinbdte)){
          $this->lo_mdl->prsjobpts = (int) (strtotime($this->lo_mdl->prsinbdte))->diff(new DateTime('now'))->format('%y');
        }else{
          $this->lo_mdl->prsjobpts = 0;
        }
        
        // cargo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
        $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'actcod'=>$this->data['actcod']) );
        break;

        
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;

         
			// LIST by TEXT
			case '#18':
        $lv_prm = array('vewmaxrec' => '10',
          'vewfldflt' => (isset($lp_prm['prstxt']) ? '[~fltrow~]p.prstxt'.chr(9).''.chr(9).$lp_prm['prstxt'].chr(9).chr(9).chr(9) : '') .
                   (isset($lp_prm['sysdocclscod']) && $lp_prm['sysdocclscod'] != '' ? '[~fltrow~]p.sysdocclscod'.chr(9).''.chr(9).$lp_prm['sysdocclscod'].chr(9).chr(9).chr(9) : '') .
                   '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
        );
        $lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson($lo_data);
			break;
      // DISPLAY (infowindow)
      case '#23':
				if ( !isset($lp_prm[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lp_prm)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				$lv_vew = 'hltprsinf' . (isset($lp_prm['vewtyp'])?$lp_prm['vewtyp']:'typ001');
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'data' => $this->lo_mdl,
												'actcod' => $this->data['actcod'],
												'model' => self::MODEL
												);
        return $this->co_reg->document->getView( $lv_vew, $lv_prm );
        break;
				
        // MODIFICAR CLASE DE DOCUMENTO
			case '#32':
				$lo_post = $this->co_reg->request->post;
				if ( $this->lo_mdl->load( array('prscod'=>$lo_post['prscod']) )==false ) {
  	      return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if( !$this->lo_mdl->changeClass( array('prscod'=>$this->lo_mdl->prscod,'sysdocclscod'=>$lo_post['sysdocclscod']) ) ) {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else {
					return '<script>$(function(){'.
						( isset($lo_post['callback']) ? $lo_post['callback'].'();' : '' ).
						'tmssTabSecCls( $("#'.$lo_post['sysdocclssec'].'") );'.
						'});</script>';
        }
				break;
        
      // CAMBIAR CLASE DE DOCUMENTO
      case '#33':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->load(array('prscod' => $lo_post['prscod']));
        $lv_dat = array('prscod'=>$this->lo_mdl->prscod,'callback'=>$lo_post['callback']);
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]d.sysdocclscod'.chr(9).'<>'.chr(9).chr(9).$this->lo_mdl->sysdocclscod.chr(9).chr(9)
																			);
				$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
        return $this->co_reg->document->getView('sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=32','data'=>$lv_dat,'doccls'=>$lv_docclsarr) );
				break;
        
			// LIST (especialidades del prestador)
      case '#37':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['controller'] = 'hltprs';
        $lp_prm['model'] = 'hltprsspc';
				$lp_prm['actcod'] = '37';
        return $lo_vew->index( '00', $lp_prm );
        break;
				
        
			// LIST by TEXT (especialidades del prestador)
      case '#38':
				$lo_prsspc_mdl = $this->co_reg->load->model('hltprsspc');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]p.prscod'.chr(9).'='.chr(9).chr(9).$lp_prm['prscod'].chr(9).chr(9).
																			'[~fltrow~]s.spctxt'.chr(9).''.chr(9).$lp_prm['spctxt'].chr(9).chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $lo_prsspc_mdl->getList($lv_prm);
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_data) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					$this->data['errcod'] = json_last_error();
        	$this->data['errtxt'] = json_last_error_msg();
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->data['errcod'],'errtxt'=>'Error en conversión json: '.$this->data['errtxt']) );
				}
        break;
    }
  }
}
?>