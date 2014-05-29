ATAM = ATAM ||
  init: (options) ->
    $window = $(window)
    $html = $('html')
    $menu = $('.menu-button')
    $header = $('.home #site-header')
    $intro = $('h1', $header)
    $scrollDown = $('#skip-to-content')
    $content = $('#content')
    $acceptTerms = $('#accept-terms')
    debounce = null
    IMG_H = 946
    IMG_W = 1600
    $hero = ->
      if $header.length
        $header.css
          height: Math.ceil IMG_H / IMG_W * $window.width()


    $html.addClass 'js'
    $html.addClass if 'ontouchstart' in window then 'touch' else 'no-touch'

    $menu.on 'click', (e) ->
      e.preventDefault()
      $html.toggleClass 'menu-visible'
      $intro.fadeToggle 250

    $scrollDown.on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate
        scrollTop: $content.offset().top
      , 500

    $acceptTerms.on 'click', (e) =>
      @closeModal()

    $window.on 'resize', ->      
      if debounce
          clearTimeout debounce
      debounce = setTimeout $hero, 50
    
    unless $html.hasClass 'home'
      $window.on 'scroll', ->
        if $window.scrollTop() > 0
          $html.addClass 'fixed'
        else
          $html.removeClass 'fixed'

    $hero()

    unless Cookies.get 'DisclaimerAccepted'
      @launchModal(options.disclaimer)

  launchModal: (url) ->
    $html = $('html')
    $overlay = $('#overlay')
    $modal = $('#modal')

    $.get url, (data) ->
      $content = $(data).filter('#content').html()
      $modal.find('.content').html $content
      $overlay.fadeIn 500
      $modal.fadeIn 500
      $html.addClass 'modal-visible'

  closeModal: ->
    $html = $('html')
    $overlay = $('#overlay')
    $modal = $('#modal')
    
    $html.removeClass 'modal-visible'
    $overlay.remove()
    $modal.remove()
    
    Cookies.set 'DisclaimerAccepted', true, 
      expires: new Date 2030, 0, 1
  