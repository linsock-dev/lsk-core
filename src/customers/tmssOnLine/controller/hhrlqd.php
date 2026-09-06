<?php
final class hhrlqdController extends tmssController {	
	const CONTROLLER = 'hhrlqd';
	const MODEL = 'hhrlqd';
	const VIEW  = 'hhrlqd';
	const ID = 'hhrlqdcod';
	const OBJTYP = 'HHR_LQD';
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

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;		
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','hhrchrasgcod'=>$lo_post['hhrchrasgcod']);

				// CARGO. recupero datos de asignación de cargo.
				$lo_chrmdl = $this->co_reg->load->model('hhrchrasg');
				$lo_chrmdl->load( array('hhrchrasgcod'=>$lo_post['hhrchrasgcod']), false );
				$lo_post['srcobjtxt'] = $lo_chrmdl->srcobjtxt;
				$lo_post['srcobjcod'] = $lo_chrmdl->srcobjcod;
				$lo_post['hhrchrtyptxt'] = $lo_chrmdl->hhrchrtyptxt;
				$lo_post['hhrchrasgatr'] = $lo_chrmdl->hhrchrasgatr;
				$lo_post['hhrchrasgdtestr'] = $lo_chrmdl->hhrchrasgdtestr;
				$lo_post['hhrchrasgdteend'] = $lo_chrmdl->hhrchrasgdteend;
				$lo_post['hhrempinbdte'] = $lo_chrmdl->hhrempinbdte;
				$lo_post['hhrempoutdte'] = $lo_chrmdl->hhrempoutdte;

