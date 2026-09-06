<?php
final class slsdshController extends tmssController {
	const CONTROLLER = '';
	const MODEL = '';
	const VIEW  = '';
	const ID = '';
	const OBJTYP = 'SLS';
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
		//$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			
			//   D A S H B O A R D
      case '#dsh':
        $lo_post = $this->co_reg->request->post;
        $lo_ret =array();
/*
        // PREFERENCIAS. grabar
        $lo_usrprfmdl = $this->co_reg->load->model('syssecusrprf');
        if(isset($lp_prm['sve'])){
          if(isset($lo_post['usrcod'])){
            $lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'CRM_DSH','usrprfkey'=>'USRCOD','usrprfval'=>$lo_post['usrcod'],'docsts'=>'A');
            $lo_usrprfmdl->save( $lv_dat );
            $lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'CRM_KAN','usrprfkey'=>'USRCOD','usrprfval'=>$lo_post['usrcod'],'docsts'=>'A');
            $lo_usrprfmdl->save( $lv_dat );
          }
          if(isset($lo_post['strdte'])){
            $lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'CRM_DSH','usrprfkey'=>'STRDTE','usrprfval'=>$lo_post['strdte'],'docsts'=>'A');
            $lo_usrprfmdl->save( $lv_dat );
          }
        }

        // PREFERENCIAS. se recuperan las preferencias de usuario
        $lv_usrcod = $this->co_reg->sec->usrcod;
        $lv_strdte = '30';
        $lv_prm=array('vewfldflt'=>	'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9)
                                    .'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9). 'CRM_DSH' .chr(9).chr(9)
                                    .'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
                      );
        $lo_usrprfarr = $lo_usrprfmdl->getList( $lv_prm );
        foreach($lo_usrprfarr as $lv_row){
          if($lv_row['usrprfkey']=='USRCOD' && trim($lv_row['usrprfval'])!=''){ $lv_usrcod = trim($lv_row['usrprfval']); }
          if($lv_row['usrprfkey']=='STRDTE' && trim($lv_row['usrprfval'])!=''){ $lv_strdte = trim($lv_row['usrprfval']); }
        }
        $lo_ret['cfg']=array('usrcod'=>$lv_usrcod,'strdte'=>$lv_strdte);

        // CONTACTOS ASIGNADOS. obtiene total de contactos asignados
        $lo_cntmdl=$this->co_reg->load->model('crmcnt');//obtiene el modelo de contactos
        $lv_prm=array('vewfldflt'=>	'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                    .'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
                                    .'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9). $lv_usrcod .chr(9).chr(9)
                      ,'vewfldgrp'    =>'c.docsts'
                      ,'vewfldgrpcal' =>'count(c.docsts) as qty');
        $lo_rs=$lo_cntmdl->getList($lv_prm);
        $lo_ret['qty']=(count($lo_rs)==0?0:$lo_rs[0]['qty']);

        // ESTADOS. obtiene contactos por estado
        $lv_prm=array('vewfldflt'   => '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      .'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
                                      .($lv_usrcod!=''?'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9).$lv_usrcod.chr(9).chr(9):'')
                                      .'[~fltrow~]c.ctedte>=DATEADD(DAY,'.(intval($lv_strdte)*-1).',GETDATE())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
                     ,'vewfldgrp'   => 'c.crmcntstscod, s.crmcntststxt'
                     ,'vewfldgrpcal'=> 'count(c.crmcntstscod) as crmcntstsqty');
        $lo_rs=$lo_cntmdl->getList($lv_prm);
        $lo_ret['sts'] = $lo_rs;

        // TIPO. obtiene contactos por tipo
        $lv_prm=array('vewfldflt'   => '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      .'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
                                      .($lv_usrcod!=''?'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9).$lv_usrcod.chr(9).chr(9):'')
                                      .'[~fltrow~]c.ctedte>=DATEADD(DAY,'.(intval($lv_strdte)*-1).',GETDATE())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
                     ,'vewfldgrp'    => 'c.crmcnttypcod, t.crmcnttyptxt'
                     ,'vewfldgrpcal' => 'count(c.crmcnttypcod) as crmcnttypqty');
        $lo_rs=$lo_cntmdl->getList($lv_prm);
        $lo_ret['typ'] = $lo_rs;

        // SOLICITANTE. obtiene contactos por cliente
        $lv_prm=array('vewfldflt'    =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      .'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
                                      .($lv_usrcod!=''?'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9).$lv_usrcod.chr(9).chr(9):'')
                                      .'[~fltrow~]c.ctedte>=DATEADD(DAY,'.(intval($lv_strdte)*-1).',GETDATE())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9)
                     ,'vewfldgrp'    =>'a.adrnme001'
                     ,'vewfldgrpcal' =>'count(a.adrnme001) as adrnme001qty');
        $lo_rs=$lo_cntmdl->getList($lv_prm);
        $lo_ret['cus']=$lo_rs;

        // ULTIMOS CARGADOS. obtiene ultimos 5 contactos cargados
        // preparo filtros establecidos por usuario
        $lo_fltcrm=array();
        if( (isset($lo_post['vewflt'])?$lo_post['vewflt']:'')!='' ){
          $lv_fltarr=array();
          $lv_fltarr=json_decode(htmlspecialchars_decode($lo_post['vewflt']));
          if($lv_fltarr->maxrec!=''){$this->lo_mdl->vewmaxrec=$lv_fltarr->maxrec;}
          if($lv_fltarr!=null){
            if($lv_fltarr->fltqty>0){
              $this->lo_mdl->vewflt = $lv_fltarr->fltstr;
              $lo_flt=explode('[~fltrow~]',$lv_fltarr->fltstr);
              foreach($lo_flt as $lv_val){
                $lv_fld=explode(chr(9),$lv_val);
                switch($lv_fld[0]){
                  case 'c.crmcntcod':
                    array_push($lo_fltcrm,$lv_val);
                    break;
                  case 't.crmcnttyptxt':
                    array_push($lo_fltcrm,$lv_val);
                    break;
                  case 'p.crmcntprttxt':
                    array_push($lo_fltcrm,$lv_val);
                    break;
                  case 'c.crmcnttxt':
                    array_push($lo_fltcrm,$lv_val);
                    break;
                  case 'm.crmcntmtvtxt':
                    array_push($lo_fltcrm,$lv_val);
                    break;
                }
              }
            }
          }
        }
        $lv_prm=array('vewfldflt'    =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      .'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
                                      .'[~fltrow~]'.implode('[~fltrow~]',$lo_fltcrm)
                                      .($lv_usrcod!=''?'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9).$lv_usrcod.chr(9).chr(9):''),
                      'vewmaxrec'		=> '4',
                      'vewfldord'		=> 'c.ctedte desc');
        $lo_rs=$lo_cntmdl->getList($lv_prm);
        $lo_ret['load'] = $lo_rs;
*/

				if( (isset($lo_post['chttyp'])?$lo_post['chttyp']:'')!='' ){
				
					// ULTIMOS CERRADOS. obtiene ultimos 5 contactos cerrados
					$lv_prm=array('vewfldflt'    =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				.'[~fltrow~]ISNULL(c.delusr,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9)
																				.'[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'ON'.chr(9).chr(9)
																				.($lv_usrcod!=''?'[~fltrow~]c.usrcod'.chr(9).'='.chr(9).chr(9).$lv_usrcod.chr(9).chr(9):''),
												'vewmaxrec'		=> '4',
												'vewfldord'		=> 'c.upddte desc');
					$lo_rs=$lo_cntmdl->getList($lv_prm);
					
					return $this->co_reg->document->getJson( array('data'=>$lo_rs) );

				} else {
					return $this->co_reg->document->getView('slsdsh', array('data'=>array(), 'actcod'=>$this->data['actcod']));
				}
        break;
			
    }
  }
		
}
?>