<?php
final class edustuevlController extends tmssController {
  
	const MODEL = 'edustuevl';						// **************************
	const VIEW  = 'edustuevl';						// **************************
	const ID = 'evlcod';									// **************************
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_mdlvew = $this->co_reg->load->model('grlvew');
		$lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// CONTROL
      case '#ctr':				
				$this->lo_mdl->ctrlst = array();
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'data' 	=> $this->lo_mdl,
												'load'  => $this->co_reg->load,
												'actcod'=> $this->data['actcod'],
												'model' => self::MODEL,
												);
				if ( (isset($lp_prm['vew'])?$lp_prm['vew']:'')=='cal' ) {
					return $this->co_reg->load->view( 'edustuevlctrcal', $lv_prm );		
				} else {
					return $this->co_reg->load->view( 'edustuevlctrlst', $lv_prm );		
				}
				break;
		
			// CONTROL - LIST
      case '#ctrlst':
				$lo_post = $this->co_reg->request->post;
				//$lo_mdlvew->setUserRestrictions( '', array( array('vewfld'=>'e.stucod'),array('vewfld'=>'pd.tchcod') ) );

				$lv_maxrec = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'');
				$lv_fldflt = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
				$lv_prm = array('vewfldflt' =>$lv_fldflt, 'vewmaxrec'=>$lv_maxrec);
				$lo_rs = $this->lo_mdl->getControlList( $lv_prm, array(), $lo_mdlvew );

				// cargo parámetros del módulo
				$lo_mdlprm->load( array('mdlcod'=>'EDU') );
				$lv_clr_aus = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_AUS');
				$lv_clr_evl = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_EVL');
				$lv_clr_pnd = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_PND');
				$lv_clr_lck = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_LCK');
				
				for($i=0;$i<count($lo_rs);$i++){
					if ($lv_clr_lck!='' && $lo_rs[$i]['evlcod']!=null && $lo_rs[$i]['evlrelsts']=='A' ) {
						$lo_rs[$i]['rowclr'] = $lv_clr_lck;
					} else if ($lv_clr_evl!='' && $lo_rs[$i]['evlcod']!=null ) {
						$lo_rs[$i]['rowclr'] = $lv_clr_evl;
					} else if($lv_clr_aus!='' && ($lo_rs[$i]['edustuass']=='-1' || $lo_rs[$i]['edustuass']=='1') ) {
						$lo_rs[$i]['rowclr'] = $lv_clr_aus;
					} else if($lv_clr_pnd!='') {
						$lo_rs[$i]['rowclr'] = $lv_clr_pnd;
					}
				}
				
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_rs) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
				}				
				break;

				
			// LISTAR planificación (calendario)
      case '#ctrlstcal':
				$lo_post = $this->co_reg->request->post;
				if(isset($lo_post['start'])){
					$lv_calstr= date('Y-m-d', strtotime($lo_post['start']));
				} else {
					$lv_calstr = date('Y-m-d', strtotime('first day of this month',time()));
				}
				if(isset($lo_post['end'])){
					$lv_calend= date('Y-m-d', strtotime($lo_post['end']));
				} else {
					$lv_calstr = date('Y-m-d', strtotime('last day of this month',time()));
				}
				
				// Planificacion mes actual				
				//$lo_mdlvew->setUserRestrictions( '', array( array('vewfld'=>'e.stucod'),array('vewfld'=>'pd.tchcod') ) );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]pd.eduplndte'.chr(9).'BT'.chr(9).chr(9).$lv_calstr.chr(9).$lv_calend.chr(9),
												'vewfldord' => ' pd.eduplndte, pd.eduplninbdte, pd.eduplnoutdte ');
				$lo_rs = $this->lo_mdl->getControlList($lv_prm,array(),$lo_mdlvew);
				
				// cargo parámetros del módulo
				$lo_mdlprm->load( array('mdlcod'=>'EDU') );
				$lv_clr_aus = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_AUS');
				$lv_clr_evl = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_EVL');
				$lv_clr_pnd = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_PND');
				$lv_clr_lck = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_LCK');
				
				$lo_data = array();				
				$lv_qtyrs=count($lo_rs);
				for($lv_i=0; $lv_i<$lv_qtyrs; ++$lv_i) {
					$lv_data = array();
					$lv_dtestr = $lo_rs[$lv_i]['eduplninbdte'];
					$lv_dteend = $lo_rs[$lv_i]['eduplnoutdte'];
					$lv_data['title'] = $lo_rs[$lv_i]['edusubtxt'];
					$lv_data['color'] = '';
					if ( $lo_rs[$lv_i]['evlcod']!=0 ) {
						if ($lv_clr_lck!='' && $lo_rs[$lv_i]['evlrelsts']=='A' ) { 
							$lv_data['color'] = $lv_clr_lck; 
						} else if ( $lv_clr_evl!='' ) { 
							$lv_data['color'] = $lv_clr_evl; 
						}
						$lv_data['editable'] = false;
					} else if ( $lo_rs[$lv_i]['edustuass']!=0 ) {
						if ( $lv_clr_aus!='' ) { $lv_data['color'] = $lv_clr_aus; }
						$lv_data['editable'] = false;
					} else {
						if ( $lv_clr_pnd!='' ) { $lv_data['color'] = $lv_clr_pnd; }
						$lv_data['editable'] = true;
					}
					if($lv_data['color']==''){ $lv_data['color']='#FFFFFF'; }
					$lv_data['textColor']  = $this->color_inverse( $lv_data['color'] );
					$lv_data['eduplncod'] = $lo_rs[$lv_i]['eduplncod'];
					$lv_data['eduplndtecod'] = $lo_rs[$lv_i]['eduplndtecod'];
					$lv_data['stucod'] = $lo_rs[$lv_i]['stucod'];
					$lv_data['evlcod'] = $lo_rs[$lv_i]['evlcod'];
					$lv_data['eduevlfrm'] = $lo_rs[$lv_i]['eduevlfrm'];
					$lv_data['start'] = $lv_dtestr->format('Y-m-d\TH:i:s');
					$lv_data['end'] = $lv_dteend->format('Y-m-d\TH:i:s'); 
					if ($lv_dtestr->format('H:i')=='00:00' && $lv_dteend->format('H:i')=='00:00') { $lv_data['allDay']='true'; }
					$lo_data[] = $lv_data;
				}
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_data) );
				
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					var_dump($lo_data);
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ';
					//return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
				}
        break;
			
				
			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':        
        if ( $this->lo_mdl->save() ) {
					$this->lo_mdl->load( array(	'evlcod'=>$this->lo_mdl->evlcod	) );				// ********************
					return $this->getView();
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        } 
        break;

      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->getView();
				break;
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( isset($lp_prm[self::ID]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID] );																		// ********************
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID] );										// ********************
				}

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return '<errcod>-1</errcod><errtxt>No se indico parametro ['.self::ID.'].</errtxt>';

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->evlcod = '';																										// ********************
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->getView();
        break;

			// DELETE
      case '#04':
        if ( $this->lo_mdl->delete() ) {
					return '<errcod></errcod><errtxt></errtxt>';
        } else {
          return '<errcod>'.$this->lo_mdl->errcod.'</errcod><errtxt>'.$this->lo_mdl->errtxt.'</errtxt>';
        }
        break;
				
    }

  }
	
	
	/**
	 * getView
	 * send screen to client browser
	 */
	private function getView() {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' 	=> $this->co_reg->sec,
										'doc' => $this->co_reg->document,
										'data' 	=> $this->lo_mdl,
										'load'  => $this->co_reg->load,
										'actcod'=> $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );		
		return $lv_ret;
	}
	
	function color_inverse($color){
    $color = str_replace('#', '', $color);
		$lv_r = hexdec(substr($color,0,2));
		$lv_g = hexdec(substr($color,2,2));
		$lv_b = hexdec(substr($color,4,2));
		$lv_color2 = '#'.($lv_r<200?'FF':'00').($lv_g<200?'FF':'00').($lv_b<200?'FF':'00');
		return $lv_color2;
	}	
}
?>