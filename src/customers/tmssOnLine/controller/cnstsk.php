<?php
final class cnstskController extends tmssController {
	const CONTROLLER = 'cnstsk';
	const MODEL = 'cnstsk';
	const VIEW  = 'cnstsk';
	const ID = 'cnstskcod';
	const OBJTYP ='CNS_TSK';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // control de sesion
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
 
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
        
      //COMPONENT. obtiene el nombre del solicitado
      case '#comp':
        $lo_post = $this->co_reg->request->post;
        $lo_srcmdl=$this->co_reg->load->model($lo_post['srcobjtyp']);
        $lo_srcmdl->load( array($lo_post['id'].'cod'=>$lo_post['srcobjcod001']) );
        return $this->co_reg->document->getJson(array('errtyp'=>$lo_srcmdl->errtyp,
                                                      'errcod'=>$lo_srcmdl->errcod,
                                                      'errtxt'=>$lo_srcmdl->errtxt,
                                                      'name'=>$lo_srcmdl->{$lo_post['id'].($lo_post['id'] == 'vhc' ?'codext':'txt')},
                                                     	'posicion'=>$lo_post['posicion'] ));
        
        break;

			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
      
      // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
       
         // PREPARO JSON DE RIESGOS Y CONTROLES      
        $lv_rsk = $lo_post['cnstsksrsk'] ?? '[]';
        $lv_ctr = $lo_post['cnstsksctr'] ?? '[]';

        // mando al post los valores combinados
       $lv_all = $lo_post['cnstskrskctr'] ?? '[]';
			 $lo_post['cnstskrskctr'] = $lv_all;

				// grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
          //grabo los componentes
          $lo_tskmatmdl = $this->co_reg->load->model('cnstskmat');
          $lv_tskmat = $lo_post['cnstskmat'];
					if ($lv_tskmat!='') {
						$lv_tskmat = html_entity_decode($lv_tskmat);
						$lv_tskmat_arr = json_decode($lv_tskmat,true);
            foreach($lv_tskmat_arr as $lv_row){
              $lv_row['cnstskcod'] = $this->lo_mdl->cnstskcod;
							$lv_row['docsts'] = 'A';                
              if ( isset($lv_row['deleted']) ) {
                if ($lo_tskmatmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_tskmatmdl->errtyp,'errcod'=>$lo_tskmatmdl->errcod,'errtxt'=>$lo_tskmatmdl->errtxt));
                }
              } else if ($lo_tskmatmdl->save($lv_row)==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$lo_tskmatmdl->errtyp,'errcod'=>$lo_tskmatmdl->errcod,'errtxt'=>$lo_tskmatmdl->errtxt));
              } 
            }
          }
          
        	//carga el documento
          $this->lo_mdl->load( array('cnstskcod'=>$this->lo_mdl->cnstskcod) );
          
          //carga clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
          
					// muestro vista
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        } else {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;

				$this->lo_mdl->create();
				
        /* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
        $lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          //vacia el codigo de la tarea
          $this->lo_mdl->cnstskcod = '';
          //vacia el codigo de componente 
          $lv_dat = $this->lo_mdl->cnstskmat; 
					for($i=0; $i<count($lv_dat); $i++){
						$lv_dat[$i]['cnstskmatcod']='';	
					} 
					$this->lo_mdl->cnstskmat = $lv_dat;
          //vacia los datos de creacion
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
        $this->lo_mdl->sysdoccls = $lo_docclsmdl;

				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;


			// DELETE. borra un objeto
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
			
      // LIST by TEXT. devuelve lista de documentos segun texto
      case '#17': case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['cnstsktxt'])?'[~fltrow~]t.cnstsktxt'.chr(9).''.chr(9).$lp_prm['cnstsktxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['cnstskcodext'])?'[~fltrow~]t.cnstskcodext'.chr(9).'='.chr(9).chr(9).$lp_prm['cnstskcodext'].chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
				break;
			
			
			// GET COMP. devuelve los componentes de una tarea
			case '#getComp':
				$lo_post = $this->co_reg->request->post;
        $lv_ret = $lo_post;
        $lv_ret['cnstskmat'] = $this->lo_mdl->getComponents( array('cnstskcod'=>$lo_post['cnstskcod']) );
				return $this->co_reg->document->getJson( $lv_ret );
				break;
        
        // RSK CTR. devuelve riesgos y controles de una tarea
        case '#getRskCtr':
            $lo_post = $this->co_reg->request->post;
            $lo_data = [];

            if ($this->lo_mdl->load(['cnstskcod' => $lo_post['cnstskcod']])) {
                $lo_data = array(
                    'cnstskrsk' => $this->lo_mdl->cnstskrsk,
                    'cnstskctr' => $this->lo_mdl->cnstskctr
                );
            }

            return $this->co_reg->document->getJson(array('data' => $lo_data));
        break;
    }
  }
  
}
?>