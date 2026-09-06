<?php
final class grldatfrmController extends tmssController {
	const CONTROLLER = 'grldatfrm';
	const MODEL = 'grldatfrm';
	const VIEW  = 'grldatfrm';
	const ID = 'frmdatcod';
	const OBJTYP ='GRL_FRM';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }


  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // control de sesion
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
        $lo_fldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lo_uplmdl = $this->co_reg->load->model('grldatupl');
        $lo_post['frmdat'] = html_entity_decode($lo_post['frmdat']);
       	$lv_frmdat  = json_decode($lo_post['frmdat'], true);
				// grabo cabecera
				if($this->lo_mdl->save()){	
					// grabo archivos
					foreach($lv_frmdat as $lv_row){
						// si el campo contiene archivos
						if(isset($lv_row2['fle']) && isset($lv_tmpfle_arr[$lv_row['sysdocfrmcod']."_".$lv_row2['frmdocfldcod']])){
							$this->co_reg->request->files = $lv_tmpfle_arr[$lv_row['sysdocfrmcod']."_".$lv_row2['frmdocfldcod']];
							$lv_ret = $lo_uplmdl->uploadFile(array('flesrctyp'=>'GRL_FRM', 'flesrccod'=>$this->lo_mdl->frmdatcod, 'flesrcfld'=>$lo_fldmdl->frmdatfldcod));
							// muestro mensaje de error
							foreach($lv_ret as $lv_row3){
								if(isset($lv_row3['error'])){
									return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1,'errtxt'=>$this->co_reg->language->message('ERRORFILEUPLOAD', array())) ); 
								}
							}
						}
          }
					
					// elimino los archivos que se quitaron de todos los formularios
          if(isset($lo_post['fledelcod']) && $lo_post['fledelcod']!=''){
            $lv_fledel_arr = json_decode($lo_post['fledelcod'], true);
            foreach($lv_fledel_arr as $lv_row){
              $lo_uplmdl->delete(array('flecod' => intval($lv_row)));
              if($lo_uplmdl->errtyp == 'E'){
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_uplmdl->errtyp, 'errcod'=>$lo_uplmdl->errcod,'errtxt'=>$lo_uplmdl->errtxt) );
            	}
            }	
          }
								
        }
        
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'frmdatcod'=>$this->lo_mdl->frmdatcod) );
        
                
        /*
        // separo los archivos que no son del mismo origen
        if(count($this->co_reg->request->files)>0){
          $lv_tmpfle_arr = array();
          $lv_frmcod_arr = array();
          $lv_fldcod_arr = array();
          
          foreach($this->co_reg->request->files as $lv_key => $lv_row2){
            $lv_frmcod = explode("_", $lv_key)[1];
            $lv_fldcod = explode("_", $lv_key)[2];
            
            if(!in_array($lv_frmcod, $lv_frmcod_arr) && !in_array($lv_fldcod, $lv_fldcod_arr)){
              $lv_frmcod_arr[] = $lv_frmcod;
              $lv_fldcod_arr[] = $lv_fldcod;
              $lv_tmpfle_arr[$lv_frmcod."_".$lv_fldcod] = array();
            }
            
            array_push($lv_tmpfle_arr[$lv_frmcod."_".$lv_fldcod], $lv_row2);
            unset($this->co_reg->request->files[$lv_key]);
          }
    		}
				*/
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array( self::ID=>($lp_prm[self::ID]??$lo_post[self::ID]??''));
        
				// GRLDATFRM. Intenta cargar los datos del formulario
				if( $lv_key[self::ID]!='' ){	
					if ( $this->lo_mdl->load($lv_key)==false ) {
						return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
					} else if ( $lp_act == '#001' ) {
						$this->lo_mdl->frmdatcod = '';
						$this->lo_mdl->ctedte = '';
						$this->lo_mdl->cteusr = '';
						$this->lo_mdl->upddte = '';
						$this->lo_mdl->updusr = '';
					}
				}
        
				//  SYSDOCFRM. carga la definicion del formulario
				$this->lo_mdl->sysdocfrm = $this->co_reg->load->model('sysdocfrm');
				$lv_sysdocfrmcod = ($this->lo_mdl->sysdocfrmcod!=''?$this->lo_mdl->sysdocfrmcod:($lo_post['sysdocfrmcod']??($lp_prm['sysdocfrmcod']??'')));
				if( $lv_sysdocfrmcod!='' ){
					$this->lo_mdl->sysdocfrm->load( array('sysdocfrmcod'=>$lv_sysdocfrmcod) );
				}

        //Asigno los valores del srcobj
        $this->lo_mdl->srcobjtyp = $lo_post['srcobjtyp']??'';
				$this->lo_mdl->srcobjcod001 = $lo_post['srcobjcod001']??'';
        $this->lo_mdl->srcobjcod002 = ($lo_post['srcobjcod002']??'');
      
				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. borra un objeto
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST. lista documentos
      case '#18':
				$lo_post = $this->co_reg->request->post;
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]df.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjtyp'].chr(9).chr(9).
                                      '[~fltrow~]df.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod001'].chr(9).chr(9).
                                      (isset($lo_post['srcobjcod002'])?'[~fltrow~]df.srcobjcod002'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod002'].chr(9).chr(9):'')
                        );
        $lo_data = $this->lo_mdl->getList($lv_prm);

				$lv_ids = array_column($lo_data, 'sysdocfrmcod');
        
        $lv_out = $lo_data;
        
        // Solo podemos buscar configuración si nos enviaron el ID de la Clase
				if (!empty($lo_post['sysdocclscod'])) {
					$lo_docclsfrm = $this->co_reg->load->model('sysdocclsfrm');
					// Traemos la configuración para esta clase
					$lv_flt = '[~fltrow~]dcf.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9);
          // Excluimos los que ya fueron grabados
          if (!empty($lv_ids)) {
            $lv_flt .= '[~fltrow~]dcf.sysdocfrmcod'.chr(9).'NI'.chr(9).chr(9).implode(chr(10), $lv_ids).chr(9).chr(9);
        	}
					$lv_prmfrm = array('vewfldflt' => $lv_flt);
					$lv_frmlst = $lo_docclsfrm->getList($lv_prmfrm);
          
          foreach ($lv_frmlst as $lv_row) {
            // Si no tiene condición definida -> pasa
            if (empty($lv_row['cndtyp']) || empty($lv_row['cndval'])) {
              $lv_out[] = $lv_row;
              continue;
            }
            // Si tiene condición -> evaluarla con verifyCondition
            $lv_cond = $this->verifyCondition($lv_row['cndtyp'], $lv_row['cndval'], $lo_post);

            if ($lv_cond) {
              $lv_out[] = $lv_row;
            }
          }
				} 
        
        return $this->co_reg->document->getJson($lv_out);
        break;			

			
     //PREVIEW. Muestra el preview del formulario.
			case '#05':
        $lo_post = $this->co_reg->request->post;
        //Verifico si la preview es de un formulario ya creado.
        if(isset($lo_post['sysdocfrmcod']) && $lo_post['sysdocfrmcod']!=''){
          //  SYSDOCFRM. carga la definicion del formulario
          $this->lo_mdl->sysdocfrm = $this->co_reg->load->model('sysdocfrm');
          $lv_sysdocfrmcod = $lo_post['sysdocfrmcod']??($lp_prm['sysdocfrmcod']??'');
          $this->lo_mdl->sysdocfrm->load( array('sysdocfrmcod'=>$lv_sysdocfrmcod) ); 
        }
        //Asigno los valores del srcobj
        $this->lo_mdl->srcobjtyp = $lo_post['srcobjtyp']??'';
        $this->lo_mdl->srcobjcod001 = $lo_post['srcobjcod001']??'';
        $this->lo_mdl->srcobjcod002 = ($lo_post['srcobjcod002']??'');
      
        // muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
      break;
    }
  }
  
  
  // VERIFY CONDITION. Devuelve TRUE si se cumple, FALSE si no.
  private function verifyCondition($lp_cndtyp, $lp_cndval, $lp_docdata=array()){

    switch($lp_cndtyp){
      // PERSONALIZADA
      case 'ZCU':
        $lv_data = $this->co_reg->document->getCallComponents( html_entity_decode($lp_cndval) );
        if( isset($lv_data['prg']) && $lv_data['prg']!='' ){
          $lo_zcucnt = $this->co_reg->load->controller( $lv_data['prg'] );
          // Ejecutamos la actividad. Debe devolver booleano.
          $lv_res = $lo_zcucnt->index( $lv_data['act'], $lv_data['prm'] );
          return ($lv_res === true);
        } 
        return false;
        break;

      // FORMULA
      case 'FOR':
        $lo_forcnt = $this->co_reg->load->controller('grlprccndfor');
        // prepara los datos para la evaluar la fórmula, el lp_docdata es un array no un string o un json.
        //Obtengo los valores que debo de buscar que necesito para la condicion dentro de los datos enviados.
        preg_match_all("/\[(.*?)\]/", $lp_cndval, $lv_tmparr);
        $lv_data = array();
        $lv_cndvalarr = $lv_tmparr[1];
        foreach($lv_cndvalarr as $lv_val){
          $lv_val = strtolower($lv_val);
          if(isset($lp_docdata[$lv_val])){
            $lv_data[$lv_val] = (is_string($lp_docdata[$lv_val])?strtoupper($lp_docdata[$lv_val]):$lp_docdata[$lv_val]);  //strtoupper
          }          	 
        }
        
        // evalua la formula
        try {
          return $lo_forcnt->evalFormula( $lp_cndval , $lv_data );
        } catch(Exception $e){
          return false;
        }
        break;
    }
  }
}
?>