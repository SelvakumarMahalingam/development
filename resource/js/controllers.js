/**
 * Created by RajaGopal S on 09/01/2016.
 */
angular.module('clinicInfo.controllers', [])


.controller('ParentController', ['$rootScope', 'clinicInfoService', function ($rootScope, clinicInfoService) {

    clinicInfoService.getSchema()
        .then(function (response) {
            $rootScope.schema = response;
        });
  clinicInfoService.getDoctorSchema()
        .then(function (response) {
            // console.log(response);
            $rootScope.doctorSchema = response;
        });
        $rootScope.getDoctors = function() {
              clinicInfoService.retriveDoctorInfo()
            .then(function (response) {
                $rootScope.resdata = response.data.doctorInfo;
            })
            .finally(function () {
            });
        }
        $rootScope.getDoctors();
}])


.controller('clinicInfoCtrl', ['$scope', '$rootScope', '$timeout', 'clinicInfoService', '$mdDialog', function ($scope, $rootScope, $timeout, clinicInfoService, $mdDialog) {

        $scope.selected = [];
   $scope.query = {
        order: 'id',
        limit: 10,
        page: 1
    };
     
    $scope.refresh = function () {
        $rootScope.clinicinfo();
         $rootScope.getDoctors();
    }

    $rootScope.clinicinfo = function () {
        $rootScope.loading++;
        clinicInfoService.retriveClinicInfo()
            .then(function (response) {
                $rootScope.clinicDatasCount = response.data.clinicInfo.length;
                $rootScope.clinicDatas = response.data;
            })
            .finally(function () {
                $rootScope.loading--;
            });
    }

    $scope.deleteSelected = function (ev, selected) {

        var confirm = $mdDialog.confirm()
            .title('Would you like to delete selected data?')
            .textContent('Deleted Data may not be recovered back. Be careful')
            .ariaLabel('delete')
            .targetEvent(ev)
            .ok('YES Delete It!')
            .cancel('Cancel');
        $mdDialog.show(confirm).then(function () {
            var jsondata = '{"clinicInfo":' + angular.toJson(selected) + '}';
            $rootScope.loading++;
            clinicInfoService.deleteClinicInfo(jsondata)
                .then(function (response) {
                    if (response) {
                        $rootScope.clinicinfo();
                    }
                })
                .finally(function () {
                    $rootScope.loading--;
                    $rootScope.refreshArchive();
                });


        });
    };

    $rootScope.clinicinfo();

}])

