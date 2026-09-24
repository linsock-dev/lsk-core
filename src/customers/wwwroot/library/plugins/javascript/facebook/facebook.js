//1243421782410174
$(document).ready( function() {
	$('#img-loginFacebook').click(facebook_signup);
});

function facebook_signup() {
 FB.login(function(response) {
	if (response.authResponse) {
			var fbuid = response.authResponse.userID;
			var fbtoken = response.authResponse.accessToken;
					FB.api('/me', {fields: 'last_name,first_name,email'}, function(data) {
						var fname = data.first_name;
						var lname = data.last_name;
						var fbEmail = data.email;
						dinoLoginForFB(fbuid,fbtoken,fname,lname,fbEmail,0,1);
					});
			} else {
					return;
			}
	}, {scope:'email'});
}

function dinoLoginForFB(fbuid,fbtoken,fname,lname,fbEmail,fstats,status){
	if(status==1) {
		var reg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
		if(reg.test(fbEmail)) {
			var postData = "FTextUserEmail="+fbEmail+"&ebID="+fbuid+"&firstname="+fname+"&lastname="+lname+"&FTextUserPwd2="+parseInt(Math.random()*1000000);
			postData = postData + "&ebToken=" + fbtoken + "&ebStats=" + fstats + "&ebUid=" + fbuid + "&actions=facebookLogin";
			$.ajax({
				type:'post',
				url: getActionUrl(null, 'fb_eb_login.php'),
				data:postData,
				error:function(XMLHttpRequest, textStatus, errorThrown){
					$.cookie("fb_pop_rel","");
					//alert("AJAX Login Error."+textStatus+"-"+errorThrown,26,0,fbEmail);
				},
				success:function(result){
					if($.cookie("fb_pop_rel")=="cart"){
						$.cookie("fb_pop_rel","");
						window.location.href = HTTPS_ORDER_DOMAIN + 'm-flow-a-checkout.htm';
					} else if ($.cookie("fb_pop_rel")=="cart_code"){
						$.cookie("fb_pop_rel","");
						$('.applybtn').trigger('click');
						$(".ui_close").trigger('click');
					} else {
						window.location.href = USER_DOMAIN + 'm-users-a-index.htm';
					}
				}
			});
		}	else {
			alert('Our system does not support Facebook accounts registered using mobile numbers. Please re-register with an email address.');
			window.location.href =  HTTPS_LOGIN_DOMAIN +'m-users-a-sign.htm?type=1';
		}
	}
}

// window.fbAsyncInit = function() {
//     FB.init({ appId: '172708326171755', status: true, cookie: true, oauth: true, xfbml: true, version: 'v2.2' });
// };
// (function() {
//     var e = document.createElement('script');
//     e.type = 'text/javascript';
//     e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
//     e.async = true;
//     document.getElementsByTagName('head')[0].appendChild(e);
// } ());

window.fbAsyncInit = function() {
    FB.init({ appId: '1243421782410174', status: true, cookie: false, oauth: true, xfbml: false, version: 'v2.8' });
};

(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/es_LA/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
