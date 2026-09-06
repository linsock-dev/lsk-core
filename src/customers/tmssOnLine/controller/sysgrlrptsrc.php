<?php
final class sysgrlrptsrcController extends tmssController {
	const MODEL = 'sysgrlrptsrc';
	const VIEW  = 'sysgrlrptsrc';
	const ID = 'rptsrccod';
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
			
			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$lo_rptcolmdl = $this->co_reg->load->model('sysgrlrptsrccol');
					$lv_buffer = $lo_post['rptcol'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_rptcol_arr = json_decode($lv_buffer,true);
						foreach( $lv_rptcol_arr as $lv_row ) {
							$lv_row['rptsrccod'] = $this->lo_mdl->rptsrccod;
							$lv_row['rptsrcsys'] = $this->lo_mdl->rptsrcsys;
							$lv_row['rptsrccolatr'] = '<def>'.(isset($lv_row['rptsrccolatrdef'])?$lv_row['rptsrccolatrdef']:'').'</def>';
							$lv_row['docsts'] = 'A'; 
							if ( isset($lv_row['deleted']) ) {
								if ($lo_rptcolmdl->delete( $lv_row )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_rptcolmdl->errtyp,'errcod'=>$lo_rptcolmdl->errcod,'errtxt'=>$lo_rptcolmdl->errtxt) );
								}
							} else if ($lo_rptcolmdl->save( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$lo_rptcolmdl->errtyp,'errcod'=>$lo_rptcolmdl->errcod,'errtxt'=>$lo_rptcolmdl->errtxt) );
							}
						}
					}
					$this->lo_mdl->load( array(	self::ID=>$this->lo_mdl->rptsrccod, 'rptsrcsys' =>$this->lo_mdl->rptsrcsys	) );
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve vista en modo creación           
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación o visualización
      case '#02': case '#03': case '#001':
				if ( $this->lo_mdl->load( $lp_prm )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->rptsrccod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
					// Copy rptcol array in order to clear rptsrccolcod field (we can't change it directly because overload)
					$rptcols = [];
					for($i=0; $i<count($this->lo_mdl->col); $i++){
						$rptcol = $this->lo_mdl->col[$i];
						$rptcol['rptsrccolcod'] = '';
						array_push($rptcols,$rptcol);
					}
					$this->lo_mdl->col = $rptcols;
				}
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST COLS. lista las columnas del reporte
			case '#18':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->load( array('rptsrccod'=>$lo_post['rptsrccod'],'rptsrcsys'=>$lo_post['rptsrcsys']) );
				$lv_ret = array();
				foreach( $this->lo_mdl->col as $lv_row ) {
					$lv_fld = $this->co_reg->document->gettagvalue($lv_row['rptsrccolatr'],'def');
					$lv_flddef = $this->co_reg->input->GetField($lv_fld);
					$lv_ret[] = array('rptsrccolcod'=>$lv_row['rptsrccolcod'], 'rptsrccolcodext'=>$lv_row['rptsrccolcodext'], 'rptsrccoltxt'=>$lv_row['rptsrccoltxt'], 'sysfldinptyp'=>(count($lv_flddef)==0?'':$lv_flddef['sysfldinptyp']) );
				}
				return $this->co_reg->document->getJson( $lv_ret );
				break;
    }
  }
}
?>