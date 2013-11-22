(function() {
  var app = angular.module('qunachiApp', []);

  app.factory('navMapping', [function() {
	  var map = {
		  "菜系": "category",
	  	"地点": "cities",
	  	"餐馆": "restaurants"
		},list = [];

		_.each(map, function(v, k) {
      list.push(k);
		});

		return {
			map: map,
			list: list
		}
	}]);

   app.config(function($routeProvider) {
    $routeProvider.
      when('/', {controller: 'SelectCtrl', templateUrl: '/ng-templates/list.html'}).
      when('/restaurants/:id', {controller: 'RestaurantsCtrl', templateUrl: '/ng-templates/restaurant.html'}).
      otherwise({redirectTo: '/'});
  });

  app.controller('SelectCtrl', ['$scope', '$http', 'navMapping', function($scope, $http, navMapping) {
  	$scope.navs = {
  	  list: navMapping.list,
  	  selected: "菜系",
  	};

    $scope.selected = {};
    $scope.step = 0;

    $http.get('/users/categories_cities').success(function(data) {
    	$scope.data = data;
    });

    $scope.selectCategory = function(category, e) {
      e.preventDefault();
      $scope.selected.category = category;
      $scope.navs.selected = "地点";
      $scope.step = 1;
      $scope.navs.list[0] = category.name;
    }

    $scope.selectCity = function(city, e) {
      e.preventDefault();
      $scope.selected.city = city;
      $scope.navs.selected = "餐馆";
      $scope.step = 2;
      $scope.navs.list[1] = city.name;

      $http.get("/restaurants", {params: {city: $scope.selected.city.name, category: $scope.selected.category.name}}).success(function(res) {
        //preprocess data
        _.each(res.restaurants, function(r) {
          r.link = "#/restaurants/" + r.id;
        });
        $scope.data = $.extend($scope.data, res);
      });
    }
  }]);

  app.controller('RestaurantsCtrl', ['$scope', '$http', 'navMapping', function($scope, $http, navMapping) {
    $scope.navs = {
      list: navMapping.list,
      selected: "地点",
    };

    var url = "/categories/" + $routeParams.id + "/cities";

    $http.get(url).success(function(data) {
      //preprocess data
      _.each(data, function(d) {
        d.link = '#/categories/' + d.id;
      });

      $scope.data = data;
    });
  }]);

})();