<?php
final class stkmatController extends tmssController {
	const CONTROLLER = 'stkmat'; 
	const MODEL = 'stkmat';
	const VIEW  = 'stkmat';
	const ID = 'matcod';
	const OBJTYP ='STK_MAT';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

	
  // INDEX. metodo principal
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve la grilla con la lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
        $lv_objtyp = 'STK_MAT';
				$lv_act = ($lo_post['matcod']!=''?'02':'01');

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load(array('sysdocclscod'=>$lo_post['sysdocclscod']));
				
				// grabo datos del documento
        if ( $this->lo_mdl->save( $lo_post ) ) {

          // grabo datos de impuestos
					$lo_mattax = $this->co_reg->load->model('stkmattax');
					$lv_buffer = $lo_post['mattax'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mattax_arr = json_decode($lv_buffer,true);

						// -- agrego/actualizo los impuestos
						foreach( $lv_mattax_arr as $lv_row ) {
							$lv_row['matcod'] = $this->lo_mdl->matcod;
							$lv_row['docsts'] = 'A';
              if ( isset($lv_row['deleted']) ) {
								if ($lo_mattax->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_mattax->errtyp,'errcod'=>$lo_mattax->errcod,'errtxt'=>$lo_mattax->errtxt) );
								}
							} else if ($lo_mattax->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_mattax->errcod,'errtxt'=>$lo_mattax->errtxt) );
							}
						}

						// -- cargo todos los impuestos del material
						$lv_prm = array('vewfldflt' =>'[~fltrow~]mt.matcod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->matcod .chr(9).chr(9) );
						$lo_rstax = $lo_mattax->getList( $lv_prm );
						// -- borro los impuestos que fueron quitados de la grilla
						foreach($lo_rstax as $lv_row){
							$lv_found = false;
							foreach($lv_mattax_arr as $lv_row2){
								if(($lv_row['fintaxtypcod']??0)==($lv_row2['fintaxtypcod']??0)){ $lv_found=true; }
							}
							if($lv_found==false){
								if ($lo_mattax->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_mattax->errcod,'errtxt'=>$lo_mattax->errtxt) );
								}
							}
						}
					}

          // cargo documento
          $this->lo_mdl->load( array('matcod' => $this->lo_mdl->matcod) );
          $lv_doccod = $this->lo_mdl->matcod;

					// cargo datos de material
					$this->lo_mdl->load( array(	'matcod'=>$this->lo_mdl->matcod	) );

					// obtengo toda la info de la clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;


      // NEW. devuelve la vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
					$this->lo_mdl->sysdocclstxt = $lo_docclsmdl->sysdocclstxt;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;


      // CHANGE - DISPLAY - COPY. devuelve la vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
				$lv_key = array();
				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );
				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
        	$lo_data=	$this->lo_mdl->mattax;
          foreach($lo_data as &$lo_row){
          	$lo_row['matcod']='';
            $lo_row['stkmattaxcod']='';
          	$lv_row['ctedte'] = '';
          	$lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          unset($lo_row);
					$this->lo_mdl->matcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				// obtengo toda la info de la clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
          if ($this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'fletypcodpic') == ''){
            $this->lo_mdl->sysdoccls->sysdocclsatr = str_replace('<fletypcodpic></fletypcodpic>', '<fletypcodpic>0</fletypcodpic>', $this->lo_mdl->sysdoccls->sysdocclsatr);
          }
				}

				// cargo ruta de jerarquia
				$lo_mathiemdl = $this->co_reg->load->model( 'stkmathie' );
				$lo_mathiemdl->load( array('mathiecod'=>$this->lo_mdl->mathiecod) );
				$this->lo_mdl->mathiepth = $lo_mathiemdl->mathiepth;

				// cargo definiciones de impuestos
				$lo_mattaxdef = $this->co_reg->load->model( 'stkmattax' );
				$lo_mattaxdef->load( array('matcod'=>$this->lo_mdl->matcod) );
				$this->lo_mdl->mathiepth = $lo_mattaxdef->mathiepth;
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;


			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;


			// GETLIST by TEXT. busca documentos segun texto
      case '#18':case '#17':
				$lo_post = $this->co_reg->request->post;

        $lv_sysdocclscod = isset($lo_post['sysdocclscod']) ? $lo_post['sysdocclscod'] : ($lp_prm['sysdocclscod'] ?? '');
				
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['mattxt']) 	 ?'[~fltrow~]m.mattxt'.chr(9).''.chr(9).($lp_prm['mattxt']).chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['matcodext']) 	 ?'[~fltrow~]m.matcodext'.chr(9).'='.chr(9).chr(9).$lp_prm['matcodext'].chr(9).chr(9):'').
                        							(isset($lp_prm['matusebch']) 	 ?'[~fltrow~]m.matusebch'.chr(9).'='.chr(9).chr(9).$lp_prm['matusebch'].chr(9).chr(9):'').
                        							(!empty($lv_sysdocclscod)?'[~fltrow~]m.sysdocclscod'.chr(9).(strpos($lv_sysdocclscod, ';') ? 'IN': '=').chr(9).chr(9).str_replace(';', chr(10), $lv_sysdocclscod).chr(9).chr(9):'').
                        							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data,'post'=>$lo_post) );
        break;
			
			
			// GET MATERIAL by CODE. dado un codigo busca un material relacionado
      // recibe: row:          datos adicionales que identifica la fila que llamo a esta funcion
      //				 sysdocclscod: clase de documento del movimiento - para obtener la secuencia de busqueda
    	//				 matcodext:    codigo a buscar
    	//				 matcodfndseq: secuencia de busqueda (opcional) en caso de que no este definida en la clase de documento
      //				 sysdocclscod_mat: (opcional) clases de documento (separadas por ;) en donde buscar materiales
			// opciones para secuencia de busqueda (separado por punto y coma):
      // - matbarcod:    CODIGO INTERNO TEMASIS = MATERIAL|LOTE|SERIE|UM
      // - matsercodext: SERIE EXTERNO
			// - matbchcodext: LOTE EXTERNO
			// - matidtcodext: IDENTIFICACION
			// - matcodext:    MATERIAL EXTERNO
			// - matcod:       MATERIAL INTERNO
      case '#19':
				$lo_data = array();
				$lv_fnd = false;
				$lo_post = $this->co_reg->request->post;

				$lv_datrow = ( $lo_post['row'] ?? $lp_prm['row'] ?? '' );
				$lv_code = ( $lo_post['matcodext'] ?? $lp_prm['matcodext'] ?? '' );
				$lv_code = utf8_decode($lv_code);
        $lv_matcodfndseq = !empty($lo_post['matcodfndseq']) ? $lo_post['matcodfndseq'] : (!empty($lp_prm['matcodfndseq']) ? $lp_prm['matcodfndseq'] : 'matcod');

				if($lv_matcodfndseq!=''){

					// obtengo la secuencia de búsqueda de código         
          $lv_fldarr = explode(';', $lv_matcodfndseq);

					$lo_sermdl = $this->co_reg->load->model('stkmatser');
					$lo_bchmdl = $this->co_reg->load->model('stkmatbch');
					$lo_idtmdl = $this->co_reg->load->model('stkmatidt');
					$lo_matmdl = $this->co_reg->load->model('stkmat');

					foreach($lv_fldarr as $lv_row) {
						switch($lv_row) {
              case 'matbarcod':
                $lv_arrcode = explode('|', str_replace('/\|+/', '|', $lv_code));
                $lv_matcod = $lv_arrcode[0] ?? '';
                $lv_matbchcod = $lv_arrcode[1] ?? '';
                $lv_matsercod = $lv_arrcode[2] ?? '';
                $lv_matuntcod = $lv_arrcode[3] ?? '';
                
                if ($lv_matsercod) {
                  // matcod|matbchcod|matsercod|matuntcod OR matcod||matsercod|matuntcod OR matcod||matsercod
                  $lv_prm = array('vewmaxrec' =>'1',
                                  'vewfldflt' =>'[~fltrow~]s.matcod'.chr(9).'='.chr(9).chr(9).$lv_matcod.chr(9).chr(9).
                                                ($lv_matbchcod ? '[~fltrow~]s.matbchcod'.chr(9).'='.chr(9).chr(9).$lv_matbchcod.chr(9).chr(9) : '').
                                                ($lv_matsercod ? '[~fltrow~]s.matsercod'.chr(9).'='.chr(9).chr(9).$lv_matsercod.chr(9).chr(9) : '').
                                                ($lv_matuntcod ? '[~fltrow~]m.matuntcod'.chr(9).'='.chr(9).chr(9).$lv_matuntcod.chr(9).chr(9) : '').
                                                '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                                '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                  (($lo_post['sysdocclscod_mat'] ?? '') != '' ?'[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'], ';', chr(10)).chr(9).chr(9) : '')
                                  );
                  $lo_rs = $lo_sermdl->getList($lv_prm, null, null, false);
                  if (count($lo_rs) > 0) {
                    $lv_matidtqty = $lo_rs[0]['matidtqty'] ?? 0;
                    $lv_matbseqty = $lo_rs[0]['matbseqty'] ?? 0;
                    $lo_rs[0]['matqty'] = $lv_matidtqty * $lv_matbseqty;
                    $lo_data = $lo_rs[0];
                    $lv_fnd = true;
                  }
                } elseif ($lv_matbchcod) {
                  // matcod|matbchcod or matcod|matbchcod||matuntcod
                  $lv_prm = array('vewmaxrec' => '1',
                                  'vewfldflt' => '[~fltrow~]b.matcod'.chr(9).'='.chr(9).chr(9).$lv_matcod.chr(9).chr(9).
                                                  '[~fltrow~]b.matbchcod'.chr(9).'='.chr(9).chr(9).$lv_matbchcod.chr(9).chr(9).
                                                  '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                                  '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                  ($lv_matuntcod ? '[~fltrow~]m.matuntcod'.chr(9).'='.chr(9).chr(9).$lv_matuntcod.chr(9).chr(9) : '').
                                  (($lo_post['sysdocclscod_mat'] ?? '') != '' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'], ';', chr(10)).chr(9).chr(9) : '')
                              		);
                  $lo_rs = $lo_bchmdl->getList($lv_prm);
                  if (count($lo_rs) > 0) {
                    $lo_data = $lo_rs[0];
                    $lv_fnd = true;
                  }
                } elseif ($lv_matcod or $lv_matuntcod) {
                  // matcod or matcod|||matuntcod
                  $lv_prm = array('vewmaxrec' =>'1',
                                  'vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'='.chr(9).chr(9).$lv_matcod.chr(9).chr(9).
                                  							'[~fltrow~]m.matuntcod'.chr(9).'='.chr(9).chr(9).$lv_matuntcod.chr(9).chr(9).
                                                ($lv_matuntcod ? '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) : '').
                                  (($lo_post['sysdocclscod_mat'] ?? '') != '' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'], ';', chr(10)).chr(9).chr(9) : '')
                                  );
                  $lo_rs = $lo_matmdl->getList($lv_prm, null, null, false);
                  if (count($lo_rs) > 0) {
                    $lo_data = $lo_rs[0];
                    $lv_fnd = true;
                  }
                }
                break;
              case 'matsercodext':
								$lv_prm = array('vewmaxrec' =>'1',
																'vewfldflt' =>($lv_row=='matsercodext' ? '[~fltrow~]s.matsercodext'.chr(9).'='.chr(9).chr(9).$lv_code.chr(9).chr(9) : '').
																							'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                ( ($lo_post['sysdocclscod_mat']??'')!='' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'],';',chr(10)).chr(9).chr(9) : '')
																);
								$lo_rs = $lo_sermdl->getList($lv_prm, null, null, false);
								if(count($lo_rs)>0){
                  $lv_matidtqty = $lo_rs[0]['matidtqty'] ?? 0;
    							$lv_matbseqty = $lo_rs[0]['matbseqty'] ?? 0;
									$lo_rs[0]['matqty'] = $lv_matidtqty * $lv_matbseqty;
									$lo_data=$lo_rs[0];
									$lv_fnd=true;
								}
								break;
							case 'matbchcodext':
								$lv_prm = array('vewmaxrec' =>'1',
																'vewfldflt' =>($lv_row=='matbchcodext' ? '[~fltrow~]b.matbchcodext'.chr(9).'='.chr(9).chr(9).$lv_code.chr(9).chr(9) : '' ).
                                              '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                ( ($lo_post['sysdocclscod_mat']??'')!='' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'],';',chr(10)).chr(9).chr(9) : '')
																);
								$lo_rs = $lo_bchmdl->getList($lv_prm);
								if(count($lo_rs)>0){$lo_data = $lo_rs[0]; $lv_fnd=true;}
								break;
							case 'matidtcodext':
								$lv_prm = array('vewmaxrec' =>'1',
																'vewfldflt' =>'[~fltrow~]i.matidtcodext'.chr(9).'='.chr(9).chr(9).$lv_code.chr(9).chr(9).
																							'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                ( ($lo_post['sysdocclscod_mat']??'')!='' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'],';',chr(10)).chr(9).chr(9) : '')
																);
								$lo_rs = $lo_idtmdl->getList($lv_prm);
								if(count($lo_rs)>0){
									$lo_rs[0]['matqty'] = $lo_rs[0]['matidtqty'] * $lo_rs[0]['matbseqty'];
									$lo_data = $lo_rs[0]; $lv_fnd=true;
								}
								break;
              case 'matcodext':
                // matbarcod = material|||um
								$lv_prm = array('vewmaxrec' =>'1',
																'vewfldflt' =>($lv_row=='matcodext' ? '[~fltrow~]m.matcodext'.chr(9).'='.chr(9).chr(9).$lv_code.chr(9).chr(9) : '' ).
																							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                ( ($lo_post['sysdocclscod_mat']??'')!='' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'],';',chr(10)).chr(9).chr(9) : '')
																);
								$lo_rs = $lo_matmdl->getList($lv_prm, null, null, false);
								if(count($lo_rs)>0){$lo_data = $lo_rs[0]; $lv_fnd=true;}
								break;
							case 'matcod':
								$lv_prm = array('vewmaxrec' =>'1',
																'vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'='.chr(9).chr(9).$lv_code.chr(9).chr(9).
																							'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                ( ($lo_post['sysdocclscod_mat']??'')!='' ? '[~fltrow~]m.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace($lo_post['sysdocclscod_mat'],';',chr(10)).chr(9).chr(9) : '')
																);
								$lo_rs = $lo_matmdl->getList($lv_prm, null, null, false);
								if(count($lo_rs)>0){$lo_data = $lo_rs[0]; $lv_fnd=true;}
								break;
						}
						if($lv_fnd==true){break;}
					}
				}

				return $this->co_reg->document->getJson( array('row'=>$lv_datrow,'data'=>$lo_data) );
        break;
    }
  }
}
?>