global with sharing class CPQController {

	private static final String DEFAULT_PRICE_LIST = 'Base Price List';	
	public class DataAccessException extends Exception {}


	@RemoteAction
	global static List<CPQFacade.CategoryResponse> categories() {

		List<CPQFacade.CategoryResponse> categories = CPQFacade.categoriesOfPrice(DEFAULT_PRICE_LIST);

		if (categories == null || categories.size() == 0) {
			throw new DataAccessException('Category not found');
		}

		return categories;
	}

	@RemoteAction
	global static List<CPQFacade.ProductResponse> products(final ID categoryId ) {

		List<CPQFacade.ProductResponse> products = CPQFacade.productsOfPriceListCategory(DEFAULT_PRICE_LIST, categoryId);

		if (products == null || products.size() == 0) {
			throw new DataAccessException('Product not found');
		}

		return products;
	}

	@RemoteAction
	global static List<CPQFacade.LineItemResponse> addProductToCartWith(final Integer quantity, final String productName, final String quoteNumber) {

		List<CPQFacade.LineItemResponse> response = CPQFacade.addProductToCartWith(quantity, DEFAULT_PRICE_LIST, productName, quoteNumber);

		if (response == null || response.size() == 0) {
			throw new DataAccessException('Failed to add a product to the cart');
		}

		return response;
	}

	@RemoteAction
	global static List<CPQFacade.LineItemResponse> cartItemsOfQuote(final String quoteNumber) {
		List<CPQFacade.LineItemResponse> response = CPQFacade.cartItemsOfQuote(quoteNumber);
		return response;
	}

}