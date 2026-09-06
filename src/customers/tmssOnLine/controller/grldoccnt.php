<?php
final class grldoccntController extends tmssController {
  const CONTROLLER = 'grldoccnt';
	const MODEL = 'grldoccnt';
	const VIEW  = 'grldoccnt';
	const ID = 'grldoccntcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	private $data_list = array();
  
  function __construct(&$lp_reg) {$this->co_reg = $lp_reg;}
  
	
  //INDEX. metodo principal
  public function index( $lp_act , $lp_prm=array() ) {
		
    // all methods of this class are available for logged users check user session
    $lo_post = $this->co_reg->request->post;
		$lo_post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		$this->data['srcobjtyp'] = (isset($lp_prm['srcobjtyp'])?$lp_prm['srcobjtyp']: (isset($lo_post['srcobjtyp'])?$lo_post['srcobjtyp']:'') );
		$this->data['srcobjcod'] = (isset($lp_prm['srcobjcod'])?$lp_prm['srcobjcod']: (isset($lo_post['srcobjcod'])?$lo_post['srcobjcod']:''));
		$this->data['srcobjtxt'] = (isset($lp_prm['srcobjtxt'])?$lp_prm['srcobjtxt']: (isset($lo_post['srcobjtxt'])?$lo_post['srcobjtxt']:''));
		$this->data['grldoccntobjtyp'] = (isset($lp_prm['grldoccntobjtyp'])?$lp_prm['grldoccntobjtyp']:(isset($lo_post['grldoccntobjtyp'])?$lo_post['grldoccntobjtyp']:''));
		$this->data['grldoccntobjcod'] = (isset($lp_prm['grldoccntobjcod'])?$lp_prm['grldoccntobjcod']:(isset($lo_post['grldoccntobjcod'])?$lo_post['grldoccntobjcod']:''));
		$this->data['grldoccntobjtxt'] = (isset($lp_prm['grldoccntobjtxt'])?$lp_prm['grldoccntobjtxt']:(isset($lo_post['grldoccntobjtxt'])?$lo_post['grldoccntobjtxt']:''));
		$this->data['bcksec'] = (isset($lp_prm['bcksec'])?$lp_prm['bcksec']:(isset($lo_post['bcksec'])?$lo_post['bcksec']:''));
		$this->data['onetme'] = (isset($lp_prm['onetme'])?$lp_prm['onetme']:(isset($lo_post['onetme'])?$lo_post['onetme']:''));
		$this->data['fndtxt'] = (isset($lp_prm['fndtxt'])?$lp_prm['fndtxt']:(isset($lo_post['fndtxt'])?$lo_post['fndtxt']:''));
		$this->data['grldoccntfrm'] = (isset($lp_prm['grldoccntfrm'])?$lp_prm['grldoccntfrm']:(isset($lo_post['grldoccntfrm'])?$lo_post['grldoccntfrm']:''));
		$this->data['readonly'] = (isset($lp_prm['readonly'])?$lp_prm['readonly']:(isset($lo_post['readonly'])?$lo_post['readonly']:''));
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// LIST. devuelve el formulario con lista de contactos (lista formulario)
      case '#': case '#08':
				$lv_flt = array('vewfldflt' => ($this->data['fndtxt']==''?'':'[~fltrow~]dc.grldoccntobjtxt'.chr(9).''.chr(9).$this->data['fndtxt'].chr(9).chr(9).chr(9)) );
        $lv_prm = array('srcobjtyp'=>$this->data['srcobjtyp'], 'srcobjcod'=>$this->data['srcobjcod'], 'grldoccntobjtyp'=>$this->data['grldoccntobjtyp'], 'grldoccntobjcod'=>$this->data['grldoccntobjcod']);
				$lv_arr_dat = $this->lo_mdl->getList( $lv_flt, $lv_prm );
        return $this->co_reg->document->getJson( array('data'=>$this->data,'list'=>$lv_arr_dat,'actcod'=>$this->data['actcod'] ) );
        break;
			
			
			// LIST. devuelve la grilla con lista de contactos (lista estandard)
      case '#09':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        $lp_prm['actcod'] = '09';
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
        $lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->save($lo_post) ) {
          if($lo_post['svemst']=='X'){
            $lo_post['grldoccntcod'] = $this->lo_mdl->grldoccntcod;
            $lo_post['cntcod']= $this->co_reg->document->getTagValue( $this->lo_mdl->grldoccntatr, 'mstcntcod' );
            $lo_post['cnttxt']=$lo_post['grldoccntobjtxt'];
            $lo_post['cntsrctyp']=$lo_post['grldoccntobjtyp'];
            $lo_post['cntsrccod']=$lo_post['grldoccntobjcod'];
            
            $lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
            if( !$lo_datcntmdl->save($lo_post, false) ){
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_datcntmdl->errtyp,'errcod'=>$lo_datcntmdl->errcod,'errtxt'=>$lo_datcntmdl->errtxt) );
            }
                        
