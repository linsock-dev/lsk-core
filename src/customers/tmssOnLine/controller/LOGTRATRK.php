<?php
final class logtratrkController extends tmssController {
	const CONTROLLER = 'logtratrk';
	const MODEL = 'logtra';
	const VIEW  = 'logtratrk';
	const ID = 'tracod';
	const OBJTYP = 'LOG_TRK';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
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
        $lp_prm['prg'] = 'logtratrk';
				$lp_prm['model'] = self::MODEL;
        $lp_prm['vewfldflt'] = '[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
        if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['objtyp'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9); }
        return $lo_vew->index( '00', $lp_prm );
        break;
			
      
			
      // CHANGE - DISPLAY - COPY
      case '#03':
				$lv_key = array();
				// get param (KEY)
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));
        $lv_key['objtyp']=self::OBJTYP;
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
 
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;
 
    }
  }
}
?>