<?php
final class zcuemaController extends tmssController { 
	const MODEL = 'zcuema';
	const VIEW  = 'zcuema';
	const ID = '';
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

		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act; 
    switch( $lp_act ) {
			
			
			// FORMULARIO CERTIFICACION
		case '#evtfrmcrt':
				$lo_post = $this->co_reg->request->post;
				$this->data['actcod'] = (isset($lo_post['actcod'])?$lo_post['actcod']:'');
        $lo_evtmdl = $this->co_reg->load->model( 'cnssteevt' );
				$lo_evtmdl->create();
        
        if((isset($lo_post['steevtdoccod'])?$lo_post['steevtdoccod']:'')!=''){
					$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.steevtdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtdoccod'].chr(9).chr(9));
					$lo_rs2 = $lo_docmdl->getList( $lv_prm );
          
          if( $this->data['actcod'] == '001' ) {
						$lo_rs2[0]['steevtcod'] = '';
        		$lo_rs2[0]['steevtdoccod'] = '';
					}
          
        	$lo_evtmdl->evtdoc = $lo_rs2;
       	}
			
        switch($lp_act){					
          case '#evtfrmcrt':
              //cargo el documento
            $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
            $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.srcobjtxt'.chr(9).'='.chr(9).chr(9).'CERTIFICACION'.chr(9).chr(9).
                                            '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT_FRM'.chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_post['steevtdte']).chr(9).chr(9).
                                            '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtcod'].chr(9).chr(9).
                                            '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
            $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
            $lo_evtmdl->cnssteevtdoc=$lo_rs;
            return $this->co_reg->document->getView( 'zcuema_evtfrmcrt', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;   
					}
				break;
        
			//CONTRATO PRD / CRT
      case '#slslstprccod':
        $lo_post = $this->co_reg->request->post;
        $lo_cnsstemdl = $this->co_reg->load->model( 'cnsste' );
        $lo_slssvcmdl = $this->co_reg->load->model( 'slssvc' );
				//añadir validaciones
        if($lo_cnsstemdl->load( array('stecod'=>$lo_post['stecod']),false )==false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_cnsstemdl->errtyp,'errcod'=>$lo_cnsstemdl->errcod,'errtxt'=>$lo_cnsstemdl->errtxt) );
        }
        $lv_cnsstestr=$lo_cnsstemdl->cnssteatr;
        $lv_slssvccodext=$this->co_reg->document->getTagValue( $lv_cnsstestr, 'ATR_NCT');
        if($lv_slssvccodext==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'LA OBRA NO TIENE CONTRATO ASOCIADO') );
        }
        //recupero contrato con codigo externo
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => '[~fltrow~]o.slssvccodext'.chr(9).'='.chr(9).chr(9).$lv_slssvccodext.chr(9).chr(9).
																			'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_slssvcdat = $lo_slssvcmdl->getList($lv_prm, null, null, false);
        if(count($lo_slssvcdat)==0){ 
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_slssvcmdl->errcod,'errtxt'=>'ID DE CONTRATO INVALIDO. ') );
        }
        if(count($lo_slssvcdat)>1){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_slssvcmdl->errcod,'errtxt'=>'SE ENCONTRO MAS DE UN CONTRATO CON ESE CODIGO DE CONTRATO ASOCIADO A LA OBRA. ') );
        }
        //recuper codigo de lista de precio
        $lv_slsprclstcod=$lo_slssvcdat[0]['slsprclstcod'];
        if($lv_slsprclstcod==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'EL CONTRATO NO TIENE LISTA DE PRECIOS ASOCIADA') );
        }
        //recupero coef de incremento
        $lv_slsprcancvar=$this->co_reg->document->getTagValue( $lo_slssvcdat[0]['slssvcatr'], 'atr_ancvar' );
        if($lv_slsprcancvar==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'EL CONTRATO NO TIENE DEFINIDO EL COEF') );
        }
        return $this->co_reg->document->getJson(array('slsprclstcod'=>$lv_slsprclstcod,'slsprcancvar'=>$lv_slsprcancvar));
        break;
        
        
      	//IMPRESION DE CERTIFICACION
       case '#evtfrmcrtpnt':            
				$lo_post = $this->co_reg->request->post;
				$lv_evtcod = (isset($lo_post['steevtcod'])?$lo_post['steevtcod']:$lp_prm['steevtcod']);
				// EVENTO. cargo el evento de certificacion
				$lo_evtmdl = $this->co_reg->load->model('cnssteevt');
				$lo_evtmdl->load( array('steevtcod'=>$lv_evtcod), false );
        
        //DOCUMENTO. cargo documento del formulario del evento
        $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
            $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.srcobjtxt'.chr(9).'='.chr(9).chr(9).'CERTIFICACION'.chr(9).chr(9).
                                            '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT_FRM'.chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_evtmdl->steevtdte->format('d/m/Y')).chr(9).chr(9).
                                            '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lv_evtcod.chr(9).chr(9).
                                            '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
        $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
        $lo_evtmdl->cnssteevtdoc=$lo_rs;
				
				// OBRA. cargo datos de la obra
				$lo_stemdl = $this->co_reg->load->model('cnsste');
				$lo_stemdl->load( array('stecod'=>$lo_evtmdl->stecod), false );
        
        // CONTRATO. cargo datos de la obra
        $lv_steatr=$lo_stemdl->cnssteatr;
        $lv_slssvccodext=$this->co_reg->document->getTagValue( $lv_steatr, 'ATR_NCT');
        $lo_stemdl->slssvccodext=$lv_slssvccodext;
        
        // CONTACTOS de las obras
        $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_evtmdl->stecod.chr(9).chr(9).
																			'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). 'CNS_STE' .chr(9).chr(9).
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_stemdl->stecnt = $lo_cntmdl->getList( $lv_prm, null, null, false );

        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
        if($lp_act=='#evtfrmcrtpnt'){
        	$lv_buffer = $this->co_reg->document->getView( 'zcuema_evtfrmcrtpnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
        }
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
        break;
       
    case '#stkmovdet':
        // obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lo_matstk = $this->co_reg->load->model('stkmatstk');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stkmovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
        $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' => $lo_stkdocmdl,
                      'actcod' => $this->data['actcod'],
                      'model' => self::MODEL
                      );
					$lv_buffer = 	$this->co_reg->load->view('zcuema_stkmovdocprn', $lv_prm);
					$this->co_reg->response->addHeader('Content-type:application/pdf'); 
					return $lv_buffer;
        break;
        
		}	
  }
}
?>