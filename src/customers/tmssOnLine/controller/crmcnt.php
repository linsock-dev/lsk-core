<?php
final class crmcntController extends tmssController {
	const CONTROLLER = 'crmcnt';
	const MODEL = 'crmcnt';
	const VIEW  = 'crmcnt';
	const ID = 'crmcntcod';
	const OBJTYP = 'CRM_CNT';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

	public function getAct($lp_url_method){
    $lv_act = null;
    
    switch($lp_url_method){
      case 'calendar':
        $lv_act = 'cal';
        break;
        
    }
    
    return $lv_act;
  }
  
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
			
			//   D A S H B O A R D
      case '#dsh':
        $lo_post = $this->co_reg->request->post;
        $lo_ret =array();

				if(($lo_post['typ']??'')!=''){
					$lo_cntmdl=$this->co_reg->load->model('crmcnt');
					$lv_prm=array('vewfldflt'=>	htmlspecialchars_decode($lo_post['vewfldflt']??'')
																			.'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																			.'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
												);
					
					switch( $lo_post['typ'] ){
						case 'active':	// ACTIVOS - NO ASIGNADOS
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='c.usrcod';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'last_closed':	// ULTIMOS CERRADOS
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9)
																	. '[~fltrow~]c.upddte>=dateadd(day,-7,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
							$lv_prm['vewfldord'] ='c.upddte desc';
							break;
						case 'recents':	// RECIENTES
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
																	. '[~fltrow~]c.ctedte>=dateadd(day,-7,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
							$lv_prm['vewfldord'] ='c.ctedte desc';
							$lv_prm['vewmaxrec'] = 5;
							break;
						case 'type':	// POR TIPO
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='t.crmcnttyptxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'priority':	// POR PRIORIDAD
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='p.crmcntprttxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'status':	// POR ESTADO
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
							$lv_prm['vewfldgrp']='s.crmcntststxt';
							$lv_prm['vewfldgrpcal']='count(*) as qty';
							break;
						case 'average_closed':	// TIEMPO MEDIO DE CIERRE
							$lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9)
																	. '[~fltrow~]c.upddte>=dateadd(day,-30,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
							$lv_prm['vewfldgrpcal']='avg( datediff( minute, c.ctedte, c.upddte ) ) as avgcls';
							break;
					}
					
					if($lo_post['typ']!='comments'){
						$lo_rs = $lo_cntmdl->getList($lv_prm, null, null, false);
					
					// para comentarios, dada la lista de tickets obtengo los comentarios
					} else {
						// armo lista de tickets
						$lo_chgmdl = $this->co_reg->load->model('sysdocchg');
						$lv_prm=array('vewfldflt' => htmlspecialchars_decode(str_ireplace('c.usrcod','dca.cteusr',($lo_post['vewfldflt']??'')))
																				.'[~fltrow~]dc.ChgDocSrcTyp'.chr(9).'='.chr(9).chr(9).'CRM_CNT'.chr(9).chr(9)
																				.'[~fltrow~]dca.chgdocatrnme'.chr(9).'='.chr(9).chr(9).'COMENTARIOS'.chr(9).chr(9)
																				.'[~fltrow~]dca.ctedte>=dateadd(day,-15,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9),
													'vewmaxrec' => 500,
													'vewfldord' => 'dca.ctedte desc'
						);
						$lo_rs = $lo_chgmdl->getVariousDetails($lv_prm);
					}
					
					return $this->co_reg->document->getJson( $lo_rs );
				}

				// obtengo filtro por default
        $this->lo_mdl = new stdClass();
        $this->lo_mdl->sysdoccls = 0;
        $this->lo_mdl->doccls = 0;
				$lo_fltmdl = $this->co_reg->load->model('grldocflt');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).'CRM_CNT_DSH'.chr(9).chr(9).
																			'[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
											);
				$lo_rs = $lo_fltmdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$this->lo_mdl->vewfldfltdef = ($lo_rs[0]['vewfltdat']??'');
					$this->lo_mdl->vewfltcod = ($lo_rs[0]['vewfltcod']??'');
				}

        // RETURN. devuelve la vista con los datos
        return $this->co_reg->document->getView('crmcntdsh', array('data'=>$this->lo_mdl));
        break;
			
			//	C A L E N D A R I O
			case '#cal':
				$lo_post = $this->co_reg->request->post;
			
				// obtengo filtro por default
				$lo_fltmdl = $this->co_reg->load->model('grldocflt');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).'CRM_CNT_CAL'.chr(9).chr(9).
																			'[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
											);
				$lo_rs = $lo_fltmdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$this->lo_mdl->vewfldfltdef = $lo_rs[0]['vewfltdat'];
					$this->lo_mdl->vewfltcod = $lo_rs[0]['vewfltcod'];
				}
			
				return $this->co_reg->document->getView('crmcntcal', array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod'], 'urlmethod'=>'calendar'));
				break;
			
			
			//   K A N B A N   - graba estados (orden de columnas)
			case '#kanprfsve':
				$lo_post = $this->co_reg->request->post;
        if( isset($lo_post['colsts']) ){
					$lo_usrprfmdl=$this->co_reg->load->model('syssecusrprf');
          $lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'CRM_KAN','usrprfkey'=>'COLSTS','usrprfval'=>$lo_post['colsts'],'docsts'=>'A');
          $lo_usrprfmdl->save( $lv_dat );
        }
				break;
			
			
			//   K A N B A N
			case '#kan':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->vew = ($lp_prm['vew']??'sts');
				
				// obtengo filtro por default
				$lo_fltmdl = $this->co_reg->load->model('grldocflt');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).'CRM_CNT_KAN'.chr(9).chr(9).
																			'[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
											);
				$lo_rs = $lo_fltmdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$this->lo_mdl->vewfldfltdef = $lo_rs[0]['vewfltdat'];
					$this->lo_mdl->vewfltcod = $lo_rs[0]['vewfltcod'];
				}
				
				//ESTADOS. obtiene los posibles estados de un contacto
				$this->lo_mdl->sts = array();
				if( $this->lo_mdl->vew=='sts') {
					
					// PREFERENCIAS. se recuperan las preferencias de usuario (orden de columnas)
					$i=0;
					$lo_usrprfmdl=$this->co_reg->load->model('syssecusrprf');
					$lv_prm=array('vewfldflt'=>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9)
																		 .'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9). 'CRM_KAN' .chr(9).chr(9)
																		 .'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
												);
					$lo_usrprfarr = $lo_usrprfmdl->getList( $lv_prm );
					foreach($lo_usrprfarr as $lv_row){
						if($lv_row['usrprfkey']=='COLSTS' && trim($lv_row['usrprfval'])!=''){
							$lv_colstsarr = explode( ';' , trim($lv_row['usrprfval']) );
							$lv_colstsord = ' (CASE s.crmcntstscod ';
							foreach($lv_colstsarr as $lv_row){
								$lv_colstsord .= ' WHEN '.$lv_row.' THEN '.$i;
								$i++;
							}
							$lv_colstsord .= ' ELSE 0 END) ';
							break;
						}
					}				
					
					// ESTADOS. se recuperan todos los estados disponibles
					$lo_cntsts=$this->co_reg->load->model('crmcntsts');
					$lv_prm=array('vewfldflt' =>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord'=>($i==0?'s.crmcntststxt':$lv_colstsord) );
					$lo_stsrs=$lo_cntsts->getList($lv_prm, null, null, false);
					$this->lo_mdl->sts = $lo_stsrs;
				}
        
        // cargo parámetro de contacto
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
        $lo_prmmdl->load(array('mdlcod'=>'CRM'));
        $this->lo_mdl->cardInfo = $this->co_reg->document->getTagValue(strtoupper($lo_prmmdl->mdlatrval001),'KANBAN_CARD_INFO');
				
        // cargo rol de usuario
        $lo_usrgrpmdl = $this->co_reg->load->model('syssecusrgrp');
        if( $lo_usrgrpmdl->load( array('usrcod'=>$this->co_reg->sec->usrcod) ) ) {
          $this->lo_mdl->usrgrp = $lo_usrgrpmdl->getData();
        }
        
				return $this->co_reg->document->getView('crmcntkan', array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;
			
			
			//   C O N T A C T    C E N T E R 
			case '#ctr':
				$lo_post = $this->co_reg->request->post;
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');

				// cargo clase de documento informada
				if( ($lo_post['sysdocclscod']??'')!=''){
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					} else {
						echo 'No se pudo cargar la clase de documento informada ['.$lo_post['sysdocclscod'].']';
					}
				} else {
					// ------------------------------------------------
					// obtengo clase de documento
					// ------------------------------------------------
					$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
					if ( $lv_docclscod=='' ) {															// si no se indic�
						$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																					'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																					);
						$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
						if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
							$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
						} else {
							return $this->co_reg->document->getView('sysdocclslst', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'],'url'=>'?prg='.self::CONTROLLER.'&act=ctr','doccls'=>$lv_docclsarr));
						}
					}
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					} else {
						echo 'No se pudieron cargar los datos de la clase de documento.';
					}
					// ------------------------------------------------
				}

				// SIN REFERENCIA -> nuevo contacto
				$lv_srcobjtyp = $this->co_reg->document->getTagValue( $this->lo_mdl->sysdoccls->sysdocclsatr, 'srcobjtyp' );
				if ( $lv_srcobjtyp=='' ) {
					$this->lo_mdl->create();
					$this->data['actcod'] = '01';
					$this->lo_mdl->crmcntsrctyp = ($lp_prm['crmcntsrctyp']??'');
					$this->lo_mdl->crmcntsrccod = ($lp_prm['crmcntsrccod']??'');
					$this->lo_mdl->crmcntsrctxt = ($lp_prm['crmcntsrctxt']??'');
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));

				// CON REFERENCIA -> centro de contacto
				} else if( ($lo_post['crmcntsrccod']??'')!='' ) {
					$this->lo_mdl->create();
					$this->lo_mdl->crmcntsrctyp = $lv_srcobjtyp;
					$this->lo_mdl->crmcntsrccod = $lo_post['crmcntsrccod'];
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					switch($lv_srcobjtyp){
						case 'SLS_CUS':
							$lo_cntmdl = $this->co_reg->load->model('slscus');
							$lo_cntmdl->load(array('cuscod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->custxt;
							break;
						case 'BUY_SUP':
							$lo_cntmdl = $this->co_reg->load->model('buysup');
							$lo_cntmdl->load(array('supcod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->suptxt;
							break;
						case 'HLT_PAT':
							$lo_cntmdl = $this->co_reg->load->model('hltpat');
							$lo_cntmdl->load(array('patcod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->pattxt;
							break;
						case 'HLT_PRS':
							$lo_cntmdl = $this->co_reg->load->model('hltprs');
							$lo_cntmdl->load(array('prscod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->prstxt;
							break;
						case 'EDU_STU':
							$lo_cntmdl = $this->co_reg->load->model('edustu');
							$lo_cntmdl->load(array('stucod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->stutxt;
							break;
						case 'EDU_TCH':
							$lo_cntmdl = $this->co_reg->load->model('edutch');
							$lo_cntmdl->load(array('tchcod'=>$lo_post['crmcntsrccod']), false);
							$this->lo_mdl->crmcntsrctxt = $lo_cntmdl->tchtxt;
							break;
					}
					$this->lo_mdl->cntphn001 = $lo_cntmdl->adr->adrphn001;
					$this->lo_mdl->cntphn002 = $lo_cntmdl->adr->adrphn002;
					$this->lo_mdl->cntmbl = $lo_cntmdl->adr->adrmblphn;
					$this->lo_mdl->cnteml = $lo_cntmdl->adr->adreml;
					$this->lo_mdl->cntidt = $lo_cntmdl->tax->taxcod;
          return $this->co_reg->document->getView('crmcntctr', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				} else {
					return $this->co_reg->document->getView('crmcntctr', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				}
        break;			
			
			
			// LIST. lista los documentos
			case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;				
        if ( $this->lo_mdl->save($lo_post) ) {
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->crmcntcod	) );

					// recargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
          
					return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
      
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				
				// ------------------------------------------------
				// obtengo clase de documento
				// ------------------------------------------------
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = ($lo_post['sysdocclscod']??'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView('sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) )) { // obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				// ------------------------------------------------
				
				// valores x default desde formulario que llama
				$this->lo_mdl->crmcntduedte = ($lo_post['crmcntduedte']?? $lp_prm['crmcntduedte']??'');
				$this->lo_mdl->crmcntsrctyp = ($lo_post['crmcntsrctyp']?? $lp_prm['crmcntsrctyp']??'');
				$this->lo_mdl->crmcntsrccod = ($lo_post['crmcntsrccod']?? $lp_prm['crmcntsrccod']??'');
				$this->lo_mdl->crmcntsrctxt = ($lo_post['crmcntsrctxt']?? $lp_prm['crmcntsrctxt']??'');
				
				return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación o visualización
			case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post; 
				$lv_key = array();

				// get param (KEY)
				$lv_key = array( self::ID=>( $lp_prm[self::ID] ?? $lo_post[self::ID] ?? '' ) );

				// load object
				if ( $lv_key[self::ID]=='' ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->crmcntcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
        
        // cargo rol de usuario
        $lo_usrgrpmdl = $this->co_reg->load->model('syssecusrgrp');
        if( $lo_usrgrpmdl->load( array('usrcod'=>$this->co_reg->sec->usrcod) ) ) {
          $this->lo_mdl->usrgrp = $lo_usrgrpmdl->getData();
        }
				return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST. Devuelve la lista de contactos
      case '#18':
        $lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>(isset($lo_post['crmcntstrdte']) && isset($lo_post['crmcntenddte']) ? '[~fltrow~]c.crmcntduedte'.chr(9).'BT'.chr(9).chr(9).$lo_post['crmcntstrdte'].chr(9).$lo_post['crmcntenddte'].chr(9) : '').
																			(($lo_post['vewfldflt']??'')!=''?html_entity_decode($lo_post['vewfldflt']):''),
												'vewfldord'	=> ($lo_post['vewfldord']??''),
												'vewmaxrec'	=> ($lo_post['vewmaxrec']??'100')
												);
				$lo_rs = $this->lo_mdl->getList($lv_prm);

        return $this->co_reg->document->getJson( $lo_rs );
        break;
      
			// LIST. Devuelve la lista de contactos
      case '#28':
        $lo_post = $this->co_reg->request->post;        
				$lv_prm = array('vewfldflt' =>(isset($lo_post['crmcntstrdte']) && isset($lo_post['crmcntenddte']) ? '[~fltrow~]c.crmcntduedte'.chr(9).'BT'.chr(9).chr(9).$lo_post['crmcntstrdte'].chr(9).$lo_post['crmcntenddte'].chr(9) : '').
																			(($lo_post['vewfldflt']??'')!=''?html_entity_decode($lo_post['vewfldflt']):''),
												'vewfldord'	=> ($lo_post['vewfldord']??''),
												'vewmaxrec'	=> ($lo_post['vewmaxrec']??'100')
												);
				$lo_rs = $this->lo_mdl->getListKanban($lv_prm);
        return $this->co_reg->document->getJson( $lo_rs );
        break;

        
			// GET HISTORY. devuelve la lista de contactos de un origen
      case '#19':
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['crmcntsrctyp'].chr(9).chr(9).
																			'[~fltrow~]c.crmcntsrccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['crmcntsrccod'].chr(9).chr(9),
                      	'vewmaxrec'	=> '100',
                       	'vewfldord'	=>'c.ctedte DESC');
        $lo_rs = $this->lo_mdl->getList( $lv_prm );
        return $this->co_reg->document->getJson( $lo_rs );
        break;
			
			
			// CNT ASG. devuelve la vista de asignacion(responder) del contacto
			case '#cntasg':
				$lo_post = $this->co_reg->request->post;				
				$this->lo_mdl->load( array('crmcntcod'=>$lo_post['crmcntcod']) );
				
				// recupero estados del motivo de contacto segun usuario actual
				$lo_mtvstsmdl = $this->co_reg->load->model('crmcntmtvsts');
				$lv_prm = array('vewfldflt'	=>'[~fltrow~]ms.crmcntmtvcod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->crmcntmtvcod .chr(9).chr(9).
																			'[~fltrow~](ms.crmcntstscodstr=^'.$this->lo_mdl->crmcntstscod.'^ or ms.crmcntstscodend=^0^)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~](ms.crmcntstsusrcod=^^ or dbo.CheckUserRole(^'.$this->co_reg->sec->buscod.'^,^'.$this->co_reg->sec->usrcod.'^,ms.CrmCntStsUsrCod)=1 )'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~]ms.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                       								'[~fltrow~](cs1.docsts=^A^ or cs1.docsts IS NULL)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                        							'[~fltrow~](cs2.docsts=^A^ or cs2.docsts IS NULL)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
                       								);
				$this->lo_mdl->crmcntmtvsts = $lo_mtvstsmdl->getList($lv_prm);
				
        return $this->co_reg->document->getView('crmcntasg', array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;
			
			//! Codigo para trasladar
			// CNT ASG TME. devuelve la vista de agregar horas
			case '#cntasgtme':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->load( array('crmcntcod'=>$lo_post['crmcntcod']) );				
        return $this->co_reg->document->getView('crmcntasgtme', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
			// ACTUALIZAR DATOS. actualiza el contacto con datos especificos enviados por post
			case '#12':
        $lv_res = $this->updateTicket(false);
        return $this->co_reg->document->getJson( $lv_res );
				break;
      
			
      // GRABADO DE HORAS Y PROGRESO
			case '#13':
				$lo_post = $this->co_reg->request->post;
        $lo_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
        $lo_post['hhrtmeregdte'] = $lo_post['crmcntcmtdte'];
        $lo_post['srcobjtyp'] = 'CRM_CNT';
        $lo_post['srcobjcod001'] = $lo_post['crmcntcod'];
        $lo_post['hhrtmesrctyp'] = 'SYS_USR';
        $lo_post['hhrtmesrccod001'] = $lo_post['usrcod'];
        $lo_post['hhrtmeregqty'] = $lo_post['crmcnthrs'];
        $lo_post['docsts'] = 'A';
        $lo_hhrtmereg = $this->co_reg->load->model('hhrtmereg');
        if ($lo_hhrtmereg->save($lo_post)==false) {
          return $this->co_reg->document->getJson(array('errtyp'=>$lo_hhrtmereg->errtyp,'errcod'=>$lo_hhrtmereg->errcod,'errtxt'=>$lo_hhrtmereg->errtxt));
        }
				return $this->co_reg->document->getJson( $lo_ret );
				break;
      
        
        // ACTUALIZAR ORDEN. actualiza el orden de un ticket dentro de los tickets de un usuario o estado específico
			case '#16':
        $lo_post = $this->co_reg->request->post;
				
				//valido si hay que actualizar el ticket (sucede si cambió de usuario o estado)
        if($lo_post['crmcntupd']??''=='true' ){
          $lv_res = $this->updateTicket();
          if($lv_res['errcod'] < 0){
          	return $this->co_reg->document->getJson( $lv_res );
          }
        }
        
        $this->lo_mdl->sortKanban(array(self::ID => $lo_post['crmcntcod'], 'crmcntkanstsord' => $lo_post['crmcntkanstsord'] ?? '', 'crmcntkanusrord' => $lo_post['crmcntkanusrord'] ?? ''));
        
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;
    }
  }
  
  // función para actualizar el ticket en caso de ordenamiento en kanban o respuesta de ticket
  // si es operación 12, u otra que no requiera autorización o haga la validación a nivel vista, se saltea la validación en el llamado al modelo
  private function updateTicket($lp_authCheck=true){
    $lo_post = $this->co_reg->request->post;
    
    // carga datos del contacto
    $this->lo_mdl->load( array('crmcntcod'=>$lo_post['crmcntcod']) );

    // reemplaza los datos del documento por los datos informados por post
    $lo_dat = $this->lo_mdl->getData();
    unset($lo_dat['crmcntkanusrord']);
    unset($lo_dat['crmcntkanstsord']);
    foreach($lo_post as $lv_key=>$lv_val){ $lo_dat[$lv_key]=$lv_val; }

    // convierto variables de tipo fecha
    foreach($lo_dat as $lv_key=>$lv_val){
      if(is_a($lv_val,'DateTime')){ 
        $lo_dat[$lv_key] = date_format($lv_val,'d/m/Y');
      } else if( !isset($lo_post[$lv_key]) && is_string($lv_val) ){
        if($lv_val!=null){ $lo_dat[$lv_key] = utf8_encode($lv_val); }
      }
    }

    $this->lo_mdl->create();

    // graba las modificaciones
    $this->lo_mdl->save($lo_dat, $lp_authCheck);
      
    return array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt);
  }
}
?>