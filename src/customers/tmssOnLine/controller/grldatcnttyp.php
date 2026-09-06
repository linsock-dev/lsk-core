<?php
final class grldatcnttypController extends tmssController {
	const MODEL = 'grldatcnttyp';
	const VIEW  = 'grldatcnttyp';
	const ID = 'cnttypcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  
  //INDEX. método principal     
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
				$lo_post = $this->co_reg->request->post;
				
				// actualizo atributos
				$lo_post['cnttypatr'] = '';
				$lv_buffer = html_entity_decode($lo_post['cnttypatr_dat']);
				$lo_cnttypatr_arr = json_decode($lv_buffer,true);
        if($lo_cnttypatr_arr != NULL){
          foreach($lo_cnttypatr_arr as $lv_row){
						$lo_post['cnttypatr'] .= '<'.$lv_row['cnttypatr'].'>'.$lv_row['cnttypatrval'].'</'.$lv_row['cnttypatr'].'>';
					}
        }
				
        if ( $this->lo_mdl->save($lo_post) ) {
					$this->lo_mdl->load( array(	'cnttypcod'=>$this->lo_mdl->cnttypcod	) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=> $this->lo_mdl,'actcod'=> $this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve vista en modo creación 
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=> $this->lo_mdl,'actcod'=> $this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. Devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );


				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->cnttypcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=> $this->lo_mdl,'actcod'=> $this->data['actcod']) );
        break;
			
			
			// DELETE. Borra un documento
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['cnttyptxt'])?'[~fltrow~]ct.cnttyptxt'.chr(9).''.chr(9).$lp_prm['cnttyptxt'].chr(9).chr(9).chr(9):'').
                        							'[~fltrow~]ct.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['cntsrctyp'].chr(9).chr(9).
																			'[~fltrow~]ct.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'data'=>$lo_data)   );
        break;
    }
  }
}
?>