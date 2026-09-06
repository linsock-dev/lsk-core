<?php
final class educurplnController extends tmssController {
	const MODEL = 'educurpln';
	const VIEW  = 'educurpln';
	const ID = 'educurplncod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
  // main method     
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
        $lp_prm['vewfldgrp'] = ($lp_prm['vewcod']=='VEW_EDU_CUR_LST')?'c.educurcod, c.educurtxt, c.docsts':
															(($lp_prm['vewcod']=='VEW_EDU_CUR_CAR')?'a.educartxt, a.educarcod, a.docsts':
															(($lp_prm['vewcod']=='VEW_EDU_CUR_COU')?'o.educoutxt, o.educoucod, o.docsts':
															(($lp_prm['vewcod']=='VEW_EDU_CUR_SUB')?'s.edusubtxt, s.edusubcod, s.docsts, cp.educurplncod':
															'error')));
        return $lo_vew->index( '00', $lp_prm );
        break;
        
      // LIST CONTENT by TEXT. Contenido de lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
                       	'vewfldflt' =>
                        							(isset($lp_prm['educurplncod'])?'[~fltrow~]cp.educurplncod'.chr(9).'='.chr(9).chr(9).$lp_prm['educurplncod'].chr(9).chr(9):'').
                        							(isset($lp_prm['educurcod'])?'[~fltrow~]c.educurcod'.chr(9).'='.chr(9).chr(9).$lp_prm['educurcod'].chr(9).chr(9):'').
                        							(isset($lp_prm['educurtxt'])?'[~fltrow~]c.educurtxt'.chr(9).''.chr(9).$lp_prm['educurtxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['educurtxt'])?'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9):''). 
                        
																			(isset($lp_prm['educarcod'])?'[~fltrow~]a.educarcod'.chr(9).'='.chr(9).chr(9).$lp_prm['educarcod'].chr(9).chr(9):'').
																			(isset($lp_prm['educartxt'])?'[~fltrow~]a.educartxt'.chr(9).''.chr(9).$lp_prm['educartxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['educartxt'])?'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9):'').
                        
																			(isset($lp_prm['educoucod'])?'[~fltrow~]o.educoucod'.chr(9).'='.chr(9).chr(9).$lp_prm['educoucod'].chr(9).chr(9):'').
																			(isset($lp_prm['educoutxt'])?'[~fltrow~]o.educoutxt'.chr(9).''.chr(9).$lp_prm['educoutxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['educoutxt'])?'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9):'').
                        
																			(isset($lp_prm['edusubcod'])?'[~fltrow~]s.edusubcod'.chr(9).'='.chr(9).chr(9).$lp_prm['edusubcod'].chr(9).chr(9):'').
																			(isset($lp_prm['edusubtxt'])?'[~fltrow~]s.edusubtxt'.chr(9).''.chr(9).$lp_prm['edusubtxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['edusubtxt'])?'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9):''),
                        
                        'vewfldgrp' =>(isset($lp_prm['educurtxt'])?'c.educurcod, c.educurtxt, c.docsts':
																			(isset($lp_prm['educartxt'])?'c.educurcod, a.educartxt, a.educarcod, a.docsts':
																			(isset($lp_prm['educoutxt'])?'c.educurcod, a.educarcod, o.educoutxt, o.educoucod, o.docsts':
																			(isset($lp_prm['edusubtxt'])?'c.educurcod, a.educarcod, o.educoucod, s.edusubtxt, s.edusubcod, s.docsts, cp.educurplncod':
																			'error'))))
                       );
        $lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>