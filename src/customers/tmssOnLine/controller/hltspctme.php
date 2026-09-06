<?php
final class hltspctmeController extends tmssController {
	const MODEL = 'hltspctme';
	const VIEW  = 'hltspctme';
	const ID = 'spccod';
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
				$lo_post['delcod'] = (isset($lo_post['delcod'])?$lo_post['delcod']:'');
				$lo_post['spccod'] = (isset($lo_post['spccod'])?$lo_post['spccod']:'');
				$lo_post['prscod'] = (isset($lo_post['prscod'])?$lo_post['prscod']:'');
				
				$lv_buffer = $lo_post['hltspctme'];
				if ($lv_buffer!='') {
					$i=0;
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_tmearr = json_decode($lv_buffer,true);
					foreach( $lv_tmearr as $lv_row ) {
						$lv_row['delcod'] = ($lo_post['delcod']!=''?$lo_post['delcod']:$lv_row['delcod']);
						$lv_row['spccod'] = ($lo_post['spccod']!=''?$lo_post['spccod']:$lv_row['spccod']);
						$lv_row['prscod'] = ($lo_post['prscod']!=''?$lo_post['prscod']:$lv_row['prscod']);
						$lv_row['docsts'] = 'A';
						if ( isset($lv_row['deleted']) ) {
							if ($this->lo_mdl->delete( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'row'=>$i) );
							}
						} else if ($this->lo_mdl->save( $lv_row )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'row'=>$i) );
						}
						$i++;
					}
				}

				// obtengo datos especialidad
				$lo_delmdl = $this->co_reg->load->model('hltdel');
				if( $lo_post['delcod']!='' ) {
					$lo_delmdl->load( array('delcod'=>$lo_post['delcod']),false );
					$this->lo_mdl->delcod = $lo_delmdl->delcod;
					$this->lo_mdl->deltxt = $lo_delmdl->deltxt;
				}
				
				// obtengo datos especialidad
				$lo_spcmdl = $this->co_reg->load->model('hltspc');
				if( $lo_post['spccod']!='' ) {
					$lo_spcmdl->load( array('spccod'=>$lo_post['spccod']) );
					$this->lo_mdl->spccod = $lo_spcmdl->spccod;
					$this->lo_mdl->spctxt = $lo_spcmdl->spctxt;
				}

				// obtengo datos prestador
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				if( $lo_post['prscod']!='' ) {
					$lo_prsmdl->load( array('prscod'=>$lo_post['prscod']) );
					$this->lo_mdl->prscod = $lo_prsmdl->prscod;
					$this->lo_mdl->prstxt = $lo_prsmdl->prstxt;
				}
				
				// cargo horarios
				$lo_tmemdl = $this->co_reg->load->model('hltspctme');
				$lv_prm = array('vewfldflt' =>($lo_post['delcod']!='' && $lo_post['spccod']=='' && $lo_post['prscod']==''?
																					'[~fltrow~]t.delcod'.chr(9).'='.chr(9).chr(9).$lo_post['delcod'].chr(9).chr(9).
																					'[~fltrow~]t.spccod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																					'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
																					:'').
																			($lo_post['spccod']!=''?'[~fltrow~]t.spccod'.chr(9).'='.chr(9).chr(9).$lo_post['spccod'].chr(9).chr(9):'').
																			($lo_post['prscod']!=''?'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).$lo_post['prscod'].chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => ' d.deltxt, s.spctxt, p.prstxt, t.tmeday '
												);		
				$lo_rs = $lo_tmemdl->getList( $lv_prm );
				$this->lo_mdl->hltspctme = $lo_rs;
				
				$this->data['actcod'] = '02';
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
      // NEW                
      case '#01':
				$this->lo_mdl->create();
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY
			case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;

				$lo_post['delcod'] = (isset($lo_post['delcod'])?$lo_post['delcod']:'');
				$lo_post['spccod'] = (isset($lo_post['spccod'])?$lo_post['spccod']:'');
				$lo_post['prscod'] = (isset($lo_post['prscod'])?$lo_post['prscod']:'');
				
				// obtengo datos delegacion
				$lo_delmdl = $this->co_reg->load->model('hltdel');
				if( $lo_post['delcod']!='' ) {
					$lo_delmdl->load( array('delcod'=>$lo_post['delcod']),false );
					$this->lo_mdl->delcod = $lo_delmdl->delcod;
					$this->lo_mdl->deltxt = $lo_delmdl->deltxt;
				}
				
				// obtengo datos especialidad
				$lo_spcmdl = $this->co_reg->load->model('hltspc');
				if( $lo_post['spccod']!='' ) {
					$lo_spcmdl->load( array('spccod'=>$lo_post['spccod']) );
					$this->lo_mdl->spccod = $lo_spcmdl->spccod;
					$this->lo_mdl->spctxt = $lo_spcmdl->spctxt;
				}

				// obtengo datos prestador
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				if( $lo_post['prscod']!='' ) {
					$lo_prsmdl->load( array('prscod'=>$lo_post['prscod']) );
					$this->lo_mdl->prscod = $lo_prsmdl->prscod;
					$this->lo_mdl->prstxt = $lo_prsmdl->prstxt;
				}
				
				// cargo horarios
				$lo_tmemdl = $this->co_reg->load->model('hltspctme');
				$lv_prm = array('vewfldflt' =>($lo_post['delcod']!=''?
																					'[~fltrow~]t.delcod'.chr(9).'='.chr(9).chr(9).$lo_post['delcod'].chr(9).chr(9).
																					'[~fltrow~]t.spccod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																					'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
																			:($lo_post['spccod']!=''?
																					'[~fltrow~]t.delcod'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																					'[~fltrow~]t.spccod'.chr(9).'='.chr(9).chr(9).$lo_post['spccod'].chr(9).chr(9).
																					'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9)
																			:($lo_post['prscod']!=''?
																					'[~fltrow~]t.delcod'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																					'[~fltrow~]t.spccod'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																					'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).$lo_post['prscod'].chr(9).chr(9)
																			:''))).
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => ' d.deltxt, s.spctxt, p.prstxt, t.tmeday '
												);		
				$lo_rs = $lo_tmemdl->getList( $lv_prm );
				$this->lo_mdl->hltspctme = $lo_rs;
				
				$this->data['actcod'] = '02';
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;		
    }
  }
}
?>