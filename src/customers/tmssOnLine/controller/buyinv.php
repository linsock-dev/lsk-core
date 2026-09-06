<?php
final class buyinvController extends tmssController {
	const CONTROLLER = 'buyinv';
	const MODEL = 'buyinv';	
	const VIEW  = 'buyinv';	
	const ID = 'buyinvcod';	
	const OBJTYP ='BUY_INV';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }   
  
	
  // INDEX. Método principal     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. Lista los objetos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				$lv_mdlcod = ( $lo_post['mdlcod'] ?? $lp_prm['mdlcod'] ?? '' );
				$lv_prgcod = ( $lo_post['prgcod'] ?? $lp_prm['prgcod'] ?? '' );
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				$lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. Graba un objeto
      case '#00':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = ( $lo_post['mdlcod'] ?? $lp_prm['mdlcod'] ?? '' );
				$lv_prgcod = ( $lo_post['prgcod'] ?? $lp_prm['prgcod'] ?? '' );
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				
				// grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$lo_post['buyinvcod'] = $this->lo_mdl->buyinvcod;
					$lo_docref = array();

					// grabo materiales del documento
					$lo_matdoc = $this->co_reg->load->model('buyinvmat');
          // PRECIOS. grabo precios de posiciones
          $lo_prcmdl = $this->co_reg->load->model('grldatprc');
          // INTERLOCUTORES. grabo interlocutores del documento
          $lo_doccntmdl = $this->co_reg->load->model('grldoccnt');
          
					$lv_buffer = $lo_post['buyinvmat'];          
          if ($lv_buffer!='') {
						$i=0;
						$lv_buydoc_arr = json_decode(html_entity_decode($lv_buffer),true);
						foreach( $lv_buydoc_arr as $lv_row ) {
							$lv_row['buyinvcod'] = $this->lo_mdl->buyinvcod;
							$lv_row['buyinvmatatr'] = '<buyinvmatbuytxt>'.(isset($lv_row['buyinvmatbuytxt'])?utf8_decode($lv_row['buyinvmatbuytxt']):'').'</buyinvmatbuytxt>';
							$lv_row['curcod'] = $lo_post['curcod'];
							$lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_matdoc->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt,'row'=>$i) );
								}
							} else if ($lo_matdoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt,'row'=>$i) );
							} 
							
							// recopilo los documentos relacionados
							if( isset($lv_row['docreftyp']) ) {
                if($lv_row['docreftyp']!='' ){
                  if (!isset($lo_docref[$lv_row['docreftyp']])) { $lo_docref[$lv_row['docreftyp']] = ''; }
                  if(stripos($lo_docref[$lv_row['docreftyp']].';',';'.$lv_row['docrefcod'].';')==false ) {
                    $lo_docref[$lv_row['docreftyp']] .= ($lo_docref[$lv_row['docreftyp']]==''?'':';').$lv_row['docrefcod'];
                  }  
                }
							}
							
							$i++;
						}
					}
					
					// PRECIOS CABECERA. grabo precios de cabecera
					$lv_buffer = $lo_post['buyinvprc'];
					if ($lv_buffer!='') {
						$lv_buyprc_arr = json_decode(html_entity_decode($lv_buffer),true);
						foreach( $lv_buyprc_arr as $lv_row3 ) {
							$lv_row3['srcobjtyp'] = $lv_objtyp;
							$lv_row3['srcobjcod001'] = $this->lo_mdl->buyinvcod;
							$lv_row3['srcobjcod002'] = '';
							$lv_row3['prcschcod'] = ( $lo_post['prcschcod'] ?? '' );
							$lv_row3['docsts'] = 'A';
							if ($lo_prcmdl->save( $lv_row3 )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcmdl->errtyp,'errcod'=>$lo_prcmdl->errcod,'errtxt'=>$lo_prcmdl->errtxt,'row'=>'') );
							}
						}
					}
          
          
          //INTERLOCUTORES. grabo datos de los interlocutores
          $lv_buffer = $lo_post['doccntjson'];
					if ($lv_buffer!='') {
						$lv_doccnt_arr = json_decode(html_entity_decode($lv_buffer),true);
						foreach( $lv_doccnt_arr as $lv_row4 ) {
							$lv_row4['srcobjtyp'] = $lv_objtyp;
							$lv_row4['srcobjcod'] = $lo_post['buyinvcod'];
							$lv_row4['grldoccntobjtyp'] = $lo_post['srcobjtyp'];
							$lv_row4['grldoccntobjcod'] = $lo_post['srcobjcod'];
              if(isset($lv_row4['cntcod'])){
								$lv_row4['mstcntcod'] = $lv_row4['cntcod'];
              }
              
              if ( isset($lv_row4['delete']) ) {
								if ($lo_doccntmdl->delete( $lv_row4 )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_doccntmdl->errtyp,'errcod'=>$lo_doccntmdl->errcod,'errtxt'=>$lo_doccntmdl->errtxt,'row'=>$i) );
								}
							} else {
                
                if ($lo_doccntmdl->save( $lv_row4 )!=false) {
                  if(isset($lv_row4['svemst']) && $lv_row4['svemst']=='X'){
                    $lv_row4['grldoccntcod'] = $lo_doccntmdl->grldoccntcod;
                    $lv_row4['cnttxt']=$lv_row4['grldoccntobjtxt'];
                    $lv_row4['cntsrctyp']=$lv_row4['grldoccntobjtyp'];
                    $lv_row4['cntsrccod']=$lv_row4['grldoccntobjcod'];

                    $lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
                    if( !$lo_datcntmdl->save($lv_row4,false) ){
                      return $this->co_reg->document->getJson( array('errtyp'=>$lo_datcntmdl->errtyp,'errcod'=>$lo_datcntmdl->errcod,'errtxt'=>$lo_datcntmdl->errtxt) );
                    }

                    $lv_row4['mstcntcod'] = $lo_datcntmdl->cntcod;
                    if( !$lo_doccntmdl->save($lv_row4) ){
                      return $this->co_reg->document->getJson( array('errtyp'=>$lo_doccntmdl->errtyp,'errcod'=>$lo_doccntmdl->errcod,'errtxt'=>$lo_doccntmdl->errtxt) );
                    }
                  }
                }else{
                	return $this->co_reg->document->getJson( array('errtyp'=>$lo_doccntmdl->errtyp,'errcod'=>$lo_doccntmdl->errcod,'errtxt'=>$lo_doccntmdl->errtxt,'row'=>'') );
                }
							}
						}
					}
					
					// cargo documento
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->buyinvcod	) );
					
					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
          
          // recupero interlocutores del documento
          $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->sysdocclscod .chr(9).chr(9).
                                        '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                         );
          $this->lo_mdl->sysdocclscnt = $lo_sysdocclscntmdl->getList($lv_prm);
					
					// asigno parámetros adicionales
					$this->lo_mdl->mdlcod = $lv_mdlcod;
					$this->lo_mdl->prgcod = $lv_prgcod;
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. Nuevo              
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = ( $lo_post['mdlcod'] ?? $lp_prm['mdlcod'] ?? '' );
				$lv_prgcod = ( $lo_post['prgcod'] ?? $lp_prm['prgcod'] ?? '' );
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
        if ( ($lo_post['tmss_actcod'] ?? '') == '01' ){
          unset($lo_post);
          $lo_post['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'] ?? '';
        }
				$this->lo_mdl->create( $lo_post );
        
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = ( $this->co_reg->request->post['sysdocclscod'] ?? '' );
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).$lv_objtyp.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
        
        // recupero interlocutores del documento
        $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->sysdoccls->sysdocclscod .chr(9).chr(9).
                                      '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
        $this->lo_mdl->sysdocclscnt = $lo_sysdocclscntmdl->getList($lv_prm);
				
        // cargo precios (array vacio)
				$this->lo_mdl->buyinvprc = array();
        
				/* cargo datos de la empresa */
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
				
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod = $lv_mdlcod;
				$this->lo_mdl->prgcod = $lv_prgcod;
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']));
				break;		
			
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = ( $lo_post['mdlcod'] ?? $lp_prm['mdlcod'] ?? '' );
				$lv_prgcod = ( $lo_post['prgcod'] ?? $lp_prm['prgcod'] ?? '' );
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				$lv_key = array();
				
				// get param (KEY)																										
				$lv_key = array( self::ID=> ( $lp_prm[self::ID] ?? $this->co_reg->request->post[self::ID]) );

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->buyinvcod = '';
					$this->lo_mdl->docsts = 'A';	
					$lv_dat = $this->lo_mdl->buyinvmat;
          // se usa una variable porque se modifica el tamaño del array dentro del for
          $counter = count($lv_dat);
					for($i=0; $i<$counter; $i++){
            if($lv_dat[$i]['docreftyp']!=""){
              unset($lv_dat[$i]);
            }else{
            	// Si no se pasa el código, no se pueden asociar los precios
              $lv_dat[$i]['buyinvmattmpcod']=$lv_dat[$i]['buyinvmatcod'];	
              $lv_dat[$i]['buyinvmatcod']='';	
              $lv_dat[$i]['buyinvcod'] = '';
              $lv_dat[$i]['docreftyp']=''; 
              $lv_dat[$i]['docrefcod']=''; 
              $lv_dat[$i]['docrefposcod']='';  
							$lv_dat[$i]['refposqty']=''; 
            }
					}
					$this->lo_mdl->buyinvmat = $lv_dat;
					$this->lo_mdl->sysdoctrecod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
        
        // recupero interlocutores del documento
        $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->sysdocclscod .chr(9).chr(9).
                                      '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
        $this->lo_mdl->sysdocclscnt = $lo_sysdocclscntmdl->getList($lv_prm);
        				
				// cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
				$this->lo_mdl->bus = $lo_busmdl;
				
				// LOCALIZACION - ARGENTINA -----------------------------------------------------
				if($lo_busmdl->adr->lndcod=='AR') {
					// cargo datos de puntos de venta
					$lo_posmdl = $this->co_reg->load->model('finlocargpos');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_docclsmdl->sysdocclscod.chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]sp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
					$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false);
					$this->lo_mdl->slspos = $lo_posrs;
				} else {
					$this->lo_mdl->slspos = array();
				}
				// ------------------------------------------------------------------------------
				
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod=$lv_mdlcod;
				$this->lo_mdl->prgcod=$lv_prgcod;
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			// ACCOUNTING. Contabilizar     
      case '#09':
        $this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'errmat'=>$this->lo_mdl->errmat));
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
			//		- (string): vista "buyinvpos"
			// ----------------------------------------------------------------------
      case '#13':
				$lo_post = $this->co_reg->request->post;

				// normalizo los datos recibidos
				$this->lo_mdl->dochdr = ($lo_post['dochdr']??'{}');
				$this->lo_mdl->docpos = ($lo_post['docpos']??'{}');
				$this->lo_mdl->docprc = ($lo_post['docprc']??'[]');
				$this->lo_mdl->readonly = ($lo_post['readonly']??'false');
				
				// obtengo el id de clase de documento
				$lv_dochdr_arr = JSON_decode(html_entity_decode($this->lo_mdl->dochdr),true);
				$lv_docpos_arr = JSON_decode(html_entity_decode($this->lo_mdl->docpos),true);
				$this->lo_mdl->buyinvcod = ( ($lv_dochdr_arr['buyinvcod'])?$lv_dochdr_arr['buyinvcod']:'');
				$this->lo_mdl->buyinvmatcod = ( $lv_docpos_arr['buyinvmatcod'] ?? '' );
				$this->lo_mdl->buyinvmatbuytxt = ( $lv_docpos_arr['buyinvmatbuytxt'] ?? '' );
				$this->lo_mdl->sysdocrejcod = ( $lv_docpos_arr['sysdocrejcod'] ?? '' );
				
				// recupero datos de la clase de documento
				if(!isset($lv_dochdr_arr['sysdocclscod'])){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Formato de comunicacion invalido. No se declaro [sysdocclscod] en cabecera.') );
				} else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$lv_dochdr_arr['sysdocclscod']) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$lv_objtyp = $lo_docclsmdl->objtyp;
				}
				
				// devuelvo la vista
				return $this->co_reg->document->getView( 'buyinvpos', array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// CALC
			// calcula el esquema de precios para una posición específica del documento
			// 		input:
			//  		- doc (array): datos de la cabecera del documento
			//  		- docpos (array): datos de la posicion
			//  		- docprc (array): precios de la posicion
			//			- readonly: (string): true-solo lectura / false-editable
			//		output:
			//			- docprc (array): array de precios de posición actualizado
			case '#calc':
				$lo_post = $this->co_reg->request->post;
				$lo_prcctr = $this->co_reg->load->controller('grldatprc');
				$lv_out = array();
        
				// INICIALIZO. obtengo e inicializo las variables
				$lv_dat = array();
				$lv_dat['dochdr'] = json_decode(html_entity_decode( ($lo_post['dochdr']??'[]') ),true);
				$lv_dat['docpos'] = json_decode(html_entity_decode( ($lo_post['docpos']??'[]') ),true);
				$lv_dat['docprc'] = json_decode(html_entity_decode( ($lo_post['docprc']??'[]') ),true);
				// PRECIOS
				if(count($lv_dat['docprc'])==0 && count($lv_dat['docpos'])!=0){
					// obtengo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$lv_dat['dochdr']['sysdocclscod']) );

					// obtengo esquema de precios
					$lo_prcschmdl = $this->co_reg->load->model('grlprcsch');
					$lo_prcschmdl->load( array('prcschcod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'prcschcod')) );
					// actualizo condicion de precio
					$lv_prc = array();
					$lv_prccndcod = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'prccndcod');
					foreach($lo_prcschmdl->prcschcnd as $lv_row){
						if ( $lv_row['prccndcod']==$lv_prccndcod ) {
							$lv_row['prccndqty'] = ( $lv_dat['docpos']['matqty'] ?? 0 );
							$lv_row['prccnduntcod'] = ( $lv_dat['docpos']['matuntcod'] ?? '' );
							$lv_row['prccndval'] = ( $lv_dat['docpos']['matprc'] ?? 0 );
							$lv_row['prccndcurcod'] = ( $lv_dat['dochdr']['curcod'] ?? '' );
							$lv_row['prcchgman'] = '';
							$lv_prc[] = $lv_row;
						}
					}
					$lv_dat['docprc'] = $this->co_reg->document->getJson( $lv_prc );
				} 
				
				// ORIGEN. recupero datos impositivos de origen
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$lv_dat['docpos']['srcobj'] = array('taxcatcod'=>$lo_busmdl->tax->taxcatcod);
				
				// DESTINO. recupero datos impositivos de destino
				$lv_dat['docpos']['dstobj'] = array('taxcatcod'=>$lv_dat['dochdr']['taxcatcod']);
				
				// MATERIAL. recupero datos impositivos de material
				$lo_matmdl = $this->co_reg->load->model('stkmat');
				if(isset($lv_dat['docpos']['matcod'])){
					$lo_matmdl->load( array('matcod'=>$lv_dat['docpos']['matcod']), false );
					foreach($lo_matmdl->mattax as $lv_row){
						if($lv_row['fintaxtypcat']=='IVA'){ $lv_dat['docpos']['stkmat'] = array('fintaxindcodext'=>$lv_row['fintaxindcodext']); break; }
					}
          $lv_out = $lo_prcctr->calculate($lv_dat);
				}
				
				// RETURN. devuelvo esquema actualizado
				return $this->co_reg->document->getJson( $lv_out );
				break;
    }
  }
}
?>