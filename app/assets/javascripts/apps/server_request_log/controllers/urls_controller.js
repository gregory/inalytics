angular.module("server_request_log").controller("urls_controller", ['$scope', 'urls', 'log_type', function($scope, urls, log_type){
  $scope.logs_by_day = urls.data;
  $scope.log_type = log_type;
}]);