				// EMPLEADO. cargo los datos del empleado
				if($lo_chrmdl->srcobjtyp=='EDU_TCH'){
					$lo_srcmdl = $this->co_reg->load->model('edutch');
					$lo_srcmdl->load( array('tchcod'=>$lo_chrmdl->srcobjcod), false );
					$lo_srcmdl->hhrempinbdte = $lo_srcmdl->tchinbdte;
					$lo_srcmdl->hhrempoutdte = $lo_srcmdl->tchoutdte;
				} else if($lo_chrmdl->srcobjtyp=='HHR_EMP'){
					$lo_srcmdl = $this->co_reg->load->model('hhremp');
					$lo_srcmdl->load( array('hhrempcod'=>$lo_chrmdl->srcobjcod), false );
					$lo_srcmdl->hhrempinbdte = $lo_srcmdl->hhrempinbdte;
					$lo_srcmdl->hhrempoutdte = $lo_srcmdl->hhrempoutdte;
				}
				$lo_post['hhrmedcovtxt'] = $lo_srcmdl->per->hhrmedcovtxt;
				$lo_post['hhrmedcovcodext'] = $lo_srcmdl->per->hhrmedcovcodext;
				// GRABO. grabo cabecera de liquidacion
        if ( $this->lo_mdl->save($lo_post) ) {
          //Chequear el stm y luego revisar como se ejecuta el storep
          $this->lo_mdl->load( array(self::ID=>$this->lo_mdl->hhrlqdcod	) );
					$lo_prcmdl = $this->co_reg->load->model('grldatprc');
					$lv_buffer = $lo_post['txtprc'];
					if ($lv_buffer!='') {
						$lv_slsprc_arr = json_decode(html_entity_decode($lv_buffer),true);
						foreach( $lv_slsprc_arr as $lv_row2 ) {
							$lv_row2['srcobjtyp'] = 'HHR_LQD';
							$lv_row2['srcobjcod001'] = $this->lo_mdl->hhrlqdcod;
							$lv_row2['srcobjcod002'] = $lo_post['hhrchrasgcod'];
							$lv_row2['prcschcod'] = (isset($lo_post['prcschcod'])?$lo_post['prcschcod']:'');
							$lv_row2['docsts'] = 'A';
							if( !$lo_prcmdl->save( $lv_row2 ) ) {
								$lv_ret['errtyp']=$lo_prcmdl->errtyp;
								$lv_ret['errcod']=$lo_prcmdl->errcod;
								$lv_ret['errtxt']=$lo_prcmdl->errtxt;
								$lv_ret['row']=$i;
								break;
							}
						}
					}
					
          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
				
				} else {
          $lv_ret['errtyp']=$this->lo_mdl->errtyp;
          $lv_ret['errcod']=$this->lo_mdl->errcod;
          $lv_ret['errtxt']=$this->lo_mdl->errtxt;
        } 
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				$lo_post = $this->co_reg->request->post;
				
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm, null, null, false );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
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
			
			
      // CHANGE - DISPLAY. devuelve vista en modo creación o visualización
      case '#02': case '#03':
				$lv_key = array();
				$lo_post = $this->co_reg->request->post;
				
				// get param (KEY)																						
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
		    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
				$this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// OBJETOS DE ORIGEN. devuelve lista de origenes posibles de procesar
			case '#getSources':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo origenes
				$lv_flt = json_decode(html_entity_decode($lo_post['vewflt']),true);
				$lv_prm = array('vewfldflt'=>'[~fltrow~]dc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																		 '[~fltrow~]ca.hhrchrasgdtestr'.chr(9).'<='.chr(9).chr(9).$this->co_reg->db->tsqldate($lo_post['hhrlqdenddte']).chr(9).chr(9).
																		 '[~fltrow~]isnull(ca.hhrchrasgdteend,^9999-12-31^)'.chr(9).'>='.chr(9).chr(9).$this->co_reg->db->tsqldate($lo_post['hhrlqdstrdte']).chr(9).chr(9).
																			$lv_flt['fltstr'],
												'vewmaxrec'=> $lv_flt['maxrec']);
				$lo_rs = $this->lo_mdl->getSources( $lv_prm );
				return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
				break;
			
			
			// CALCULAR. calcula una liquidación
			case '#calc':
				$lo_post = $this->co_reg->request->post;

				// normalizo datos de cabecera recibidos
				$lv_dochdr = array();
				$lv_dochdr_arr = json_decode(html_entity_decode($lo_post['dochdr']),true);
				foreach($lv_dochdr_arr as $lv_key=>$lv_val){
					if( isset($lv_val['name']) && isset($lv_val['value']) ){
						$lv_dochdr[$lv_val['name']] = $lv_val['value'];
					} else {
						$lv_dochdr[$lv_key] = $lv_val;
					}
				}

				// asigno datos de cabecera-precios
				$lv_dat = array();
				$lv_dat['dochdr'] = $lv_dochdr;
				$lv_dat['dochdr']['prcdte'] = $lv_dochdr['hhrlqdstrdte'];
				$lv_dat['dochdr']['prcschcalctr'] = 'hhrlqd';
				$lv_dat['dochdr']['prcschcalact'] = 'calc';
				$lv_dat['docpos'] = array( array() );
				$lv_dat['docprc'] = ((isset($lo_post['docprc']) && $lo_post['docprc'] != '' )?$lo_post['docprc']:array()); //json_decode(html_entity_decode(isset($lo_post['docprc'])?$lo_post['docprc']:'[]'),true);
				
				// LIQUIDACION
				$lv_dat['docpos']['hhrlqd'] = $lv_dochdr;
				$lv_dat['docpos']['hhrlqd']['hhrlqddte'] = date_create_from_format('d/m/Y',$lv_dat['docpos']['hhrlqd']['hhrlqddte']);
				$lv_dat['docpos']['hhrlqd']['hhrlqdstrdte'] = date_create_from_format('d/m/Y',$lv_dat['docpos']['hhrlqd']['hhrlqdstrdte']);
				$lv_dat['docpos']['hhrlqd']['hhrlqdenddte'] = date_create_from_format('d/m/Y',$lv_dat['docpos']['hhrlqd']['hhrlqdenddte']);
				
				// ASIGNACION. obtengo info de asignacion
				$lo_hhrchrasgmdl = $this->co_reg->load->model('hhrchrasg');
				$lo_hhrchrasgmdl->load( array('hhrchrasgcod'=>$lv_dochdr['hhrchrasgcod']), false );
				$lv_dat['docpos']['hhrchrasg'] = $lo_hhrchrasgmdl->getData();
        
        // EDUCACION - LUGAR DE ESTUDIO
        $lv_stdloccod = $this->co_reg->document->getTagValue($lo_hhrchrasgmdl->hhrchrasgatr,'stdloccod');
        if($lo_hhrchrasgmdl->srcobjtyp=='EDU_TCH' && $lv_stdloccod!=''){
          $lo_stdlocmdl = $this->co_reg->load->model('edustdloc');
          $lo_stdlocmdl->load( array('stdloccod'=>$lv_stdloccod), false );
          $lv_dat['docpos']['hhrchrasg']['stdloccod'] = $lo_stdlocmdl->stdloccod;
          $lv_dat['docpos']['hhrchrasg']['stdloccodext'] = $lo_stdlocmdl->stdloccodext;
          $lv_dat['docpos']['hhrchrasg']['stdloctxt'] = $lo_stdlocmdl->stdloctxt;
        }
          
				// TIPO CARGO. obtengo info de cargo
				$lo_hhrchrtypmdl = $this->co_reg->load->model('hhrchrtyp');
				$lo_hhrchrtypmdl->load( array('hhrchrtypcod'=>$lo_hhrchrasgmdl->hhrchrtypcod) );
				$lv_dat['docpos']['hhrchrtyp'] = $lo_hhrchrtypmdl->getData();
        $lv_dat['docpos']['hhrchrtyp']['hhrchrtypatrtmeasg'] = $this->co_reg->document->getTagValue($lo_hhrchrtypmdl->hhrchrtypatr, 'tmeasg');
				
				// CLASE CARGO. obtengo info de la clase de cargo
				$lo_hhrchrclsmdl = $this->co_reg->load->model('hhrchrcls');
				$lo_hhrchrclsmdl->load( array('hhrchrclscod'=>$lo_hhrchrtypmdl->hhrchrclscod) );
				$lv_dat['docpos']['hhrchrcls'] = $lo_hhrchrclsmdl->getData();
				
				// CONVENIO. obtengo info de convenio
				$lo_hhragrmdl = $this->co_reg->load->model('hhragr');
				if($lo_hhrchrasgmdl->hhragrcod!=''){
					$lo_hhragrmdl->load( array('hhragrcod'=>$lo_hhrchrasgmdl->hhragrcod) );
				}
				$lv_dat['docpos']['hhragr'] = $lo_hhragrmdl->getData();
				
				// SINDICATO. obtengo info de sindicato
				$lo_hhrlabunimdl = $this->co_reg->load->model('hhrlabuni');
				if($lo_hhrchrasgmdl->hhrlabunicod!=''){
					$lo_hhrlabunimdl->load( array('hhrlabunicod'=>$lo_hhrchrasgmdl->hhrlabunicod) );
				}
				$lv_dat['docpos']['hhrlabuni'] = $lo_hhrlabunimdl->getData();
				
				/*
				// LICENCIAS. obtiene un resumen de licencias para el cargo que se quiere liquidar
				$lo_hhrlicmdl = $this->co_reg->load->model('hhrlic');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]lc.hhrchrasgcod'.chr(9).'='.chr(9).chr(9).$lo_post['hhrchrasgcod'].chr(9).chr(9).
																			'[~fltrow~]l.hhrassdte'.chr(9).'>='.chr(9).chr(9). $lv_dat['docpos']['hhrlqd']['hhrlqdstrdte']->format('Y-m-d') .chr(9).chr(9).
																			'[~fltrow~]l.hhrassdte'.chr(9).'<='.chr(9).chr(9). $lv_dat['docpos']['hhrlqd']['hhrlqdenddte']->format('Y-m-d') .chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldgrpcal'=>' SUM( (CASE WHEN l.hhrassflg=0 THEN CAST(dbo.getTagValue(^hrs^,lc.hhrasschratr) as INT) ELSE 0 END) ) as hhrassflg000hrs '.
																				' ,SUM( (CASE WHEN l.hhrassflg=1 THEN CAST(dbo.getTagValue(^hrs^,lc.hhrasschratr) as INT) ELSE 0 END) ) as hhrassflg001hrs '
												);
				$lo_hhrlicrs = $lo_hhrlicmdl->getList( $lv_prm );
				$lv_dat['docpos']['hhrlic'] = (count($lo_hhrlicrs)>0?$lo_hhrlicrs[0]:array());

select l.HhrLicCodExt, l.HhrLicDteStr, l.HhrLicDteEnd, lt.hhrlictypcodext, lt.hhrlictyptxt, dbo.gettagvalue('rem',lt.hhrlictypatr) as hhrlictypatrrem, dbo.gettagvalue('hrs',lc.hhrlicchratr) as hhrlicchratrhrs 
from HHR_LIC l
inner join HHR_LIC_TYP lt on lt.BusCod=l.BusCod and lt.HhrLicTypCod=l.HhrLicTypCod
inner join HHR_LIC_CHR lc on lc.BusCod=l.BusCod and lc.hhrliccod=l.HhrLicCod
where l.buscod = 'TEMASIS_EDU'
and l.SrcObjTyp = '.$lo_post['srcobjtyp']
and l.SrcObjCod = '.$lo_post['srcobjcod'] 
and l.DelDte is null
and lc.HhrChrAsgCod = '.$lo_post['hhrchrasgcod']
and l.HhrLicDteStr <= '.$lv_dat['docpos']['hhrlqd']['hhrlqdenddte']->format('Y-m-d')
and l.HhrLicDteEnd >= '.$lv_dat['docpos']['hhrlqd']['hhrlqdstrdte']->format('Y-m-d')

				// SUPLENCIAS. obtiene un resumen de suplencias
				$lo_hhrsubmdl = $this->co_reg->load->model('hhrsub');
				$lo_hhrsubrs = $lo_hhrsubmdl->getList( $lv_prm );
				$lv_dat['docpos']['hhrsub'] = $lo_hhrsubrs;
				*/
				
				// ASISTENCIAS. obtiene un resumen de las inasistencias
				$lo_hhrassmdl = $this->co_reg->load->model('hhrass');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]lc.hhrchrasgcod'.chr(9).'='.chr(9).chr(9).$lv_dochdr['hhrchrasgcod'].chr(9).chr(9).
																			'[~fltrow~]l.hhrassdte'.chr(9).'>='.chr(9).chr(9). $lv_dat['docpos']['hhrlqd']['hhrlqdstrdte']->format('Y-m-d') .chr(9).chr(9).
																			'[~fltrow~]l.hhrassdte'.chr(9).'<='.chr(9).chr(9). $lv_dat['docpos']['hhrlqd']['hhrlqdenddte']->format('Y-m-d') .chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldgrpcal'=>' SUM( (CASE WHEN l.hhrassflg=0 THEN CAST(dbo.getTagValue(^hrs^,lc.hhrasschratr) as INT) ELSE 0 END) ) as hhrassflg000hrs '.
																				' ,SUM( (CASE WHEN l.hhrassflg=1 THEN CAST(dbo.getTagValue(^hrs^,lc.hhrasschratr) as INT) ELSE 0 END) ) as hhrassflg001hrs '
												);
				$lo_hhrassrs = $lo_hhrassmdl->getChargesList( $lv_prm );
				$lv_dat['docpos']['hhrass'] = (count($lo_hhrassrs)>0?$lo_hhrassrs[0]:array());
        
				
				// OBJETO. cargo objeto de origen de la asignacion de cargo.
				$lo_objtypmdl = $this->co_reg->load->model('sysobjtyp');
				$lo_objtypmdl->load( array('objtypcod'=>$lo_hhrchrasgmdl->srcobjtyp) );
				
				// PERSONAL. obtengo info de personal
				$lo_permdl = $this->co_reg->load->model($lo_objtypmdl->objtypctr);
				$lo_permdl->load( array($lo_objtypmdl->objtypkey => $lv_dochdr['srcobjcod']), false ); 
				$lv_dat['docpos']['hhremp'] = $lo_permdl->getData();
				unset($lv_dat['docpos']['hhremp']['adr']);
				unset($lv_dat['docpos']['hhremp']['tax']);
				unset($lv_dat['docpos']['hhremp']['bnk']);
				unset($lv_dat['docpos']['hhremp']['per']);
        
				//$lv_dat['docpos']['hhremp']['adr'] = $lo_permdl->adr->getData();
				//$lv_dat['docpos']['hhremp']['tax'] = $lo_permdl->tax->getData();
				//$lv_dat['docpos']['hhremp']['bnk'] = $lo_permdl->bnk->getData();
				//$lv_dat['docpos']['hhremp']['per'] = $lo_permdl->per->getData();
        
        // CONTACTOS. obtiene los contactos del empleado
				$lo_grldatcntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lv_dat['docpos']['hhrchrasg']['srcobjtyp'].chr(9).chr(9).
                        							'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lv_dat['docpos']['hhrchrasg']['srcobjcod'].chr(9).chr(9)
												);
        $lo_rs = $lo_grldatcntmdl->getList($lv_prm,null,null,false);
				
        $lo_permdl = $this->co_reg->load->model('grldatper');
        $lv_dat['docpos']['hhremp']['cnt'] = array();
        foreach($lo_rs as $key=>$lv_row){
       
          // cargo modelo de personas con el codigo de cada contacto
          $lo_permdl->create();
          $lo_permdl->load( array('persrctyp'=>'GRL_CCT', 'persrccod'=>$lv_row['cntcod'] ) );
          
          // asigno los datos necesarios
          $lv_dat['docpos']['hhremp']['cnt'][$key] = $lo_permdl->getData();
          $lv_dat['docpos']['hhremp']['cnt'][$key]['sysdocclscodext'] = $lv_row['sysdocclscodext'];
        }
				
				// realizo cálculo de precios
				$lo_prc = $this->co_reg->load->controller('grldatprc');
				$lv_out = $lo_prc->calculate( $lv_dat );
				return $this->co_reg->document->getJson( $lv_out );
				break;
			
			
			
			// ----------------------------------------------------------------------
			// SHOW DETAIL
			// muestra en pantalla el detalle de una posicion de la factura
			// 	input:
			//		- dochdr (array): datos de cabecera del documento
			//		- docpos (array): datos de posicion del documento
			//		- docposinx (int): nro de posicion
			//		- dochdrprc (array): esquema de precios de cabecera
			//		- docposprc (array): esquemas de precio de todas las posiciones
			//	output:
			//		- (string): vista "slsinvpos"
			// ----------------------------------------------------------------------
      case '#13':
				$lo_post = $this->co_reg->request->post;

				// normalizo los datos recibidos
				$this->lo_mdl->dochdr = (isset($lo_post['dochdr'])?$lo_post['dochdr']:'{}');
				$this->lo_mdl->docpos = (isset($lo_post['docpos'])?$lo_post['docpos']:'{}');
				$this->lo_mdl->docprc = (isset($lo_post['docprc'])?$lo_post['docprc']:'[]');
				$this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'false');
				$this->lo_mdl->sec = ((isset($lo_post['sec'])?$lo_post['sec']:''));
				// obtengo el id de clase de documento
				$lv_dochdr = array();
				$lv_dochdr_arr = JSON_decode(html_entity_decode($this->lo_mdl->dochdr),true);
				foreach($lv_dochdr_arr as $lv_row){$lv_dochdr[$lv_row['name']] = $lv_row['value'];} 
				$lv_dochdr['prcschcalctr'] = 'hhrlqd';
				$lv_dochdr['prcschcalact'] = 'calc';
				$this->lo_mdl->dochdr = $lv_dochdr;

				$lv_docpos = array();
				$lv_docpos_arr = JSON_decode(html_entity_decode($this->lo_mdl->docpos),true);
				foreach($lv_docpos_arr as $lv_row){$lv_docpos[$lv_row['name']] = $lv_row['value'];} 
				$this->lo_mdl->docpos = $lv_docpos;
				
				// recupero datos de la clase de documento
				if(!isset($lv_dochdr['sysdocclscod'])){
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'Formato de comunicacion invalido. No se declaro [sysdocclscod] en cabecera.') );
				} else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$lv_dochdr['sysdocclscod']) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				// devuelvo la vista
		    return $this->co_reg->document->getView( 'hhrlqddet', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
      
      
      
			
			
      // ----------------------------------------------------------------------
			//
			//   A R G E N T I N A
			//
			// ----------------------------------------------------------------------
			
			
			
			
			
			// F-931
			// realiza la descarga en .TXT del formulario 931 basado en los datos del período liquidado AAAA.MM
			// ver.41
			case '#arg_f931':
				$lo_post = $this->co_reg->request->post;
        
        // recupero zona de la empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod), false);
        $lv_buszon = $lo_busmdl->adr->adrzon;
        
        if(!isset($lo_post['download'])){
		    	return $this->co_reg->document->getView( 'hhrlqd_arg_f931', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        }
        
        $lv_date = DateTime::createFromFormat('m/Y', $lo_post['term']);

				// LIQUIDACION. cargo datos de liquidación de grupo
				/*$lv_buffer = '';
        $lo_lqdgrpmdl = $this->co_reg->load->model('hhrlqdgrp');
				$lo_lqdgrpmdl->load( array('hhrlqdgrpcod'=>$lp_prm['hhrlqdgrpcod']) );*/
        
        // LIQUIDACIÓN. cargo datos de las liquidaciones del período
        $lo_lqdmdl = $this->co_reg->load->model('hhrlqd');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]l.hhrlqdstrdte'.chr(9).'<='.chr(9).chr(9). $lv_date->format('Ym').'01' .chr(9).chr(9).
                        							'[~fltrow~]l.hhrlqdenddte'.chr(9).'>='.chr(9).chr(9). $lv_date->format('Ym').'01' .chr(9).chr(9)
                       );
				$lo_rs = $lo_lqdmdl->getList( $lv_prm, null, null, false );
        if(count($lo_rs) < 1){ return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No existe ninguna liquidaci&oacute;n en este per&iacute;odo. ['.$lv_date->format('Ym').']') ); }

				// armo lista de IDs de liquidaciones encontradas en el periodo
        $lv_lqdarr = '';
        foreach($lo_rs as $lv_row) {
          $lv_lqdarr .= ($lv_lqdarr==''?'':chr(10)).$lv_row['hhrlqdcod'];
				}
        
				
        // PRECIOS. cargo los precios de la liquidaciones
        $lo_prcmdl = $this->co_reg->load->model('grldatprc');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_LQD'.chr(9).chr(9).
                        							'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). $lv_lqdarr .chr(9).chr(9) 
                       );
        $lo_prcrs = $lo_prcmdl->getList($lv_prm);

        
        // INTERFAZ. cargo interfaz de F-931
        $lo_intmdl = $this->co_reg->load->model('sysint');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'ARG_F931'.chr(9).chr(9) );
        $lo_intrs = $lo_intmdl->getList($lv_prm);
        if(count($lo_intrs) < 1){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-2, 'errtxt'=>'Falta configuraci&oacute;n de interfaces ARG_F931.') );
        }
        $lv_intatr = $lo_intrs[0]['sysintatr'];
        
        
        // REDUCTOR. reduzco los cargos a uno por persona sumando precios y obteniendo código de cargo
        $lo_doc = array();
        foreach($lo_rs as $lv_row){
          $lo_tmpdoc = array();
          $lv_found = -1;
					
					// busca si la persona ya fue agregada al array
          foreach($lo_doc as $lv_key => $lv_row2){
            if($lv_row2['srcobjcod001'] == $lv_row['srcobjcod001']){
              $lv_found=$lv_key;
              break;
            }
          }
          
					// carga los precios de la liquidación en un array
          $lv_prcarr = array();
          foreach($lo_prcrs as $lv_prcrow){
            if($lv_prcrow['srcobjcod001'] == $lv_row['hhrlqdcod'] && $lv_prcrow['prccndstd']!=''){
              $lv_prcarr[ $lv_prcrow['prcschcndrow'] ]['prccndval'] = $lv_prcrow['prccndval'];
              $lv_prcarr[ $lv_prcrow['prcschcndrow'] ]['prccnduntcod'] = $lv_prcrow['prccnduntcod'];
              $lv_prcarr[ $lv_prcrow['prcschcndrow'] ]['prccndqty'] = $lv_prcrow['prccndqty'];
              $lv_prcarr[ $lv_prcrow['prcschcndrow'] ]['prccndtot'] = $lv_prcrow['prccndtot'];
            }
          }

          $lo_tmpdoc['prcarr'] = $lv_prcarr;
          $lo_tmpdoc['srcobjcod001'] = $lv_row['srcobjcod001'];
          $lo_tmpdoc['srcobjtxt'] = $this->co_reg->document->getTagValue($lv_row['hhrlqdatr001'], 'srcobjtxt');
          if(!isset($lv_row['hhragrcodext']) || $lv_row['hhragrcodext'] == '' ){$lv_row['hhragrcodext']='PROG';}
          $lo_tmpdoc['actcod'] = $this->co_reg->document->getTagValue($lv_intatr, 'ACT_CONV_'.$lv_row['hhragrcodext']);
          $lo_tmpdoc['taxcod'] = $lv_row['taxcod'];
          $lo_tmpdoc['bnkacccbu'] = $lv_row['bnkacccbu'];
          $lo_tmpdoc['hhrlqdatr001'] = $lv_row['hhrlqdatr001'];
					$lo_tmpdoc['hhrlqddte'] = $lv_row['hhrlqddte'];
					$lo_tmpdoc['firstday'] = $lv_row['hhrlqdstrdte']; //primer día de trabajo
					$lo_tmpdoc['lastday'] = $lv_row['hhrlqdenddte']; //último día de trabajo
          
					// remuneración imponible. Se almacena en un array que tiene como índice el código de cargo
					// ej: $lv_remimp[16] = 80000
					//  	 $lv_remimp[92] = 13000
          $lv_tmptotrem = (isset($lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTREM') ]) ? $lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTREM') ]['prccndtot'] : 0);
					$lo_tmpdoc['totrem'][$lo_tmpdoc['actcod']] = $lv_tmptotrem; // Remuneración imponible 1 82 12

          $lv_tmptotnorem = (isset($lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTNOREM') ]) ? $lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTNOREM') ]['prccndtot'] : 0);
					$lo_tmpdoc['totnorem'][$lo_tmpdoc['actcod']] = $lv_tmptotnorem; // Remuneración imponible 1 82 12
					
					// SAC. Se almacena en un array que tiene como índice el código de cargo
          $lv_sac = (isset($lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_SAC') ]) ? $lo_tmpdoc['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_SAC') ]['prccndtot'] : 0);
					$lo_tmpdoc['sac'][$lo_tmpdoc['actcod']] = $lv_sac;
					$lo_tmpdoc['actcodarr'][] = $lo_tmpdoc['actcod'];
          
          // primer cargo de la persona, se agrega al array
          if($lv_found < 0){
            array_push($lo_doc, $lo_tmpdoc);
            
          // siguientes cargos de la persona
          }else{
            // si la fecha de inicio es anterior, usa esa fecha
            if($lv_row['hhrlqdstrdte']->diff($lo_doc[$lv_found]['firstday'])->format('d') > 0){
              $lo_doc[$lv_found]['firstday'] = $lv_row['hhrlqdstrdte'];
            }
            // si la fecha de fin es posterior, usa esa fecha
            if($lv_row['hhrlqdenddte']->diff($lo_doc[$lv_found]['firstday'])->format('d') > 0){
              $lo_doc[$lv_found]['lastday'] = $lv_row['hhrlqdenddte'];
            }
            if(intval($lo_doc[$lv_found]['actcod']) < intval($lo_tmpdoc['actcod']) ){
            	$lo_doc[$lv_found]['actcod'] = $lo_tmpdoc['actcod'];
            }
            
          	if(!in_array($lo_doc[$lv_found]['actcod'], $lo_doc[$lv_found]['actcodarr'])){ $lo_doc[$lv_found]['actcodarr'][] = $lo_doc[$lv_found]['actcod']; }
            
            // remuneración imponible. Se almacena en un array que tiene como índice el código de cargo
            $lo_doc[$lv_found]['totrem'][$lo_doc[$lv_found]['actcod']] = (isset($lo_doc[$lv_found]['totrem'][$lo_doc[$lv_found]['actcod']]) ? $lo_doc[$lv_found]['totrem'][$lo_doc[$lv_found]['actcod']] + $lv_tmptotrem : $lv_tmptotrem); // Remuneración imponible 1 82 12
            
            // total no remunerativo
            $lo_doc[$lv_found]['totnorem'][$lo_doc[$lv_found]['actcod']] = (isset($lo_doc[$lv_found]['totnorem'][$lo_doc[$lv_found]['actcod']]) ? $lo_doc[$lv_found]['totnorem'][$lo_doc[$lv_found]['actcod']] + $lv_tmptotnorem : $lv_tmptotnorem); // Remuneración imponible 1 82 12
            
            // SAC. Se almacena en un array que tiene como índice el código de cargo
            $lo_doc[$lv_found]['sac'][$lo_doc[$lv_found]['actcod']] = (isset($lo_doc[$lv_found]['sac'][$lo_doc[$lv_found]['actcod']]) ? $lo_doc[$lv_found]['sac'][$lo_doc[$lv_found]['actcod']] + $lv_sac : $lv_sac); // Remuneración imponible 1 82 12
            
            // sumo o creo condiciones de precios de la persona
            foreach($lo_tmpdoc['prcarr'] as $lv_key => $lv_prcrow){
              $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndval'] = isset($lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndval']) ? $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndval'] + $lv_prcrow['prccndval'] : $lv_prcrow['prccndval'];
              $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndqty'] = isset($lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndqty']) ? $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndqty'] + $lv_prcrow['prccndqty'] : $lv_prcrow['prccndqty'];
              $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndtot'] = isset($lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndtot']) ? $lo_doc[$lv_found]['prcarr'][ $lv_key ]['prccndtot'] + $lv_prcrow['prccndtot'] : $lv_prcrow['prccndtot'];
            }
              
          }
        }
				
				
        $lv_buffer = '';
				
				// Registro tipo '01' - Datos referenciales del envío (Liquidación de SyJ y datos para DJ F931) 
				$lv_buffer .= '01';			// Fijo '01'	1 	2
				$lv_buffer .= str_pad($lo_busmdl->tax->taxcod,11);	// CUIT del empleador 	3		13
				$lv_buffer .= 'SJ';			// Identificacion del Envio (Valores permitidos. 'SJ'=Informa la liquidación de SyJ y datos de la DJ F931; 'RE'=Sólo informa datos de la DJ F931 a rectificar)		14	15
				$lv_buffer .= date_format($lv_date,'Ym'); // Periodo (Es el período de la liquidación de SyJ o de la DJ. Formato: AAAAMM)	16	21
				$lv_buffer .= 'M'; 			// Tipo de Liquidacion (- Si "identificación del envío='SJ'" los valores permitidos son: 'M'=mes; 'Q'=quincena; 'S'=semanal /- Si "identificación del envío='RE'", en blanco) 	22 	22
				$lv_buffer .= str_pad($lv_row['hhrlqdcod'],5,'0',STR_PAD_LEFT); 	// Numero de Liquidacion (Si "identificación del envío='SJ'" contendrá el número de liquidación del empleador // Si "identificación del envío='RE'", dejar en blanco )
				$lv_buffer .= '30'; 		// Dias Base (Valor fijo '30'. Si “identificación del envío” es igual a “RE”, dejar en blanco.) 28	29
				$lv_buffer .= str_pad(count($lo_doc),6,'0',STR_PAD_LEFT);	// Cantidad de trabajadores informados en registros '04' (6 enteros. Debe coincidir con la cantidad de registros tipo ‘04’ informados en el archivo (emplados propios y no propios))	 30	35
				$lv_buffer .= chr(10);
				
        foreach($lo_doc as $lv_row){
					
					/*
          $lv_totrem = (isset($lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTREM') ]) ? $lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTREM') ]['prccndtot'] : 0);
          $lv_totnorem = (isset($lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTNOREM') ]) ? $lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_TOTNOREM') ]['prccndtot'] : 0);
          $lv_difos = (isset($lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_DIFOS') ]) ? $lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_DIFOS') ]['prccndtot'] : 0);
          $lv_cantdias =  $lv_row['firstday']->diff( $lv_row['lastday'] )->format('%D') ; // cantidad de dias del período INICIO-FIN
          
          $lv_asgfam = 0; // suma filas 715 - 727 (asignaciones familiares)
          // recurro precios y sumo asignaciones familiares
          foreach($lv_row['prcarr'] as $lv_keyprc=>$lv_rowprc){
            if(strpos($this->co_reg->document->getTagValue($lv_intatr, 'ROW_ASGFAM'), $lv_keyprc) === true){
              $lv_asgfam += $lv_rowprc['prccndtot'];
            }
          }  
          $lv_modcont = '008';
          $lv_cantadherentes = '0'; // Cantidad de adherentes 68 2 personas a cargo para OOSS. Queda en 0. Puede modificarse a mano.
          
          // Usar constantes de interfaz para códigos?
          $lv_impcod = 0;
          foreach($lv_row['totrem'] as $lv_keyimp => $lv_rowimp){
            // tomo los códigos. Si no es 16, lo piso y lo utilizo
            if($lv_impcod == 0 || $lv_impcod == 16){ $lv_impcod = $lv_keyimp; }
          }
          $lv_remimp = (isset($lv_row['totrem'][$lv_impcod]) ? $lv_row['totrem'][$lv_impcod] : 0); // Remuneración imponible 1 82 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
          
          //total remunerativo + incentivo
        						// ACTIVIDAD 16/ (mixto 92-16) / (mixto 39-16) - TOTAL REMUNERATIVO + INCENTIVO (row600	RESOLUCION 2/04)
                    // ACTIVIDAD 49/92/39 - TOTAL REMUNERATIVO
          // verifico si hay un 16 y me quedo con eso
          $lv_includeinc = false;
          foreach($lv_row['actcodarr'] as $lv_rowact){
            if($lv_rowact == 16){
              $lv_includeinc = true;
              break;
            }
          }
          $lv_remimpinc = $lv_totrem;
          if($lv_includeinc){
          	$lv_remimpinc +=  (isset($lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_INCENTIVO') ]) ? $lv_row['prcarr'][ $this->co_reg->document->getTagValue($lv_intatr, 'ROW_INCENTIVO') ]['prccndtot'] : 0);
          }
          
          // SAC
          $lv_impcod = 0;
          foreach($lv_row['sac'] as $lv_keysac => $lv_rowsac){
            // tomo los códigos. Si no es 16, lo piso y lo utilizo
            if($lv_impcod == 0 || $lv_impcod == 16){ $lv_impcod = $lv_rowimp; }
          }
          $lv_sac = 0; // SAC 272 12
                                                              // ACTIVIDAD 92/39/16 - suma de todos los recibos (row230 - SAC)
                                                              // si hay mixto - SAC solo del 92 o 39
          $lv_totnoremcod = $lv_totnorem + (isset($lv_row['totrem']['16']) ? $lv_row['totrem']['16'] : 0); // Conceptos No remunerativos 406 12
                                                              // suma row899-TOTAL NO REMUNERATIVO
                                                              // concepto no remunerativo row 899
                                                              // si es mixto TOTAL remunerativo el código 16 + TOTAL NO remunerativo del código 16, 39 o 92
                                                              // Siempre recupero suma de no remunerativos. Si es mixto, recupero además remunerativo del 16
          */
					
					// Registros tipo '02' - Datos referenciales de la Liquidación de SyJ del trabajador
					$lv_buffer .= '02';	// Identificacion del tipo de registro  (Fijo '02')
					$lv_buffer .= str_pad($lv_row['taxcod'],11);	// CUIL	del trabajador (11 enteros. CUIL del empleado sin guiones.)		3		13
					$lv_buffer .= str_pad($lv_row['srcobjcod001'],10,'0',STR_PAD_LEFT); // Legajo del trabajador (Este valor es optativo. De no incluir detalle, completar con espacios.) 14	23
					$lv_buffer .= str_pad('',50,' ',STR_PAD_RIGHT); // Dependencia revista del trabajador (Es el área donde el trabajador desempeña sus funciones( Ej. departamento de ventas). Este valor es optativo. De no incluir detalle, completar con espacios.)	24	73
					$lv_buffer .= str_pad($lv_row['bnkacccbu'],22,'0',STR_PAD_LEFT); // CBU de acreditación del pago (Se valida de acuerdo a las reglas definidas por el BCRA. Sólo se informa si "forma de pago" es igual a '3' (acreditación en cuenta))	74	95
					$lv_buffer .= '030'; // Cantidad de días para proporcionar tope (3 enteros. Este valor se utiliza para proporcionar en más o en menos la base imponible máxima o “tope” para el cálculo de los descuentos de aportes al trabajador (SIPA, INSSJyP y obra social/Fondo Solidario de Redistribución). Si la liquidación no corresponde a período de inicio o fin de la relación laboral o relacionada con vacaciones, este valor debe informarse en 0.)	96	98
					$lv_buffer .=	date_format($lv_row['hhrlqddte'],'Ymd'); // Fecha de pago (Formato: AAAAMMDD)	99	106
					$lv_buffer .= str_pad('',8,' ',STR_PAD_LEFT);	// Fecha de rúbrica (Completar con espacios en blanco.)		107		114
					$lv_buffer .= '1';	// Forma de pago (Valores permitidos. '1'=Efectivo; '2'=Cheque; '3'=Acreditación en cuenta)	115		115
					$lv_buffer .= chr(10);
					
					// Registros tipo '03' - Detalle de los conceptos de sueldo liquidados al trabajador
					// recorrer todos los precios
					foreach($lv_row['prcarr'] as $lv_rowprc){
						if($lv_rowprc['prccndtot']!=0){
							$lv_buffer .= '03';		// Identificación del tipo de registro  (Fijo '03')
							$lv_buffer .= str_pad($lv_row['taxcod'],11);	// CUIL	del trabajador (11 enteros. CUIL del empleado sin guiones.)		3		13
							$lv_buffer .= '0HDLYM1157'; // Código de concepto liquidado por el empleador ( Corresponde al código del concepto del empleador.)	14	23
							$lv_buffer .= str_pad('',5,' ',STR_PAD_LEFT); // Cantidad (3 enteros y 2 decimales. Este valor es obligatorio cuando se informa un código de concepto asociado a los siguientes conceptos AFIP: 123000-SAC PROPORCIONAL / 150000-ADELANTO VACACIONAL / 130000 a 139999-HORASEXTRAS)
							$lv_buffer .= ' '; // Unidades (Tipo de moneda=$; porcentuales=%; A=año; M=mes; Q=quincena; S=semanal; D=días; H=horas. Valor optativo, puede informarse en blanco.)	29	29
							$lv_buffer .= str_pad($lv_rowprc['prccndtot']*100,15,'0',STR_PAD_LEFT); // Importe (13 enteros y 2 decimales)	30	44
							$lv_buffer .= ($lv_rowprc['prccndtot']>0?'C':'D'); // Indicador Debito / Credito (D=Débito; C=Crédito)	45	45
							$lv_buffer .= str_pad('',6,' ',STR_PAD_LEFT); // Periodo de Ajuste Retroactivo (Formato: AAAAMM. Para los conceptos liquidados del período este valor se informa con blancos. Si hace referencia a una liquidación retroactiva del concepto, se debe informar el período. Este dato es solo informativo.)	46	51
							$lv_buffer .= chr(10);
						}
					}
					
					// Registros tipo '04' - Datos del trabajador para el calculo de la DJ F931 
					$lv_buffer .= '04';		// Identificación del tipo de registro  (Fijo '04')
					$lv_buffer .= str_pad($lv_row['taxcod'],11);	// CUIL	del trabajador (11 enteros. CUIL del empleado sin guiones.)		3		13

					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 3 Marca de cónyuge 1 14 14 Alfanumérico Valores permitidos: ‘0’=No; ‘1’=Si
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 4 Cantidad de hijos 2 15 16 Numérico 2 enteros
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 5 Marca de trabajador en CCT 1 17 17 Alfanumérico Valores permitidos: ‘0’=No; ‘1’=Si
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 6 Marca de cobertura de SCVO 1 18 18 Alfanumérico Valores permitidos: ‘0’=No; ‘1’=Si
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 7 Marca de corresponde reducción 1 19 19 Alfanumérico Valores permitidos: ‘0’=No; ‘1’=Si
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 8 Código de tipo de empleador asociado al trabajador 1 20 20 Alfanumérico (0- Administración Pública / 1- Decreto 814/01, Art 2 Inc. B / 2- Servicios Eventuales, Art 2 Inc. B / 4- Decreto 814/01, Art 2 Inc.A / 5- Servicios Eventuales, Art 2 Inc. A / 7- Enseñanza Privada / 8- Decreto 1212/03 – AFA Clubes )
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 9 Código de tipo de operación 1 21 21 Alfanumérico Valor fijo: ‘0’
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 10 Código de situación de revista 2 22 23 Alfanumérico Valores permitidos: los existentes en la tabla “Situación de Revista” de Declaración en Línea.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 11 Código de condición 2 24 25 Alfanumérico Valores permitidos: los existentes en la tabla “Código de Condición” de Declaración en Línea.
					$lv_buffer .= str_pad('',3,'0',STR_PAD_LEFT);	// 12 Código de actividad 3 26 28 Alfanumérico Valores permitidos: los existentes en la tabla “Actividades” de Declaración en Línea.
					$lv_buffer .= str_pad('',3,'0',STR_PAD_LEFT);	// 13 Código de modalidad de contratación 3 29 31 Alfanumérico Valores permitidos: los existentes en la tabla “Modalidades de Contratación” de Declaración en Línea.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 14 Código de siniestrado 2 32 33 Alfanumérico Valores permitidos: los existentes en la tabla “Siniestrados” de Declaración en Línea.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 15 Código de localidad 2 34 35 Alfanumérico Valores permitidos: los existentes en la tabla “Localidades Geográficas” de Declaración en Línea.
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 16 Situación de revista 1 2 36 37 Alfanumérico Valores permitidos: los existentes en la tabla “Situación de Revista” de Declaración en Línea.
					$lv_buffer .= str_pad('',1,'0',STR_PAD_LEFT);	// 17 Día de inicio situación de revista 1 2 38 39 Numérico 2 enteros. Día inicial para la situación de revista 1.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 18 Situación de revista 2 2 40 41 Alfanumérico Valores permitidos: los existentes en la tabla “Situación de Revista” de Declaración en Línea.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 19 Día de inicio situación de revista 2 2 42 43 Numérico 2 enteros. Día inicial para la situación de revista 2.
					$lv_buffer .= str_pad('',3,'0',STR_PAD_LEFT);	// 20 Situación de revista 3 2 44 45 Alfanumérico Valores permitidos: los existentes en la tabla “Situación de Revista” de Declaración en Línea.
					$lv_buffer .= str_pad('',3,'0',STR_PAD_LEFT);	// 21 Día de inicio situación de revista 3 2 46 47 Numérico 2 enteros. Día inicial para la situación de revista 3.
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 22 Cantidad de días trabajados 2 48 49 Numérico 2 enteros. Si se informa un valor, el campo Horas trabajadas debe ser 0.
					$lv_buffer .= str_pad('',3,'0',STR_PAD_LEFT);	// 23 Cantidad de horas trabajadas 3 50 52 Numérico 3 enteros. Si se informa un valor, el campo Cantidad días trabajados debe ser 0.
					$lv_buffer .= str_pad('',5,'0',STR_PAD_LEFT);	// 24 Porcentaje de aporte adicional de seguridad social 5 53 57 Numérico 3 enteros y 2 decimales. Formato 99999. Las últimas dos posiciones corresponden a los centavos del importe. Se consignarán los puntos porcentuales que superen los establecidos en la Ley N° 24241, artículo 11 o Decreto N.º 1387/01, artículo 15. El programa adicionará el porcentaje adicional que se consigne en el campo al aporte obligatorio vigente a cada período y procederá al cálculo sobre la Base Imponible de aportes SIPA
					$lv_buffer .= str_pad('',5,'0',STR_PAD_LEFT);	// 25 Porcentaje de contribución por tarea diferencial 5 58 62 Numérico 3 enteros y 2 decimales. Formato 99999. Las últimas dos posiciones corresponden a los centavos del importe. Refleja el cálculo de los aportes diferenciales sobre la Base Imponible de Regímenes Diferenciales (Por ejemplo: 2% aporte diferencial de los docentes)
					$lv_buffer .= str_pad('',6,'0',STR_PAD_LEFT);	// 26 Código de obra social del trabajador 6 63 68 Alfanumérico Según tabla de codificación RNOS
					$lv_buffer .= str_pad('',2,'0',STR_PAD_LEFT);	// 27 Cantidad de adherentes de obra social 2 69 70 Numérico 2 enteros. Se registra el número de aquellos que no integran el grupo familiar. Ese dato es tenido en cuenta para el incremento del porcentaje a considerar para el cálculo de aportes de Obra Social.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 28 Aporte adicional de obra social 15 71 85 Numérico 13 enteros y 2 decimales. Se consignarán las contribuciones del empleador, emergentes de la diferencia entre la remuneración efectivamente percibida por este y el mínimo fijado por ANSES, a los efectos de acceder a una cobertura médico asistencial (Dec 492/95, art. 8)
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 29 Contribución adicional de obra social 15 86 100 Numérico 13 enteros y 2 decimales. Se consignarán las contribuciones del empleador, emergentes de la diferencia entre la remuneración efectivamente percibida por el trabajador y el mínimo fijado por ANSES, a los efectos de permitirle a este acceder a una cobertura médico asistencial (Dec 492/95, art 8)
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 30 Base para el cálculo diferencial de aporte de obra social y FSR (1) 15 101 115 Numérico 13 enteros y 2 decimales. Para informar diferenciales que sumen a la base imponible 4 (aportes de obra social y FSR) en los casos de trabajadores a tiempo parcial que aportan como tiempo completo (Ley 26.474 art 1, inc 4)
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 31 Base para el cálculo diferencial de contribuciones de obra social y FSR (1) 15 116 130 Numérico 13 enteros y 2 decimales. Para informar diferenciales que sumen a la base imponible 8 (contribuciones de obra social y FSR) en los casos de trabajadores a tiempo parcial que contribuyen como tiempo completo (Ley 26.474 art 1, inc 4)
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 32 Base para el cálculo diferencial Ley de Riesgos del Trabajo (1) 15 131 145 Numérico 13 enteros y 2 decimales. Para informar diferenciales que sumen a la base imponible 9 (contribuciones LRT)
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 33 Remuneración maternidad para ANSeS 15 146 160 Numérico 13 enteros y 2 decimales. Informará el monto de la remuneración bruta que le hubiera correspondido percibir a la trabajadora si hubiera cumplido sus servicios normalmente.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 34 Remuneración bruta 15 161 175 Numérico Formato: 13 enteros y 2 decimales. Es la suma de conceptos remunerativos y no remunerativos liquidados en el mes.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 35 Base imponible 1 15 176 190 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Aportes Previsionales.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 36 Base imponible 2 15 191 205 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Contribuciones previsionales e INSSJyP
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 37 Base imponible 3 15 206 220 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Contribuciones FNE, asignaciones familiares y RENATRE
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 38 Base imponible 4 15 221 235 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Aportes obra social y FSR.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 39 Base imponible 5 15 236 250 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Aportes INSSJyP.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 40 Base imponible 6 15 251 265 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Aportes diferenciales.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 41 Base imponible 7 15 266 280 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Aportes personal regímenes especiales.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 42 Base imponible 8 15 281 295 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Contribuciones obra social y FSR.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 43 Base imponible 9 15 296 310 Numérico Formato: 13 enteros y 2 decimales. Base de cálculo para Ley de riesgos de Trabajo.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 44 Base para el cálculo diferencial de aporte de Seg. Social 15 311 325 Numérico Formato: 13 enteros y 2 decimales. Para informar diferenciales que sumen a la base imponible 1.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 45 Base para el cálculo diferencial de contribuciones de Seg. Social 15 326 340 Numérico Formato: 13 enteros y 2 decimales. Para informar diferenciales que sumen a la base imponible 2.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 46 Base imponible 10 15 341 355 Numérico Formato: 13 enteros y 2 decimales. Para informar la base de contribuciones relacionadas con la Ley 27.430. La misma de compone de la base imponible 2 menos el importe a detraer. Si el importe a detraer es 0, se informa también en 0.
					$lv_buffer .= str_pad('',15,'0',STR_PAD_LEFT);	// 47 Importe a detraer (Ley 26.473) 15 356 370 Numérico Formato: 13 enteros y 2 decimales. Para informar el monto a detraer de la base de contribuciones que va a determinar la base imponible 10.

					$lv_buffer .= chr(10);
					
					// Registros tipo '05' - Datos del trabajador de la empresa de servicios eventuales - Dec 342/1992
					// no se informa
					
					/*
					$lv_buffer .= str_pad(substr($lv_row['tchtxt'],0,30),30);	// Apellido y Nombre 12 30
					$lv_buffer .= str_pad('F',1);	// Cónyuge 42 1 (siempre se usa la constante F )
					$lv_buffer .= str_pad( '0',2,'0',STR_PAD_LEFT);	// Cantidad de hijos 43 2 (siempre va constante CERO ya que no se declara en el F931)
					$lv_buffer .= str_pad( '01',2,'0',STR_PAD_LEFT);	// Código de situación 45 2		PENDIENTE: revisar listado completo de codigos y ver como los relacionamos con la info del sistema
																															//														01 (x default) - ACTIVO
																															//														02 - cuando se asigna como JUBILIADO
																															//														13 - cuando se asigna una licencia sin goce se asigna codigo 13-LICENCIA SIN SUELDO
					$lv_buffer .= str_pad( '01',2,'0',STR_PAD_LEFT);	// Código de condición 47 2	(FIJO 01 - revisar lista completa de codigos)
					$lv_buffer .= str_pad( $lv_row['actcod'],3,'0',STR_PAD_LEFT);	// Código de actividad 49 3		PENDIENTE: revisar listado completo de codigos de actividad
                                                                          // PROGRAMATICO: codigo 016 (todos los docentes)
                                                                          // SAOEP / SOEME: codigo 039 (prevalece sobre el 16)
                                                                          // EXTRAPROGRAMATICOS: codigo 092 (prevalece sobre el 16 y 39)
                                                                          // FUERA DE CONVENIO: codigo 049
					$lv_buffer .= str_pad( '2',2,'0',STR_PAD_LEFT);	// Código de zona 52 2	PENDIENTE: listado de zonas y asignar zona a EMPRESA
					$lv_buffer .= str_pad(number_format(0,2,',',''),5,' ',STR_PAD_LEFT);	// Porcentaje de aporte adicional SS 54 5	(SIEMPRE CERO)
					$lv_buffer .= str_pad( $lv_modcont,'3','0',STR_PAD_LEFT);	// Código de modalidad de contratación 59 3		PENDIENTE: reivsar lista completa de codigos y asignación a PERSONA
																															// 008 - x default	- jornada completa
																															// 001 - media joranada
					$lv_buffer .= str_pad( $this->co_reg->document->getTagValue($lv_row['hhrlqdatr001'], 'medcovcodext'),6,'0',STR_PAD_LEFT);	// Código de obra social 62 6
					$lv_buffer .= str_pad( $lv_cantadherentes,2,'0',STR_PAD_LEFT);	// Cantidad de adherentes 68 2	(obtener los datos desde los contactos - personas a cargo para OOSS)
					$lv_buffer .= str_pad(number_format($lv_totrem + $lv_totnorem,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración total 70 12
																															// SUMA TOTAL REMUNERATIVO + TOTAL NO REMUNERATIVO (todos los recibos)
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 1 82 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Asignaciones familiares pagadas 94 9	(PENDIENTE: verificar definición)
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Importe aporte voluntario 103 9	(x default CERO)
					$lv_buffer .= str_pad(number_format($lv_difos,2,',',''),9,' ',STR_PAD_LEFT);	// Importe adicional OS 112 9	(SUMA del total de todos los recibos - row450	DIF. APORTE OBRA SOCIAL)
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Importe excedente aportes SS 121 9	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Importe excedente aportes OS 130 9	(x default CERO)
					$lv_buffer .= str_pad($lv_buszon,50,' ');	// Provincia localidad 139 50	(tomar de la ZONA de la empresa) (PENDIENTE - pasar listado) Empresa->adrzon
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 2 189 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 3 201 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad(number_format($lv_remimpinc,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 4 213 12
																															// ACTIVIDAD 16/ (mixto 92-16) / (mixto 39-16) - TOTAL REMUNERATIVO + INCENTIVO (row600	RESOLUCION 2/04)
																															// ACTIVIDAD 49/92/39 - TOTAL REMUNERATIVO
					$lv_buffer .= str_pad('00',2,'0',STR_PAD_LEFT);	// Código de siniestrado 225 2	(x default CERO - PENDIENE listado - 00=no incapacitado)
					$lv_buffer .= str_pad('T',1);	// Marca de corresponde reducción 227 1		(x default T=true va en el colegio-empresa)
					$lv_buffer .= str_pad(number_format(0,'2',',',''),9,' ',STR_PAD_LEFT);	// Capital de recomposición de LRT 228 9	(x defalt CERO - PENDIENTE confirmacion)
					$lv_buffer .= str_pad('7',1);	// Tipo de empresa 237 1	(x default 7-enseñanza privada - pendiente LISTADO)
					
					$lv_buffer .= str_pad(number_format($lv_difos,'2',',',''),9,' ',STR_PAD_LEFT);	// Aporte adicional de obra social 238 9
																															// suma del total de row460 - DIF. APORTE OBRA SOCIAL
					$lv_buffer .= str_pad('1',1);	// Régimen 247 1	(x default UNO)
					$lv_buffer .= str_pad('01',2,'0',STR_PAD_LEFT);	// Situación de revista 1 248 2
																															// MISMO CODIGO QUE "CODIGO DE SITUACION"
																															//														01 (x default) - ACTIVO
																															//														02 - cuando se asigna como JUBILIADO
																															//														13 - cuando se asigna una licencia sin goce se asigna codigo 13-LICENCIA SIN SUELDO
					$lv_buffer .= str_pad('1',2,'0',STR_PAD_LEFT);	// Día de inicio situación de revista 1 250 2	(x default UNO)
					$lv_buffer .= str_pad('01',2,'0',STR_PAD_LEFT);	// Situación de revista 2 252 2
																															// MISMO CODIGO QUE "CODIGO DE SITUACION"
																															//														01 (x default) - ACTIVO
																															//														02 - cuando se asigna como JUBILIADO
																															//														13 - cuando se asigna una licencia sin goce se asigna codigo 13-LICENCIA SIN SUELDO
					$lv_buffer .= str_pad('0',2,'0',STR_PAD_LEFT);	// Día de inicio situación de revista 2 254 2	(x default CERO)
					$lv_buffer .= str_pad('01',2,'0',STR_PAD_LEFT);	// Situación de revista 3 256 2
																															// MISMO CODIGO QUE "CODIGO DE SITUACION"
																															//														01 (x default) - ACTIVO
																															//														02 - cuando se asigna como JUBILIADO
																															//														13 - cuando se asigna una licencia sin goce se asigna codigo 13-LICENCIA SIN SUELDO
					$lv_buffer .= str_pad('0',2,'0',STR_PAD_LEFT);	// Día de inicio situación de revista 3 258 2	(x default CERO)
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Sueldo + adicionales 260 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad(number_format($lv_sac,2,',',''),12,' ',STR_PAD_LEFT);	// SAC 272 12
																																				// ACTIVIDAD 92/39/16 - suma de todos los recibos (row230 - SAC)
																																				// si hay mixto - SAC solo del 92 o 39
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Horas extras 284 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Zona desfavorable 296 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Vacaciones 308 12	(x default CERO)
					$lv_buffer .= str_pad('0000000'.$lv_cantdias,9);	// Cantidad de días trabajados 320 9	(cantidad de dias del período INICIO-FIN)
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 5 329 12
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad('T',1);	// Trabajador convencionado (0-No 1-Si) 341 1		(x default T)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 6 342 12	(x default CERO)
																															// ACTIVIDAD 16/92/39/49 - TOTAL REMUNERATIVO (igual que la 5)
																															// si hay un mixto (codigos 92 y 16) se toma solo el TotREM del 92
																															// si hay un mixto (codigos 39 y 16) se toma solo el TotREM del 39
					$lv_buffer .= str_pad('0',1);	// Tipo de operación 354 1	(x default 0)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Adicionales 355 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Premios 367 12	(x default CERO)
					$lv_buffer .= str_pad(number_format($lv_remimp,2,',',''),12,' ',STR_PAD_LEFT);	// Rem. Dto. 788/05 / Remuneración 8 379 12
																															// ACTIVIDAD 16/ (mixto 92-16) / (mixto 39-16) - TOTAL REMUNERATIVO + INCENTIVO (row600	RESOLUCION 2/04)
																															// ACTIVIDAD 49/92/39 - TOTAL REMUNERATIVO
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración imponible 7 391 12	(x default CERO)
					$lv_buffer .= str_pad('0',3,'0',STR_PAD_LEFT);	// Cantidad de horas extras 403 3	(x default CERO)
					$lv_buffer .= str_pad(number_format($lv_totnoremcod,2,',',''),12,' ',STR_PAD_LEFT);	// Conceptos No remunerativos 406 12
																																				// suma row899-TOTAL NO REMUNERATIVO (PENDIENTE: confirmación)
																																				// mixto (92/16) se toma el TOTAL remunerativo y NO remunerativo del 16 y se lo suma como no remunerativo
																																				// mixto (39/16) se toma el TOTAL remunerativo y NO remunerativo del 16 y se lo suma como no remunerativo
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Maternidad 418 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Rectificación de Remuneración 430 9	(x default CERO)
					$lv_buffer .= str_pad(number_format($lv_totrem + $lv_totnorem + $lv_asgfam,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración Imponible 9 439 12
																															// SUMA TOTAL REMUNERATIVO + TOTAL NO REMUNERATIVO - ASIGNACIONES FAMILIARES (todos los recibos)
					$lv_buffer .= str_pad(number_format(0,2,',',''),9,' ',STR_PAD_LEFT);	// Contribución Tarea Diferencial % 451 9	(x default CERO)
					$lv_buffer .= str_pad('0',3,'0',STR_PAD_LEFT);	// Horas Trabajadas 460 3	(x default CERO)
					$lv_buffer .= str_pad('T',1);	// Seguro Colectivo de Vida Obligatorio 463 1	(x default T-true)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Importe detracción Ley 27430 464 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Incremento salarial 476 12	(x default CERO)
					$lv_buffer .= str_pad(number_format(0,2,',',''),12,' ',STR_PAD_LEFT);	// Remuneración Imponible 11 488 12	(x default CERO)
					$lv_buffer .= chr(10);
					*/
				}
        
				$this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$this->co_reg->sec->buscod.'_F931_'.$lv_date->format('Ym').'.txt');
				$this->co_reg->response->addHeader('Content-Type: text/plain');
        $lv_header = $this->co_reg->sec->buscod.'_F931_'.$lv_date->format('Ym').'.txt';
        
        return $this->co_reg->document->getJson( array('filename'=>$lv_header, 'body'=>$lv_buffer) );
        
				break;
        
    }
  }
}
?>