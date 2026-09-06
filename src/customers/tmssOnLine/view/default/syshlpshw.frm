<?php
	$lv_sec = $vew_token;
?>
<section id="<?= $lv_sec; ?>" class="body">

<div class="container-fluid">

	<h1>Autogestión de Usuarios</h1>
	<br>
	<p>
	A través de estas opciones es posible gestionar los accesos al sistema a través de los datos maestros.<br>
	Se disponen de las siguientes opciones:
	</p><br>
	
	<h3><span class="fas fa-link"></span> Vincular</h3>
	<p>
	Permite relacionar el email ingresado con un email de un usuario existente en el sistema.<br>
	Esta opción estará disponible solo si ya existe un usuario en el sistema con la misma cuenta de email y aún no se ha creado un acceso al sistema con el dato maestro actual.
	</p><br>

	<h3><span class="far fa-file"></span> Crear</h3>
	<p>
	Permite crear un acceso al sistema (usuario) y establecer una relación entre el dato maestro y el acceso.<br>
	Los permisos que se aplican corresponden a los configurados en los enlaces de seguridad del sistema.<br>
	Esta opción está disponible solamente si aún no se ha creado un acceso y no existe otro usuario con la misma cuenta de email.
	</p><br>

	<h3><span class="fas fa-trash-alt"></span> Borrar</h3>
	<p>
	A través de esta opción se borra el acceso al sistema y todos los vínculos existentes con otros datos maestros.<br>
	Esta opción está disponible si existe una acceso creado/vinculado al dato maestro.
	</p><br>

	<h3><span class="fas fa-unlink"></span> Desvincular</h3>
	<p>
	Permite remover la relación que existe entre el dato maestro y el usuario del sistema.<br>
	Al desvincular una cuenta, el acceso al sistema sigue activo y se deberá gestionar a través del módulo de Sistemas.<br>
	Opción disponible solo si ya existe un acceso creado/vinculado al dato maestro.
	</p><br>

	<h3><span class="fas fa-unlock"></span> Desbloquear</h3>
	<p>
	Permite desbloquear un acceso al sistema que fue bloqueado por reiterados intentos fallidos de acceso.<br>
	Esta opción está disponible solo si el usuario se encuentra bloqueado.
	</p><br>

	<h3><span class="fas fa-envelope"></span> Enviar Información</h3>
	<p>
	Envía información de acceso al sistema a la cuenta de email registrada.<br>
	Esta opción solo esta disponible si ya existe un acceso creado/vinculado al dato maestro. 
	</p><br>
	
</div>
	
	
    <style type="text/css">
      div, p, a, li, td { -webkit-text-size-adjust: none; }
      .body { width: 100%; height: 100%; background: #ffffff !important; margin: 0; padding: 0; -webkit-font-smoothing: antialiased !important; -moz-osx-font-smoothing: grayscale; font-family:  Helvetica, Arial, sans-serif !important; }
      .header { background-color: #1570A6; height: 70px; width: 100%; padding-top: 10px; padding-bottom: 10px; text-align: center; font-weight: bold; color: #FFFFFF; font-size: 36px; line-height: 43px; }
      .content { width: 100%; }
      .footer { background-color: #f1f1f3; height: 110px; width: 100%; padding-top: 10px; padding-bottom: 10px; color: #7b808f; font-size: 13px; line-height: 26px; text-align: center; }
      .footer a { color: #7b808f; text-decoration: underline; }
      .title1 { font-weight: bold; font-size: 36px; line-height: 43px; padding: 20px; }
      .title2 { font-weight: bold; font-size: 23px; line-height: 33px; padding: 10px; margin: 10px; width: 450px; text-align: left; }
      .title3 { font-weight: normal; font-size: 18px; line-height: 27px; padding: 10px; margin: 10px; width: 450px; text-align: left; }
      .title4 { padding: 20px; } 
      .button_td { height: 44px; FONT-WEIGHT: bold; BACKGROUND-COLOR: #f77d0e; border-radius: 3px; }
      .button_link { FONT-SIZE: 18px; TEXT-DECORATION: none; WIDTH: 100%; COLOR: #ffffff; DISPLAY: block; LINE-HEIGHT: 44px; }
    </style>

    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
      <tr><td class="footer">
        &copy; 2016 Temasis. Todos los derechos reservados.<br>
        Pujol 1275, C1416CIC Ciudad Aut&oacute;noma de Buenos Aires, Argentina<br>
        <a href="https://www.temasis.com.ar/documentos/politica_privacidad.html">Pol&iacute;tica de Privacidad</a> | <a href="https://www.temasis.com.ar/documentos/terminos_condiciones.html">T&eacute;rminos y Condiciones</a> | <a href="mailto:soporte@temasis.com.ar">soporte@temasis.com.ar</a><br>
      </td></tr>
    </table>
		
</section>