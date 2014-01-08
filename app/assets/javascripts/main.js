(function($) {
  $.fn.sticky = function(options) {
    var settings = {}, 
      $_this = this;
    
    settings = $.extend(settings, options);
    
    if (settings.offset) {
      var offsetMarginBottom = settings.offset.css('marginBottom');
      $(window).scroll(function() {
        if ($(window).scrollTop() >= ($_this.offset().top - settings.offset.outerHeight())) {
          $_this.addClass('fixed'); 
          settings.offset.css({
            marginBottom: $_this.outerHeight()
          });
        }else {
          $_this.removeClass('fixed');
          settings.offset.css({
            marginBottom: parseInt(offsetMarginBottom)
          });
        }
      });
    }else {
      var paddingTop = $_this.parent().css("paddingTop");
      $(window).scroll(function() {
        if ($(window).scrollTop() >= $_this.offset().top) {
          $_this.addClass('fixed');
          $_this.parent().css({
            paddingTop: $_this.outerHeight()
          });
        }else {
          $_this.removeClass('fixed');
          $_this.parent().css({
            paddingTop: paddingTop
          });
        }
      });
    }
  }
})(jQuery)

// $(document).ready(function() {
//   $('.sticky').sticky({
//     offset: $('header')
//   });
// })