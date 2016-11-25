public class RVLineItems extends fflib_SObjectDomain implements RVILineItems{

	public static RVILineItems newInstance(Type theType){
		return (RVILineItems) RVApplication.ExternalService.newInstance(theType);
	}

	public static RVILineItems newInstance(List<SObject> sObjectList){
		return (RVILineItems) RVApplication.Domain.newInstance(sObjectList);
	}

	public RVLineItems(){
		super(new List<SObject>());
	}

	public RVLineItems(List<SObject> sObjectList){
		super(sObjectList);
	}

	public override void onApplyDefaults(){
	}

	public override void onValidate(){
	}

	public override void onValidate(Map<Id, SObject> existingRecords){
	}

	public override void onAfterInsert(){
	}

	public ID addProductToCartWith(ID priceListId, Integer quantity, Id productId, String quoteNumber){

		ID cartId;
		final List<Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
		final Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
		selProdDO.ProductID = productId;
		selProdDO.Quantity = quantity;
		selProdDO.SellingTerm = 12;
		selProdDO.StartDate = Date.Today();
		selProdDO.EndDate = Date.Today() + 12;
		selProdDO.Comments = 'Added by Code';
		selectedProdDOList.add(selProdDO);

		if (selectedProdDOList.size() > 0) {
			Apttus_CPQApi.CPQ.CreateCartResponseDO ccrDO;
			final Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
			final List<Apttus_Proposal__Proposal__c> listQuote = [Select Id from Apttus_Proposal__Proposal__c where Name = :quoteNumber LIMIT 1];

			if (listQuote != null && listQuote.size() > 0){
				Apttus_Proposal__Proposal__c quote = listQuote.get(0);
				request.QuoteId = quote.Id;
				ccrDO = Apttus_CPQApi.CPQWebService.createCart(request);
			}

			if(ccrDO == null){
				return cartId;
			}

			final Apttus_CPQApi.CPQ.AddMultiProductRequestDO request2 = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
			request2.CartId = ccrDO.cartId;
			request2.SelectedProducts = selectedProdDOList;
			final Apttus_CPQApi.CPQ.AddMultiProductResponseDO amprDO = Apttus_CPQApi.CPQWebService.addMultiProducts(request2);
			//List<Decimal> lineNumber = amprDO.LineNumbers;
			//lineItems = lineItemsOfCart(ccrDO.cartId);
			cartId = ccrDO.cartId;
		}

		return cartId;
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new RVLineItems(sObjectList);
		}
	}
}