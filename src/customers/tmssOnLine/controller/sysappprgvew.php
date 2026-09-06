<?php
final class sysappprgvewController extends tmssController {

	const MODEL = 'sysappprgvew';
	const VIEW  = 'sysappprgvew';
	const ID = 'vewcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();


  function __construct(&$lp_reg) {$this->co_reg = $lp_reg;}


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
        
        $lo_post['vewalwsrt'] = ($lo_post['vewalwsrt']??1);
        $lo_post['vewalwflt'] = ($lo_post['vewalwflt']??1);
        $lo_post['vewsrcsys'] = ($lo_post['vewsrcsys']??1);
        if ( $this->lo_mdl->save( $lo_post ) ) {  
          
          // grabo columnas de la tabla
					$lo_sysvewcolmdl = $this->co_reg->load->model('sysappprgvewcol');
          $lo_post['vewcod'] = $this->lo_mdl->vewcod;
					$lv_buffer = $lo_post['sysvewcol'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_sysvewcol_arr = json_decode($lv_buffer,true);
            foreach($lv_sysvewcol_arr as $lv_row){
              $lv_row['vewcod'] = $this->lo_mdl->vewcod;
              $lv_row['docsts'] = 'A';
              if (isset($lv_row['deleted'])) {
                if ($lo_sysvewcolmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysvewcolmdl->errtyp,'errcod'=>$lo_sysvewcolmdl->errcod,'errtxt'=>$lo_sysvewcolmdl->errtxt));
                }
              } else if ($lo_sysvewcolmdl->save($lv_row)==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysvewcolmdl->errtyp,'errcod'=>$lo_sysvewcolmdl->errcod,'errtxt'=>$lo_sysvewcolmdl->errtxt));
              } 
            }
          }
					$this->lo_mdl->load( array('vewcod'=>$this->lo_mdl->vewcod	) );

          return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }

      // NEW. devuelve vista en modo creación
      case '#01':
				$this->lo_mdl->create();
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;

      // CHANGE - DISPLAY - COPY. Devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
        $lv_key = array(self::ID=>(isset($lp_prm['vewid']) ? $lp_prm['vewid'] : $this->co_reg->request->post[self::ID])) ;

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].'));

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));

				} else if ( $lp_act == '#001' ) {          
          $this->lo_mdl->vewcod = '';
					$lo_rs = $this->lo_mdl->sysvewcol;
					foreach($lo_rs as &$lv_row){
						$lv_row['vewfldcod']='';
						$lv_row['ctedte'] = '';
						$lv_row['cteusr'] = '';
						$lv_row['upddte'] = '';
						$lv_row['updusr'] = '';
					}
					unset($lv_row);
					$this->lo_mdl->sysvewcol = $lo_rs;
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. borra un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			// GET TYPEAHEAD DEFINITION. devuelve la definición de typeahead de una vista
			case '#getTypeaheadDefinitions':				
				$lo_post = $this->co_reg->request->post;
				
				// busco definicion
				$lv_prm=array('vewfldflt' =>'[~fltrow~]dbo.getTagValue(^typcod^,v.vewatr)'.chr(9).'NE'.chr(9).chr(9).chr(9).chr(9).
																		'[~fltrow~]v.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
											'vewmaxrec' => '999' );
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				
				// preparo datos de salida
				$lo_ret = array();
				foreach( $lo_rs as $lv_row ){
					$lo_ret[] = array('typcod'=>$this->co_reg->document->getTagValue( $lv_row['vewatr'], 'typcod' ),
														'typtxt'=>$this->co_reg->document->getTagValue( $lv_row['vewatr'], 'typtxt' ),
														'typprg'=>$this->co_reg->document->getTagValue( $lv_row['vewatr'], 'typprg' ),
														'vewttl'=>$this->co_reg->language->getTranslation( $lv_row['vewttl'] ),
														'vewcod'=>$lv_row['vewcod']);
				}
				
				// devuelvo definicion en formato JSON
				return $this->co_reg->document->getJson( $lo_ret );
				break;

    }
  }
}
?>