.controller('addEditCtrl', ['$scope', '$rootScope', 'clinicInfoService', '$state', '$stateParams', 'Upload', '$timeout', 'makeurl', '$log', function ($scope, $rootScope, clinicInfoService, $state, $stateParams, Upload, $timeout, makeurl, $log) {

    $scope.d_id = "";
    $scope.d_name = ""
    $scope.clinicInfo  = {};
    // console.log($stateParams);
    var mode = $stateParams.postMode;
    if ($stateParams.passModelData != null) {
        $scope.clinicInfo = angular.copy($stateParams.passModelData);
    } else {
        $scope.clinicInfo = angular.copy($rootScope.schema);
    }
        if (mode != 'edit') {
            $rootScope.loading++;
            clinicInfoService.getActualClinicId()
                .then(function (response) {
                    if (response) {
                        $scope.clinicInfo.id = response.data.lastId._id;
                    }
                })
                .finally(function () {
                    $rootScope.loading--;
                });
        }
    if ($scope.clinicInfo.specializations.specialization[0] == '') {
        $scope.clinicInfo.specializations.specialization.splice(0, 1);
    }
    if ($scope.clinicInfo.services.service[0] == '') {
        $scope.clinicInfo.services.service.splice(0, 1);
    }
 
    $scope.empty= function () {
        $scope.logoImg = null;
        $scope.clinicInfo.logo= '';
    }
    $scope.emptygal = function () {
        $scope.galleryImgs = null;
        $scope.clinicInfo.images.image = [""];
    }
 
    $scope.addDoctor = function (x, y, lmode) {
        
         function addtoClinic(x,y)
        {
            $scope.clinicInfo.doctors.doctor.push({
                "_id": x,
                "_name": y
            });
        }
        
        $scope.selected = false;
        if(lmode == 'update') {
            addtoClinic(x,y);
            $scope.selectedDoctor.workLocation.location.push({"location_type": 'clinic', "location_id": $scope.clinicInfo.id, "location_name" : $scope.clinicInfo.name, "location_logo" :'', "workLocationType": 'primary'});
            var jsonModelData = '{"doctorInfo":' + angular.toJson($scope.selectedDoctor) + '}';
            $rootScope.loading++;
             clinicInfoService.updateDoctorInfo(jsonModelData)
            .then(function (response) {
                if (response) {
                    console.log('DoctorInfo Updated');
                }
            })
            .finally(function () {
                $rootScope.loading--;
            });
        }
        if (lmode == 'addnew')
        {
            $scope.newdoctorInfo = angular.copy($rootScope.doctorSchema);
            delete $scope.newdoctorInfo['id'];
            $scope.newdoctorInfo.name = y;
            $scope.newdoctorInfo.workLocation.location.push({"location_type": 'clinic', "location_id": $scope.clinicInfo.id, "location_name" : $scope.clinicInfo.name, "location_logo" :'', "workLocationType": 'primary'});
            // console.log($scope.newclinicInfo);
            var jsonModelData = '{"doctorInfo":' + angular.toJson($scope.newdoctorInfo) + '}';
            $rootScope.loading++;
            clinicInfoService.saveDoctorInfo(jsonModelData)
            .then(function (response) {
                if (response) {
                    $scope.msg = true;
                    var newDoctorID = response.doctorInfo.id;
                    var DoctorName = response.doctorInfo.name;
                    addtoClinic(newDoctorID,DoctorName);
                }
            })
            .finally(function () {
                $rootScope.loading--;
                $rootScope.getDoctors();
                $timeout(function () {
                    $scope.repos = loadAll();
                    $scope.msg = false;
                }, 5000);

            });
        }
    };
    
    
    $scope.removeDoctor = function (index) {
        var toBeRemove=$scope.clinicInfo.doctors.doctor[index];
        toBeRemove._clinicId=$scope.clinicInfo.id;
        toBeRemove._clinicName=$scope.clinicInfo.name;
        
        var finalRemove = '{ "data" : '+ angular.toJson(toBeRemove)  +'}';
        $rootScope.loading++;
        clinicInfoService.deleteClinicInDoctor(finalRemove)
                    .then(function (response) {
                        if (response) {
                            console.log('Removed successfully');
                            $scope.clinicInfo.doctors.doctor.splice(index, 1);
                        }
                    })
                    .finally(function () {
                        $rootScope.loading--;
                    });
        
        
    };

    $rootScope.postClinicData = function (logo, gallery) {

        // console.log(logo);
        // console.log(gallery);

            finalsend();
     
        function finalsend() {

            $rootScope.loading++;


            /** ===== Image Uploads Starts Here ===== **/

            if (logo) {
                var ext = '.' + logo.name.split('.').pop();
                Upload.rename(logo, 'clinic-' + $scope.clinicInfo.id + '-logo' + ext);
                $scope.clinicInfo.logo = logo.ngfName;
                // console.log($scope.clinicInfo.logo);
                logo.upload = Upload.upload({
                    url: makeurl + 'service/imageUpload.xq',
                    data: {
                        file: logo
                    },
                });

                logo.upload.then(function (response) {
                    $timeout(function () {
                        logo.result = response.data;
                    });
                }, function (response) {
                    if (response.status > 0)
                        $scope.errorMsg = response.status + ': ' + response.data;
                }, function (evt) {
                    logo.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total));
                })
                .finally(function(){
                    $scope.galleryImgs = null;
                });
            }
            if (gallery) {
                // var i = $scope.clinicInfo.images.image.length + 1;
                var i = 1;
                angular.forEach(gallery, function (img) {
                    
                    var ext = '.' + img.name.split('.').pop();
                    // console.log($scope.galleryImgs[i-1]);
                    Upload.rename(img, 'clinic-' + $scope.clinicInfo.id + '-gallery-' + i + ext);
                     i++;
                    // console.log(img);
                    $scope.clinicInfo.images.image.push(img.ngfName);
                    // console.log($scope.clinicInfo.images);

                    gallery.upload = Upload.upload({
                        url: makeurl + 'service/imageUpload.xq',
                        data: {
                            file: img
                        }
                    });

                    gallery.upload.then(function (response) {
                        $timeout(function () {
                            gallery.result = response.data;
                           
                        });
                    }, function (response) {
                        if (response.status > 0)
                            $scope.errorMsg = response.status + ': ' + response.data;
                    }, function (evt) {
                        gallery.progress = Math.min(100, parseInt(100.0 *
                            evt.loaded / evt.total));
                    })
                    .finally(function(){
                        $scope.galleryImgs=null;
                    });
                });
            }

            /** ===== Image Uploads End Starts Here ===== **/

            var sendJson = angular.toJson($scope.clinicInfo);
            var jsonModelData = '{"clinicInfo":' + sendJson + '}';
            
            if(mode == 'edit')
            {
                clinicInfoService.updateClinicInfo(jsonModelData)
                    .then(function (response) {
                        if (response) {
                            console.log('saved successfully');
                        }
                    })
                    .finally(function () {
                        $state.go('clinicInfo');
                        $rootScope.loading--;
                    });
            }
            else
            {
                clinicInfoService.saveClinicInfo(jsonModelData)
                .then(function (response) {
                    if (response) {
                        $rootScope.clinicinfo();
                    }
                })
                .finally(function () {
                    $state.go('clinicInfo');
                    $rootScope.loading--;
                });
            }
          
        }

    };
    
    $scope.simulateQuery = false;
    $scope.isDisabled = false;
    $scope.repos = loadAll();
    $scope.querySearch = function (query) {
        var results = query ? $scope.repos.filter(createFilterFor(query)) : $scope.repos,
            deferred;
        if ($scope.simulateQuery) {
            deferred = $q.defer();
            $timeout(function () {
                deferred.resolve(results);
            }, Math.random() * 1000, false);
            return deferred.promise;
        } else {
            return results;
        }
    }
    $scope.searchTextChange = function (text) {
        $log.info('Text changed to ' + text);
        $scope.typingtext = text;
    }
    $scope.selectedItemChange = function (item) {
        $log.info('Item changed to ' + JSON.stringify(item));
        $scope.selectedDoctor = item;
        $scope.selected = true;
    }

    function loadAll() {
         if($rootScope.resdata != undefined)
        {
            var repos = $rootScope.resdata;
            return repos.map(function (repo) {
                repo.value = repo.name.toLowerCase();
                return repo;
            });
        }
        else
            return null;

    }

    function createFilterFor(query) {
        var lowercaseQuery = angular.lowercase(query);
        return function filterFn(item) {
            return (item.value.indexOf(lowercaseQuery) === 0);
        };
    }

}])

