public class RVApplication{

    // Configure and create the UnitOfWorkFactory for this Application
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType> {
                    Apttus_Config2__LineItem__c.SObjectType
                }); 

    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service = 
        new fflib_Application.ServiceFactory(
            new Map<Type, Type> {
                    RVICPQService.class => RVCPQServiceImpl.class
                });

    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector = 
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type> {
                    Apttus_Config2__LineItem__c.SObjectType => RVLineItemsSelector.class
                });

    // Configure and create the DomainFactory for this Application
    public static final fflib_Application.DomainFactory Domain = 
        new fflib_Application.DomainFactory(
            RVApplication.Selector,
            new Map<SObjectType, Type> {
                    Apttus_Config2__LineItem__c.SObjectType => RVLineItems.Constructor.class
                });

    // Configure and create the ExternalServiceFactory for this Application
    public static final fflib_Application.ExternalServiceFactory ExternalService =
        new fflib_Application.ExternalServiceFactory(
            new Map<Type, Type> {
                	RVCPQDomainHelper.Category.class    => RVCategories.class,
                    RVCPQDomainHelper.Product.class     => RVProducts.class,
                    RVCPQDomainHelper.LineItem.class    => RVLineItems.class
                });

}