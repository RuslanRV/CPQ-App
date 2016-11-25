global with sharing class CPQFacade {

    global interface CPQResponse {

    }

    global class CategoryResponse implements CPQResponse {
        public ID categoryId;
        public String categoryName;
        public List<ProductResponse> products;

        public CategoryResponse(final String categoryId, final String categoryName) {
            this.categoryId = categoryId;
            this.categoryName = categoryName;
        }
    }

    global class ProductResponse implements CPQResponse {
        public ID productId {get; set;}
        public String productCode {get; set;}
        public String productName {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String contentUrl {get; set;}
        public Boolean hasPrices {get; set;}
        public Decimal quantity {get; set;}
        public ID categoryId {get; set;}

        public ProductResponse(final String productId, final String productName) {
            this.productId = productId;
            this.productName = productName;
        }
    }

    global class LineItemResponse {
        public ID Id {get; set;}
        public String name {get; set;}
        public String productName {get; set;}
        public Decimal quantity {get; set;}
        public Decimal listPrice {get; set;}
        public Decimal netPrice {get; set;}
        public Decimal lineNumber {get; set;}
    }

    public static List<CategoryResponse> categoriesOfPrice(final String priceListName) {

        final List<CategoryResponse> response = new List<CategoryResponse>();
        final ID priceListId = CPQService.getInstance().priceListIdOfName(priceListName);
        final Apttus_CPQApi.CPQ.CategorySearchResultDO result = CPQService.getInstance().categoriesOfPrice(priceListId);

        for (Apttus_CPQApi.CPQ.CategoryDO catresult : result.Categories) {

            response.add(new CategoryResponse(catresult.categoryId, catresult.name));

            if (catresult.HasChildCategories) {

                for (Apttus_CPQApi.CPQ.CategoryDO subcatresult : catresult.ChildCategories) {
                    response.add(new CategoryResponse(subcatresult.categoryId, subcatresult.name));

                    if (subcatresult.HasChildCategories) {

                        for (Apttus_CPQApi.CPQ.CategoryDO subsubcatresult : subcatresult.ChildCategories) {
                            response.add(new CategoryResponse(subsubcatresult.categoryId, subsubcatresult.name));
                        }
                    }
                }
            }
        }

        return response;
    }

    public static List<ProductResponse> productsOfPriceListCategory(final String priceListName, final ID categoryId) {

        final List<ProductResponse> products = new List<ProductResponse>();

        if (categoryId != null && priceListName != null) {

            final ID priceListId = CPQService.getInstance().priceListIdOfName(priceListName);

            Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = CPQService.getInstance().productsOfPriceListCategory(priceListId, categoryId);

            for (Apttus_CPQApi.CPQ.ProductDO productDO : productResult.Products) {
                products.add(new ProductResponse (productDO.ProductId, productDO.Name));
            }
        }

        return products;
    }

    public static List<LineItemResponse> addProductToCartWith(final Integer quantity, final String priceListName, final String productName, final String quoteNumber) {

        List<LineItemResponse> response = new List<LineItemResponse>();
        List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
        final ID priceListId = CPQService.getInstance().priceListIdOfName(priceListName);
        Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsForSearchText(priceListId, productName);
        
        if(productResult == null){
            return response;
        }

        List<Apttus_CPQApi.CPQ.ProductDO> products = productResult.Products;

        if(products.size() == 0){
            return response;
        }       

        for(Apttus_CPQApi.CPQ.ProductDO prDO : products) {
            Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selProdDO.ProductID = prDO.ProductId;
            selProdDO.Quantity = quantity;
            selProdDO.SellingTerm = 12;
            selProdDO.StartDate = Date.Today();
            selProdDO.EndDate = Date.Today() + 12;
            selProdDO.Comments = 'Added by Code';
            selectedProdDOList.add(selProdDO);
        }

        if (selectedProdDOList.size() > 0) {
            Apttus_CPQApi.CPQ.CreateCartResponseDO ccrDO = cartOfQuote(quoteNumber);
            if(ccrDO == null){
                return response;
            }
            Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
            request.CartId = ccrDO.cartId;
            request.SelectedProducts = selectedProdDOList;
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO amprDO = Apttus_CPQApi.CPQWebService.addMultiProducts(request);
            //List<Decimal> lineNumber = amprDO.LineNumbers;
            response = lineItemsOfCart(ccrDO.cartId);
        } 
        return response;
    }
    
    private static List<LineItemResponse> lineItemsOfCart(final ID cartId) {

        List<LineItemResponse> lirs = new List<LineItemResponse>();

        List<Apttus_Config2__LineItem__c> liSOList = [select id, Name,
                                          Apttus_Config2__Description__c,
                                          Apttus_Config2__Quantity__c, Apttus_Config2__ListPrice__c, Apttus_Config2__NetPrice__c,
                                          Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :cartId];

        for (Apttus_Config2__LineItem__c liSO : liSOList) {
            LineItemResponse lir = new LineItemResponse();
            lir.id = liSO.Id;
            lir.name = liSO.Name;
            lir.productName = liSO.Apttus_Config2__Description__c;
            lir.quantity = liSO.Apttus_Config2__Quantity__c;
            lir.listPrice = liSO.Apttus_Config2__ListPrice__c;
            lir.netPrice = liSO.Apttus_Config2__NetPrice__c;
            lir.lineNumber = liSO.Apttus_Config2__LineNumber__c;
            lirs.add(lir);
        }

        return lirs;
    }

    private static Apttus_CPQApi.CPQ.CreateCartResponseDO cartOfQuote(final String quoteNumber){
        Apttus_CPQApi.CPQ.CreateCartResponseDO response;
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
        List<Apttus_Proposal__Proposal__c> listQuote = [Select Id from Apttus_Proposal__Proposal__c where Name = :quoteNumber LIMIT 1];
        
        if (listQuote != null && listQuote.size() > 0){
            Apttus_Proposal__Proposal__c quote = listQuote.get(0);
            request.QuoteId = quote.Id;
            response = Apttus_CPQApi.CPQWebService.createCart(request);
        }
        return response;
    }

    public static List<LineItemResponse> cartItemsOfQuote(final String quoteNumber) {
        List<LineItemResponse> response = new List<LineItemResponse>();
        Apttus_CPQApi.CPQ.CreateCartResponseDO ccrDO = cartOfQuote(quoteNumber);        
        if(ccrDO == null){
            return response;
        }
        response = lineItemsOfCart(ccrDO.cartId);         
        return response;
    }

}