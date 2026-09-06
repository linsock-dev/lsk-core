<?php 
final class grlprccndController extends tmssController {
	const MODEL = 'grlprccnd';
	const VIEW  = 'grlprccnd';
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
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba un documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
				
				// grabo condicion
        if ( $this->lo_mdl->save( $lo_post ) ) {
					
					// grabo accesos
					$lo_accmdl = $this->co_reg->load->model('grlprccndaccseq');
					$lv_buffer = $this->co_reg->request->post['prccndaccseq'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_cndacc_arr = json_decode($lv_buffer,true);
						foreach( $lv_cndacc_arr as $lv_row ) {
							$lv_row['prccndcod'] = $this->lo_mdl->prccndcod;
              // desactiva la centralización de las secuencias si no está centralizada la condición
							$lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_accmdl->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_accmdl->errtyp, 'errcod'=>$lo_accmdl->errcod, 'errtxt'=>$lo_accmdl->errtxt) );
								}
							} else if ($lo_accmdl->save( $lv_row )==false) { 
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_accmdl->errtyp, 'errcod'=>$lo_accmdl->errcod, 'errtxt'=>$lo_accmdl->errtxt) );
							}
						}
					}
					
					// cargo datos del documento
					$this->lo_mdl->load( array('prccndcod'=>$this->lo_mdl->prccndcod) );
					
					// obtiene módulos activos
					$lo_appmdlmdl = $this->co_reg->load->model('sysappmdl');
					$lv_prm = array('vewfldflt' => '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'm.mdlord' ); 
					$lo_rs = $lo_appmdlmdl->getList( $lv_prm );
					$this->lo_mdl->mdl = $lo_rs;
										
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,	'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve la vista en modo creación              
      case '#01':
				$this->lo_mdl->create();

				// obtiene módulos activos
				$lo_appmdlmdl = $this->co_reg->load->model('sysappmdl');
				$lv_prm = array('vewfldflt'=>'A');
				$lv_prm = array('vewfldflt' => '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'm.mdlord' ); 
				$lo_rs = $lo_appmdlmdl->getList( $lv_prm );
				$this->lo_mdl->mdl = $lo_rs;
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,	'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo visualizacion o modificacion
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				// get param (KEY)																																		
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->prccndcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
					$lv_tmp = $this->lo_mdl->prccndaccseq;
          foreach($lv_tmp as $lv_key=>&$lv_row){ $lv_row['prccndaccseqcod']=''; }
					$this->lo_mdl->prccndaccseq = $lv_tmp;
				}
				
				// obtiene módulos activos
				$lo_appmdlmdl = $this->co_reg->load->model('sysappmdl');
				$lv_prm = array('vewfldflt' => '[~fltrow~]m.objsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) ); 
				$lo_rs = $lo_appmdlmdl->getList( $lv_prm );
				$this->lo_mdl->mdl = $lo_rs;
        				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,	'actcod'=>$this->data['actcod']) );
        break;			
			
			
			// DELETE. borra un documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['prccndtxt'])?'[~fltrow~]pc.prccndtxt'.chr(9).''.chr(9).$lp_prm['prccndtxt'].chr(9).chr(9).chr(9):'').
                        							(isset($lp_prm['prccndcatcodext'])?'[~fltrow~]pcc.prccndcatcodext'.chr(9).'='.chr(9).chr(9).$lp_prm['prccndcatcodext'].chr(9).chr(9):'').
																			'[~fltrow~]pc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												); 
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>