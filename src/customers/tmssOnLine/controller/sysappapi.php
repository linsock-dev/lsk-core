<?php
final class sysappapiController extends tmssController {
	const MODEL = 'sysappapi';	
	const VIEW  = 'sysappapi';	
	const ID = 'sysappapicod';	
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }  
  
	
  // Index - Método principal     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. Lista
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. Graba un objeto
      case '#00':
        $lo_post = $this->co_reg->request->post;
        
        if ( $this->lo_mdl->save() ) {
          
          // grabo mapeo de apis
					$lo_sysappapimapmdl = $this->co_reg->load->model('sysappapimap');
					$lv_buffer = $lo_post['sysappapimap'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_sysappapimap_arr = json_decode($lv_buffer,true);
            foreach($lv_sysappapimap_arr as $lv_row){
              $lv_row['sysappapicod'] = $this->lo_mdl->sysappapicod;
              $lv_row['docsts'] = 'A';
              
              if(isset($lv_row['sysappapimapfldmap'])){
                if(is_array($lv_row['sysappapimapfldmap'])){
                  $lv_row['sysappapimapfldmap'] = json_encode($lv_row['sysappapimapfldmap']);
                }else{
                  $lv_row['sysappapimapfldmap'] = substr($lv_row['sysappapimapfldmap'],1 ,-1);
                }
              }
              
              if (isset($lv_row['deleted'])) {
                if ($lo_sysappapimapmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysappapimapmdl->errtyp,'errcod'=>$lo_sysappapimapmdl->errcod,'errtxt'=>$lo_sysappapimapmdl->errtxt));
                }
              } else if ($lo_sysappapimapmdl->save($lv_row)==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_sysappapimapmdl->errtyp,'errcod'=>$lo_sysappapimapmdl->errcod,'errtxt'=>$lo_sysappapimapmdl->errtxt));
              }
            }
          }
          
          
					$this->lo_mdl->load( array(	'sysappapicod'=>$this->lo_mdl->sysappapicod	) );
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
			
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $lo_data=	$this->lo_mdl->apimap; 
          foreach($lo_data as &$lo_row){
          	$lo_row['sysappapimapcod']='';
            $lo_row['sysappapicod']='';
          	$lv_row['ctedte'] = '';
          	$lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lo_row);
          $this->lo_mdl->apimap = $lo_data;
					$this->lo_mdl->sysappapicod = '';
          $this->lo_mdl->sysappapiver = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}   	
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// GETLIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['sysappapitxt'])?'[~fltrow~]a.sysappapitxt'.chr(9).''.chr(9).utf8_decode($lp_prm['sysappapitxt']).chr(9).chr(9).chr(9):'').
                                      	(isset($lp_prm['sysappapiurl'])?'[~fltrow~]a.sysappapiurl'.chr(9).''.chr(9).utf8_decode($lp_prm['sysappapiurl']).chr(9).chr(9).chr(9):'').							
                                        '[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
       
       
      // GETLIST de todas las apis
      case '#getApis':
				$lv_prm = array('vewmaxrec' =>'999',
												'vewfldflt' => '[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
        
    	// POP UP Mapeo de campos
      case '#fldmap':
        $lo_post = $this->co_reg->request->post;
        $this->lo_mdl->apifldmap = (isset($lo_post['sysappapimapfldmap']) && $lo_post['sysappapimapfldmap'] != '' ? is_array($lo_post['sysappapimapfldmap']) ? json_encode($lo_post['sysappapimapfldmap']) : substr(html_entity_decode($lo_post['sysappapimapfldmap']), 1, -1) : '');
        //$this->lo_mdl->apifldmap = (isset($lo_post['sysappapimapfldmap']) ? $lo_post['sysappapimapfldmap'] : '');

				//modo solo lectura
        $this->lo_mdl->readonly = (($lo_post['readonly']??false)=='true'?true:false);
        
        // mostrar detalles técnicos
        $this->lo_mdl->showtech = (($lo_post['showtech']??false)=='true'?true:false); 
        
        //devuelve la vista del dialogo de escala de precios
        return $this->co_reg->document->getView( 'sysappapimap', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
    }
  }
  
  /*
  	GET RESOURCE. devuelve todos los datos de un recurso
    RECIBE: 
    	- string $lp_res = nombre del recurso (por ejemplo: sales-order)
    DEVUELVE:
    	- array (
        - string prg = controlador (ej: slsord)
        - string mdlcod = código de módulo (ej: SLS)
        - string prgcod = código de programa (ej: ORD)
        - string doccod = nombre de código interno de documento (ej: slsordcod)
        - string tab_title = título de la nueva tab (ej: Pedidos)
        - string vewcod = nombre de la vista (ej: VEW_SLS_ORD)
      )
  */
  public function getResource($lp_res){
    // cargo API
    $lo_apimdl = $this->co_reg->load->model('sysappapi');
    $lv_prm=array('vewfldflt' => 	'[~fltrow~]a.sysappapicodext'.chr(9).'='.chr(9).chr(9).$lp_res.chr(9).chr(9).
                                  '[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
    $lo_apirs = $lo_apimdl->getList($lv_prm);
    
    if(count($lo_apirs)<1){
      return array('errtyp'=>'E','errcod'=>404,'errtxt'=>'Recurso no encontrado.');
    }
    
    // cargo método LOAD de API para obtener el nombre del campo con el código interno
    $lo_apimapmdl = $this->co_reg->load->model('sysappapimap');
    $lv_prm=array('vewfldflt' => 	'[~fltrow~]m.sysappapicod'.chr(9).'='.chr(9).chr(9).$lo_apirs[0]['sysappapicod'].chr(9).chr(9).
                  								'[~fltrow~]m.sysappapimapmdlmth'.chr(9).'='.chr(9).chr(9).'LOAD'.chr(9).chr(9).
                                  '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
    $lo_apimaprs = $lo_apimapmdl->getList($lv_prm);
    $lv_mdlcod = explode('_', $lo_apirs[0]['sysappapiurl'])[0];
    $lv_prgcod = explode('_', $lo_apirs[0]['sysappapiurl'])[1];
    
    if(count($lo_apimaprs)<1){
      return array('errtyp'=>'E','errcod'=>-2,'errtxt'=>'Configuraci&oacute;n de la API insuficiente.');
    }
    
    $lo_prgmdl = $this->co_reg->load->model('sysappprg');
    $lv_prm=array('vewfldflt' => 	'[~fltrow~]p.codmdl'.chr(9).'='.chr(9).chr(9).$lv_mdlcod.chr(9).chr(9).
                  								'[~fltrow~]p.codprg'.chr(9).'='.chr(9).chr(9).$lv_prgcod.chr(9).chr(9));
    $lo_prgrs = $lo_prgmdl->getList($lv_prm);
    $lv_prgtxt = $lo_prgrs[0]['prgtxt'];
    
    return array('prg'=>$lo_apimaprs[0]['sysappapimapmdl'], 
                 'mdlcod'=>$lv_mdlcod, 
                 'prgcod'=>$lv_prgcod, 
                 'doccod'=>$lo_apimaprs[0]['sysappapimapfldcod'],
                 'tab_title'=>$this->co_reg->language->$lv_prgtxt,
                 'vewcod'=>$lo_prgrs[0]['vewcod'],
                 'prgfrm'=>$lo_prgrs[0]['prgfrm']
                ); 
  }
  public function getApiResource($lp_mdlcod,$lp_prgcod){
    $this->lo_mdl = $this->co_reg->load->model( self::MODEL );
    // GETLIST by TEXT. devuelve la lista según un texto
    $lv_prm=array('vewfldflt' => 	'[~fltrow~]a.sysappapiurl'.chr(9).'='.chr(9).chr(9).strtoupper($lp_mdlcod.'_'.$lp_prgcod).chr(9).chr(9));
    $lv_rs= $this->lo_mdl->getList( $lv_prm );		
   	return $lv_rs; 		
  }
}
?>