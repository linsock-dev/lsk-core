<?php
final class hhrempController extends tmssController {
	const CONTROLLER = 'hhremp';
	const MODEL = 'hhremp';
	const VIEW  = 'hhremp';
	const ID = 'hhrempcod';
	const OBJTYP ='HHR_EMP';
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
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
        
        if (  $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array(	'hhrempcod'=>$this->lo_mdl->hhrempcod	) );
					
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        } 
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				// ------------------------------------------------
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualización
      case '#02': case '#03': case '#001':									
        $lv_key = array(self::ID=>($lp_prm[self::ID]??$this->co_reg->request->post[self::ID]));

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->hhrempcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// obtengo toda la info de la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra un docuento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			// LIST by TEXT. lista los documentos segun texto indicado
      case '#18': case '#17':
				$lo_post = $this->co_reg->request->post;
				
				if(isset($lo_post['hhremptxt'])){ $lp_prm['hhremptxt'] = $lo_post['hhremptxt']; }
				if(isset($lo_post['hhrempcodext'])){ $lp_prm['hhrempcodext'] = $lo_post['hhrempcodext']; }
				
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['hhremptxt'])?'[~fltrow~]p.hhremptxt'.chr(9).''.chr(9).$lp_prm['hhremptxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['hhrempcodext'])?'[~fltrow~]p.hhrempcodext'.chr(9).'='.chr(9).chr(9).$this->co_reg->db->sqldata($lp_prm['hhrempcodext']).chr(9).chr(9):'').
                        							'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
        break;
        
      // GET EMPLOYEE. Devuelve un empleado
      case '#getEmp':
        $lv_key = array();

				// get param (KEY)
        $lv_key = (isset($lp_prm[self::ID])?array(self::ID=>$lp_prm[self::ID]):array(self::ID=>$this->co_reg->request->post[self::ID]));

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico el parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
				}
        
        $this->lo_mdl->tax = $this->lo_mdl->tax->getData();
        
        return $this->co_reg->document->getJson( array('data'=>$this->lo_mdl->getData()) );
        break;
        
    
			// DASHBOARD. devuelve el dashboard del empleado
			case '#dshemp':
				$lo_post = $this->co_reg->request->post;
				$lv_typ = ($lo_post['typ']??'');
				$lv_empcod = ($lo_post['hhrempcod']??'');

				// si no se informo empleado, se intenta obtener el parametro y se devuelve la vista completa
				if($lv_empcod==''){
					$this->lo_mdl->create();
					// ID EMPLEADO. obtengo de los parametros de usuario el ID de empleado
					$lv_empcod = '';
					$lo_prmmdl = $this->co_reg->load->model('syssecusrprm');
					$lv_prm = array('vewfldflt'=>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
					$lo_prmrs = $lo_prmmdl->getDefinitions( $lv_prm );
					$lv_prm = array('vewfldflt'=>	'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lo_usrprmrs = $lo_prmmdl->getList( $lv_prm );
					foreach($lo_prmrs as $lv_row){
						if($lv_row['secusrprmreffld']=='hhrempcod'){
							foreach($lo_usrprmrs as $lv_rowusr){
								if($lv_rowusr['prmcod']==$lv_row['secusrprmcod']){
									$lv_empcod=$lv_rowusr['prmval'];
									break;
								}
							}
							break;
						}
					}
					$this->lo_mdl->load( array('hhrempcod'=>$lv_empcod), false );
					
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					
					return $this->co_reg->document->getView( 'hhrempdsh', array('data'=>$this->lo_mdl) );
				}
					
				// se informo empleado, se devuelven datos JSON segun el tipo de info que se requiere
				$lo_rs = array();
				switch( $lv_typ ){
					// EMPLEADO. obtiene los datos del empleado
					case 'emp':					
						$this->lo_mdl->load( array('hhrempcod'=>$lv_empcod), false );
						$lo_rs = $this->lo_mdl->getData();
						$lo_rs['adr'] = $this->lo_mdl->adr->getData();
						$lo_rs['tax'] = $this->lo_mdl->tax->getData();
						$lo_rs['bnk'] = $this->lo_mdl->bnk->getData();
						$lo_rs['per'] = $this->lo_mdl->per->getData();
						break;
						
					// MIS TURNOS. obtiene los turnos asignados al empleado
					case 'tme':
						$lo_tmemdl = $this->co_reg->load->model('hhremptme');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]et.hhremptmestr'.chr(9).'<='.chr(9).chr(9).date_format(new DateTime(),'Y-m-d').chr(9).chr(9).
																					'[~fltrow~]et.hhremptmeend'.chr(9).'>='.chr(9).chr(9).date_format(new DateTime(),'Y-m-d').chr(9).chr(9).
																					'[~fltrow~]et.hhrempcod'.chr(9).'='.chr(9).chr(9).$lv_empcod.chr(9).chr(9).
																					'[~fltrow~]et.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewfldord' => ' e.hhremptxt ' );
						$lo_rs = $lo_tmemdl->getList( $lv_prm );
						break;
						
					// MIS LICENCIAS. obtiene las licencias solicitadas por el empleado
					case 'lic':
						$lo_licmdl = $this->co_reg->load->model('hhrlic');
            $lv_lmtdte = date("Y-m-d", strtotime("-1 year"));
						$lv_prm = array('vewmaxrec' =>'8',
														'vewfldflt' =>'[~fltrow~]l.srcobjtyp'.chr(9).''.chr(9).'HHR_EMP'.chr(9).chr(9).chr(9).
																					'[~fltrow~]l.srcobjcod'.chr(9).'='.chr(9).chr(9).$lv_empcod.chr(9).chr(9).
                            							'[~fltrow~]l.hhrlicdtestr'.chr(9).'>='.chr(9).chr(9).$lv_lmtdte.chr(9).chr(9),
														'vewfldord' => 'l.hhrlicdtestr desc' );
						$lo_rs = $lo_licmdl->getList( $lv_prm, null, null, false);
						break;
						
					// MIS RECIBOS. obtiene los ultimos recibos del empleado
					case 'lqd':
						$lo_lqdmdl = $this->co_reg->load->model('hhrlqd');
						$lv_prm = array('vewmaxrec' =>'6',
														'vewfldflt' =>'[~fltrow~]l.srcobjtyp'.chr(9).''.chr(9).'HHR_EMP'.chr(9).chr(9).chr(9).
																					'[~fltrow~]l.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lv_empcod.chr(9).chr(9).
																					'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9), 
														'vewfldord' => 'l.hhrlqdstrdte desc' );
						$lo_rs = $lo_lqdmdl->getList( $lv_prm,null,null, false );
						break;
						
					// NOVEDADES.
					case 'nws':
						$lo_nwsmdl = $this->co_reg->load->model('grlnws');
            $lv_lmtdte = date("Y-m-d", strtotime("-4 months"));
						$lv_prm = array('vewmaxrec' =>'10',
														'vewfldflt' =>'[~fltrow~]n.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																					'[~fltrow~]tt.txttypcodext'.chr(9).'='.chr(9).chr(9).'NEWS'.chr(9).chr(9).
                            							'[~fltrow~]n.nwsdte'.chr(9).'>='.chr(9).chr(9).$lv_lmtdte.chr(9).chr(9),
														'vewfldord' => 'n.nwsdte desc' );
						$lo_rs = $lo_nwsmdl->getlist($lv_prm);
						break;
						
					// MIS COMPAÑEROS. cumples, horarios y aniversarios
					case 'cum':
						$lo_empmdl = $this->co_reg->load->model('hhremp');
						$lv_prm = array('vewmaxrec' =>'100',
														'vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																					'[~fltrow~]isnull(p.hhrempoutdte,getdate()) >= getdate()'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																					'[~fltrow~]p.hhrempinbdte <= getdate()'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9),
                            'extra'			=> '<avoiduserrestrictions>X</avoiduserrestrictions>',
														'vewfldord' => 'p.hhremptxt');
						$lo_rs = $lo_empmdl->getList( $lv_prm, null, null, false );
						break;
          case 'ski':
            break;
          case 'obj':
            break;
				}
				return $this->co_reg->document->getJson( $lo_rs );
				break;
    }
  }
}
?>