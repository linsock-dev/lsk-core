<?php
final class hltprslqdController extends tmssController2{

  function initialize(){$this->CONTROLLER='hltprslqd';$this->MODEL='hltprslqd';$this->VIEW='hltprslqd';$this->ID='hltprslqdcod';$this->enable_sysdoccls=true;}

  function beforeCreate(){$this->prm['prgcod']= 'LQD';}
  
  function beforeSave( $lp_dat ){
    $lp_dat['hltprslqdids001'] = $lp_dat['opnsrvids'];
    $lp_dat['hltprslqdids002'] = $lp_dat['opnexpids'];
    return $lp_dat;
  }
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {

			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->mdl->accounting();
      	return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
        break;

			// VER DETALLE. devuelve el detalle de los documentos liquidados (modo edición)
			case '#11':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->data['actcod'] = $this->act;
      	$this->mdl->opnexp = array();
				$this->mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']) );
				$this->mdl->sysdoccls = $lo_docclsmdl;

        $lv_hltprslqdcod = (isset($this->co_reg->request->post['hltprslqdcod'])?$this->co_reg->request->post['hltprslqdcod']:'');
				$lv_prscod = (isset($this->co_reg->request->post['prscod'])?$this->co_reg->request->post['prscod']:'');
				$lv_cuscod = (isset($this->co_reg->request->post['cuscod'])?$this->co_reg->request->post['cuscod']:'');
				$lv_strdte = (isset($this->co_reg->request->post['hltprslqdstrdte'])?$this->co_reg->request->post['hltprslqdstrdte']:'');
        $lv_enddte = (isset($this->co_reg->request->post['hltprslqdenddte'])?$this->co_reg->request->post['hltprslqdenddte']:'');
        $lv_sec = (isset($this->co_reg->request->post['token'])?$this->co_reg->request->post['token']:'');

				// obtengo control de prestaciones no liquidados
				$lo_prslqdmdl = $this->co_reg->load->model('hltprslqd');
        $lv_prm = array( 'hltprslqdcod'=>$lv_hltprslqdcod, 'prscod'=>$lv_prscod, 'cuscod'=>$lv_cuscod, 'hltprslqdstrdte'=>$lv_strdte, 'hltprslqdenddte'=>$lv_enddte, 'sysdocclscod'=>$this->mdl->sysdoccls->sysdocclscod );
				$lo_rs = $lo_prslqdmdl->getOpenServices( array(), $lv_prm );
				$this->mdl->opnsrv = $lo_rs;

				// obtengo gastos no liquidados
				$lo_rs = $lo_prslqdmdl->getOpenExpenses( array(), $lv_prm );
				$this->mdl->opnexp = $lo_rs;

        return $this->co_reg->document->getView( 'hltprslqddet', array('data'=>$this->mdl,'actcod'=>$this->data['actcod']) );
				break;

      // VER DETALLE. devuelve el detalle de los documentos liquidados (modo visualización)
      case '#13':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->data['actcod'] = $this-> act;
        $lo_post = $this->co_reg->request->post;
				$this->mdl->opnexp = array();
				$this->mdl->opnsrv = array();

				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']) );
				$this->mdl->sysdoccls = $lo_docclsmdl;

				// obtengo posiciones de prestaciones
				$lo_docmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltprslqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['hltprslqdcod'].chr(9).chr(9).
                           								'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).$this->co_reg->document->getTagValue( $this->mdl->sysdoccls->sysdocclsatr, 'srcobjtyp').chr(9).chr(9) ); 
				$lo_rs = $lo_docmdl->getList( $lv_fltopt );
				$this->mdl->opnsrv = $lo_rs;

				// obtengo posiciones de gastos
				$lv_fltopt = array('vewfldflt' =>'[~fltrow~]ld.hltprslqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['hltprslqdcod'].chr(9).chr(9).
                           								'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_EXP'.chr(9).chr(9) ); 
				$lo_rs = $lo_docmdl->getList( $lv_fltopt );
				$this->mdl->opnexp = $lo_rs;

        return $this->co_reg->document->getView( 'hltprslqddet', array('data'=>$this->mdl,'actcod'=>$this->data['actcod']) );
				break;
    }
  }
}
?>