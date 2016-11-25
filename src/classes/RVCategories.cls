public class RVCategories extends fflib_SObjectDomain implements RVICategories{
	
	public static RVICategories newInstance(List<SObject> sObjectList){
		//return (RVICategories) RVApplication.Domain.newInstance(sObjectList);
		return null;
	}

	public static RVICategories newInstance(Type theType){
		return (RVICategories) RVApplication.ExternalService.newInstance(theType);
	}

    public RVCategories(){
        super(new List<SObject>());
    }

    public RVCategories(List<SObject> sObjectList){
        super(sObjectList);
    }
    
    public List<RVCPQDomainHelper.Category> categoriesOfPriceList(ID priceListId){
		
		final List<RVCPQDomainHelper.Category> categories = new List<RVCPQDomainHelper.Category>();
		
		final Apttus_CPQApi.CPQ.CategorySearchResultDO csrDO = Apttus_CPQApi.CPQWebService.getCategoriesForPriceList(priceListId);

        for (Apttus_CPQApi.CPQ.CategoryDO cDO1 : csrDO.Categories) {
           categories.add(new RVCPQDomainHelper.Category(cDO1));

            if (cDO1.HasChildCategories) {

                for (Apttus_CPQApi.CPQ.CategoryDO cDO2 : cDO1.ChildCategories) {
                    categories.add(new RVCPQDomainHelper.Category(cDO2));

                    if (cDO2.HasChildCategories) {

                        for (Apttus_CPQApi.CPQ.CategoryDO cDO3 : cDO2.ChildCategories) {
                            categories.add(new RVCPQDomainHelper.Category(cDO3));
                        }
                    }
                }
            }
        }
        return categories;
	}
    
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new RVCategories(sObjectList);
		}
	}
}