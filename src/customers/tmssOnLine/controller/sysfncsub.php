<?php
final class sysfncsubController extends tmssController {
	const MODEL = 'sysfncsub';
	const VIEW  = 'sysfncsub';
	const ID = '';
  protected $co_reg;
	protected $co_usr;
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
    
			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;		
		
      // SAVE
      case '#00':
        $lo_post = $this->co_reg->request->post;
				$lv_buffer = $this->co_reg->request->post['fnccus'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_fncsub_arr = json_decode($lv_buffer,true);
					foreach( $lv_fncsub_arr as $lv_row ) {
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
							return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
						}
					}
				}

        // cargo datos de funcionalidad
        $lo_fncmdl = $this->co_reg->load->model('sysfnc');
        $lo_fncmdl->load( array('sysfnccod'=>$this->co_reg->request->post['sysfnccod']) );	

        if ( $lo_fncmdl->sysfnccod!='' ) {
          // clientes suscriptos
          $lv_prm = array('vewfldflt' =>'[~fltrow~]s.sysfnccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['sysfnccod'].chr(9).chr(9));
          $lo_fnccus_rs = $this->lo_mdl->getList( $lv_prm );
        }
        $this->lo_mdl->fnccus = $lo_fnccus_rs;
        $this->lo_mdl->sysfnc = $lo_fncmdl;
      	$this->data['actcod'] = '02';
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;

        
      // CHANGE - DISPLAY
      case '#02': case '#03':
        // cargo datos de funcionalidad
        $lo_fncmdl = $this->co_reg->load->model('sysfnc');
        $lo_fncmdl->load( array('sysfnccod'=>$this->co_reg->request->post['sysfnccod']) );	

        if ( $lo_fncmdl->sysfnccod!='' ) {
          // clientes suscriptos
          $lv_prm = array('vewfldflt' =>'[~fltrow~]s.sysfnccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['sysfnccod'].chr(9).chr(9));
          $lo_fnccus_rs = $this->lo_mdl->getList( $lv_prm );
        }

        $this->lo_mdl->fnccus = $lo_fnccus_rs;
        $this->lo_mdl->sysfnc = $lo_fncmdl;
				return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;
        
        
			// SHOP
      case '#18':
				// cargo la lista de todas las funcionalidades y solo aquellas específicas del clientes
				$lo_fncmdl = $this->co_reg->load->model('sysfnc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>' dbo.getTagValue(^sysfncgrp^, f.sysfncatrval001), m.objord' );
				$lo_fnc_rs = $lo_fncmdl->getList( $lv_prm );
				
				// debería quitar las suscripciones de clientes que no sean de este cliente
				// cargo la lista de suscripciones
				$lo_fncsubmdl = $this->co_reg->load->model('sysfncsub');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cuscodext'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_fnccus_rs = $this->lo_mdl->getList( $lv_prm );
        return $this->co_reg->document->getView('sysfncsubshp',array('data'=>$this->lo_mdl,'fnclst'=>$lo_fnc_rs,'fnccus'=>$lo_fnccus_rs,'model'=>self::MODEL,'actcod'=>$this->data['actcod']));
        break;
    }
  }
}
?>