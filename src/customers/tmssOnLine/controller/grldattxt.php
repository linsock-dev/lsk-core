<?php
final class grldattxtController extends tmssController2 {
  function initialize(){
    $this->CONTROLLER='grldattxt';$this->MODEL='grldattxt';$this->VIEW='grldattxt';$this->ID='txtcod';$this->enable_sysdoccls=false;
    $this->extraRet = array('objtyp'=>'GRL_TXT');
    $this->preventCopy = array('txtcod');
  }

  // esta funcion se usa para obtener y pasar el tipo de objeto entre operaciones
  function _getExtraParameters(){
    $this->prm['txtsys'] = (($this->prm['txtsys']??'')!='' ? $this->prm['txtsys'] : ($this->post['txtsys']??''));
  }
  
  function beforeGetList(){ $this->prm['vewfldflt'] = ($this->prm['vewfldflt']??'') . '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9); }
	function beforeCreate(){ $this->_getExtraParameters(); }
  function beforeLoad(){ $this->_getExtraParameters(); }
  function additionalFunctions($lp_act){
    switch ( $lp_act ) {
        
      // muestro dialogo de textos (o devuelvo cantidad de tipos de texto)
    	case '#dialog':
        // con ID de texto, se carga lo grabado
        if (($this->post['txtcod']??'')=='' && ($this->post['sysdocclstxtcod']??'')==''){
          $this->mdl->setData( $this->post );        
        } else {
          if( ($this->post['txtcod']??'') !='' ){
            $this->mdl->load( array('txtcod'=>$this->post['txtcod'],'txtsys'=>$this->post['txtsys']??'' ));
          // sin ID de texto se carga el modelo (solo si NO es readonly)
          } else if( ($this->post['sysdocclstxtcod']??'') != '' ){
            $this->mdl->load( array('txtcod'=>$this->post['sysdocclstxtcod'],'txtsys'=>$this->post['txtsys']??'' ));
            $this->mdl->txtcod = '';  // esto es para que el grabado posterior no pise el texto por default
          	$this->mdl->txttypcod = $this->post['txttypcod'];
          } 
          $this->mdl->txtsrctyp = $this->post['txtsrctyp'];
          $this->mdl->txtsrccod = $this->post['txtsrccod'];
        }
        
        $this->mdl->readonly = $this->post['readonly']??'true';
        return $this->co_reg->document->getView( 'grldattxtdia', array('data'=>$this->mdl,'actcod'=>$this->act) );
				break;
			
      // SAVE. graba un documento
      case '#dialogsave':
        $this->post['txtsrctyp']=$this->post['txtsrctyp']??'**';
        $this->post['txtsrccod']=$this->post['txtsrccod']??'**';
        $this->mdl->save($this->post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->mdl->errtyp,'errcod'=>$this->mdl->errcod,'errtxt'=>$this->mdl->errtxt,'txtcod'=>$this->mdl->txtcod) );  
        break;
						
			// GET TEXT. devuelve el texto
			case '#05':
				$this->mdl->load( array('txtcod'=>$this->co_reg->request->post['txtcod'], 'txtsys'=>($this->post['txtsys']??'')));
				return $this->mdl->txttxt;
				break;
        
      // LIST by TEXT. lista documentos segun texto
      case '#18': 
        $lv_txtsrctyp = ( $this->post['txtsrctyp']??$this->prm['txtsrctyp']??'' );
        $lv_txtsrccod = ( $this->post['txtsrccod']??$this->prm['txtsrccod']??'' );
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>($lv_txtsrctyp!=''?'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).$lv_txtsrctyp.chr(9).chr(9):'').
                        							($lv_txtsrccod!=''?'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).$lv_txtsrccod.chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							(isset($this->prm['txtcodext'])?'[~fltrow~]t.txtcodext'.chr(9).''.chr(9).$this->prm['txtcodext'].chr(9).chr(9).chr(9):'').
                        							(isset($this->post['txttypcodext'])?'[~fltrow~]tt.txttypcodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), json_decode(html_entity_decode($this->post['txttypcodext']))).chr(9).chr(9):'')
                        							
												);
        $lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>