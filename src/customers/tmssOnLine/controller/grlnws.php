<?php
final class grlnwsController extends tmssController {
  const CONTROLLER = 'grlnws';
	const MODEL = 'grlnws';
	const VIEW  = 'grlnws';
	const ID = 'nwscod';
  const OBJTYP ='GRL_NWS';
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
        
				if ($lo_post['nwsdte']==''){ $lo_post['nwsdte'] = new DateTime(date('d-m-Y')); }
        
        if ( $this->lo_mdl->save( $lo_post ) ) {
          
					// TEXTO. graba cuerpo de la noticia
          $lo_grltxtmdl=$this->co_reg->load->model('grldattxt');
          $lv_dat = array();
          $lv_dat['txtcod'] = $lo_post['txtbdycod'];
          $lv_dat['txttxt'] = htmlspecialchars(html_entity_decode($_POST['grlnwsbdy']));
          $lv_dat['lngcod'] = $lo_post['lngcod'];
          $lv_dat['docsts'] = 'A';
          $lv_dat['txtsrctyp'] = 'GRL_NWS';
          $lv_dat['txtsrccod'] = $this->lo_mdl->nwscod;
          $lv_dat['txttypcod'] = $lo_post['txttypcod'];
          if ( $lo_grltxtmdl->save( $lv_dat )==false ) {
            return $this->co_reg->document->getJson( array('errtyp'=>$lo_grltxtmdl->errtyp,'errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt));
          }
          
          // CARGA. carga nuevamente el documento grabado
          $this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->nwscod	) );
          
          // TIPO. obtengo los tipos de texto de novedades
          $lo_txttypmdl = $this->co_reg->load->model('grldattxttyp');
					$lv_prm=array('vewfldflt' =>'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
          $lo_rs = $lo_txttypmdl->getList( $lv_prm );
          $this->lo_mdl->txttyp = $lo_rs;

          // CLASE. obtiene la clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
          $this->lo_mdl->sysdoccls=$lo_docclsmdl;
          
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve la vista en modo creacion
      case '#01':
				$this->lo_mdl->create();
        /* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				
				// TIPO. obtengo los tipos de texto de novedades
				$lo_txttypmdl = $this->co_reg->load->model('grldattxttyp');
				$lv_prm=array('vewfldflt' =>'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
				$lo_rs = $lo_txttypmdl->getList( $lv_prm );
				$this->lo_mdl->txttyp = $lo_rs;

				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':	
				$lv_key = array();

				// get param (KEY)																																		
				$lv_key = array(self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]));

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				// copiar
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->nwscod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
          $this->lo_mdl->txtbdycod = '';	//????????***************!!!!!!!!!!!
				}
				
				// TIPO. obtengo los tipos de texto de novedades
				$lo_txttypmdl = $this->co_reg->load->model('grldattxttyp');
				$lv_prm=array('vewfldflt' =>'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
				$lo_rs = $lo_txttypmdl->getList( $lv_prm );
				$this->lo_mdl->txttyp = $lo_rs;
                
        // CLASE. carga clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      	$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
        $this->lo_mdl->sysdoccls=$lo_docclsmdl;
        
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. borra una novedad
      case '#04':
				$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
			/*
      //TO DO: mover accion al controlador grldattsk
      // SCH
      case '#sch':
        $lo_post = $this->co_reg->request->post;
        
        //explota las opcionesd de frecuencia
        $lo_post['freq'] = explode(',',$lo_post['freq']);
        //arma las opciones en un array
        $lv_frqfor=array();
        for($i=0;$i<count($lo_post['freq']);$i+=2){
          array_push($lv_frqfor,array('cod'=>$lo_post['freq'][$i],'txt'=>$lo_post['freq'][$i+1]));
        }
        
        //array de codigos validos
      	$lv_frqarr = array();
      	//regex de las preferencias
      	$lv_frqregex = '/\bU\b|\bPD\b|\bPS\b|\bPM\b|\bPA\b/';
      	//recore las frequencias
      	foreach($lv_frqfor as $lv_row){
          //pregunta si el codigo de frecuencia es valido
          if(preg_match($lv_frqregex,$lv_row['cod'])){
            array_push($lv_frqarr,$lv_row);
          }
        }
        //opciones de frecuencias
        $this->lo_mdl->frq = $lv_frqarr;
        //id del boton de origen
        $this->lo_mdl->srcid = $lo_post['srcid'];
        //formate los valores pre cargados
        $lo_post['prevdat'] = explode(',',$lo_post['prevdat']);
        $lv_prevdatarr = array();
        if(count($lo_post['prevdat'])>1){
          for($i=0;$i<count($lo_post['prevdat']);$i+=2){
            $lv_prevdatarr[$lo_post['prevdat'][$i]] = $lo_post['prevdat'][$i+1];
          }
        } 
        
        $this->lo_mdl->prevdat = $lv_prevdatarr;
        
        return $this->co_reg->document->getView('grldattsksch',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
        
      // EDITOR. carga la vista con el editor
      case '#edt':
        $this->lo_mdl->grlnwsbdy = $_POST['grlnwsbdy'];
        $this->lo_mdl->readonly = $this->co_reg->request->post['readonly'];
        
        return $this->co_reg->document->getView('grlnwsedt',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
        
      // POST. carga la vista con los medios
      case '#pst':
       //obtiene medios
        $lo_sysintmdl = $this->co_reg->load->model('sysint');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lo_rs = $lo_sysintmdl->getList($lv_prm);
        $this->lo_mdl->grlnwsmda = $lo_rs;
        
        return $this->co_reg->document->getView('grlnwspst',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			// SEND. envia una novedad
			case '#send':
				$lo_post = $this->co_reg->request->post;
				
				// cargo la novedad
				$this->lo_mdl->load( array(	self::ID=>$lo_post[self::ID] ) );
				
				// verifico si hay texto
				$lv_nwsmsg = html_entity_decode($this->lo_mdl->nwsmsg);
				if(trim($lv_nwsmsg)==''){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe indicar el texto del mensaje.') );
				}
				
				// verifico destinatarios
				$lv_mailto = array();
				foreach( explode(chr(10),$lo_post['adreml']) as $lv_val ) {
					if(trim($lv_val)!=''){$lv_mailto[] = array('address'=>$lv_val);}
				}
				if(count($lv_mailto)==0){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe indicar al menos un destinatario.') );
				}
				
				// preparo y envío mail
				$lo_eml = new tmssMail();
				$lv_emlprm['to'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
				$lv_emlprm['bcc'] = $lv_mailto;
				$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
				$lv_emlprm['replyto'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
				$lv_emlprm['subject'] = $this->lo_mdl->nwstxt;
				$lv_emlprm['bodyhtml'] = $lv_nwsmsg;
				if ( $lo_eml->send( $lv_emlprm ) ) {
        	return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Se produjo un error al enviar el mensaje. <br><br>'.$lo_eml->getError() ) );
				}
				break;				
			*/
    }
  }
}
?>