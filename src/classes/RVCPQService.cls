/*
 * Provides service layer access to other services
 *
* */
global with sharing class RVCPQService{

    global static List<RVCPQDomainHelper.Category> categoriesOfPriceList(ID priceListId){        
        final List<RVCPQDomainHelper.Category> cats = cpqService().categoriesOfPriceList(priceListId);
        return cats;
    }

    global static List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId){
        final List<RVCPQDomainHelper.Product> products = cpqService().productsOfPriceListAndCategory(priceListId, categoryId);
        return products;
    }

    global static List<Apttus_Config2__LineItem__c> lineItemsOfCart(ID cartId){        
        List<Apttus_Config2__LineItem__c> records = new List<Apttus_Config2__LineItem__c>();
        final RVILineItems item = cpqService().lineItemsOfCart(cartId);
        if(item.sObjectType() == Apttus_Config2__LineItem__c.SObjectType){
            records = item.getRecords();
        }
        return records;
    }

    global static ID addProductToCartWith(ID priceListId, Integer quantity, ID productId, String quoteNumber){
        final ID cartId = cpqService().addProductToCartWith(priceListId, quantity, productId, quoteNumber);
        return cartId;
    }

    private static RVICPQService cpqService(){
        return (RVICPQService) RVApplication.Service.newInstance(RVICPQService.class);
    }
}