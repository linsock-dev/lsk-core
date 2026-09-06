<?php
final class tsrbnktjtController extends tmssController {
  const CONTROLLER = 'tsrbnktjt';
	const MODEL = 'grldatbnk';
	const VIEW  = 'tsrbnktjt';
	const ID = 'bnknum';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
  
  // INDEX. método principal  
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL);
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. lista los documentos
      case '#': case '#08':		
				// getlist de las vias de pago para sacar paymthcod
       $lo_mdlpaymthcod=$this->co_reg->load->model('tsrpaymth');
       $lv_prm= array('vewmaxrec' =>'1',
                      'vewfldflt' =>'[~fltrow~]paymthcodext'.chr(9).'='.chr(9).chr(9).'TJT'.chr(9).chr(9));
				$lo_rs =$lo_mdlpaymthcod->getList($lv_prm);
        $lv_prm=array();
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model']=self::MODEL;
        $lp_prm['controller']=self::CONTROLLER;
        $lp_prm['view']=self::VIEW;
       	$lp_prm['vewfldflt']= '[~fltrow~]b.bnksrctyp'.chr(9).'='.chr(9).chr(9).'ADM_BUS'.chr(9).chr(9).
          										'[~fltrow~]b.buscod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9).
          										'[~fltrow~]tp.paymthcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['paymthcod'].chr(9).chr(9); 
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE. guarda un documento
        case '#00':
					$lo_post = $this->co_reg->request->post;
					// si es una creación determino el paymthcod para el nuevo registro
					if($lo_post['paymthcod']==''  ){						
            $lo_mdlpaymthcod=$this->co_reg->load->model('tsrpaymth');
       			$lp_prm= array('vewmaxrec' =>'1',
            							 'vewfldflt' =>'[~fltrow~]paymthcodext'.chr(9).'='.chr(9).chr(9).'TJT'.chr(9).chr(9));
						$lo_rs =$lo_mdlpaymthcod->getList($lp_prm);
						$lo_post['paymthcod'] =$lo_rs[0]['paymthcod'];
					}
        
        // si es una creación determino el ID para el nuevo registro
					if($lo_post['bnksrccod']==''){						
						// getlist de las tarjetas ordenadas por bnksrccod desc (tomo solo 1 registro)
       			$lp_prm= array('vewmaxrec' =>'1',
            							 'vewfldflt' =>'[~fltrow~]b.bnksrctyp'.chr(9).'='.chr(9).chr(9).'ADM_BUS'.chr(9).chr(9).
          															 '[~fltrow~]b.bnksrccod'.chr(9).''.chr(9).chr(9).$this->co_reg->sec->buscod.'_'.chr(9).chr(9).
                                         '[~fltrow~]tp.paymthcod'.chr(9).'='.chr(9).chr(9).$lo_post['paymthcod'].chr(9).chr(9).
                                         '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                           'vewfldord' => 'b.bnksrccod desc');
						$lo_rs = $this->lo_mdl->getList($lp_prm);
						if(count($lo_rs)==0){
							$lv_id = str_pad(1,4,'0',STR_PAD_LEFT);
						} else {
              $lv_id = explode("_", $lo_rs[0]['bnksrccod']);
							$lv_id = str_pad(intval($lv_id[2])+1,4,0,STR_PAD_LEFT);
						}
						$lo_post['bnksrccod'] = $this->co_reg->sec->buscod.'_'.$lv_id;
					}
        $lo_post['bnktjtenddte'] = '01/'. $lo_post['bnktjtenddte'];
        	if ( $this->lo_mdl->save($lo_post) ) {
						$this->lo_mdl->load03( array(	'bnknum'=>$this->lo_mdl->bnknum	));
						return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        	} else {
						return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        	} 
        	break;
				
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl ,'actcod'=>$this->data['actcod']) );
				break;
				
				 // CHANGE - DISPLAY - COPY
        case '#02': case '#03': case '#001':									
       	$lv_key = array();
				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load03($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          $this->lo_mdl->bnknum = '';
          $this->lo_mdl->bnksrccod='';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

      // DELETE
      case '#04':
        $this->lo_mdl->delete( array('bnknum'=>$this->co_reg->request->post['bnknum'],'bnksrctyp'=>$this->co_reg->request->post['bnksrctyp'],'bnksrccod'=>$this->co_reg->request->post['bnksrccod']));
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;

			// LIST by TEXT
      case '#17':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['finacctxt']) 	 ?'[~fltrow~]a.finacctxt'.chr(9).''.chr(9).utf8_decode($lp_prm['finacctxt']).chr(9).chr(9).chr(9):'').
																			 (isset($lp_prm['finaccclscod'])?'[~fltrow~]a.finaccclscod'.chr(9).'='.chr(9).chr(9).$lp_prm['finaccclscod'].chr(9).chr(9):'').
																			'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>