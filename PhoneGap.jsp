<apex:page showHeader="false" Controller="KennelTest" >
<html>
  <head>
    <title>Capture Photo</title>

    <script type="text/javascript" charset="utf-8" src="{!URLFOR($Resource.PhoneGap12)}"></script>
    <script type="text/javascript" charset="utf-8">

    var pictureSource;   // picture source
    var destinationType; // sets the format of returned value 

    // Wait for PhoneGap to connect with the device
    document.addEventListener("deviceready",onDeviceReady,false);

    //Device is ready
    function onDeviceReady() {
        pictureSource=navigator.camera.PictureSourceType;
        destinationType=navigator.camera.DestinationType;
		document.getElementById('dogDiv').style.opacity = 1;
		if('{!ImageBase64}' != '') {
			document.getElementById('dogImage').src = 'data:image/jpeg;base64,{!ImageBase64}';
		}
    }

    function onPhotoDataSuccess(imageData) {
      document.getElementById('dogDiv').style.opacity = 0.1;
	  KennelTest.saveImage(imageData, "{!exampleDog.Id}", "{!exampleDog.Name}", 
			function(res,event){ 		
				document.getElementById('dogDiv').style.opacity = 1; 
			});
      document.getElementById('dogImage').src = "data:image/jpeg;base64," + imageData;
	  
    }

	//via camera
    function capturePhoto() {
      // Take picture using device camera and retrieve image as base64-encoded string
      navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 50 });
    }

    //editable photo alternative
    function capturePhotoEdit() {
      // Take picture using device camera, allow edit, and retrieve image as base64-encoded string  
		navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 20, allowEdit: true }); 
    }

    //via library
    function getPhoto(source) {
      // Retrieve image file location from specified source
      navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 50, 
        sourceType: source });
    }

    function onFail(message) {
      window.console('Failed because: ' + message);
    }

    </script>
  </head>
  <body>
   <div style="position: absolute; height: 100%; width: 100px; background-color: white; top: 0px; text-align:center; border-right: 2px solid #999; padding-top: 20px; "> 
    <button onclick="getPhoto(pictureSource.PHOTOLIBRARY);"><apex:image url="{!URLFOR($Resource.glyphish, '42-photos.png')}" height="32" width="48" /></button><BR /><BR />
    <button onclick="capturePhoto();"><apex:image url="{!URLFOR($Resource.glyphish, '86-camera.png')}" height="32" width="48" /></button><BR /><BR />
    
    <button onclick="window.location.reload();" style="position: absolute; bottom: 40px; left: 15px;"><apex:image url="{!URLFOR($Resource.glyphish, '01-refresh.png')}" height="32" width="48" /></button><BR /><BR />
   </div>
    <div id="dogDiv" style="position: absolute; top: 25px; left: 125px; opacity:0.5">
      <image id="dogImage" src="{!URLFOR($Resource.glyphish, '82-dog-paw.png')}" style="float: left; width: 200px; height: 200px; border: 1px solid #999; margin-right: 10px;" />
      <h2>{!exampleDog.Name}</h2>,
      <I>{!exampleDog.Breed__c}</I>
      <hr />
      Weight: {!exampleDog.Weight__c} lbs. <BR />
      Age: {!exampleDog.Years_Old__c} years 
    </div>
  </body>
</html>
</apex:page>