            $lo_post['mstcntcod'] = $lo_datcntmdl->cntcod;
            if( !$this->lo_mdl->save($lo_post) ){
              return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
            }
          }
          
					$this->lo_mdl->load( array(self::ID=>$this->lo_mdl->grldoccntcod	) );
          // cargo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscodcnt']) ) ) {
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          }
					$this->lo_mdl->grldoccntfrm = (isset($this->data['grldoccntfrm']) ? $this->data['grldoccntfrm'] : '' );
          $this->lo_mdl->pos = (isset($this->data['pos']) ? $this->data['pos'] : '' );
          $this->lo_mdl->srcobjtyp = $this->data['srcobjtyp'];
          $this->lo_mdl->srcobjcod = $this->data['srcobjcod'];
          $this->lo_mdl->grldoccntobjtyp = $this->data['grldoccntobjtyp'];
          $this->lo_mdl->grldoccntobjcod = $this->data['grldoccntobjcod'];
          $this->lo_mdl->bcksec = $this->data['bcksec'];
          $this->lo_mdl->fndtxt = $this->data['fndtxt'];
          $this->lo_mdl->readonly = $this->data['readonly'];
          $this->lo_mdl->sysdocclscod = (isset($lp_prm['sysdocclscod']) ? $lp_prm['sysdocclscod'] : (isset($lo_post['sysdocclscod']) ? $lo_post['sysdocclscod'] : ''));
        
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );

        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;

			
      // NEW. devuelve la vista en modo creación
      case '#01':
        $lo_post = $this->co_reg->request->post;
				$this->lo_mdl->create();
				$this->lo_mdl->srcobjtyp = $this->data['srcobjtyp'];
        $this->lo_mdl->srcobjcod = $this->data['srcobjcod'];
        $this->lo_mdl->srcobjtxt = $this->data['srcobjtxt'];
        $this->lo_mdl->grldoccntobjtyp = $this->data['grldoccntobjtyp'];
        $this->lo_mdl->grldoccntobjcod = $this->data['grldoccntobjcod'];
				$this->lo_mdl->bcksec = $this->data['bcksec'];
				$this->lo_mdl->onetme = $this->data['onetme'];
				$this->lo_mdl->fndtxt = $this->data['fndtxt'];
        $this->lo_mdl->readonly = $this->data['readonly'];
        $this->lo_mdl->sysdocclscod = (isset($lp_prm['srcdocclscod']) ? $lp_prm['srcdocclscod'] : '');
        
        if (isset($lp_prm['srcdocclscod']) || isset($lo_post['srcdocclscod'])){
          
          // se recuperan todas las clases de documento de contacto que tenga la clase de documento de cabecera
          $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
          $lv_prm=array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). (isset($lp_prm['sysdocclscod']) ? $lp_prm['sysdocclscod'] : '') .chr(9).chr(9).
                                      '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
          );
          $lo_rscnt = $lo_sysdocclscntmdl->getList( $lv_prm );
          
          // armo el filtro con las clases de documento que se recuperaron
          $lo_docclsflt = array();
          foreach ($lo_rscnt as $lv_row) {
            array_push($lo_docclsflt,$lv_row['sysdocclscodcnt']);
          }
          
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = isset($lo_post['sysdocclscod']) ? $lo_post['sysdocclscod'] : (isset($lp_prm['srcdocclscod']) ? $lp_prm['srcdocclscod'] : '');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). 'GRL_CCT' .chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                            							'[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_docclsflt) .chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_srcobjtyp='.$this->lo_mdl->srcobjtyp.'&prm_srcobjcod='.$this->lo_mdl->srcobjcod.'&prm_grldoccntobjtyp='.$this->lo_mdl->grldoccntobjtyp.'&prm_grldoccntobjcod='.$this->lo_mdl->grldoccntobjcod.'&prm_srcobjtxt='.$this->lo_mdl->srcobjtxt.'&prm_bcksec='.$this->lo_mdl->bcksec.'&prm_readonly='.$this->lo_mdl->readonly.'&prm_onetme='.$this->lo_mdl->onetme,'doccls'=>$lv_docclsarr) );
            }
          }
         	if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $this->lo_mdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          
          // TODAS LAS CLASES. devuelvo el recordset completo de las clases de documento de los interlocutores y un indicador con las clases separadas por ;
          if($lv_docclscod=='-1'){
            $this->lo_mdl->sysdoccls = $lo_rscnt;
            $this->lo_mdl->multiplecls = implode(';',$lo_docclsflt);
          }
          /* ------------------------------------------------ */
          
          
        }else{
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-900','errtxt'=>'No se pudo recuperar la clase de dcoumento de cabecera.') );
        }
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve la vista en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
        if(isset($lo_post['grldoccntfrm'])){$this->data['grldoccntfrm'] = $lo_post['grldoccntfrm'];}
        if(isset($lo_post['pos'])){$this->data['pos'] = $lo_post['pos'];}
        
        // recupera el detalle de la grilla y busca si tiene código de contacto de documento
        if ($this->data['grldoccntfrm'] != '' && $this->data['grldoccntfrm'] != 'undefined'){
        	$lo_data = json_decode(html_entity_decode($this->data['grldoccntfrm']));
          $this->lo_mdl->grldoccntobjtyp = (isset($lo_data->grldoccntobjtyp) ? $lo_data->grldoccntobjtyp : '');
          $this->lo_mdl->grldoccntobjcod = (isset($lo_data->grldoccntobjcod) ? $lo_data->grldoccntobjcod : '');
          $this->lo_mdl->grldoccntobjtxt = (isset($lo_data->grldoccntobjtxt) ? $lo_data->grldoccntobjtxt : '');
          $lv_dockey = (isset($lo_data->grldoccntcod) ? $lo_data->grldoccntcod : '');
          $lv_sysdocclscodcnt = $lo_data->sysdocclscodcnt;
        }
          
        // si tiene código de contacto de documento, se carga de la base de datos
        if( (isset($lp_prm[self::ID]) && $lp_prm[self::ID] != '') || (isset($lv_dockey) && $lv_dockey!='') || isset($this->co_reg->request->post[self::ID]) ){
          $lv_sysdocclscodcnt = (isset($lv_sysdocclscodcnt) ? $lv_sysdocclscodcnt : ( isset($lp_prm['sysdocclscodcnt']) ? $lp_prm['sysdocclscodcnt'] : (isset($lo_post['sysdocclscodcnt']) ? $lo_post['sysdocclscodcnt'] : '' ) ) );
          $lv_key = array();

          // get param (KEY)																																		
          $lv_key = array( self::ID=> (isset($lv_dockey) && $lv_dockey!='' ? $lv_dockey : ( isset($lp_prm[self::ID]) && $lp_prm[self::ID] != '' ? $lp_prm[self::ID] : (isset($lo_post[self::ID]) && $lo_post[self::ID] != '' ? $lo_post[self::ID] : '' ) ) ) );
					$lv_key['grldoccntobjtyp'] = $this->data['grldoccntobjtyp'];
          
          // load object
          if ( !isset($lv_key[self::ID]) ) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
          } else if ( $this->lo_mdl->load( $lv_key )==false ) {
            return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
          } else if ( $lp_act == '#001' ) {
            $this->lo_mdl->cntcod = '';
            $this->lo_mdl->ctedte = '';
            $this->lo_mdl->cteusr = '';
            $this->lo_mdl->upddte = '';
            $this->lo_mdl->updusr = '';
          }

        // en caso de no tener código de contacto de documento, se utilizan los datos del JSON para cargar la pantalla de edición del contacto
        }else{
          $lv_sysdocclscodcnt = (isset($lv_sysdocclscodcnt) ? $lv_sysdocclscodcnt : (isset($lo_post['sysdocclscodcnt']) ? $lo_post['sysdocclscodcnt'] : (isset($lp_prm['sysdocclscodcnt']) ? $lp_prm['sysdocclscodcnt'] : '') ) );
          $this->lo_mdl->create();
          
          // se asignan los datos a las propiedades que corresponden según el modelo al que pertenecen
          foreach((array) $lo_data as $lv_key => $lv_row){
            if(substr($lv_key, 0, 3) == 'adr' || substr($lv_key, 0, 3) == 'tra' || substr($lv_key, 0, 3) == 'lnd'){
              $this->lo_mdl->adr->set($lv_key, (is_string($lv_row) ? strtoupper($lv_row) : $lv_row));
            }else if (substr($lv_key, 0, 3) == 'tax'){
              $this->lo_mdl->tax->set($lv_key, (is_string($lv_row) ? strtoupper($lv_row) : $lv_row));
            }else{
              $this->lo_mdl->set($lv_key, (is_string($lv_row) ? strtoupper($lv_row) : $lv_row));
            }
          }

          // datos adicionales
          $this->lo_mdl->grldoccntfrm = $this->data['grldoccntfrm'];
          $this->lo_mdl->pos = $this->data['pos'];
        	if(isset($lo_post['srcobjtxt'])){$this->lo_mdl->srcobjtxt = $lo_post['srcobjtxt'];}
          $this->lo_mdl->srcobjtyp = $this->data['srcobjtyp'];
          $this->lo_mdl->srcobjcod = $this->data['srcobjcod'];
          $this->lo_mdl->bcksec = $this->data['bcksec'];
          $this->lo_mdl->fndtxt = $this->data['fndtxt'];
          $this->lo_mdl->readonly = $this->data['readonly'];
          $this->lo_mdl->sysdocclscod = (isset($lp_prm['sysdocclscod']) ? $lp_prm['sysdocclscod'] : (isset($lo_post['sysdocclscod']) ? $lo_post['sysdocclscod'] : ''));
        }

        // cargo clase de documento
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_sysdocclscodcnt) ) ) {
          $this->lo_mdl->sysdoccls = $lo_docclsmdl;
        }
          
        return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );  

        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// LIST by TEXT. lista los documentos segun texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($lp_prm['cnttxt'])?'[~fltrow~]dc.grldoccntobjtxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($lp_prm['cnttxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]dc.srcobjtyp'.chr(9).'='.chr(9).chr(9).$this->data['srcobjtyp'].chr(9).chr(9).
																			'[~fltrow~]dc.srcobjcod'.chr(9).'='.chr(9).chr(9).$this->data['srcobjcod'].chr(9).chr(9).
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->lo_mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
        
      // CHOOSECNT. Devuelve una pantalla para elegir qué contacto será qué interlocutor.
      // en caso de tener un solo contacto, se asignará a todos los interlocutores y devolverá un json.
      // en caso de no tener contactos, devolverá -901
      // en caso de no tener interlocutores, devolverá -902
      case '#choosecnt':
        $lo_post = $this->co_reg->request->post;
        
        // recuperar contactos del documento de origen
        $lo_grldatcntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). $lo_post['grldoccntobjtyp'] .chr(9).chr(9).
                                      '[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9). $lo_post['grldoccntobjcod'] .chr(9).chr(9).
                                      '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
				$lo_cnt = $lo_grldatcntmdl->getList($lv_prm, null, null, false);
        
        //si no hay contactos, devuelvo -901
        if ( count($lo_cnt)==0 ) {
          $lo_cntmstmdl = $this->co_reg->load->model($lo_post['mdlcod']);
          if(!$lo_cntmstmdl->load( array($lo_post['mdlid'] => $lo_post['grldoccntobjcod']) )){
          	return $this->co_reg->document->getJson( array('errtyp'=>$lo_cntmstmdl->errtyp,'errcod'=>$lo_cntmstmdl->errcod,'errtxt'=>$lo_cntmstmdl->errtxt) );
          }
          $lo_cnt[0] = $lo_cntmstmdl->getData();
          $lo_cnt[0]['cnttxt'] = $lo_cntmstmdl->suptxt;
          if(isset($lo_cnt[0]['taxactstr'])){ $lo_cnt[0]['taxactstr'] = $lo_cnt[0]['taxactstr']->format('d/m/Y'); }
          if(isset($lo_cnt[0]['adr'])){ unset($lo_cnt[0]['adr']); }
          if(isset($lo_cnt[0]['tax'])){ unset($lo_cnt[0]['tax']); }
          if(isset($lo_cnt[0]['bnk'])){ unset($lo_cnt[0]['bnk']); }
          if(isset($lo_cnt[0]['acc'])){ unset($lo_cnt[0]['acc']); }
          //return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'-901','errtxt'=>'No hay contactos asignados al objeto de origen') );
        }
          
        // recupero interlocutores del documento
        $lo_sysdocclscntmdl = $this->co_reg->load->model('sysdocclscnt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]dcc.sysdocclscod'.chr(9).'='.chr(9).chr(9). $lo_post['sysdocclscod'] .chr(9).chr(9).
                                      '[~fltrow~]dcc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
        $lo_sysdocclscnt = $lo_sysdocclscntmdl->getList($lv_prm);

        //si no hay interlocutores, devuelvo -902
        if(count($lo_sysdocclscnt) == 0){
					return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>'-902','errtxt'=>'No hay interlocutores asignados a la clase de documento') );
        }
      	
        //si hay un solo contacto, le asigno todos los interlocutores y devuelvo un array
        if(count($lo_cnt) == 1){
          $lo_cntret = array();
          foreach($lo_sysdocclscnt as $lv_row){
            $lv_dat = $lo_cnt;
            $lv_dat[0]['sysdocclscodcnt'] = $lv_row['sysdocclscodcnt'];
            $lv_dat[0]['sysdocclstxtcnt'] = $lv_row['sysdocclstxtcnt'];
            $lo_cntret[] = $lv_dat;
          }
      		return $this->co_reg->document->getJson( $lo_cntret );    
        }
        
        // si hay muchos contactos y al menos un interlocutor, devuelvo una vista en la que seleccionar
        $this->lo_mdl->post = $lo_post;
        $this->lo_mdl->cnt = $lo_cnt;
        $this->lo_mdl->int = $lo_sysdocclscnt;
          
        // Carga la vista de selección de contactos/interlocutores
        return $this->co_reg->document->getView( 'grldoccntsel', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );  
        break;
        
		}
	}
}
?>