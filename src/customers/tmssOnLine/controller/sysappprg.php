<?php
final class sysappprgController extends tmssController {
	const MODEL = 'sysappprg';					
	const VIEW  = 'sysappprg';					
	const ID = 'prgcod';								
	const ID2 = 'mdlcod';								
	const OBJTYP ='SYS_PRG';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
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
		$lo_grltxtmdl = $this->co_reg->load->model('grldattxt');
		$lo_grltxttypmdl = $this->co_reg->load->model('grldattxttyp');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			case'#help':
				$lo_post = $this->co_reg->request->post;
				$this->co_reg->user->lngcod= ($this->co_reg->user->lngcod!=''?$this->co_reg->user->lngcod:'ES');

				// obtiene el texto de la ayuda
				$lv_prm = array('vewmaxrec'=>1,
												'vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).$lo_post['mdlcod'].'_'.$lo_post['prgcod'].chr(9).chr(9).
																			'[~fltrow~]lngcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->user->lngcod.chr(9).chr(9));
				$lo_rs = $lo_grltxtmdl->getList( $lv_prm, array(), null, true );

				//devuelve valores dependiendo de la operacion
				if($lo_post['optype']=='check'){
					return ( count($lo_rs)>0 ? (trim($lo_rs[0]['txttxt'])!='') : false );
				} else if($lo_post['optype']=='get'){
					$this->lo_mdl->txt = (count($lo_rs)>0 ? $lo_rs[0]['txttxt'] : '');
          
        	return $this->co_reg->document->getView( 'sysappprghlpdia', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				}
				break;

			// LIST
      case '#': case '#08':
				$this->lo_mdl->sysprg = $this->co_reg->document->getMenu( array('getall'=>true,'gethde'=>true,'chkper'=>false,'getopr'=>false,'getsep'=>true,'getempfld'=>true) );
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'data' => $this->lo_mdl,
												'actcod' => $this->data['actcod'],
												'model' => self::MODEL
												);
				$lv_ret = $this->co_reg->load->view( 'sysappprgtre', $lv_prm );
				return $lv_ret;
        break;

      // SAVE
      case '#00':
				$lo_dat = $this->co_reg->request->post;
				
        if ( $this->lo_mdl->save( $lo_dat ) ) {
					$lv_buffer = $this->co_reg->request->post['prgopr'];
					if ($lv_buffer!='') {
						$lo_prgopr = $this->co_reg->load->model('syssecopr');
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_prgopr_arr = json_decode($lv_buffer,true);
						foreach( $lv_prgopr_arr as $lv_row ) {
							$lv_row['mdlcod'] = $this->lo_mdl->mdlcod;
							$lv_row['prgcod'] = $this->lo_mdl->prgcod;
							if ( isset($lv_row['deleted']) ) {
								if ($lo_prgopr->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errcod'=>$lo_prgopr->errcod,'errtxt'=>$lo_prgopr->errtxt) );		
								}
							} else if ($lo_prgopr->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errcod'=>$lo_prgopr->errcod,'errtxt'=>$lo_prgopr->errtxt) );
							}
						}
					}
					
					// cargo definición de textos
					$lv_prm = array('vewfldflt' =>'[~fltrow~]tt.objtyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP .chr(9).chr(9).
																				'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_txtrs = $lo_grltxttypmdl->getList( $lv_prm, array(), null, true);
										
					// grabo textos
					foreach($lo_txtrs as $lv_rowdef) {
						$lv_typcod = $lv_rowdef['txttypcod'];
						if ( isset($lo_dat['grldattxt_txt_'.$lv_typcod]) ) {
							$lv_dat = array();
							$lv_dat['txtcod'] = $lo_dat['grldattxt_cod_'.$lv_typcod];
							$lv_dat['txttxt'] = $lo_dat['grldattxt_txt_'.$lv_typcod];
							$lv_dat['lngcod'] = $lo_dat['lngcod'];
							$lv_dat['docsts'] = $lo_dat['docsts'];
							$lv_dat['txtsrctyp'] = self::OBJTYP;
							$lv_dat['txtsrccod'] = $this->lo_mdl->mdlcod .'_'. $this->lo_mdl->prgcod;
							$lv_dat['txttypcod'] = $lv_typcod;
							if ( $lo_grltxtmdl->save( $lv_dat, true )==false ) {
                return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
							}
						}
					}

					// cargo datos del documento
					$this->lo_mdl->load( array('mdlcod'=>$this->lo_mdl->mdlcod,'prgcod'=>$this->lo_mdl->prgcod) );
					
					// cargo textos del documento
					$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP .chr(9).chr(9).
																				'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->mdlcod .'_'. $this->lo_mdl->prgcod .chr(9).chr(9) );
					$lo_rs = $lo_grltxtmdl->getList( $lv_prm, array(), null, true );
					$this->lo_mdl->txt = $lo_rs;
					
					// asigno definición de textos
					$this->lo_mdl->txttyp = $lo_txtrs;
					
        	return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

      // NEW                
      case '#01':
				$this->lo_mdl->load( array(	'mdlcod'=>$this->co_reg->request->post['mdlcod'], 'prgcod'=>$this->co_reg->request->post['prgcod']	) );											
				$lv_mdlcod = $this->lo_mdl->mdlcod;
				$lv_mdltxt = $this->lo_mdl->mdltxt;
				$lv_prgord = $this->lo_mdl->prgord;
				if ($this->lo_mdl->prgtypcod=='3') {
					$lv_prgord = $this->lo_mdl->prgord + 1;
					$lv_prgmnupar = $this->lo_mdl->prgmnuchl;
				} else {
					$lv_prgmnupar = '';
				}
				
				$this->lo_mdl->create();
				$this->lo_mdl->opr = array();
				$this->lo_mdl->mdlcod=$lv_mdlcod;
				$this->lo_mdl->mdltxt=$lv_mdltxt;
				$this->lo_mdl->prgord=$lv_prgord;
				$this->lo_mdl->prgmnupar=$lv_prgmnupar;
				
				// cargo definición de textos
				$lv_prm = array('vewfldflt' =>'[~fltrow~]tt.objtyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP .chr(9).chr(9).
																			'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_txtrs = $lo_grltxttypmdl->getList( $lv_prm, array(), null, true );
				$this->lo_mdl->txttyp = $lo_txtrs;
				
				// cargo textos del documento (array vacío)
				$this->lo_mdl->txt = array();
				
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
				
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				if ( isset($lp_prm[self::ID]) && isset($lp_prm[self::ID2]) ) {
					$lv_key = array( self::ID=>$lp_prm[self::ID], self::ID2=>$lp_prm[self::ID2] );																			
				} else {
					$lv_key = array( self::ID=>$this->co_reg->request->post[self::ID], self::ID2=>$this->co_reg->request->post[self::ID2] );										
				}

				// load object
				if ( !isset($lv_key[self::ID]) || !isset($lv_key[self::ID2]) ) {
					return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.' o '.self::ID2.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->prgcod = '';																												
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo definición de textos
				$lv_prm = array('vewfldflt' =>'[~fltrow~]tt.objtyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP .chr(9).chr(9).
																			'[~fltrow~]tt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_txtrs = $lo_grltxttypmdl->getList( $lv_prm, array(), null, true );
				$this->lo_mdl->txttyp = $lo_txtrs;
				
				// cargo textos del documento
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). self::OBJTYP .chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->mdlcod .'_'. $this->lo_mdl->prgcod .chr(9).chr(9) );
				$lo_rs = $lo_grltxtmdl->getList( $lv_prm, array(), null, true );
				$this->lo_mdl->txt = $lo_rs;
				
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;

    }

  }

	private function getMenu( $lp_rs ) {
		/* armo los menúes */
		$lv_mnu = array();
    if (isset($lp_rs) && count($lp_rs)!=0) {
			$lv_lstmdl='';
      for( $lv_inx=0; $lv_inx<count($lp_rs); $lv_inx++ ) {
        if ($lv_lstmdl!=$lp_rs[$lv_inx]['mdlcod']) {
					$lv_lstmdl=$lp_rs[$lv_inx]['mdlcod'];
          $lv_mnu[] = array('mdlcod'=>$lp_rs[$lv_inx]['mdlcod'],
														'prgcod'=>'**',
														'prgtxt'=>$lp_rs[$lv_inx]['mdltxt'],
														'mdlpic'=>$lp_rs[$lv_inx]['mdlpic'],
														'prgpic'=>'',
														'prgtypcod'=>'0',
														'prgmnuchl'=>$lp_rs[$lv_inx]['prgmnuchl'],
														'prgmnupar'=>'',
														'mnulst'=> $this->getMenuArray( $lp_rs, $lv_inx, $lp_rs[$lv_inx]['prgmnuchl'], false )
														);
        }
      }
    }
    return $lv_mnu;
	}
	/* *************************************************************************
	 * getMenuArray
	 * Recursiva para armar el menú de programas (sin operaciones)
	 */
  private function getMenuArray( &$lp_mnu=array(), &$lp_inx=-1, $lp_key='', $lp_chkPer=true ) {
    $lv_mnu = array();
    $lv_ext=0;
    for( ; $lp_inx<count($lp_mnu) && $lv_ext==0; $lp_inx++ ) {
      if ( $lp_mnu[$lp_inx]['prgmnupar']!=$lp_key ) {
        $lp_inx-=2;
        $lv_ext=1; 
      } else {
				//	C A R P E T A
        if ( $lp_mnu[$lp_inx]['prgtypcod']==3 ) {
          $lv_mnutmp001 = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'],
																'prgcod'=>$lp_mnu[$lp_inx]['prgcod'],
																'prgtxt'=>$lp_mnu[$lp_inx]['prgtxt'],
																'prgpic'=>$lp_mnu[$lp_inx]['prgpic'],
																'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
																'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
																'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar'],
																'mnulst'=>array()
																);
					$lv_mnuchl = $lp_mnu[$lp_inx]['prgmnuchl'];
					$lp_inx++;
					$lv_mnutmp001['mnulst'] = $this->getMenuArray( $lp_mnu, $lp_inx, $lv_mnuchl, $lp_chkPer);
          // si contiene programas, cargo la carpeta principal
          //if ( count($lv_mnutmp001['mnulst'])!=0 ) {$lv_mnu[] = $lv_mnutmp001;}
					$lv_mnu[] = $lv_mnutmp001;
					
        //	S E P A R A D O R
        } else if ( $lp_mnu[$lp_inx]['prgtypcod']==2 ) {
          // no se cargan separadores si es la primer opción
          if ( count($lv_mnu)!=0 ) {
            // no se cargan dos separadores juntos
            if ($lv_mnu[count($lv_mnu)-1]['prgtypcod']!=2) {
              $lv_mnu[] = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'],
																'prgcod'=>$lp_mnu[$lp_inx]['prgcod'],
																'prgtxt'=>'',
																'prgpic'=>'',
																'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
																'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
																'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar'],
																'mnulst'=>array()
																);
            }
          }
					
				//	P R O G R A M A
        } else if ( $lp_mnu[$lp_inx]['prgtypcod']==1 ) {
					if ( $lp_chkPer==false || $this->co_reg->sec->hasPermission($lp_mnu[$lp_inx]['mdlcod'], $lp_mnu[$lp_inx]['prgcod']) ) {
						$lv_mnu[] = array('mdlcod'=>$lp_mnu[$lp_inx]['mdlcod'],
															'prgcod'=>$lp_mnu[$lp_inx]['prgcod'],
															'prgtxt'=>$lp_mnu[$lp_inx]['prgtxt'],
															'prgpic'=>$lp_mnu[$lp_inx]['prgpic'],
															'prgtypcod'=>$lp_mnu[$lp_inx]['prgtypcod'],
															'prgmnuchl'=>$lp_mnu[$lp_inx]['prgmnuchl'],
															'prgmnupar'=>$lp_mnu[$lp_inx]['prgmnupar'],
															'mnulst'=>array()
															);
					}
        }
      }
    }
    return $lv_mnu;
  }
	
}
?>