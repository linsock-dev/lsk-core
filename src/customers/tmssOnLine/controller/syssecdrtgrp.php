<?php
final class syssecdrtgrpController extends tmssController{
	const MODEL = 'syssecdrtgrp';
	const VIEW  = 'syssecdrtgrp';
	const ID = 'syssecdrtgrpcod';
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
        
    		if ( $this->lo_mdl->save($lo_post) ) {
          //graba la tabla de directivas
          $lo_grptypmdl = $this->co_reg->load->model('syssecdrtgrptyp');
          $lv_buffer = $lo_post['syssecdrtgrptyp'];
          if ($lv_buffer!='') {
            $i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_grptyp_arr = json_decode($lv_buffer,true);
            
            foreach( $lv_grptyp_arr as $lv_row ) {
              $lv_row['syssecdrtgrpcod'] = $this->lo_mdl->syssecdrtgrpcod;
							$lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_grptypmdl->delete( $lv_row )==false) {
				          return $this->co_reg->document->getJson( array('errtyp'=>$lo_grptypmdl->errtyp,'errcod'=>$lo_grptypmdl->errcod,'errtxt'=>$lo_grptypmdl->errtxt,'row'=>$i) );
								}
							} else {
                if ($lo_grptypmdl->save( $lv_row )==false) {
			          	return $this->co_reg->document->getJson( array('errtyp'=>$lo_grptypmdl->errtyp,'errcod'=>$lo_grptypmdl->errcod,'errtxt'=>$lo_grptypmdl->errtxt,'row'=>$i) );
                }
              } 
              
              $i++;
            }
          }
          
          $this->lo_mdl->load( array(	'syssecdrtgrpcod'=>$this->lo_mdl->syssecdrtgrpcod	) );
          
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
          $this->lo_mdl->syssecdrtgrpcodext = '';
					$this->lo_mdl->syssecdrtgrpcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
          
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->syssecdrtgrptyp; 
          foreach($lv_dat as &$lv_row){
            $lv_row['syssecdrtgrptypcod'] = ''; 
            $lv_row['syssecdrtgrpcod'] = ''; 
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          $this->lo_mdl->syssecdrtgrptyp = $lv_dat;
				}

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
      
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
      case '#17':case '#18':
        $lo_post = $this->co_reg->request->post;
        
        $lv_prm = array('vewfldflt' => ( isset( $lo_post['syssecdrtgrptxt'] ) || isset( $lp_prm['syssecdrtgrptxt'] ) ?'[~fltrow~]syssecdrtgrptxt'.chr(9).'LIKE'.chr(9).chr(9).(isset( $lo_post['syssecdrtgrptxt'] )?$lo_post['syssecdrtgrptxt']:$lp_prm['syssecdrtgrptxt']).chr(9).chr(9):'').
                        							 '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs = $this->lo_mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( array('data'=>$lo_rs,'post'=>$lo_post) );
        break;
    }
  }
}
?>