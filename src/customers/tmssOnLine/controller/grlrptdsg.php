<?php
final class grlrptdsgController extends tmssController {
	const MODEL = 'grlrpt';
	const VIEW  = 'grlrptdsg';
	const ID = 'rptcod';
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

		$lp_act = '#' . strtolower($lp_act);
    switch( $lp_act ) {

			// LIST. devuelve la grilla con la lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['controller'] = 'grlrptdsg';
        $lp_prm['view'] = 'grlrptdsg';
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
      
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// grabo el documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
					// cargo el documento
					$this->lo_mdl->load( array(	'rptcod'=>$this->lo_mdl->rptcod, 'rptsys' => $this->lo_mdl->rptsys) );
					// cargo definicion de campos (del origen de datos)
					$lo_rptsrcmdl = $this->co_reg->load->model('sysgrlrptsrc');
					if($this->lo_mdl->rptsrccod!='') { 
            $lv_rptatr = html_entity_decode($this->lo_mdl->rptatr);	
            $lv_rptatr_arr = json_decode($lv_rptatr,true);
            $lo_rptsrcmdl->load( array('rptsrccod'=>$this->lo_mdl->rptsrccod,'rptsrcsys'=> intval(isset($lv_rptatr_arr['rptsrcsystyp']) && $lv_rptatr_arr['rptsrcsystyp']!=''?$lv_rptatr_arr['rptsrcsystyp']:$this->lo_mdl->rptsrcsys)) );
            $this->lo_mdl->rptsrcfld = $lo_rptsrcmdl->col;
						$this->lo_mdl->rptsrctxt = $lo_rptsrcmdl->rptsrctxt;
          } else {
          	$this->lo_mdl->set('rptsrcfld', array());
          }
          $this->lo_mdl->rptsys = ($lp_prm['rptsys']??$lo_post['rptsys']??'');
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve la vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo modificación o visualización
      case '#02': case '#03': case '#001':									
				$lo_post = $this->co_reg->request->post;
				$lv_key = array( self::ID=>($lp_prm[self::ID]??$lo_post[self::ID]??''),
												'rptsys'=>($lp_prm['rptsys']??$lo_post['rptsys']??''));
			
				// load object
				if ( !isset($lv_key[self::ID]) ) {
	        return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->rptcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				// cargo definicion de columnas
				$lo_rptsrcmdl = $this->co_reg->load->model('sysgrlrptsrc');
        $lv_rptatr = html_entity_decode($this->lo_mdl->rptatr);	
        $lv_rptatr_arr = json_decode($lv_rptatr,true);
        $lo_rptsrcmdl->load( array('rptsrccod'=>$this->lo_mdl->rptsrccod,'rptsrcsys'=> intval(isset($lv_rptatr_arr['rptsrcsystyp']) && $lv_rptatr_arr['rptsrcsystyp']!=''?$lv_rptatr_arr['rptsrcsystyp']:$this->lo_mdl->rptsrcsys)) );
				$this->lo_mdl->rptsys = ($lp_prm['rptsys']??$lo_post['rptsys']??'');
				$this->lo_mdl->rptsrcfld = $lo_rptsrcmdl->col;
				$this->lo_mdl->rptsrctxt = $lo_rptsrcmdl->rptsrctxt;

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;			
			
			
      // SAVE SECURITY. establece la seguridad de un reporte
      case '#21':
        $this->lo_mdl->saveSecurity();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
        
      // GET SECURITY. recupera la seguridad de un reporte
      case '#22':
        $lo_rs = $this->lo_mdl->getSecurity();
        $lv_dat = (isset($lo_rs[0]) ? $lo_rs[0] : '');
      	return $this->co_reg->document->getJson( array('data'=>$lv_dat, 'errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
        
      
      // GET REPORT LIST. devuelve la vista con la lista de reportes
      case '#getreportlist':
        $lv_prm = array();
				$lo_rs = $this->lo_mdl->getReportList($lv_prm);

				// cargo roles de usuario
				$lo_grpmdl = $this->co_reg->load->model('syssecusrgrp');
				$lo_grprs = $lo_grpmdl->load( array('usrcod'=>$this->co_reg->sec->usrcod) );

				return $this->co_reg->document->getView( 'grlrptlst', array('secusrrls'=>$lo_grprs,'data'=>$lo_rs,'actcod'=>$this->data['actcod']) );
        break;
      
				
			// GET REPORT DEFINITION. obtiene la definicion del reporte
			case '#getreportdefinition':
				$lo_post = $this->co_reg->request->post;
				
				// cargo la definicion del reporte
				$this->lo_mdl->load( array('rptcod'=>$lo_post['rptcod'], 'rptsys'=>$lo_post['rptsys']) );
        
        // armo vewcod
				$lv_vewcod = 'GRL_RPT_'.($lo_post['rptsys']=='0'?'SYS':'USR').'_'.$lo_post['rptcod'];
				
        // busco el filtro por defecto
        $lv_vewfldfltdat = '';
        $lv_vewfltcod = '';
        $lo_fltmdl = $this->co_reg->load->model('grldocflt');
        $lv_prm = array('vewmaxrec' =>'1',
                        'vewfldflt' =>'[~fltrow~]f.vewcod'   .chr(9).'='.chr(9).chr(9).$lv_vewcod.chr(9).chr(9).
                                      '[~fltrow~]f.usrcod'   .chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
                                      '[~fltrow~]f.vewfltdef'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                                      '[~fltrow~]f.docsts'   .chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );
        $lo_rs = $lo_fltmdl->getList($lv_prm);
        if (count($lo_rs) > 0) {
          $lv_vewfldfltdat = $lo_rs[0]['vewfltdat'];
          $lv_vewfltcod = $lo_rs[0]['vewfltcod'];
        }
        
				// cargo la definicion de fuente de datos
				$lv_coldef = array();
				if($this->lo_mdl->rptsrccod!=''){
					$lo_rptsrcmdl = $this->co_reg->load->model('sysgrlrptsrc');
          $lv_rptatr = html_entity_decode($this->lo_mdl->rptatr);	
        	$lv_rptatr_arr = json_decode($lv_rptatr,true);
					$lo_rptsrcmdl->load( array('rptsrccod'=>$this->lo_mdl->rptsrccod,'rptsrcsys'=> intval(isset($lv_rptatr_arr['rptsrcsystyp']) && $lv_rptatr_arr['rptsrcsystyp']!=''?$lv_rptatr_arr['rptsrcsystyp']:$this->lo_mdl->rptsrcsys)) );
          $lv_rptsrcdat = $lo_rptsrcmdl->getData();
          
          if(isset($lv_rptsrcdat['col'])){
            foreach($lv_rptsrcdat['col'] as $lv_col){
              $lv_fld = $this->co_reg->input->getField( strtolower($this->co_reg->document->getTagValue($lv_col['rptsrccolatr'],'def')) );
              // si el tipo de campo definido en el origen no es válido, devuelvo un error.
              if(!$lv_fld || $lv_fld == ''){ return $this->co_reg->document->getJson( array( 'errtyp'=>'E', 'errcod'=>'1', 'errtxt'=>'El tipo de campo ['.strtolower($this->co_reg->document->getTagValue($lv_col['rptsrccolatr'],'def').'] no existe.') ) ); }
              $lv_col['sysfldinptyp'] = $lv_fld['sysfldinptyp'];
              $lv_coldef[] = $lv_col;
            }
          }
				}
        
				return $this->co_reg->document->getJson( array('rpt'=>$this->lo_mdl->getData(), 'def'=>$lv_coldef, 'vewcod'=>$lv_vewcod, 'vewfldfltdat'=>$lv_vewfldfltdat, 'vewfltcod'=>$lv_vewfltcod) );
				break;
      
			
			// SHOW REPORT. muestra la vista de reportes para mostrar un reporte
			case '#show':
				$lo_post = $this->co_reg->request->post;
        
        $lv_rptcod = ($lo_post['rptcod']??'');
        $lv_rptcod = ($lv_rptcod!=''?$lv_rptcod:($lp_prm['rptcod']??''));
        // REPORTE. cargo datos del reporte
				// si se indicó id de reporte, cargo la definicion desde la base de datos
				if( $lv_rptcod!='' ){
					$this->lo_mdl->load( array('rptcod'=>$lv_rptcod, 'rptsys'=>$lo_post['rptsys'] ) );
          $lv_rptatr = html_entity_decode($this->lo_mdl->rptatr);	
          $lv_rptatr_arr = json_decode($lv_rptatr,true);
				// sino, utilizo la definición proporcionada por post
				} else {
					$this->lo_mdl->rptsrccod = ($lo_post['rptsrccod']??'');
					$this->lo_mdl->rptsrcsys = ($lo_post['rptsrcsys']??'');
					$this->lo_mdl->rptatr = html_entity_decode(isset($lo_post['rptatr'])?utf8_decode($lo_post['rptatr']):'');
				}

        // DEFINICION. cargo datos de la definición del reporte
        $lo_rptsrcmdl = $this->co_reg->load->model('sysgrlrptsrc');
        if( $this->lo_mdl->rptsrccod!='' ){
        	$lo_rptsrcmdl->load( array('rptsrccod'=>$this->lo_mdl->rptsrccod,'rptsrcsys'=> intval(isset($lv_rptatr_arr['rptsrcsystyp']) && $lv_rptatr_arr['rptsrcsystyp']!=''?$lv_rptatr_arr['rptsrcsystyp']:$this->lo_mdl->rptsrcsys)) );
        }
				// SALIDA. se preparan datos para la salida
        $this->lo_mdl->rptsrc = $lo_rptsrcmdl;
        $this->lo_mdl->included = ($lo_post['included']??'');
        $this->lo_mdl->popup = ($lo_post['popup']??'');
        $this->lo_mdl->depth = ($lo_post['depth']??'');
        $this->lo_mdl->vewfldflt = ($lo_post['vewfldflt']??'');
        $this->lo_mdl->vewfldord = ($lo_post['vewfldord']??'');
        $this->lo_mdl->vewmaxrec = ($lo_post['vewmaxrec']??'100');
        //Habia un error en el caso de no recibir un mensaje, quitar esto si es necesario.
        $this->lo_mdl->rptmsgcls = (($this->lo_mdl->rptmsgcls!='')?$this->lo_mdl->rptmsgcls : array()); 
        // Asigno el código de vista (vewcod) recibido por POST
        $this->lo_mdl->vewcod = ($lo_post['vewcod']??'');
        $this->lo_mdl->vewfltcod = ($lo_post['vewfltcod']??'');
				// devuelvo vista de reporte
				return $this->co_reg->document->getView( 'grlrpt', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
      
			
			// GET REPORT DATA. obtiene los datos para el reporte
			case '#getreportdata':
				$lo_post = $this->co_reg->request->post;
				$lv_sqlstm = '';
				
				// cargo la definicion del reporte
				if( ($lo_post['rptcod']??'')!='' ){
					$this->lo_mdl->load( array('rptcod'=>$lo_post['rptcod']) );
          $lv_rptatr = html_entity_decode($this->lo_mdl->rptatr);	
        	$lv_rptatr_arr = json_decode($lv_rptatr,true);	
				} else {
					$this->lo_mdl->create();
					$this->lo_mdl->rptsrccod = ($lo_post['rptsrccod'] ?? '' );
					$this->lo_mdl->rptsrcsys = ($lo_post['rptsrcsys'] ?? '' );
				}
				
				// valido que exista un origen de reporte
				if($this->lo_mdl->rptsrccod==''){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe inidicar un origen de datos para el reporte.') );
				}
				
				// cargo la definicion de fuente de datos	
				$lo_rptsrcmdl = $this->co_reg->load->model('sysgrlrptsrc');
				if(!$lo_rptsrcmdl->load( array('rptsrccod'=>$this->lo_mdl->rptsrccod,'rptsrcsys'=> intval(isset($lv_rptatr_arr['rptsrcsystyp']) && $lv_rptatr_arr['rptsrcsystyp']!=''?$lv_rptatr_arr['rptsrcsystyp']:$this->lo_mdl->rptsrcsys)) )){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_rptsrcmdl->errtyp,'errcod'=>$lo_rptsrcmdl->errcod,'errtxt'=>$lo_rptsrcmdl->errtxt) );
        }

				// parseo de sentencia
				$lv_rptsrc = html_entity_decode( htmlspecialchars_decode( strtolower($lo_rptsrcmdl->rptsrcsrc) ) );
				$lv_rptsrctyp = $lo_rptsrcmdl->rptsrctyp;				
				$this->lo_mdl->cols = $lo_rptsrcmdl->col;
				$this->lo_mdl->vewfldflt = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
				$this->lo_mdl->vewmaxrec = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'100');
				$this->lo_mdl->vewfldord = (isset($lo_post['vewfldord'])?$lo_post['vewfldord']:'');
				
				// armo lista y mapeo de campos
				$lo_rptcol = $this->lo_mdl->cols;
				
				// fijo filtros de vista y filtros por restriccion de usuario
				$lo_vewmdl = $this->co_reg->load->model('grlvew');
				$lv_vewprm =array('vewfldflt'=>(isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:''),
													'vewmaxrec'=>(isset($lo_post['vewmaxrec'])?intval($lo_post['vewmaxrec']):100),
													'vewfldord'=>(isset($lo_post['vewfldord'])?$lo_post['vewfldord']:'')
													);
				$lv_vewflt = $lo_vewmdl->parseViewOptions( $lv_vewprm );		
				$lo_data = array();
				// OBTENER DATOS. datos por STORED PROCEDURE
				if( $lv_rptsrctyp=='SP' ) {

					// a partir del string del SP, armo un array con los valores y string con la sentencia
					$lv_sqltxt = '';
					$lv_sqlprm = array();
					
					// separo los campos de la sentencia por coma (,) en un array
					$lv_sqlprmsrc = explode(',',$lv_rptsrc);
					// obtengo el nombre del SP/accion a ejecutar
					$lv_sqlprmsp = explode(' ',$lv_sqlprmsrc[0]);
					// reemplazo la primer pos que tiene SP y accion por la accion unicamente
					$lv_sqlprmsrc[0] = $lv_sqlprmsp[1];
					// para cada parametro del array, si el valor es "null" se arma en el string como ?
					for($i=0; $i<count($lv_sqlprmsrc); $i++){
						if ( trim(strtolower($lv_sqlprmsrc[$i]))=='null' ) {
							$lv_sqltxt .= ($lv_sqltxt==''?'':',') . 'null';
						} else {
							$lv_sqltxt .= ($lv_sqltxt==''?'':',') . '?';
							
							// reemplazo as variables por los valores
							$lv_sqlprmsrc[$i] = str_ireplace( '<application>usrcod</application>', $this->co_reg->sec->usrcod, $lv_sqlprmsrc[$i] );
							$lv_sqlprmsrc[$i] = str_ireplace( '<application>buscod</application>', $this->co_reg->sec->buscod, $lv_sqlprmsrc[$i] );
							$lv_sqlprmsrc[$i] = str_ireplace( '<rpt>rptcod</rpt>', $this->lo_mdl->rptcod, $lv_sqlprmsrc[$i] );
							$lv_sqlprmsrc[$i] = str_ireplace( '<view>options</view>', $this->co_reg->db->sqldat(array('view_options' => $lv_vewflt), 'view_options', false), $lv_sqlprmsrc[$i]) ;
							
              array_push($lv_sqlprm, trim($lv_sqlprmsrc[$i]) );
						}						
					}
					
					$lv_sqltxt = $lv_sqlprmsp[0].'('.$lv_sqltxt.')';
					$lo_data = $this->lo_mdl->getReportData( $lv_sqlprm, $lv_sqltxt );
					$lv_sqlstm = $this->lo_mdl->getsysdata('sqlstm');
				}
				
				// OBTENER DATOS. datos por PROGRAMA
				if( $lv_rptsrctyp=='PR' ) {
					$lv_prm = array();
					$lv_rptsrc = html_entity_decode($lo_rptsrcmdl->rptsrcsrc );
					$lv_rptarr = explode( '&', $lv_rptsrc );
					$lv_controller='';
					$lv_action='';
					foreach($lv_rptarr as $lv_row){
						$lv_rptarrprm = explode('=',$lv_row);
						switch( strtolower($lv_rptarrprm[0]) ) {
							case '?prg': $lv_controller = $lv_rptarrprm[1]; break;
							case 'act': $lv_action = $lv_rptarrprm[1]; break;
							default: $lv_prm[$lv_rptarrprm[0]] = $lv_rptarrprm[1]; break;
						}
					}					
					$lv_prm['vewprm'] = $lv_vewprm;
					if ( $lv_controller!='' && $lv_action!='' ) {
						$lo_ctr = $this->co_reg->load->controller( $lv_controller );
						$lo_data = $lo_ctr->index( $lv_action , $lv_prm );
					}
				}
				
				// PREPARAR DATOS. preparo datos para return
				if (is_array($lo_data)) {
					foreach($lo_data as &$lv_row){
						
						// recorre todas las columnas del reporte y recupera los datos necesarios
						foreach ( $lo_rptcol as $lv_col ) {
							$lv_val = '';
							$lv_val2 = '';
							$lv_tagvalue = false;
							$lv_tagnme = '';

							// DETERMINAR VALOR. determino valor del campo
							
							// se solicito un dbo.getTagValue ( "," y "^" requerido)
							if( strtolower(substr($lv_col['rptsrccolcodext'],0,15))=='dbo.gettagvalue' && stripos($lv_col['rptsrccolcodext'],',')!=false && stripos($lv_col['rptsrccolcodext'],'^')!=false ){ 
								$lv_tagvalue = true;
								$lv_colcodext = str_ireplace('dbo.gettagvalue(','',str_ireplace('^','',str_ireplace(' ','',$lv_col['rptsrccolcodext'])));
								$lv_colcodext = substr($lv_colcodext,0,strlen($lv_colcodext)-1);
								$lv_tagnme = explode(',',$lv_colcodext)[0];
								$lv_fldnme = strtolower(explode(',',$lv_colcodext)[1]);
							// se solicitó un campo
							} else {
								$lv_fldnme = strtolower($lv_col['rptsrccolcodext']);
							}
							// si tiene alias lo quito del nombre del campo
							if ( strpos($lv_fldnme,'.') ) { $lv_fldnme = explode('.',$lv_fldnme)[1]; }
							// si la columna de la vista ESTA en el recordset
							if ( isset($lv_row[$lv_fldnme]) ) {
								if($lv_tagvalue){
									$lv_val = $this->co_reg->document->getTagValue( $lv_row[$lv_fldnme], $lv_tagnme );
								} else {
									$lv_val = $lv_row[$lv_fldnme];
								}
							}
								
							// CASTEAR. prepara dato para salida
							
							// FECHA. se formatea el campo como fecha
							if( $lv_val instanceof DateTime ) {
								$lv_val2 = $lv_val->format('d/m/Y');
							} else if( $lv_col['sysfldinptyp']=='DATE' ){
								$lv_val2 = $lv_val; //date_create_from_format('d/m/Y',$lv_val);
							// NUMERO. formatear según decimales del campo
							} else if( $lv_col['sysfldinptyp']=='NUMBER' ){
								$lv_val2 = number_format( $lv_val , $lv_col['sysfldoutsze'] );
							// TEXTO. se convierte utf8
							} else {
								$lv_val2 = utf8_encode( $lv_val ); 
							}
							$lv_row[$lv_col['rptsrccolcodext']] = $lv_val2;
						}
					}
					unset($lv_row);
				}
				
				return $this->co_reg->document->getJson( array('data'=>$lo_data,'def'=>$lo_rptsrcmdl->col,'stm'=>$lv_sqlstm, 'src'=>$lo_rptsrcmdl->rptsrcsrc) );
				break;
			
    }
  }
	
	private function export_normalize_array( $lp_val ) {
		if(is_a($lp_val, 'DateTime')){
			return $lp_val->format('d/m/Y');
		} else if( is_array($lp_val) ) {
			return mb_detect_encoding(implode( '.', $lp_val ), 'UTF-8') ? implode( '.', $lp_val ) : utf8_decode( implode( '.', $lp_val ) );
		} else {
			return mb_detect_encoding($lp_val, 'UTF-8') ? $lp_val : utf8_decode( $lp_val );
		}
	}
	
}
?>