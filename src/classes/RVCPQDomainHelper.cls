global  class RVCPQDomainHelper {

    global class Product{
        public ID id { get; set; }
        public String name { get; set; }
        public String imageUrl { get; set; }
        public Decimal listPrice { get; set; }
        public String description { get; set; }
        public String productCode { get; set; }

        global Product(Apttus_CPQApi.CPQ.ProductDO pr){
            this.id = pr.productId;
            this.name = pr.name;
            this.imageUrl = pr.imageUrl;
            this.listPrice = pr.prices.get(0).Value;
            this.description = pr.description;
            this.productCode = pr.productCode;
        }
    }
    
    global class Category{
        public ID id { get; set; }
        public String name { get; set; }
        public Integer productCount { get; set; }

        global Category(Apttus_CPQApi.CPQ.CategoryDO cat){
            this.id = cat.CategoryId;
            this.name = cat.Name;
            this.productCount = cat.ProductCount;
        }
    }

    global class LineItem{
        public ID id { get; set; }
        public String name { get; set; }
        public ID cartId { get; set; }
    }
}