<?php
abstract class tmssController2 {
  // --------------------------------------------------------------------------------------
  // resumen de operaciones de esta clase:
  // - initialize (obligatoria): inicializa variables y define el comportamiento de la clase
  // - index: metodo principal de la clase
  // - getList / create / save / delete / modify / view / copyDocument (operaciones)
  // - beforeSave / afterSave / beforeDelete / afterDelete / afterCopy / afterLoad / afterCreate/ beforeGetList (exit dentro de operaciones)
  // --------------------------------------------------------------------------------------
  
	protected $co_reg;						// array con otras clases a utilizar
	protected $data = [];					// datos propios del controlador
  protected $err = [];  				// array de errores
  protected $act;								// id de actividad
	protected $prm;								// datos de url (https:\\...&prm_clave=valor)
  protected $post;							// datos post
  protected $mdl;								// id de modelo
  protected $enable_sysdoccls;	// flag para habilitar el uso de clases de documento
  protected $authCheck = true;	// flag que indica que la operacion verifica permisos de usuario
  protected $preventCopy = [];	// array con campos que no deben copiarse cuando se hace un copiar documento
  protected $getJson = '';			// flag que indica si los datos devuelto por la clase deben ser en formato json
    
	function __construct( &$lp_reg ) { 
		$this->co_reg = $lp_reg;
		$this->initialize();
  }
	
