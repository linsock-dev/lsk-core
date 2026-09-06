<?php
final class slscusController extends tmssController2{
	function initialize(){
    	$this->CONTROLLER='slscus';
      $this->MODEL='slscus';
      $this->VIEW='slscus';
      $this->ID='cuscod';
      $this->OBJTYP = 'SLS_CUS'; 
      $this->enable_sysdoccls = true;
      $this->extraRet = array(
        'sysseclnk'=>$this->co_reg->load->controller('sysseclnk'),
        'objtyp'=>'SLS_CUS'
      );
  }
  
   function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			
			// GETLIST by TEXT. lista los documentos por texto
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['custxt'])?'[~fltrow~]c.custxt'.chr(9).''.chr(9).$this->prm['custxt'].chr(9).chr(9).chr(9):'').
																			((isset($this->prm['sysdocclscod'])?$this->prm['sysdocclscod']:'')!=''?'[~fltrow~]dc.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$this->prm['sysdocclscod']).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson( $lo_data );
        break;
        
        
      case '#28':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($this->prm['custxt'])?'[~fltrow~]c.custxt'.chr(9).''.chr(9).$this->prm['custxt'].chr(9).chr(9).chr(9):'').
																			((isset($this->prm['sysdocclscod'])?$this->prm['sysdocclscod']:'')!=''?'[~fltrow~]dc.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$this->prm['sysdocclscod']).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getListCentral($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
			
			
			// MODIFICAR CLASE DE DOCUMENTO
			case '#32':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lo_post = $this->co_reg->request->post;
				if ( $this->mdl->load( array('cuscod'=>$lo_post['cuscod']) )==false ) {
  	      return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				} else if( !$this->mdl->changeClass( array('cuscod'=>$this->mdl->cuscod,'sysdocclscod'=>$lo_post['sysdocclscod']) ) ) {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt) );
				} else {
					return '<script>$(function(){'.
						( isset($lo_post['callback']) ? $lo_post['callback'].'();' : '' ).
						'tmssTabSecCls( $("#'.$lo_post['sysdocclssec'].'") );'.
						'});</script>';
        }
				break;
			
			
			// CAMBIAR CLASE DE DOCUMENTO
			case '#33':
				$lo_post = $this->co_reg->request->post;
        $this->mdl = $this->co_reg->load->model($this->MODEL);
        $this->mdl->load(array('cuscod' => $lo_post['cuscod']));
        $lv_dat = array('cuscod'=>$this->mdl->cuscod,'callback'=>$lo_post['callback']);
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).$this->OBJTYP.chr(9).chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]d.sysdocclscod'.chr(9).'<>'.chr(9).chr(9).$this->mdl->sysdocclscod.chr(9).chr(9)
																			);
				$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
        return $this->co_reg->document->getView('sysdocclslst', array('url'=>'?prg='.$this->CONTROLLER.'&act=32','data'=>$lv_dat,'doccls'=>$lv_docclsarr) );
				break;
    }
  }
}
?>