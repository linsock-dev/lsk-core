<?php

/* obtengo la cantidad total de registros (sin las sentencias SQL) */
if ( !isset($vew_data['length']) ) {
	$vew_data['length'] = sizeof($vew_data) - (isset($vew_data['data_sqlprm'])?1:0) - (isset($vew_data['data_sqltxt'])?1:0);
}

/* convierto cadenas a UTF8 */
$lv_data = array();
foreach( $vew_data as $lv_rowkey => $lv_row ) {
	if ( $lv_rowkey!='data_sqlprm' && $lv_rowkey!='data_sqltxt' && $lv_rowkey!='length') {
		foreach( $lv_row as $lv_key => &$lv_val ) {
			if ( is_string($lv_val) ) {
				$lv_val = utf8_encode( $lv_val );
			}
		}
	}
	$lv_data[] = $lv_row;
}

/* convierto a JSON */
$lv_sdat = json_encode( array('data'=>$lv_data) );

/* verifico si hubo errores */
if ( $lv_sdat==false ) {
	echo 'ERROR: se produjo un error al convertir a JSON.['.json_last_error().']<br>';
	switch (json_last_error()) {
		case JSON_ERROR_NONE: echo 'No ocurrió ningún error.<br>'; break;
		case JSON_ERROR_DEPTH: echo 'Se ha excedido la profundidad máxima de la pila.<br>'; break;
		case JSON_ERROR_STATE_MISMATCH: echo 'JSON con formato incorrecto o inválido.<br>'; break;
		case JSON_ERROR_CTRL_CHAR: echo 'Error del carácter de control, posiblemente se ha codificado de forma incorrecta.<br>'; break;
		case JSON_ERROR_SYNTAX: echo 'Error de sintaxis.<br>'; break;
		case JSON_ERROR_UTF8: echo 'Caracteres UTF-8 mal formados, posiblemente codificados de forma incorrecta.<br>'; break;
		case JSON_ERROR_RECURSION: echo 'Una o más referencias recursivas en el valor a codificar.<br>'; break;
		case JSON_ERROR_INF_OR_NAN: echo 'Uno o más valores NAN o INF en el valor a codificar.<br>'; break;
		case JSON_ERROR_UNSUPPORTED_TYPE: echo 'Se proporcionó un valor de un tipo que no se puede codificar.<br>'; break;
	}
	var_dump( $lv_data );
} else {
	echo $lv_sdat;
}
?>