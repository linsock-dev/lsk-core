<?php
final class grldatwrkController extends tmssController {
	const MODEL = 'grldatwrk';
	const VIEW  = 'grldatwrk';
	const ID = 'wrkflwdatcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
      // DISPLAY. devuelve vista en modo modificación, visualización o copia
      case '#03':
				$lo_post = $this->co_reg->request->post;
				
				// load object
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				}
				// DEFINICION. cargo la definicion del workflow
				$lo_syswrkmdl = $this->co_reg->load->model('sysdocwrk');
				$lo_syswrkmdl->load( array('wrkflwcod'=>($lo_post['wrkflwcod']??$this->lo_mdl->wrkflwcod)) );
				$this->lo_mdl->sysdocwrk = $lo_syswrkmdl;
				
				// LOG. cargo log de cambios para el workflow
				/*
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_flt = array('vewfldflt'=> '[~fltrow~]'.$lv_wrkflt.chr(9).'ZZ'.chr(9).' OR '.$lv_stpflt.chr(9).chr(9).chr(9),
                       'vewfldord' => 'dca.ctedte desc, dca.chgdocatrcod desc');
        $lv_log = $lo_docchgmdl->getVariousDetails( $lv_flt );
				*/
				
				// ROLES. cargo los roles del usuario actual
				$lo_usrgrpmdl = $this->co_reg->load->model('syssecusrgrp');
        $lv_prm = array('vewfldflt'=> '[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9));
				$this->lo_mdl->usrgrp = $lo_usrgrpmdl->getList( $lv_prm );
				
				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			
			// LIST. devuelve lista de workflows
			case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dw.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
																			'[~fltrow~]dw.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod001'].chr(9).chr(9).
																			(isset($lo_post['srcobjcod002'])?'[~fltrow~]dw.srcobjcod002'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod002'].chr(9).chr(9):'')
												);
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_rs);
        break;
        
      //CHANGE STATUS. Cambia el estado de un paso y revisa las acciones correspondientes a realizarse. 
      //Tambien revisa en simultaneo el comportamiento del workflow asociado.
      case '#changeStatus':
        $lo_post = $this->co_reg->request->post;
				// load object
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID] ) );
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				}
        $lo_post['wrkflwcod'] = $this->lo_mdl->wrkflwcod;
        $lo_post['data'] = $this->lo_mdl->getData();
        $lv_ret = $this->lo_mdl->releaseStep($lo_post); 
				//var_dump($lv_ret);
        $lo_usrgrpmdl = $this->co_reg->load->model('syssecusrgrp');
        $lv_prm = array('vewfldflt'=> '[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9));
				$this->lo_mdl->usrgrp = $lo_usrgrpmdl->getList( $lv_prm );
        
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
		}
  }
}
?>