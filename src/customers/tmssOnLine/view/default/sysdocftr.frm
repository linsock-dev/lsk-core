<?php if( ($vew_sec->buscod??'')=='' ){ ?>
<div style="background-color: #F44336;text-align: center;font-weight: bold;font-size: 16px;color: white;padding: 5px;position: fixed;top: calc(100vH - 33px);width: 100%;z-index: 9999;">Por favor, regularice su situaci&oacute;n. Evite cortes.</div>
<?php } ?>
<a href="#" class="back-to-top img-rounded">
  <i class="fas fa-arrow-circle-up fa-3x"></i>
</a>
<script>
$(document).ready(function() {
  var offset = 50;
  var duration = 300;
  
  $(window).scroll(function() {
    if (jQuery(this).scrollTop() > offset) {
      $(".back-to-top").fadeIn(duration);
    } else {
      $(".back-to-top").fadeOut(duration);
    }
    if ($(this).scrollTop() > 50) {
      $(".navbar-fixed-top").removeClass("tmss-shadow");
      $(".tmss-navbar-fixed").addClass("tmss-navbar-fixed-hold").parent().css("padding-top","50px");
    } else {
      $(".navbar-fixed-top").addClass("tmss-shadow");
      $(".tmss-navbar-fixed").removeClass("tmss-navbar-fixed-hold").parent().css("padding-top","");
    }
  });
  
  $(".back-to-top").click(function(event) {
    event.preventDefault();
    $("html, body").animate({scrollTop: 0}, duration);
    return false;
  })
  
  if ($(this).scrollTop() > offset) {
    $(".back-to-top").fadeIn(duration);
  } else {
    $(".back-to-top").fadeOut(duration);
  }
});
</script> 