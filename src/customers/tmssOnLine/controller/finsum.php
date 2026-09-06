<?php
final class finsumController extends tmssController {
  const CONTROLLER = 'finsum';
	const MODEL = 'finsum';
	const VIEW  = 'finsum';
	const ID = 'finsumcod';
  const OBJTYP = 'FIN_SUM';
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
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE. guarda un documento
        case '#00':			
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	'finsumcod'=>$this->lo_mdl->finsumcod	) );	
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        }
        else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
        
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
			// CHANGE - DISPLAY - COPY
    	case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) { 
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->finsumcod = '';																										
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
       
			
      // GETLIST by TEXT. Lista por texto -finsumdoc
      case '#18':
        $lo_post = $this->co_reg->request->post;
        $lo_finsumdoc = $this->co_reg->load->model('finsumdoc');

				$lv_vew = array('vewfldflt' => (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'').
																			'[~fltrow~]fd.finsumcod'.chr(9).'='.chr(9).chr(9).$lo_post['finsumcod'].chr(9).chr(9),				
												'vewmaxrec' => (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'100') );
        $lo_data = $lo_finsumdoc->getList($lv_vew);
        return $this->co_reg->document->getJson( array('data'=>$lo_data) );		
        break;
                 
      // GETLIST by TEXT. Lista por texto -finsum
      case '#19':
        $lo_post = $this->co_reg->request->post;
        $lo_finsum = $this->co_reg->load->model(self::MODEL);
				$lv_vew = array('vewfldflt' => '[~fltrow~]f.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
                        							 '[~fltrow~]f.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9),			
												'vewmaxrec' => (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'100') );
        $lo_data = $lo_finsum->getList($lv_vew);
        return $this->co_reg->document->getJson( array('data'=>$lo_data) );		
        break;
    }
  }
}
?>