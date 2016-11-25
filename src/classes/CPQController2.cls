@RestResource(urlMapping = '/cpq/*')
global with sharing class CPQController2  {

    private static final String DEFAULT_PRICE_LIST = 'Base Price List';
    public class DataAccessException extends Exception {}


    @HttpGet
    global static List<CPQFacade.CPQResponse> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response; 

       if(req.requestURI == '/cpq/categories'){
        return getCategories();
       }else{
        ID categoryId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        return getProducts(categoryId);
       }
    }

    @HttpPost
    global static Account create() {
        Account obj;
        return obj;
    }

    @HttpPut
    global static Account updateObject() {
        Account obj;
        return obj;
    }

    @HttpDelete
    global static void remove() {
    }


    private static List<CPQFacade.CategoryResponse> getCategories() {
        List<CPQFacade.CategoryResponse> categories = CPQFacade.categoriesOfPrice(DEFAULT_PRICE_LIST);
        if (categories == null || categories.size() == 0) {
            throw new DataAccessException('Category not found');
        }
        return categories;
    }

    private static List<CPQFacade.ProductResponse> getProducts(final ID categoryId ) {
        List<CPQFacade.ProductResponse> products = CPQFacade.productsOfPriceListCategory(DEFAULT_PRICE_LIST, categoryId);
        if (products == null || products.size() == 0) {
            throw new DataAccessException('Product not found');
        }
        return products;
    }
}