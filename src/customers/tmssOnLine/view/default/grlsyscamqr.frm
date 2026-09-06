<canvas id="canvas" class="hidden" style="background-color:black"></canvas>
<script>
  //contador del buffer
  var gv_<?= $lv_sec; ?>_counter = 150;
  
  //buffer
  var gv_<?= $lv_sec; ?>_buffer = false;

  //booleano para escanear
  var gv_<?= $lv_sec; ?>_scan = true;

  //boleano de metodo de escaneo
  var gv_<?= $lv_sec; ?>_singleScan = true

  //track del video
  var gv_<?= $lv_sec; ?>_track;

  //stream de video
  var gv_<?= $lv_sec; ?>_video = document.createElement("video");

  //canvas
  var gv_<?= $lv_sec; ?>_canvas = $("#<?= $lv_sec; ?> #canvas");
  
  //memoria
  var gv_<?= $lv_sec; ?>_memory = [];
  
  //booleano para usar mamoria
  var gv_<?= $lv_sec; ?>_useMemory = true;
  
  //contador de descanso
  var gv_<?= $lv_sec; ?>_restCounter = 10;
  
  //existe camara
  var gv_<?= $lv_sec; ?>_camera = true;
  
  

  //remarca el qr
  function drawLine(begin, end, color) {
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").beginPath();
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").moveTo(begin.x, begin.y);
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").lineTo(end.x, end.y);
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").lineWidth = 4;
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").strokeStyle = color;
    gv_<?= $lv_sec; ?>_canvas[0].getContext("2d").stroke();
  }

  //funcion inicial
  $(function(){
    tmssLoadScript("jsQR",function(){});
    
    if(!tmssIsMobile()){
      //invierte la imagen si se esta en escritorio
      gv_<?= $lv_sec; ?>_canvas.css("transform", "scaleX(-1)"); 
    }
    
    //revisa si se provieron datos de configuracion inicial
    if( typeof gv_<?= $lv_sec; ?>_camData != "undefined" && typeof gv_<?= $lv_sec; ?>_camData == "object" ){
      var lv_camData = gv_<?= $lv_sec; ?>_camData;
      
      //obtiene el metodo de escaneo
      if( typeof lv_camData.scan != "undefined" && typeof lv_camData.scan == "string"){
        //revisa que el metodo de escaneo este declarado
        if( lv_camData.scan == "multiple" ){
          //se declara que se escanearea multiples veces
          gv_<?= $lv_sec; ?>_singleScan = false;
        }
      }
      
      //obtiene si se usa memoria
      if( typeof lv_camData.memory != "undefined" && typeof lv_camData.memory == "boolean"){ gv_<?= $lv_sec; ?>_useMemory = lv_camData.memory; }
    }
  })
  
  //apaga o prende la camara
  function <?= $lv_sec; ?>_toggleVideo(){
    //pregunta si el video esta pausado
    if(gv_<?= $lv_sec; ?>_video.paused){
      //activa el buffer temporalmente
      gv_<?= $lv_sec; ?>_buffer = true;
      
      //reinicia el contador del buffer
      gv_<?= $lv_sec; ?>_counter = 150
      
      //reinicia el contador de descanso
      gv_<?= $lv_sec; ?>_restCounter = 10;
      
      //obtiene el stream de la camara
      navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
        //propiedades del video
        gv_<?= $lv_sec; ?>_video.srcObject = stream;
        gv_<?= $lv_sec; ?>_video.setAttribute("playsinline", true);

        //track del video
        gv_<?= $lv_sec; ?>_track = gv_<?= $lv_sec; ?>_video.srcObject.getTracks()[0];

        //activa al video
        gv_<?= $lv_sec; ?>_video.play();
        
        //habilita el escaneo
        gv_<?= $lv_sec ?>_scan = true;
        
        //funcion que va a correr en cada frame del video
        requestAnimationFrame(tick);
      }).catch(function(){ toastr.warning("Camara no encontrada"); });

      //detiene el stream
    }else{//si el video se esta reproduciendo
      //se frena el video
      gv_<?= $lv_sec; ?>_video.pause();

      //se frena el track del video
      gv_<?= $lv_sec; ?>_track.stop()
    }
                                                    
    //cambia si se muestra o no
    gv_<?= $lv_sec; ?>_canvas.toggleClass("hidden");
    
    return true;
  };

  //funcion que corre cada frame de del stream
  function tick(){
    if (gv_<?= $lv_sec; ?>_video.readyState === gv_<?= $lv_sec; ?>_video.HAVE_ENOUGH_DATA){
      if( gv_<?= $lv_sec; ?>_buffer ){
        if( gv_<?= $lv_sec; ?>_counter == 0){ gv_<?= $lv_sec; ?>_buffer=false; }else{ gv_<?= $lv_sec; ?>_counter--; }
      }
      
      //define el tamaño del canvas al tamaño del padre
      gv_<?= $lv_sec; ?>_canvas[0].width = gv_<?= $lv_sec; ?>_canvas.parent().width();
      gv_<?= $lv_sec; ?>_canvas[0].height = gv_<?= $lv_sec; ?>_canvas.parent().width() * ( tmssIsMobile() ? 1 : 0.5 );
      
			// Obtén el contexto del canvas
			var ctx = gv_<?= $lv_sec; ?>_canvas[0].getContext("2d", { willReadFrequently: true });
      
      if( gv_<?= $lv_sec; ?>_canvas[0].height > 0 && gv_<?= $lv_sec; ?>_canvas[0].width > 0 ){
        //actualiza el canvas
        ctx.drawImage(gv_<?= $lv_sec; ?>_video, 0, 0, gv_<?= $lv_sec; ?>_canvas.parent().width(), gv_<?= $lv_sec; ?>_canvas.parent().height());
      
        //si el contador de descanso no es cero no se buscan qr
      	if( gv_<?= $lv_sec; ?>_restCounter == 0 ){
          //reinicia el contador de descanso
          gv_<?= $lv_sec; ?>_restCounter = 10;
          
					//obtiene el imageData del canvas
          var imageData = ctx.getImageData(0, 0, gv_<?= $lv_sec; ?>_canvas[0].width, gv_<?= $lv_sec; ?>_canvas[0].height);

          var qr = jsQR(imageData.data, imageData.width, imageData.height, { inversionAttempts: "dontInvert"});

          //pregunta si se leyo un qr
          if ( qr  && !gv_<?= $lv_sec; ?>_video.paused) {
            //remarca el qr
            drawLine(qr.location.topLeftCorner, qr.location.topRightCorner, "#FF3B58");
            drawLine(qr.location.topRightCorner, qr.location.bottomRightCorner, "#FF3B58");
            drawLine(qr.location.bottomRightCorner, qr.location.bottomLeftCorner, "#FF3B58");
            drawLine(qr.location.bottomLeftCorner, qr.location.topLeftCorner, "#FF3B58");

            //revisa si se usa memoria
            if( gv_<?= $lv_sec; ?>_useMemory ){
              //se revisa si se encontro en memoria
              var lv_found = false;
              for(i=0; i < gv_<?= $lv_sec; ?>_memory.length; i++){ if( gv_<?= $lv_sec; ?>_memory[i] == qr.data ){ lv_found = true;break; } }
            }

            if( !lv_found ){
              //se manda el codigo leido
              <?= $lv_sec; ?>_output(qr.data);

              //revisa si solo se escanea una vez
              if( gv_<?= $lv_sec; ?>_singleScan){ gv_<?= $lv_sec ?>_scan = false; } 
            }
          }
        }else{
          gv_<?= $lv_sec; ?>_restCounter--;
        }
      }
    }
    
    //pregunta si hay que dejar de escanera 
    if( !gv_<?= $lv_sec ?>_scan && !gv_<?= $lv_sec; ?>_video.paused){ $("#<?= $lv_sec ?> #btnSwitch").click() }
    
    requestAnimationFrame(tick);
  }
  
  //output
  function <?= $lv_sec; ?>_output(lp_code){
    //muestra el codigo que se obtuvo
    if( typeof <?= $lv_sec; ?>_camAccion == "function" ){ <?= $lv_sec; ?>_camAccion( lp_code );
    }else{ toastr.info( lp_code ); }
    
    //agrega el codigo a la memoria
    gv_<?= $lv_sec; ?>_memory.push(lp_code);
  }
</script>