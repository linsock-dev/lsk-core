<?php
final class spttrfController extends tmssController {
  const CONTROLLER = 'spttrf';
	const MODEL = 'spttrf';		
	const VIEW  = 'spttrf';						
	const ID = 'spttrfcod';							
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
		
      // SAVE
      case '#00': 	
        $lo_post = $this->co_reg->request->post;
        // grabo documento
        if ( $this->lo_mdl->save($lo_post) ) {
          // grabo los documentos
          $lo_trflstmdl=$this->co_reg->load->model('spttrflst');
          $lv_trflst = $lo_post['spttrflst'];
          if($lv_trflst!=''){
            $i = 0;
          	$lv_trflst = html_entity_decode($lv_trflst);
            $lv_trflst_arr = json_decode($lv_trflst, true);
            foreach($lv_trflst_arr as $lv_row){
            	$lv_row['spttrfvercod'] = $this->lo_mdl->spttrfvercod;
            	$lv_row['spttrfcod'] = $this->lo_mdl->spttrfcod;
              $lv_row['docsts'] = 'A';
              if( isset($lv_row['deleted']) ){
              	if($lo_trflstmdl->delete( $lv_row )==false){
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_trflstmdl->errtyp,'errcod'=>$lo_trflstmdl->errcod,'errtxt'=>$lo_trflstmdl->errtxt,'row'=>$i) );
                	//return $this->co_reg->document->getJson(array('errtyp'=>$lo_trflstmdl->errtyp,'errcod'=>$lo_trflstmdl->errcod,'errtxt'=>$lo_trflstmdl->errtxt));
                }
              }else if($lo_trflstmdl->save($lv_row)==false){
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_trflstmdl->errtyp,'errcod'=>$lo_trflstmdl->errcod,'errtxt'=>$lo_trflstmdl->errtxt,'row'=>$i) );
                //return $this->co_reg->document->getJson(array('errtyp'=>$lo_trflstmdl->errtyp,'errcod'=>$lo_trflstmdl->errcod,'errtxt'=>$lo_trflstmdl->errtxt));
              }
              $i++;
            }
          }
					$this->lo_mdl->load( array(	'spttrfcod'=>$this->lo_mdl->spttrfcod	) );	
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
					$this->lo_mdl->spttrfcod = '';	
					$this->lo_mdl->spttrfcodext = '';			
					$lv_dat = $this->lo_mdl->spttrflst; 
					for($i=0; $i<count($lv_dat); $i++){ $lv_dat[$i]['spttrflstcod']='';	} 
					$this->lo_mdl->spttrflst = $lv_dat;
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
	
			// LIST by TEXT
      case '#18': 
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['spttrftxt'])?'[~fltrow~]t.spttrftxt'.chr(9).''.chr(9).$lp_prm['spttrftxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList( $lv_prm );		
				return $this->co_reg->document->getJson( $lo_data );
        break;
				
			// UPDATE PRECIOS DE TARIFA SEGUN VERSION
			case '#20':
				$lo_post = $this->co_reg->request->post;

				$lo_trflstmdl = $this->co_reg->load->model('spttrflst');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]tl.spttrfvercod'.chr(9).'='.chr(9).chr(9).$lo_post['spttrfvercod'].chr(9).chr(9).
																			'[~fltrow~]tl.spttrfcod'.chr(9).'='.chr(9).chr(9).$lo_post['spttrfcod'].chr(9).chr(9));
				$lo_data = $lo_trflstmdl->getList($lv_prm);

				return $this->co_reg->document->getJson( $lo_data );
			break;
    }
  }	
}
?>