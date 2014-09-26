angular.module("server_request_log", ["ngRoute"])
  .config([
    '$routeProvider',
    function($routeProvider){
      $routeProvider.when("/",{
        controller: 'urls_controller',
        templateUrl: 'urls_template.html',
        resolve: {
          urls: ['UrlService', function(UrlService){
            return UrlService.urls().then(null, function(data){
              console.log("error");
            });
          }],
          log_type: function(){ return 'urls' }
        }
      })
      .when("/referrers",{
        controller: 'urls_controller',
        templateUrl: 'urls_template.html',
        resolve: {
          urls: ['UrlService', function(UrlService){
            return UrlService.referrers().then(null, function(data){
              console.log("error");
            });
          }],
          log_type: function(){ return 'referrers' }
        }
      }).otherwise("/");
    }
  ]);
