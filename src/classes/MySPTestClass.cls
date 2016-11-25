@isTest
private class MySPTestClass {

    @isTest static void theMethod(){
        Account[] accs = [Select id, name from account];
    }
    
    private static void tttt(){
        System.debug('Limits.getDMLStatements(): ' + Limits.getDMLStatements());
        System.debug('Limits.getDmlRows(): ' + Limits.getDmlRows());
        System.debug('Limits.getLimitDmlRows(): ' + Limits.getLimitDmlRows());
        System.debug('Limits.getLimitDmlStatements()): ' + Limits.getLimitDmlStatements());
        System.debug('====================================================================');
    }
}