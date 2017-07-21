(function(){
  $(document).on("click", ".noInvitation", function(){
    if($(this).is(':checked')){
      $(".withPassword").removeClass("hide")
    } else {
      $(".withPassword").addClass("hide")
    }
  })
}.call(this));

