<?php
final class hltlqdController extends tmssController {
	const CONTROLLER = 'hltlqd';
	const MODEL = 'hltlqd';
	const VIEW  = 'hltlqd';
	const ID = 'hltlqdcod';
	const OBJTYP = 'HLT_LQC';
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

		$lv_hltlqdcod = (isset($this->co_reg->request->post['hltlqdcod'])?$this->co_reg->request->post['hltlqdcod']:'');
		$lv_cuscod = (isset($this->co_reg->request->post['cuscod'])?$this->co_reg->request->post['cuscod']:'');
		$lv_strdte = (isset($this->co_reg->request->post['hltlqdstrdte'])?$this->co_reg->request->post['hltlqdstrdte']:'');
		$lv_enddte = (isset($this->co_reg->request->post['hltlqdenddte'])?$this->co_reg->request->post['hltlqdenddte']:'');
		$lv_sec = (isset($this->co_reg->request->post['token'])?$this->co_reg->request->post['token']:'');

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
        if ( $this->lo_mdl->save($lo_post) ) {
					// recargo el documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;

					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
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


      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array( self::ID=>($lp_prm[self::ID]??($lo_post[self::ID]??'')) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
 	     		return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
	      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->hltlqdcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
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
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;


			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->lo_mdl->accounting();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;


			// VER DETALLE. devuelve el detalle de los documentos liquidados
      //FALTA REVISAR EL CASO DEL 13 y 11 QUE FUNCIONE CORRECTAMENTE.
			case '#11': case '#12': case '#13':
        $lv_post = $this->co_reg->request->post;
				$this->lo_mdl->opnexp = array();
				$this->lo_mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				// GASTOS. obtengo gastos de liquidacion
				$lo_lqdmdl = $this->co_reg->load->model('hltlqd');
				$lv_fltopt = array();
        $lv_prm = array( 'hltlqdcod'=>$lv_hltlqdcod, 'cuscod'=>$lv_cuscod, 'hltlqdstrdte'=>$lv_strdte, 'hltlqdenddte'=>$lv_enddte, 'sysdocclscod'=>$this->lo_mdl->sysdoccls->sysdocclscod );
        
        if ($lp_act=='#13') {
          $lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltlqdcod'.chr(9).'='.chr(9).chr(9).$lv_post['hltlqdcod'].chr(9).chr(9));
          $lo_rs2 = $lo_lqdmdl->getExpenses( $lv_fltopt, $lv_prm ); 
					$this->lo_mdl->opnexp = $lo_rs2;
        }else{
          if ($lp_act=='#11') {
          	$lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltlqdcod'.chr(9).'EE'.chr(9).chr(9).chr(9).chr(9) );
          }else{
            $lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltlqdcod'.chr(9).'ZZ'.chr(9).' = '.$lv_post['hltlqdcod'].chr(9).' OR ld.hltlqdcod IS NULL'.chr(9).chr(9));
					}
          // obtengo gastos no liquidados
					$lo_rs2 = $lo_lqdmdl->getOpenExpenses( $lv_fltopt, $lv_prm );
					$this->lo_mdl->opnexp = $lo_rs2;
        }
        
        //Reasigno el filtro porque luego debo utilizarlo para pedir las prestaciones.
        $lv_fltSvs = $lv_fltopt;
        
				// CALCULO. se calculan los precios actuales de los servicios
				if( $lp_act=='#13' ){
					// SERVICIOS. obtiene servicios de liquidacion
					$lo_opnsrv = $lo_lqdmdl->getServices( $lv_fltSvs, $lv_prm ); 

					foreach($lo_opnsrv as &$lv_row){
            $lv_hltlqddocatr001 = json_decode(html_entity_decode(isset($lv_row['hltlqddocatr001']) && $lv_row['hltlqddocatr001']!=='' ? utf8_encode($lv_row['hltlqddocatr001']) : '[]'), true);
           	if($lv_hltlqddocatr001!=null && count($lv_hltlqddocatr001)){ 
              foreach($lv_hltlqddocatr001 as $lv_key=>$lv_val){
                $lv_row[$lv_key] = $lv_val;
              }
           
              $lv_row['srcdte'] = date_create_from_format('d/m/Y',$lv_row['srcdte'] ?? $lv_row['evldte']);
              $lv_row['slsprc'] = $lv_row['hltlqddocprc'];
              $lv_row['slsprcsrctxt'] = utf8_decode($lv_row['modtxt']??'');
              $lv_row['pattxt'] = utf8_decode($lv_row['pattxt']??'');
              $lv_row['hltdisclstxt'] = utf8_decode($lv_row['hltdisclstxt']??'');
              $lv_row['patpro'] = utf8_decode($lv_row['patpro']??'');
              $lv_row['patcodext'] = utf8_decode($lv_row['patcodext']??'');
            }
					}			
					unset($lv_row);
   
					$this->lo_mdl->opnsrv = $lo_opnsrv;

				} else {
          // SERVICIOS. obtiene servicios de liquidacion
					$lo_opnsrv = $lo_lqdmdl->getOpenServices($lv_fltSvs, $lv_prm );
          
					// obtengo módulos del cliente (valorizados)
					$lo_prclstmdl = $this->co_reg->load->model('slsprclst');
					$lv_prm2 = array('vewfldflt' =>'[~fltrow~]st3.cuscod'.chr(9).'='.chr(9).chr(9).(isset($lv_post['cuscod']) ? $lv_post['cuscod'] : '' ).chr(9).chr(9).
																				'[~fltrow~]pv.SlsPrcLstStrDte'.chr(9).'<='.chr(9).chr(9).(isset($lv_post['hltlqdstrdte']) ? substr($this->co_reg->db->sqldate($lv_post['hltlqdstrdte']),0,8) : '' ).chr(9).chr(9).
																				'[~fltrow~]pv.SlsPrcLstEndDte'.chr(9).'>='.chr(9).chr(9).(isset($lv_post['hltlqdenddte']) ? substr($this->co_reg->db->sqldate($lv_post['hltlqdenddte']),0,8) : '' ).chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																					);
					$lo_prclst = $lo_prclstmdl->getList( $lv_prm2 );

					// traspaso la liquidacion al modulo que corresponda (1-MODULO)
					// se arma array con todos los módulos del cliente para después buscar las posiciones de esos módulos
					$lv_modarr = array();
					$lv_srcobjcodarr = array();
					foreach ($lo_prclst as $lv_row) {
						array_push($lv_modarr,$lv_row['slsprcsrccod']);
						array_push($lv_srcobjcodarr,$lv_row['slsprclstcod'].';'.$lv_row['slsprclstvercod'].';'.$lv_row['slsprclstprccod']);
					}

					$lo_modplnmdl = $this->co_reg->load->model('hltmodpln');
					$lv_prm3 = array('vewfldflt' =>'[~fltrow~]mp.hltmodcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_modarr) .chr(9).chr(9).
																				 '[~fltrow~]mp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'mp.hltmodcod, mp.srcobjtyp desc'      
													);
					$lo_modlst = $lo_modplnmdl->getList($lv_prm3);

					$lo_grlprcmdl = $this->co_reg->load->model('grldatprc');
					$lv_prm4 = array('vewfldflt' =>'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_srcobjcodarr) .chr(9).chr(9).
																				 '[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SYS_PCN'.chr(9).chr(9).
																				 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																	);
					$lo_grlprc = $lo_grlprcmdl->getList($lv_prm4);

					$lv_zonarr = array();

					//Recorre por cada control los detalles de los módulos del cliente y busca que corresponda especialidad y clasificación de enfemedad
					foreach($lo_opnsrv as &$lv_row){
						$lv_modcod = '';
						$lv_disclscod = '';
						$lv_spccod = '';
						foreach($lo_modlst as $lv_modrow){
							if ($lv_modrow['hltmodcod'] != $lv_modcod && $lv_modcod != ''){
								$lv_disclscod = '';
								$lv_spccod = '';
							}
							$lv_modcod = $lv_modrow['hltmodcod'];
							if($lv_modrow['srcobjtyp'] == 'HLT_DCL'){
								if($lv_row['hltdisclscod'] == $lv_modrow['srcobjcod001']){$lv_disclscod = $lv_row['hltdisclscod'];}
							}else if($lv_modrow['srcobjtyp'] == 'HLT_SPC'){
								if($lv_row['spccod'] == $lv_modrow['srcobjcod001']){$lv_spccod = $lv_row['spccod']; }
							}
							if ($lv_disclscod != '' && $lv_spccod != ''){
								$lv_row['modcod'] = $lv_modcod;
								break;
							}
						}
						if (!isset($lv_row['modcod'])){
							// traspaso la liquidacion a la zona/cantidad (2-ZONA/CANTIDAD)
							// de vuelta recorro los módulos buscando que las zonas coincidan
							foreach($lo_modlst as $lv_modrow){
								if($lv_modrow['srcobjtyp'] == 'SYS_ZON'){
									if($lv_row['adrzoncod'] == $lv_modrow['srcobjcod001']){
										if(isset($lv_zonarr[$lv_row['adrzoncod']])){
											$lv_zonarr[$lv_row['adrzoncod']] ++;
										}else{
											$lv_zonarr[$lv_row['adrzoncod']] = 1;
										}
										$lv_row['modcod'] = $lv_modrow['hltmodcod'];
									}
								}
							}
						}
					}
					unset($lv_row);
					// recorrer todas las liquidaciones y armar documento con posiciones (añadir importe según escala de precios, descripción del módulo/zona-cantidad)
					foreach($lo_opnsrv as $lv_key => &$lv_row){
						//se descartan las liquidaciones de los pacientes que no tienen módulo ni zona que corresponda
						if (!isset($lv_row['modcod']) || empty($lo_grlprc)){
							// tkt#1113 - antes de descartar la prestacion, se muestra con un grupo "sin asingar"
							$lv_row['modcod'] = 0;
							$lv_row['slsprcsrctxt'] = 'SIN ASIGNAR';
							$lv_row['slsprc'] = 0;
							//unset($lo_opnsrv[$lv_key]);
						}else{
							foreach($lo_prclst as $lv_lstrow){
								if (isset($lv_row['modcod']) && $lv_lstrow['slsprcsrccod'] == $lv_row['modcod']){
									foreach($lo_grlprc as $lv_prcrow){
										if ($lv_prcrow['srcobjcod001'] == $lv_lstrow['slsprclstcod'].';'.$lv_lstrow['slsprclstvercod'].';'.$lv_lstrow['slsprclstprccod']){
											$lv_row['slsprc'] = $lv_prcrow['prccndval'];
											// si hay escala de precios y el paciente tiene zona correcta se verifica qué posición de la escala le corresponde
											if(!empty($lv_zonarr)){
												if (isset($lv_zonarr[$lv_row['adrzoncod']])){
													if(!empty($lv_prcrow['grldatprcsca'])){
														$lv_oldqty = 0;
														foreach($lv_prcrow['grldatprcsca'] as $lv_scarow){
															if($lv_scarow['prccndqty'] > $lv_oldqty && $lv_scarow['prccndqty'] <= $lv_zonarr[$lv_row['adrzoncod']]){
																$lv_oldqty = $lv_scarow['prccndqty'];
																$lv_row['slsprc'] = $lv_scarow['prccndtot'];
															} 
														}
													} 
												}
											}
										}
										$lv_row['slsprcsrctxt'] = $lv_lstrow['slsprcsrctxt']; 
									} 
								}
							}
						}
					}
					unset($lv_row);
					$this->lo_mdl->opnsrv = $lo_opnsrv;
				}

       	return $this->co_reg->document->getView( 'hltlqddet', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
    }
  }
}
?>