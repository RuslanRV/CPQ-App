public class RVCPQServiceImpl implements RVICPQService{
	
	public List<RVCPQDomainHelper.Product> productsOfPriceListAndCategory(ID priceListId, ID categoryId){
		final RVIProducts iprod = RVProducts.newInstance(RVCPQDomainHelper.Product.class);
		final List<RVCPQDomainHelper.Product> prods = iprod.productsOfPriceListAndCategory(priceListId, categoryId);
		return prods;
	}

	public List<RVCPQDomainHelper.Category> categoriesOfPriceList(ID priceListId){
        final RVICategories icat = RVCategories.newInstance(RVCPQDomainHelper.Category.class);
		final List<RVCPQDomainHelper.Category> cats = icat.categoriesOfPriceList(priceListId);
		return cats;
	}

	public ID addProductToCartWith(ID priceListId, Integer quantity, ID productId, String quoteNumber){
		final RVILineItems iitem = RVLineItems.newInstance(RVCPQDomainHelper.LineItem.class);
		final ID cartId = iitem.addProductToCartWith(priceListId, quantity, productId, quoteNumber);
		return cartId;
	}

	public RVILineItems lineItemsOfCart(ID cartId){
		final RVILineItems lineItems = RVLineItems.newInstance(RVLineItemsSelector.newInstance().lineItemsOfCart(cartId));
		return lineItems;
	}
}