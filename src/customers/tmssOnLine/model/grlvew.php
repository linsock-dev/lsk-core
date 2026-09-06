<?php
final class grlvew extends tmssAction {
  protected $co_reg;
	private $data = array();
	private $sysdata = array();
  private $co_hdr;
  private $co_col;
	private $co_flt;
  private $co_opr;
  private $co_dat;

  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
  // LOAD VIEW. carga una vista (cabecera y columnas)
  function loadView( $lp_id ) {
    $lo_db = $this->co_reg->db;
    $lo_sec = $this->co_reg->sec;
    
		$lo_vewmdl = $this->co_reg->load->model('sysappprgvew');
		$this->co_hdr = $lo_vewmdl->getlist( array('vewfldflt'=>'[~fltrow~]v.vewcod'.chr(9).'='.chr(9).chr(9).$lp_id.chr(9).chr(9)) );
		if( count($this->co_hdr)==0 ){
			$this->errcod=-1;
			$this->errtxt='Código de vista inválido ['.$lp_id.'].';
			$this->errtyp='E';
      return false;
    } else {
			$this->co_hdr = $this->co_hdr[0];
		}
		
		$lo_colmdl = $this->co_reg->load->model('sysappprgvewcol');
		$this->co_col = $lo_colmdl->getList( array('vewfldflt'=>'[~fltrow~]vc.vewcod'.chr(9).'='.chr(9).chr(9).$lp_id.chr(9).chr(9),'vewfldord'=>'vc.vewfldord') );
    if(count($this->co_col)==0){
			$this->errcod=-2;
			$this->errtxt='Vista ['.$lp_id.'] sin columnas definidas.';
			$this->errtyp='E';
      return false;
    }
		
    return true;
	}

  // GET HEADER. devuelve datos de cabecera de la vista
  public function getHeader() { return $this->co_hdr; }
  
  // GET COLUMNS. devuelve datos de columnas de la vista
  public function getColumns() { return $this->co_col; }
		
	// GET OPERATIONS. devuelve las operaciones disponibles para la vista
  public function getOperations( $lp_mdlcod, $lp_prgcod ) {
		
		// obtengo las operaciones suscriptas de la empresa
		$lo_sysfncsub = $this->co_reg->load->model('sysfncsub');
		$lv_prm = array('cuscodext'=>$this->co_reg->sec->buscod);
		$lv_prmopt = array('vewfldflt'=>'[~fltrow~]o.codmdl'.chr(9).'='.chr(9).chr(9).$lp_mdlcod.chr(9).chr(9).
																		'[~fltrow~]o.codprg'.chr(9).'='.chr(9).chr(9).$lp_prgcod.chr(9).chr(9) );
		$lo_rs = $lo_sysfncsub->getOperationsList($lv_prmopt,$lv_prm);
		
		// verifico permisos
		foreach( $lo_rs as $lv_row ) {
			if ( $this->co_reg->sec->hasPermission( $lv_row['mdlcod'], $lv_row['prgcod'], $lv_row['oprcod'] ) ) {
				$this->co_opr[] = $lv_row;
			}
		}
		
		return $this->co_opr;
	}
	
