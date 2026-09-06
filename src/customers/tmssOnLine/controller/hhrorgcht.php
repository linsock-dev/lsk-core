<?php
final class hhrorgchtController extends tmssController {
	const CONTROLLER = 'hhrorgcht';	
	const MODEL = 'hhrorgcht';	
	const VIEW  = 'hhrorgcht';	
	const ID = 'hhrorgchtcod';
	const OBJTYP ='HHR_ORG';
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

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
    $lo_orgwrkmdl = $this->co_reg->load->model( 'hhrorgchtwrk' );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. Lista
      case '#': case '#08':
        $lo_post = $this->co_reg->request->post;
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        $lp_prm['altbuscod'] = ($lo_post['altbuscod']??$lp_prm['altbuscod']??'');
        return $lo_vew->index( '00', $lp_prm );
        break;
				
			
      // SAVE. Graba un objeto
      case '#00':        
        if ( $this->lo_mdl->save() ) { 
        	$lo_post = $this->co_reg->request->post;  
          
          if(isset($lo_post['hhrorgchtwrk']) && $lo_post['hhrorgchtwrk']){
            $lo_wrkmdl = $this->co_reg->load->model('hhrorgchtwrk');
            if(!$lo_wrkmdl->massiveSave(array('hhrorgchtwrk' => $lo_post['hhrorgchtwrk']))){
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_wrkmdl->errtyp,'errcod'=>$lo_wrkmdl->errcod,'errtxt'=>$lo_wrkmdl->errtxt) );
            }
          }
          
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->hhrorgchtcod	) );
          
          // cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
          
          return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
       
			
      // NEW. Nuevo               
      case '#01':
				$this->lo_mdl->create();
        
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
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
					$this->lo_mdl->hhrorgchtcod = '';
					$this->lo_mdl->hhrorgchtcodext = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
        // cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;		
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
        
			// LIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['hhrorgchttxt'])?'[~fltrow~]hhrorgchttxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['hhrorgchttxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]r.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );		
				$lo_data = $this->lo_mdl->getList($lv_prm,($lp_prm['altbuscod']?array('altbuscod'=>$lp_prm['altbuscod']):array()));
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;
        
      // ENTEGRAMAS
        
      // SAVE. Graba un objeto
      case '#10':       
        $lo_post = $this->co_reg->request->post;
        $lo_post['docsts'] = 'A';
        if ( $lo_orgwrkmdl->save($lo_post) ) {  
         
					$lo_orgwrkmdl->load( array(	'hhrorgchtwrkcod'=>$lo_orgwrkmdl->hhrorgchtwrkcod	) );
          
          return $this->co_reg->document->getJson( $lo_orgwrkmdl->getData() );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_orgwrkmdl->errtyp,'errcod'=>$lo_orgwrkmdl->errcod,'errtxt'=>$lo_orgwrkmdl->errtxt) );
        }
        break; 
        
    
        // NEW. Nuevo               
      case '#11':
        $lo_orgwrkmdl->create();
        $lo_orgwrkmdl->hhrorgchtcod = $this->co_reg->request->post['hhrorgchtcod'];
        return $this->co_reg->document->getView('hhrorgchtwrk', array('data'=>$lo_orgwrkmdl, 'actcod'=>$this->data['actcod']));
				break;		
        
       
      // CHANGE - DISPLAY
      case "#12": case "#13":		
				// get param (KEY)																																		
				$lv_key = array( 'hhrorgchtwrkcod'=>( isset($lp_prm['hhrorgchtwrkcod']) ? $lp_prm['hhrorgchtwrkcod'] : $this->co_reg->request->post['hhrorgchtwrkcod'] ));

				// load object. Cargar objeto
				if ( !isset($lv_key['hhrorgchtwrkcod']) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [hhrorgchtwrkcod].') );
				} else if ($lo_orgwrkmdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_orgwrkmdl->errtyp,'errcod'=>$lo_orgwrkmdl->errcod,'errtxt'=>$lo_orgwrkmdl->errtxt) );
				}
        
				return $this->co_reg->document->getView( 'hhrorgchtwrk', array('data'=>$lo_orgwrkmdl,'actcod'=>$this->data['actcod']) );
        break;
        
        
      // LIST. Filtro personalizado
      case '#wrkflt':       
        $lo_post = $this->co_reg->request->post;
        $lo_wrkempmdl = $this->co_reg->load->model('hhrorgchtwrkemp');
        $lo_capmdl = $this->co_reg->load->model('hhrorgchtwrkcap');
        
				$lv_prm = array('vewfldflt' => $lo_post['vewfldflt'].
                       '[~fltrow~]w.hhrorgchtcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->db->sqldata($lo_post['hhrorgchtcod']).chr(9).chr(9)
                       );
				$lo_rs_orgwrk = $lo_orgwrkmdl->getListWithAncestors($lv_prm);
        
        $lv_wrkcod = '';
        foreach($lo_rs_orgwrk as $lv_row){
          $lv_wrkcod .= ($lv_wrkcod?chr(10):'').$lv_row['hhrorgchtwrkcod'];
        }
      
        // busco horarios de los puestos de trabajo de cada entegramas
        $lv_prm = array('vewfldflt' =>'[~fltrow~]we.hhrorgchtwrkcod'.chr(9).'IN'.chr(9).chr(9).$lv_wrkcod.chr(9).chr(9).
                                      '[~fltrow~]t.hhremptmestr'.chr(9).'<='.chr(9).chr(9).date('Y-m-d').chr(9).chr(9).
                                      '[~fltrow~]t.hhremptmeend'.chr(9).'>='.chr(9).chr(9).date('Y-m-d').chr(9).chr(9).
                                      ($lo_post['wrkplctxt']?'[~fltrow~]p.wrkplctxt'.chr(9).''.chr(9).$lo_post['wrkplctxt'].chr(9).chr(9).chr(9):'').
                                      '[~fltrow~]we.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs_asg = $lo_wrkempmdl->getList( $lv_prm );
      
        // busco capacidad de cada entegrama
        $lv_prm = array('vewfldflt' =>'[~fltrow~]c.hhrorgchtwrkcod'.chr(9).'IN'.chr(9).chr(9).$lv_wrkcod.chr(9).chr(9).
                                      ($lo_post['wrkplctxt']?'[~fltrow~]p.wrkplctxt'.chr(9).''.chr(9).$lo_post['wrkplctxt'].chr(9).chr(9).chr(9):''),
                       'vewfldord' => 'c.hhrorgchtwrkcod');
        $lo_rs_cap = $lo_capmdl->getList( $lv_prm );

        // emparejo horarios y capacidades
        foreach($lo_rs_orgwrk as &$lv_wrkrow){
          $lv_wrkrow['asg'] = array();
          $lv_wrkrow['cap'] = array();

          foreach($lo_rs_asg as &$lv_asg){
            if($lv_asg['hhrorgchtwrkcod'] == $lv_wrkrow['hhrorgchtwrkcod']){
              $lv_wrkrow['asg'][] = $lv_asg;
            }
          }
          unset($lv_asg);

          foreach($lo_rs_cap as &$lv_cap){
            if($lv_cap['hhrorgchtwrkcod'] == $lv_wrkrow['hhrorgchtwrkcod']){
              $lv_wrkrow['cap'][] = $lv_cap;
            }
          }
          unset($lv_cap);
        }
        unset($lv_wrkrow);
        
        return $this->co_reg->document->getJson( $lo_rs_orgwrk );
        break;  
        
      // Actualizar dependencias entre entegramas
      case "#15":		
        $lo_wrkmdl = $this->co_reg->load->model('hhrorgchtwrk');
        $lo_wrkmdl->massiveSave(array('hhrorgchtwrk' => $this->co_reg->request->post['hhrorgchtwrk']));
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_wrkmdl->errtyp,'errcod'=>$lo_wrkmdl->errcod,'errtxt'=>$lo_wrkmdl->errtxt) );
        break;
    }
  }
}
?>