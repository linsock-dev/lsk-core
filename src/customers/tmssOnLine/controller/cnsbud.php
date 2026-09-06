<?php
final class cnsbudController extends tmssController {
	const CONTROLLER = 'cnsbud';
	const MODEL = 'cnsbud';
	const VIEW  = 'cnsbud';
	const ID = 'budcod';
	const OBJTYP = 'CNS_BUD';
  protected $co_reg;
	private $lo_mdl;
	private $lo_mdlmat;
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
		$this->lo_mdlmat = $this->co_reg->load->model( 'cnsbudmat' );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = (isset($lp_prm['vewcod']) && strpos($lp_prm['vewcod'], 'CNS_BUD_MAT') ? 'cnsbudmat' :  self::MODEL);
        $lp_prm['controller'] = self::CONTROLLER;
        if(isset($lp_prm['vewcod']) && strpos($lp_prm['vewcod'], 'CNS_BUD_MAT')){
        	$lp_prm['vewfldgrp'] = 'bm.srcobjtxt, bm.matqty, bm.matuntcod, bm.srcobjtyp, bm.srcobjcod001';
        	$lp_prm['vewfldord'] = 'bm.srcobjtxt';
        }
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				// grabo los datos de cabecera
        if ( $this->lo_mdl->save( $lo_post ) ) {
					
					// verifico si hay datos en la grilla
          if($lo_post['budtskdat']){
            // grabo los datos de la grilla de costos
            $lv_budcstdat = $lo_post['budtskdat'];
            $lv_budcstdatarr = json_decode(html_entity_decode($lv_budcstdat), true);
            // verifico si se pudo convertir
            if ( json_last_error()==0 ) { 
              $i=0;
              foreach( $lv_budcstdatarr as $lv_row ) {
                $lv_row['budcod'] = $this->lo_mdl->budcod;
                $lv_row['docsts'] = 'A';
                if ( isset($lv_row['deleted']) ) {
                  if ($this->lo_mdlmat->delete( $lv_row )==false) {
                    return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdlmat->errtyp,'errcod'=>$this->lo_mdlmat->errcod,'errtxt'=>$this->lo_mdlmat->errtxt,'row'=>$i) );
                  }
                } else if ($this->lo_mdlmat->save( $lv_row )==false) {
                  	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdlmat->errtyp,'errcod'=>$this->lo_mdlmat->errcod,'errtxt'=>$this->lo_mdlmat->errtxt,'row'=>$i) );
                }
                $i++;
              }
            } else {
              $this->data['errcod'] = json_last_error();
              $this->data['errtxt'] = json_last_error_msg();
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->data['errcod'],'errtxt'=>'Se produjo un error al grabar los datos de COSTOS: '.$this->data['errtxt']) );
              break;
            }
          }
					// cargo nuevamente el documento
					$this->lo_mdl->load( array('budcod'=>$this->lo_mdl->budcod) );
					
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}					
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'cstdat'=>$this->lo_mdlmat->getData()) );
					
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
        break;
			
			
      // NEW. devuelve vista en modo creación            
      case '#01':
				$this->lo_mdl->create();
				$lv_mdlcod = explode('_',self::OBJTYP)[0];
				$lv_prgcod = explode('_',self::OBJTYP)[1];
				
				// obtengo clase de documento//
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
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'cstdat'=>$this->lo_mdlmat->getData()) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación o visualización
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				$lo_post = $this->co_reg->request->post;

				// get param (KEY)																																		
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );				
				} else if ( $lp_act == '#001' ) {
          $lv_dat=$this->lo_mdl->budtsk;
          foreach($lv_dat as &$lv_row){
          	$lv_row['budmatcod'] = '';
            $lv_row['budcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lv_row);
          $this->lo_mdl->budtsk = $lv_dat;
					$this->lo_mdl->budcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
				
				// obtengo toda la info de la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'cstdat'=>$this->lo_mdlmat->getData()) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
      // GETLIST by TEXT. busca posiciones del presupuesto por texto
      case '#28':
        $lo_post = $this->co_reg->request->post;
        $lv_prm = array('vewmaxrec' =>'10', 
                        'vewfldflt' =>(isset($lp_prm['srcobjtxt']) ? '[~fltrow~]bm.srcobjtxt'.chr(9).''.chr(9).$lp_prm['srcobjtxt'].chr(9).chr(9).chr(9):'').
                        							(isset($lp_prm['srcobjtyp']) ? '[~fltrow~]bm.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['srcobjtyp'].chr(9).chr(9):'').
                        							(isset($lp_prm['cnstskclscodext']) ? '[~fltrow~]tc.cnstskclscodext'.chr(9).'='.chr(9).chr(9).$lp_prm['cnstskclscodext'].chr(9).chr(9):'').
                        							(isset($lp_prm['stecod']) ? '[~fltrow~]b.stecod'.chr(9).'='.chr(9).chr(9).$lp_prm['stecod'].chr(9).chr(9):'').
                        							'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                      '[~fltrow~]bm.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                      '[~fltrow~]b.deldte'.chr(9).'EE'.chr(9).chr(9).chr(9).chr(9),
                        'vewfldgrp' =>' bm.srcobjtxt, bm.srcobjcod001',
                       	'vewfldord' =>' bm.srcobjtxt');
        $lo_data = $this->lo_mdlmat->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
        break; 
			
			// TAREAS - devuelve la lista de tareas del presupuesto
			case '#showTasks';
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->setData( $lo_post );				
				$this->data['actcod'] = (isset($lo_post['actcod'])?$lo_post['actcod']:'');
				return $this->co_reg->document->getView( 'cnsbudtsk', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'cstdat'=>$this->lo_mdlmat->getData()) );
				break;
    }
  }
}
?>