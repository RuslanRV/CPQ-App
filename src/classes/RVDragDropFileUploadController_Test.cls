@isTest
private class RVDragDropFileUploadController_Test {

    static testMethod void unitTest() {
    	Account acc = new Account();
    	acc.Name = 'Test';
    	insert acc;
    	
        RVDragDropFileUploadController c = new RVDragDropFileUploadController(new ApexPages.StandardController(acc));
        String error = RVDragDropFileUploadController.saveFile('filename',null,null);
        System.assert(error!=null,'Error should have been thrown');
        error = RVDragDropFileUploadController.saveFile('filename','content',acc.Id);
        System.assert(error==null,'Error should have been null');
    }
}