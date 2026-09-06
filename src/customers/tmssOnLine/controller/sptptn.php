<?php
final class sptptnController extends tmssController {
	const CONTROLLER = 'sptptn';
	const MODEL = 'sptptn';
	const VIEW  = 'sptptn';
	const ID = 'ptncod';	
	const OBJTYP ='SPT_PTN';
  protected $co_reg;
	private $lo_mdl;
  private $data = array(); 
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
    
  
  // main method   
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
    $lo_grltxtmdl = $this->co_reg->load->model('grldattxt');
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;    
				if( $this->lo_mdl->save($lo_post) ){
					
					// ACTIVIDADES. grabo actividades del socio
          $lo_ptnact = $this->co_reg->load->model('sptptnact');
          $lv_buffer = $lo_post['ptnact'];
          if($lv_buffer!=''){
          	$i = 0;
            $lv_buffer = html_entity_decode($lv_buffer);
            $lv_sptptn_arr = json_decode($lv_buffer,true);
            foreach($lv_sptptn_arr as $lv_row){
              $lv_row['ptncod'] = $this->lo_mdl->ptncod;
              $lv_row['docsts'] = 'A';
              if(isset($lv_row['deleted'])){
              	if($lo_ptnact->delete( $lv_row )==false){
                	return $this->co_reg->document->getJson( array('errtyp'=>$lo_ptnact->errtyp,'errcod'=>$lo_ptnact->errcod,'errtxt'=>$lo_ptnact->errtxt,'row'=>$i) );
                } 
              } else if($lo_ptnact->save( $lv_row )==false){
               	return $this->co_reg->document->getJson( array('errtyp'=>$lo_ptnact->errtyp,'errcod'=>$lo_ptnact->errcod,'errtxt'=>$lo_ptnact->errtxt,'row'=>$i) );
              }
              $i++;
            }
          }
					
					// ARANCELES. grabo aranceles del socio
          $lo_ptntrf = $this->co_reg->load->model('sptptntrf');
          $lv_buffer = $lo_post['ptntrf'];
          if($lv_buffer!=''){
          	$i = 0;
            $lv_buffer = html_entity_decode($lv_buffer);
            $lv_sptptn_arr = json_decode($lv_buffer,true);
            foreach($lv_sptptn_arr as $lv_row){
              $lv_row['ptncod'] = $this->lo_mdl->ptncod;
              $lv_row['docsts'] = 'A';
              if(isset($lv_row['deleted'])){
              	if($lo_ptntrf->delete( $lv_row )==false){
                	return $this->co_reg->document->getJson( array('errtyp'=>$lo_ptntrf->errtyp,'errcod'=>$lo_ptntrf->errcod,'errtxt'=>$lo_ptntrf->errtxt,'row'=>$i) );
                } 
              } else if($lo_ptntrf->save( $lv_row )==false){
               	return $this->co_reg->document->getJson( array('errtyp'=>$lo_ptntrf->errtyp,'errcod'=>$lo_ptntrf->errcod,'errtxt'=>$lo_ptntrf->errtxt,'row'=>$i) );
              }
              $i++;
            }
          }

          // TEXTOS. grabo textos
					foreach($lo_post as $lv_key=>$lv_val) {     
						if ( substr($lv_key, 0, 13)=='grldattxt_txt') {
							$lv_typcod = str_ireplace('grldattxt_txt','',$lv_key);
              // si existe un texto, se graba o modifica
              if($lv_val != ''){
                $lv_dat = array();
                $lv_dat['txtcod'] = $lo_post['grldattxt_cod'.$lv_typcod];
                $lv_dat['txttxt'] = $lv_val;
                $lv_dat['lngcod'] = $this->co_reg->sec->lngcod;
                $lv_dat['docsts'] = 'A';
                $lv_dat['txtsrctyp'] = self::OBJTYP;
                $lv_dat['txtsrccod'] = $this->lo_mdl->ptncod;
                $lv_dat['txttypcod'] = $lv_typcod;     
                
                if ( $lo_grltxtmdl->save( $lv_dat )==false ) {
									return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
                }
              	// si el texto está en blanco pero está definido el código, se elimina el texto
              }else if ($lv_val == '' && $lo_post['grldattxt_cod'.$lv_typcod] != ''){
                if ( $lo_grltxtmdl->delete( array('txtcod'=>$lo_post['grldattxt_cod'.$lv_typcod]) )==false ) {
                  return $this->co_reg->document->getJson( array('errcod'=>$lo_grltxtmdl->errcod,'errtxt'=>$lo_grltxtmdl->errtxt) );
                }
              }
						}
					}
          
          $this->lo_mdl->load( array(	'ptncod'=>$this->lo_mdl->ptncod	) );
          
          //cargo clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lo_docclsmdl->load( array('sysdocclscod' => $this->lo_mdl->sysdocclscod ) );
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          /*
          $lo_docclsmdl = $this->co_reg->load->model('grldatadrdef');
          $lo_docclsmdl->save( array('adrnme001'=> $lo_post => 'ptntxt','adrstrnum'=> $lo_post => 'adrstrnum','adrstrflr'=> $lo_post => 'adrstrflr','adrstrunt'=> $lo_post => 'adrstrunt','adrstrbld'=> $lo_post => 'adrstrbld','adrstr'=> $lo_post => 'adrstr','adrpstcod'=> $lo_post => 'adrpstcod','adrcty'=> $lo_post => 'adrcty','lndtwncod'=> $lo_post => 'lndtwncod','adrtwn'=> $lo_post => 'adrtwn','lndregcod'=> $lo_post => 'lndregcod','lndcod'=> $lo_post => 'lndcod','adrphn001'=> $lo_post => 'adrphn001','adrphn002'=> $lo_post => 'adrphn002','adrfax'=> $lo_post => 'adrfax',,'adrfax'=> $lo_post => 'adrfax'  );
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          */

          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
          
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[fltrow]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[fltrow]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
					$this->lo_mdl->sysdocclstxt = $lo_docclsmdl->sysdocclstxt;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------*/
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']) );
				break;
			
			
			
      // CHANGE - DISPLAY - COPY
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
          $this->lo_mdl->ptncod = '';
          $this->lo_mdl->ptncodext = '';
					$this->lo_mdl->docsts = 'A';
          $lv_dat = $this->lo_mdl->sptptnact;
          foreach ($lv_dat as &$lv_row){
          	$lv_row['ptnactcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          $lv_dat2 = $this->lo_mdl->sptptntrf;
          foreach ($lv_dat2 as &$lv_row){
          	$lv_row['ptntrfcod'] = '';
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
					$this->lo_mdl->sptptnact = $lv_dat;
          $this->lo_mdl->sptptntrf = $lv_dat2;
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
      		

				}
        
        
				// obtengo toda la info de la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'objtyp'=>self::OBJTYP, 'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['ptntxt'])?'[~fltrow~]p.ptntxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['ptntxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, array(), null, false);
				return $this->co_reg->document->getJson($lo_data);
        break;
			
			
			// LIST by TEXT (actividades del socio)
      case '#38':
				$lo_ptnact_mdl = $this->co_reg->load->model('sptptnact');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>'[~fltrow~]p.ptncod'.chr(9).'='.chr(9).chr(9).$lp_prm['ptncod'].chr(9).chr(9).
																			'[~fltrow~]s.acttxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['acttxt']).chr(9).chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $lo_ptnact_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
				break;
			
			
			//vista de carnets	
			case '#28':
        return $this->co_reg->document->getView( 'sptptncrd', array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod'], 'sysseclnk'=>$this->co_reg->load->controller('sysseclnk')) );
				break;
			
			
			//Lista de carnet de socios
			case '#29':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['ptntxt'])?'[~fltrow~]p.ptntxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['ptntxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->lo_mdl->getList($lv_prm);
				foreach ($lo_rs as &$lv_row) {
					if($lv_row['ptncatcod']== null){
						$lv_row['crdststxt'] = 'Falta categoria';
					}elseif ($lv_row['idttyptxt']== null) {
						$lv_row['crdststxt'] = 'Falta tipo de documento';
					}elseif ($lv_row['taxdocnum'] == null) {
						$lv_row['crdststxt'] = 'Falta numero de documento';
					}elseif ($lv_row['flecod'] == null) {
						$lv_row['crdststxt'] = 'Falta foto';
					}else{		
						$lv_row['crdststxt'] = '-';
						$lv_row['ptnbarcode'] = $lv_row['ptncodext'].$lv_row['ptncatcod'].$lv_row['ptncrddte']->format('Ymd');
					}
				}
				return $this->co_reg->document->getJson( $lo_rs );
				break;
    }

  }
}
?>