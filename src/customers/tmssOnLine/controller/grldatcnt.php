<?php
final class grldatcntController extends tmssController {
	const CONTROLLER = 'grldatcnt';
	const MODEL = 'grldatcnt';
	const VIEW  = 'grldatcnt';
	const ID = 'cntcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	private $data_list = array();
  
  function __construct(&$lp_reg) {$this->co_reg = $lp_reg;}
  
	
  //INDEX. metodo principal
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$lo_post = $this->co_reg->request->post;
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$this->data['cntsrctyp'] = ($lp_prm['cntsrctyp']??($lo_post['cntsrctyp']??''));
		$this->data['cntsrccod'] = ($lp_prm['cntsrccod']??($lo_post['cntsrccod']??''));
		$this->data['bcksec'] = ($lp_prm['bcksec']??($lo_post['bcksec']??''));
		$this->data['popup'] = ($lp_prm['popup']??($lo_post['popup']??''));
		$this->data['fndtxt'] = ($lp_prm['fndtxt']??($lo_post['fndtxt']??''));
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
        
      // LIST. Lista estándar (vista grlvew)
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        if($this->data['cntsrctyp']){
					$lp_prm['cntsrctyp'] = $this->data['cntsrctyp'];
        }
        return $lo_vew->index( '00', $lp_prm );
        break;
      
        
      // LIST. devuelve el formulario con lista de contactos (lista formulario como JSON)
      case '#09':
      	$lv_flt = array('vewfldflt' => '[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$this->data['cntsrctyp'].chr(9).chr(9).
																			 '[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$this->data['cntsrccod'].chr(9).chr(9).
																				(isset($lp_prm['invadr'])?'[~fltrow~]dbo.getTagValue(^invadr^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9):'').
                        								($this->data['fndtxt']==''?'':'[~fltrow~]c.cnttxt'.chr(9).''.chr(9).$this->data['fndtxt'].chr(9).chr(9).chr(9))
												);
				$lv_prm = array('cntsrctyp'=>$this->data['cntsrctyp']);
				$lv_arr_dat = $this->lo_mdl->getList( $lv_flt, $lv_prm, null, false );
        return $this->co_reg->document->getJson( array('data'=>$this->data,'list'=>$lv_arr_dat,'actcod'=>$this->data['actcod'] ) );
        break;
        
			
      // SAVE. graba el documento
      case '#00':
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save($lo_post) ) {
          
          // cargo documento
					$this->lo_mdl->load( array(	'cntcod'=>$this->lo_mdl->cntcod, 'cntsrctyp' => $lp_prm['cntsrctyp']??$lo_post['cntsrctyp']	) );
          
          // grabo textos
					$lo_grltxtmdl = $this->co_reg->load->model('grldattxt');
					foreach($lo_post as $lv_key=>$lv_val) {   
						if ( substr($lv_key,0,13)=='grldattxt_txt') {
							$lv_typcod = str_ireplace('grldattxt_txt','',$lv_key);
              // si existe un texto, se graba o modifica
              if($lv_val != ''){  
                $lv_dat = array();
                $lv_dat['txtcod'] = $lo_post['grldattxt_cod'.$lv_typcod];
                $lv_dat['txttxt'] = $lv_val;
                $lv_dat['lngcod'] = $this->co_reg->sec->lngcod;
                $lv_dat['docsts'] = 'A';
                $lv_dat['txtsrctyp'] = ($lp_prm['cntsrctyp']??($lo_post['cntsrctyp']??'')).'C';
                $lv_dat['txtsrccod'] = $this->lo_mdl->cntcod;
                $lv_dat['txttypcod'] = $lv_typcod;             
        				
                if ( $lo_grltxtmdl->save( $lv_dat )==false ) {
									return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
                }
              	// si el texto está en blanco pero está definido el código, se elimina el texto
              }else if ($lv_val == '' && $lo_post['grldattxt_cod'.$lv_typcod] != ''){
                if ( $lo_grltxtmdl->delete( array('txtcod'=>$lo_post['grldattxt_cod'.$lv_typcod]) )==false ) {
                  return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
                }
              }
						}
					}
          
          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscodcnt) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					$this->lo_mdl->cntsrctyp = ($this->data['cntsrctyp']??'');
					$this->lo_mdl->cntsrccod = ($this->data['cntsrccod']??'');
					$this->lo_mdl->bcksec = $this->data['bcksec'];
					$this->lo_mdl->popup = $this->data['popup'];
					$this->lo_mdl->fndtxt = $this->data['fndtxt'];
          $this->lo_mdl->sysdocclscod = ($lp_prm['sysdocclscod']??($lo_post['sysdocclscod']??''));
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );

        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

			
      // NEW. devuelve la vista en modo creación
      case '#01':
        $lo_post = $this->co_reg->request->post;
				
				$this->lo_mdl->create();
				$this->lo_mdl->cntsrctyp = ($this->data['cntsrctyp']=='' ? ($lp_prm['cntsrctyp']??($lo_post['cntsrctyp']??'')) : $this->data['cntsrctyp']);
				$this->lo_mdl->cntsrccod = ($this->data['cntsrccod']=='' ? ($lp_prm['cntsrccod']??($lo_post['cntsrccod']??'')) : $this->data['cntsrccod']);;
				$this->lo_mdl->bcksec = ($this->data['bcksec']=='' ? ($lp_prm['bcksec']??($lo_post['bcksec']??'')) : $this->data['bcksec']);
				$this->lo_mdl->popup = ($this->data['popup']=='' ? ($lp_prm['popup']??($lo_post['popup']??'')) : $this->data['popup']);
				$this->lo_mdl->fndtxt = ($this->data['fndtxt']=='' ? ($lp_prm['fndtxt']??($lo_post['fndtxt']??'')) : $this->data['fndtxt'] );

				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				
				// clase de documento del objeto que quiere agregar el contacto
				$lv_srcdocclscod = ($lp_prm['srcdocclscod']??($lo_post['srcdocclscod']??''));
				// clase de documento del contacto
				$lv_docclscod = ($lp_prm['sysdocclscod']??($lo_post['sysdocclscod']??''));
        
        if ( $lv_docclscod=='' ){
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). 'GRL_CCT' .chr(9).chr(9).chr(9).
                              '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)                            
                              );
          // se recuperan todas las clases de docuemnto de contacto que tenga la clase de documento de cabecera
          if($lv_srcdocclscod!=''){
            $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
            $lv_prm=array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $lv_srcdocclscod .chr(9).chr(9).
                                        '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
            );
            $lo_rscnt = $lo_sysdocclscntmdl->getList( $lv_prm );

            // armo el filtro con las clases de documento que se recuperaron
            $lo_docclsflt = array();
            foreach ($lo_rscnt as $lv_row){ array_push($lo_docclsflt,$lv_row['sysdocclscodcnt']); }
            $lv_prm=array('vewfldflt' =>'[~fltrow~]d.sysdocclscod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lo_docclsflt) . chr(9) . chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
            );
          } 
            // obtengo clase de documento
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_cntsrctyp='.$this->lo_mdl->cntsrctyp.'&prm_cntsrccod='.$this->lo_mdl->cntsrccod.'&prm_srcdocclscod='.$lv_srcdocclscod.'&prm_bcksec='.$this->lo_mdl->bcksec.'&prm_popup='.$this->lo_mdl->popup,'doccls'=>$lv_docclsarr) );
					}
          
				}
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        } else {
          echo 'No se pudieron cargar los datos de la clase de documento.';
        }
        /* ------------------------------------------------ */
          
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>($lp_prm[self::ID]??$lo_post[self::ID]), 'cntsrctyp' => ($lp_prm['cntsrctyp']??$lo_post['cntsrctyp']));

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( !isset($lv_key['cntsrctyp'])) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro [cntsrctyp].') );
        } else if ( $this->lo_mdl->load($lv_key)==false ) { 
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->cntcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
        // cargo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscodcnt) ) ) {
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        }
				$this->lo_mdl->cntsrctyp = $this->data['cntsrctyp'];
				$this->lo_mdl->cntsrccod = $this->data['cntsrccod'];
				$this->lo_mdl->bcksec = $this->data['bcksec'];
				$this->lo_mdl->popup = $this->data['popup'];
				$this->lo_mdl->fndtxt = $this->data['fndtxt'];
        $this->lo_mdl->sysdocclscod = ($lp_prm['sysdocclscod']??($lo_post['sysdocclscod']??''));
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST by TEXT. lista los documentos segun texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['cnttxt'])?'[~fltrow~]c.cnttxt'.chr(9).''.chr(9).$lp_prm['cnttxt'].chr(9).chr(9).chr(9):'').
                                       (isset($lp_prm['cntsrctyp'])?'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lp_prm['cntsrctyp'].chr(9).chr(9):'').
                                       (isset($lp_prm['cntsrccod'])?'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lp_prm['cntsrccod'].chr(9).chr(9):'').
																			 (isset($lp_prm['dlvadr'])?'[~fltrow~]dbo.getTagValue(^dlvadr^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9):'').
                        							 (isset($lp_prm['invadr'])?'[~fltrow~]dbo.getTagValue(^invadr^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9):'').
																			 '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lv_prm2 = array('cnrsrctyp'=>$this->data['cntsrctyp']);
				$lo_data = $this->lo_mdl->getList($lv_prm, $lv_prm2, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
		}
	}
}
?>