<?php
final class hltpatController extends tmssController2 {
 function initialize(){
    $this->OBJTYP='HLT_PAT'; $this->CONTROLLER='hltpat';$this->MODEL='hltpat';$this->VIEW='hltpat';$this->ID='patcod';$this->enable_sysdoccls=true;$this->extraRet = array('sysseclnk' => $this->co_reg->load->controller('sysseclnk'));
  }
  //Migrar una vez que pueda cambiarse el VIEW de un create/modify/View de tmssController2
 	function create(){
     $this->post = $this->co_reg->request->post;

    $this->mdl->create();
    /* ------------------------------------------------ */
    /* obtengo clase de documento 											*/
    /* ------------------------------------------------ */
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
    $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
    if ( $lv_docclscod=='' ) {															// si no se indicó
      $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).$this->OBJTYP.chr(9).chr(9).chr(9).
                                    '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                    );
      $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
      if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
        $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
      } else {
        return $this->co_reg->document->getView( 'sysdocclslst', array('data'=>$this->post,'url'=>'?prg='.$this->CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
      }
    }
    if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
      $this->mdl->sysdoccls = $lo_docclsmdl;
    } else {
      echo 'No se pudieron cargar los datos de la clase de documento.';
    }
    /* ------------------------------------------------ */
    $lv_vew = (isset($this->post['hltpatvew'])?$this->post['hltpatvew']:$this->VIEW);
    $this->mdl->lv_sec = (isset($this->post['lv_sec'])?$this->post['lv_sec']:'');
    return $this->co_reg->document->getView($lv_vew, array('data'=>$this->mdl, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'objtyp' => $this->OBJTYP, 'actcod'=>$this->act));
  }
  
  
  function modify(){
    $this->post = $this->co_reg->request->post;
    $lv_key = array();

    // get param (KEY)																																		
    $lv_key = array( $this->ID=>(isset($lp_prm[$this->ID]) ? $lp_prm[$this->ID] : $this->co_reg->request->post[$this->ID]) );

    // load object
    if ( !isset($lv_key[$this->ID]) ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.$this->ID.'].') );
    } else if ( $this->mdl->load($lv_key)==false ) {
      return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
    // cargo la clase de documento
    } else {
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      $lo_docclsmdl->load(array('sysdocclscod'=>$this->mdl->sysdocclscod));
      $this->mdl->sysdoccls = $lo_docclsmdl;
    }

    // copiar
    if ( $this->act == '#001' ) {
      $this->mdl->patcod = '';																										
      $lv_dat = $this->mdl->prsrls;
      for ($i = 0; $i < count($lv_dat); $i++) {
        $lv_dat[$i]['patprsrlscod'] = '';
      }
      $this->mdl->prsrls = $lv_dat;
      $this->mdl->ctedte = '';
      $this->mdl->cteusr = '';
      $this->mdl->upddte = '';
      $this->mdl->updusr = '';
    }
    return $this->co_reg->document->getView((isset($this->post['hltpatvew'])?$this->post['hltpatvew']:$this->VIEW), array('data'=>$this->mdl, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'objtyp' => $this->OBJTYP, 'actcod'=>$this->act));
  }
   // VER - devuelve la vista del documento en modo visualización
    function view(){
      // get param (KEY)																																		
      $lv_key = array( $this->ID=>(isset($this->prm[$this->ID]) ? $this->prm[$this->ID] : $this->co_reg->request->post[$this->ID]) );

      // load object
      if ( !isset($lv_key[$this->ID]) ) {
        return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.$this->ID.'].') );
      } else if ( $this->mdl->load($lv_key)==false ) {
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
      // cargo la clase de documento
      } else {
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsmdl->load(array('sysdocclscod'=>$this->mdl->sysdocclscod));
        $this->mdl->sysdoccls = $lo_docclsmdl;
      }
			
      // devuelve los datos
      $lv_ret = array_merge(array('data'=>($this->getJson!='' ? $this->mdl->getData() : $this->mdl),'actcod'=>$this->act), $this->extraRet);
      $lv_vew = (isset($this->post['hltpatvew'])?$this->post['hltpatvew']:$this->VIEW);
      if( $this->getJson!='' ){
        return $this->co_reg->document->getJson( $lv_ret );
      } else {
        return $this->co_reg->document->getView( $lv_vew , $lv_ret );
      }
    }
  
  function additionalFunctions($lp_act, $lp_prm=[] ){
    switch ( $lp_act ) {
      // CHECK DUPLICATES
      case '#17': 
				$lv_src = array('adrfrtnme'=>(isset($this->co_reg->request->post['adrfrtnme'])?$this->co_reg->request->post['adrfrtnme']:''),
												'adrlstnme'=>(isset($this->co_reg->request->post['adrlstnme'])?$this->co_reg->request->post['adrlstnme']:'')
												);
				$lv_prm = array('vewfldflt' =>($lv_src['adrfrtnme']!=''?'[~fltrow~]a.adrfrtnme'.chr(9).'='.chr(9).chr(9).$lv_src['adrfrtnme'].chr(9).chr(9):'').
																			($lv_src['adrlstnme']!=''?'[~fltrow~]a.adrlstnme'.chr(9).'='.chr(9).chr(9).$lv_src['adrlstnme'].chr(9).chr(9):'')
																			);
        
				$lo_rs = $this->mdl->getList($lv_prm);
				$lv_ret = array();
				foreach($lo_rs as $lv_row){
					$lv_ret[] = array('patcod'=>$lv_row['patcod'],'adrfrtnme'=>$lv_row['adrfrtnme'],'adrlstnme'=>$lv_row['adrlstnme']);
				}
        return $this->co_reg->document->getJson( $lv_ret );
        break;
			// LIST by TEXT
      case '#18':
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['pattxt'])?'[~fltrow~]p.pattxt'.chr(9).''.chr(9).$lp_prm['pattxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
      // LISTAR  PACIENTES  x  TEXTO
      case '#19':
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['pattxtfnd'])?'[~fltrow~]p.pattxt+isnull(id.idttyptxt,^^)+isnull(t.taxdocnum,^^)'.chr(9).''.chr(9).$lp_prm['pattxtfnd'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]p.deldte'.chr(9).'ZZ'.chr(9).chr(9).' IS NULL'.chr(9).chr(9)
												);
				$lo_data = $lo_patmdl->getList($lv_prm);
				for($i=0; $i<count($lo_data); $i++){
					$lo_data[$i]['pattxtfnd'] = $lo_data[$i]['pattxt'].' ('.$lo_data[$i]['idttyptxt'].' '.$lo_data[$i]['taxdocnum'].')';
				}
        return $this->co_reg->document->getJson( $lo_data );
        break;			
      
			
      // DISPLAY (infowindow)
      case '#23':
				if ( !isset($lp_prm[$this->ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.$this->ID.'].') );
				} else if ( $this->mdl->load($lp_prm)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				}
				$lv_vew = 'hltpatinf' . (isset($lp_prm['vewtyp'])?$lp_prm['vewtyp']:'typ001');
        return $this->co_reg->document->getView($lv_vew, array('data'=>$this->mdl, 'model' => $this->MODEL, 'actcod'=>$lp_act));
        break;
        
      // MODIFICAR CLASE DE DOCUMENTO
			case '#32':
				$this->post = $this->co_reg->request->post;
				if ( $this->mdl->load( array('patcod'=>$this->post['patcod']) )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				} else if( !$this->mdl->changeClass( array('patcod'=>$this->mdl->patcod,'sysdocclscod'=>$this->post['sysdocclscod']) ) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				} else {
					$this->mdl->load( array('patcod'=>$this->post['patcod']) );
					
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load(array('sysdocclscod'=>$this->mdl->sysdocclscod));
					$this->mdl->sysdoccls = $lo_docclsmdl;
					
					return $this->co_reg->document->getView($this->VIEW, array('data'=>$this->mdl, 'sysseclnk' => $this->co_reg->load->controller('sysseclnk'), 'objtyp' => $this->OBJTYP, 'actcod'=>$lp_act));
				}
				break;
			
			// CAMBIAR CLASE DE DOCUMENTO
			case '#33':
				$this->post = $this->co_reg->request->post;
				
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->post['sysdocclscod'])?$this->post['sysdocclscod']:'');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).$this->OBJTYP.chr(9).chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																			);
				$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto

				$this->post['evldia'] = utf8_decode($this->post['evldia']??'');

				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' 	=> $this->co_reg->sec,
												'url'		=> '?prg='.$this->CONTROLLER.'&act=32',
												'data'  => $this->post,
												'doccls'=> $lv_docclsarr
												);
				$lv_ret = $this->co_reg->load->view( 'sysdocclslst', $lv_prm );		
				return $lv_ret;
				break;
    }
  }
}
?>