<?php
final class stkmovelbController extends tmssController {
	const CONTROLLER = 'stkmovelb';
	const MODEL = 'stkmovelb';
	const VIEW  = 'stkmovelb';
	const ID = 'stkmovelbcod';
	const OBJTYP ='STK_MOV';
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
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
	
			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['objtyp'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9); }
				if(isset($lp_prm['stkmovelblck'])){ $lp_prm['vewfldflt'] .= '[~fltrow~]d.stkmovelblck'.chr(9).'='.chr(9).chr(9).$lp_prm['stkmovelblck'].chr(9).chr(9); }
        return $lo_vew->index( '00', $lp_prm );
        break;
			
				
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$lo_post['stkmovelbcod'] = $this->lo_mdl->stkmovelbcod;

					// grabo materiales del documento
					$lo_elbmatmdl = $this->co_reg->load->model('stkmovelbmat');
					$lv_buffer = $lo_post['stkmovelbmat'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_movelb_arr = json_decode($lv_buffer,true);
						foreach( $lv_movelb_arr as $lv_row ) {
							$lv_row['stkmovelbcod'] = $this->lo_mdl->stkmovelbcod;
							$lv_row['docsts'] = 'A';							
							if ( isset($lv_row['deleted']) ) {
								if ($lo_elbmatmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errcod'=>$lo_elbmatmdl->errcod, 'errtxt'=>$lo_elbmatmdl->errtxt, 'row'=>$i));
								}
							} else if ($lo_elbmatmdl->save( $lv_row )==false) {
								return $this->co_reg->document->getJson(array('errcod'=>$lo_elbmatmdl->errcod, 'errtxt'=>$lo_elbmatmdl->errtxt, 'row'=>$i));
							}
							
							$i++;
						}
					}
					
					// cargo documento
					$this->lo_mdl->load( array(	'stkmovelbcod'=>$this->lo_mdl->stkmovelbcod	) );
          
					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}
          
          //obtine la clase de documento de inventario
          $lo_invmdl = $this->co_reg->load->model('sysdoccls');
          $lo_invmdl->load( array( 'sysdocclscod' => $this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'sysdocclscodinv') ), false );
          $this->lo_mdl->invatr = $lo_invmdl->sysdocclsatr;
					
					// asigno parámetros adicionales
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
						
			
      // NEW. devuelve vista en modo creación
      case '#01':
        $this->lo_mdl->create();

				
				// obtengo clase de documento ------------------------
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lp_prm['mdlcod'].'&prm_prgcod='.$lp_prm['prgcod'],'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					return $this->co_reg->document->getJson(array('errtxt'=>'No se pudieron cargar los datos de la clase de documento.'));
				}
				// ------------------------------------------------
        
        //obtine la clase de documento de inventario
        $lo_invmdl = $this->co_reg->load->model('sysdoccls');
        $lo_invmdl->load( array( 'sysdocclscod' => $this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'sysdocclscodinv') ) );
        $this->lo_mdl->invatr = $lo_invmdl->sysdocclsatr;
				
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;			
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación o visualización
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
					$this->lo_mdl->stkmovelbcod = '';
					$this->lo_mdl->docsts = 'A';
					$lo_rs = $this->lo_mdl->stkmovelbmat;
					for($i=0; $i<count($lo_rs); $i++) { 
						$lo_rs[$i]['stkmovelbmatcod']=''; 
					}
					$this->lo_mdl->stkmovelbmat = $lo_rs;
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				// cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
        
        //obtine la clase de documento de inventario
        $lo_invmdl = $this->co_reg->load->model('sysdoccls');
        $lo_invmdl->load( array( 'sysdocclscod' => $this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'sysdocclscodinv') ) );
        $this->lo_mdl->invatr = $lo_invmdl->sysdocclsatr;
        
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// ACCOUNTING. contabiliza el documento
      case '#09':
				$lo_post = $this->co_reg->request->post;
				$lv_errtyp = 'S';
				$lv_errcod = 0;
				$lv_errtxt = '';
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        
				// proceso nros de serie
				$lv_matserarr = array();
        $lv_matsercodextlstjsn = $lo_post['matsercodextlst'];
				$lv_buffer = (isset($lo_post['matsercodextlst'])?$lo_post['matsercodextlst']:'');
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_matserarr = json_decode($lv_buffer,true);
				}
        $lo_post['matsercodextlst'] = '';
				foreach($lv_matserarr as $lv_row){$lo_post['matsercodextlst'] .= '<row><matsercod>'.$lv_row['matsercod'].'</matsercod><matsercodext>'.$lv_row['matsercodext'].'</matsercodext></row>';}				
				
        $lo_post['stkmovelbdte'] =  (DateTime::createFromFormat('d/m/Y', $lo_post['stkmovelbdte']))->format('d/m/Y');
				//$lo_post['matbchduedte'] = ($lo_post['matbchduedte']!='')?(DateTime::createFromFormat('d/m/Y', $lo_post['matbchduedte'])->format('Ymd')):$lo_post['matbchduedte'];
        //NOTIFICACION. Guardo datos de notificacion
        if( $this->lo_mdl->save( $lo_post )==false ) {
					$lv_errtyp = 'E';
					$lv_errcod = -901;
					$lv_errtxt = 'No se puede grabar los datos de notificacion. '.$this->lo_mdl->errtxt;
				}
        //ELABORACION. Contabilizo la elaboracion, teniendo en cuenta la creacion del movimiento de inventario y su contabilizacion. Tambien actualizacion de costo
				if( $lv_errcod==0 && $this->lo_mdl->docsts!='C' ) {
					if( $this->lo_mdl->accounting( array('stkmovelbcod'=>$this->lo_mdl->stkmovelbcod, 'matbchduedte'=>$lo_post['matbchduedte']??'', 'matsercodextlst'=>$lv_matsercodextlstjsn) )==false) {
						$lv_errtyp = 'E';
						$lv_errelb = -911;
            $lv_errcod = $this->lo_mdl->errcod;
						$lv_errtxt = 'Se produjo un error al contabilizar el documento actual. '.$this->lo_mdl->errtxt.' ERRTCH: '.$this->lo_mdl->errtch;						
            $lv_errmat = $this->lo_mdl->errmat;
					}
				}
				return $this->co_reg->document->getJson( array('errtyp'=>$lv_errtyp,'errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt, 'errmat'=>$lv_errmat??'','errelb'=>$lv_errelb??'') );
        break;
			

			
			// CONTABILIZACION (NOTIFICACION) - VER. devuelve formulario de contabilización
			case '#10':
				$lo_post = $this->co_reg->request->post;
				$lo_invmdl = $this->co_reg->load->model('stkmovdoc');
				
				// cargo datos del documento
				$this->lo_mdl->load( array(self::ID => $lo_post[self::ID]) );
				$this->lo_mdl->frmsec = (isset($lo_post['frmsec'])?$lo_post['frmsec']:'');
  
        // cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				// cargo datos de documento de inventario
				if(intval($this->lo_mdl->stkmovdoccod)!=0){
					$lo_invmdl->load( array('stkmovdoccod'=>$this->lo_mdl->stkmovdoccod), false );
				}
				
				$lv_arr = explode( '</row>', $this->lo_mdl->matsercodextlst );
				$lv_arrout = array();
				foreach($lv_arr as $lv_row) {
					$lv_row = str_ireplace('<row>','',$lv_row);
					$lv_arrout[] = array('matsercod'=>$this->co_reg->document->getTagValue($lv_row,'matsercod'),'matsercodext'=>$this->co_reg->document->getTagValue($lv_row,'matsercodext'));
				}
				$this->lo_mdl->matsercodextlst = $lv_arrout;

        return $this->co_reg->document->getView( 'stkmovelbntf', array('data'=>$this->lo_mdl,'invdoc'=>$lo_invmdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;
			
			
			
			// COMPOSICION DE MATERIAL. devuelve composicion del material a elaborar
			case '#28':
				$lo_post = $this->co_reg->request->post;
        
          // obtengo la cantidad que se forma con la composición
          $lo_matlstmdl = $this->co_reg->load->model('stkmatlst');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ml.matcod'.chr(9).'='.chr(9).chr(9).$lo_post['matcod'].chr(9).chr(9).
                                        '[~fltrow~]ml.matlstcod'.chr(9).'='.chr(9).chr(9).$lo_post['matlstcod'].chr(9).chr(9).
                                        '[~fltrow~]ml.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );
          $lo_rs = $lo_matlstmdl->getList($lv_prm, null, null, false);
          if (isset($lo_rs['0'])){ $matqty = $lo_rs['0']['matqty']; }

          // obtengo composicion de la lista de materiales
          $lo_matlstmdl = $this->co_reg->load->model('stkmatlstmat');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ml.matcod'.chr(9).'='.chr(9).chr(9).$lo_post['matcod'].chr(9).chr(9).
                                        '[~fltrow~]ml.matlstcod'.chr(9).'='.chr(9).chr(9).$lo_post['matlstcod'].chr(9).chr(9).
                                        '[~fltrow~]ml.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                        );
          $lo_rs = $lo_matlstmdl->getList( $lv_prm );
          $lv_matlst = '';

          foreach($lo_rs as $key => $lv_row){ 
            if($lv_row['srcobjtyp']=='STK_MAT'){
              $lv_matlst .= ($lv_matlst!=''?chr(10):'').$lv_row['srcobjcod'];
              $lo_rs[$key]['matqty'] = $lv_row['matqty'] / $matqty;
            }
          }
          $lv_batch_arr = explode(',', $lo_post['matbchcodext']);
        
          // obtengo stock de materiales
          $lo_matstkmdl = $this->co_reg->load->model('stkmatstk');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]s.stkobjtyp'.chr(9).'='.chr(9).chr(9).'STK_STL'.chr(9).chr(9).
                                        '[~fltrow~]s.stkobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['strloccod'].chr(9).chr(9).
                                        '[~fltrow~]s.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_matlst.chr(9).chr(9).
                                        '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                        '[~fltrow~]mb.matbchcodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_batch_arr).chr(9).chr(9)
                        );
          $lo_rsstk = $lo_matstkmdl->getList( $lv_prm );

          // preparo el array de salida
          $lo_data = array();
          foreach($lo_rs as $lv_row) {
            $lv_stk = 0;
            foreach($lo_rsstk as $lv_rowstk) {
              if($lv_row['srcobjcod']==$lv_rowstk['matcod']){$lv_stk += $lv_rowstk['matqty'];}
            }
            $lo_data[] = array('matcod'=>$lv_row['srcobjcod'],'mattxt'=>$lv_row['srcobjtxt'],'matqtybse'=>$lv_row['matqty'],'matuntcod'=>$lv_row['matuntcod'],'matqtystk'=>$lv_stk,'matstkrel'=>$lv_row['matstkrel'],'matuseser'=>$lv_row['matuseser'],'matusebch'=>$lv_row['matusebch']);
          }
          return $this->co_reg->document->getJson( $lo_data );
          break;
    }
  }
}
?>