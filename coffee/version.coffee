# returns true if iphone/ipad and version is 3.2+
isIPhone3_2_Plus = ->
    # add iphone specific tests
    if Titanium.Platform.name is 'iPhone OS'
        version = Titanium.Platform.version.split(".")
        major = parseInt(version[0],10)
        minor = parseInt(version[1],10)
        
        # can only test this support on a 3.2+ device
        if major > 3 or (major is 3 and minor > 1)
            return true
    return false

isiOS4Plus = ->
    # add iphone specific tests
    if Titanium.Platform.name is 'iPhone OS'
        version = Titanium.Platform.version.split(".")
        major = parseInt(version[0],10)
        # can only test this support on a 3.2+ device
        if major >= 4
            return true
    return false
