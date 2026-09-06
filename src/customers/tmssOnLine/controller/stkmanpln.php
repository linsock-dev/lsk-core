<?php
final class stkmanplnController extends tmssController {
	const CONTROLLER = 'stkmanpln';
  const MODEL = 'stkmanpln';
	const VIEW  = 'stkmanpln';
	const ID = 'stkmanplncod';
	const OBJTYP ='STK_MPL';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // Index - Método principal     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$lv_mdlcod = explode('_',self::OBJTYP)[0];
		$lv_prgcod = explode('_',self::OBJTYP)[0];
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
          // grabo materiales del documento
					/*
					$lo_matdoc = $this->co_reg->load->model('stkmanplnmat');
					$lv_buffer = $lo_post['stkmanplnmat'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_stkdoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_stkdoc_arr as $lv_row ) {
              $lv_row['stkmanplncod']= $this->lo_mdl->stkmanplncod;
              $lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_matdoc->delete( $lv_row )==false ) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt, 'row'=>$i) );
								}
							} else if ($lo_matdoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt, 'row'=>$i) );
							}
							$i++;
						}
					}
          */
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->stkmanplncod	) );

          // cargo clase de documento
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
				$this->lo_mdl->create( $lo_post );

				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = ($lo_post['sysdocclscod']??'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). self::OBJTYP .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

        // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}	
        
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
					$this->lo_mdl->stkmanplncod = '';
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
			
			
			// LIST
      case '#18':
				$lo_post = $this->co_reg->request->post;        
				$lv_prm = array('vewfldflt'=>
												($lp_prm['stkmanplntxt']!=''?'[~fltrow~]p.stkmanplntxt'.chr(9).'='.chr(9).chr(9).$lp_prm['stkmanplntxt'].chr(9).chr(9):'').
                        '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												);        
				$lo_rs = $lo_datmdl->getList($lv_prm, null, null, false); 
				return $this->co_reg->document->getJson($lo_rs);
				break;

    }
  }
}
?>