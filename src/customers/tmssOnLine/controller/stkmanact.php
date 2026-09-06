<?php
final class stkmanactController extends tmssController {
	const CONTROLLER = 'stkmanact';
  const MODEL = 'stkmanact';
	const VIEW  = 'stkmanact';
	const ID = 'stkmanactcod';
	const OBJTYP ='STK_MCA';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  // INDEX. método principal     
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

			// LIST. Lista
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			    
      // SAVE. Graba un objeto
      case '#00':        
        $lo_post = $this->co_reg->request->post;
        
        // grabo documento 
        if( $this->lo_mdl->save( $lo_post ) ) {
					$lo_post['stkmanactcod'] = $this->lo_mdl->stkmanactcod;
					$lv_doccod = $this->lo_mdl->stkmanactcod;
          
          // TAREAS. grabo tareas del documento
					$lo_matdocmdl = $this->co_reg->load->model('stkmanactmat');
          $lv_buffer = $lo_post['stkmanactmat'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_stkdoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_stkdoc_arr as $lv_row ) {
              $lv_row['stkmanactcod']= $this->lo_mdl->stkmanactcod;
              $lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_matdocmdl->delete( $lv_row )==false ) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdocmdl->errtyp,'errcod'=>$lo_matdocmdl->errcod,'errtxt'=>$lo_matdocmdl->errtxt, 'row'=>$i) );
								}
							} else if ($lo_matdocmdl->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdocmdl->errtyp,'errcod'=>$lo_matdocmdl->errcod,'errtxt'=>$lo_matdocmdl->errtxt, 'row'=>$i) );
							}
							$i++;
						}
					}
							// cargo documento y clase de documento
         	$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->stkmanactcod	) );
          
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          }   
           // cargo clase de documento
         	$lo_docclsmdl->load(array('sysdocclscod'=> $this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr, 'sysdocclscodinv'))); 
          
          
          // INSUMOS. grabo insumos en el documento
					$lo_movdoc = $this->co_reg->load->model('stkmovdoc');
					$lo_movdocmat = $this->co_reg->load->model('stkmovdocmat');
          $lv_buffer = array();
          $lv_buffer['stkmovdocdte'] = $lo_post['stkmanactdte'];
          $lv_buffer['stkmovdoccod'] = $lo_post['stkmovdoccod'];
          $lv_buffer['sysdocclscod'] = $lo_docclsmdl->sysdocclscod;
          $lv_buffer['dstobjtyp'] = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr, 'dstobjtyp');
          $lv_buffer['dstobjcod'] = $lo_post['dstobjcod'];
          $lv_buffer['docsts'] = 'A';
          
          if ($lo_movdoc->save($lv_buffer,false)) {
						$lo_post['stkmovdoccod'] = $lo_movdoc->stkmovdoccod;
            $lo_post['stkmanactcod'] = $this->lo_mdl->stkmanactcod;
           	$this->lo_mdl->save($lo_post);
            
            $json = html_entity_decode($lo_post['stkmaninv']);
						$lv_stkdoc_arr = json_decode($json, true);
            $i=0;
            if ($lv_stkdoc_arr != ''){
              foreach( $lv_stkdoc_arr as $lv_row ) {
                $lv_row['stkmovdoccod'] = $lo_movdoc->stkmovdoccod;
                $lv_row['stkmovdocmatcod'] = ($lv_row['stkmovdocmatcod']??'');
                $lv_row['matsercod'] = ($lv_row['matsercod']??'');
                $lv_row['matbchcod'] = ($lv_row['matusebch']??'');
                $lv_row['matqty'] = abs($lv_row['matqty'])*(-1);             
                if ( isset($lv_row['deleted']) ) {
                  if ($lo_movdocmat->delete( $lv_row )==false ) {
                    return $this->co_reg->document->getJson( array('errtyp'=>$lo_movdocmat->errtyp,'errcod'=>$lo_movdocmat->errcod,'errtxt'=>$lo_movdocmat->errtxt, 'row'=>$i) );
                  } 
                } else if ($lo_movdocmat->save( $lv_row )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_movdocmat->errtyp,'errcod'=>$lo_movdocmat->errcod,'errtxt'=>$lo_movdocmat->errtxt, 'row'=>$i) );
                } 
                $i++;
              } 
          }
            
          }else{
						return $this->co_reg->document->getJson( array('errtyp'=>$lo_movdoc->errtyp,'errcod'=>$lo_movdoc->errcod,'errtxt'=>$lo_movdoc->errtxt) );
					}
					
					// cargo documento y clase de documento
         	$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->stkmanactcod	) );
          
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          }          
					
          return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        
        break;
        
      // NEW. Nuevo               
      case '#01':
				$lo_post = $this->co_reg->request->post;
        $lo_post[self::ID] = '';
        if ( ($lo_post['tmss_actcod'] ?? '') == '01' ){
          unset($lo_post);
          $lo_post['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'] ?? '';
        }
				$this->lo_mdl->create( $lo_post );
					
        // obtengo clase de documento ------------------------
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lp_prm['mdlcod'].'&prm_prgcod='.$lp_prm['prgcod'],'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				// ------------------------------------------------
        
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $this->lo_mdl->stkmanactcod = '';
          $this->lo_mdl->stkmovdoccod = '';
					$this->lo_mdl->docsts = 'A';
					$this->lo_mdl->stkmanactmat = array();
					$this->lo_mdl->stkmovdocmat = array();
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

         // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']));
        break;		
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
      
			
    	// ACCOUNTING. contabiliza el documento
      case '#09':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->accounting( $lo_post );
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'errmat'=>$this->lo_mdl->errmat) );
        break;
    }
  }
}
?>