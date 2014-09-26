angular.module("server_request_log").factory("UrlService", [
  '$http',

  function($http){
    var service = {};
    service.urls = function(){
      return $http.get('/server_request_logs/top_urls.json');
    }
    service.referrers = function(){
      return $http.get('/server_request_logs/top_referrers.json');
    }
    return service;
  }
]);
