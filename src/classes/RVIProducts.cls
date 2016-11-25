public interface RVIProducts extends fflib_ISObjectDomain{
	List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId);
}