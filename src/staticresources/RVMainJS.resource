     
  
var App = angular.module('theApp', []);  
     
App.controller('ctrl', ['$scope', '$http', function($scope, $http){
          
var quoteNumber = 'Q-00000000';
var priceListId = 'a200Y0000008byW'

$scope.displayProducts = false;
$scope.categories = [];
$scope.products = [];
$scope.btnActive = [];
$scope.warningMessage = '';
$scope.productsInCart = 0;

Visualforce.remoting.Manager.invokeAction(remote_action_cat, priceListId, function(result, event) {
    if(!event.status){
      $scope.warningMessage = event.message;
    }else{
      $scope.categories = result;
      $scope.warningMessage = '';            
    }
    $scope.$apply();
});

Visualforce.remoting.Manager.invokeAction(remote_action_cart_items_of_quote, quoteNumber, function(result, event) {
    if(!event.status){
      $$scope.productsInCart = 0;
    }else{
      $scope.productsInCart = result.length;          
    }
    $scope.$apply();
});

$scope.submit = function(cat){
      Visualforce.remoting.Manager.invokeAction(remote_action_prod, priceListId, cat.CategoryId__c, function(result, event) {
        $scope.btnActive = [];
        $scope.btnActive[cat.categoryId] = 'active';
        if(!event.status){
            $scope.products = [];
            $scope.warningMessage = event.message;
        }else{
          $scope.products = result;
          $scope.displayProducts = $scope.products.length != 0;
          $scope.warningMessage = '';
      }
      $scope.$apply();
     }); 
};

$scope.addToCart = function(pr){
  Visualforce.remoting.Manager.invokeAction(remote_action_add_prod_to_cart, priceListId, 1, pr.Name, quoteNumber, function(result, event) {
    if(!event.status){
        $scope.warningMessage = event.message;
    }else{
      $scope.productsInCart = result.length;
      $scope.warningMessage = '';
  }
  $scope.$apply();
  });
};
}]);
