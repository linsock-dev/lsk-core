<?php
final class grlprcschController extends tmssController {
	const MODEL = 'grlprcsch';
	const VIEW  = 'grlprcsch';
	const ID = 'prcschcod';
	const OBJTYP ='SYS_PSC';
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
					$lv_buffer = $this->co_reg->request->post['prcschcnd'];
					if ($lv_buffer!='') {
						$i=0;
						$lo_schcndmdl = $this->co_reg->load->model('grlprcschcnd');
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_schcnd_arr = json_decode($lv_buffer,true);
						foreach( $lv_schcnd_arr as $lv_row ) {
							if ( isset($lv_row['deleted']) ) {
								if ($lo_schcndmdl->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_schcndmdl->errtyp, 'errcod'=>$lo_schcndmdl->errcod, 'errtxt'=>$lo_schcndmdl->errtxt, 'row'=>$i) );
								}
							} else {
								$lv_row['prccndcod'] = (isset($lv_row['prccndcod'])? ($lv_row['prccndcod']==''?'0':$lv_row['prccndcod']) : '0' );
								if($lv_row['prccndcod']=='0'){ $lv_row['prccndttl']=$lv_row['prccndtxt']; $lv_row['prccndtxt']=''; }
								$lv_row['prcschcod'] = $this->lo_mdl->prcschcod;
								if ($lo_schcndmdl->save( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_schcndmdl->errtyp, 'errcod'=>$lo_schcndmdl->errcod, 'errtxt'=>$lo_schcndmdl->errtxt, 'row'=>$i) );
								}
							}
							$i++;
						}
					}
					
					// cargo datos del documento
					$this->lo_mdl->load( array('prcschcod'=>$this->lo_mdl->prcschcod) );
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
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
				$lo_post = $this->co_reg->request->post;				
				$lv_key = array( self::ID=> (isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $lv_dat= $this->lo_mdl->prcschcnd;
          foreach($lv_dat as &$lv_row){
          	$lv_row['prcschcndcod'] = '';
            $lv_row['prcschcod'] = '';
          }
          unset($lv_row);
          $this->lo_mdl->prcschcnd = $lv_dat;
					$this->lo_mdl->prcschcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;			
			
			
			// GETLIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]ps.prcschtxt'.chr(9).''.chr(9).$lp_prm['prcschtxt'].chr(9).chr(9).chr(9).
																			'[~fltrow~]ps.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }
}
?>