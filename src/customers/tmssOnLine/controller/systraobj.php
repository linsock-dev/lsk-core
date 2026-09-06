<?php
final class systraobjController extends tmssController {
	const MODEL = 'systraobj';
	const VIEW  = 'systraobj';
	const ID = 'systraobjcod';
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

			// LIST. lista los objetos de la orden de transporte
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );


      // SAVE. graba el objeto en la orden de transporte
      case '#00':
        $lo_post = $this->co_reg->request->post;
				//$lo_post['sysobjcnt'] = $_POST['sysobjcnt'];
				$this->lo_mdl->save($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'sysobjcod'=>$lo_post['sysobjcod']) );
        break;


      // NEW. devuelve la vista para asignar el objeto a la OT
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();

				// recupera ordenes de transporte
        $lv_prm=array( 'vewfldflt'=>'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rs = $this->lo_mdl->getList($lv_prm);

				// devuelve vista con los datos
				$this->lo_mdl->setData( $lo_post );
				$this->lo_mdl->systradat = $lo_rs;

        // user actual
        $this->lo_mdl->usrcod = $this->co_reg->sec->usrcod;
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;


      // DISPLAY. devuelve la vista con los datos del objeto
      case '#03':
				$lv_key = array();

				// get param (KEY)
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object 
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.']') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				}

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;


      // DELETE. borra un objeto de la OT
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			

			// SAVE FILE CONTENT. graba el contenido de un objeto
			case '#11':
				$lo_post = $this->co_reg->request->post;

				//ORDEN DE TRANSPORTE. revisa si el objeto se encuentra en una orden de transporte
				$lv_prm = array('vewfldflt' => '[~fltrow~]ot.usrcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9).
																			 '[~fltrow~]ot.sysobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjcod'].chr(9).chr(9).
																			 '[~fltrow~]ot.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			 '[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_rs = $this->lo_mdl->getList($lv_prm);

				// el objeto se encuentra dentro de una OT del usuario. se graba el documento
				if(count($lo_rs)>0){
					//FILE. guarda el contenido de un archivo
					$lo_objmdl = $this->co_reg->load->model('sysobj');
					$lo_ret = json_decode($lo_objmdl->setContent($lo_post['sysobjcod'], $_POST['flecont']),true);
					$lo_ret['flecont'] = $_POST['flecont'];
					return $this->co_reg->document->getJson($lo_ret);

				// el objeto no existe en ninguna OT del usuario. se informa
				}else{
					$lv_ret = array('errtyp'=>'W','errcod'=>0,'errtxt'=>'','flcont'=>$lo_post['flecont']);
					return $this->co_reg->document->getJson($lv_ret);
				}
				break;
			
			
			// RELEASE. libera el objeto individual
      case '#release':
				$this->lo_mdl->release();
				return $this->co_reg->document->getjson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;
			
			
			// MOVE OBJECT. mueve un objeto de usuario o de orden
      case '#moveobj': case '#showObjectOrder':
        $lo_post = $this->co_reg->request->post;
        
        /// recupero id de orden de transporte que tenga el objeto que paso asociado
				$lv_prm = array('vewfldflt' => '[~fltrow~]ot.sysobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjcod'].chr(9).chr(9).
																			 '[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs = $this->lo_mdl->getList($lv_prm);

        // si el archivo esta asociado a una orden de transporte visualizo sus datos
        if(isset($lo_rs[0]['systracod'])){
          // cargo info de la OT
          $lo_systramdl = $this->co_reg->load->model('systra');
          $lo_systramdl->load( array( 'systracod' => $lo_rs[0]['systracod'] ) );

          //if($lo_rs[0]['usrcod'] == $this->co_reg->sec->usrcod){
						//obtengo el sytraobjcod de los objetos
						$lv_temptraobj = '';
						$lv_prm = array('vewfldflt' => '[~fltrow~]ot.sysobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['sysobjcod'].chr(9).chr(9).
																					 '[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
						$lo_rs2 = $this->lo_mdl->getList($lv_prm);
						$lv_temptraobj .= $lo_rs2[0]['systraobjcod'].';';

            // asigno info a la OT
            $lo_systramdl->usrcod = $lo_rs[0]['usrcod'];
            $lo_systramdl->systracod = $lo_rs[0]['systracod'];
            $lo_systramdl->systraobjcod = $lv_temptraobj;
						$lo_systramdl->sysobjcod = $lo_post['sysobjcod'];

            // recupera ordenes de transporte del usuario
            $lv_prm=array('vewfldflt'=>'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                   		 '[~fltrow~]ot.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9));
            $lo_rs = $this->lo_mdl->getList($lv_prm);

						// devuelve vista con los datos
						$lo_systramdl->systradat = $lo_rs;

            return $this->co_reg->document->getView( self::VIEW, array('data'=>$lo_systramdl,'actcod'=>$this->data['actcod']) );
          //}else{ 
          //  $lv_ret = array('errtyp'=>'W','errcod'=>0,'errtxt'=>'No se puede realizar este movimento. Archivo utilizado por ['.$lo_rs[0]['usrcod'].']');
          //  return $this->co_reg->document->getJson($lv_ret);
          //}
        }else{
					$lv_ret = array('errtyp'=>'W','errcod'=>0,'errtxt'=>'No existe orden de transporte asociada a este archivo.');
					return $this->co_reg->document->getJson($lv_ret);
        }
				break;
    }
  }
}
?>