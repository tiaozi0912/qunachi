window.qunachiApp = angular.module('qunachiApp', ['ngRoute']);
(function() {
  qunachiApp.factory('navMapping', [function() {
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
  qunachiApp.factory('SharedService', ['$rootScope', 'navMapping', function($rootScope, navMapping) {
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
      prepForBroadcast: function(backBtn, step, selection) { 
        //sync with other controllers
        //step: the current step; 
        //backBtn: set the link of the btn and action; action will be called when the back btn is clicked
        var _this = this;
        
        if (backBtn !== null && typeof backBtn !== 'undefined') {
          $.extend(_this.backBtn, backBtn);
        }
        
        if (step !== null && typeof step !== 'undefined') {
          _this.step = step;
        }

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
        if (this.step > 0) {
          this.step -= 1;
          scope.navs.selected = navMapping.list[this.step];
          scope.step = this.step;
          scope.navs.list[this.step] = navMapping.list[this.step];
        }
      }
    };

    return sharedObj;
  }]);

  qunachiApp.config(['$routeProvider', function($routeProvider) {
    $routeProvider.
      when('/', {controller: 'SelectCtrl', templateUrl: '/ng-templates/list.html'}).
      when('/restaurants/:id', {controller: 'RestaurantCtrl', templateUrl: '/ng-templates/restaurant.html'}).
      when('/search/:keywords', {controller: 'SearchCtrl', templateUrl: '/ng-templates/search_results.html'}).
      otherwise({redirectTo: '/'});
  }]);
  
  //controllers start 
  qunachiApp.controller('HeaderCtrl', ['$scope', '$location', 'SharedService', function($scope, $location, SharedService) {
    SharedService.init($scope);

    $scope.search = function(keywords) {
      $scope.showSearchInput = false;

      var path = '/search/' + keywords;
      $location.path(path);
    };

  }]);

  qunachiApp.controller('SelectCtrl', ['$scope', '$http', 'navMapping', 'SharedService', function($scope, $http, navMapping, SharedService) {
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
        _.each(res.restaurants.matched, function(r) {
          r.link = "#/restaurants/" + r.id;
        });
        $scope.matchedRestaurants = res.restaurants.matched;
      });
    };

    $scope.restart = function(e) {
      e.preventDefault();
      init();
      SharedService.prepForBroadcast(null, $scope.step);
    }
  }]);

  qunachiApp.controller('RestaurantCtrl', ['$scope', '$http', '$routeParams', '$location', 'SharedService', 'navMapping', function($scope, $http, $routeParams, $location, SharedService, navMapping) {
    SharedService.init($scope);
    
    //TODO: just back to the previous step
    SharedService.prepForBroadcast({
      action: function(e) {
        SharedService.step = 0;
      }
    }, 3);

    var url = "/restaurants/" + $routeParams.id;

    $http.get(url).success(function(data) {
      $scope.r = data.restaurant;
    });

    $scope.restart = function(e) {
      e.preventDefault();
      SharedService.step = 0;
      SharedService.prepForBroadcast();
      $location.path('#');
    }
  }]);

  qunachiApp.controller('SearchCtrl', ['$scope', '$routeParams', '$location', 'SharedService', function($scope, $routeParams, $location, SharedService) {
    SharedService.init($scope);
    SharedService.prepForBroadcast({
      link: "#",
      action: function(e) {
        e.preventDefault();
        SharedService.step = 0;
        $location.path(this.link);
      }
    }, 1);

    var keywords = $routeParams.keywords,
        url = '/restaurants/search';

    $.get(url, {keywords: keywords}, function(data) {
      $scope.restaurants = data.restaurants;
      $scope.$apply();
    });

  }]);
})();