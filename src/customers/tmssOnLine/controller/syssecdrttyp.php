<?php
final class syssecdrttypController extends tmssController{
	const MODEL = 'syssecdrttyp';
	const VIEW  = 'syssecdrttyp';
	const ID = 'syssecdrttypcod';
  protected $co_reg;
	private $lo_mdl; 
  private $data = array();
	private $data_list = array();
  
  function __construct(&$lp_reg) {$this->co_reg = $lp_reg;}
  
	
  //INDEX. metodo principal
  public function index( $lp_act , $lp_prm=array() ) {
    
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      
      case '#':case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
      
      case '#00':
        //datos post
        $lo_post = $this->co_reg->request->post;
        
        $lv_buffer = $lo_post['syssecdrttypreq'];
        $lv_buffer = html_entity_decode($lv_buffer);
				$lv_req_arr = json_decode($lv_buffer, true);
        $lv_strreq = '';
        
        foreach( $lv_req_arr as $lv_row ) {
          if(isset($lv_row['syssecdrttypcod']) && !empty($lv_row['syssecdrttypcod'])){
        		$lv_strreq.= ($lv_strreq != '' ? chr(10) : '').'<reqcod>'.$lv_row['syssecdrttypcod'].'</reqcod><reqval>'.$lv_row['syssecdrttypval'].'</reqval>';
          }
        }
        $lo_post['syssecdrttypreq'] = $lv_strreq;
        
    		if ( $this->lo_mdl->save($lo_post) ) {
         
          $this->lo_mdl->load( array(	'syssecdrttypcod'=>$this->lo_mdl->syssecdrttypcod	) );
          
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
      
      case '#01':
        $this->lo_mdl->create();
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
      
      case '#02':case '#03':case '#001':
        $lo_post = $this->co_reg->request->post;
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $this->lo_mdl->syssecdrttypcodext = '';
					$this->lo_mdl->syssecdrttypcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
      
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
      case '#17':case '#18':
        $lv_prm = array('vewmaxrec' =>'10',
                        'vewfldflt' => (isset( $lp_prm['syssecdrttyptxt'] ) ?'[~fltrow~]dt.syssecdrttyptxt'.chr(9).''.chr(9).$lp_prm['syssecdrttyptxt'].chr(9).chr(9).chr(9):'').
                        							 '[~fltrow~]dt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
        break;
    }
  }
}
?>