.controller('viewCtrl', ['$scope', '$state', '$stateParams', function ($scope, $state, $stateParams){
    $scope.clinicInfo = angular.copy($stateParams.passModelData);
     $scope.slickConfigLoaded = true;
    $scope.slickConfig = {
        method: {},
        dots: true,
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        fade: true,
        asNavFor: '.smallslider'
    };
    $scope.slickConfigsmallLoaded = true;
    $scope.slickConfigsmall = {
        method: {},
        dots: false,
        infinite: true,
        slidesToShow: 6,
        slidesToScroll: 1,
        asNavFor: '.slider',
        focusOnSelect: true,
        responsive: [
            {
                breakpoint: 768,
                settings: {
                    slidesToShow: 3,
                    arrows: false,
                    centerMode: true
                }
    },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 2,
                    arrows: false,
                    centerMode: true
                }
    },
            {
                breakpoint: 360,
                settings: {
                    slidesToShow: 2,
                    arrows: false,
                    centerMode: true
                }
    },
            {
                breakpoint: 320,
                settings: {
                    slidesToShow: 2,
                    arrows: false,
                    centerMode: true
                }
    }
  ]

    };
    $scope.$on('mapInitialized', function(event, map) {
        $scope.map = map;
    });
}])

.controller('archiveCtrl', ['$scope', '$rootScope', 'clinicInfoService', function ($scope, $rootScope, clinicInfoService) {

    $scope.query = {
        order: 'archivedby.__dateTime',
        limit: 10,
        page: 1
    };

    $rootScope.refreshArchive = function () {
        $rootScope.loading++;
        clinicInfoService.archiveInfo()
            .then(function (response) {
                $rootScope.archiveDatasCount = response.data.clinicInfo.length;
                $rootScope.archiveDatas = response.data;
            })
            .finally(function () {
                $rootScope.loading--;
            });
    };
    $rootScope.refreshArchive();
}])

