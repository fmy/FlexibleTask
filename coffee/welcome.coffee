# use a closure to (a) test it and (b) not expose this into global scope
->
    tabGroup.addEventListener "open", (e) ->
        # window container
        welcomeWindow = Titanium.UI.createWindow
            height:80,
            width:200,
            touchEnabled:false

        # black view
        indView = Titanium.UI.createView
            height:80,
            width:200,
            backgroundColor:'#000',
            borderRadius:10,
            opacity:0.8,
            touchEnabled:false
        welcomeWindow.add indView

        # message
        message = Titanium.UI.createLabel
            text:'Appcelerator Titanium ' + Titanium.version,
            color:'#fff',
            textAlign:'center',
            font:
                fontSize:18,
                fontWeight:'bold'
            height:'auto',
            width:'auto'
        welcomeWindow.add message
        welcomeWindow.open()

        animationProperties = delay: 1500, duration: 1000, opacity: 0.1
        if Ti.Platform.osname is "iPhone OS"
            animationProperties.transform =
                Ti.UI.create2DMatrix().translate(-200,200).scale(0)
        welcomeWindow.animate animationProperties, ->
            welcomeWindow.close()
            return
        return
    return