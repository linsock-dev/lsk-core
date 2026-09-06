<?php 
final class grldmsdocController extends tmssController {
	const CONTROLLER = 'grldmsdoc';
	const MODEL = 'grldmsdoc';	
	const VIEW  = 'grldmsdoc';	
	const ID = 'grldmsdoccod';	
	const OBJTYP ='GRL_DMS';
  const FILE_ROOT = '../files';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }   
  
	
  // INDEX. Método principal     
  public function index( $lp_act , $lp_prm = array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
    
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      // SAVE. Guarda un objeto
      case '#00':
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save($lo_post) ) {
          if ((isset($lo_post['grldmsdocsrc']) ?? '') == 'FD'){
            $lo_post['grldmsdoccod'] = $this->lo_mdl->grldmsdoccod;
          }else if((isset($lo_post['docsts']) ?? '') == 'W'){
            
          }
          return $this->co_reg->document->getJson( array('data'=>$lo_post, 'errcod'=>$this->lo_mdl->errcod) );
        }else{
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
      

      case '#04':
        $lo_post = $this->co_reg->request->post;
      	// recupero clases de documento de DMS.
				if ( ($lo_post["grldmsdocvercod"]??"")=="" && ($lo_post["grldmsdoccod"]??"")!='' && ($lo_post["grldmsdocdelall"]??false)==true ) {
          $lv_prm = array( 'grldmsdoccod' => $lo_post["grldmsdoccod"] );
          $lv_docdat = $this->lo_mdl->getFileData( $lv_prm );
          $lo_post["grldmsdocvercod"] = $lv_docdat["grldmsdocvercod"];
        }
        $lo_post['act'] = ($lo_post['grldmsdocdelall'] ?? "false") == "true" ? '14' : '04';
      	$this->lo_mdl->delete( $lo_post );
				return $this->co_reg->document->getJson( array('srvret'=>$this->lo_mdl->sv_info,'data'=>$this->lo_mdl->data) );
        break;
        
			// LIST. Lista las carpetas para el árbol de documentos
      case '#': case '#08':
        $lo_trearr = $this->lo_mdl->getFdList( array('vewfldflt'=>'[~fltrow~]d.grldmsdocsrc'.chr(9).'='.chr(9).chr(9).'FD'.chr(9).chr(9)) );
        $lo_rshdr['trearr'] = $lo_trearr[0][0]['alldoc'];
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'dathdr'=>$lo_rshdr,'actcod'=>$this->data['actcod']));
        break;
      
      // DESCARGAR CARPETA COMPLETA (recursivo)
      case '#downloadfolder':
        try {
          $lo_post = $this->co_reg->request->post;

          $lv_fldstr = $this->lo_mdl->getFolderStructure($lo_post);
          $lv_docs = $lv_fldstr;

          $lv_map = [];
          foreach ($lv_docs as $lv_row) {
            $lv_map[$lv_row['grldmsdoccod']] = $lv_row;
          }

          function buildPath($lp_doccod, $lp_map) {
            $lv_path = [];
            while ($lp_doccod && isset($lp_map[$lp_doccod])) {
              array_unshift($lv_path, $lp_map[$lp_doccod]['grldmsdoctxt']);
              $lp_doccod = $lp_map[$lp_doccod]['grldmsfldcod'];
            }
            return implode('/', $lv_path);
          }

          $lv_zipnme = tempnam(sys_get_temp_dir(), 'zip');
          $lo_zip = new ZipArchive();
          $lo_zip->open($lv_zipnme, ZipArchive::OVERWRITE);

          foreach ($lv_docs as $lv_doc) {
            $lv_path = buildPath($lv_doc['grldmsdoccod'], $lv_map);

            if ($lv_doc['grldmsdocsrc'] === 'FD') {
              $lo_zip->addEmptyDir($lv_path);
              continue;
            }

            if ($lv_doc['esdoc'] == 1 && !empty($lv_doc['grldmsdocvercod'])) {
              $lv_cnt = $this->lo_mdl->getFileContents( array( 'grldmsdocvercod' => $lv_doc['grldmsdocvercod'], 'flenme' => $lv_doc['grldmsdoctxt'], 'fletyp' => $lv_doc['fletyp'] ?? 'application/octet-stream' ),
                																				array( 'mode' => 'returnBinary', 'addpth' => '' ) );

              if ($lv_cnt !== false) {
                $lo_zip->addFromString($lv_path, $lv_cnt);
              }
            }
          }

          $lo_zip->close();
					
          $lv_zipfnlnme = ($lv_docs[0]['grldmsdoctxt'] ?? 'carpeta') . '.zip';
          
          $lv_bin = file_get_contents($lv_zipnme);
          unlink($lv_zipnme);

          $this->lo_mdl->data = array( 'zipcnt' => base64_encode($lv_bin), 'zipnme' => $lv_zipfnlnme, 'errcod' => 0 );
          return $this->co_reg->document->getJson( array( 'srvret' => $this->lo_mdl->sv_info, 'data' => $this->lo_mdl->data ) );

        } catch (Exception $e) {
          $this->lo_mdl->data = array( 'errcod' => 1, 'errtyp' => 'server', 'errtxt' => $e->getMessage() );
          return $this->co_reg->document->getJson( array( 'srvret' => $this->lo_mdl->sv_info, 'data' => $this->lo_mdl->data ) );
        }
        break;

     
      // DOC. LIST. Lista los documentos internos de la carpeta seleccionada
      case '#18':
        $lo_post = $this->co_reg->request->post;
        $lo_post["grldmsdoccod"] = $lo_post["grldmsdoccod"] ?? '';
        $lo_post["docsts"] = $lo_post["docsts"] ?? '';
        $lo_post["grldmsfldcod"] = $lo_post["grldmsfldcod"]??'';
        $lo_doclst = $this->lo_mdl->getDocList( array('vewfldflt'=> htmlspecialchars_decode($lo_post['vewfldflt']??'').
        																													 '[~fltrow~]d.grldmsdocsrc'.chr(9).'!='.chr(9).chr(9).'FD'.chr(9).chr(9).
                                              										 ($lo_post["grldmsfldcod"]!='' ? '[~fltrow~]d.grldmsfldcod'.chr(9).'='.chr(9).chr(9).$lo_post["grldmsfldcod"].chr(9).chr(9) : '').
                                                      						 ($lo_post["grldmsdoccod"]!='' ? '[~fltrow~]d.grldmsdoccod'.chr(9).'='.chr(9).chr(9).$lo_post["grldmsdoccod"].chr(9).chr(9) : '').
                                                      						 ($lo_post["docsts"]==true ? '[~fltrow~]dv.docsts'.chr(9).'!='.chr(9).chr(9).'I'.chr(9).chr(9) : '').
                                                      						 	htmlspecialchars_decode($lo_post['vewmaxrec']??'')
                                                  	 ) 
                                           		);
        return $this->co_reg->document->getJson( array('data'=>$lo_doclst["data"], 'errcod'=>$lo_doclst['errcod']) );

			// AYUDA. devuelve vista edicion de ayuda
      case '#hlp':
				return $this->co_reg->document->getView('grldmsdochlp',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
      
    	// VER DOCUMENTO. devuelve la vista con el visor de documentos
      case '#vwdoc': case '#02':
        $lo_post = $this->co_reg->request->post;

        // reviso si es por ID de documento o por ID de versión específico
        $lv_doccod = isset($lo_post['grldmsdocvercod']) ? array('grldmsdocvercod'=>$lo_post['grldmsdocvercod']) : array('grldmsdoccod'=>$lo_post['grldmsdoccod']);
        $lv_docsts = array('docsts'=>$lo_post['docsts'] ?? 'A');
        $lv_prm = array_merge($lv_doccod, $lv_docsts);
        
        $this->data = $this->lo_mdl->getFileData( $lv_prm );
        $this->lo_mdl->oldsec = $lo_post['oldsec'] ?? '';
                
        // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
        
        // si es de tipo texto busco activaciones de IA
        if( str_starts_with($this->data["fletyp"], 'text') ){
          $lo_iaaactmdl = $this->co_reg->load->model( "sysappiaa" );
          $lv_usractlst = $lo_iaaactmdl->getActivationsList( array('vewfldflt'=>'[~fltrow~]a.sysappiaaactcodext'.chr(9).'IN'.chr(9).chr(9).'GRL_DMS_ASS'.chr(9).chr(9) ) );
          if ( is_array($lv_usractlst) && $lv_usractlst["errcod"] === 0) { $this->lo_mdl->iaaactlst = $lv_usractlst; }
        }
        
				return $this->co_reg->document->getView('grldmsdocvew',array('data'=>$this->lo_mdl, 'actcod'=>$this->lo_mdl->actcod));
        break;
      
      case '#getfilecontents':
        $lo_post = $this->co_reg->request->post;
        
      	$lv_fletyp = $lo_post['fletyp'];
        $lv_ext = $lo_post['fleext'] ?? '';
				
        // revisa si el tipo de archivo pertenece a un archivo de Office.
        if (str_starts_with($lv_fletyp, 'application/vnd.openxmlformats-officedocument')){//in_array($lv_fletyp, ['application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/msword', 'application/vnd.ms-excel', 'application/vnd.ms-powerpoint'])) {
          echo '<head>
                  <title>Documento Office</title>
                  <!-- Bootstrap 5 -->
                  <link href="\library\plugins\bootstrap\bootstrap\3.4.1\css\bootstrap.min.css" rel="stylesheet">
                  <!-- Font Awesome -->
                  <link href="\library\fonts\font-awesome\6.4.0pro\css\all.min.css" rel="stylesheet">
                </head>
                <body style="text-align:center;padding-top:50px;">
                  <img src="https://img.icons8.com/color/96/000000/microsoft-office-2019.png" alt="Office Icon">
                  <p>Este es un documento de Office' . ($lv_ext ? ' (.' . htmlspecialchars($lv_ext) . ')' : '') . '</p>
                  <button id="btndwn" class="btn btn-success">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </body>';
          exit;
        }else if(str_starts_with($lv_fletyp, 'text')){
          $lv_docvewdat = $this->lo_mdl->getFileContents( array('grldmsdocvercod'=>$lo_post['grldmsdocvercod'], 'fletyp'=>$lv_fletyp, 'flenme'=>$lo_post['grldmsdoctxt']), array('mode'=>'returnText','addpth'=>'') );
        	echo '<form method="post">
                	<textarea id="docvewmce">'.htmlspecialchars($lv_docvewdat).'</textarea>
                </form>';
          exit;
        }
        else if($lv_fletyp == 'application/pdf' || str_starts_with($lv_fletyp, 'image')){
        	$lv_docvewdat = $this->lo_mdl->getFileContents( array('grldmsdocvercod'=>$lo_post['grldmsdocvercod'], 'fletyp'=>$lv_fletyp, 'flenme'=>$lo_post['grldmsdoctxt']) );
        }
        else{
        	echo '<head>
                  <title>Documento No Reconocido</title>
                  <!-- Bootstrap 5 -->
                  <link href="\library\plugins\bootstrap\bootstrap\3.4.1\css\bootstrap.min.css" rel="stylesheet">
                  <!-- Font Awesome -->
                  <link href="\library\fonts\font-awesome\6.4.0pro\css\all.min.css" rel="stylesheet">
                </head>
                <body style="text-align:center;padding-top:50px;">
                  <img src="library/images/TemasisArgentina_Isotipo_280gray.png" alt="Temasis Icon">
                  <p>No se reconoce el tipo de documento' . ($lv_ext ? ' (.' . htmlspecialchars($lv_ext) . ')' : '') .'. ' 
                  .	'Se recomienda no descargarlo a menos que su fuente sea confiable.</p>
                  <button id="btndwn" class="btn btn-success">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </body>';
          exit;
        }
        
        $this->data = $lv_docvewdat;
          
				return $this->co_reg->document->getJson( array('data'=>$this->data, 'actcod'=>$this->data['actcod']) );
        break;
        
      case '#uploadnewdocument':
        $lo_post = $this->co_reg->request->post;
        $lv_docclscod = $lo_post['sysdocclscod'] ?? '';
        $this->lo_mdl->flesrcfld = $lo_post['grldmsfldcod'] ?? '';
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      	// recupero clases de documento de DMS.
				if ( $lv_docclscod=='' ) {
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'GRL_DMS'.chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                          );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para DMS.
          return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=uploadNewDocument&prm_mdlcod=GRL&prm_prgcod=DMS','doccls'=>$lv_docclsarr, 'data'=>$lo_post) );
        }
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          // si es un texto vacío, devuelvo la clase y continúo con la creación desde la vista
          if (isset($lo_post['grldmsdocsrc']) && $lo_post['grldmsdocsrc'] == 'T' ){
            return $this->co_reg->document->getJson( array('sysdocclscod'=>$this->lo_mdl->sysdoccls->sysdocclscod, 'errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          }
        }else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        // cargo los tipos de archivos (si no se indica archivo y se indica tipo de objeto)
        $this->lo_mdl->fletyplst = array();
        if ( !isset($lo_post['fletypcod']) || $lo_post['fletypcod']==null ){
          if(($lo_post['sysdocclscod'] ?? '')!=''){
            $lo_typmdl = $this->co_reg->load->model('sysdocclsfle');
            $lv_prm = array('vewfldflt'=> '[~fltrow~]dcf.SysDocClsCod'.chr(9).'='.chr(9).chr(9). $lo_post['sysdocclscod'] .chr(9).chr(9).
                                          '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
            $lo_rs = $lo_typmdl->getList( $lv_prm );
            $this->lo_mdl->fletyplst = $lo_rs;
          }
        }
        
        $this->lo_mdl->grldmsdoccod = $lo_post['grldmsdoccod'] ?? '';
        $this->lo_mdl->grldmsdocvercod = $lo_post['grldmsdocvercod'] ?? '';
				$this->lo_mdl->sysdocclscod = $lo_post['sysdocclscod'] ?? '';
				$this->lo_mdl->flesrcfld = $lo_post['grldmsfldcod'] ?? '';
				$this->lo_mdl->fletypcod = $lo_post['fletypcod'] ?? '';
        $this->lo_mdl->docsts = $lo_post['docsts'] ?? '';
        $this->lo_mdl->oldsec = (isset($lo_post['sec'])?$lo_post['sec']:'');
        $this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'');
				return $this->co_reg->document->getView( 'grldmsdocupl', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
    
    	// UPLOAD FILE. adjunta un archivo
      case '#uploadFile':
        $lo_post = $this->co_reg->request->post;
        if ( $lo_post['grldmsdocsrc'] ?? '' == 'T'){
          // si es un texto, revisa si es una versión activa o si ya está siendo editada
          if (isset($lo_post['docsts']) && $lo_post['docsts']!='E'){
            // si el archivo no está siendo editado, borró el código de la versión para que el modelo modifique el contenido y cree una nueva versión
            unset($lo_post['grldmsdocvercod']);
          }
          // si no, creo una nueva versión y modifico el estado de la cabecera
          $lv_txtsveret = $this->lo_mdl->uploadString( $lo_post );
          return $this->co_reg->document->getJson( array('data'=>$lv_txtsveret, 'errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        else{
          $lv_flesveret = $this->lo_mdl->uploadFile( $lo_post );
          return $this->co_reg->document->getJson( array('data'=>$lv_flesveret, 'errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
				
        break;
        
      // DOWNLOAD FILE. descarga un adjunto
			case '#downloadfile':
        $lo_post = $this->co_reg->request->post;
        
        $lo_post['grldmsdocvercod'] = (isset($lp_prm['grldmsdocvercod'])?$lp_prm['grldmsdocvercod']:$lo_post['grldmsdocvercod']);

        if ( $this->lo_mdl->getFileData( array('grldmsdocvercod'=>$lo_post['grldmsdocvercod']) ) ) {
					$this->lo_mdl->download();
				}

				break;
        
      // PROCESS FILE. procesa el archivo una vez que el editor lo publica
			case '#processfile':
        $lo_post = $this->co_reg->request->post;
        // cargo todos los datos del documento y de la versión
        $lo_post['grldmsdocvercod'] = (isset($lp_prm['grldmsdocvercod'])?$lp_prm['grldmsdocvercod']:$lo_post['grldmsdocvercod']);
        $this->data = $lo_post;
        if ( $this->lo_mdl->getFileData( array('grldmsdocvercod'=>$lo_post['grldmsdocvercod']) ) ) {
          // cargo la clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          if( $lo_docclsmdl->load( array( 'sysdocclscod'=>$lo_post['sysdocclscod'] ) ) ){
            $lv_workflows = $lo_docclsmdl->sysdocclswrk;
          }
          // reviso si tiene algún workflow asociado
          if( count($lv_workflows)>0 ){
            // si lo/s tiene, valido y llamo al workflow con sus parámetros para ver si se triggerea
            $lo_wrkmdl = $this->co_reg->load->model('grldatwrk');
            foreach($lv_workflows as $lv_rowwrk){
              $lv_prm = array('srcobjtyp'=>'GRL_DMS',
                              'srcobjcod001'=>$this->data['grldmsdoccod'],
                              'srcobjcod002'=>($this->data['grldmsdocvercod']??''),
                              'sysdocclscod'=>$this->data['sysdocclscod'],
                              'wrkflwcod'=>$lv_rowwrk['wrkflwcod'],
                              'relsts'=>'A',
                              'docsts'=>'W',                        
                              'data'=>$this->data);
              $lo_wrkmdl->trigger( $lv_act,$lv_prm );
            }
          }
          else{
            $this->data['srcobjdocclscod'] = $this->data['sysdocclscod'];
            unset($this->data['sysdocclscod']);
            $lv_docpblrsp = $this->lo_mdl->publishFile( $this->data );
            return $this->co_reg->document->getJson( array('data'=>$lv_docpblrsp,'errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          }
				}

				break;
    }
  }
}
?>