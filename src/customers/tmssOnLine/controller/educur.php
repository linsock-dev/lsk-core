<?php
final class educurController extends tmssController {
	const MODEL = 'educur';	
	const VIEW  = 'educur';	
	const ID = 'educurcod';	
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	
	
  // Index - Método principal   
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model. Cargar modelo
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// LIST. Lista
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;	
			
			
      // SAVE. Graba un objeto
      case '#00':
        if ( $this->lo_mdl->save() ) {
          
          // grabo columnas de la tabla
          $lo_post = $this->co_reg->request->post;
					$lo_curplnmdl = $this->co_reg->load->model('educurpln');
          $lo_post['educurcod'] = $this->lo_mdl->educurcod;
					$lv_buffer = $lo_post['educurpln'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_sysvewcol_arr = json_decode($lv_buffer,true);
            foreach($lv_sysvewcol_arr as $lv_row){
              $lv_row['educurcod'] = $this->lo_mdl->educurcod;
              $lv_row['docsts'] = 'A';
              if (isset($lv_row['deleted'])) {
                if ($lo_curplnmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_curplnmdl->errtyp,'errcod'=>$lo_curplnmdl->errcod,'errtxt'=>$lo_curplnmdl->errtxt));
                }
              } else if ($lo_curplnmdl->save($lv_row)==false) {
                  return $this->co_reg->document->getJson(array('errtyp'=>$lo_curplnmdl->errtyp,'errcod'=>$lo_curplnmdl->errcod,'errtxt'=>$lo_curplnmdl->errtxt));
              } 
            }
          }
					$this->lo_mdl->load( array(	'educurcod'=>$this->lo_mdl->educurcod	) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;	
			
			
      // NEW. Nuevo               
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. Cambiar - Mostrar - Copiar
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ));

				// load object. Cargar objeto
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
          
      		// limpio codigo interno de cada posicion
          $lv_dat = $this->lo_mdl->educurpln; 
          foreach($lv_dat as &$lv_row){
            $lv_row['educurplncod'] = ''; 
            $lv_row['ctedte'] = '';
            $lv_row['cteusr'] = '';
            $lv_row['upddte'] = '';
            $lv_row['updusr'] = '';
          }
          
          
          $this->lo_mdl->educurpln = $lv_dat;
					$this->lo_mdl->educurcod = '';	
          $this->lo_mdl->educurcodext = '';	
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;		
			
			
			// DELETE. Borra un objeto
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;	
			
			
			// LIST by TEXT. Lista por texto
      case '#18': 
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['educurtxt'])?'[~fltrow~]c.educurtxt'.chr(9).''.chr(9).$lp_prm['educurtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );		
				$lo_data = $this->lo_mdl->getList($lv_prm);
				$lv_ret = array();
				foreach($lo_data as $lv_row){
					$lv_ret[] = array('educurcod'=>$lv_row['educurcod'],'educurtxt'=>$lv_row['educurtxt']);
				}
				return $this->co_reg->document->getJson( array('data'=>$lv_ret) );
        break;		
			
			
			// LIST. devuelve grilla con lista de planes de estudio
      case '#28':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = 'educurpln';
        return $lo_vew->index( '00', $lp_prm );
        break;
    }
  }
}
?>