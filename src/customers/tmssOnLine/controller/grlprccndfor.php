<?php
final class grlprccndforController extends tmssController {
	const MODEL = 'grlprccndfor';
	const VIEW  = 'grlprccndfor';
	const ID = 'prccndforcod';
	const OBJTYP ='SYS_PCF';
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
			
			
      // SAVE. graba un documento
      case '#00':
				$lo_dat = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_dat ) ) {
					// cargo datos del documento
					$this->lo_mdl->load( array('prccndforcod'=>$this->lo_mdl->prccndforcod) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        } 
        break;
			
			
      // NEW. devuelve la vista en modo creación
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo visualización o modificiación
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].'));
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->prccndforcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson(array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt));
        break;
			
			
			// LIST by TEXT. devuelve la lista de objetos segun el texto a buscar
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['prccndfortxt'])?'[~fltrow~]pf.prccndfortxt'.chr(9).''.chr(9).$lp_prm['prccndfortxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['mdlcod'])?'[~fltrow~]pc.mdlcod'.chr(9).'='.chr(9).chr(9).$lp_prm['mdlcod'].chr(9).chr(9):'').
																			'[~fltrow~]pf.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;			
			
			
			// EVAL formula
			case '#evalFormula':
				$lo_post = $this->co_reg->request->post;
				$lv_data = (isset($lo_post['data']) ? $lo_post['data'] : (isset($lp_prm['data']) ? $lp_prm['data'] : '[]'));
				$lv_dat = json_decode(html_entity_decode($lv_data), true);
				if($lv_dat==NULL){$lv_dat=array();} else{
					$lv_inf = array();
					foreach($lv_dat as $lv_key=>$lv_val){
						foreach($lv_val as $lv_key2=>$lv_val2){
							$lv_inf[$lv_key2] = $lv_val2;
						}
					}
					$lv_dat = $lv_inf;
				}
				
				$lv_errtxt = '';
				$lv_ret = '';
				try {
					$lv_ret = $this->evalFormula( (isset($lo_post['formula']) ? $lo_post['formula'] : $lp_prm['formula']) , $lv_dat );
				} catch(Exception $e){
					$lv_errtxt = $e->getMessage();
				}
				return $this->co_reg->document->getJson( array('resultado'=>$lv_ret,'errcod'=>($lv_errtxt==''?0:-1),'errtxt'=>$lv_errtxt) );
				break;
    }
  }
	
	
	
	// evalFormula
	// evalua una fórmula en funcion de un array de datos
	// FORMULA: SI Y O DAY MONTH YEAR
	// OPERADORES: > < = <> >= <=
	// FACTORES: + - * /
	// CONSTANTES:	@@VACIO, @@HOY, @@TRUE, @@FALSE
	// ejemplo: SI([ASIGNACION.CONVENIO]=@@VACIO;[ASIGNACION.SALARIO];[CONVENIO.SALARIO_BASE]*10,75)
	public function evalFormula( $lp_frm, $lp_dat ) {
		
		// NORMALIZO FORMULA
		// quito espacios y convierto a mayúsculas
		$lp_frm = str_ireplace(' ','',strtoupper(html_entity_decode($lp_frm)));
		
		// REEMPLAZO de VALORES DE DATOS.
		// se reemplazan las variables de la formula por valores del array de datos
		// solo 2 niveles de array soportados
		$lv_fld = '';
		foreach($lp_dat as $lv_key=>$lv_val){
			$lv_fld = strtoupper($lv_key);
			if (is_a($lv_val, 'DateTime')){
				$lp_frm = str_ireplace('['.$lv_fld.']',$lv_val->format('Y.m.d'),$lp_frm); 
			} else if(is_array($lv_val)){
				foreach($lv_val as $lv_key2=>$lv_val2){
					if (is_a($lv_val2, 'DateTime')){
						$lp_frm = str_ireplace('['.$lv_fld.'.'.strtoupper($lv_key2).']',$lv_val2->format('Y.m.d'),$lp_frm); 
					} else if(!is_array($lv_val2) && !is_object($lv_val2)){
						$lp_frm = str_ireplace('['.$lv_fld.'.'.strtoupper($lv_key2).']',($lv_val2==null?'':$lv_val2),$lp_frm);
					}
				}
			} else { 
				$lp_frm = str_ireplace('['.$lv_fld.']',($lv_val==''?chr(39).chr(39):$lv_val),$lp_frm); 
			}
		}
		
		// ANALISIS DE FORMULA
		$lv_ret = $this->analizeFormula( $lp_frm );
		
		// DEVOLVER RESULTADO
		return $lv_ret;
	}
	
	
	
	// --------------------------------------------------------------------------
	// F O R M U L A 
	// --------------------------------------------------------------------------
	// analizeFormula
	// recursiva para calcular fórmula
	// se espera SI(Y(1>0;1<10);5-2;3*4) 
	// caso 1) 4
	// caso 2) 4+1
	// caso 3) SI(1>0;1;0)
	// caso 4) SI(Y(1>0;1<10);5;3)
	private function analizeFormula( $lp_frm ){	
		// función que devuelve todos los terminos de una formula (los terminos se separan por "+", "-", "(" ) 
		$lv_lvl = $this->getFormula($lp_frm);
    
		if($lv_lvl['operador']==''){
			return $lv_lvl['terminos'][0];
		
		} else if($lv_lvl['operador']=='+'){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return ( !is_numeric($lv_trm1) || !is_numeric($lv_trm2) ? 0 : ($lv_trm1 + $lv_trm2) );
		
		} else if($lv_lvl['operador']=='-'){ 
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return ( !is_numeric($lv_trm1) || !is_numeric($lv_trm2) ? 0 : ($lv_trm1 - $lv_trm2) );
		
		} else if($lv_lvl['operador']=='*'){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return ( !is_numeric($lv_trm1) || !is_numeric($lv_trm2) ? 0 : ($lv_trm1 * $lv_trm2) );
		
		} else if($lv_lvl['operador']=='/'){ 
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return ( !is_numeric($lv_trm1) || !is_numeric($lv_trm2) ? 0 : ($lv_trm2==0 ? 0 : $lv_trm1 / $lv_trm2 ) );
		
		} else if($lv_lvl['operador']=='DAY'){ 
			$lv_lvl['terminos'][0] = str_ireplace(chr(39),'',$lv_lvl['terminos'][0]);
			$lv_dte=date_create_from_format('Y.m.d',$lv_lvl['terminos'][0]); 
			return ( $lv_lvl['terminos'][0]=='' || $lv_dte==false ? 0 : intval($lv_dte->format('d')) );
		
		} else if($lv_lvl['operador']=='MONTH'){ 
			$lv_lvl['terminos'][0] = str_ireplace(chr(39),'',$lv_lvl['terminos'][0]);
			$lv_dte=date_create_from_format('Y.m.d',$lv_lvl['terminos'][0]); 
			return ( $lv_lvl['terminos'][0]=='' || $lv_dte==false ? 0 : intval($lv_dte->format('m')) );
		
		} else if($lv_lvl['operador']=='YEAR'){ 
			$lv_lvl['terminos'][0] = str_ireplace(chr(39),'',$lv_lvl['terminos'][0]);
			$lv_dte=date_create_from_format('Y.m.d',$lv_lvl['terminos'][0]); 
			return ( $lv_lvl['terminos'][0]=='' || $lv_dte==false ? 0 : intval($lv_dte->format('Y')) );
		
		} else if($lv_lvl['operador']=='<='){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 <= $lv_trm2;
		
		} else if($lv_lvl['operador']=='>='){ 
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 >= $lv_trm2;
		
		} else if($lv_lvl['operador']=='<>'){ 
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 != $lv_trm2;
		
		} else if($lv_lvl['operador']=='>'){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 > $lv_trm2;
		
		} else if($lv_lvl['operador']=='<'){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 < $lv_trm2;
		
		} else if($lv_lvl['operador']=='='){
			$lv_trm1 = $this->analizeFormula($lv_lvl['terminos'][0]);
			$lv_trm2 = $this->analizeFormula($lv_lvl['terminos'][1]);
			$lv_trm1 = ($lv_trm1==''?0:(is_numeric($lv_trm1)?floatval($lv_trm1):$lv_trm1));
			$lv_trm2 = ($lv_trm2==''?0:(is_numeric($lv_trm2)?floatval($lv_trm2):$lv_trm2));
			return $lv_trm1 == $lv_trm2;
		
		} else if($lv_lvl['operador']=='Y'){ 
			$lv_ret = true;
			foreach($lv_lvl['terminos'] as $lv_row){ 
				if($this->analizeFormula($lv_row)==false){ $lv_ret=false; }
			}
			return $lv_ret;
		
		} else if($lv_lvl['operador']=='O'){
			$lv_ret = false;
			foreach($lv_lvl['terminos'] as $lv_row){ 
				if($this->analizeFormula($lv_row)==true){ $lv_ret=true; } 
			} 
			return $lv_ret;
		
		} else if($lv_lvl['operador']=='SI'){ 
      
			if( $this->analizeFormula($lv_lvl['terminos'][0])==true ) {
				return $this->analizeFormula($lv_lvl['terminos'][1]);
			} else {
				return ( isset( $lv_lvl['terminos'][2] ) ? $this->analizeFormula($lv_lvl['terminos'][2]) : 0 );
			}
		} else {
			throw new Exception('Formula invalida.');
		}
	}
	
	
	
	// sepTerminos
	// devuelve 2 terminos y su operador. el primer termino y el resto de los terminos
	// si no encuentra mas de dos terminos, no devuelve nada para que se resuelva de forma separada
	private function sepTerminos( $lp_frm ){
		$lv_ret = array('operador'=>'','terminos'=>array(0=>'',1=>''),'formula'=>$lp_frm);
		// si comienza con un (
		if( substr($lp_frm,0,1)=='(' || substr($lp_frm,0,3)=='SI(' || substr($lp_frm,0,4)=='DAY(' || substr($lp_frm,0,6)=='MONTH(' || substr($lp_frm,0,5)=='YEAR(' ){
			$lv_parentesis = -1;
			$lv_inicio = (substr($lp_frm,0,1)=='('?1:(substr($lp_frm,0,3)=='SI('?3:(substr($lp_frm,0,4)=='DAY('?4:(substr($lp_frm,0,6)=='MONTH('?6:5))));
			for($x=$lv_inicio;$x<strlen($lp_frm);$x++){
				if(substr($lp_frm,$x,1)=='('){$lv_parentesis--;}
				if(substr($lp_frm,$x,1)==')'){
					$lv_parentesis++;
					
					// se cerro el parentesis de la formula inicial que comenzaba con "(" o con "SI("
					// se puede devolver el resultado
					if($lv_parentesis==0){ 
						
						// la formula contiene parentesis al inicio y fin x ej: (1+1)
						// se quitan estos parentesis y se devuelve la formula como: 1+1
						if( substr($lp_frm,0,1)=='(' && $x==strlen($lp_frm)-1 ) {
							$lv_ret['formula'] = substr($lp_frm,1,strlen($lp_frm)-2);
						
						// si el parentesis se cierra al final de la formula, es un solo termino. no se devuelve nada.
						} else if($x==strlen($lp_frm)) {
							break;
							
						// si el parentesis se cierra antes del fin de la formula, entonces hay mas terminos
						// se toma el primer caracter siguiente ("+","-","*","/") como operador y se devuelven
						// los terminos
						} else {
							$lv_ret['operador'] = substr($lp_frm,$x+1,1);
							$lv_ret['terminos'][0]=substr($lp_frm, ($lv_inicio==1?1:0), $x-($lv_inicio==1?1:-1) );
							$lv_ret['terminos'][1]=substr($lp_frm,$x+2,strlen($lp_frm)-$x-2);
						}
						break;
					}
				}
			}
			if($lv_ret['terminos'][1]==''){ $lv_ret['operador']=''; $lp_frm=$lv_ret['terminos'][0]; }
		}
		return $lv_ret;
	}
	
	
	
	// getFormula
	// devuelve el operador y los terminos
	private function getFormula( $lp_frm ){
		
		// separa los terminos de la formula, extrae termino 1 y termino 2
		$lv_ret = $this->sepTerminos( $lp_frm );
		$lp_frm = $lv_ret['formula'];
		if( $lv_ret['operador']!='' ){ return $lv_ret; } else { $lv_ret=array('operador'=>'','terminos'=>array()); }
		
		// si comienza con una formula SI
		if( substr($lp_frm,0,3)=='SI(' ){
			$lv_ret['operador'] = 'SI';
			$lp_frm = substr($lp_frm,3,strlen($lp_frm)-4); // quito el operador y los parentesis iniciales y finales (dejo solo los terminos)
			// determino terminos
			// siempre hay 3 terminos (x ej. SI(24>18;'ADULTO';'MENOR') )
			$lv_contador = 0;
			$lv_inicio = 0;
			for($x=0;$x<strlen($lp_frm);$x++){
				if(substr($lp_frm,$x,1)=='('){$lv_contador--;}
				if(substr($lp_frm,$x,1)==')'){$lv_contador++;}
				if(substr($lp_frm,$x,1)==';' && $lv_contador==0 && count($lv_ret['terminos'])==0){ 
					$lv_ret['terminos'][0] = substr($lp_frm,$lv_inicio,$x); 
					$lv_contador++; 
					$lv_inicio=$x+1; 
				} else if(substr($lp_frm,$x,1)==';' && $lv_contador==1 && count($lv_ret['terminos'])==1){
					$lv_ret['terminos'][1] = substr($lp_frm,$lv_inicio,$x-$lv_inicio); 
					$lv_contador++; 
					$lv_inicio=$x+1; 
				} else if($x==strlen($lp_frm)-1){ 
					$lv_ret['terminos'][2] = substr($lp_frm,$lv_inicio,strlen($lp_frm)-$lv_inicio); 
				}
			}
		
		// si comienza con una formula Y u O
		} else if( substr($lp_frm,0,2)=='Y(' || substr($lp_frm,0,2)=='O(' ){
			$lv_ret['operador'] = substr($lp_frm,0,1);
			$lp_frm = substr($lp_frm,2,strlen($lp_frm)-3); // quito el operador y los parentesis iniciales y finales (dejo solo los terminos)
			// determino terminos
			// hay teminos variables (x ej. Y(1>10;8=5;4=10*5) )
			$lv_contador = 0;
			$lv_inicio = 0;
			for($x=0;$x<strlen($lp_frm);$x++){
				if(substr($lp_frm,$x,1)=='('){$lv_contador--;}
				if(substr($lp_frm,$x,1)==')'){$lv_contador++;}
				if(substr($lp_frm,$x,1)==';' && $lv_contador==0){ 
					$lv_ret['terminos'][] = substr($lp_frm,$lv_inicio,$x-$lv_inicio); 
					$lv_inicio=$x+1; 
				} else if($x==strlen($lp_frm)-1){ 
					$lv_ret['terminos'][] = substr($lp_frm,$lv_inicio,strlen($lp_frm)-$lv_inicio); 
				}
			}
			
		// si comienza con una formula DAY, MONTH o YEAR
		} else if( substr($lp_frm,0,4)=='DAY(' || substr($lp_frm,0,6)=='MONTH(' || substr($lp_frm,0,5)=='YEAR(' ){
			$lv_inicio = (substr($lp_frm,0,4)=='DAY('?4:(substr($lp_frm,0,6)=='MONTH('?6:5));
			$lv_ret['operador'] = substr($lp_frm,0,$lv_inicio-1);
			$lv_ret['terminos'][0] = (strlen($lp_frm)==$lv_inicio+1? '' : substr($lp_frm,$lv_inicio,strlen($lp_frm)-$lv_inicio-1) );
			$lv_ret['terminos'][1] = '';
			
		} else {
			// determino operadores
			// siempre tienen 2 terminos (x ej. A+B, X-Y, P*Q, N/D)
			// siempre tienen 2 terminos (x ej. A>B, X<Y, P=Q, N<>D)
			$lv_found = false;
			for($x=0;$x<strlen($lp_frm);$x++){
				if(substr($lp_frm,$x,1)=='*' || substr($lp_frm,$x,1)=='+' || substr($lp_frm,$x,1)=='/' || substr($lp_frm,$x,1)=='-' || 
					 substr($lp_frm,$x,1)=='>' || substr($lp_frm,$x,1)=='<' || substr($lp_frm,$x,1)=='=' || 
					 substr($lp_frm,$x,2)=='<>' || substr($lp_frm,$x,2)=='>=' || substr($lp_frm,$x,2)=='<=' ){
					$lv_ret['operador'] = substr($lp_frm,$x, (substr($lp_frm,$x,2)=='<>' || substr($lp_frm,$x,2)=='<=' || substr($lp_frm,$x,2)=='>='?2:1) );
					$lv_ret['terminos'][0] = substr($lp_frm,0,$x);
					$lv_ret['terminos'][1] = substr($lp_frm, $x+(substr($lp_frm,$x,2)=='<>' || substr($lp_frm,$x,2)=='<=' || substr($lp_frm,$x,2)=='>='?2:1) , strlen($lp_frm)-$x-(substr($lp_frm,$x,2)=='<>' || substr($lp_frm,$x,2)=='<=' || substr($lp_frm,$x,2)=='>='?1:0) );
					$lv_found=true;
					break;
				}
			}
			// es un valor, determino si es una constante, numero,string o fecha
			// constantes @TRUE, @FALSE, @VACIO, @HOY
			if($lv_found==false){
				$lv_ret['operador']='';
				if($lp_frm=='@@TRUE'){ $lv_ret['terminos'][0]=true;
				} else if($lp_frm=='@@FALSE'){ $lv_ret['terminos'][0]=false;
				} else if($lp_frm=='@@VACIO'){ $lv_ret['terminos'][0]='';
				} else if($lp_frm=='@@HOY'){ 
					$lv_dte = new DateTime();
					$lv_ret['terminos'][0]=$lv_dte->format('Y.m.d');
				} else if(substr($lp_frm,0,1)==chr(39)){ $lv_ret['terminos'][0]=$lp_frm;
				} else if(stripos('.',$lp_frm)!=false){ 
					$lv_dte = date_create_from_format( 'Y.m.d' , str_ireplace('.','-',$lp_frm) );
					$lv_ret['terminos'][0]=$lv_dte->format('Y.m.d');
				} else { $lv_ret['terminos'][0]=strval($lp_frm); }
			}
		}
		return $lv_ret;
	}
	// --------------------------------------------------------------------------
}
?>