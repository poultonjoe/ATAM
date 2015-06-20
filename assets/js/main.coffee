ATAM = ATAM ||
  init: (options) ->
    $window = $(window)
    $html = $('html')
    $menu = $('.menu-button')
    $header = $('#site-header')
    $homeHeader = $('.home #site-header')
    $subnav = $('.sub-navigation a[href^="#"]')
    $intro = $('h1', $homeHeader)
    $scrollDown = $('#skip-to-content')
    $scrollUp = $('#skip-to-navigation')
    $content = $('#content')
    $acceptTerms = $('#accept-terms')
    debounce = null
    IMG_H = 946
    IMG_W = 1600
    hero = ->
      if $homeHeader.length
        $homeHeader.css
          height: Math.ceil IMG_H / IMG_W * $window.width()
    scrollUpPosition = ->
      if $window.width() >= 1160
        $scrollUp.css
          right: Math.ceil((($window.width() - $content.outerWidth()) / 4) - 23)
    scrollUpOpacity = ->
      if $window.width() >= 1160
        scroll = $window.scrollTop()
        offset = $homeHeader.outerHeight()
        opacity = 0
        fadeStartPos = if $html.hasClass 'home' then 146 else offset
        fadeEndPos = if $html.hasClass 'home' then offset else fadeStartPos + 146
        if scroll <= fadeStartPos
          opacity = 0
        else if scroll <= fadeEndPos
          opacity = scroll / fadeEndPos
        else
          opacity = 1
        $scrollUp.css
          opacity: opacity

    $html.addClass 'js'
    $html.addClass if 'ontouchstart' in window then 'touch' else 'no-touch'

    $menu.on 'click', (e) ->
      e.preventDefault()
      $html.toggleClass 'menu-visible'
      $intro.fadeToggle 250

    $subnav.on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate
        scrollTop: $(e.target.hash).offset().top - $header.outerHeight() - 36
      , 250

    $scrollDown.on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate
        scrollTop: $content.offset().top
      , 500

    $scrollUp.on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate
        scrollTop: 0
      , 500

    $acceptTerms.on 'click', (e) =>
      @closeModal()

    $window.on 'resize', ->      
      if debounce
          clearTimeout debounce
      debounce = setTimeout ->
        hero()
        scrollUpPosition()
      , 50
    
    $window.on 'scroll', ->
      unless $html.hasClass 'home'
        if $window.scrollTop() > 0
          $html.addClass 'fixed'
        else
          $html.removeClass 'fixed'
      scrollUpOpacity()

    hero()
    scrollUpPosition()
    scrollUpOpacity()

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
  