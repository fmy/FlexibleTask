/*
this is a background service and this code will run *every* time the 
application goes into the foreground
*/
var notification;

Ti.API.info("hello from a background service");

notification = Ti.App.iOS.scheduleLocalNotification({
  alertBody: "Flexible Task was put in background",
  alertAction: "Re-Launch!",
  userInfo: {
    "hello": "world"
  },
  sound: "pop.caf",
  date: new Date(new Date().getTime() + 3000)
});

Ti.App.iOS.addEventListener('notification', function() {
  Ti.API.info('background event received = ' + notification);
  Ti.App.currentService.unregister();
});

Ti.App.currentService.addEventListener('stop', function() {
  return Ti.API.info("background service is stopped");
});

Ti.App.currentService.stop();
