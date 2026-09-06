<?php
final class gasslnController extends tmssController { 
	const MODEL = 'gassln';
	const VIEW  = 'gassln';
	const ID = 'slncod';
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':        
				$lo_post = $this->co_reg->request->post;

        if ( $this->lo_mdl->save() ) {

					// TODO: save tables
					$lo_gasslntbl = $this->co_reg->load->model('gasslntbl');
					$lv_buffer = isset($lo_post['slntbls'])?$lo_post['slntbls']:'';;
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_slntbl_arr = json_decode($lv_buffer,true);
						foreach( $lv_slntbl_arr as $lv_row ) {
							$lv_row['slncod'] = $this->lo_mdl->slncod;
              $lv_row['slntblcod'] = $lv_row['slntblcod'];
              $lv_row['slntblcodext'] = $lv_row['slntblcodext'];
              $lv_row['slntblqty'] = $lv_row['slntblqty'];
							$lv_row['docsts'] = 'A';							
							if ( isset($lv_row['deleted']) && $lv_row['deleted']=="x" && $lv_row['slntblcod']!='' ) {
								if ($lo_gasslntbl->delete( $lv_row )==false) {
									return '<errcod>'.$lo_gasslntbl->errcod.'</errcod><errtxt>'.$lo_gasslntbl->errtxt.'</errtxt><row>'.$i.'</row>';
								}
							} else if(  isset($lv_row['deleted']) && $lv_row['deleted']=="" ){
								if ($lo_gasslntbl->save( $lv_row )==false) {
									return '<errcod>'.$lo_hldmov->errcod.'</errcod><errtxt>'.$lo_hldmov->errtxt.'</errtxt><row>'.$i.'</row>';
								}
							}
							$i++;
						}
					}

					// Load createad/modified object and show it
					$this->lo_mdl->load( array(	'slncod'=>$this->lo_mdl->slncod	) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
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
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$lv_dat = $this->lo_mdl->slntbls; 
   				foreach($lv_dat as &$lv_row){
          $lv_row['slncod'] = '';
          $lv_row['ctedte'] = '';
          $lv_row['cteusr'] = '';
          $lv_row['upddte'] = '';
          $lv_row['updusr'] = '';
          $lv_row['slntblcod'] = '';
          $lv_row['slntbls'] = '';
          	}               
          unset($lv_row);
					$this->lo_mdl->slncod = '';	
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
          $this->lo_mdl->slntblcod = '';
          $this->lo_mdl->slntblcodext = '';
          $this->lo_mdl->slntblqty = ''; 
          $this->lo_mdl->slntbls = $lv_dat;
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			

    }

  }
}
?>