<?php
final class slsprclstController extends tmssController {
	const CONTROLLER = 'slsprclst';
	const MODEL = 'slsprclst';
	const VIEW  = 'slsprclst';
	const ID = 'slsprclstvercod';
	const ID2 = 'slsprclstcod';
	const OBJTYP ='SLS_PRV';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  //INDEX. metodo principal
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
			
			
      // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
        
        //si se reemplaza los datos existentes por los nuevos realiza llamado a deleteList 
        if(($lo_post['slsprcrpl']??'false')=='true'){
        	$this->lo_mdl->deleteList( array('slsprclstcod'=>$lo_post['slsprclstcod'], 'slsprclstvercod'=>$lo_post['slsprclstvercod']) );
          if($this->lo_mdl->errtyp=='E')
          	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );             
        }

        if ($this->lo_mdl->save( $lo_post )) {
          if($lo_post['upl']??false){
            return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'0','errtxt'=>'Se grabaron los precios correctamente.') );
          }
          
          // cargo lista de precios
          $lo_prcmdl = $this->co_reg->load->model('slsprc');
          $lo_prcmdl->load( array('slsprclstcod'=>$lo_post['slsprclstcod']),false );

          // cargo cabecera de version de precios
          $lo_prcvermdl = $this->co_reg->load->model('slsprcver');
          $lo_prcvermdl->load( array('slsprclstcod'=>$lo_post['slsprclstcod'], 'slsprclstvercod'=>$lo_post['slsprclstvercod']) );

          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load( array('sysdocclscod'=>$lo_prcmdl->sysdocclscod) );
          
          //agregar version y id de slsprc
          $this->lo_mdl->slsprc = $lo_prcmdl;
          $this->lo_mdl->slsprcver = $lo_prcvermdl;
          $this->lo_mdl->slsprc->sysdoccls = $lo_docclsmdl;
          
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt!=''?$this->lo_mdl->errtxt:'No se pudo grabar los precios') );
        }
        break;
			
			
      // NEW. crea un documento
			case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->slsprclstcod = $lo_post['slsprclstcod'];
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array( self::ID=>($lo_post[self::ID]??$lp_prm[self::ID]), self::ID2=>($lo_post[self::ID2]??$lp_prm[self::ID2]) );
				
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'/'.self::ID2.'].') );
				}
				$this->lo_mdl->load($lv_key);
				
				// cargo cabecera precios
        $lo_prcmdl = $this->co_reg->load->model('slsprc');
				$lo_prcmdl->load( array('slsprclstcod'=>$lo_post['slsprclstcod']),false );

				// cargo cabecera precios
        $lo_prcvermdl = $this->co_reg->load->model('slsprcver');
				$lo_prcvermdl->load( array('slsprclstcod'=>$lo_post['slsprclstcod'], 'slsprclstvercod'=>$lo_post['slsprclstvercod']) );

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_prcmdl->sysdocclscod) );

        //agregar version y id de slsprc
        $this->lo_mdl->slsprc = $lo_prcmdl;
        $this->lo_mdl->slsprcver = $lo_prcvermdl;
				$this->lo_mdl->slsprc->sysdoccls = $lo_docclsmdl;
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. elimina un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) ); 
				break;
			
			
			// UPDATE LIST - COSTOS. actualiza lista de costos
      case '#06':
        $lo_post = $this->co_reg->request->post;
				$lv_flt = '';
        
				if (isset($lo_post['vewfldflt']) && !empty($lo_post['vewfldflt'])) {
          $lv_flt = $lo_post['vewfldflt'];
        }
				
				$lv_prm = array('vewfldflt' => $lv_flt);
        $lo_data = $this->lo_mdl->getListCost(array(), $lv_prm);
				
				return $this->co_reg->document->getJson($lo_data);
				break;
			
			
			// UPDATE LIST - PRECIOS. actualiza lista de precios
      case '#07':
        $lo_post = $this->co_reg->request->post;
				$lv_flt = '';
				
        if (isset($lo_post['vewfldflt']) && !empty($lo_post['vewfldflt'])) {
          $lv_flt = $lo_post['vewfldflt'];
        }
				
				$lv_prm = array('vewfldflt' => $lv_flt);
        $lo_data = $this->lo_mdl->getListPrice(array(), $lv_prm);
        
				return $this->co_reg->document->getJson($lo_data);
        break;
			
        
			// LIST. lista los documentos
			case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lo_post['slsprclstcod'].chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'pv.slsprclststrdte desc'
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
				break;
			
			
			// LISTAR. lista los precios de la version utilizando los filtros personalizados
			case'#17':case '#23':
				$lo_post = $this->co_reg->request->post;

        if(isset($lp_prm['slsprclstdte']) || isset($lo_post['slsprclstdte'])){
          $lv_slsprclstdte = (isset($lp_prm['slsprclstdte'])?$this->co_reg->db->sqldate($lp_prm['slsprclstdte']):$this->co_reg->db->sqldate($lo_post['slsprclstdte']));
          $lv_slsprclstdte=substr($lv_slsprclstdte,0,4).'-'.substr($lv_slsprclstdte,4,2).'-'.substr($lv_slsprclstdte,6,2);
        }
				$lv_slsprcsrctyp = (isset($lp_prm['slsprcsrctyp'])?$lp_prm['slsprcsrctyp']:(isset($lo_post['slsprcsrctyp'])?$lo_post['slsprcsrctyp']:''));
				$lv_slsprcsrccod = (isset($lp_prm['slsprcsrccod'])?$lp_prm['slsprcsrccod']:(isset($lo_post['slsprcsrccod'])?$lo_post['slsprcsrccod']:''));
				$lv_slsprclstcod = (isset($lp_prm['slsprclstcod'])?$lp_prm['slsprclstcod']:$lo_post['slsprclstcod']);
        $lv_slsprclstvercod = (isset($lp_prm['slsprclstvercod'])?$lp_prm['slsprclstvercod']:($lo_post['slsprclstvercod']??''));
				// PRECIOS. obtengo precios de lista de precios
				$lv_prm = array('vewfldflt' =>($lo_post['vewfldflt']??'').
                        							($lv_slsprcsrctyp!=''?'[~fltrow~]pl.slsprcsrctyp'.chr(9).'='.chr(9).chr(9).$lv_slsprcsrctyp.chr(9).chr(9):'').
																			($lv_slsprcsrccod!=''?'[~fltrow~]pl.slsprcsrccod'.chr(9).'='.chr(9).chr(9).$lv_slsprcsrccod.chr(9).chr(9):'').
                        							(isset($lv_slsprclstdte)?('[~fltrow~]'.chr(9).'ZZ'.chr(9).'^'.$lv_slsprclstdte.'^ BETWEEN pv.slsprclststrdte AND pv.slsprclstenddte'.chr(9).chr(9).chr(9)).																			
                                      '[~fltrow~]pv.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9):'').
                        							($lv_slsprclstvercod!=''?'[~fltrow~]pl.slsprclstvercod'.chr(9).'='.chr(9).chr(9).$lv_slsprclstvercod.chr(9).chr(9):'').
                        							'[~fltrow~]pl.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lv_slsprclstcod.chr(9).chr(9),
                        							'[~fltrow~]srcobjsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),				
												'vewmaxrec' => ($lo_post['vewmaxrec']??100),
                       	'vewfldord' => 'pv.slsprclststrdte desc');
				$lo_rs = $this->lo_mdl->getList($lv_prm);
        
        if( isset($lp_prm['currow']) ) { $lo_data['currow'] = $lp_prm['currow']; }
        if($lp_act=='#17')return $this->co_reg->document->getJson( $lo_rs );		
        
        $lo_prcsca = array();
        if($lv_slsprclstvercod!=''){
          // ESCALAS. obtengo escalas de precios
          $lo_prcmdl = $this->co_reg->load->model('grldatprc');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SYS_PCN'.chr(9).chr(9).
                                        '[~fltrow~]pcaq.prccndaccseqord'.chr(9).'='.chr(9).chr(9).($lo_post['prccndacccod']??'').chr(9).chr(9).
                                        '[~fltrow~]p.prccndcod'.chr(9).'='.chr(9).chr(9).($lo_post['prccndcod']??'') .chr(9).chr(9).
                                        '[~fltrow~]p.srcobjcod001'.chr(9).'LIKE'.chr(9).$lo_post['slsprclstcod'].';'.$lo_post['slsprclstvercod'].';%'.chr(9).chr(9).chr(9)
                          );
          $lo_rssca = $lo_prcmdl->getListWithSequence( $lv_prm );
          foreach($lo_rssca as $lv_row){
            if (isset($lv_row['grldatprcsca'])){
              foreach($lv_row['grldatprcsca'] as $lv_row2){
                $lv_prcatr = explode(';' , $lv_row['srcobjcod001']);
                $lv_row2['slsprclstprccod'] = $lv_prcatr[2];
                $lo_prcsca[] = $lv_row2;
              }
            }
          }
        }
        return $this->co_reg->document->getJson( array('data'=>$lo_rs, 'prcsca'=>$lo_prcsca) );		
				break;
			
			
			
			
			// UPLOAD. NEW. devuelve vista de subida de precios
			case '#slsprcupl':
      	$lo_post = $this->co_reg->request->post;
        // PRECIOS. obtengo precios de lista de precios
				$lv_prm = array('vewfldflt' =>($lo_post['vewfldflt']??'').
                        							'[~fltrow~]pl.slsprclstvercod'.chr(9).'='.chr(9).chr(9).$lo_post['slsprclstvercod'].chr(9).chr(9).
                        							'[~fltrow~]pl.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lo_post['slsprclstcod'].chr(9).chr(9),
                        							'[~fltrow~]srcobjsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),				
												'vewmaxrec' => ($lo_post['vewmaxrec']??9999) );
				$lo_rs = $this->lo_mdl->getList($lv_prm);
        $this->lo_mdl->slsprclstcod=$lo_post['slsprclstcod'];
        $this->lo_mdl->slsprclstvercod=$lo_post['slsprclstvercod'];
        $this->lo_mdl->slsprclst=$lo_rs;

        // devuelvo vista
				return $this->co_reg->document->getView( 'slsprcupl', array('data'=>$this->lo_mdl, 'actcod'=>'02') );
				break;			
			
			// UPLOAD. PREVIEW. carga datos para previsualizacion de info a cargar
      case '#slsprcuplchk':
          $lo_post = $this->co_reg->request->post;
        	$this->lo_mdl->load(array('slsprclstcod'=>$lo_post['slsprclstcod']));
					//cargar cabecera de precios
          $lo_slsprcmdl = $this->co_reg->load->model('slsprc');
        	$lo_slsprcmdl->load(array('slsprclstcod'=>$lo_post['slsprclstcod']));

          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load( array('sysdocclscod'=>$lo_slsprcmdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;					
          $lv_srcobjtyp=$this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'srcobjtyp');

        // preparo datos
					$lv_matlststr = '';
					$lv_matlst = json_decode(utf8_encode(html_entity_decode($lo_post['matlst'])), true);
        
					foreach($lv_matlst as $lv_row){ $lv_matlststr.=$lv_row['matcodext'].chr(10); }
					
					// busco materiales para validar
					switch($lv_srcobjtyp){
						case 'STK_MAT':
							$lo_stkmatmdl = $this->co_reg->load->model('stkmat');
							$lv_prm = array('vewfldflt' =>(isset($lo_post['matcodlst'])?'[~fltrow~]m.matcodext'.chr(9).'IN'.chr(9).chr(9).$lv_matlststr.chr(9).chr(9):'').
																					'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
														);
							$lo_data = $lo_stkmatmdl->getList($lv_prm, null, null, false);
							break;
						case  'CNS_TSK':
							$lo_cnstskmdl = $this->co_reg->load->model('cnstsk');
							$lv_prm = array('vewfldflt' =>($lv_matlststr!=''?'[~fltrow~]t.cnstskcodext'.chr(9).'IN'.chr(9).chr(9).$lv_matlststr.chr(9).chr(9):'').
																						'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
															'vewfldgrpcal'=>'t.*, t.cnstskcod as matcod,t.cnstskcodext as matcodext, t.cnstsktxt as mattxt, 0.00 as matcst'                              	
														);
							$lo_data = $lo_cnstskmdl->getList($lv_prm,null,null,false);
							break;
						default:
							$lo_data = array();
							break;
					}
					$lo_matidt_mdl = $this->co_reg->load->model('stkmatidt');
					// valido materiales
					foreach($lv_matlst as &$lv_row){
						$lv_found = false;
            $lv_matuntcoderr=false;
						foreach($lo_data as $lv_rowdata){
							if($lv_rowdata['matcodext']==$lv_row['matcodext']){
								$lv_found=true;
                $lv_row['mattxt']=$lv_rowdata['mattxt'];
                $lv_row['matcod']=$lv_rowdata['matcod'];
                $lv_row['srcobjtyp']=$lv_srcobjtyp;
                //valido unidad
                if($lv_rowdata['matuntcod']!=$lv_row['matuntcod']){
                	$lv_matuntcoderr=true;
              	}
                //si es un material y no coincide la unidad, revisa sus unidades alternativas
                if($lv_srcobjtyp=='STK_MAT' && $lv_matuntcoderr){
                  // lista de conversiones
                  $lv_prm = array('vewfldflt' =>'[~fltrow~]i.matcod'.chr(9).'='.chr(9).chr(9).$lv_row['matcod'].chr(9).chr(9) );
                  $lo_rs = $lo_matidt_mdl->getList( $lv_prm );
                  foreach($lo_rs as $lv_rowmatuntcod){
                    if($lv_rowmatuntcod['matidtuntcod']==$lv_row['matuntcod']){
                      $lv_matuntcoderr=false;
                      break;
                    }
                  }
								}
							}
            }
						if($lv_found){
							$lv_row['errtyp']='S';
              $lv_row['errcod']=0;
							$lv_row['errtxt']='';
              if($lv_matuntcoderr){
                $lv_row['errtyp']='E';
                $lv_row['errcod']=-2;
                $lv_row['errtxt']='No coinciden las unidades de medida.';						
              }
						} else {
							$lv_row['errtyp']='E';
							$lv_row['errcod']=-1;
							$lv_row['errtxt']='Codigo no encontrado/invalido.';
						}
					}
					unset($lv_row);
					
					// devuelvo resultado de validacion
          return $this->co_reg->document->getJson( $lv_matlst );		  
					break;
    }
  }
}
?>