<div class="container">
  
  <nav class="navbar navbar-default navbar-fixed-top">
    <div class="containter-fluid">
      
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#tmss-sysmnu">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="#"><?= $vew_sec->bustxt; ?></a>
      </div>

      <div class="collapse navbar-collapse" id="tmss-sysmnu" style="padding-right: 24px; padding-left: 16px;">

        <ul class="nav navbar-nav">
          <?php
            // recursiva para mostrar menú
            function armar_menu( $lp_mnu = array() ) {
              $lv_buffer = '';
              foreach( $lp_mnu as $lv_row ) {              
                // carpeta
                if ( $lv_row['prgtypcod']==0 || $lv_row['prgtypcod']==3 ) {
                  $lv_buffer .= '<li class="dropdown" id="'.$lv_row['prgcod'].'"><a href="#">'.($lv_row['prgpic']==''?'':'<img src="../library/images/'.$lv_row['prgpic'].'" class="tmss-icon">').' '.$lv_row['prgtxt'].'</a><ul class="dropdown-menu">';
                  $lv_buffer .= armar_menu( $lv_row['mnulst'] );
                  $lv_buffer .= '</ul></li>';
                // separador
                } else if ( $lv_row['prgtypcod']==2 ) {
                  $lv_buffer .= '<li class="divider" id="'.$lv_row['prgcod'].'"></li>';
                // programa
                } else if ( $lv_row['prgtypcod']==1 ) {
                  $lv_buffer .= '<li><a href="#" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].chr(39).',{tab_title:'.chr(39).$lv_row['prgtxt'].chr(39).', url_data: {vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}});">'.($lv_row['prgpic']==''?'':'<img src="../library/images/'.$lv_row['prgpic'].'" class="tmss-icon">').' '.$lv_row['prgtxt'].'</a></li>';
                }
              }
              return $lv_buffer;
            }
            echo armar_menu( $vew_mnu );
          ?>
        </ul>

        <ul class="nav navbar-nav navbar-right">
          <li>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><?= $vew_sec->usrcod; ?> </a>
            <ul class="dropdown-menu">
              <li><a href="#" onclick="tmssLink('?prg=syssecusr&act=25',{tab_title:'Mi cuenta'});" class="tmssLink"><span class="fas fa-user"></span> <?= $vew_lang->my_account; ?></a></li>
              <li class="divider"></li>
              <li><a href="?prg=syssecusr&act=16"><span class="fas fa-exchange-alt"></span> <?= $vew_lang->change_business; ?></a></li>
              <li class="divider"></li>
              <li><a href="?prg=syssecusr&act=99"><span class="fas fa-power-off"></span> <?= $vew_lang->exit; ?></a></li>
            </ul>
          </li>

        </ul>
      </div> <!-- menu -->
    </div> <!-- containter-fluid -->
  </nav>

</div> <!-- containter -->