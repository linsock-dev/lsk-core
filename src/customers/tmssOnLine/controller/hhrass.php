<?php
final class hhrassController extends tmssController {
	const CONTROLLER = 'hhrass';
	const MODEL = 'hhrass';
	const VIEW  = 'hhrass';
	const ID = 'hhrasscod';
	const OBJTYP='HHR_ASS';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  
  // INDEX. método principal de la clase
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

			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba un documento
			case '#00':
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->hhrasscod	) );
					
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
			
				
      // NEW. Devuelve vista en modo creación   
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
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
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
				$lo_rs = $lo_lckmdl->getUnlockPeriod(self::OBJTYP);
				$this->lo_mdl->minstrdte = $lo_rs['hhrlqdlckstrdte'];
				$this->lo_mdl->maxenddte = $lo_rs['hhrlqdlckenddte'];
				
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
				
				
      // CHANGE - DISPLAY - COPY. Devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':									
				$lv_key = array( self::ID=> ($lp_prm[self::ID]??$this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->hhrasscod = '';
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
				
				//load only asigned charges
				$lo_chrtypasgmdl = $this->co_reg->load->model('hhrass');
				$lo_rsasg = $lo_chrtypasgmdl->getChargesList(null, $lv_key);
				$this->lo_mdl->chrtypasg = $lo_rsasg;				
				
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
												'vewfldflt' => (isset($lp_prm['hhrasstxt'])?'[~fltrow~]hhrasstxt'.chr(9).''.chr(9).$lp_prm['hhrasstxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'data'=>$lo_data) );
				break;
		}
  }
}
?>