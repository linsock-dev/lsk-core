<?php
final class hltpatevlController extends tmssController {
	const CONTROLLER = 'hltpatevl';
	const MODEL = 'hltpatevl';
	const VIEW  = 'hltpatevl';					
	const ID = 'evlcod';
  const OBJTYP = 'HLT_EVL';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
  // MAIN METHOD     
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
				
				// grabo evolución
				$lo_post['evlatr001'] = '<pathgh>'.$lo_post['pathgh'].'</pathgh>'.
																'<patwgt>'.$lo_post['patwgt'].'</patwgt>'.
																'<patsex>'.$lo_post['patsex'].'</patsex>'.
																'<cushspcod>'.$lo_post['cushspcod'].'</cushspcod>'.
																'<cushsptxt>'.$lo_post['cushsptxt'].'</cushsptxt>'.
																'<pataflnum>'.$lo_post['pataflnum'].'</pataflnum>'.
																'<pataflpln>'.$lo_post['pataflpln'].'</pataflpln>'.
																'<patbrndte>'.$lo_post['patbrndte'].'</patbrndte>';
        if ( $this->lo_mdl->save( $lo_post )==false ) {
          return $this->co_reg->document->getJson(array('errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt));
				}

				// cargo datos paciente
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$this->lo_mdl->patcod) );


				// obtengo y grabo datos de paciente (atributos de peso/altura)
				$lo_dat = $lo_patmdl->getData(); 
       
				$lo_dat['adrlstnme'] = $lo_dat['adrlstnme'];
				$lo_dat['adrfrtnme'] = $lo_dat['adrfrtnme'];
				//$lo_dat['pattxt'] = $lo_dat['adrnme001'];
				$lo_dat['patatrval001'] =  htmlentities(strtolower($lo_dat['patatrval001'] ?? ''));
				$lv_str = stripos($lo_dat['patatrval001'],'<pathgh>');
				if( $lv_str==false ) {
					$lo_dat['patatrval001'] .= '<pathgh>'.$lo_post['pathgh'].'</pathgh>';
				} else {
					$lv_lstval = substr($lo_dat['patatrval001'], $lv_str+8, strlen($lo_dat['patatrval001'])-stripos($lo_dat['patatrval001'],'</pathgh>') );
					$lo_dat['patatrval001'] = str_ireplace($lv_lstval,'<pathgh>'.$lo_post['pathgh'].'</pathgh>',$lo_dat['patatrval001']);
				}
				$lv_str = stripos($lo_dat['patatrval001'],'<patwgt>');
				if( $lv_str==false ) {
					$lo_dat['patatrval001'] .= '<patwgt>'.$lo_post['patwgt'].'</patwgt>';
				} else {
					$lv_lstval = substr($lo_dat['patatrval001'], $lv_str+8, strlen($lo_dat['patatrval001'])-stripos($lo_dat['patatrval001'],'</patwgt>') );
					$lo_dat['patatrval001'] = str_ireplace($lv_lstval,'<patwgt>'.$lo_post['patwgt'].'</patwgt>',$lo_dat['patatrval001']);
				}
        $lo_dat['prsrls'] = '';
				if( $lo_patmdl->save( $lo_dat )==false ) {
					// no se pudo actualizar Altura/Peso de paciente
				} 
				
				// cargo datos de paciente
        $lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$this->lo_mdl->patcod) );
    
				$this->lo_mdl->pat = $lo_patmdl;

				// cargo evolucion
				$this->lo_mdl->load( array(	'evlcod'=>$this->lo_mdl->evlcod	) );

        
        // obtengo toda la info de la clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        } 
  
				
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				
        break;
			
			
      // NEW                
      case '#01':
				$lo_post = $this->co_reg->request->post;
                
				$lo_delmdl = $this->co_reg->load->model('hltdel');
				if( (isset($lo_post['delcod'])?$lo_post['delcod']:'')!='' ){
					$lo_delmdl->load( array('delcod'=>$lo_post['delcod']),false );
				}
				
				$lo_spcmdl = $this->co_reg->load->model('hltspc');
				if( (isset($lo_post['spccod'])?$lo_post['spccod']:'')!='' ){
					$lo_spcmdl->load( array('spccod'=>$lo_post['spccod']) );
				}

				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				if( (isset($lo_post['prscod'])?$lo_post['prscod']:'')!='' ){
					$lo_prsmdl->load( array('prscod'=>$lo_post['prscod']) );
				}
				
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$lo_post['patcod']) );
				
				$this->lo_mdl->create();
				$this->lo_mdl->plnid = (isset($lo_post['plnid'])?$lo_post['plnid']:'');
				$this->lo_mdl->plndteid = (isset($lo_post['plndteid'])?$lo_post['plndteid']:'');
				$this->lo_mdl->pat = $lo_patmdl;
				$this->lo_mdl->spc = $lo_spcmdl;
				$this->lo_mdl->del = $lo_delmdl;
				$this->lo_mdl->prs = $lo_prsmdl;
        
        /* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
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
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
        
				return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																	
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );						
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson(array('errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].'));

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson(array('errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt));

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->evlcod = '';																					
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_patmdl->load( array('patcod'=>$this->lo_mdl->patcod) );
				$this->lo_mdl->pat = $lo_patmdl;
        
        // obtengo toda la info de la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE
      case '#04':
				$lo_post = $this->co_reg->request->post;
        
        $this->lo_mdl->delete( $lo_post );
				return $this->co_reg->document->getJson(array('errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt));
        break;
    }

  }
}
?>