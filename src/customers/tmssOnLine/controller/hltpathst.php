<?php
final class hltpathstController extends tmssController {
	const MODEL = 'hltpathst';
	const VIEW  = 'hltpathst';
	const ID = 'patcod';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }

  // INDEX. Método principal
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
        $lp_prm['model'] = 'hltpat'; //self::MODEL;
        $lp_prm['controller'] = 'hltpathst';
        return $lo_vew->index( '00', $lp_prm );
        break;


      // HISTORY - vista
      case '#03':
				$lo_post = $this->co_reg->request->post;

				// cargo datos de paciente
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lv_patcod = ($lo_post['patcod'] ?? $lp_prm['patcod'] ?? '');
				if ( $lv_patcod=='' ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $lo_patmdl->load( array('patcod'=>$lv_patcod), false )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_patmdl->errtyp,'errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
				}
				$this->lo_mdl->pat = $lo_patmdl;
        
        // muestro vista
        return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
        break;
      
      
      case '#dsh':
        $lo_post = $this->co_reg->request->post;
        $lv_patcod = $lo_post['patcod'];
        $lv_intdte = new DateInterval('P7D');
        
        if( $lv_patcod=='' ){
          $lo_rs = array();

        } else {
          $lv_dtefrm = new DateTime();
          $lv_dteto = new DateTime();
          
          switch( ($lo_post['typ']??'') ){    
          	case 'crmcnt':	// CONTACTOS
              $lv_dtefrm->modify('-30 days');
              $lo_crmmdl = $this->co_reg->load->model('crmcnt');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                              							'[~fltrow~]c.crmcntsrccod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]c.crmcntreqdte'.chr(9).'>='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]c.crmcntreqdte'.chr(9).'<='.chr(9).chr(9).$lv_dteto->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewfldgrp'   => 'c.crmcntsrctyp',
                            'vewfldgrpcal'=> 'count(*) as qty'
                            );
              $lo_rs = $lo_crmmdl->getList( $lv_prm, null, null, false );
        			break;

            case 'slsord':	// RECETAS
              $lv_dtefrm->modify('-30 days');
              $lo_slsordmdl = $this->co_reg->load->model('slsord');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                                            '[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]o.slsorddte'.chr(9).'>='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]o.slsorddte'.chr(9).'<='.chr(9).chr(9).$lv_dteto->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewfldgrp'    => 'o.dstobjtyp, o.dstobjcod',
                            'vewfldgrpcal' => 'count(*) as qty'
                            );
              $lo_rs = $lo_slsordmdl->getList( $lv_prm, null, null, false);
        			break;

            case 'crepln':	// PLANES DE CUIDADO
              $lo_creplnmdl = $this->co_reg->load->model('hltpatcrepln');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]c.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]c.patcreplnstrdte'.chr(9).'<='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]c.patcreplnenddte'.chr(9).'>='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewfldgrp'   => 'c.patcod',
                            'vewfldgrpcal'=> 'count(*) as qty'
                            );
              $lo_rs = $lo_creplnmdl->getList( $lv_prm, null, null, false );
        			break;

            case 'stksou':	// CONSUMOS
              $lv_dtefrm->modify('-7 days');
              $lo_plndtemdl = $this->co_reg->load->model('stkmovdoc');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]pld.plndte'.chr(9).'>='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]pld.plndte'.chr(9).'<='.chr(9).chr(9).$lv_dteto->format('Y-m-d').chr(9).chr(9).
                                            '[~fltrow~]pld.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewfldgrp'   => 'pl.patcod',
                            'vewfldgrpcal'=> 'count(*) as qty'
                            );
              $lo_rs = $lo_plndtemdl->getList( $lv_prm, null, null, false);
              break;              
            
            case 'hltpln':	// TURNOS
              $lv_dteto->modify('+30 days');
              $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]pld.plndte'.chr(9).'>='.chr(9).chr(9).$lo_post['strdte'].chr(9).chr(9).
                                            '[~fltrow~]pld.plndte'.chr(9).'<='.chr(9).chr(9).$lo_post['enddte'].chr(9).chr(9).
                                            '[~fltrow~]pld.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          	'vewmaxrec'   => '50',
                            'vewfldord' 	=> 'pld.plndte'
                            //'vewfldgrp'   => 'pl.patcod',
                            //'vewfldgrpcal'=> 'count(*) as qty'
                            );
              $lo_rs = $lo_plndtemdl->getList( $lv_prm, null, null );
							break;

            case 'hltevl':	// EVOLUCIONES
              $lv_dtefrm->modify('-30 days');
              $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
              $lv_prm = array('vewmaxrec'=> '50','vewfldord'=> ' e.evldte desc ');
              $lv_prm['vewfldflt'] ='[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                    (($lo_post['spccodtxt']??'')!=''?'[~fltrow~]s.spccod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(',',chr(10),$lo_post['spccodtxt']).chr(9).chr(9) :'').
                                    (($lo_post['prscod']??'')!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lo_post['prscod'].chr(9).chr(9) :'').
                										'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
              
              if(($lo_post['ythmthtxt']??'')!='' || ($lo_post['ythtxt']??'')!=''){
                $lv_ythmtharr = explode(',', $lo_post['ythmthtxt']??'');
                if(($lo_post['ythtxt']??'')!=''){
                  $lv_ytharr = explode(',', $lo_post['ythtxt']);
                  $lv_tmp = array_filter($lv_ythmtharr, function($lp_row) use ($lv_ytharr) {
                    $lv_yth = explode('-', $lp_row)[0];
                    return !in_array($lv_yth, $lv_ytharr);
                	});  
                  $lv_ythmtharr=$lv_tmp;
                }
                $lv_ythmth=implode(',',$lv_ythmtharr);
                
                $lv_prm['vewfldflt'] .=(($lo_post['ythtxt']??'')!=''?'[~fltrow~]YEAR(e.evldte)'.chr(9).'IN'.chr(9).chr(9).str_ireplace(',',chr(10),$lo_post['ythtxt']).chr(9).chr(9) :'').
                                    (($lv_ythmth!='')?'[~fltrow~]FORMAT(e.evldte, ^yyyy-MM^ )'.chr(9).'IN'.chr(9).chr(9).str_ireplace(',',chr(10),$lv_ythmth).chr(9).chr(9) :'');                
              }else if(($lo_post['evldte']??'')!=''){
              $lv_prm['vewfldflt'] .= '[~fltrow~]e.evldte'.chr(9).'='.chr(9).chr(9).DateTime::createFromFormat('d/m/Y', $lo_post['evldte'])->format('Y-m-d').chr(9).chr(9);
                
              }else if(($lo_post['spccodtxt']??'')=='' &&  ($lo_post['prscod']??'')==''){
                $lv_prm['vewfldflt'] ='[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                              '[~fltrow~]e.evldte'.chr(9).'>='.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).chr(9).
                                              '[~fltrow~]e.evldte'.chr(9).'<='.chr(9).chr(9).$lv_dteto->format('Y-m-d').chr(9).chr(9).  							
                                              '[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
              }
              $lo_rs = $lo_evlmdl->getList( $lv_prm, null, null, false );
              break;
              
						case 'hltevlflt':	// FILTRO EVOLUCIONES
              $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                            '[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                            'vewmaxrec'=> '100',
                            'vewfldord'=> ' e.evldte desc '
                            );
              $lo_rs = $lo_evlmdl->getList( $lv_prm, null, null, false );
              
							break;

            default:
              $lo_rs = array();
              break;
          }
        }
        return $this->co_reg->document->getJson( $lo_rs );
        break;
      
      
      case '#08':
        // detallado para paciente
        $lv_prm = array('vewfldflt' =>'[~fltrow~]h.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9),
												'vewfldord' => 'h.ctedte desc',
												'vewmaxrec' =>'50'
												);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
        
        break;
    }
  }

}
?>