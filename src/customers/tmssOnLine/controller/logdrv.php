<?php
final class logdrvController extends tmssController {
	const CONTROLLER = 'logdrv';				
	const MODEL = 'logdrv';							
	const VIEW  = 'logdrv';							
	const ID = 'drvcod';								
	const OBJTYP ='LOG_DRV';
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

			// LIST. lista los objetos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
        
      // SAVE. graba un objeto
      case '#00':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {
          // cargo documento
					$this->lo_mdl->load( array(	'drvcod'=>$this->lo_mdl->drvcod	) );	
					$lv_doccod = $this->lo_mdl->drvcod;

          //cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load( array('sysdocclscod' => $this->lo_mdl->sysdocclscod ) );
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

        
      // NEW. nuevo
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
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		
          // obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											
            // si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			
          // obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'),'actcod'=>$this->data['actcod']) );
				break;
				
        
      // CHANGE - DISPLAY - COPY . Cambiar - Mostrar - Copiar
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
					$this->lo_mdl->drvcod = '';																										
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
        //cargo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsmdl->load( array('sysdocclscod' => $this->lo_mdl->sysdocclscod ) );
        $this->lo_mdl->sysdoccls = $lo_docclsmdl;	
				
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'actcod'=>$this->data['actcod']) );
        break;

        
			// DELETE
      case '#04':
         $this->lo_mdl->delete();
         return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
         break;

        
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['drvtxt'])?'[~fltrow~]d.drvtxt'.chr(9).''.chr(9).$lp_prm['drvtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm,null,null,false);
				return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }  
}
?>