<?php
final class cnssteController extends tmssController {
	const CONTROLLER = 'cnsste';
  const MODEL = 'cnsste';
	const VIEW  = 'cnsste';
	const ID = 'stecod';
	const OBJTYP = 'CNS_STE';
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
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save( $lo_post ) ) {
					$this->lo_mdl->load( array(	'stecod'=>$this->lo_mdl->stecod	) );
					
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}					
					
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;
			
			
      // NEW. devuelve vista en modo creación               
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$lv_mdlcod = explode('_',self::OBJTYP)[0];
				$lv_prgcod = explode('_',self::OBJTYP)[1];
				
				// obtengo clase de documento
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). self::OBJTYP .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
						
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':									
				$lv_key = array();
				
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );
				
				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );

				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );

				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->stecod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				} 
				
				// obtengo toda la info de la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}
				
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra un documento
      case '#04':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->delete($lo_post);
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// GETLIST by TEXT. devuelve lista de documentos segun texto
      case '#17': case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['stetxt'])?'[~fltrow~]s.stetxt'.chr(9).''.chr(9).$lp_prm['stetxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
      
      case '#reporteStock':
				$lo_post = $this->co_reg->request->post;
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

        $lv_ret = [];
        $lv_vewfldflt = ($lo_post['vewfldflt']??'');
        $lv_vewmaxrec = ($lo_post['vewmaxrec']??'');
        
        $lo_vewfldfltcnsste = '';
				$lo_vewfldfltmatstk = '';

				// separar los filtros
        if (!empty($lv_vewfldflt)) {
          $lv_vewfldfltarr = array_filter(explode('[~fltrow~]', $lv_vewfldflt));
          $lv_cnsstearr = [];
          $lv_matstkarr = [];
          // Recorre cada filtro
          foreach ($lv_vewfldfltarr as $lv_vewfldfltrow) {
            $lv_vewfldfltrow = ltrim($lv_vewfldfltrow);
            $lv_cnsste = explode("\t", $lv_vewfldfltrow)[0];
            if (strpos($lv_cnsste, 's.') === 0 || strpos($lv_cnsste, 's.cnssteatr') !== false) {
              $lv_cnsstearr[] = '[~fltrow~]' . $lv_vewfldfltrow;
            } else {
              $lv_matstkarr[] = '[~fltrow~]' . $lv_vewfldfltrow;
            }
          }
          $lo_vewfldfltcnsste = implode('', $lv_cnsstearr);
          $lo_vewfldfltmatstk = implode('', $lv_matstkarr);
        }
        
        // recupero obras
        $lv_cnssteprm = [
            'vewfldflt' => '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                            $lo_vewfldfltcnsste,
            'vewfldord' => ''
        ];
        $lo_cnsstelst = $this->lo_mdl->getList($lv_cnssteprm, null, null, false);
        
        // recupero stock
        $lo_matstkmdl = $this->co_reg->load->model('stkmatstk');
        $lo_vewfldfltmatstk= str_replace('matcod', 's.matcod', $lo_vewfldfltmatstk);
        $lo_vewfldfltmatstk= str_replace('s.matcodext', 'm.matcodext', $lo_vewfldfltmatstk);
        $lo_vewfldfltmatstk= str_replace('matuntcod', 's.matuntcod', $lo_vewfldfltmatstk);
        $lv_matstkprm = [
            'vewfldflt' => '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
          								 '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
          									$lo_vewfldfltmatstk,
            'vewfldord' => ''
        ];
        $lo_matstklst = $lo_matstkmdl->getList($lv_matstkprm);

        // unir obras por stetxt
        $lv_cnsstelst = [];
        foreach ($lo_cnsstelst as $lo_cnssterow) {
          if (!empty($lo_cnssterow['stetxt'])) {
            $lv_cnsstelst[$lo_cnssterow['stetxt']] = $lo_cnssterow;
          }
        }
        foreach ($lo_matstklst as $i => $lo_matstkrow) {
          if ($lv_vewmaxrec > 0 && count($lv_ret) >= $lv_vewmaxrec) break;
          $lo_adrnme001 = $lo_matstkrow['adrnme001'];
          if (!empty($lo_adrnme001) && isset($lv_cnsstelst[$lo_adrnme001])) {
            $lv_ret[] = array_merge($lv_cnsstelst[$lo_adrnme001], $lo_matstkrow);
          }
        }

        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret;
        break;
    }
  }
}
?>