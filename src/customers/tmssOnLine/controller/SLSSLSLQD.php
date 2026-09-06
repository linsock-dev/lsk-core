<?php
final class slsslslqdController extends tmssController2 {
  private $lo_mdl;
  function initialize(){$this->CONTROLLER='slsslslqd';$this->MODEL='slsslslqd'; $this->VIEW='slsslslqd'; $this->ID='slsslslqdcod';$this->enable_sysdoccls=true;}

  function beforeCreate(){ $this->prm['prgcod']= 'SLQ'; }

 	function additionalFunctions($lp_act){

    $this->lo_mdl = $this->co_reg->load->model('slsslslqd');
    $post = $this->co_reg->request->post;

    switch ($lp_act) {
      
        // carga del detalle de servicios (crear / editar / ver)
        case '#11': case '#12': case '#13':
          $slsslslqdcod = $post['slsslslqdcod'] ?? null;
          // MODO VER 
          if ($lp_act=='#13' && !empty($slsslslqdcod)) {
            $this->lo_mdl->opnsrv = $this->lo_mdl->getDetailById($slsslslqdcod);
          }
          // MODO CREAR / EDITAR 
          else {
            $prm = [
              'slsslslqdcod'    => $slsslslqdcod,
              'cuscod'          => $post['cuscod'] ?? '',
              'slsslslqdstrdte' => $post['slsslslqdstrdte'] ?? '',
              'slsslslqdenddte' => $post['slsslslqdenddte'] ?? '',
              'sysdocclscod'    => $post['sysdocclscod'] ?? ''
            ];
         	$lv_savedDetail = [];
					// obtiene los insumos ya guardados del documento
          if (($lp_act=='#11' || $lp_act=='#12') && !empty($slsslslqdcod)) {
            $lv_savedDetail = $this->lo_mdl->getDetailById($slsslslqdcod);
          }
            $this->lo_mdl->opnsrv = $this->lo_mdl->getOpenServices([], $prm);
          }
          $this->lo_mdl->docsts = $post['docsts'] ?? '';
          $this->data['actcod'] = ltrim($lp_act,'#');

          return $this->co_reg->document->getView(
            'slsslslqd',
            [
              'data'   => $this->lo_mdl,
              'actcod' => $this->data['actcod'],
              'savedDetail'   => $lv_savedDetail ?? []
            ]
          );
          break;

          // DATOS (open insumos)
          case '#38':
            $lo_post = $this->co_reg->request->post;
            $lv_prm = array(
                'slsslslqdcod'    => ($lo_post['slsslslqdcod'] ?? ''),
                'cuscod'          => ($lo_post['cuscod'] ?? ''),
                'slsslslqdstrdte' => ($lo_post['slsslslqdstrdte'] ?? ''),
                'slsslslqdenddte' => ($lo_post['slsslslqdenddte'] ?? ''),
                'sysdocclscod'    => ($lo_post['sysdocclscod'] ?? ''),
              	'refdoccls' 			=> ($lo_post['refdoccls'] ?? '')
            );
            $lv_flt = array(
                'vewfldflt' => ($lo_post['vewfldflt'] ?? '')
            );
            $lo_data = $this->lo_mdl->getOpenServices($lv_flt, $lv_prm);
            return $this->co_reg->document->getJson(array('data' => $lo_data));
        break;
      }
  }
}
?>