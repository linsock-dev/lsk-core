<?php
final class grldatprcController extends tmssController {
	const MODEL = 'grldatprc';
	const VIEW  = 'grldatprc';
	const ID = 'grldatprc';
	const OBJTYP ='GRL_PRC';
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

			// LIST. devuelve la grilla con la lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_dat = $this->co_reg->request->post;
				
        if ( $this->lo_mdl->save( $lo_dat ) ) {
					$lv_buffer = $this->co_reg->request->post['prcschcnd'];
					if ($lv_buffer!='') {
						$i=0;
						$lo_schcndmdl = $this->co_reg->load->model('grldatprccnd');
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_schcnd_arr = json_decode($lv_buffer,true);
						foreach( $lv_schcnd_arr as $lv_row ) {
							$lv_row['prcschcod'] = $this->lo_mdl->prcschcod;
							if ( isset($lv_row['deleted']) ) {
								if ($lo_schcndmdl->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_schcndmdl->errtyp,'errcod'=>$lo_schcndmdl->errcod,'errtxt'=>$lo_schcndmdl->errtxt,'row'=>$i) );
								}
							} else if ($lo_schcndmdl->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_schcndmdl->errtyp,'errcod'=>$lo_schcndmdl->errcod,'errtxt'=>$lo_schcndmdl->errtxt,'row'=>$i) );
							}
							$i++;
						}
					}
					
					// cargo datos del documento
					$this->lo_mdl->load( array('prcschcod'=>$this->lo_mdl->prcschcod) );
					
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
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo visualización o modificación
      case '#02': case '#03': case '#001':									
				$lo_post = $this->co_reg->request->post;
				
				// INICIALIZO. obtengo e inicializo las variables
				$lv_dat = array();
				$lv_dat['dochdr'] = json_decode(html_entity_decode(isset($lo_post['dochdr'])?$lo_post['dochdr']:'{}'),true);
				$lv_dat['docpos'] = json_decode(html_entity_decode(isset($lo_post['docpos'])?$lo_post['docpos']:'{}'),true);
				$lv_dat['docprc'] = json_decode(html_entity_decode(isset($lo_post['docprc'])?$lo_post['docprc']:'[]'),true);

				if(!isset($lv_dat['dochdr']['prcschcalctr'])){ $lv_dat['dochdr']['prcschcalctr']='grldatprc'; }
				if(!isset($lv_dat['dochdr']['prcschcalact'])){ $lv_dat['dochdr']['prcschcalctr']='02'; }
				
				// ESQUEMA DE PRECIOS. obtengo condiciones del esquema de precios
				if( (isset($lv_dat['dochdr']['prcschcod'])?$lv_dat['dochdr']['prcschcod']:'')!='' ) {
					$lo_schmdl = $this->co_reg->load->model('grlprcsch');
					$lo_schmdl->load( array('prcschcod'=>$lv_dat['dochdr']['prcschcod']) );
					$this->lo_mdl->sch = $lo_schmdl;
				} else {

					// CLASE DE DOCUMENTO. obtengo clase de documento
					$lv_sysdocclscod = (isset($lv_dat['dochdr']['sysdocclscod'])?$lv_dat['dochdr']['sysdocclscod']:0);
					if($lv_sysdocclscod==0){ return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo determinar la clase de documento.</errtxt>'; }
					$lo_docmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docmdl->load( array('sysdocclscod'=>$lv_sysdocclscod) );
					$lv_prcschcod = $this->co_reg->document->getTagValue( $lo_docmdl->sysdocclsatr, 'prcschcod' );
						
					// ESQUEMA DE PRECIOS. obtengo esquema de precios
					if( ($lv_prcschcod==''?0:$lv_prcschcod)==0 ) {return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se pudo determinar el esquema de precios de la clase de documento.</errtxt>'; }					
					$lo_schmdl = $this->co_reg->load->model('grlprcsch');
					$lo_schmdl->load( array('prcschcod'=>$lv_prcschcod) );
					$this->lo_mdl->sch = $lo_schmdl;
				}

				// RETURN. devuelvo vista
				$this->lo_mdl->dochdr = $lv_dat['dochdr'];
				$this->lo_mdl->docpos = $lv_dat['docpos'];
				$this->lo_mdl->docprc = $lv_dat['docprc'];
				$this->lo_mdl->sec = (isset($lo_post['sec'])?$lo_post['sec']:'');
				$this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'false');
				$this->lo_mdl->totalonly = (isset($lo_post['totalonly'])?$lo_post['totalonly']:'false');
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
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
								
				// INICIALIZO. obtengo e inicializo las variables
				$lv_dat = array();
				$lv_dat['dochdr'] = json_decode(html_entity_decode((isset($lo_post['dochdr'])?$lo_post['dochdr']:'{}')),true);
				$lv_dat['docpos'] = json_decode(html_entity_decode((isset($lo_post['docpos'])?$lo_post['docpos']:'{}')),true);
				$lv_dat['docprc'] = json_decode(html_entity_decode((isset($lo_post['docprc'])?$lo_post['docprc']:'[]')),true);
				
				$lv_out = $this->calculate($lv_dat);
				$lv_out['sec'] = (isset($lo_post['sec'])?$lo_post['sec']:'');
				$lv_out['readonly'] = (isset($lo_post['readonly'])?$lo_post['readonly']:'false');
				
				// RETURN. devuelvo esquema actualizado
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lv_out) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
				}
				break;
    }
  }
	
	
	
	public function calculate( $lp_dat ) {
		// INICIALIZO. obtengo e inicializo las variables
		$lv_dat = $lp_dat;
		$lv_out = array('docprc'=>$lv_dat['docprc']);
		
		// ESQUEMA DE PRECIOS. obtengo condiciones del esquema de precios
		if( (isset($lv_dat['dochdr']['prcschcod'])?$lv_dat['dochdr']['prcschcod']:'')!='' ) {
			$lo_prcmdl = $this->co_reg->load->model('grlprcsch');
			$lo_prcmdl->load( array('prcschcod'=>$lv_dat['dochdr']['prcschcod']) );
		} else {
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>No se indicó esquema de precios.</errtxt>';
		}
		
		// CALCULO. calculo precios de posicion.
		$lv_posprc_in = $lv_dat['docprc'];
		if(!is_array($lv_posprc_in) && !is_object($lv_posprc_in)){ $lv_posprc_in = json_decode(html_entity_decode($lv_posprc_in)); }
		if(is_object($lv_posprc_in)){ $lv_posprc_in = json_decode(json_encode($lv_posprc_in), true); }
		$lv_posprc_out = $this->calcPosition( $lv_dat['dochdr'], $lv_dat['docpos'], $lv_posprc_in, $lo_prcmdl->prcschcnd );
		$lv_out['docprc'] = $lv_posprc_out;
		$lv_out['dochdr'] = $lv_dat['dochdr'];
		$lv_out['docpos'] = $lv_dat['docpos'];
    
    //formateo esquema como 0000.00
    foreach($lv_out['docprc'] as &$lv_row){
      if($lv_row['prccndval'] != ""){$lv_row['prccndval'] = floatval(number_format($lv_row['prccndval'], 2, '.', ''));}
      if($lv_row['prccndqty'] != ""){$lv_row['prccndqty'] = floatval(number_format($lv_row['prccndqty'], 2, '.', ''));}
      if($lv_row['prccndtot'] != ""){$lv_row['prccndtot'] = floatval(number_format($lv_row['prccndtot'], 2, '.', ''));}
    }
		
		return $lv_out;
	}
	
	
	
	// --------------------------------------------------------------------------
	// CALC POSITION
	// realiza el cálculo de precios de un esquema para una posición de un documento
	// - input:
	//			doc: datos de cabecera
	//			docpos: posicion del documento
	//			docposprc: condiciones de precio de la posición en el documento para el esquema de precios
	//			schprc: esquema de precios (template)
	// - output:
	//			esquema de precios actualizado para la posición
	// --------------------------------------------------------------------------
	private function calcPosition( $lp_dochdr, $lp_docpos, $lp_docprc, $lp_schprc ){
		$lo_forctr = $this->co_reg->load->controller('grlprccndfor');
		$lv_out = $lp_schprc;

		//$lo_grldatprcmdl = $this->co_reg->load->model('grldatprc');
		if( isset($lp_dochdr['prcdte']) ){
			$lv_dte = date_create_from_format( 'd/m/Y', $lp_dochdr['prcdte'] );
		} else {
			$lv_dte = new Datetime();
		}
		
		// INICIALIZO.
		// armo el esquema de salida inicialmente con los precios actuales
		foreach( $lv_out as &$lv_row ) {
			unset($lv_row['ctedte']);
			unset($lv_row['upddte']);
			$lv_row['prccndstd']=$lv_row['prcschcndstd'];
			$lv_row['prcchgman']='';
			$lv_row['prccndqty'] = 0;
			$lv_row['prccnduntcod'] = 'UN';		// *************** CAMBIAR *************
			$lv_row['prccndval'] = 0;
			$lv_row['prccndcurcod'] = 'ARS';	// *************** CAMBIAR *************
			$lv_row['prccndtot'] = 0;
			$lv_row['curcod'] = 'ARS';				// *************** CAMBIAR *************
			// busco los valores pre-existentes de la condición
			foreach($lp_docprc as $lv_rowdoc){
				if(!is_array($lv_rowdoc) && !is_object($lv_rowdoc)){ $lv_rowdoc = json_decode(html_entity_decode($lv_rowdoc)); }
				if(is_object($lv_rowdoc)){ $lv_rowdoc = json_decode(json_encode($lv_rowdoc), true); }
				if(isset($lv_rowdoc['prcschcndrow'])){
					if($lv_row['prcschcndrow']==$lv_rowdoc['prcschcndrow']){
						$lv_row['prccndrowcod'] = (isset($lv_rowdoc['prccndrowcod'])?$lv_rowdoc['prccndrowcod']:'');
						$lv_row['prccndqty'] = $lv_rowdoc['prccndqty'];
						$lv_row['prccnduntcod'] = $lv_rowdoc['prccnduntcod'];
						$lv_row['prccndval'] = $lv_rowdoc['prccndval'];
						$lv_row['prccndcurcod'] = $lv_rowdoc['prccndcurcod'];
						$lv_row['prccndtxt']=$lv_rowdoc['prccndtxt'];
						$lv_row['prccndstd']=(isset($lv_rowdoc['prccndstd'])?$lv_rowdoc['prccndstd']:'');
						// si el total fue modificado manualmente, asigno valor
            if (!isset($lv_rowdoc['prcschcndman'])){
              $lv_rowdoc['prcschcndman'] = $lv_row['prcschcndman'];
            }
						if($lv_rowdoc['prcchgman']!='' && $lv_rowdoc['prcschcndman']=='TOT'){
							$lv_row['prccndtot'] = $lv_rowdoc['prccndtot'];
						} else {
              if($lv_rowdoc['prccnduntcod']=='%'){
                $lv_row['prccndtot'] = round(floatval($lv_rowdoc['prccndval']) * floatval($lv_rowdoc['prccndqty'] / 100), 2);
              } else if($lv_row['prccnduntcod']!=''){
                $lv_row['prccndtot'] = round(floatval($lv_rowdoc['prccndval']) * floatval($lv_rowdoc['prccndqty']) ,2);
              }
						}
						$lv_row['prcchgman'] = $lv_rowdoc['prcchgman'];
					}
				}
			}
		}
		unset($lv_row);
		
		
		// CALCULO. sumarizo los totales del esquema
		foreach($lv_out as &$lv_row){
			
			// RANGO. sumo valores desde-hasta (si el valor no fue modificado manualmente) (FALTA. quitar valores estadisticos)
      if($lv_row['prcchgman']==''){
        $lv_subtot = 0;
        if(intval($lv_row['prcschcndrowstr'])+intval($lv_row['prcschcndrowend'])>0) {
          foreach($lv_out as $lv_row2) {
            if( intval($lv_row2['prcschcndrow'])>=intval($lv_row['prcschcndrowstr']) && intval($lv_row2['prcschcndrow'])<=intval($lv_row['prcschcndrowend']) ) {
              $lv_subtot += floatval($lv_row2['prccndtot']);
            }
          }
          if($lv_row['prccndcod']=='0'){
            $lv_row['prccndtot'] = round(floatval($lv_subtot),2);
          } else {
            $lv_row['prccndval'] = round(floatval($lv_subtot),2);
          }
        }
      }
			
			
			// TEXTO. determino texto de la condiciones
			if($lv_row['prccndcod']=='0'){
				$lv_row['prccndtxt'] = $lv_row['prccndttl'];
				$lv_row['prccndval'] = '';
				$lv_row['prccndcurcod'] = '';
				$lv_row['prccndqty'] = '';
				$lv_row['prccnduntcod'] = '';
			}
			
			
			// actualizo fórmulas (si el valor no fue modificado manualmente)
			if($lv_row['prcchgman']==''){
				
				// REGISTRO. busco registro de condición
				if($lv_row['prccndcod']!='0'){
					$lv_prcrec = $this->findConditionRecord( $lv_row['prccndcod'], $lv_dte, $lp_docpos );
					if(count($lv_prcrec['prccnd'])>0){
						$lv_prc = $lv_prcrec['prccnd'];
						if($lv_prc['prccndcurcod']!=''){
							$lv_row['prccndval'] = $lv_prc['prccndval'];
							$lv_row['prccndcurcod'] = $lv_prc['prccndcurcod'];
						}
						if($lv_prc['prccnduntcod']!=''){
							$lv_row['prccndqty'] = $lv_prc['prccndqty'];
							$lv_row['prccnduntcod'] = $lv_prc['prccnduntcod'];
						}
						
						// CALCULO. inicial en función del registro de condición
						if($lv_row['prccnduntcod']=='%'){
							$lv_row['prccndtot'] = $lv_row['prccndval'] * $lv_row['prccndqty'] / 100;
						} else if($lv_row['prccnduntcod']!=''){
							$lv_row['prccndtot'] = $lv_row['prccndval'] * $lv_row['prccndqty'];
						}
					}
					$lv_row['prccndfndlog'] = $lv_prcrec['prccndfndlog']??array();
				}
				
				
				
				// CONSTANTES DE REFERENCIA. 
				// @@CANTIDAD, @@VALOR, @@TOTAL, @@CANTIDAD.ROWnnnnn y @@VALOR.ROWnnnnn, @@TOTAL.ROWnnnnn
				for($i=0;$i<3;$i++){
					$lv_fld = ($i==0?'prccndforsrcval':($i==1?'prccndforsrcqty':'prccndforsrctot'));
					$lv_found =( stripos($lv_row[$lv_fld],'@@CANTIDAD.ROW')!==false || stripos($lv_row[$lv_fld],'@@VALOR.ROW')!==false || stripos($lv_row[$lv_fld],'@@TOTAL.ROW')!==false );
					if( $lv_found && $lv_row[$lv_fld]!='' ){
						while( $lv_found ){
							if(stripos($lv_row[$lv_fld],'@@CANTIDAD.ROW')!==false){
								$lv_getfld = 'prccndqty';
								$lv_repfld = '@@CANTIDAD.ROW';
								$lv_getrow = substr($lv_row[$lv_fld],stripos($lv_row[$lv_fld],'@@CANTIDAD.ROW')+14,5);								
							} else if(stripos($lv_row[$lv_fld],'@@VALOR.ROW')!==false){
								$lv_getfld = 'prccndval';
								$lv_repfld = '@@VALOR.ROW';
								$lv_getrow = substr($lv_row[$lv_fld],stripos($lv_row[$lv_fld],'@@VALOR.ROW')+11,5);
							} else if(stripos($lv_row[$lv_fld],'@@TOTAL.ROW')!==false){
								$lv_getfld = 'prccndtot';
								$lv_repfld = '@@TOTAL.ROW';
								$lv_getrow = substr($lv_row[$lv_fld],stripos($lv_row[$lv_fld],'@@TOTAL.ROW')+11,5);
							}
              $lv_rowfound = false;
							foreach($lv_out as $lv_row2) {
								if( intval($lv_row2['prcschcndrow'])==intval($lv_getrow) ) {
									$lv_row[$lv_fld] = str_ireplace($lv_repfld.$lv_getrow,$lv_row2[$lv_getfld],$lv_row[$lv_fld]);
                  $lv_rowfound = true;
									break;
								}
							}
              if (!$lv_rowfound){
                $lv_row[$lv_fld] = str_ireplace($lv_repfld.$lv_getrow,$lv_row2[$lv_getfld],$lv_row[$lv_fld]);
              }
							$lv_found =( stripos($lv_row[$lv_fld],'@@CANTIDAD.ROW')!==false || stripos($lv_row[$lv_fld],'@@VALOR.ROW')!==false || stripos($lv_row[$lv_fld],'@@TOTAL.ROW')!==false );
						}
					}
				}
				
				
				
				// FORMULA PERSONALIZADA - valor/cantidad/um/total/moneda dependen de un controlador externo
				if($lv_row['prccndforsrctyp']=='1'){

					// reemplazo constantes antes de ejecutar la formula personalizada
					for($i=0;$i<3;$i++){
						$lv_fld = ($i==0?'prccndforsrcval':($i==1?'prccndforsrcqty':'prccndforsrctot'));
						$lv_found =( stripos($lv_row[$lv_fld],'@@CANTIDAD')!==false || stripos($lv_row[$lv_fld],'@@VALOR')!==false || stripos($lv_row[$lv_fld],'@@TOTAL')!==false );
						if($lv_found){
							$lv_row[$lv_fld] = str_ireplace('@@VALOR',doubleval($lv_row['prccndval']),$lv_row[$lv_fld]);
							$lv_row[$lv_fld] = str_ireplace('@@CANTIDAD',doubleval($lv_row['prccndqty']),$lv_row[$lv_fld]);
							$lv_row[$lv_fld] = str_ireplace('@@TOTAL',doubleval($lv_row['prccndtot']),$lv_row[$lv_fld]);
						}
					}
					
					// llamo al controlador pasando como parámetros los datos del documento, posición y condición
					$lv_ctr='';
					$lv_act='';
					$lv_prmarr = explode('&',html_entity_decode($lv_row['prccndforsrcsrc']));
					foreach($lv_prmarr as $lv_prmrow){
						$lv_key = explode('=',$lv_prmrow);
						if($lv_key[0]=='?prg'){ $lv_ctr=$lv_key[1]; }
						if($lv_key[0]=='act'){ $lv_act=$lv_key[1]; }
					}
					$lo_retarr=array();
					if($lv_ctr!='' && $lv_act!=''){
						$lo_frmctr = $this->co_reg->load->controller( $lv_ctr );
						$lo_ret = $lo_frmctr->index( $lv_act, array('dochdr'=>$lp_dochdr,'docpos'=>$lp_docpos,'docprc'=>$lv_row,'docsch'=>$lv_out) );
						$lo_retarr = JSON_DECODE( $lo_ret, true );
					}
					
					// obtengo el resultado de la formula
					$lv_row['prccndqty'] = (!isset($lo_retarr['prccndqty'])?$lv_row['prccndqty']:$lo_retarr['prccndqty']);
					$lv_row['prccnduntcod'] = (!isset($lo_retarr['prccnduntcod'])?$lv_row['prccnduntcod']:$lo_retarr['prccnduntcod']);
					$lv_row['prccndval'] = (!isset($lo_retarr['prccndval'])?$lv_row['prccndval']:$lo_retarr['prccndval']);
					$lv_row['prccndtot'] = (!isset($lo_retarr['prccndtot'])?$lv_row['prccndval']*$lv_row['prccndqty']:$lo_retarr['prccndtot']);
					$lv_row['prccndcurcod'] = (!isset($lo_retarr['prccndcurcod'])?$lv_row['prccndcurcod']:$lo_retarr['prccndcurcod']);
				
				
				// FORMULA ESTANDAR
				} else if($lv_row['prccndforsrctyp']=='2') {
					
					// valor
					if( $lv_row['prccndforsrcval']!='' ) {
						// reemplazo constantes @@VALOR y @@CANTIDAD antes de ejecutar la formula
						$lv_row['prccndforsrcval'] = str_ireplace('@@VALOR',doubleval($lv_row['prccndval']),$lv_row['prccndforsrcval']);
            $lv_row['prccndforsrcval'] = str_ireplace('@@CANTIDAD',doubleval($lv_row['prccndqty']),$lv_row['prccndforsrcval']);
						$lv_row['prccndval'] = $lo_forctr->evalFormula( $lv_row['prccndforsrcval'], $lp_docpos );
						$lv_row['prccndval'] = round(floatval($lv_row['prccndval']), 2);
						if($lv_row['prccndcurcod']==''){ $lv_row['prccndcurcod'] = (isset($lp_dochdr['curcod'])?$lp_dochdr['curcod']:'ARS'); }
					}
					
					// cantidad
					if( $lv_row['prccndforsrcqty']!='' ) {
						// reemplazo constantes @@VALOR y @@CANTIDAD antes de ejecutar la formula
						$lv_row['prccndforsrcqty'] = str_ireplace('@@VALOR',doubleval($lv_row['prccndval']),$lv_row['prccndforsrcqty']);
						$lv_row['prccndforsrcqty'] = str_ireplace('@@CANTIDAD',doubleval($lv_row['prccndqty']),$lv_row['prccndforsrcqty']);
						$lv_row['prccndqty'] = $lo_forctr->evalFormula( $lv_row['prccndforsrcqty'], $lp_docpos );
						$lv_row['prccndqty'] = round(floatval($lv_row['prccndqty']), 2);
					}
					
					// unidad
					if( $lv_row['prccndforsrcunt']!='' ) {
						$lv_row['prccnduntcod'] = $lv_row['prccndforsrcunt'];
					}
					
					// total
					if( $lv_row['prccndforsrctot']!='' ) {
						// reemplazo constantes @@VALOR, @@CANTIDAD antes de ejecutar la formula
						$lv_row['prccndforsrctot'] = str_ireplace('@@VALOR',doubleval($lv_row['prccndval']),$lv_row['prccndforsrctot']);
						$lv_row['prccndforsrctot'] = str_ireplace('@@CANTIDAD',doubleval($lv_row['prccndqty']),$lv_row['prccndforsrctot']);
						$lv_row['prccndtot'] = $lo_forctr->evalFormula( $lv_row['prccndforsrctot'], $lp_docpos );
					} else if($lv_row['prccnduntcod']=='%') {
						$lv_row['prccndtot'] = $lv_row['prccndval'] * (is_numeric($lv_row['prccndqty'])?$lv_row['prccndqty']:0) / 100;
					} else {
						$lv_row['prccndtot'] = $lv_row['prccndval'] * (is_numeric($lv_row['prccndqty'])?$lv_row['prccndqty']:0);
					}
					$lv_row['prccndtot'] = round(floatval($lv_row['prccndtot']), 2);
					
					
					// CLIENTE. variables de clientes
					if($lv_row['prccndforsrczcu']!=''){
						
						// recorro todas las variables establecidas
						$lv_forarr = json_decode( html_entity_decode($lv_row['prccndforsrczcu']) , true );
						foreach( $lv_forarr as $lv_forrow ){							
							$lv_zcukey = $lv_forrow['zcukey'];
							$lv_zcuval = $lv_forrow['zcuval'];						
							
							// CONSTANTES. reemplazo constantes antes de ejecutar la formula personalizada
							$lv_found =( stripos($lv_zcuval,'@@CANTIDAD')!==false || stripos($lv_zcuval,'@@VALOR')!==false || stripos($lv_zcuval,'@@TOTAL')!==false );
							if($lv_found){
								$lv_zcuval = str_ireplace('@@VALOR',doubleval($lv_row['prccndval']),$lv_zcuval);
								$lv_zcuval = str_ireplace('@@CANTIDAD',doubleval($lv_row['prccndqty']),$lv_zcuval);
								$lv_zcuval = str_ireplace('@@TOTAL',doubleval($lv_row['prccndtot']),$lv_zcuval);
							}
							
							// CONSTANTES DE REFERENCIA. @@CANTIDAD, @@VALOR, @@TOTAL, @@CANTIDAD.ROWnnnnn y @@VALOR.ROWnnnnn, @@TOTAL.ROWnnnnn
							$lv_found =( stripos($lv_zcuval,'@@CANTIDAD.ROW')!==false || stripos($lv_zcuval,'@@VALOR.ROW')!==false || stripos($lv_zcuval,'@@TOTAL.ROW')!==false );
							if( $lv_found ){
								while( $lv_found ){
									if(stripos($lv_zcuval,'@@CANTIDAD.ROW')!==false){
										$lv_getfld = 'prccndqty';
										$lv_repfld = '@@CANTIDAD.ROW';
										$lv_getrow = substr($lv_zcuval,stripos($lv_zcuval,'@@CANTIDAD.ROW')+14,5);								
									} else if(stripos($lv_zcuval,'@@VALOR.ROW')!==false){
										$lv_getfld = 'prccndval';
										$lv_repfld = '@@VALOR.ROW';
										$lv_getrow = substr($lv_zcuval,stripos($lv_zcuval,'@@VALOR.ROW')+11,5);
									} else if(stripos($lv_zcuval,'@@TOTAL.ROW')!==false){
										$lv_getfld = 'prccndtot';
										$lv_repfld = '@@TOTAL.ROW';
										$lv_getrow = substr($lv_zcuval,stripos($lv_zcuval,'@@TOTAL.ROW')+11,5);
									}
									foreach($lv_out as $lv_row2) {
										if( intval($lv_row2['prcschcndrow'])==intval($lv_getrow) ) {
											$lv_zcuval = str_ireplace($lv_repfld.$lv_getrow,$lv_row2[$lv_getfld],$lv_zcuval);
											break;
										}
									}
									$lv_found =( stripos($lv_zcuval,'@@CANTIDAD.ROW')!==false || stripos($lv_zcuval,'@@VALOR.ROW')!==false || stripos($lv_zcuval,'@@TOTAL.ROW')!==false );
								}
							}
							
							// FORMULA. evalua la formula
							$lv_zcuval = $lo_forctr->evalFormula( $lv_zcuval, $lp_docpos );
						
							// ASIGNO VARIABLE A CATALOGO
							if(!isset($lp_docpos['zcu'])){ $lp_docpos['zcu'] = array(); }
							$lp_docpos['zcu'][ $lv_zcukey ] = $lv_zcuval;
							$lv_row['prccndforsrczcu'] = '';
						}	
					}
					
				}
			}
		}
		unset($lv_row);
		
		return $lv_out;
	}
	
	
	
	// findConditionRecord
	// determina el registro de condición en función de una fecha y datos proporcionados
	public function findConditionRecord( $lp_prccndcod, $lp_dte, $lp_dat ){
		
		$lv_out = array('prccnd'=>array(),'prccndfndlog'=>array());
		$lo_grldatprcmdl = $this->co_reg->load->model('grldatprc');
		$lv_dte = $lp_dte->format('Y-m-d');
		
		// REGISTRO DE CONDICION. obtengo precios del registro de condición
		$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SYS_PCN'.chr(9).chr(9).
																	'[~fltrow~]p.prccndcod'.chr(9).'='.chr(9).chr(9).$lp_prccndcod .chr(9).chr(9).
																	'[~fltrow~]p.prccndstrdte'.chr(9).'<='.chr(9).chr(9).$lv_dte.chr(9).chr(9).
																	'[~fltrow~]p.prccndenddte'.chr(9).'>='.chr(9).chr(9).$lv_dte.chr(9).chr(9).
																	'[~fltrow~]isnull(pcaq.prccndcod,0)'.chr(9).'<>'.chr(9).chr(9). '0' .chr(9).chr(9),
										'vewfldord' => ' pcaq.prccndaccseqord ',
										'vewmaxrec' => '1000' );
		$lo_rs = $lo_grldatprcmdl->getListWithSequence( $lv_prm );
		if( count($lo_rs)>0 ) {
			$lv_out['prccndfndlog'][] = 'Registros encontrados '.count($lo_rs).' [SYS_PCN / '.$lp_prccndcod.' / '.$lv_dte.']';
			
			// BUSQUEDA. busco el registro según la clave
			$lv_valkey = '';
			$lv_lstkey = '';
			foreach($lo_rs as $lo_rsprc){
				$lv_acckey = $this->co_reg->document->getTagValue($lo_rsprc['prccndaccatr'],'fld');
				$lv_acckey = html_entity_decode($lv_acckey);
				if($lv_acckey!=$lv_lstkey){
					
					// CLAVE. se arma una cadena <campo>;<campo>; con la clave de la secuencia de acceso
					$lv_lstkey = $lv_acckey;
					$lv_keyarr = json_decode($lv_lstkey,true);
					$lv_valkey = '';
					foreach($lv_keyarr as $lv_keyrow){ $lv_valkey .= $lv_keyrow['prccndaccfldcod'].';'; }
					$lv_valkey = strtoupper($lv_valkey);
					$lv_out['prccndfndlog'][] = 'Acceso ['.$lo_rsprc['prccndacctxt'].']. Clave ['.strtolower($lv_acckey).']';
					
					// DATOS. reemplazo la clave con los datos del documento
					$lv_fld = '';
					foreach($lp_dat as $lv_key=>$lv_val){
						$lv_fld = strtoupper($lv_key);
						if (is_a($lv_val, 'DateTime')){
							if(stripos($lv_valkey,$lv_fld.';')!=false){ $lv_valkey = str_ireplace($lv_fld.';',$lv_val->format('Y.m.d').';',$lv_valkey); }
						} else if(is_array($lv_val)){
							foreach($lv_val as $lv_key2=>$lv_val2){
								if (is_a($lv_val2, 'DateTime')){
									if(stripos($lv_valkey,$lv_fld.'.'.strtoupper($lv_key2).';')!==false){$lv_valkey=str_ireplace($lv_fld.'.'.strtoupper($lv_key2).';',$lv_val2->format('Y.m.d').';',$lv_valkey);}
								} else if(!is_array($lv_val2) && !is_object($lv_val2)){
									if(stripos($lv_valkey,$lv_fld.'.'.strtoupper($lv_key2).';')!==false){
										$lv_valkey=str_ireplace($lv_fld.'.'.strtoupper($lv_key2).';',$lv_val2.';',$lv_valkey);
									}
								}
							}
						} else if(stripos($lv_valkey,$lv_fld.';')!==false){
							$lv_valkey = str_ireplace($lv_fld.';',$lv_val.';',$lv_valkey);
						}
					}
					$lv_valkey = substr($lv_valkey,0,strlen($lv_valkey)-1);
					$lv_out['prccndfndlog'][] = 'Cadena de busqueda ['.strtolower($lv_valkey).']';
				}
				
				// VERIFICO. si coincide la clave reemplazada por los datos con la clave del registro de precios
				if( trim(strtoupper($lv_valkey)) == trim(strtoupper($lo_rsprc['srcobjcod001'])) ){
					$lv_out['prccnd'] = array('prccndrowcod'=>$lo_rsprc['prccndrowcod'],
																		'prccndcod'=>$lo_rsprc['prccndcod'],
																		'prccndacccod'=>$lo_rsprc['prccndacccod'],
																		'prccndqty'=>$lo_rsprc['prccndqty'],
																		'prccnduntcod'=>$lo_rsprc['prccnduntcod'],
																		'prccndval'=>$lo_rsprc['prccndval'],
																		'prccndcurcod'=>$lo_rsprc['prccndcurcod']);
					$lv_out['prccndfndlog'][] = 'Registro encontrado ['.$lo_rsprc['prccndval'].'/'.$lo_rsprc['prccndcurcod'].'/'.$lo_rsprc['prccndqty'].'/'.$lo_rsprc['prccnduntcod'].']';
					break;
				}
				
			}
		} else {
			// no se determinaron registros
			//$lv_out['prccndfndlog'][] = 'No se encontraron registros con [SYS_PCN / '.$lp_prccndcod.' / '.$lv_dte.']';
		}
		
		return $lv_out;
	}
}
?>