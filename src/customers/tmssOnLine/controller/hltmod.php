<?php
final class hltmodController extends tmssController {
	const CONTROLLER = 'hltmod';
	const MODEL = 'hltmod';
	const VIEW  = 'hltmod';
	const ID = 'hltmodcod';
	const OBJTYP ='HLT_MOD';
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
				$lv_act = ($this->co_reg->request->post[self::ID]!=''?'02':'01');
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save() ) {
          
          //grabo los componentes
          $lo_plnmdl = $this->co_reg->load->model('hltmodpln');
          $lv_pln = $lo_post['hltmodpln'];
					if ($lv_pln!='') {
						$lv_pln = html_entity_decode($lv_pln);
						$lv_plnarr = json_decode($lv_pln,true);
            foreach($lv_plnarr as $lv_row){
              $lv_row['hltmodcod'] = $this->lo_mdl->hltmodcod;
							$lv_row['docsts'] = 'A';
              if ( isset($lv_row['deleted']) ) {
                if ($lo_plnmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_plnmdl->errtyp,'errcod'=>$lo_plnmdl->errcod,'errtxt'=>$lo_plnmdl->errtxt));
                }
              } else if ($lo_plnmdl->save($lv_row)==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$lo_plnmdl->errtyp,'errcod'=>$lo_plnmdl->errcod,'errtxt'=>$lo_plnmdl->errtxt));
              }
            }
          }
          
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->hltmodcod) );
					
					// UserExit AfterSave ----------------------------------------------------
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
					$lv_uexit = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_aftersave');
					if ( $lv_uexit!='' ) {
						$lv_uexit = str_ireplace('[','<',$lv_uexit);
						$lv_uexit = str_ireplace(']','>',$lv_uexit);
						$lv_controller = $this->co_reg->document->getTagValue($lv_uexit , 'controller');
						$lv_action = $this->co_reg->document->getTagValue($lv_uexit , 'action');
						if ( $lv_controller!='' && $lv_action!='' ) {
							$lv_prm = array('document_parameters'=>$lv_uexit,
															'action'=>($lv_act=='01'?'NEW':'UPDATE'), 
															'patcod'=>$this->lo_mdl->patcod);
							$lo_ctr = $this->co_reg->load->controller( $lv_controller );
							$lo_ctr->index( $lv_action , $lv_prm );
						}
					}
					// -----------------------------------------------------------------------
          
					$this->lo_mdl->doccls = $lo_docclsmdl;
			    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
      
      // NEW. devuelve vista en modo creación
      case '#01':
				$this->lo_mdl->create();
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
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->doccls = $lo_docclsmdl;
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
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				// cargo la clase de documento
				} else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
					$this->lo_mdl->doccls = $lo_docclsmdl;
				}
				
				// copiar
				if ( $lp_act == '#001' ) {
					$this->lo_mdl->hltmodcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
          
          $lv_hltmodplntmp = $this->lo_mdl->hltmodpln;
          foreach($lv_hltmodplntmp as $lv_key => $lv_row){
            $lv_hltmodplntmp[$lv_key]['hltmodplncod'] = '';
            $lv_hltmodplntmp[$lv_key]['hltmodcod'] = '';
            $lv_hltmodplntmp[$lv_key]['ctedte'] = '';
            $lv_hltmodplntmp[$lv_key]['cteusr'] = '';
            $lv_hltmodplntmp[$lv_key]['upddte'] = '';
            $lv_hltmodplntmp[$lv_key]['updusr'] = '';
          }
          $this->lo_mdl->hltmodpln = $lv_hltmodplntmp;
				}
        
		    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
      
			// DELETE. borra un documento
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
      
			// GETLIST by TEXT. devuelve lista de documentos segun texto
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['hltmodtxt'])?'[~fltrow~]m.hltmodtxt'.chr(9).''.chr(9).$lp_prm['hltmodtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$this->data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$this->data) );
        break;				
    }
  }
}
?>