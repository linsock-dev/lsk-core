<?php
final class hltcatController extends tmssController {
	
	const MODEL = 'hltcat';							
	const VIEW  = 'hltcat';							
	const ID = 'hltcatcod';							
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
  /**
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

        
      // SAVE
      case '#00':        
        // Grabar datos de cabecera
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save($lo_post) ) {
          
          // Grabar datos de valores de categorías
          if($lo_post['hltcatval']){
            $lv_catval = $lo_post['hltcatval'];
            $lv_catval_arr = json_decode(html_entity_decode($lv_catval), true);
            if ( json_last_error()==0 ){ // Verificar si se pudo convertir
        			
              $lo_docval = $this->co_reg->load->model('hltcatval');
              foreach( $lv_catval_arr as $lv_row ) {
                $lv_row['hltcatcod'] = $this->lo_mdl->hltcatcod;
                $lv_row['docsts'] = (isset($lv_row['docsts'])?($lv_row['docsts']==''?'A':$lv_row['docsts']):'A'); 
                if ( isset($lv_row['deleted']) ) {
                  if ($lo_docval->delete( $lv_row )==false) {
                    return $this->co_reg->document->getJson( array('errtyp'=>$lo_docval->errtyp,'errcod'=>$lo_docval->errcod,'errtxt'=>$lo_docval->errtxt) );
                  }
                } else if ($lo_docval->save( $lv_row )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_docval->errtyp,'errcod'=>$lo_docval->errcod,'errtxt'=>$lo_docval->errtxt) );
                }
              }
            
            } else {
              $this->data['errcod'] = json_last_error();
              $this->data['errtxt'] = json_last_error_msg();
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->data['errcod'],'errtxt'=>'Se produjo un error al grabar los datos de COSTOS: '.$this->data['errtxt']) );
              break;
            }
          }
          
					$this->lo_mdl->load( array(	'hltcatcod'=>$this->lo_mdl->hltcatcod	) );				
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
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No se indico parametro ['.self::ID.']') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
	
				} else if ( $lp_act == '#001' ) {
          
          // obtengo la lista de valores de categoría
          $lo_post = $this->co_reg->request->post;
       	 	$lo_docval = $this->co_reg->load->model('hltcatval');
          $lv_prm = array(self::ID=>$this->co_reg->request->post[self::ID]);
          $lo_data = $lo_docval->getList(array(), $lv_prm);
          // recorro la lista de valores de categoría y vacio todos sus ID's
          foreach($lo_data as &$lv_row){
                $lv_row['hltcatvalcod'] = '';
                $lv_row['hltcatcod'] = '';
                $lv_row['ctedte'] = '';
                $lv_row['cteusr'] = '';
                $lv_row['upddte'] = '';
                $lv_row['updusr'] = '';
          }
          unset($lv_row);
          
					$this->lo_mdl->hltcatcod = '';																										
					$this->lo_mdl->hltcatval = $lo_data;
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
        $this->lo_mdl->delete($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
        
      // GETLIST by TEXT. busca categorías por texto
      case '#18':
				$lo_post = $this->co_reg->request->post;
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['hltcattxt'])?'[~fltrow~]hltcattxt'.chr(9).''.chr(9).$lp_prm['hltcattxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
        $lo_data = $this->lo_mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
				break;
      
        
 			// GET VAL LIST. busca valores por categoría y texto
			case '#28':
				$lo_post = $this->co_reg->request->post;
        $lo_docval = $this->co_reg->load->model('hltcatval');
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['hltcatval'])?'[~fltrow~]hltcatval'.chr(9).''.chr(9).$lp_prm['hltcatval'].chr(9).chr(9).chr(9):'').
                        							(isset($lp_prm['hltcatcod'])?'[~fltrow~]hltcatcod'.chr(9).'='.chr(9).chr(9).$lp_prm['hltcatcod'].chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
        $lo_data = $lo_docval->getList($lv_prm);
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
				break;
    }
  }
}
?>