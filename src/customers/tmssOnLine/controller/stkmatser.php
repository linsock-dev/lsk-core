<?php
final class stkmatserController extends tmssController {
  
	const CONTROLLER = 'stkmatser';
	const MODEL = 'stkmatser';
	const VIEW  = 'stkmatser';
	const ID = 'matsercod';
	const OBJTYP = 'STK_SER';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  /*
   * main method
   */     
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

      // SAVE. graba un documento
      case '#00':        
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->matsercod	) );
					
					// obtengo objetos
					$lo_sysobj_mdl = $this->co_reg->load->model('sysobjtyp');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
					$lo_rs = $lo_sysobj_mdl->getList($lv_prm);
					$lv_dat = array();
					foreach($lo_rs as $lv_row) {
						if ( $this->co_reg->document->getTagValue($lv_row['objtypatr'],'objstkrel')=='X' ) { $lv_dat[]=$lv_row; }
					}
					$this->lo_mdl->sysobjtyp = $lv_dat;

					// cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

      // NEW. devuelve en una vista en modo creacion
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
						$lv_prm = array('lang'  => $this->co_reg->language,
														'input' => $this->co_reg->input,
														'sec' 	=> $this->co_reg->sec,
														'url'=>'index.php?prg='.self::CONTROLLER.'&act=01',
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
				/* ------------------------------------------------ */
				
				// obtengo objetos
				$lo_sysobj_mdl = $this->co_reg->load->model('sysobjtyp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_rs = $lo_sysobj_mdl->getList($lv_prm);
				$lv_dat = array();
				foreach($lo_rs as $lv_row) {
					if ( $this->co_reg->document->getTagValue($lv_row['objtypatr'],'objstkrel')=='X' ) { $lv_dat[]=$lv_row; }
				}
				$this->lo_mdl->sysobjtyp = $lv_dat;
				
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=> isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]);

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->matsercod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// obtengo objetos
				$lo_sysobj_mdl = $this->co_reg->load->model('sysobjtyp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_rs = $lo_sysobj_mdl->getList($lv_prm);
				$lv_dat = array();
				foreach($lo_rs as $lv_row) {
					if ( $this->co_reg->document->getTagValue($lv_row['objtypatr'],'objstkrel')=='X' ) { $lv_dat[]=$lv_row; }
				}
				$this->lo_mdl->sysobjtyp = $lv_dat;
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
			
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;

			// DELETE. borra un objeto
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
    }
  }
}
?>