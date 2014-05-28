ATAM = ATAM ||
  init: ->
    $window = $(window)
    $html = $('html')
    $menu = $('.menu-button')
    $header = $('.home #site-header')
    $intro = $('.home #introduction')
    $scrollDown = $('#skip-to-content')
    $content = $('#content')
    $acceptTerms = $('#accept-terms')
    lang = if document.location.href.indexOf('zh') > -1 then 'zh' else ''
    disclaimerUrl = document.location.origin + lang + '/disclaimer/'
    $hero = ->
      if $header.length
        $header.css
          height: $window.height() - 77
        $intro.css
          height: $window.height() - 77

    $html.addClass 'js'
    $html.addClass if 'ontouchstart' in window then 'touch' else 'no-touch'

    $menu.on 'click', (e) ->
      e.preventDefault()
      $html.toggleClass 'menu-visible'

    $scrollDown.on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate
        scrollTop: $content.offset().top
      , 500

    $acceptTerms.on 'click', (e) =>
      @closeModal()

    $window.on 'resize', ->
      $hero()

    $hero()

    unless Cookies.get 'DisclaimerAccepted'
      @launchModal(disclaimerUrl)

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


$ ->
  ATAM.init()
  