	// PARSE VIEW OPTIONS. convierte la sentencia de array a filtro string TSQL
	// [~fltrow~] ==> 0(campo) chr(9) 1(=/>/>=/</<=/<>/IN/NI/BT/NB/EE/NE) chr(9) 2(val) chr(9) 3(val ini '\n') chr(9) 4(val fin) chr(9) ''
  public function parseViewOptions( $lp_prm=array() ) {
		$lv_strsep = '^'; //chr(39);
		$lv_flt = '';
    $lv_arr = explode( '[~fltrow~]', (isset($lp_prm['vewfldflt'])?$lp_prm['vewfldflt']:'') );
    foreach ( $lv_arr as $lv_row ) {
      $lv_dat = explode( chr(9) , $lv_row );
      if ( count($lv_dat)==6 ) {
				
				// palabras clave dentro de los valores.
				// si comienzan con (like) o (in) entonces se actualizan los comparadores
				// esto es utilizado para los typeahead donde los valores se pasan directamentea a esta funcion
				if( substr($lv_dat[2],0,6)=='(like)' ){ $lv_dat[1]='LIKE'; $lv_dat[2]=substr($lv_dat[2],6); }
				if( substr($lv_dat[2],0,4)=='(in)' ){ $lv_dat[1]='IN'; $lv_dat[3]=str_ireplace(';',chr(13).chr(10),substr($lv_dat[2],4));}
				
				$lv_fltin = '';
        if( $lv_dat[1]=='IN' || $lv_dat[1]=='NI' ) {
          $lv_dat[3] = str_ireplace( chr(13).chr(10), chr(10), $lv_dat[3] );
          $lv_arrin = explode( chr(10) , $lv_dat[3] );
          foreach ( $lv_arrin as $lv_arrinval ) {
            $lv_fltin .= ($lv_fltin==''?'':',').$lv_strsep.
																								$lv_arrinval.	
																								$lv_strsep;
          }
        } 
        $lv_flt .= ' AND ';
				
        switch( $lv_dat[1] ) {
          case '': case 'LIKE': $lv_flt .= '('.$lv_dat[0].' LIKE '.$lv_strsep.'%'.$lv_dat[2].'%'.$lv_strsep.')'; break;
          case 'SW'  : $lv_flt .= '('.$lv_dat[0].' LIKE '.$lv_strsep.''.$lv_dat[3].'%'.$lv_strsep.')'; break;
          case 'EW'  : $lv_flt .= '('.$lv_dat[0].' LIKE '.$lv_strsep.'%'.$lv_dat[3].''.$lv_strsep.')'; break;
          //case ''  : $lv_flt .= '('.$lv_dat[0].' COLLATE Latin1_General_CI_AI LIKE '.$lv_strsep.'%'.utf8_decode($lv_dat[2]).'%'.$lv_strsep.' COLLATE Latin1_General_CI_AI )'; break;
          case 'IN': $lv_flt .= '('.$lv_dat[0].' IN ('.$lv_fltin.'))'; break;
          case 'NI': $lv_flt .= '('.$lv_dat[0].' NOT IN ('.$lv_fltin.'))'; break;
          case 'BT': $lv_flt .= '('.$lv_dat[0].' BETWEEN '.$lv_strsep.$lv_dat[3].$lv_strsep.' AND '.$lv_strsep.$lv_dat[4].$lv_strsep.')'; break;
          case 'NB': $lv_flt .= '(NOT ('.$lv_dat[0].' BETWEEN '.$lv_strsep.$lv_dat[3].$lv_strsep.' AND '.$lv_strsep.$lv_dat[4].$lv_strsep.'))'; break;
          case 'EE': $lv_flt .= '(ISNULL('.$lv_dat[0].','.$lv_strsep.$lv_strsep.')='.$lv_strsep.$lv_strsep.')'; break;
          case 'NE': $lv_flt .= '(ISNULL('.$lv_dat[0].','.$lv_strsep.$lv_strsep.')<>'.$lv_strsep.$lv_strsep.')'; break;
					case 'ZZ': $lv_flt .= '('.$lv_dat[0].$lv_dat[2].$lv_dat[3].')'; break;
					case 'EQ': $lv_flt .= '('.$lv_dat[0].'='.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
					case 'GT': $lv_flt .= '('.$lv_dat[0].'>'.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
					case 'LT': $lv_flt .= '('.$lv_dat[0].'<'.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
					case 'LE': $lv_flt .= '('.$lv_dat[0].'<='.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
					case 'GE': $lv_flt .= '('.$lv_dat[0].'>='.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
					case 'NS': $lv_flt .= '('.$lv_dat[0].'<>'.$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
          default:   $lv_flt .= '('.$lv_dat[0].$lv_dat[1].$lv_strsep.$lv_dat[3].$lv_strsep.')'; break;
        }
      }
    }
		
    // filtro del sistema
    if ($this->co_flt!='') { $lv_flt = $lv_flt . ' AND (' . $this->co_flt . ')'; }
		
		$lv_ret = '<view>'.
                '<vewflt>'.$lv_flt.'</vewflt>'.
                '<vewgrp>'.($lp_prm['vewfldgrp']??'').'</vewgrp>'.
                '<vewgrpcal>'.($lp_prm['vewfldgrpcal']??'').'</vewgrpcal>'.
                '<vewgrpcalflt>'.($lp_prm['vewfldgrpcalflt']??'').'</vewgrpcalflt>'.
                '<veword>'.($lp_prm['vewfldord']??'').'</veword>'.
                '<vewmax>'.(isset($lp_prm['vewmaxrec'])?$lp_prm['vewmaxrec']+1:'').'</vewmax>'.
                '<vewpge>'.($lp_prm['vewcurpge']??'').'</vewmax>'.
                '<extra>'.($lp_prm['extra']??'').'</extra>'.
              '</view>';
		
    return $lv_ret;
  }
}
?>