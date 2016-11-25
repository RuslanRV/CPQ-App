public class RVProducts extends fflib_SObjectDomain implements RVIProducts{

	public static RVIProducts newInstance(Type theType){
		return (RVIProducts) RVApplication.ExternalService.newInstance(theType);
	}

    public RVProducts(){
        super(new List<SObject>());
    }

    public RVProducts(List<SObject> sObjectList){
        super(sObjectList);
    }
    
    public List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId){

        final List<RVCPQDomainHelper.Product> products = new List<RVCPQDomainHelper.Product>();

        final Apttus_CPQApi.CPQ.ProductSearchResultDO psrDO = Apttus_CPQApi.CPQWebService.getProductsForPriceListCategory(priceListId, categoryId);

        for (Apttus_CPQApi.CPQ.ProductDO pDO : psrDO.Products) {
            products.add(new RVCPQDomainHelper.Product(pDO));
        }

        return products;
    }
		
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new RVProducts(sObjectList);
		}
	}
}