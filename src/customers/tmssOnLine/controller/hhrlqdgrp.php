<?php
final class hhrlqdgrpController extends tmssController {	
	const CONTROLLER = 'hhrlqdgrp';
	const MODEL = 'hhrlqdgrp';
	const VIEW  = 'hhrlqdgrp';
	const ID = 'hhrlqdgrpcod';
	const OBJ_TYP = 'HHR_LQG';
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

			// LIST
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
        $this->lo_mdl->save($lo_post);
				$lv_ret = array('hhrlqdgrpcod'=>$this->lo_mdl->hhrlqdgrpcod, 'errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt);
				return $this->co_reg->document->getJson( $lv_ret );
        break;
			
			
      // NEW
      case '#01':
				$this->lo_mdl->create();
				$lo_post = $this->co_reg->request->post;
				
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). self::OBJ_TYP .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				
        // cargo clase de documento de referencia
        $lo_docclsrefmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsrefmdl->load( array('sysdocclscod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'sysdocclscodref') ) );
        $this->lo_mdl->sysdocclsref = $lo_docclsrefmdl;
        
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve vista en modo modificación o visualización
      case '#02': case '#03':									
				$lv_key = array();
				$lo_post = $this->co_reg->request->post;
				
				// get param (KEY)																						
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
        
        // cargo clase de documento de referencia
        $lo_docclsrefmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsrefmdl->load( array('sysdocclscod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'sysdocclscodref') ) );
        $this->lo_mdl->sysdocclsref = $lo_docclsrefmdl;
        
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			
			// DELETE. borra el documento
      case '#04':
				$this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// CONTABILIZAR. contabiliza el documento
      case '#09':
        $this->lo_mdl->accounting();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp, 'errcod'=>$this->lo_mdl->errcod, 'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// OBTENER OBJETOS DE ORIGEN
			case '#getSources':
				$lo_post = $this->co_reg->request->post;
				
				// cargo clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				
				// obtengo origenes
				$lv_flt = json_decode(html_entity_decode($lo_post['vewflt']),true);
				$lv_prm = array('vewfldflt'=> '[~fltrow~]dc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																			$lv_flt['fltstr'],
												'vewmaxrec'=> $lv_flt['maxrec']);
				$lo_rs = $this->lo_mdl->getSources( $lv_prm );
				return $this->co_reg->document->getJson( array('data'=>$lo_rs) );
				break;
      
			
			// REPORTE. Liquidaciones
      case "#lqdprcrpt":
				$lo_post = $this->co_reg->request->post;
        $lo_prcmdl = $this->co_reg->load->model('grldatprc');
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lo_docclsrefmdl = $this->co_reg->load->model('sysdoccls');
    		$lv_lqd_arr = array();
        
        // cargo liquidaciones grupales
        $lv_prm = array('vewfldflt'=> $lo_post['vewfldflt'],
                        'vewmaxrec'=> $lo_post['vewmaxrec']);
        $lo_rs = $this->lo_mdl->getList($lv_prm);
        
        $i = 0;
        foreach($lo_rs as &$lv_row){
					$lv_doc = array();
          
          // buscar liquidaciones
          $lv_prm = array('vewfldflt' =>'[~fltrow~]g.hhrlqdgrpcod'.chr(9).'='.chr(9).chr(9).$lv_row['hhrlqdgrpcod'].chr(9).chr(9));
          $lv_row['hhrlqddoc'] = $this->lo_mdl->getDocuments( $lv_prm );
          
          // buscar condiciones
					foreach($lv_row['hhrlqddoc'] as $lv_rowdoc){$lv_doc[]=$lv_rowdoc['hhrlqdcod'];}
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_LQD'.chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_doc).chr(9).chr(9),
                          'vewfldord' => 'p.srcobjtyp, p.srcobjcod001, p.prcschcndrow' );
					$lv_row['hhrlqddocprc'] = $lo_prcmdl->getList( $lv_prm );
          
          // juntar datos necesarios de liquidación y las condiciones
          foreach($lv_row['hhrlqddoc'] as $lv_rowdoc){
            $lv_docatr001 = $this->co_reg->document->getTagValue($lv_rowdoc['hhrlqdatr001'],'chratr');
            $lv_oldyth = $this->co_reg->document->getTagValue($lv_docatr001,'oldyth');
            $lv_oldmth = $this->co_reg->document->getTagValue($lv_docatr001,'oldmth');
            
            $lv_lqd_arr[$i] =array('l.hhrlqdgrpcod' => $lv_row['hhrlqdgrpcod'],
																	 'hhrlqdgrpstrdtecnv' => $lv_row['hhrlqdgrpstrdtecnv'],
																	 'hhrlqdgrpenddtecnv' => $lv_row['hhrlqdgrpenddtecnv'],
																	 'l.hhrlqdcod' => $lv_rowdoc['hhrlqdcod'],
																	 'srcobjtxt' => $lv_rowdoc['srcobjtxt'],
																	 'hhrchrtyptxt' => $lv_rowdoc['hhrchrtyptxt'],
																	 'hhrchrasgcod' => $lv_rowdoc['hhrchrasgcod'],
																	 'hhrchrstrdte' => $lv_rowdoc['hhrchrstrdte'],
																	 'hhrchrenddte' => $lv_rowdoc['hhrchrenddte'],
																	 'dni' => $lv_rowdoc['taxiibb'],
																	 'seq' => $this->co_reg->document->getTagValue($lv_docatr001,'seq'),
																	 'hrs' => $this->co_reg->document->getTagValue($lv_docatr001,'hrs'),
																	 'ant' => $lv_oldyth!='' && $lv_oldmth!='' ? ($lv_oldyth<10?'0':'').$lv_oldyth.'.'.($lv_oldmth<10?'0':'').$lv_oldmth : '',
																	 'ps.prcschcod' =>$lv_row['prcschcod']
																	);
            $lv_antprc = 0;
            foreach($lv_row['hhrlqddocprc'] as $lv_rowprc){
              if($lv_rowprc['srcobjcod001'] == $lv_rowdoc['hhrlqdcod']){
                
                if($lv_rowprc['prccndcodext'] == 'ANTIGUEDAD'){
                  $lv_antprc = number_format($lv_rowprc['prccndqty'], 2);
                }
                
                $lv_lqd_arr[$i][$lv_rowprc['prccndtxt']] = number_format($lv_rowprc['prccndtot'], 2);
							}
            }
            
            $lv_lqd_arr[$i]['ant%'] = $lv_antprc;
          	$i++;
          }
        }
        unset($lv_row);
        
        return $lv_lqd_arr;
        break;
    }
  }
	
}
?>