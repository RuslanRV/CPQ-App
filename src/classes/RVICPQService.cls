public interface RVICPQService {
	List<RVCPQDomainHelper.Category> categoriesOfPriceList(ID priceListId);
	List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId);
	ID addProductToCartWith(ID priceListId, Integer quantity, String productName, String quoteNumber);
	RVILineItems lineItemsOfCart(ID cartId);
}