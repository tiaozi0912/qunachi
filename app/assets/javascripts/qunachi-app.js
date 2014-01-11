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
  
  //shared service for communicating between HeaderCtrl and other controllers
  app.factory('SharedService', ['$rootScope', 'navMapping', function($rootScope, navMapping) {
    function onBroadcast(scope, sharedService) {
      scope.$on('nextStep', function() {
        scope.sharedService = sharedService;
      });
    }

    var sharedObj = {
      backBtn: {
        link: "#",
        action: function() {

        }
      },
      selection: {},
      step: 0,
      prepForBroadcast: function(backBtn, step, selection) { //sync with other controllers
        var _this = this;

        $.extend(_this.backBtn, backBtn);
        _this.step = step;
        if (!_.isEmpty(selection)) {
          _this.selection = selection;
        }
        $rootScope.$broadcast('nextStep');
      },
      init: function(scope) {
        scope.sharedService = this;
        onBroadcast(scope, this);
      },
      back: function(scope) {
        this.step -= 1;
        scope.navs.selected = navMapping.list[this.step];
        scope.step = this.step;
        scope.navs.list[this.step] = navMapping.list[this.step];
      }
    };

    return sharedObj;
  }]);

  app.config(function($routeProvider) {
    $routeProvider.
      when('/', {controller: 'SelectCtrl', templateUrl: '/ng-templates/list.html'}).
      when('/restaurants/:id', {controller: 'RestaurantCtrl', templateUrl: '/ng-templates/restaurant.html'}).
      when('/search/:keywords', {controller: 'SearchCtrl', templateUrl: '/ng-templates/search_results.html'}).
      otherwise({redirectTo: '/'});
  });

  app.controller('HeaderCtrl', ['$scope', '$location', 'SharedService', function($scope, $location, SharedService) {
    SharedService.init($scope);

    $scope.search = function(keywords) {
      $scope.showSearchInput = false;

      var path = '/search/' + keywords;
      $location.path(path);
    };

  }]);

  app.controller('SelectCtrl', ['$scope', '$http', 'navMapping', 'SharedService', function($scope, $http, navMapping, SharedService) {
    function init() {
      var list = _.clone(navMapping.list);
      $scope.navs = {
        list: list,
        selected: "菜系"
      };

      $scope.selected = {};
      $scope.step = 0;
    }
    
    SharedService.init($scope);
    init();

    $http.get('/users/categories_cities').success(function(data) {
    	$scope.data = data;
    });

    $scope.selectCategory = function(category, e) {
      e.preventDefault();
      $scope.selected.category = category;
      $scope.navs.selected = "地点";
      $scope.step = 1;
      $scope.navs.list[0] = category.name;

      SharedService.prepForBroadcast({
        link: "#",
        action: function (e) {
          e.preventDefault();
          SharedService.back($scope);
        }
      }, $scope.step);
    };

    $scope.selectCity = function(city, e) {
      e.preventDefault();
      $scope.selected.city = city;
      $scope.navs.selected = "餐馆";
      $scope.step = 2;
      $scope.navs.list[1] = city.name;

      SharedService.prepForBroadcast({
        action: function (e) {
          e.preventDefault();
          SharedService.back($scope);
        }
      }, $scope.step);

      $http.get("/restaurants", {params: {city: $scope.selected.city.name, category: $scope.selected.category.name}}).success(function(res) {
        //preprocess data
        _.each(res.restaurants, function(r) {
          r.link = "#/restaurants/" + r.id;
        });
        $scope.data = $.extend($scope.data, res);
      });
    };
  }]);

  app.controller('RestaurantCtrl', ['$scope', '$http', '$routeParams', 'SharedService', 'navMapping', function($scope, $http, $routeParams, SharedService, navMapping) {
    SharedService.init($scope);
    
    //TODO: just back to the previous step
    SharedService.prepForBroadcast({
      action: function(e) {}
    }, 3);

    var url = "/restaurants/" + $routeParams.id;

    $http.get(url).success(function(data) {
      $scope.r = data.restaurant;
    });
  }]);

  app.controller('SearchCtrl', ['$scope', '$routeParams', function($scope, $routeParams) {
    var keywords = $routeParams.keywords,
        url = '/restaurants/search';

    $.get(url, {keywords: keywords}, function(data) {
      $scope.restaurants = data.restaurants;
      $scope.$apply();
    });

  }]);

})();