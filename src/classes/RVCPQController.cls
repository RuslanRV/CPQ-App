public with sharing class RVCPQController {

	@RemoteAction
	public static List<RVCPQDomainHelper.Category> categoriesOfPriceList(ID priceListId) {        
       
        RVDebugInstrumentation.push('RVCPQController.categoriesOfPriceList');

        List<RVCPQDomainHelper.Category> result;

        try{
			result = RVCPQService.categoriesOfPriceList(priceListId);
        }catch(Exception ex){
    		RVDebugInstrumentation.debugException(ex, RVConstants.ERR_GC);
        }finally{        	
        }
        
        RVDebugInstrumentation.pop();

        return result;
	}

	@RemoteAction
	public static List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId) {
	        
	    RVDebugInstrumentation.push('RVCPQController.productsOfPriceListAndCategory');

		List<RVCPQDomainHelper.Product> result;

        try{
			result = RVCPQService.productsOfPriceListAndCategory(priceListId, categoryId);
			if(result == null || result.size() == 0){
				throw new RVDebugInstrumentation.CustomException('Product not found', RVConstants.ERR_GP);
			}
        }catch(RVDebugInstrumentation.CustomException rnfe){
    		RVDebugInstrumentation.debugException(rnfe);
        }catch(Exception ex){
    		RVDebugInstrumentation.debugException(ex, RVConstants.ERR_GP);
        }finally{
        }

		RVDebugInstrumentation.pop();

        return result;
	}

	@RemoteAction
	public static List<Apttus_Config2__LineItem__c> addProductToCartWith(ID priceListId, Integer quantity, ID productId, String quoteNumber) {
		final ID cartId = RVCPQService.addProductToCartWith(priceListId, quantity, productId, quoteNumber);
		return RVCPQService.lineItemsOfCart(cartId);
	}

	@RemoteAction
	public static List<Apttus_Config2__LineItem__c> cartItemsOfQuote(String quoteNumber) {
		//return RVCPQService.lineItemsOfCart(cartId);
		return new List<Apttus_Config2__LineItem__c>();
	}
}