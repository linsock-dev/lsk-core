<?php
final class edumodController extends tmssController {
	const CONTROLLER = 'edumod';			
	const MODEL = 'edumod';						
	const VIEW  = 'edumod';						
	const ID = 'edumodcod';						
	const OBJTYP ='EDU_MOD';
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
				$lv_objtyp = 'EDU_MOD';
				$lv_act = ($lo_post[self::ID]!=''?'02':'01');
				
				$lo_post['edumodatr'] = '<sumtyp>'.$lo_post['edumodatrsumtyp'].'</sumtyp>';
        if ( $this->lo_mdl->save( $lo_post ) ) {
					
					$lo_post['edumodcod'] = $this->lo_mdl->edumodcod;
					$lo_plndoc = $this->co_reg->load->model('edumodpln');
					$lv_buffer = $lo_post['edumodpln'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_plndoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_plndoc_arr as $lv_row ) {
							$lv_row['edumodcod'] = $this->lo_mdl->edumodcod;
							$lv_row['edumodplnatr'] = '<ctrtyp>'.substr($lv_row['edumodplnatrtyp'],0,1).'</ctrtyp>';
							$lv_row['docsts'] = 'A';							
							if ( isset($lv_row['deleted']) ) {
								if ($lo_plndoc->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_plndoc->errtyp,'errcod'=>$lo_plndoc->errcod,'errtxt'=>$lo_plndoc->errtxt, 'row'=>$i) );
								}
							} else if ($lo_plndoc->save( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_plndoc->errtyp,'errcod'=>$lo_plndoc->errcod,'errtxt'=>$lo_plndoc->errtxt, 'row'=>$i) );
							}
							$i++;
						}
					}
          
          // cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$lo_post['sysdocclscod']));
          $this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->edumodcod	) );

					// obtengo toda la info de la clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
          
        	return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				// -----------------------------------------------
				// obtengo clase de documento 										
				// ------------------------------------------------
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
					$this->lo_mdl->sysdocclstxt = $lo_docclsmdl->sysdocclstxt;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			

			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																	
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
					// cargo la clase de documento
        } else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				// copiar
				if ( $lp_act == '#001' ) {
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->edumodpln;
          foreach($lv_dat as &$lv_row){
          	$lv_row['edumodplncod'] = '';
          	$lv_row['edumodcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lv_row);
					$this->lo_mdl->edumodpln = $lv_dat;
          $this->lo_mdl->edumodcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
     		$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
				
			
			// GETLIST by TEXT
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['edumodtxt'])?'[~fltrow~]m.edumodtxt'.chr(9).''.chr(9).$lp_prm['edumodtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
        break;	
    }
  }
}
?>