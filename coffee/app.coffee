# this sets the background color of the master UIView (when there are no windows/tab groups on it)
Titanium.UI.setBackgroundColor "#000"

# create tab group
tabGroup = Titanium.UI.createTabGroup id:"tabGroup"

# create base UI tab and root window
win1 = Titanium.UI.createWindow titleid:'list_title'
tab1 = Titanium.UI.createTab icon:'KS_nav_ui.png', titleid:'list_title', window:win1

win2 = Titanium.UI.createWindow titleid:"today_title"
tab2 = Titanium.UI.createTab icon:'KS_nav_views.png', titleid:"today_title", window:win2

win3 = Titanium.UI.createWindow titleid:"week_title"
tab3 = Titanium.UI.createTab icon:'KS_nav_views.png', titleid:"week_title", window:win3

win4 = Titanium.UI.createWindow titleid:"month_title"
tab4 = Titanium.UI.createTab icon:'KS_nav_views.png', titleid:"month_title", window:win4

win5 = Titanium.UI.createWindow titleid:"done_title"
tab5 = Titanium.UI.createTab icon:'KS_nav_views.png', titleid:"done_title", window:win5

tabGroup.addTab tab1
tabGroup.addTab tab2
tabGroup.addTab tab3
tabGroup.addTab tab4
tabGroup.addTab tab5

tabGroup.setActiveTab 1

tabGroup.open transition: Titanium.UI.iPhone and Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT

messageWin = Titanium.UI.createWindow
    height:30,
    width:250,
    bottom:70,
    borderRadius:10,
    touchEnabled:false,
    orientationModes:[
        Titanium.UI.PORTRAIT,
        Titanium.UI.UPSIDE_PORTRAIT,
        Titanium.UI.LANDSCAPE_LEFT,
        Titanium.UI.LANDSCAPE_RIGHT
    ]


messageView = Titanium.UI.createView
    id:'messageview',
    height:30,
    width:250,
    borderRadius:10,
    backgroundColor:'#000',
    opacity:0.7,
    touchEnabled:false

messageLabel = Titanium.UI.createLabel
    id:'messagelabel',
    text:'',
    color:'#fff',
    width:250,
    height:'auto',
    font:
        fontFamily:'Helvetica Neue',
        fontSize:13
    ,
    textAlign:'center'

messageWin.add messageView
messageWin.add messageLabel

tabGroup.addEventListener 'open', ->
    # set background color back to white after tab group transition
    Titanium.UI.setBackgroundColor '#fff'
    messageLabel.text = 'tab group open event'
    messageWin.open()
    setTimeout ->
        messageWin.close opacity:0, duration:500
        return
    , 1000
    return

tabGroup.addEventListener 'close', ->
    messageLabel.text = 'tab group close event'
    messageWin.open()
    if Ti.Platform.osname is "iphone"
        tabGroup.open()
    setTimeout ->
        messageWin.close opacity:0, duration:500
        return
    , 1000
    return
  
tabGroup.addEventListener 'focus', (e) ->
    messageLabel.text = 'tab changed to ' + e.index + ' old index ' + e.previousIndex
    messageWin.open()
    setTimeout ->
        Ti.API.info 'tab ' + e.tab.title  + ' prevTab = ' + (if e.previousTab then e.previousTab.title else null)
        messageLabel.text = 'active title ' + e.tab.title + ' old title ' + (if e.previousTab then e.previousTab.title else null)
        return
    , 1000
    setTimeout ->
        messageWin.close opacity:0, duration:500
        return
    , 2000
    return
    
tabGroup.addEventListener 'blur', (e) ->
    Titanium.API.info 'tab blur - new index ' + e.index + ' old index ' + e.previousIndex
    
indWin = null
actInd = null
showIndicator = ->
    if Ti.Platform.osname isnt 'android'
        # window container
        indWin = Titanium.UI.createWindow height:150, width:150

        # black view
        indView = Titanium.UI.createView
            height:150,
            width:150,
            backgroundColor:'#000',
            borderRadius:10,
            opacity:0.8
        indWin.add indView

    # loading indicator
    actInd = Titanium.UI.createActivityIndicator
        style:Titanium.UI.iPhone && Titanium.UI.iPhone.ActivityIndicatorStyle.BIG,
        height:30,
        width:30

    if Ti.Platform.osname isnt 'android'
        indWin.add actInd
        # message
        message = Titanium.UI.createLabel
            text:'Loading',
            color:'#fff',
            width:'auto',
            height:'auto',
            font:
                fontSize:20,
                fontWeight:'bold'
            bottom:20
        indWin.add message
        indWin.open()
    else
        actInd.message = "Loading"
    actInd.show()
    return
    
