<?php
final class finlocargltrController extends tmssController {
  const CONTROLLER = 'finlocargltr';
	const MODEL = 'finlocargltr';
	const VIEW  = 'finlocargltr';
	const ID = 'argltrcodext';
  const OBJTYP ='FIN_LOC_ARG_LTR';
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
				$lv_buffer = $lo_post['argltrrules'] ?? '';
				if ($lv_buffer!='') {
					$i=0;
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_argltrrules_arr = json_decode($lv_buffer,true);

					foreach( $lv_argltrrules_arr as $lv_row ) {
						$lv_row['argltrcodext'] = $lo_post['argltrcodext'];
						$lv_row['docsts'] 			= $lo_post['docsts'];

						if ( isset($lv_row['deleted']) && $lv_row['deleted']=="X" && $lv_row['argltrcod']!='' ) {
							if ($this->lo_mdl->delete($lv_row)==false) {
              	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'row'=>$i) );
							}
						} else {
							if ($this->lo_mdl->save($lv_row)==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'row'=>$i) );
							}
						}
						$i++;
					}
					$this->lo_mdl->load( array(	'argltrcodext'=>$lo_post['argltrcodext'] ) );
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        } else {
          if ( $this->lo_mdl->save( $lo_post ) ){
            $this->lo_mdl->load( array(	'argltrcodext'=>$lo_post['argltrcodext'] ) );
            return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        	}
        }
        break;
			
      // NEW.  devuelve vista en modo creación              
      case '#01': 
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
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
					$this->lo_mdl->argltrcodext = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
					$lv_recordset = array();
					foreach($this->lo_mdl->recordset as $lv_row ){
						$lv_row['argltrcod'] = '';
						array_push($lv_recordset, $lv_row);
					}
					$this->lo_mdl->recordset = $lv_recordset;
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        break;
			
			// DELETE
      case '#04':
        $this->lo_mdl->deleteByArgltrcodext();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['argltrcodext'])?'[~fltrow~]argltrcodext'.chr(9).''.chr(9).$lp_prm['argltrcodext'].chr(9).chr(9).chr(9):'')
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
			
			
			// GET LETTER
      case '#getLetter':
				$lo_post = $this->co_reg->request->post;
				$lv_taxcatcodsrc = (isset($lo_post['taxcatcodsrc'])?$lo_post['taxcatcodsrc']:'');
				$lv_taxcatcoddst = (isset($lo_post['taxcatcoddst'])?$lo_post['taxcatcoddst']:'');
				$lv_argltroprtyp = (isset($lo_post['argltroprtyp'])?$lo_post['argltroprtyp']:'');
				if( $lv_taxcatcodsrc!='' && $lv_taxcatcoddst!='' && $lv_argltroprtyp!='' ) {
					$lv_prm = array('vewmaxrec' =>'10',
													'vewfldflt' =>'[~fltrow~]l.taxcatcodsrc'.chr(9).''.chr(9).$lv_taxcatcodsrc.chr(9).chr(9).chr(9).
																				'[~fltrow~]l.taxcatcoddst'.chr(9).''.chr(9).$lv_taxcatcoddst.chr(9).chr(9).chr(9).
																				'[~fltrow~]l.argltroprtyp'.chr(9).''.chr(9).$lv_argltroprtyp.chr(9).chr(9).chr(9).
																				'[~fltrow~]l.docsts'.chr(9).chr(9).'A'.chr(9).chr(9).chr(9)
													);
					$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				} else {
					$lo_data = array();
				}
        return $this->co_reg->document->getJson( $lo_data );
        break;	
    }
  }
}
?>