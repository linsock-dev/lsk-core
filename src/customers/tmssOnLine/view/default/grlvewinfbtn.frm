<li><a href="#" class="tmsLink" id="btnshowinfo"><i style="width:20px" class="fas fa-info"></i><?= $vew_lang->additionalInfo; ?></a></li>
<script>
  //INFO adicional
  $("#<?= $lv_sec; ?> #btnshowinfo").on("click",function(e){e.preventDefault
    var lv_dat=[{"infttl":"<?= $vew_lang->createdby;?>","infdat":"<?= $vew_data->cteusr; ?>"},
                {"infttl":"<?= $vew_lang->createddate; ?>","infdat":"<?= ($vew_data->ctedte!=''?date_format($vew_data->ctedte,'d-m-Y h:i:s'):''); ?>"},
                {"infttl":"<?= $vew_lang->updatedby; ?>","infdat":"<?= $vew_data->updusr; ?>"},
                {"infttl":"<?= $vew_lang->updateddate; ?>","infdat":"<?= ($vew_data->upddte!=''?date_format($vew_data->upddte,'d-m-Y h:i:s'):''); ?>"}];
    var lv_pstdat=[{name:"infdat",value:JSON.stringify(lv_dat)}];
    tmssPopup("Info","?prg=grlvew&act=showinfo",function(){},lv_pstdat);
  });
</script>
