
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find({}, sort: {"slack.timestamp": -1})
    @render 'gallery',
      data: {photos}

Template.gallery.helpers
  photo_title: ->
    @slack.title unless \
      _.any(["jpg", "png", "upload"],
            (badEnding) => @slack.title.toLowerCase().endsWith(badEnding)) or
      @slack.title.startsWith("DSC")
      
prevLightbox = null
      
buildGallery = ->
  console.log "buildGallery"
  $('#gallery').justifiedGallery({
    rowHeight: 200
    lastRow: 'nojustify'
    margins: 15
  })
  
  prevLightbox.quitImageLightbox() if prevLightbox
  
  selectorF = '#gallery a'
  instanceF = $('#gallery a')
  prevLightbox = instanceF
  instanceF.imageLightbox({
    onStart: ->
      lightbox.overlayOn()
      lightbox.closeButtonOn(instanceF)
      lightbox.arrowsOn(instanceF, selectorF)
    onEnd: ->
      lightbox.overlayOff()
      lightbox.captionOff()
      lightbox.closeButtonOff()
      lightbox.arrowsOff()
      lightbox.activityIndicatorOff()
    onLoadStart: ->
      lightbox.captionOff()
      lightbox.activityIndicatorOn()
    onLoadEnd: ->
      lightbox.captionOn()
      lightbox.activityIndicatorOff()
      $('.imagelightbox-arrow').css('display', 'block')
  })

Template.gallery.onRendered ->
  @autorun ->
    Photos.find().count()  # solely to force reactivity in the method
    setTimeout(buildGallery, 250)