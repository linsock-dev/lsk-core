<?php
//require_once('..\library\plugins\phptools\tcpdf\6.2.25\tcpdf.php');
require_once('library\plugins\phptools\tcpdf\6.7.4\tcpdf.php');

final class grlvewController extends tmssController {
  protected $co_reg;
  private $data = array();
  private $co_vewinf='';
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm=array() ) {
		ini_set('memory_limit', '2048M');
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

    $lo_vew = $this->co_reg->load->model('grlvew');
		$lo_fltmdl = $this->co_reg->load->model('grldocflt');
		$lo_prfmdl = $this->co_reg->load->model('syssecusrprf');

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			
      // SHOW. muestra una vista o completa los datos de una vista
      case '#00':
				$lo_post = $this->co_reg->request->post;
        $lo_vew->loadView( $lp_prm['vewcod'] );
				$lo_vewhdr = $lo_vew->getHeader();
				$lo_vewcol = $lo_vew->getColumns();
				
				$lv_flt = ($lo_post['vewfldflt']??'').($lp_prm['vewfldflt']??'');
				if(($lp_prm['dwn']??'')==''){
					$lv_flt = html_entity_decode( $lv_flt );
				} else {
					$lv_flt = urldecode( utf8_decode( html_entity_decode( $lv_flt )));
				}
				
				$this->data['vewopt']=array('vewfldord'=>($lo_post['vewfldord']??$lp_prm['vewfldord']??''),
																		'vewmaxrec'=>($lo_post['vewmaxrec']?? ($lp_prm['vewmaxrec']??'') ),
																		'vewfldflt'=>$lv_flt,
																		'vewfldgrp'=>($lo_post['vewfldgrp']??'').($lp_prm['vewfldgrp']??''),
																		'vewfldgrpcal'=>($lo_post['vewfldgrpcal']??'').($lp_prm['vewfldgrpcal']??'')
																		);
				
				// LAYOUT DE USUARIO. aplico layout de usuario si se visualiza la grilla
				// por primera vez o se esta descargando los datos
				if( ($lp_prm['dwn']??'')=='1' || ($lp_prm['rfh']??'')!='1' ){
					
					// preferencias de usuario (layout)
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																				'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9).'GRL_VEW'.chr(9).chr(9).
																				'[~fltrow~]usrprfkey'.chr(9).'='.chr(9).chr(9).$lp_prm['vewcod'].chr(9).chr(9).
																				'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
													);
          
          $lo_rs = $lo_prfmdl->getList( $lv_prm );
          
          if(count($lo_rs)>0){
						$lo_prfmdl->usrprfcod = $lo_rs[0]['usrprfcod'];
						$lo_prfmdl->usrprfval = $lo_rs[0]['usrprfval'];
					}

					// aplica las preferencias de usuario sobre la configuracion de la vista actual
					if($lo_prfmdl->usrprfval!=''){
						$lo_rs = json_decode($lo_prfmdl->usrprfval,true);
						foreach($lo_vewcol as &$lv_row){
							foreach($lo_rs as $lv_usrrow){
								if(intval($lv_usrrow['vewfldcod'])==intval($lv_row['vewfldcod'])){
									$lv_row['vewfldord'] = $lv_usrrow['vewfldord'];
									$lv_row['vewfldflt'] = $lv_usrrow['vewfldflt'];
									$lv_row['vewfldwth'] = (intval($lv_usrrow['vewfldwth'])==0?0:(intval($lv_row['vewfldwth'])>0?$lv_row['vewfldwth']:50));
									$lv_row['vewfldcal'] = ($lv_usrrow['vewfldcal']??'');
									break;
								}
							}
						}
						unset($lv_row);
						
						usort( $lo_vewcol, array($this,'usortColOrder') );
					}
				}
				
        // grid refresh -> ajax call -> JSON response   
        if ( ($lp_prm['rfh']??'')=='1' ) {
          $lv_ret = array();
          $lv_count=-1;

          // cargo modelo
					$lo_vewmdl = $this->co_reg->load->model( $lp_prm['model'] );

					// verifico si se paso por QueryString algun filtro (...prm_fldflt=[lndcod:AR],[campo:string]...)
					if (isset($lp_prm['fldflt'])) {
						if ($lp_prm['fldflt']!='') {
							$lv_fldasg = explode(',',$lp_prm['fldflt']);
							foreach( $lv_fldasg as $lv_row ) {
								if (stripos(strtolower($lv_row),'(like)')>0) {
									$lv_fldasg2 = explode('(like)', substr($lv_row,1,strlen($lv_row)-2));
									$lv_fldasg2[0] = str_ireplace('_',',',$lv_fldasg2[0]);
									$this->data['vewopt']['vewfldflt'] .= '[~fltrow~]'.$lv_fldasg2[0].chr(9).''.chr(9).$lv_fldasg2[1].chr(9).chr(9).chr(9);
								} elseif (stripos(strtolower($lv_row),'(in)')>0) {
									$lv_fldasg2 = explode('(in)', substr($lv_row,1,strlen($lv_row)-2));
									$lv_fldasg2[0] = str_ireplace('_',',',$lv_fldasg2[0]);
									$this->data['vewopt']['vewfldflt'] .= '[~fltrow~]'.$lv_fldasg2[0].chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$lv_fldasg2[1]).chr(9).chr(9);
								} else {
									$lv_fldasg2 = explode(':', substr($lv_row,1,strlen($lv_row)-2));
									$lv_fldasg2[0] = str_ireplace('_',',',$lv_fldasg2[0]);
									$this->data['vewopt']['vewfldflt'] .= '[~fltrow~]'.$lv_fldasg2[0].chr(9).'='.chr(9).chr(9).$lv_fldasg2[1].chr(9).chr(9);
								}
							}
						}
					}

          // obtengo datos del modelo
					// si se indico el metodo, lo llamo, sino utilizo el metodo "getList"
					if ( ($lp_prm['srcmtd']??'')!='' ) {
						$lv_srcmtd = $lp_prm['srcmtd'];
						$lv_vewdat = $lo_vewmdl->{$lv_srcmtd}( $this->data['vewopt'], $lp_prm, $lo_vew, false );
					} else {
						$lv_vewdat = $lo_vewmdl->getList( $this->data['vewopt'], $lp_prm, $lo_vew, false );
					}
					
          // obtengo sentencia SQL ejecutada
          $lv_sqlstm = $lo_vewmdl->getsysdata('sqlstm');
					
          // prepare dataset to return (only view's columns)
					$lv_vewdatret = array();
          if (is_array($lv_vewdat)) {
            foreach( $lv_vewdat as $lv_row ) {
              $lv_count++;
              foreach ( $lo_vewcol as $lv_col ) {
								$lv_fldnme = $lv_col['vewfld'];
								
								// GET TAG VALUE
								if( strtolower(substr($lv_fldnme,0,15))=='dbo.gettagvalue' ) {
									$lv_fldnme = strtolower($lv_col['vewfld']);
									$lv_fld = substr(trim(explode(',',$lv_fldnme)[1]),0,-1);
									if (strpos($lv_fld,'.')){ $lv_fld = explode('.',$lv_fld)[1]; }
									$lv_tag = explode('^',explode('^',$lv_fldnme)[1])[0];
									$lv_vewdatret[$lv_count][$lv_fldnme] = $this->co_reg->document->gettagvalue( $lv_row[$lv_fld] , $lv_tag );
								} else {
									if (strpos($lv_fldnme,'.')){ $lv_fldnme = explode('.',$lv_col['vewfld'])[1]; }
									// NO DEFINIDO. si la columna de la vista NO está en el recordset
									if ( !isset($lv_row[$lv_fldnme]) ) {
										$lv_vewdatret[$lv_count][$lv_fldnme] = '';
									// FECHA. se formatea el campo como fecha
									} else if( $lv_row[$lv_fldnme] instanceof DateTime ) {
										$lv_vewdatret[$lv_count][$lv_col['vewfld']] = $lv_row[$lv_fldnme]->format('d/m/Y');
									// NUMERO. formatear según decimales del campo
									} else if( $lv_col['sysfldinptyp']=='NUMBER' ){
										$lv_vewdatret[$lv_count][$lv_col['vewfld']] = number_format( $lv_row[$lv_fldnme] , $lv_col['sysfldoutsze'] );
									// FALTA
									// TEXTO. se convierte utf8
									} else { 
										$lv_vewdatret[$lv_count][$lv_col['vewfld']] = utf8_encode( $lv_row[$lv_fldnme] );
									}
								}
              }
            }
          }
          

					// EXPORTAR
					if ( ($lp_prm['dwn']??'')=='1' ) {
						$lv_flenme = 'data'; //str_ireplace('@','',$this->co_reg->language->get($lo_vewhdr->vewttl) );
						$lv_buffer = '';

						// COLUMNAS. TIPO. prepara tipo de datos de cada columna
						$lv_coldattype = array();
						if( is_array( $lo_vewcol ) ){
							foreach ( $lo_vewcol as $lv_col ) {
								$lv_fld = ( stripos($lv_col['vewfld'],'.')===false ? $lv_col['vewfld'] : explode('.',$lv_col['vewfld'])[1] );
								$lv_coldattype[$lv_col['vewfld']] = array();
								switch($lv_col['sysfldinptyp']){
									case 'NUMBER':
										$lv_coldattype[$lv_fld] = array('hide'=>(intval($lv_col['vewfldwth']??0)==0?true:false),
																										'tmsstype'=>'NUMBER',
																										'tmssformat'=>'',
																										'tmssdecimals'=>$lv_col['sysfldoutsze'],
																										'tmssxlsformat'=>'#\,##0\.'.str_repeat('0',$lv_col['sysfldoutsze']) ); break;
									case 'DATE': 
										$lv_coldattype[$lv_fld] = array('hide'=>(intval($lv_col['vewfldwth']??0)==0?true:false),
																										'tmsstype'=>'DATE',
																										'tmssdecimals'=>'0',
																										'tmssformat'=>'d/m/Y',
																										'tmssxlsformat'=>'dd/mm/yyyy'); break;
									default: 
										$lv_coldattype[$lv_fld] = array('hide'=>(intval($lv_col['vewfldwth']??0)==0?true:false),
																										'tmsstype'=>'STRING',
																										'tmssformat'=>'',
																										'tmssdecimals'=>'0',
																										'tmssxlsformat'=>'\@'); break;
								}
							}
						}

            // COLUMNAS. se prepara array de columnas visibles
            $lv_cols = array();
            for($i=0;$i<count($lo_vewcol);$i++) {
              if($lo_vewcol[$i]['vewfldwth']!=0) { 
                $lv_cols[] = utf8_decode( html_entity_decode( $this->co_reg->language->get($lo_vewcol[$i]['vewfldttl'])) );	
							} 
            }
            
						// TIPO ARCHIVO. prepara los datos segun el tipo de archivo seleccionado
						switch ( $lo_post['vewdwntyp'] ) {
							case 'eml':  // EMAIL
								// cabecera
								$lv_buffer .= implode( chr(9), $lv_cols ) . chr(13).chr(10);									
								// datos. fila
								foreach( $lv_vewdatret as $lv_row ) {
									$i = 0;
									foreach( $lv_row as $lv_index2=>$lv_row2 ) {
										if( ($lv_coldattype[$lv_index2]['hide']??true)==false ){
											$lv_buffer .= ($i==0?'':chr(9)). $this->formatExportData( $lv_row2, $lv_coldattype[$lv_index2] );
											$i++;
										}
									}
									$lv_buffer .= chr(13).chr(10);
								}
								return $lv_buffer;
								// preparar mail
								// añadir adjunto
								// enviar mail
								// devolver JSON o SCRIPT para mensaje
								break;
              
							case 'txt':  // TEXTO
								// header
								$this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.txt');
								$this->co_reg->response->addHeader('Content-Type: text/plain');
								// cabecera
                $lv_buffer .= implode( chr(9), $lv_cols ) . chr(13).chr(10);									
								
								// datos. fila
								foreach( $lv_vewdatret as $lv_row ) {
									$i = 0;
									foreach( $lv_row as $lv_index2=>$lv_row2 ) {
										$lv_fld = ( stripos($lv_index2,'.')===false ? $lv_index2 : explode('.',$lv_index2)[1] );
										if( ($lv_coldattype[$lv_fld]['hide']??true)==false ){
											$lv_buffer .= ($i==0?'':chr(9)). $this->formatExportData( $lv_row2, $lv_coldattype[$lv_fld] );
											$i++;
										}
									}
									$lv_buffer .= chr(13).chr(10);
								}
								break;
              
							case 'xls':  // EXCEL
                // header
                $this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.xls');
								$this->co_reg->response->addHeader('Content-Type: application/vnd.ms-excel');

								$lv_buffer .= '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head>
								<style id="Leads_style">
									table {
										mso-displayed-decimal-separator:"\.";
										mso-displayed-thousand-separator:"\,";
									} 
								</style>
								</head><body>';

                // cabecera
                $lv_buffer .= '<table style="border: #000000 1px solid;" x:publishsource="Excel">';
								$lv_buffer .= '<tr><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.implode( '</td><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">', $lv_cols ) . '</td></tr>';
                // datos. fila
								foreach( $lv_vewdatret as $lv_index => $lv_row ) {
                  $lv_buffer .= '<tr>';
									foreach( $lv_row as $lv_index2=>$lv_row2 ){
										$lv_fld = ( stripos($lv_index2,'.')===false ? $lv_index2 : explode('.',$lv_index2)[1] );
										if( ($lv_coldattype[$lv_fld]['hide']??true)==false ){
											//invierte el formato de la fecha para que sea mes/dia/año
											//if( ($lv_coldattype[$lv_fld]['tmssxlsformat']??'\@')=='mmmm\ d\,\ yyyy' && $lv_row2!='' ){
											//	//array de fecha
											//	$lv_tempdte = explode( '/', $lv_row2 );                        
											//	//arma la fecha para invertir dia y mes
											//	$lv_row2 = $lv_tempdte[1].'/'.$lv_tempdte[0].'/'.$lv_tempdte[2];
											//}												
											//recorre array de tipo de datos
											$lv_buffer .= '<td style="mso-number-format:'.chr(39).$lv_coldattype[$lv_fld]['tmssxlsformat'].chr(39).';">'.$this->formatExportData( $lv_row2, $lv_coldattype[$lv_fld] ).'</td>';
										}
									}
                  $lv_buffer .= '</tr>';
								}
								$lv_buffer .= '</table>';
								$lv_buffer .= '</body></html>';
                break;
              
							case 'doc':  // WORD
								// header
								$this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.doc');
								$this->co_reg->response->addHeader('Content-Type: application/msword');
                // cabecera
                $lv_buffer .= '<TABLE style="border: #000000 1px solid;">';
								$lv_buffer .= '<tr><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.implode( '</td><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">', $lv_cols ) . '</td></tr>';
								// datos. fila
								foreach( $lv_vewdatret as $lv_row ) {
									$i = 0;
									foreach( $lv_row as $lv_index2=>$lv_row2 ) {
										$lv_fld = ( stripos($lv_index2,'.')===false ? $lv_index2 : explode('.',$lv_index2)[1] );
										if( ($lv_coldattype[$lv_fld]['hide']??true)==false ){
											$lv_buffer .= ($i==0?'<tr><td>':'</td><td>'). $this->formatExportData( $lv_row2, $lv_coldattype[$lv_fld] );
											$i++;
										}
									}
									$lv_buffer .= '</td></tr>';
								}
								$lv_buffer .= '</TABLE>';
								break;
              
							case 'pdf':  // PDF
								// header
                //$this->co_reg->response->addHeader('Content-Disposition: attachment; filename=datos.pdf');
                //$this->co_reg->response->addHeader('Content-Type: application/pdf');
                // cabecera
                $lv_buffer .= '<TABLE style="border: #000000 1px solid;">';
                $lv_buffer .= '<tr><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.implode( '</td><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">', $lv_cols ) . '</td></tr>';
                // datos. fila
                foreach( $lv_vewdatret as $lv_row ) {
									$i = 0;
									foreach( $lv_row as $lv_index2=>$lv_row2 ) {
										$lv_fld = ( stripos($lv_index2,'.')===false ? $lv_index2 : explode('.',$lv_index2)[1] );
										if( ($lv_coldattype[$lv_fld]['hide']??true)==false ){
											$lv_buffer .= ($i==0?'<tr><td>':'</td><td>'). $this->formatExportData( $lv_row2, $lv_coldattype[$lv_fld] );
											$i++;
										}
									}
									$lv_buffer .= '</td></tr>';
                }
                $lv_buffer .= '</TABLE>';

                // create new PDF document
                $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, false, 'ISO-8859-1', false);

                // set document information
                $pdf->SetTitle('Temasis');

                // set auto page breaks
                $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

                // add a page
                $pdf->AddPage();

                // output the HTML content
                $pdf->writeHTML($lv_buffer, true, false, true, false, '');

                //Close and output PDF document
                $pdf->Output( $lv_flenme.'.pdf', 'D');
                break;
							
							default:
								$lv_buffer .= 'FORMATO ['.$this->co_reg->request->post['vewdwntyp'].'] DESCONOCIDO';
								break;
						}
						return $lv_buffer;
						
					} else {
						// preparar respuesta JSON - para grid refresh
						$lv_retarr = array( 'total' => count($lv_vewdatret), 'rows' => $lv_vewdatret, 'sqlstm' =>$lv_sqlstm );
            return $this->co_reg->document->getJson( $lv_retarr );
					}
        }
				
        // grid load -> display view
				if ( ($lp_prm['rfh']??'')!='1' ) {
					
					// FILTRO x DEFAULT. obtengo filtro por default
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).$lp_prm['vewcod'].chr(9).chr(9).
																				'[~fltrow~]f.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																				'[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																				'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
					$lo_rs = $lo_fltmdl->getList( $lv_prm );
					if(count($lo_rs)>0){
						$lp_prm['vewfldfltdef'] = $lo_rs[0]['vewfltdat'];
						$lp_prm['vewfltcod'] = $lo_rs[0]['vewfltcod'];
					}

          // si se paso por parametro de vista condiciones de filtro las aplico
          $lp_prm['vewfldord'] = ($lo_post['vewfldord']??$lp_prm['vewfldord']??'');
          $lp_prm['vewmaxrec'] = ($lo_post['vewmaxrec']??$lp_prm['vewmaxrec']??'');
          $lp_prm['vewfldgrp'] = ($lo_post['vewfldgrp']??'').($lp_prm['vewfldgrp']??'');
          $lp_prm['vewfldgrpcal'] = ($lo_post['vewfldgrpcal']??'').($lp_prm['vewfldgrpcal']??'');
					$lp_prm['vewfldflt'] = ($lo_post['vewfldflt']??'').($lp_prm['vewfldflt']??'');
					if($lp_prm['vewfldflt']!=''){ $lp_prm['vewfldflt'] = urldecode( utf8_decode( html_entity_decode( $lp_prm['vewfldflt'] ))); }
					
					// si se indico Módulo-Programa, obtengo operciones que se muestran en la grilla
					if ( ($lp_prm['mdlcod']??'')!='' && ($lp_prm['prgcod']??'')!='' ) {
						$lo_vewopr = $lo_vew->getOperations( $lp_prm['mdlcod'], $lp_prm['prgcod'] );
					} else {
						$lo_vewopr = array();
					}

					// defaults
					$lp_prmcfg['toolbar'] = 									( $lp_prm['toolbar']??true );
					$lp_prmcfg['toolbar.close'] = 						( $lp_prm['toolbar.close']??true );
					$lp_prmcfg['toolbar.refresh'] = 					( $lp_prm['toolbar.refresh']??true );
					$lp_prmcfg['toolbar.filter'] = 						( $lp_prm['toolbar.filter']??true );
					$lp_prmcfg['toolbar.options'] = 					( $lp_prm['toolbar.options']??true );
					$lp_prmcfg['toolbar.options.print'] = 		( $lp_prm['toolbar.options.print']??true );
					$lp_prmcfg['toolbar.options.export'] = 		( $lp_prm['toolbar.options.export']??true );
					$lp_prmcfg['toolbar.options.send'] = 			( $lp_prm['toolbar.options.send']??true );
					$lp_prmcfg['toolbar.options.favorites'] = ( $lp_prm['toolbar.options.favorites']??true );
					$lp_prmcfg['toolbar.options.technical'] = ( $lp_prm['toolbar.options.technical']??true );
					$lp_prmcfg['toolbar.operations'] = 				( $lp_prm['toolbar.operations']??array() );
					
					// devuelvo vista de grilla
          return $this->co_reg->document->getView( 'sysdocgrd', array('defhdr'=>$lo_vewhdr,'defcol'=>$lo_vewcol,'defopr'=>$lo_vewopr,'defcfg'=>$lp_prmcfg,'model'=>($lp_prm['model']??''),'view'=>($lp_prm['view']??''),'controller'=>($lp_prm['controller']??''),'prm'=>$lp_prm) );
        }
        break;
			
			
      // SHOW INFO. devuelve la vista de info
      case '#showinfo':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl = $this->co_reg->load->model('grlvew');
				$lv_dat=array();
				$lo_post['infdat']=json_decode(html_entity_decode($lo_post['infdat']),true);
				foreach($lo_post['infdat'] as $lv_row){$lv_dat[]=array('infttl'=>$lv_row['infttl'],'infdat'=>$lv_row['infdat']);}
				$this->lo_mdl->infdat=$lv_dat;
        return $this->co_reg->document->getView( 'grlvewinf', array('data' => $this->lo_mdl) );
				break;
			
			
			// SHOW CONFIG. devuelve vista para grabar filtro / layout
			case '#showConfig':
				$lo_post = $this->co_reg->request->post;
				$lv_vewcod = ($lo_post['vewcod']??'');
				$lv_vewfltcod = ($lo_post['vewfltcod']??'');
				$lv_vewfltdat = ($lo_post['vewfltdat']??'');
				$lv_vewmaxrec = ($lo_post['vewmaxrec']??'');
        if ($lv_vewfltcod === 'undefined') {
          $lv_vewfltcod = '';
        }
        
				// carga filtro de usuario
				if($lv_vewfltcod!='') { $lo_fltmdl->load(array('vewfltcod'=>$lv_vewfltcod)); }
				$lo_fltmdl->vewfltdat = $lv_vewfltdat;
				$lo_fltmdl->vewmaxrec = $lv_vewmaxrec;
				
				// carga definicion de vista
				if( $lo_vew->loadView( $lv_vewcod )==false ){
					$lo_vewcol = array();
				} else {
					//$lo_vewhdr = $lo_vew->getHeader();
					$lo_vewcol = $lo_vew->getColumns();
					
					// preferencias de usuario (layout)
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																				'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9).'GRL_VEW'.chr(9).chr(9).
																				'[~fltrow~]usrprfkey'.chr(9).'='.chr(9).chr(9).$lv_vewcod.chr(9).chr(9).
																				'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
													);
					$lo_rs = $lo_prfmdl->getList( $lv_prm );
					if(count($lo_rs)>0){
						$lo_prfmdl->usrprfcod = $lo_rs[0]['usrprfcod'];
						$lo_prfmdl->usrprfval = $lo_rs[0]['usrprfval'];
					}				
				
					// aplica las preferencias de usuario sobre la configuracion de la vista actual
					if($lo_prfmdl->usrprfval!=''){
						$lo_rs = json_decode($lo_prfmdl->usrprfval,true);
						foreach($lo_vewcol as &$lv_row){
							foreach($lo_rs as $lv_usrrow){
								if(intval($lv_usrrow['vewfldcod'])==intval($lv_row['vewfldcod'])){
									$lv_row['vewfldord'] = $lv_usrrow['vewfldord'];
									$lv_row['vewfldflt'] = $lv_usrrow['vewfldflt'];
									$lv_row['vewfldwth'] = (intval($lv_usrrow['vewfldwth'])==0?0:(intval($lv_row['vewfldwth'])>0?$lv_row['vewfldwth']:50));
									$lv_row['vewfldcal'] = ($lv_usrrow['vewfldcal']??'');
									break;
								}
							}
						}
						unset($lv_row);
						usort( $lo_vewcol, array($this,'usortColOrder') );
					}
				}
				
        return $this->co_reg->document->getView( 'grldocfltcfg', array('data'=>$lo_fltmdl,'vewcod'=>$lv_vewcod, 'defcol'=>$lo_vewcol, 'usrprf'=>$lo_prfmdl ) );
				break;			
			
			
			
			
			
			// -------------------------------------------------------------------
			//
			//  F I L T R O S
			//
			// -------------------------------------------------------------------
			
			
			
			
			
			// FILTER. GETLIST. listar filtros
			case '#getFilterList':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]f.vewcod'.chr(9).'='.chr(9).chr(9).$lo_post['vewcod'].chr(9).chr(9).
																			'[~fltrow~](case when f.usrcod=^'.$this->co_reg->sec->usrcod.'^ then 1 when f.vewfltpub=1 then 1 else 0 end)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $lo_fltmdl->getList( $lv_prm );
				return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
				break;			
			
			
			// FILTER. SAVE. grabar filtro
			case '#saveFilter':
				$lo_post = $this->co_reg->request->post;
        $lo_post['vewfltdat'] = utf8_decode($lo_post['vewfltdat']);
				$lo_post['usrcod'] = $this->co_reg->sec->usrcod;
				$lo_post['vewfltpub'] = ($lo_post['vewfltpub']??0);
				$lo_post['vewfltdef'] = ($lo_post['vewfltdef']??0);
				if( strtolower(trim($lo_post['vewfltpub']))=='on' ) { $lo_post['vewfltpub']=1; }
				if( strtolower(trim($lo_post['vewfltpub']))=='off') { $lo_post['vewfltpub']=0; }
				if( strtolower(trim($lo_post['vewfltdef']))=='on' ) { $lo_post['vewfltdef']=1; }
				if( strtolower(trim($lo_post['vewfltdef']))=='off') { $lo_post['vewfltdef']=0; }
				// falta pasar ID de variante a la vista
				if( $lo_fltmdl->save( $lo_post )==true ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'Filtro Grabado.','vewfltcod'=>$lo_fltmdl->vewfltcod) );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_fltmdl->errtyp,'errcod'=>$lo_fltmdl->errcod,'errtxt'=>$lo_fltmdl->errtxt,'vewfltcod'=>'') );
				}
				break;
			
			
			// FILTER. DELETE. borrar filtro
			case '#deleteFilter':
				$lo_post = $this->co_reg->request->post;
				if( $lo_fltmdl->delete( $lo_post )==true ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'Filtro Grabado.','vewfltcod'=>$lo_fltmdl->vewfltcod) );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_fltmdl->errtyp,'errcod'=>$lo_fltmdl->errcod,'errtxt'=>$lo_fltmdl->errtxt,'vewfltcod'=>'') );
				}
				break;
			
			
			
			
			
			// -------------------------------------------------------------------
			//
			//  L A Y O U T
			//
			// -------------------------------------------------------------------
			
			
			
			
			
			// LAYOUT. SAVE. grabar layout de usuario
			case '#saveLayout':
				$lo_post = $this->co_reg->request->post;
				$lv_prm['usrcod'] = $this->co_reg->sec->usrcod;
				$lv_prm['usrprfgrp'] = 'GRL_VEW';
				$lv_prm['usrprfkey'] = ($lo_post['vewcod']??'');
				$lv_prm['usrprfval'] = ($lo_post['usrprfval']??'');
				$lv_prm['docsts'] = 'A';
				if( $lo_prfmdl->save( $lv_prm )==true ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'Filtro Grabado.','usrprfcod'=>$lo_prfmdl->usrprfcod) );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_prfmdl->errtyp,'errcod'=>$lo_prfmdl->errcod,'errtxt'=>$lo_prfmdl->errtxt,'usrprfcod'=>'') );
				}
				break;
			
			
			// LAYOUT. DELETE. borra layout de usuario
			case '#deleteLayout':
				$lo_post = $this->co_reg->request->post;				
				$lo_post['usrprfcod'] = ($lo_post['usrprfcod']??'');				
				if( $lo_prfmdl->delete( $lo_post )==true ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'Filtro Grabado.','vewcod'=>$lo_prfmdl->vewcod) );
				} else {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_prfmdl->errtyp,'errcod'=>$lo_prfmdl->errcod,'errtxt'=>$lo_prfmdl->errtxt,'vewcod'=>'') );
				}
				break;
    }
  }


	private function usortColOrder($a, $b){
		return ($a['vewfldord']<$b['vewfldord']?-1:1);
	}

	private function formatExportData( $lp_val, $lp_fmt=array() ){
		switch( ($lp_fmt['tmsstype']??'') ){
			case 'DATE':
				if( $lp_val instanceOf DateTime ){
					return date_format( $lp_val, ($lp_fmt['tmssformat']??'d/m/Y') );
				} else {
					return $lp_val;
				}
				break;
			case 'NUMBER':	
				$lv_dotPos = strrpos($lp_val, '.');
				$lv_commaPos = strrpos($lp_val, ',');
				$lv_sep = (($lv_dotPos > $lv_commaPos) && $lv_dotPos) ? $lv_dotPos : 
						((($lv_commaPos > $lv_dotPos) && $lv_commaPos) ? $lv_commaPos : false);
				if (!$lv_sep) {
					$lv_num = floatval(preg_replace("/[^0-9]/", "", $lp_val));
				} else {
					$lv_num = floatval(
						preg_replace("/[^0-9]/", "", substr($lp_val, 0, $lv_sep)) . '.' .
						preg_replace("/[^0-9]/", "", substr($lp_val, $lv_sep+1, strlen($lp_val)))
						);
				}
				return number_format( $lv_num,($lp_fmt['tmssdecimals']??0) , '.', ',' );
				break;
			default:				return utf8_decode( html_entity_decode( $lp_val )); break;
		}
	}
}
?>