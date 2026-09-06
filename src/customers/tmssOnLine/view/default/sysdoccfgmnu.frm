<div class="container">

  <ul class="nav nav-pills nav-stacked nav-tree" id="myTree" data-toggle="nav-tree">
    <?php
      // recursiva para mostrar menú
      function armar_menu( $lp_mnu = array() ) {
        $lv_buffer = '';
        foreach( $lp_mnu as $lv_row ) {              
          // carpeta
          if ( $lv_row['prgtypcod']==0 || $lv_row['prgtypcod']==3 ) {
            $lv_buffer .= '<li id="'.$lv_row['prgcod'].'"><a href="#">'.($lv_row['prgpic']==''?'':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">').' '.$lv_row['prgtxt'].'</a><ul class="nav nav-pills nav-stacked nav-tree">';
            $lv_buffer .= armar_menu( $lv_row['mnulst'] );
            $lv_buffer .= '</ul></li>';
          // separador
          } else if ( $lv_row['prgtypcod']==2 ) {
            //$lv_buffer .= '<li class="divider" id="'.$lv_row['prgcod'].'"></li>';
          // programa
          } else if ( $lv_row['prgtypcod']==1 ) {
            $lv_buffer .= '<li><a href="#" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].chr(39).',{tab_title:'.chr(39).$lv_row['prgtxt'].chr(39).', url_data: {vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}});">'.($lv_row['prgpic']==''?'':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">').' '.$lv_row['prgtxt'].'</a></li>';
          }
        }
        return $lv_buffer;
      }
      echo armar_menu( $vew_mnu );
    ?>
  </ul>

</div> <!-- containter -->