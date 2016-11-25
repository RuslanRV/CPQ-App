public interface RVILineItemsSelector extends fflib_ISObjectSelector{	
	List<Apttus_Config2__LineItem__c> lineItemsOfCart(ID cartId);
}