.controller('changeLogCtrl', ['$scope', '$rootScope', 'clinicInfoService', function ($scope, $rootScope, clinicInfoService) {

    $scope.query = {
        order: '_id',
        limit: 10,
        page: 1
    };

    $rootScope.getchangeLog = function () {
        $rootScope.loading++;
        clinicInfoService.changelog()
            .then(function (response) {
                if (response != null) {
                    $scope.uploadHistoryDatasCount = response.data.uploadHistory.length;
                    $scope.uploadHistoryDatas = response.data.uploadHistory;
                    // console.log($scope.uploadHistoryDatas);
                } else $scope.filehistoryEmpty = true;

            })
            .finally(function () {
                $rootScope.loading--;
            });
    };

    $rootScope.savechangelog = function (filename) {
        $rootScope.loading++;
        clinicInfoService.saveChangeLog(filename)
            .then(function (response) {
                $rootScope.getchangeLog();
            })
            .finally(function () {
                $rootScope.loading--;
            });
    };

    $rootScope.getchangeLog();

}])

.controller('templateCtrl', ['$scope', '$rootScope', 'clinicInfoService', 'Upload', '$timeout', 'makeurl', 'Flash', '$window', function ($scope, $rootScope, clinicInfoService, Upload, $timeout, makeurl, Flash, $window) {

    $scope.query = {
        order: '_sno',
        limit: 10,
        page: 1
    };
    $scope.selected_post_data = [];
    $scope.uploadFiles = function (file, errFiles) {
        $scope.f = file;
        $scope.errFile = errFiles && errFiles[0];
        if (file) {
            file.upload = Upload.upload({
                url: makeurl + 'service/templateUpload.xq',
                data: {
                    file: file
                }
            });

            file.upload.then(function (response) {
                $timeout(function () {
                    file.result = response.data;
                });
            }, function (response) {
                if (response.status > 0) $scope.errorMsg = response.status + ': ' + response.data;
            }, function (evt) {
                file.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total));
            });
            Papa.parse(file, {
                header: true,
                skipEmptyLines: true,
                complete: function (results, file, err) {
                    // console.log("Parsing complete:", results, file);
                    $scope.results = results.data;
                    $scope.csvlength = results.data.length;

                    $scope.formattedPosteddata = [];

                    for (var i = 0; i <= results.data.length - 1; i++) {
                        // console.log(i);
                        var temp = parseandmatchjson($rootScope.schema, results.data[i]);
                        $scope.formattedPosteddata.push(temp);
                    }

                    $scope.showPostData = true;
                }
            });
        }

        $scope.clearAll = function () {
            $scope.showPostData = false;
            $scope.formattedPosteddata = formattedPosteddata = [];

        };
        $scope.deletecsvrecord = function(index)
        {
            $scope.formattedPosteddata.splice(index, 1);
        }
        $scope.startSaving = function () {
            var jsonPostedModelData = '{ "clinicInfo" :' + angular.toJson($scope.formattedPosteddata) + '}';
            $rootScope.loading++;
            clinicInfoService.saveUploadedClinicInfo(jsonPostedModelData)
                .then(function (response) {
                    if (response) {
                        $rootScope.clinicinfo();
                        Flash.create('success', $scope.formattedPosteddata.length + " have been added successfully");
                        $scope.clearAll();
                        //Saving changelog
                        $rootScope.savechangelog(file.name);
                    }
                })
                .
            finally(function () {
                $rootScope.loading--;
            });
        };
        $scope.clearAll = function () {
            $scope.showPostData = false;
            $scope.results = $scope.formattedPosteddata = formattedPosteddata = [];

        };

    };
    $scope.callDownload = function(){
        $window.location.href = $rootScope.downLoc;
    }
    
}]);





      var countryApp = angular.module('countryApp', ['ngRoute']);
       countryApp.config(function($routeProvider) {
        $routeProvider.
          when('/', {
            templateUrl: 'country-list.html',
            controller: 'CountryListCtrl'
          }).
          when('/:countryName', {
            templateUrl: 'country-detail.html',
            controller: 'CountryDetailCtrl'
          }).
          otherwise({
            redirectTo: '/'
          });
      });

      countryApp.factory('countries', function($http){
        return {
          list: function(callback){
            $http.get('countries.json').success(callback);
          },
          find: function(name, callback){
            $http.get('countries.json').success(function(data) {
              var country = data.filter(function(entry){
                return entry.name === name;
              })[0];
              callback(country);
            });
          }
        };
      });

      countryApp.controller('CountryListCtrl', function ($scope, countries){
        countries.list(function(countries) {
          $scope.countries = countries;
        });
      });

      countryApp.controller('CountryDetailCtrl', function ($scope, $routeParams, countries){
        countries.find($routeParams.countryName, function(country) {
          $scope.country = country;
        });
      });