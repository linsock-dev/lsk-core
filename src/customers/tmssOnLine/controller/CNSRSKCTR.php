 <?php 
final class cnsrskctrController extends tmssController2 {
	function initialize(){ $this->MODEL='cnsrskctr'; $this->VIEW='cnsrskctr'; $this->ID='cnsrskctrcod'; }
  function additionalFunctions($lp_act){
    switch($lp_act){

      // AUTOCOMPLETE by TEXT 
       case '#17':
        $this->lo_mdl = $this->co_reg->load->model($this->MODEL);

        // si no viene tipo, por defecto se asume Riesgo (R)
        $lv_cnsrskctrtyp = isset($this->prm['cnsrskctrtyp']) ? $this->prm['cnsrskctrtyp'] : 'R';

        $lv_prm = array(
          'vewmaxrec' => '10',
          'vewfldflt' =>
            (isset($this->prm['cnsrskctrtxt'])
              ? '[~fltrow~]cnsrskctrtxt' . chr(9) . '' . chr(9) . $this->prm['cnsrskctrtxt'] . chr(9) . chr(9) . chr(9)
              : '') .
            '[~fltrow~]docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9) .
            '[~fltrow~]cnsrskctrtyp' . chr(9) . '=' . chr(9) . chr(9) . $lv_cnsrskctrtyp . chr(9) . chr(9)
        );
        // obtiene los registros y devuelve en formato JSON
        $lo_data = $this->lo_mdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson($lo_data);
        break;
    }
  }  
}
?>