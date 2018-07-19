
(function () {


        var srcurl = document.currentScript.src;
        var makeurl ='';
        var fileFolder = 'clinicInfoCSV';
        var fileLoc = 'clinicInfoCSV/clinictemplate.csv';
        var downLoc = 'data/seedData/clinicInfoCSV/clinictemplate.csv';

    angular.module('clinicInfo', ['ngMaterial', 'ngMessages','ui.router','clinicInfo.controllers','clinicInfo.services','ngMap','md.data.table','ngFileUpload','slickCarousel','flash'])


    .constant('makeurl', makeurl)
    .constant('downLoc', downLoc)
     

    .run(function ($rootScope) {
        $rootScope.makeurl = makeurl;
        $rootScope.downLoc = downLoc;
        $rootScope.loading = 0;

    })

    .config(function ($stateProvider, $urlRouterProvider) {

        $urlRouterProvider.otherwise("/")

        $stateProvider
            .state('clinicInfo', {
                url: "/",
                templateUrl: makeurl + 'partials/main.html',
                controller: 'clinicInfoCtrl'
            })
            .state('addEditClinic', {
                url: "/addEdit",
                templateUrl: makeurl + 'partials/clinicForm.html',
                controller: 'addEditCtrl',
                params: {
                    passModelData: null,
                    postMode: null
                }
            })
             .state('viewClinic', {
                url: "/viewClinic",
                templateUrl: makeurl + 'partials/clinicView.html',
                controller: 'viewCtrl',
                params: {
                    passModelData: null
                }
            })
    })

    .directive('empty', function ($parse) {
        return {
            require: '?ngModel',
            link: function (scope, element, attrs, ngModel) {
                var ngModelGet = $parse(attrs.ngModel);
                scope.$watch(attrs.ngModel, function () {
                    if (ngModelGet(scope) == undefined && angular.isObject(ngModel) && (!attrs.type || attrs.type === 'text')) {
                        var model = $parse(attrs.ngModel);
                        model.assign(scope, '');
                    }
                });
            }
        }
    });


})();