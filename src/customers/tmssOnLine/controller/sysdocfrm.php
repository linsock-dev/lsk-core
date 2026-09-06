<?php
final class sysdocfrmController extends tmssController {
	const CONTROLLER = 'sysdocfrm';
	const MODEL = 'sysdocfrm';
	const VIEW  = 'sysdocfrm';
	const ID = 'sysdocfrmcod';
	const OBJTYP ='SYS_FRM';
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
					//graba los elementos del formulario
					$lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');

					$lv_buffer = $lo_post['sysdocfrmfld'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_frmfld_arr = json_decode($lv_buffer,true);

						foreach( $lv_frmfld_arr as $lv_row ){
              $lo_dat = array('sysdocfrmfldcod'	 => ($lo_post['sysdocfrmcod']!=''?$lv_row['sysdocfrmfldcod']:''),
                              'sysdocfrmfldcodext'=> $lv_row['sysdocfrmfldcodext']??'',
															'sysdocfrmcod'	   => $this->lo_mdl->sysdocfrmcod,
															'sysfldinptyp'	   => $lv_row['sysfldinptyp'],
															'sysdocfrmfldord'  => $lv_row['sysdocfrmfldord'],
															'sysdocfrmfldatr'  => json_encode($lv_row['sysdocfrmfldatr']),
															'docsts'				   => 'A',
															'deleted'					 => $lv_row['deleted']);

							if ($lo_dat['deleted'] == 'X' && $lo_frmfldmdl->delete( $lo_dat )==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$lo_frmfldmdl->errtyp,'errcod'=>$lo_frmfldmdl->errcod,'errtxt'=>$lo_frmfldmdl->errtxt));
              }
							if ($lo_frmfldmdl->save( $lo_dat )==false) {
                return $this->co_reg->document->getJson(array('errtyp'=>$lo_frmfldmdl->errtyp,'errcod'=>$lo_frmfldmdl->errcod,'errtxt'=>$lo_frmfldmdl->errtxt));
              }
						}
					}

					// cargo documento
					$this->lo_mdl->load( array(	'sysdocfrmcod'=>$this->lo_mdl->sysdocfrmcod	) );

					// muestro vista
					return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        } else {
	        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;


      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();

				$lo_frmfldatrmdl = $this->co_reg->load->model('sysdocfrmfldatr');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$this->lo_mdl->sysdocfrmfldatr = $lo_frmfldatrmdl->getList( $lv_prm );

        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
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
					$this->lo_mdl->sysdocfrmcod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';

					//borra el id del formulario a los elementos
					$lo_frmfldar = $this->lo_mdl->sysdocfrmfld;
					foreach($lo_frmfldar as &$lv_row ){ $lv_row['sysdocfrmcod'] = ''; }
					unset($lv_row);
					$this->lo_mdl->sysdocfrmfld = $lo_frmfldar;
          
				}
				$this->lo_mdl->tmss_actcod = $lp_act;
				// muestro vista
        return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']));
        break;


			// DELETE. borra un objeto
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
     
				
      // LIST by TEXT. lista documentos segun texto
      case '#18':
				$lo_post = $this->co_reg->request->post;
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' =>(isset($lp_prm['sysdocfrmtxt'])?'[~fltrow~]sysdocfrmtxt'.chr(9).''.chr(9).$lp_prm['sysdocfrmtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }
}
?>
