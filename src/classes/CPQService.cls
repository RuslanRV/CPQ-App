public with sharing class CPQService {

    private static CPQService instance = null;
    public String id {get; private set;}

    private CPQService() {
        //id = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('').getRecordTypeId();
    }

    public static CPQService getInstance() {
        if (instance == null) {
            instance = new CPQService();
        }
        return instance;
    }

    public Apttus_CPQApi.CPQ.CategorySearchResultDO categoriesOfPrice(final ID priceListId) {

        Apttus_CPQApi.CPQ.CategorySearchResultDO result;

        if (priceListId != null) {
            result = Apttus_CPQApi.CPQWebService.getCategoriesForPriceList(priceListId);
        }
        return result;
    }

    public Apttus_CPQApi.CPQ.ProductSearchResultDO productsOfPriceListCategory(final ID priceListId, final ID categoryId) {

        Apttus_CPQApi.CPQ.ProductSearchResultDO result;

        if (categoryId != null && priceListId != null) {
            result = Apttus_CPQApi.CPQWebService.getProductsForPriceListCategory(priceListId, categoryId);
        }

        return result;
    }

    public ID priceListIdOfName(final String priceListName) {

        ID priceListId;

        final List<Apttus_Config2__PriceList__c> priceListItemList = [select id
                from Apttus_Config2__PriceList__c
                where name = :priceListName limit 1];

        if (priceListItemList.size() > 0) {
            priceListId = priceListItemList[0].ID;
        }

        return priceListId;
    }

}