<?php 
final class grlprccndrecController extends tmssController {
	const MODEL = 'grlprccnd';
	const VIEW  = 'grlprccndrec';
	const ID = 'prccndcod';
	const OBJTYP ='SYS_PCN';
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

			// LIST. devuelve la grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				$lp_prm['controller'] = 'grlprccndrec';

				// solo mostrar condiciones que tengan secuencias de acceso asignadas
				$lv_flt = '[~fltrow~]exists(select top 1 * from grl_prc_cnd_acc_seq xpcas where xpcas.BusCod=pc.BusCod and xpcas.PrcCndCod=pc.PrcCndCod)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
				
				// para el modulo de sistemas se muestran todas las condiciones, para el resto solo las habilitadas para el modulo
				if($lp_prm['mdlcod']!='sys'){
					$lv_flt .= '[~fltrow~]dbo.gettagvalue(^mdlcod^,pc.PrcCndAtr)'.chr(9).''.chr(9). $lp_prm['mdlcod'] .chr(9).chr(9).chr(9);
				}
				
				// se incluyen los filtro en POST para que lo tome la vista 
				$this->co_reg->request->post['vewfldflt'] = $lv_flt;
				
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// grabo valores
				$lo_prcmdl = $this->co_reg->load->model('grldatprc');
				$lv_buffer = $this->co_reg->request->post['prccndrec'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_valarr = json_decode($lv_buffer,true);
					foreach( $lv_valarr as $lv_row ) {
						if ( isset($lv_row['deleted']) ) {
							if ($lo_prcmdl->delete( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcmdl->errtyp,'errcod'=>$lo_prcmdl->errcod,'errtxt'=>$lo_prcmdl->errtxt) );
							}
						} else {
							$lv_row['prccndcod'] = $lo_post['prccndcod'];
							$lv_row['prccndacccod'] = $lo_post['prccndacccod'];
							$lv_row['docsts'] = 'A';
							if ($lo_prcmdl->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcmdl->errtyp,'errcod'=>$lo_prcmdl->errcod,'errtxt'=>$lo_prcmdl->errtxt) );
							}
              
              $lv_prccndrowcod = $lo_prcmdl->get('prccndrowcod');
              
