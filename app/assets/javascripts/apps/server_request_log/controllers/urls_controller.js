angular.module("server_request_log").controller("urls_controller", ['$scope', 'UrlService', function($scope, UrlService){
  UrlService.urls(function(data){
    $scope.logs_by_day = data;
  });
}]);
