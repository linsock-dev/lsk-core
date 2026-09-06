<?php
final class hhrlicController extends tmssController {
	const CONTROLLER = 'hhrlic';
	const MODEL = 'hhrlic';
	const VIEW  = 'hhrlic';
	const ID = 'hhrliccod';
	const OBJTYP='HHR_LIC';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  // INDEX
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
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->hhrliccod	) );			
					
					// cargo la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;

					// determino fecha minima y maxima de carga para según los bloqueos de liquidación
					$lo_lckmdl = $this->co_reg->load->model('hhrlqdlck');
					$lo_rs = $lo_lckmdl->getUnlockPeriod(self::OBJTYP);
					$this->lo_mdl->minstrdte = $lo_rs['hhrlqdlckstrdte'];
					$this->lo_mdl->maxenddte = $lo_rs['hhrlqdlckenddte'];
					
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

			
      // NEW                
			case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				
				// obtengo clase de documento ----------------------------
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = ($lo_post['sysdocclscod']??'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );	// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER
                                                                         .'&act=01&prm_srcobjcod='.(isset($lp_prm['srcobjcod'])?$lp_prm['srcobjcod']:''),
                                                                         'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				// ------------------------------------------------
				
				// determino fecha minima y maxima de carga para según los bloqueos de liquidación
				$lo_lckmdl = $this->co_reg->load->model('hhrlqdlck');
				if(!$lo_lckmdl->getUnlockPeriod(self::OBJTYP)){ return $this->co_reg->document->getJson( array('errtyp'=>$lo_lckmdl->errtyp,'errcod'=>lo_lckmdl->errcod,'errtxt'=>$lo_lckmdl->errtxt) ); }
				$this->lo_mdl->minstrdte = $lo_lckmdl->hhrlqdlckstrdte;
				$this->lo_mdl->maxenddte = $lo_lckmdl->hhrlqdlckenddte;
        
        $lo_empmdl = $this->co_reg->load->model('hhremp');
       
        
				if($lo_empmdl->load(array('hhrempcod'=>isset($lp_prm['srcobjcod'])?$lp_prm['srcobjcod']:''),false)){
					$this->lo_mdl->srcobjcod = $lp_prm['srcobjcod'];
          $this->lo_mdl->srcobjtxt = $lo_empmdl->hhremptxt;
        }
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
				
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array( self::ID=> ($lp_prm[self::ID]??$this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->hhrliccod = '';																										
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				// determino fecha minima y maxima de carga para según los bloqueos de liquidación
				$lo_lckmdl = $this->co_reg->load->model('hhrlqdlck');
				if(!$lo_lckmdl->getUnlockPeriod(self::OBJTYP)){ return $this->co_reg->document->getJson( array('errtyp'=>$lo_lckmdl->errtyp,'errcod'=>lo_lckmdl->errcod,'errtxt'=>$lo_lckmdl->errtxt) ); }
				$this->lo_mdl->minstrdte = $lo_lckmdl->hhrlqdlckstrdte;
				$this->lo_mdl->maxenddte = $lo_lckmdl->hhrlqdlckenddte;
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;

				
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST by TEXT
      case '#18': 
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['hhrlictxt'])?'[~fltrow~]hhrlictxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['hhrlictxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>