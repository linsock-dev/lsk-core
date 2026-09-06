<?php
final class grldatuplController extends tmssController {

	const MODEL = 'grldatupl';
	const VIEW  = 'grldatupl';
	const ID = 'flecod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();


  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  //INDEX. metodo principal
  public function index( $lp_act , $lp_prm=array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lo_post = $this->co_reg->request->post;
		$lo_post['flecod'] = (isset($lo_post['flecod'])?$lo_post['flecod']:'');
		$lo_post['flesrctyp'] = (isset($lo_post['flesrctyp'])?$lo_post['flesrctyp']:'');
		$lo_post['flesrccod'] = (isset($lo_post['flesrccod'])?$lo_post['flesrccod']:'');
		$lo_post['flesrcfld'] = (isset($lo_post['flesrcfld'])?$lo_post['flesrcfld']:'');
		$lo_post['fletypcod'] = (isset($lo_post['fletypcod'])?$lo_post['fletypcod']:'');

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// SHOW UPLOAD GRID. muestra la vista de grilla de archivos de un objeto
      case '#showUploadGrid'://NO HARIA FALTA
				$this->lo_mdl->flecod = $lo_post['flecod'];
				$this->lo_mdl->flesrctyp = $lo_post['flesrctyp'] ?? '';
				$this->lo_mdl->flesrccod = $lo_post['flesrccod'] ?? '';
				$this->lo_mdl->flesrcfld = $lo_post['flesrcfld'] ?? '';
				$this->lo_mdl->fletypcod = $lo_post['fletypcod'] ?? '';
        $this->lo_mdl->sysdocclscod = $lo_post['sysdocclscod'] ?? '';
				return $this->co_reg->document->getView( 'grldatuplgrd', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;



			// GET UPLOAD LIST. devuelve la lista de adjuntos de un objeto (JSON)
			case '#getUploadList':
				$lo_rs = array();
				if($lo_post['flesrctyp']!='' && $lo_post['flesrccod']!=''){
					$lv_prm = array('vewfldflt'=> '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9). $lo_post['flesrctyp'] .chr(9).chr(9).
																				'[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9). $lo_post['flesrccod'] .chr(9).chr(9).
																				( ($lo_post['flesrcfld']??'')!=''?'[~fltrow~]f.flesrcfld'.chr(9).'='.chr(9).chr(9). $lo_post['flesrcfld'] .chr(9).chr(9):'' ).
																				( ($lo_post['fletypcod']??'')!=''?'[~fltrow~]ft.fletypcod'.chr(9).'='.chr(9).chr(9). $lo_post['fletypcod'] .chr(9).chr(9):'' ).
                          							( ($lo_post['sysdocclscod']??'')!=''?'[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9). $lo_post['sysdocclscod'] .chr(9).chr(9):'' ).
																				'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9).
																				'[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
					$lo_rs = $this->lo_mdl->getList( $lv_prm );
				}
				return $this->co_reg->document->getJson( $lo_rs );
				break;



			// SHOW UPLOAD. muestra la vista para la carga de un adjunto (camara o archivo)
      //NUEVA VISTA DE ARCHIVOS E IMAGENES PARA SUBIR/VER/EDITAR  
      case '#showUpload':
				// cargo info del archivo (si se informa)
				if($lo_post['flecod']!='') {
					$this->lo_mdl->load( array('flecod'=>$lo_post['flecod']) );
				}

				// cargo los tipos de archivos (si no se indica archivo y se indica tipo de objeto)
				$this->lo_mdl->fletyplst = array();
				//viejo filtro por objtyp para que no se rompa lo no migrado
        /*if( $lo_post['flesrctyp']!='' && ($lo_post['sysdocclscod'] ?? '')=='' ) {
					$lo_typmdl = $this->co_reg->load->model('grldatfletyp');
					$lv_prm = array('vewfldflt'=> '[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9). $lo_post['flesrctyp'] .chr(9).chr(9).
																				($lo_post['fletypcod']!=''?'[~fltrow~]ft.fletypcod'.chr(9).'='.chr(9).chr(9). $lo_post['fletypcod'] .chr(9).chr(9):'').
																				'[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
					$lo_rs = $lo_typmdl->getList( $lv_prm );
					$this->lo_mdl->fletyplst = $lo_rs;
				}*/
        //if(($lo_post['sysdocclscod'] ?? '')!=''){
          $lo_typmdl = $this->co_reg->load->model('sysdocclsfle');
					$lv_prm = array('vewfldflt'=> '[~fltrow~]dcf.SysDocClsCod'.chr(9).'='.chr(9).chr(9). $lo_post['sysdocclscod'] .chr(9).chr(9).
																				'[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
					$lo_rs = $lo_typmdl->getList( $lv_prm );
					$this->lo_mdl->fletyplst = $lo_rs;
        //}
        
				$this->lo_mdl->sysdocclscod = $lo_post['sysdocclscod'] ?? '';
        $this->lo_mdl->flecod = $lo_post['flecod'];
				$this->lo_mdl->flesrctyp = $lo_post['flesrctyp'];
				$this->lo_mdl->flesrccod = $lo_post['flesrccod'];
				$this->lo_mdl->flesrcfld = $lo_post['flesrcfld'];
				$this->lo_mdl->fletypcod = $lo_post['fletypcod'];
        $this->lo_mdl->oldsec = (isset($lo_post['sec'])?$lo_post['sec']:'');
        $this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'');
				return $this->co_reg->document->getView( 'grldatupl', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;



			// SHOW UPLOAD CAM. muestra la vista para usar la camara
      case '#showUploadCam':
				$lo_post = $this->co_reg->request->post;
				return $this->co_reg->document->getView( 'grldatuplcam', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;



      // UPLOAD FILE. adjunta un archivo
      case '#uploadFile':
        $this->lo_mdl->uploadFile( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;



			// UPLOAD IMAGE. adjunta una imagen
			case '#uploadImage':
				$this->lo_mdl->uploadImage( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;


			// UPLOAD STRING. adjunta un string
			case '#uploadString':
				$this->lo_mdl->uploadString( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;


			// UPDATE DATA. acctualiza los atributos de una imagen
			case '#save':
				$this->lo_mdl->save( $lo_post );
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;


			// DOWNLOAD FILE. descarga un adjunto
			case '#downloadFile':
				$lo_post['flesrctyp'] = (isset($lp_prm['flesrctyp'])?$lp_prm['flesrctyp']:$lo_post['flesrctyp']);
				$lo_post['flesrccod'] = (isset($lp_prm['flesrccod'])?$lp_prm['flesrccod']:$lo_post['flesrccod']);
				$lo_post['flecod'] = (isset($lp_prm['flecod'])?$lp_prm['flecod']:$lo_post['flecod']);
				if ( $this->lo_mdl->load( array('flesrctyp'=>$lo_post['flesrctyp'],'flesrccod'=>$lo_post['flesrccod'],'flecod'=>$lo_post['flecod']) ) ) {
					$this->lo_mdl->download();
				}
				break;



			// DELETE FILE. borra un adjunto
      case '#deleteFile':
        $this->lo_mdl->delete( $lo_post );
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;



			// UPLOAD BUTTON. muestra el botón de archivos adjuntos
			case '#07':
				// obtengo lista de adjuntos
				$lo_flelstmdl = $this->co_reg->load->model('grldatupl');
				$lv_prm = array('vewfldflt' => '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->flesrctyp .chr(9).chr(9).
																			 '[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->flesrccod .chr(9).chr(9)
												);
				$lo_rs = $lo_flelstmdl->getList( $lv_prm );
				$this->lo_mdl->flelst = $lo_rs;

				return $this->co_reg->document->getView( 'grldatuplbtn', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;



			// GET FILE. devuelve los datos de un archivo (especifico o principal) y su contenido
      case '#getFile':
				$lp_prm['main'] = (isset($lp_prm['main'])?$lp_prm['main']:'');						// devuelve el archivo con marca de principal
				$lp_prm['content'] = (isset($lp_prm['content'])?$lp_prm['content']:'');		// devuelve el contenido
				if($lp_prm['main']=='') {
					$this->lo_mdl->load( $lo_post );
				} else {
					$this->lo_mdl->getMainPhoto( $lo_post );
					$lo_data = $this->lo_mdl->getData();
					if( count($lo_data)>0){
						$this->lo_mdl->load( array('flecod'=>$lo_data[0]['flecod']) );
					} else {
						$this->lo_mdl->create();
					}
				}
				$lo_data = $this->lo_mdl->getData();
        $this->lo_mdl->flecnt = '';
				$this->lo_mdl->fleimg = false;
				if($lp_prm['content']!='' && $this->lo_mdl->flecod!=''){
					//Get file content
					$lo_img = $this->lo_mdl->getFileContents( array('flecod'=>$this->lo_mdl->flecod) );
					// Check if file is a valid image
					// Call imagecreatefromstring function wiht '@' operator to disable E_WARNING if the data is not in a recognized format
          $lv_fletyp = explode('/', $this->lo_mdl->fletyp);
          if($lv_fletyp[0] == 'IMAGE'){
            if (@imagecreatefromstring($lo_img)!== false) {
              // Image is valid -> return it as base64 encoded string
              $lo_data['flecnt'] = base64_encode($lo_img);
              $lo_data['fleimg'] = true;
            }
          }
				}
				return $this->co_reg->document->getJson( $lo_data );

        break;
		}
  }
}
?>
