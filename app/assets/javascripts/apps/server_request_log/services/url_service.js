angular.module("server_request_log").factory("UrlService", [
  '$http',

  function($http){
    var service = {};
    service.urls = function(fn){

      $http.get('/server_request_logs/top_urls.json')
        .success(function(data){
          return fn(data);
        })
    }
    return service;
  }
]);
