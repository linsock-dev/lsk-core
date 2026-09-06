<script language="JavaScript" src="//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
<script language="JavaScript" src="scriptcam.js"></script>
<div class="row">
	<div class="col-md-12">
		<a id="modal-456343" href="#modal-container-456343" role="button" class="btn" data-toggle="modal">Launch demo modal</a>
		<div class="modal fade" id="modal-container-456343" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4 class="modal-title" id="myModalLabel">Modal title</h4>
					</div>
					<div class="modal-body">
						<img id="image" src="\images\fun.png" class="img-responsive img-rounded">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" ng-click="changeImage('img1')">Image 1</button>
						<button type="button" class="btn btn-primary" ng-click="changeImage('img2')">Image 2</button>
						<button type="button" class="btn btn-default" >+</button> 
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button> 
						<button type="button" class="btn btn-primary">Save changes</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
	$(document).ready(function() {
			$("#webcam").scriptcam({
					showMicrophoneErrors:false,
					onError:onError,
					cornerRadius:20,
					disableHardwareAcceleration:1,
					cornerColor:'e3e5e2',
					onWebcamReady:onWebcamReady,
					uploadImage:'upload.gif',
					onPictureAsBase64:base64_tofield_and_image
			});
	});
	function base64_tofield() {
			$('#formfield').val($.scriptcam.getFrameAsBase64());
	};
	function base64_toimage() {
			$('#image').attr("src","data:image/png;base64,"+$.scriptcam.getFrameAsBase64());
	};
	function base64_tofield_and_image(b64) {
			$('#formfield').val(b64);
			$('#image').attr("src","data:image/png;base64,"+b64);
	};
	function changeCamera() {
			$.scriptcam.changeCamera($('#cameraNames').val());
	}
	function onError(errorId,errorMsg) {
			$( "#btn1" ).attr( "disabled", true );
			$( "#btn2" ).attr( "disabled", true );
			alert(errorMsg);
	}          
	function onWebcamReady(cameraNames,camera,microphoneNames,microphone,volume) {
			$.each(cameraNames, function(index, text) {
					$('#cameraNames').append( $('<option></option>').val(index).html(text) )
			});
			$('#cameraNames').val(camera);
	}
	$scope.imgUrls = {
			img1: "/images/yeoman.png",
			img2: "/images/fun.png"
	}

	$scope.changeImage = function(img){
			if(img == "img1") $("#i").attr('src', $scope.imgUrls.img1);
			if(img == "img2") $("#i").attr('src', $scope.imgUrls.img2);
	}
</script>