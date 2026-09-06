<?php	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<div class="container-fluid">
			<div class="center-block" style="width: 300px;">
				<div id="<?= $lv_sec; ?>_camera_result" class="hidden" name="result"></div>
				<input type="hidden" id="camera_base64">
				<canvas id="<?= $lv_sec; ?>_camera" width="300" height="225" style="border: #666666 1px solid;"></canvas>
			</div>
			<div style="text-align: center; font-size: 42px; color: #363636;" class="hidden" id="countDown">&nbsp;</div>
			<a href="#" class="hidden" id="btnstrpht"></a>
			<a href="#" class="hidden" id="btnendpht"></a>
			<a href="#" class="hidden" id="btntkepht"></a>
			<a href="#" class="hidden" id="btntkepht2"></a>
			<a href="#" class="hidden" id="btndelpht"></a>
			<a href="#" class="hidden" id="btnuplpht"></a>				
		</div>
	</form>
	<script>
		var <?= $lv_sec; ?>_counter = 3;
		function <?= $lv_sec; ?>_countDown(){
      if( gv_<?= $lv_sec; ?>_videoInput ){
        if($("#<?= $lv_sec; ?> #countDown").length==1){
          switch( <?= $lv_sec; ?>_counter ) {
            case 3: $("#<?= $lv_sec; ?> #countDown").html("<span class='text-danger'><b>3</b></span> 2 1 <i class='far fa-smile'></i>").removeClass("hidden"); break;
            case 2: $("#<?= $lv_sec; ?> #countDown").html("3 <span class='text-danger'><b>2</b></span> 1 <i class='far fa-smile'></i>"); break;
            case 1: $("#<?= $lv_sec; ?> #countDown").html("3 2 <span class='text-danger'><b>1</b></span> <i class='far fa-smile'></i>"); break;
            case 0:	
              $("#<?= $lv_sec; ?>_camera").css("filter","opacity(0.1)");
              $("#<?= $lv_sec; ?> #countDown").html("3 2 1 <span class='text-danger'><i class='fas fa-grin'></i></span>"); 
              break;
            case -1:
              $("#<?= $lv_sec; ?>_camera").css("filter","");
              $("#<?= $lv_sec; ?> #btntkepht2").trigger("click");
              $("#<?= $lv_sec; ?> #countDown").addClass("hidden");
              $.each(BootstrapDialog.dialogs, function(id, dialog){
                if( dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>" ) { 
                  dialog.getButton("btndel").removeClass("hidden");
                  dialog.getButton("btnok").removeClass("hidden");
                }
              });
              break;
          }
          if(<?= $lv_sec; ?>_counter>0){
            setTimeout(<?= $lv_sec; ?>_countDown, 1000); 
            <?= $lv_sec; ?>_counter--;
          } else if(<?= $lv_sec; ?>_counter==0){
            setTimeout(<?= $lv_sec; ?>_countDown, 100);
            <?= $lv_sec; ?>_counter--;
          } else {
            <?= $lv_sec; ?>_counter=3;
          }
        }
      }else{
        $("#<?= $lv_sec; ?> #countDown").html("<span>No se detect&oacute; ning&uacute;n dispositivo de video</span>").css({'font-size' : '20px', 'margin-top' : '20px'}).removeClass("hidden");
      }
		}
	</script>
	<script>
		jQuery.video2image = { version: "1.0.0" };
		(function ($) {
			navigator.getUserMedia_ = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);
      
      var isSupported = !! navigator.getUserMedia_;
      var canvas;
      var video;
      var stream1;
      var canvasContext;
      var stopVideo;
      stopVideo = false;
      $.fn.video2image = function (options) {
        canvas = this.get(0); // our canvas
        if (options === 'isSupported') {
          return isSupported;
        } else if (options === 'capture') {
          return canvas.toDataURL();
        } else if (options === 'stop') {
          stopVideo = true;
          stream1.getVideoTracks()[0].stop();
          canvasContext.clearRect(0, 0, canvas.width, canvas.height);
          return;
        }  else if (options === 'start') {
          stopVideo = false;
          return video.play();
        } else {
          // These are the defaults.
          var settings = $.extend({
            width: canvas.clientWidth,
            height: canvas.clientHeight,
            autoplay: true,
            onerror: function () {},
            onsuccess: function () {}
          }, options);

          // canvas context
          canvasContext = canvas.getContext('2d');

          // video element
          video = document.createElement('video');

          // Update our canvas dimensions
          $(canvas).prop("width", settings.width).prop("height", settings.height);

          // requestAnimationFrame
          window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

          // Write video to our canvas
          function tocanvas() {
            if (!stopVideo) {
              canvasContext.drawImage(video, 0, 0, settings.width, settings.height);
              window.requestAnimationFrame(tocanvas);
            }
          }

          // Set up video
          if (isSupported) {
            //navigator.webkitGetUserMedia({
            navigator.getUserMedia_({
              video: true
            }, function (stream) {
              try {
                video.srcObject = stream;
                stream1 = stream;
              } catch (error) {
                video.src = URL.createObjectURL(stream);
              }
              //video.src = URL.createObjectURL(stream);
              if (settings.autoplay)
                video.play();
              window.requestAnimationFrame(tocanvas);
              settings.onsuccess();
            }, settings.onerror);
          }
          return this.css({
            width: settings.width,
            height: settings.height
          });
        }
      };
		}
		(jQuery));
	</script>
	<script>
    gv_<?= $lv_sec; ?>_videoInput = false;
		$(function(){
      // revisa que exista una camara
      navigator.mediaDevices.enumerateDevices().then(function(stream){
        //recorre todos los streams para encontrar un input de video
        for(var i = 0; i < stream.length; i++){ if( stream[i].kind == "videoinput" && stream[i].label != "" ){ gv_<?= $lv_sec; ?>_videoInput = true;break; } }
        //revisa si se encontro un input de video
        if( gv_<?= $lv_sec; ?>_videoInput ){
        	$("#<?= $lv_sec; ?>_camera").video2image();
					$("#<?= $lv_sec; ?>_camera").video2image("start");
        }                                                                                                
      }).catch(function(){  });
			$("#<?= $lv_sec; ?>_camera_result").addClass("hidden");
			$("#<?= $lv_sec; ?>_camera").removeClass("hidden");
		});
		
		$("#<?= $lv_sec; ?> #btntkepht").on("click", function(e) { e.preventDefault();
			<?= $lv_sec; ?>_countDown();
		});
		
		$("#<?= $lv_sec; ?> #btntkepht2").on("click", function(e) { e.preventDefault();
			var data_uri = $("#<?= $lv_sec; ?>_camera").video2image("capture");
			document.getElementById("<?= $lv_sec; ?>_camera_result").innerHTML = "<img src='"+data_uri+"'/>";
      $("#<?= $lv_sec; ?> #camera_base64").val(data_uri);							
			$("#<?= $lv_sec; ?>_camera_result").removeClass("hidden");
			$("#<?= $lv_sec; ?>_camera").addClass("hidden");
		});
		
		$("#<?= $lv_sec; ?> #btndelpht").on("click", function(e) { e.preventDefault(); 
			$("#<?= $lv_sec; ?>_camera_result").addClass("hidden");
			$("#<?= $lv_sec; ?>_camera").removeClass("hidden");
		});
		
		$("#<?= $lv_sec; ?> #btnendpht").on("click", function(e) { e.preventDefault();
      if( gv_<?= $lv_sec; ?>_videoInput ){
        $("#<?= $lv_sec; ?>_camera").video2image("stop");
      }
			$("#<?= $lv_sec; ?>_camera_result").addClass("hidden");
			$("#<?= $lv_sec; ?>_camera").removeClass("hidden");
		});
	</script>
</section>