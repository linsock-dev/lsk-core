<?php 
final class sysdocwrkController extends tmssController {
	const CONTROLLER = 'sysdocwrk';
	const MODEL = 'sysdocwrk';
	const VIEW  = 'sysdocwrk';
	const ID = 'wrkflwcod';
	const OBJTYP ='SYS_WRK';
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
				// grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
          // grabo las acciones
          $lo_wrkflwactmdl = $this->co_reg->load->model('sysdocwrkact');
          $lv_wrkflwact = $lo_post['wrkflwact'];
          if ($lv_wrkflwact!='') {
						$lv_wrkflwact = html_entity_decode($lv_wrkflwact);
						$lv_wrkflwact_arr = json_decode($lv_wrkflwact,true);
            foreach($lv_wrkflwact_arr as $lv_row){
              $lv_row['wrkflwcod'] = $this->lo_mdl->wrkflwcod;
							$lv_row['docsts'] = 'A';
              if ( isset($lv_row['deleted']) ) {
                if ($lo_wrkflwactmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwactmdl->errtyp,'errcod'=>$lo_wrkflwactmdl->errcod,'errtxt'=>$lo_wrkflwactmdl->errtxt));
                }
              } else if ($lo_wrkflwactmdl->save($lv_row)==false) {
								return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwactmdl->errtyp,'errcod'=>$lo_wrkflwactmdl->errcod,'errtxt'=>$lo_wrkflwactmdl->errtxt));
              } 
            }
          }
          
          //grabo los componentes
          $lo_wrkflwstpmdl = $this->co_reg->load->model('sysdocwrkstp');
          $lv_wrkflwstp = $lo_post['wrkflwstp'];
					if ($lv_wrkflwstp!='') {
						$lv_wrkflwstp = html_entity_decode($lv_wrkflwstp);
						$lv_wrkflwstp_arr = json_decode($lv_wrkflwstp,true);
            foreach($lv_wrkflwstp_arr as $lv_row){
              $lv_row['wrkflwcod'] = $this->lo_mdl->wrkflwcod;
							$lv_row['docsts'] = 'A';
              
              // graba pasos
              if ( isset($lv_row['deleted']) ) {
                if ($lo_wrkflwstpmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwstpmdl->errtyp,'errcod'=>$lo_wrkflwstpmdl->errcod,'errtxt'=>$lo_wrkflwstpmdl->errtxt));
                }
              } else if ($lo_wrkflwstpmdl->save($lv_row)==false) {
								return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwstpmdl->errtyp,'errcod'=>$lo_wrkflwstpmdl->errcod,'errtxt'=>$lo_wrkflwstpmdl->errtxt));
              } else if(isset($lv_row['wrkflwstpact']) || isset($lv_row['wrkflwstpactdel']) ) { 
                
                // graba acciones de pasos 
                $lv_row['wrkflwstpact'] = isset($lv_row['wrkflwstpact']) ? $lv_row['wrkflwstpact'] : array();
                foreach($lv_row['wrkflwstpact'] as $lv_row2){ 
                  $lv_row2['wrkflwcod'] = $this->lo_mdl->wrkflwcod;
                  $lv_row2['wrkflwstpcod'] = $lo_wrkflwstpmdl->wrkflwstpcod;
                  $lv_row2['docsts'] = 'A';
                  if ($lo_wrkflwactmdl->save($lv_row2)==false) {
                    return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwactmdl->errtyp,'errcod'=>$lo_wrkflwactmdl->errcod,'errtxt'=>$lo_wrkflwactmdl->errtxt));
                  } 
                }
                
                // elimina acciones de pasos
                $lv_row['wrkflwstpactdel'] = isset($lv_row['wrkflwstpactdel']) ? $lv_row['wrkflwstpactdel'] : array();
                foreach($lv_row['wrkflwstpactdel'] as $lv_row2){ 
                  if ($lo_wrkflwactmdl->delete( $lv_row2 )==false) {
                    return $this->co_reg->document->getJson(array('errtyp'=>$lo_wrkflwactmdl->errtyp,'errcod'=>$lo_wrkflwactmdl->errcod,'errtxt'=>$lo_wrkflwactmdl->errtxt));
                  }
                }
              }
            }
          }
          
					// cargo documento
					$this->lo_mdl->load( array(	'wrkflwcod'=>$this->lo_mdl->wrkflwcod	) );
          
					// muestro vista
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        } else {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->wrkflwstp = array();
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación, visualización o copia
      case '#02': case '#03': case '#001':
				$lv_key = array();

				// get param (KEY)
        $lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          
          $this->lo_mdl->sysdocwrkact = array(); 
					$lv_dat = $this->lo_mdl->sysdocwrkstp;
					for($i=0; $i<count($lv_dat); $i++){
						$lv_dat[$i]['wrkflwcod']='';	
						$lv_dat[$i]['wrkflwstpcod']='';	
					} 
					$this->lo_mdl->sysdocwrkstp = $lv_dat;
					
          $this->lo_mdl->wrkflwcod = '';
          $this->lo_mdl->wrkflwcodext = '';
          $this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;


			// DELETE. borra un objeto
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
      
			
      // LIST by TEXT. devuelve lista de documentos segun texto
      case '#17': case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['wrkflwtxt'])?'[~fltrow~]w.wrkflwtxt'.chr(9).''.chr(9).$lp_prm['wrkflwtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]w.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
				break;
    }
  }
}
?>