(function() {
  var app = angular.module('App', []);

	app.factory('RenrenFeeds', ['$http', function($http) {
		return {
			async: function() {
				var promise = $http.get('/get_renren_feeds').then(function(data) {
  	      return data.data;
  	    });

  	    return promise;
			}
		}
	}]);

  app.config(function($routeProvider) {
    $routeProvider.
      when('/renren', {controller: 'RenrenCtrl', templateUrl: '/ng-templates/renren.html'}).
      when('/weibo', {controller: 'WeiboCtrl', templateUrl: '/ng-templates/weibo.html'}).
      when('/fb', {controller: 'FBCtrl', templateUrl: '/ng-templates/fb.html'}).
      otherwise({redirectTo: '/renren'});
  });

	app.controller('RenrenCtrl', ['$scope', 'RenrenFeeds', function($scope, RenrenFeeds) {
    RenrenFeeds.async().then(function(data) {
      $scope.feeds = data.response;

      console.log($scope.feeds);

      var wall = new freewall('.main-content-container');
      wall.reset({
        selector: '.feed-container',
        animate: true,
        onResize: function() {
          wall.fitWidth();
        }
      });
      wall.fitWidth();
    });
	}]);

	app.controller('WeiboCtrl', ['$scope', '$http', function($scope, $http) {
    
	}]);

	app.controller('FBCtrl', ['$scope', '$http', function($scope, $http) {
    
	}]);


})();