hideIndicator = ->
    actInd.hide()
    if Ti.Platform.osname isnt 'android'
        indWin.close opacity:0, duration:500

# Add global event handlers to hide/show custom indicator
Titanium.App.addEventListener 'show_indicator', ->
    Ti.API.info "IN SHOW INDICATOR"
    showIndicator()
Titanium.App.addEventListener 'hide_indicator', ->
    Ti.API.info "IN HIDE INDICATOR"
    hideIndicator()

# trap app shutdown event
Titanium.App.addEventListener 'close', ->
    Ti.API.info "The application is being shutdown"

# test for loading in a root-level include
Ti.include "welcome.js"

# test out logging to developer console, formatting and localization
Ti.API.info String.format("%s%s",L("welcome_message","default_not_set"),Titanium.version)
Ti.API.debug String.format("%s %s",L("user_agent_message","default_not_set"),Titanium.userAgent)

Ti.API.debug String.format("locale specific date is %s",String.formatDate(new Date())) # default is short
Ti.API.debug String.format("locale specific date (medium) is %s",String.formatDate(new Date(),"medium"))
Ti.API.debug String.format("locale specific date (long) is %s",String.formatDate(new Date(),"long"))
Ti.API.debug String.format("locale specific time is %s",String.formatTime(new Date()))
Ti.API.debug String.format("locale specific currency is %s",String.formatCurrency(12.99))
Ti.API.debug String.format("locale specific decimal is %s",String.formatDecimal(12.99))


Ti.API.info "should be en, was = " + Ti.Locale.currentLanguage
Ti.API.info "welcome_message = " + Ti.Locale.getString("welcome_message")
Ti.API.info "should be def, was = " + Ti.Locale.getString("welcome_message2","def")
Ti.API.info "welcome_message = " + L("welcome_message")
Ti.API.info "should be def, was = " + L("welcome_message2","def")
Ti.API.info "should be 1, was = " + String.format('%d',1)
Ti.API.info "should be 1.0, was = " + String.format('%1.1f',1)
Ti.API.info "should be hello, was = " + String.format('%s','hello')

# test to check that we can iterate over titanium based objects
->
    Ti.API.info "you should see a list of properties (3 or more) below this line"
    Ti.API.info "---------------------------------------------------------------"
    for p in win1
        Ti.API.info "         win1 property: " + p
    Ti.API.info "Did you see properties? ^^^^^ "
    Ti.API.info "---------------------------------------------------------------"

    Ti.API.info "you should see a list of modules (3 or more) below this line"
    Ti.API.info "---------------------------------------------------------------"
    for p in Titanium
        Ti.API.info "             module: " + p
    Ti.API.info "Did you see modules? ^^^^^ "
    Ti.API.info "---------------------------------------------------------------"
    return
    
Ti.include "version.js"

if isiOS4Plus()
    # register a background service. this JS will run when the app is backgrounded
    ###
    service = Ti.App.iOS.registerBackgroundService url:'bg.js'
    Ti.API.info "registered background service = " + service
    ###
    
    # listen for a local notification event
    Ti.App.iOS.addEventListener 'notification', (e) ->
        Ti.API.info "local notification received: " + JSON.stringify(e)
        return

    # fired when an app resumes for suspension
    Ti.App.addEventListener 'resume', ->
        Ti.API.info "app is resuming from the background"
        return
    Ti.App.addEventListener 'resumed', ->
        Ti.API.info "app has resumed from the background"
        return

    Ti.App.addEventListener 'pause', ->
        Ti.API.info "app was paused from the foreground"
        return

if Ti.App.Properties.getBool 'showNotice', true
    alertNotice = Ti.UI.createAlertDialog
        buttonNames: ['OK', 'Visit docs', 'Don\'t show again'],
        cancel:0,
        title: 'Notice',
        message: 'While this FlexibleTask provides an extensive demonstration of the Titanium API, its structure is not recommended for production apps. Please refer to our documentation for more details.'
    alertNotice.show()
    alertNotice.addEventListener 'click', (e) ->
        if e.index is 1
            Titanium.Platform.openURL 'http://wiki.appcelerator.org/display/guides/Example+Applications'
        else if e.index is 2
            Ti.API.info "showNotice switch to false"
            Ti.App.Properties.setBool 'showNotice', false
        return
