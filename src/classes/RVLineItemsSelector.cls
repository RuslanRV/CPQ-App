public class RVLineItemsSelector extends fflib_SObjectSelector implements RVILineItemsSelector{
	
	public static RVILineItemsSelector newInstance()	{
		return (RVILineItemsSelector) RVApplication.Selector.newInstance(Apttus_Config2__LineItem__c.SObjectType);
	}
	
	public List<Schema.SObjectField> getSObjectFieldList()	{
		return new List<Schema.SObjectField> {
			Apttus_Config2__LineItem__c.Id,
			Apttus_Config2__LineItem__c.Name,
			Apttus_Config2__LineItem__c.Apttus_Config2__Description__c,
			Apttus_Config2__LineItem__c.Apttus_Config2__Quantity__c,
			Apttus_Config2__LineItem__c.Apttus_Config2__ListPrice__c,
			Apttus_Config2__LineItem__c.Apttus_Config2__NetPrice__c,
			Apttus_Config2__LineItem__c.Apttus_Config2__LineNumber__c
		};
	}
	
	public Schema.SObjectType getSObjectType(){
		return Apttus_Config2__LineItem__c.sObjectType;
	}

	public List<Apttus_Config2__LineItem__c> selectById(Set<ID> idSet){
		return (List<Apttus_Config2__LineItem__c>) selectSObjectsById(idSet);
	}
		
	//Example 1 - DB selector
	public List<Apttus_Config2__LineItem__c> lineItemsOfCart(ID cartId){
		fflib_QueryFactory queryFactory = newQueryFactory();
		return (List<Apttus_Config2__LineItem__c>) Database.query(queryFactory.setCondition('Apttus_Config2__ConfigurationId__c=:cartId').toSOQL());
	}

/*  
	//Example 2 - External API call  
	public List<Apttus_Config2__LineItem__c> lineItemsOfCart(final ID cartId) {

        final List<Apttus_Config2__LineItem__c> lineItems = [select Id, Name,
                                          Apttus_Config2__Description__c,
                                          Apttus_Config2__Quantity__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c,
                                          Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :cartId];
        return lineItems;
    }*/

}