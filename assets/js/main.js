var ATAM,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ATAM = ATAM || {
  init: function(options) {
    var $acceptTerms, $content, $header, $html, $intro, $menu, $scrollDown, $scrollUp, $window, IMG_H, IMG_W, debounce, hero, scrollUpOpacity, scrollUpPosition;
    $window = $(window);
    $html = $('html');
    $menu = $('.menu-button');
    $header = $('.home #site-header');
    $intro = $('h1', $header);
    $scrollDown = $('#skip-to-content');
    $scrollUp = $('#skip-to-navigation');
    $content = $('#content');
    $acceptTerms = $('#accept-terms');
    debounce = null;
    IMG_H = 946;
    IMG_W = 1600;
    hero = function() {
      if ($header.length) {
        return $header.css({
          height: Math.ceil(IMG_H / IMG_W * $window.width())
        });
      }
    };
    scrollUpPosition = function() {
      if ($window.width() >= 1160) {
        return $scrollUp.css({
          right: Math.ceil((($window.width() - $content.outerWidth()) / 4) - 23)
        });
      }
    };
    scrollUpOpacity = function() {
      var fadeEndPos, fadeStartPos, offset, opacity, scroll;
      if ($window.width() >= 1160) {
        scroll = $window.scrollTop();
        offset = $header.outerHeight();
        opacity = 0;
        fadeStartPos = $html.hasClass('home') ? 146 : offset;
        fadeEndPos = $html.hasClass('home') ? offset : fadeStartPos + 146;
        if (scroll <= fadeStartPos) {
          opacity = 0;
        } else if (scroll <= fadeEndPos) {
          opacity = scroll / fadeEndPos;
        } else {
          opacity = 1;
        }
        return $scrollUp.css({
          opacity: opacity
        });
      }
    };
    $html.addClass('js');
    $html.addClass(__indexOf.call(window, 'ontouchstart') >= 0 ? 'touch' : 'no-touch');
    $menu.on('click', function(e) {
      e.preventDefault();
      $html.toggleClass('menu-visible');
      return $intro.fadeToggle(250);
    });
    $scrollDown.on('click', function(e) {
      e.preventDefault();
      return $('html,body').animate({
        scrollTop: $content.offset().top
      }, 500);
    });
    $scrollUp.on('click', function(e) {
      e.preventDefault();
      return $('html,body').animate({
        scrollTop: 0
      }, 500);
    });
    $acceptTerms.on('click', (function(_this) {
      return function(e) {
        return _this.closeModal();
      };
    })(this));
    $window.on('resize', function() {
      if (debounce) {
        clearTimeout(debounce);
      }
      return debounce = setTimeout(function() {
        hero();
        return scrollUpPosition();
      }, 50);
    });
    $window.on('scroll', function() {
      if (!$html.hasClass('home')) {
        if ($window.scrollTop() > 0) {
          $html.addClass('fixed');
        } else {
          $html.removeClass('fixed');
        }
      }
      return scrollUpOpacity();
    });
    hero();
    scrollUpPosition();
    scrollUpOpacity();
    if (!Cookies.get('DisclaimerAccepted')) {
      return this.launchModal(options.disclaimer);
    }
  },
  launchModal: function(url) {
    var $html, $modal, $overlay;
    $html = $('html');
    $overlay = $('#overlay');
    $modal = $('#modal');
    return $.get(url, function(data) {
      var $content;
      $content = $(data).filter('#content').html();
      $modal.find('.content').html($content);
      $overlay.fadeIn(500);
      $modal.fadeIn(500);
      return $html.addClass('modal-visible');
    });
  },
  closeModal: function() {
    var $html, $modal, $overlay;
    $html = $('html');
    $overlay = $('#overlay');
    $modal = $('#modal');
    $html.removeClass('modal-visible');
    $overlay.remove();
    $modal.remove();
    return Cookies.set('DisclaimerAccepted', true, {
      expires: new Date(2030, 0, 1)
    });
  }
};
