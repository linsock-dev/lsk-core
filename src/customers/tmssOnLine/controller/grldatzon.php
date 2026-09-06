<?php
final class grldatzonController extends tmssController {
	const MODEL = 'grldatzon';
	const VIEW  = 'grldatzon';
	const ID = 'adrzoncod';
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

			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
        
        
      // LIST. lista los documentos agrupados
      case '#28':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        $lp_prm['srcmtd'] = 'getListAgrup';
        return $lo_vew->index( '00', $lp_prm );
        break;
        

      // SAVE. graba un documento
      case '#00':
       // grabo columnas de la tabla
        $lo_post = $this->co_reg->request->post;
        $lv_buffer = $lo_post['adrzoncol'];
        if ($lv_buffer!='') {
          $lv_buffer = html_entity_decode($lv_buffer);
          $lv_sysvewcol_arr = json_decode($lv_buffer,true);
          foreach($lv_sysvewcol_arr as $lv_row){
            $lv_row['objtyp'] = $lo_post['objtyp'];
            if (isset($lv_row['deleted'])) {
              if ($this->lo_mdl->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
              }
            } else if ($this->lo_mdl->save($lv_row)==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
            } 
          }
        }
        $lv_prm = array('vewfldflt' =>'[~fltrow~]z.objtyp'.chr(9).''.chr(9). $lo_post['objtyp'] .chr(9).chr(9).chr(9));
        $this->lo_mdl->list = $this->lo_mdl->getList($lv_prm);
				$this->lo_mdl->objtyp = $lo_post['objtyp'];
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;

				
      // NEW. Devuelve vista en modo creación              
      case '#01':
				$this->lo_mdl->create();
				$this->lo_mdl->list = array();
				return $this->co_reg->document->getView(self::VIEW ,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
				
				
      // CHANGE - DISPLAY - COPY. Devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':				
				$lo_post = $this->co_reg->request->post;
				
				// get param (KEY)																																		
        $lv_key = array( 'objtyp'=>( ($lp_prm['objtyp']??'')!='' ? $lp_prm['objtyp'] : ($lo_post['objtyp']??'') ) );
				
				// load object
				if ( $lv_key['objtyp']=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else {
          $lv_prm = array('vewfldflt' =>'[~fltrow~]z.objtyp'.chr(9).''.chr(9). $lv_key['objtyp'] .chr(9).chr(9).chr(9));
					$lo_rs = $this->lo_mdl->getList($lv_prm);
					$this->lo_mdl->list = array();
					$this->lo_mdl->objtyp = $lv_key['objtyp'];
        	if ( $lo_rs==false ) {
						return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          } else if ( $lp_act == '#001' ) {
						$this->lo_mdl->objtyp = '';
						foreach($lo_rs as $key => &$lv_row){
							$lv_row[$key]['adrzoncod'] = '';
							$lv_row[$key]['objtyp'] = '';
							$lv_row[$key]['ctedte'] = '';
							$lv_row[$key]['cteusr'] = '';
							$lv_row[$key]['upddte'] = '';
							$lv_row[$key]['updusr'] = ''; 
						}
						unset($lv_row);
					}
					$this->lo_mdl->list = $lo_rs;
          return $this->co_reg->document->getView(self::VIEW ,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'])); 
        }
        break;

				
			// DELETE. Borra un documento
      case '#04':
      	$lo_post = $this->co_reg->request->post;
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]z.objtyp'.chr(9).''.chr(9). $lo_post['objtyp'] .chr(9).chr(9).chr(9));
        $lo_list = $this->lo_mdl->getList($lv_prm);
        
        foreach($lo_list as $lv_row){
          $this->lo_mdl->delete( $lv_row );
        }
        
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;

				
			// LIST by TEXT 
      // RECUPERAR LAS ZONAS DE LA HOT
      case '#18':
        if(isset($lp_prm['objtyp'])){
          $lv_objtyp = $lp_prm['objtyp'];
          $lv_adrzontxt = (isset($lp_prm['adrzontxt']) ? $lp_prm['adrzontxt'] : '');
        }else{
          $lv_objtyp = $this->co_reg->request->post['objtyp'];
          $lv_adrzontxt = (isset($this->co_reg->request->post['adrzontxt']) ? $this->co_reg->request->post['adrzontxt'] : '');
        }
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]z.objtyp'.chr(9).''.chr(9). $lv_objtyp .chr(9).chr(9).chr(9).
                        							(isset($lv_adrzontxt)?'[~fltrow~]z.adrzontxt'.chr(9).''.chr(9).$lv_adrzontxt.chr(9).chr(9).chr(9):'').
																			'[~fltrow~]z.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'data'=>$lo_data) );
        break;
      
        
        //Devuelve si tiene zonas un objeto (1,0)
      case '#19':
        if (isset($this->co_reg->request->post['objtyp'])){
        	$lv_prm = array('vewfldflt' =>'[~fltrow~]z.objtyp'.chr(9).''.chr(9). $this->co_reg->request->post['objtyp'] .chr(9).chr(9).chr(9).
																				'[~fltrow~]z.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												); 
          $lo_data = $this->lo_mdl->getList($lv_prm);
          $lo_data = (isset($lo_data[0])? 1 : 0);
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'data'=>$lo_data) );
        }else{
        	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>'-1','errtxt'=>'Se requiere tipo de objeto como parámetro','data'=>$lo_data) ); 
        }
        break;
    }
  }
}
?>