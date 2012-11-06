public with sharing class KennelTest {

	public Dog__c exampleDog {get; set;}
	public Attachment dogImage {get; set;}
	public String getImageBase64() {
		if(dogImage.Body != null) {
			return EncodingUtil.base64Encode(dogImage.Body);
		} else {
			return '';
		}
	}
	
	public KennelTest() {
		exampleDog = [SELECT Id, Name, Breed__c, Weight__c, Years_Old__c from Dog__c ORDER BY CreatedDate DESC LIMIT 1];
		List<Attachment> attachments = [SELECT Id, Body from Attachment WHERE ParentId =: exampleDog.Id];
		if(attachments.size() > 0) {
			dogImage = attachments[0];
		} else {
			dogImage = new Attachment();
		}
	}
	
	@RemoteAction
	static public String saveImage(String imageData, String dogId, string dogName) {
		Attachment dogImage = new Attachment();
		List<Attachment> attachments = [SELECT Id from Attachment WHERE ParentId =: dogId];
		if(attachments.size() > 0) {
			dogImage = attachments[0];
		} else {
			dogImage.parentid = dogId;
		}
		
		dogImage.Name = dogName + 'Profile';
		dogImage.body = EncodingUtil.base64Decode(imageData);
		upsert dogImage;
		return null;
	}

}
