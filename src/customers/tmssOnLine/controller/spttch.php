<?php
final class spttchController extends tmssController {
	const CONTROLLER = 'spttch';
	const MODEL = 'spttch';							
	const VIEW  = 'spttch';							
	const ID = 'tchcod';
  const OBJTYP ='SPT_TCH';
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
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
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
        //datos post
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save($lo_post) ) {
          //graba la tabla
          $lo_tchactmdl = $this->co_reg->load->model('spttchact');
          $lv_buffer = $lo_post['spttchact'];
          if ($lv_buffer!='') {
          	$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_tchact_arr = json_decode($lv_buffer,true);
            
            foreach( $lv_tchact_arr as $lv_row ) {
            	$lv_row['tchcod'] = $this->lo_mdl->tchcod;
              $lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
              	if ($lo_tchactmdl->delete( $lv_row )==false) {
				          return $this->co_reg->document->getJson( array('errtyp'=>$lo_tchactmdl->errtyp,'errcod'=>$lo_tchactmdl->errcod,'errtxt'=>$lo_tchactmdl->errtxt,'row'=>$i) );
								}
              } else {
              	if ($lo_tchactmdl->save( $lv_row )==false) {
			          	return $this->co_reg->document->getJson( array('errtyp'=>$lo_tchactmdl->errtyp,'errcod'=>$lo_tchactmdl->errcod,'errtxt'=>$lo_tchactmdl->errtxt,'row'=>$i) );
                }
              }
              $i++;
            }
          }
          
          $this->lo_mdl->load( array(	'tchcod'=>$this->lo_mdl->tchcod	) );
          //carga clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          }
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
      	break;

      // NEW                
      case '#01':
				$this->lo_mdl->create();
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[fltrow]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[fltrow]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
					$this->lo_mdl->sysdocclstxt = $lo_docclsmdl->sysdocclstxt;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------*/
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']) );
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
					
          // limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->spttchact; 
          foreach($lv_dat as &$lv_row){
            $lv_row['tchactcod'] = ''; 
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lv_row); 
          $this->lo_mdl->spttchact = $lv_dat;
          $this->lo_mdl->tchcod = '';																									
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
      
        // cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
        $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        
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
												'vewfldflt' => (isset($lp_prm['tchtxt'])?'[~fltrow~]t.tchtxt'.chr(9).''.chr(9).$lp_prm['tchtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>