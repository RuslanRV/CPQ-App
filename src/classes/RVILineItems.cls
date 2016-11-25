public interface RVILineItems extends fflib_ISObjectDomain{
	ID addProductToCartWith(ID priceListId, Integer quantity, String productName, String quoteNumber);
}