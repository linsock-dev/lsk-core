<?php 
final class hltpatcreplnController extends tmssController {  
  const CONTROLLER = 'hltpatcrepln';	
	const MODEL = 'hltpatcrepln';
	const VIEW  = 'hltpatcrepln';
	const ID = 'patcreplncod';
	const OBJTYP ='HLT_PLA';
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
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				$lp_prm['srcmtd'] = 'getPatientsList';
        return $lo_vew->index( '00', $lp_prm );
        break;

      // SAVE
      case '#00':
        
				$lv_act = ($this->co_reg->request->post['patcod']!=''?'02':'01');
				$lo_post = $this->co_reg->request->post;
				 
				$lv_patcreplncod = (isset($this->co_reg->request->post['patcreplncod'])?$this->co_reg->request->post['patcreplncod']:'');
				$lo_patcreplnmdl_prv = $this->co_reg->load->model('hltpatcrepln');
				if ( $lv_patcreplncod!='' ) { $lo_patcreplnmdl_prv->load( array('patcreplncod'=>$lv_patcreplncod) ); }

				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load(array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']));
				
        
        if ( $this->lo_mdl->save() ) {  
          
          // cargo documento
          $this->lo_mdl->load( array(	'patcreplncod'=>$this->lo_mdl->patcreplncod	) );	
          $lv_doccod = $this->lo_mdl->patcreplncod;
                
					// MATERIALES
					$lo_plnmatmdl = $this->co_reg->load->model('hltpatcreplnmat');
					$lv_buffer = $this->co_reg->request->post['patcreplnmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['patcreplncod'] = $this->lo_mdl->patcreplncod;
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_plnmatmdl->delete( $lv_arr )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_plnmatmdl->errtyp,'errcod'=>$lo_plnmatmdl->errcod,'errtxt'=>$lo_plnmatmdl->errtxt) );				
								}
							} else if ($lo_plnmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_plnmatmdl->errtyp,'errcod'=>$lo_plnmatmdl->errcod,'errtxt'=>$lo_plnmatmdl->errtxt) );
							}
						}
					}					
					$this->lo_mdl->load( array('patcreplncod'=>$this->lo_mdl->patcreplncod) );								
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
      // NEW                     
      case '#01':
        
					$this->lo_mdl->create();
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$this->lo_mdl->pattxt = $lo_patmdl->pattxt;
					$this->lo_mdl->patcreplnmat = array();

					// obtengo clase de documento 										
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
					if ( $lv_docclscod=='' ) {															// si no se indicó
						$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																					'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																					);
						$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
						if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
							$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
						} else {
							return $this->co_reg->document->getView('sysdocclslst',array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01', 'doccls'=>$lv_docclsarr));
						}
					}
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					} else {
						echo 'No se pudieron cargar los datos de la clase de documento.';
					}
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
					
         break;
       
     	// CHANGE - DISPLAY - COPY 
    	case '#02': case '#03': case '#001':									

				$lv_key = array();
				// get param (KEY)
        $lv_key = array( self::ID=>( isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID] ) );
				
          // load object
					if ( !isset($lv_key[self::ID]) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No se indico parametro ['.self::ID.']') );
					} else if ( $this->lo_mdl->load($lv_key)==false ) {
						return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

					// cargo la clase de documento
					} else {
						$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
						$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod));
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					if ( $lp_act == '#001' ) {					
            $lo_patcreplnmat = $this->lo_mdl->patcreplnmat;
            foreach($lo_patcreplnmat as &$lv_row){
              
              $lv_row['patcreplnmatcod'] = '';
          	}
            unset($lv_row);
            $this->lo_mdl->patcreplnmat = $lo_patcreplnmat;

            $this->lo_mdl->patcreplncod = '';
            $this->lo_mdl->ctedte = '';
            $this->lo_mdl->cteusr = '';
            $this->lo_mdl->upddte = '';
            $this->lo_mdl->updusr = '';
					}	
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        	break;

			// DELETE
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
				
			// LIST HISTORY
      case '#28':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = 'hltpatcrepln';
				$lp_prm['srcmtd'] = 'getHistory';
				$lp_prm['actcod'] = '28';
        return $lo_vew->index( '00', $lp_prm );
        break;
				
    }
  }
}
?>