              // grabo las escalas de precios
              $lv_buffer2 = $lv_row['grldatprcsca'];
              if ($lv_buffer2!='') {
                $lo_prcscamdl = $this->co_reg->load->model('grldatprcsca');
                $lv_buffer2 = html_entity_decode($lv_buffer2);
								$lv_valarr2 = json_decode($lv_buffer2,true);
                
                foreach( $lv_valarr2 as $lv_row2 ) {
                  $lv_row2['prccndrowcod'] = $lv_prccndrowcod;
                  if ( isset($lv_row2['deleted']) ) {
                    if ($lo_prcscamdl->delete( $lv_row2 )==false) {
                      return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcscamdl->errtyp,'errcod'=>$lo_prcscamdl->errcod,'errtxt'=>$lo_prcscamdl->errtxt) );
                    }
                  } else {
                    $lv_row2['docsts'] = 'A';
                    if ($lo_prcscamdl->save( $lv_row2 )==false) {
                      return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcscamdl->errtyp,'errcod'=>$lo_prcscamdl->errcod,'errtxt'=>$lo_prcscamdl->errtxt) );
                    }
                  }
                }
              }
						}
					}
				}
					
				// CONDICION/ACCESOS. cargo condición
				$lo_prccndmdl = $this->co_reg->load->model('grlprccnd');
				if($lo_prccndmdl->load( array('prccndcod'=>$lo_post['prccndcod']) )==false) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else {
					$this->lo_mdl = $lo_prccndmdl;
				}

				// ACCESO y PRECIOS
				$this->lo_mdl->prccndacccod = (isset($lo_post['prccndacccod'])?$lo_post['prccndacccod']:'');
				$this->lo_mdl->prccndrecdte = (isset($lo_post['prccndrecdte'])?$lo_post['prccndrecdte']:'');
				if($this->lo_mdl->prccndacccod!=''){
					// ACCESO. cargo definición de acceso
					$lo_accmdl = $this->co_reg->load->model('grlprccndacc');
					$lo_accmdl->load( array('prccndacccod'=>$this->lo_mdl->prccndacccod) );
					$this->lo_mdl->prccndacc = $lo_accmdl;
				
					// PRECIOS. cargo accesos de condición
					$lv_dte = $this->co_reg->db->sqldate($this->lo_mdl->prccndrecdte);
					$lv_dte = substr($lv_dte,0,4).'-'.substr($lv_dte,4,2).'-'.substr($lv_dte,6,2);
					$lo_prcmdl = $this->co_reg->load->model('grldatprc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SYS_PCN'.chr(9).chr(9).
																				'[~fltrow~]p.prccndacccod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prccndacccod.chr(9).chr(9).
																				'[~fltrow~]p.prccndcod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prccndcod.chr(9).chr(9).
																				'[~fltrow~]p.prccndstrdte'.chr(9).'<='.chr(9).chr(9).$lv_dte.chr(9).chr(9).
																				'[~fltrow~]p.prccndenddte'.chr(9).'>='.chr(9).chr(9).$lv_dte.chr(9).chr(9)
													);
					$lo_rs = $lo_prcmdl->getList( $lv_prm );
          
					$this->lo_mdl->prcrec = $lo_rs;
          $lv_prcsca = array();
          foreach($lo_rs as $lv_row){
            foreach($lv_row['grldatprcsca'] as $lv_row2){
              $lv_prcsca[] = $lv_row2;
            }
          }
          $this->lo_mdl->prcsca = $lv_prcsca;
				} else {
					$this->lo_mdl->prcrec = array();
					$this->lo_mdl->prcsca = array();
        }					
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'], 'prcsync'=>false) );
        break;
			
			
      // CHANGE - DISPLAY. devuelve vista en modo modificacion o visualizacion
      case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
				$lv_key = array();
				$lo_prccndmdl = $this->co_reg->load->model('grlprccnd');
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=> (isset($lp_prm[self::ID])?$lp_prm[self::ID]:(isset($lo_post[self::ID])?$lo_post[self::ID]:'')) );
				if ($lv_key[self::ID]=='') {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				// CONDICION/ACCESOS. cargo condición
				} else if($lo_prccndmdl->load( $lv_key )==false) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else {
					$this->lo_mdl = $lo_prccndmdl;
				}

				// ACCESO y PRECIOS
				$this->lo_mdl->prccndacccod = (isset($lo_post['prccndacccod'])?$lo_post['prccndacccod']:'');
				$this->lo_mdl->prccndrecdte = (isset($lo_post['prccndrecdte'])?$lo_post['prccndrecdte']:'');
				if($this->lo_mdl->prccndacccod!=''){
					// ACCESO. cargo definición de acceso
					$lo_accmdl = $this->co_reg->load->model('grlprccndacc');
					$lo_accmdl->load( array('prccndacccod'=>$this->lo_mdl->prccndacccod) );
					$this->lo_mdl->prccndacc = $lo_accmdl;
          foreach($lo_prccndmdl->prccndaccseq as $lv_row){
            if($lv_row['prccndacccod']==$this->lo_mdl->prccndacccod){
              $this->lo_mdl->prccndacc->prccndaccseqsynprc=$lv_row['prccndaccseqsynprc'];
              break;
            }
          }
				
					// PRECIOS. cargo accesos de condición
					$lv_dte = $this->co_reg->db->sqldate($this->lo_mdl->prccndrecdte);
					$lv_dte = substr($lv_dte,0,4).'-'.substr($lv_dte,4,2).'-'.substr($lv_dte,6,2);
					$lo_prcmdl = $this->co_reg->load->model('grldatprc');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SYS_PCN'.chr(9).chr(9).
																				'[~fltrow~]p.prccndacccod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prccndacccod .chr(9).chr(9).
																				'[~fltrow~]p.prccndcod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prccndcod .chr(9).chr(9).
																				'[~fltrow~]p.prccndstrdte'.chr(9).'<='.chr(9).chr(9).$lv_dte.chr(9).chr(9).
																				'[~fltrow~]p.prccndenddte'.chr(9).'>='.chr(9).chr(9).$lv_dte.chr(9).chr(9)
													);
					$lo_rs = $lo_prcmdl->getList( $lv_prm );
					$this->lo_mdl->prcrec = $lo_rs;
          $lo_prcsca = array();
          
          foreach ($lo_rs as $lv_row) {
            if (isset($lv_row['grldatprcsca'])){
              foreach($lv_row['grldatprcsca'] as $lv_row2){
             		array_push($lo_prcsca, $lv_row2);
              }
            }
          }
          $this->lo_mdl->prcsca = $lo_prcsca;
				} else {
					$this->lo_mdl->prcsca = array();
					$this->lo_mdl->prcrec = array();
				}
        
        // cargo parámetro de sincronización
        $lo_prmmdl = $this->co_reg->load->model( 'sysappmdlprm' );  
        $lv_prmarr = array('mdlcod'=>'GRL', 'mdlatrval001'=>'GRL_PRC_SYN');
        $lo_prm_rs = $lo_prmmdl->getParameter( $lv_prmarr );
        $lv_prcsync = count($lo_prm_rs)>0;

				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'], 'prcsync'=>$lv_prcsync) );
        break;
        
        
      // ESCALA DE PRECIOS. muestra el popup de escala de precios
      case '#prcsca':
        $lo_post = $this->co_reg->request->post;

        if (isset($lo_post['grldatprcsca'])){
          $this->lo_mdl->prcsca = json_decode(html_entity_decode($lo_post['grldatprcsca']),true);
        }else{
          $this->lo_mdl->prcsca = array();
        }
        
        //datos originales del registro
        $this->lo_mdl->prccndqty = ( isset($lo_post['prccndqty']) ? $lo_post['prccndqty'] : '' );
        $this->lo_mdl->prccnduntcod = ( isset($lo_post['prccnduntcod']) ? $lo_post['prccnduntcod'] : '' );
        $this->lo_mdl->prccndval = ( isset($lo_post['prccndval']) ? $lo_post['prccndval'] : '' );
        $this->lo_mdl->curcod = ( isset($lo_post['curcod']) ? $lo_post['curcod'] : '' );
        
        //condicion
        $lv_keys = (isset($lo_post['key1']) ? $lo_post['key1'] : '');
        $lv_keys .= (isset($lo_post['key2']) ? '/'.$lo_post['key2'] : '');
        $lv_keys .= (isset($lo_post['key3']) ? '/'.$lo_post['key3'] : '');
        $this->lo_mdl->prccndatr = $lv_keys;
        
				//modo solo lectura
        $this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'false');
        
        //devuelve la vista del dialogo de escala de precios
        return $this->co_reg->document->getView( 'grldatprcsca', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'] ) );
				break;
        
    }
  }
}
?>