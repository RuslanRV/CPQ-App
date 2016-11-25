public class ATestA {
    
    public void method1(){
       
		sObject sObj = Schema.getGlobalDescribe().get('atestobj__c').newSObject();	
        
        sObj.put('MyName', null);
        
        System.debug('sObj: ' + sObj);
    }

}