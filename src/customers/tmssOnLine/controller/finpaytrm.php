<?php
final class finpaytrmController extends tmssController {
	const MODEL = 'finpaytrm';
	const VIEW  = 'finpaytrm';
	const ID = 'paytrmcod';
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
      // SAVE
      case '#00':        
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {

					// save due
					$lo_due = $this->co_reg->load->model('finpaytrmdue');
					$lv_buffer = isset($lo_post['paytrmdue'])?$lo_post['paytrmdue']:'';;
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_due_arr = json_decode($lv_buffer,true);
						foreach( $lv_due_arr as $lv_row ) {
							$lv_row['paytrmcod'] = $this->lo_mdl->paytrmcod;
							$lv_row['docsts'] = 'A';							
							if ( isset($lv_row['deleted']) && $lv_row['deleted']=="X" && $lv_row['paytrmduecod']!="" ) {
								if ($lo_due->delete( $lv_row )==false) {
							    return $this->co_reg->document->getJson( array('errtyp'=>$lo_due->errtyp,'errcod'=>$lo_due->errcod,'errtxt'=>$lo_due->errtxt) );
								}
							} else if(  isset($lv_row['deleted']) && $lv_row['deleted']==""){
								if ($lo_due->save( $lv_row )==false) {
							    return $this->co_reg->document->getJson( array('errtyp'=>$lo_due->errtyp,'errcod'=>$lo_due->errcod,'errtxt'=>$lo_due->errtxt) );
								}
							}
							$i++;
						}
					}

					// Load createad/modified object and show it
					$this->lo_mdl->load( array(	'paytrmcod'=>$this->lo_mdl->paytrmcod	) );
          return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
			    return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
			
      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// load object
        $lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );
				if ( !isset($lv_key[self::ID]) ) {
			    return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
			    return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->paytrmcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';

					// Copy due array in order to clear paytrmcod and paytrmduecod fields (we can't change it directly because overload)
					$dues = [];
					for($i=0; $i<count($this->lo_mdl->due); $i++){
						$due = $this->lo_mdl->due[$i];
						$due['paytrmcod'] = "";
						$due['paytrmduecod'] = "";
						array_push($dues,$due);
					}
					$this->lo_mdl->due = $dues;
				}

		    return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			
			// DELETE
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['paytrmtxt'])?'[~fltrow~]t.paytrmtxt'.chr(9).''.chr(9).$lp_prm['paytrmtxt'].chr(9).chr(9).chr(9):'').
																			(isset($lp_prm['paytrmgrp'])?'[~fltrow~]t.paytrmgrp'.chr(9).''.chr(9).$lp_prm['paytrmgrp'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
        return $this->co_reg->document->getJson( $lo_data );
        break;
			
			
			
			// obtener fecha de vencimiento
			// parámetros: paytrmcod/docdte/ctedte/docaccdte
			case '#getDueDate':
				$lo_post = $this->co_reg->request->post;
				$lv_bsedte = '';
				$lo_paytrmmdl = $this->co_reg->load->model('finpaytrm');
				if( $lo_paytrmmdl->load( array('paytrmcod'=>$lo_post['paytrmcod']) ) ){
					switch( $lo_paytrmmdl->paytrmbseduedte ) {
						// contabilización
						case 'C':	
							if( (isset($lo_post['docaccdte'])?$lo_post['docaccdte']:'')!=''){
								$lv_bsedte = date_create_from_format('d/m/Y',$lo_post['docaccdte']);
							}
							break;
						// creación
						case 'I':
							if( (isset($lo_post['ctedte'])?$lo_post['ctedte']:'')!=''){
								$lv_bsedte = date_create_from_format('d/m/Y',$lo_post['ctedte']);
							}
							break;
						// documento
						case 'D':
							if( (isset($lo_post['docdte'])?$lo_post['docdte']:'')!=''){
								$lv_bsedte = date_create_from_format('d/m/Y',$lo_post['docdte']); 
							}
							break;
						// día fijo**************** (ver donde se indica el día fijo)
						case 'X': 
							if( (isset($lo_post['docdte'])?$lo_post['docdte']:'')!=''){
								$lv_bsedte = date_create_from_format('d/m/Y',$lo_post['docdte']);
								$lv_bsedte->modify('+1 month');
							}
							break;
						// personalizado ********** (hacer la llamada al programa externo)
						case 'Z':
							$lv_bsedte = '';
							break;
						// primer/ultimo día del mes ******** (tomar la fecha del día)
						case 'F': case 'L':
							if( (isset($lo_post['ctedte'])?$lo_post['ctedte']:'')!=''){
								// cargo datos de la empresa (país)
								$lo_busmdl = $this->co_reg->load->model('admbus');
								$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
								$lv_tmezne = timezone_identifiers_list(4096, strtoupper($lo_busmdl->adr->lndcod));								
								// fijar el primer dia del mes actual	21.07.2022 => 01.07.2022
								$lo_post['ctedte'] = '01/'.substr($lo_post['ctedte'],3);
								$lv_bsedte = date_create_from_format('d/m/Y',$lo_post['ctedte'],new DateTimeZone($lv_tmezne[0]));
								// agregar un mes											01.07.2022 => [01.08.2022]
								$lv_bsedte->modify('+1 month');
								// restar un día											01.08.2022 => [31.07.2022]
								if( $lo_paytrmmdl->paytrmbseduedte=='L'){
									$lv_bsedte->modify('-1 day');
								}
							}
							break;
					}
					
					$lo_data =array('paytrmcod'=>$lo_paytrmmdl->paytrmcod,
													'paytrmcodext'=>$lo_paytrmmdl->paytrmcodext,
													'paytrmtxt'=>$lo_paytrmmdl->paytrmtxt,
													'paytrmman'=>$lo_paytrmmdl->paytrmman,
													'paytrmbseduedte'=>$lo_paytrmmdl->paytrmbseduedte,
													'paytrmduedte'=>array());
					if($lv_bsedte!=''){
						foreach( $lo_paytrmmdl->due as $lv_row ) {
							$lv_strmod = '+'.$lv_row['paytrmdueqty'].' '.($lv_row['paytrmduetyp']=='1'?'days':($lv_row['paytrmduetyp']=='30'?'months':($lv_row['paytrmduetyp']=='365'?'years':'')));
							$lv_bsedte->modify( $lv_strmod );
							$lo_data['paytrmduedte'][] =array('paytrmdueamt'=>$lv_row['paytrmdueamt'],
																				'paytrmduetyp'=>$lv_row['paytrmduetyp'],
																				'paytrmdueqty'=>$lv_row['paytrmdueqty'],
																				'paytrmduedte'=>date_format($lv_bsedte,'d/m/Y')
																				);
						}
					}
					return $this->co_reg->document->getJson( $lo_data );					
				} else {
	 		  	return $this->co_reg->document->getJson( array('errtyp'=>$lo_paytrmmdl->errtyp,'errcod'=>$lo_paytrmmdl->errcod,'errtxt'=>$lo_paytrmmdl->errtxt) );
				}
				break;

    }
  }
}
?>
