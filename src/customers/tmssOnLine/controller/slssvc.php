<?php
final class slssvcController extends tmssController {
	const CONTROLLER = 'slssvc';				
	const MODEL = 'slssvc';							 
	const VIEW  = 'slssvc';						
	const ID = 'slssvccod';							
	const OBJTYP ='SLS_SVC';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
      
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
    
  // main method
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['objtyp'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9); }

        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':
				$lv_objtyp = $lp_prm['mdlcod'] . '_' . $lp_prm['prgcod'];
				$lo_post = $this->co_reg->request->post;
				$lv_act = ($lo_post['slssvccod']!=''?'02':'01');			
				
				// grabo documento
        if ( $this->lo_mdl->save($lo_post) ) {
          // cargo documento
					$this->lo_mdl->load( array(	'slssvccod'=>$this->lo_mdl->slssvccod	) );			
					$lo_post['slssvccod'] = $this->lo_mdl->slssvccod;					
					$lo_docref = array();
					
					// grabo materiales del documento
					$lo_matdoc = $this->co_reg->load->model('slssvcmat');
					$lv_buffer = $lo_post['slssvcmat'];
					if ($lv_buffer!='') {            
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_slsdoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_slsdoc_arr as $lv_row ) {              
							$lv_row['slssvccod'] = $this->lo_mdl->slssvccod;
							$lv_row['curcod'] = $lo_post['curcod'];
							$lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_matdoc->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt) );
								}
							} else if ($lo_matdoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt,'errrow'=>$i) );
							}
							if(!isset($lv_row['deleted'])){ $i++; }
						}
					} 

					$this->lo_mdl->load( array(	'slssvccod'=>$this->lo_mdl->slssvccod	) );			
					
					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					
					// asigno parámetros adicionales
					$this->lo_mdl->mdlcod = $lp_prm['mdlcod'];
					$this->lo_mdl->prgcod = $lp_prm['prgcod'];
					
          					
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW                
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = (isset($lo_post['mdlcod'])?$lo_post['mdlcod']:(isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:''));
				$lv_prgcod = (isset($lo_post['prgcod'])?$lo_post['prgcod']:(isset($lp_prm['prgcod'])?$lp_prm['prgcod']:''));
				$lv_objtyp = $lv_mdlcod . '_' . $lv_prgcod;
				$this->lo_mdl->create( $lo_post );
				
				
		
				// obtengo clase de documento 											
		
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).($lv_mdlcod!='' && $lv_prgcod!=''?$lv_objtyp:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						$lv_prm = array('lang'  => $this->co_reg->language,
														'input' => $this->co_reg->input,
														'sec' 	=> $this->co_reg->sec,
														'url'=>'index.php?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,
														'doccls'=>$lv_docclsarr
														);
						$lv_ret = $this->co_reg->load->view( 'sysdocclslst', $lv_prm );		
						return $lv_ret;
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				
				/* cargo datos de la empresa */
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda

				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod = $lv_mdlcod;
				$this->lo_mdl->prgcod = $lv_prgcod;
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_objtyp = $lp_prm['mdlcod'] . '_' . $lp_prm['prgcod'];
				$lv_key = array();
				
				// get param (KEY)																										
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																		
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );									
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );


				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->slssvccod = '';																										
					$this->lo_mdl->docsts = 'A';																											
					$lv_dat = $this->lo_mdl->slssvcmat; 
					for($i=0; $i<count($lv_dat); $i++){
						$lv_dat[$i]['slssvcmatcod']='';	
						$lo_rs[$i]['docreftyp']=''; 
						$lo_rs[$i]['docrefcod']=''; 
						$lo_rs[$i]['docrefposcod']=''; 
					} 
					$this->lo_mdl->slssvcmat = $lv_dat;
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}				
				
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod=$lp_prm['mdlcod'];
				$this->lo_mdl->prgcod=$lp_prm['prgcod'];
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );;
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
				
    }
  }
}
?>