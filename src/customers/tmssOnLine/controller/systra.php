<?php
final class systraController extends tmssController {
	const CONTROLLER = 'systra';
	const MODEL = 'systra';
	const VIEW  = 'systra';
	const ID = 'systracod';
  const OBJTYP = 'SYS_TRA';
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				if( $this->lo_mdl->save( $lo_post ) ){
					$this->lo_mdl->load( array('systracod'=>$this->lo_mdl->systracod) );
					$lv_ret= $this->lo_mdl->getData();
					$lv_ret['errtyp']='S';
					$lv_ret['errcod']=0;
					$lv_ret['errtxt']='';
          
          //carga los objetos asignados a la orden
          if( count($this->lo_mdl->traobj)>0 ){
            //modelo de clase de documentos
            $lo_objcls = $this->co_reg->load->model( 'sysobjcls' );
            //modelo de objetos
            $lo_objmdl = $this->co_reg->load->model('sysobj');
            //array de objetos
            $lo_obj = array();
            foreach($this->lo_mdl->traobj as $lv_row){
              $lo_objmdl->load( array('sysobjcod' => $lv_row['sysobjcod']) );
              $lo_objcls->load( array('sysobjclscod' => $lo_objmdl->sysobjclscod) );
              array_push( $lo_obj, array('sysobjcod' => $lo_objmdl->sysobjcod, 'sysobjtxt' => $lo_objmdl->sysobjtxt, 'usrcod' => $lv_row['usrcod'], 'sysobjcls'=>$lo_objcls->sysobjclstxt) );
            }

            $this->lo_mdl->obj = $lo_obj;
          }
          
          if( isset($lo_post['systraflg']) && $lo_post['systraflg'] == 'X' ){
						return $this->co_reg->document->getJson( array('systracod' => $this->lo_mdl->systracod) );            
          } else {
            return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>'03'));
          }
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
        break;
			
			
			
      // NEW. devuelve la vista para crear una nueva OT
      case '#01':
				$this->lo_mdl->create();
        // obtengo grupos de dev
        $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
        $this->lo_mdl->devgrp = $lo_devgrpmdl->getOwnGroups();
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
			
			
			
      // CHANGE - DISPLAY. devuelve la vista con el contenido de la OT
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.']') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $this->lo_mdl->systracod = '';
          $this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
          foreach($this->lo_mdl->traobj as &$lv_row){
            $lv_row['systraobjcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';            
          }
          unset($lv_row);
        }
				
        // obtengo grupos de dev
        if($this->data['actcod'] != '03'){
          $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
          $this->lo_mdl->devgrp = $lo_devgrpmdl->getOwnGroups();
        }
        
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;
			
			
			
      // DELETE. borra una OT
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
				
				
      // RELEASE. libera la orden y sus objetos
      case '#05':
        $lo_post = $this->co_reg->request->post;        
        $this->lo_mdl->release( $lo_post );
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
			
      
      // Editor. devuelve la vista para el editor
      case '#edt':
        $this->lo_mdl->create();
        // obtengo grupos de dev
        $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
        $this->lo_mdl->devgrp = array_column($lo_devgrpmdl->getOwnGroups(), 'sysdevgrptxt', 'sysdevgrpcod');
				return $this->co_reg->document->getView('systraedt',array( 'data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>'01' ));
        break;
      
			
			
      case '#add':
        $lo_post = $this->co_reg->request->post;
        //obtiene los objetos
        $lo_objmdl = $this->co_reg->load->model('sysobj');
        $lv_prm = array('vewfldflt' => '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lv_obj = $lo_objmdl->getList( $lv_prm );
        
        $lv_ret = array('obj' => $lv_obj,
                        'errtyp' => $lo_objmdl->errtyp,
                        'errcod' => $lo_objmdl->errcod,
                        'errtxt' => $lo_objmdl->errtxt);
        return $this->co_reg->document->getJson( $lv_ret );
        break;
		}
  }
}
?>