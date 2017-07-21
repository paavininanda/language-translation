$(document).ready(function(){
  $(document).on("click", ".jpayAudio", function(e){
    $(this).next().get(0).play();

    e.preventDefault();
  })

  .on("click", ".addMoreAudio", function(e){
    console.log($(document).data("audioFieldCount"))
    var fieldsCount = $(document).data("audioFieldCount") || $(".audioBox").length;
        fieldsCount ++;

    var audioFields = "<div class='clear audioBox'>\
        <div class='g--half'>\
          <div class='Form-group'>\
            <input class='Form-control' type='text' name='article[audios_attributes]["+fieldsCount+"][content]' />\
          </div>\
        </div>\
        <div class='g--half g--last'>\
          <div class='Form-group'>\
            <input class='Form-control Media--file' type='file' name='article[audios_attributes]["+fieldsCount+"][audio]' />\
            <a href='#' class='Close Close--cross u-fr removeAudioFile'><span class='icon-close'></span></a>\
          </div>\
        </div>\
        <div class='clear'></div>\
      </div>";
    
    $(".AudioContainer").append(audioFields);

    $(document).data("audioFieldCount", fieldsCount);

    e.preventDefault();
  })

  .on("click", ".removeAudioFile", function(e){
    var $this = $(this);

    $this.parents(".audioBox").hide();

    $(this).prev().prop('checked', true);

    e.preventDefault();
  })
})
