@IsTest(SeeAllData=true)
private class RVCPQServiceTest{
	
    @IsTest
	private static void callingServiceShouldCallSelectorLineItemsOfCartInDomainAndCommit(){		
        // Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		RVILineItems domainMock = new RVMocks.RVLineItems(mocks);
		RVILineItemsSelector selectorMock = new RVMocks.RVLineItemsSelector(mocks);

		// Given
        mocks.startStubbing();
        
        ID priceListId = ID.valueOf('a200Y0000008byW');
        Integer quantity = 1;
        ID productId = ID.valueOf('01t0Y000000BsLv');
        String quoteNumber = 'Q-00000000';
        
		Apttus_Config2__LineItem__c testLineItem = new Apttus_Config2__LineItem__c(
															Apttus_Config2__ConfigurationId__c = fflib_IDGenerator.generate(Apttus_Config2__LineItem__c.SObjectType),
															Apttus_Config2__Description__c = 'Test description',
															Apttus_Config2__Quantity__c = 1,
															Apttus_Config2__ListPrice__c = 10.0,
															Apttus_Config2__NetPrice__c = 10.0,
															Apttus_Config2__LineNumber__c = 11);


		ID cartId = testLineItem.Apttus_Config2__ConfigurationId__c;

		mocks.when(domainMock.sObjectType()).thenReturn(Apttus_Config2__LineItem__c.SObjectType);
		mocks.when(selectorMock.sObjectType()).thenReturn(Apttus_Config2__LineItem__c.SObjectType);
		mocks.when(selectorMock.lineItemsOfCart(cartId)).thenReturn(testLineItem);
		mocks.stopStubbing();
		RVApplication.Domain.setMock(domainMock);
		RVApplication.Selector.setMock(selectorMock);

		// When
		ID tmpCartId = RVCPQService.addProductToCartWith(priceListId, quantity, productId, quoteNumber);
        
        System.assertNotEquals(null, tmpCartId, 'Expected not null Cart Id');
               
        // Then
		List<Apttus_Config2__LineItem__c> items = ((RVILineItemsSelector)mocks.verify(selectorMock)).lineItemsOfCart(tmpCartId);

		System.assertNotEquals(null, items, 'Expected not empty Line Items');
	}

	@IsTest
	private static void testLineItemsOfCart(){
		// Test data
		ID priceListId = ID.valueOf('a200Y0000008byW');
        Integer quantity = 1;
        ID productId = ID.valueOf('01t0Y000000BsLv');
        String quoteNumber = 'Q-00000000';

		ID cartId = RVCPQService.addProductToCartWith(priceListId, quantity, productId, quoteNumber);
				
		// Query
		List<Apttus_Config2__LineItem__c> lineItems =  RVLineItemsSelector.newInstance().lineItemsOfCart(cartId);

		// Assert
		System.assertEquals(1, lineItems.size());	
	}
}