	function __get( $lp_key ) { return $this->data[$lp_key] ?? '' ; }
	function get( $lp_key ) { return $this->data[$lp_key] ?? '' ; }
	function getData(){ return $this->data; }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=[] ) { $this->data = $lp_dat; }	  
  
  
  
  // initialize debe sobreescribirse (override) en cada controlador para indicar los parámetros de ejecución del controlador
	// ejemplo: function initialize(){ $this->MODEL='tsrbnkacc'; $this->VIEW='tsrbnkacc'; $this->ID='bnkacccod'; }
	function initialize(){
    $this->enable_sysdoccls=false; 	// este indicador se utiliza cuando la opcion gestiona clase de documentos
    $this->OBJTYP=''; 
    $this->CONTROLLER=''; 
    $this->MODEL=''; 
    $this->VIEW=''; 
    $this->ID=''; 
    $this->ID2='';
    $this->enable_2stepsview=false; // este indicador se utiliza para que las vistas y los datos se carguen de forma separada
    $this->preventCopy=[];	// evita que estos datos sean copiados de documento en documento
  }
	
  
  
  // INDEX. metodo principal de la clase. recibe la actividad a realizar y los parámetros que se indican por url https:\\...&prm_clave=valor
  function index( $lp_act , $lp_prm=[] ) {
    
    // se inicializan las variables internas
		$this->act = $lp_act;
    $this->prm = $lp_prm;
    $this->post = $this->co_reg->request->post;
    $this->err = [];
    $this->getJson = ($this->prm['getjson']??'');		// determina si se debe devolver los datos como JSON. ejemplo: ?prg=slscus&act=03&prm_getjson=X
    $this->extraRet = !$this->extraRet || $this->extraRet == '' ? [] : $this->extraRet;
    if( $this->MODEL!='' ){ $this->mdl = $this->co_reg->load->model( $this->MODEL ); }
    
    // todos los metodos de esta clase validan sesion/login de usuario **********************
		$this->co_reg->request->post['ajax']='1';	// ???? revisar este concepto
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();	// todo se debe controlar ???
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
    // **************************************************************************************
    
    // determina la operacion a realizar
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      case '#': case '#08': return $this->getList();
      case '#00': return ( $this->save()==true ? $this->view() : $this->co_reg->document->getJson( $this->err ) );
      case '#01': return $this->create();
      case '#001': return $this->copyDocument();
      case '#02': return $this->modify();
      case '#03': return $this->view();
      case '#04': return $this->delete();
      case '#09': return $this->accounting();
      default: return $this->additionalFunctions($lp_act, $this->prm);
    }
  }
	  
  
  
  // LISTAR - devuelve la vista de listar documentos
  function getList(){
    // verifico que se haya indicado un modelo
	  if( !$this->checkParameter('MODEL') ){ return $this->co_reg->document->getJson( $this->err ); }
    
    // instancio controlador y ejecuto la operación de listar
    $lo_vew = $this->co_reg->load->controller('grlvew');
    $this->prm['model'] = $this->MODEL;
    
    $this->beforeGetList();
    
    return $lo_vew->index( '00', $this->prm );    
  }
  // beforeList. permite hacer un override para fijar datos antes de obtener el listado.
  function beforeGetList( ){ }
  
  
  
  // CREAR - devuelve la vista de un documento en modo creación
  function create(){
    // verifico que se haya indicado un codigo de vista (solo si la salida no es json)
	  if( !$this->checkParameter('VIEW') && $this->getJson=='' ){ return $this->co_reg->document->getJson( $this->err ); }
    
    // verifico que se haya indicado un codigo de modelo
    if( !$this->checkParameter('MODEL') ){ return $this->co_reg->document->getJson( $this->err ); }
        
  	// instancio modelo
    $this->mdl = $this->co_reg->load->model( $this->MODEL );
    
    $this->beforeCreate();
    
    // ejecuto create del modelo
    $this->mdl->create( $this->post );
    
    // CLASE DE DOCUEMTNO. obtengo/determino clase de documento
    if( $this->enable_sysdoccls ){
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
			
      $lv_docclscod = ($this->post['sysdocclscod']??'');
      // si no se indico clase de documento se obtiene la lista de posibles clases para el objeto
      if ( $lv_docclscod=='' ) {
        $lv_objtyp = ( ($this->prm['mdlcod']??'')!='' && ($this->prm['prgcod']??'')!='' ? $this->prm['mdlcod'].'_'.$this->prm['prgcod'] : $this->OBJTYP );
        if( ( ($this->prm['mdlcod']??'')=='' || ($this->prm['prgcod']??'')=='' ) && stripos($this->OBJTYP,'_')!=false ){
        	$this->prm['mdlcod'] = explode('_', $this->OBJTYP )[0];
        	$this->prm['prgcod'] = explode('_', $this->OBJTYP )[1];
        }
        if($lv_objtyp==''){
          $this->err = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se puede determinar el tipo de objeto.');
          return $this->co_reg->document->getJson( $this->err );
        }
        $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).$lv_objtyp.chr(9).chr(9).chr(9).
                                      '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      );
        $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );
        // si hay solo una la tomo como default
        if ( count($lv_docclsarr)==1 ) {
          $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
        // valido datos minimos requeridos
        } else if( $this->CONTROLLER=='') {
          $this->err = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Variable CONTROLLER no inicializada.');
          return $this->co_reg->document->getJson( $this->err );
        // muestra la lista de clases de documento y redirecciona al controlador indicado una vez seleccionado una
        } else if( $this->getJson=='' ){
					return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.$this->CONTROLLER.'&act=01&prm_mdlcod='.$this->prm['mdlcod'].'&prm_prgcod='.$this->prm['prgcod'],'doccls'=>$lv_docclsarr) );
				} else {
					return $this->co_reg->document->getJson( array('url'=>'?prg='.$this->CONTROLLER.'&act=01&prm_mdlcod='.$this->prm['mdlcod'].'&prm_prgcod='.$this->prm['prgcod'],'doccls'=>$lv_docclsarr) );
        }
      }
      // obtengo toda la info de la clase de documento
      if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {
        $this->mdl->sysdoccls = $lo_docclsmdl;
      // no se pudo cargar la clase de documento, devuelvo error
      } else {
        $this->err = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se pudieron cargar los datos de la clase de documento ['.$lv_docclscod.']. '.$lo_docclsmdl->errcod.': '.$lo_docclsmdl->errtxt);
        return $this->co_reg->document->getJson( $this->err );
      }
    }

    $this->afterCreate();
    
    // devuelve datos de creación
    $lv_ret = array_merge(array('data'=>$this->mdl,'actcod'=>$this->act), $this->extraRet);
		if( $this->getJson!='' ){
			return $this->co_reg->document->getJson( $lv_ret );
		} else {
			return $this->co_reg->document->getView( $this->VIEW, $lv_ret );
		}
  }
  // beforeCreate. permite ejecutar código antes de ejecutar el create del modelo
  function beforeCreate( ){ }
  // afterCreate. permite ejecutar código luego de haber ejecutado el create del modelo y antes de finalizar la ejecución
  // Se ejecuta luego de fijar la clase de doc, si es que usa
  function afterCreate( ){ }
  
  
  
  // GRABAR - guarda un documento nuevo o modificado
  function save(){
    // verifico que se haya indicado un codigo de modelo
    if( !$this->checkParameter('MODEL') ){ return false; }
    
  	// instancio modelo
    $this->mdl = $this->co_reg->load->model( $this->MODEL );
    
    // exit previo al grabado
    $lp_dat = $this->beforeSave( $this->post );
    
    // grabo documento
  	$lv_ret = $this->mdl->save( $lp_dat, $this->authCheck );
    if($lv_ret==true){
			$this->prm[$this->ID] = $this->mdl->get( $this->ID );

			// exit posterior al grabado
			$this->afterSave( $lv_ret );
		}    
    
    // devuelvo resultado de ejecución
    $this->err =array('errtyp'=>$this->mdl->errtyp,
											'errcod'=>$this->mdl->errcod,
											'errtxt'=>$this->mdl->errtxt,
											'errjva'=>$this->mdl->errjva,
											'errmsg'=>$this->mdl->errmsg,
											'errvar'=>$this->mdl->errvar,
											'errtch'=>$this->mdl->errtch
											);
    return $lv_ret;
  }
  // beforeSave. permite hacer un override para fijar datos antes de que se transfieran al modelo
  function beforeSave( $lp_dat ){ return $lp_dat; }
  // afterSave. permite hacer un override para fijar datos del modelo antes de que se devuelvan los datos
  function afterSave( $lp_ret ){ }
  
  
  
  // BORRAR - borra un documento
  function delete(){
    // verifico que se haya indicado un codigo de modelo
    if( !$this->checkParameter('MODEL') ){ return $this->co_reg->document->getJson( $this->err ); }
        
  	// instancio modelo
    $this->mdl = $this->co_reg->load->model( $this->MODEL );

    // exit previo al borrado
    $lp_dat = $this->beforeDelete( $this->post );
    
    // borro documento
    $lv_ret = $this->mdl->delete( $lp_dat , $this->authCheck );
    $this->err = array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt);
    
    // exit posterior al borrado
    $this->afterDelete( $lv_ret );
    
    // devuelvo JSON
    return $this->co_reg->document->getJson($this->err);
  }
  // beforeDelete. permite hacer un override para fijar datos antes de que se transfieran al modelo
  function beforeDelete( $lp_dat ){ return $lp_dat; }
  // afterDelete. permite hacer un override para fijar datos del modelo antes de que se devuelvan los datos
  function afterDelete( $lp_ret ){ }
	
  // CONTABILIZAR - contabiliza un documento
  function accounting(){
    // verifico que se haya indicado un codigo de modelo
    if( !$this->checkParameter('MODEL') ){ return $this->co_reg->document->getJson( $this->err ); }

    // instancio modelo
    $this->mdl = $this->co_reg->load->model( $this->MODEL );

    // contabilizo documento
    $this->mdl->accounting( $this->post );
    $this->err = array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt);

    // devuelvo JSON
    return $this->co_reg->document->getJson($this->err);
  }
  
  // MODIFICAR - devuelve la vista del documento en modo edición
  function modify(){
    // verifico que se haya indicado un codigo de vista
	  if( !$this->checkParameter('VIEW') && $this->getJson=='' ){ return $this->co_reg->document->getJson( $this->err ); }
    
    // si no se pudo cargar el documento devuelve el error
    if( !$this->loadDocument() ){ return $this->co_reg->document->getJson( $this->err ); }
    
    // devuelve los datos
    $lv_ret = array_merge(array('data'=>$this->mdl,'actcod'=>$this->act), $this->extraRet);
		if( $this->getJson!='' ){
			return $this->co_reg->document->getJson( $lv_ret );
		} else {
			return $this->co_reg->document->getView( $this->VIEW, $lv_ret );
		}
  }
	
  
  
  // VER - devuelve la vista del documento en modo visualización
  function view(){
    // verifico que se haya indicado un codigo de vista
	  if( !$this->checkParameter('VIEW') && $this->getJson=='' ){ return $this->co_reg->document->getJson( $this->err ); }

    // si no se pudo cargar el documento devuelve el error
    if( !$this->loadDocument() ){ return $this->co_reg->document->getJson( $this->err ); }
    
    // devuelve los datos
    $lv_ret = array_merge(array('data'=>$this->mdl,'actcod'=>$this->act), $this->extraRet);
		if( $this->getJson!='' ){
			return $this->co_reg->document->getJson( $lv_ret );
		} else {
			return $this->co_reg->document->getView( $this->VIEW, $lv_ret );
		}
  }
  
  
  
  // COPIAR - devuelve la vista del documento como copia de otro documento
  function copyDocument(){
    // verifico que se haya indicado un codigo de vista
	  if( !$this->checkParameter('VIEW') && $this->getJson=='' ){ return $this->co_reg->document->getJson( $this->err ); }

    // si no se pudo cargar el documento devuelve el error
    if( !$this->loadDocument() ){ return $this->co_reg->document->getJson( $this->err ); }
		
    // agrego campos que deben limpiarse siempre
    $this->preventCopy = array_merge($this->preventCopy, [strtolower($this->ID), 'ctedte', 'cteusr', 'upddte', 'updusr', 'sysdoctrecod', 'sysdocrejcod']);
    // inicializo los valores de los campos que no deben copiarse
    $lv_dat = $this->mdl->getData();
    foreach($lv_dat as $lv_key=>&$lv_val){
      if( is_array($lv_val) ){
        // 2do nivel de profundidad de array
        foreach($lv_val as &$lv_row2){
          if (is_array($lv_row2)) {
            foreach($lv_row2 as $lv_key2=>&$lv_val2){
              if(in_array(strtolower($lv_key2),$this->preventCopy)){ $lv_val2=''; }
            }
            unset($lv_val2);
          }
        }
        unset($lv_row2);
      } else if(in_array(strtolower($lv_key),$this->preventCopy)){ $lv_val=''; }
    }
    unset($lv_val);
    $this->mdl->setData( $lv_dat );

    // exit para quitar mas datos del modelo antes de la copia
    $this->afterCopy();
    
    // devuelve los datos
    $lv_ret = array_merge(array('data'=>$this->mdl,'actcod'=>$this->act), $this->extraRet);
		if( $this->getJson!='' ){
			return $this->co_reg->document->getJson( $lv_ret );
		} else {
			return $this->co_reg->document->getView( $this->VIEW, $lv_ret );
		}
  }
  // afterCopy. permite hacer un override para modificar los datos del modelo antes de que se devuelvan
  function afterCopy(){ }

  
  
  // FUNCIONES ADICIONALES - permite definir funciones especificas adicionales (hay que hacer override)
  function additionalFunctions($lp_action){ }
	
  
  
  // ----------------------------------------------------------------------------------------
  // FUNCIONES PRIVADAS - USO INTERNO
  // ----------------------------------------------------------------------------------------
	
  
  
	// CARGAR DOCUMENTO. carga un documento devolviendo el objeto o FALSE si no se pudo cargar
	private function loadDocument(){
    // verifico que se haya indicado un codigo de modelo
    if( !$this->checkParameter('MODEL') ){ return false; }
    
  	// instancio modelo
    $this->mdl = $this->co_reg->load->model( $this->MODEL );
    
    // prepara datos
    $this->beforeLoad();
    $lp_dat = ( ($this->prm[$this->ID]??'')!='' ? $this->prm : $this->post );
    
    // valida parametro minimo requerido
    if ( ($lp_dat[$this->ID]??'')=='' ) { $this->err = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.$this->ID.'].');	 return false; }
    
    // verifica que el documento se haya cargado correctamente
    if ( $this->mdl->load($lp_dat,$this->authCheck)==false ) {
      $this->err = array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt, 'errtch'=>$this->mdl->errtch);
      return false;	
  	}
    
    // obtengo toda la info de la clase de documento
    if( $this->enable_sysdoccls ){
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->mdl->sysdocclscod) ) ) {
        $this->mdl->sysdoccls = $lo_docclsmdl;
      }
    }
    
    $this->afterLoad();
    
    // devuelve el objeto
    return true;
  }
  function beforeLoad(){ }
  function afterLoad(){ }
  
  
  
	// checkParameter. verifica si un parametro especifico fue inicializado  
  private function checkParameter( $lp_param ){
    if( $this->get( $lp_param )=='' ){
      $this->err = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Variable '.$lp_param.' no inicializada.');
      return false;
    } else {
      return true;
    }
  }  
}
?>