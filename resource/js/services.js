
var services = angular.module('clinicInfo.services', []);

services.factory('clinicInfoService', ['$http', 'makeurl', function ($http, makeurl) {

    function errFunction(response) {
//        Flash.create('danger', response.status + response.statusText)
    }

    /** =============== JSON2XML & XML2JSON Converstion ==================== **/

    function xml2json(response) {
        var x2js = new X2JS({
            arrayAccessFormPaths: [
            "data.clinicInfo",
            "data.clinicInfo.images.image",
           "data.clinicInfo.specializations.specialization",
          "data.clinicInfo.services.service",
          "data.clinicInfo.doctors.doctor",
          "data.uploadHistory",
          "data.doctorInfo",
          "data.doctorInfo.workLocation.location",
        ]
        });
        return x2js.xml_str2json(response.data);
    }

    function json2xml(data) {
        var js2x = new X2JS();
        // console.log(js2x.json2xml_str(JSON.parse(data)));
        return js2x.json2xml_str(JSON.parse(data));
    }



    var obj = {};

    /** =============== GET Methods ==================== **/

    obj.getSchema = function () {
            return $http({
                method: "GET",
                url: makeurl + "data/clinicInfo.json"
            }).then(function (response) {
                return response.data;
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in retriving schema. Uploading data may not work');
                errFunction(response);
            });
        },
    obj.getDoctorSchema = function () {
            return $http({
                method: "GET",
                url: makeurl + "data/doctorInfo.json"
            }).then(function (response) {
                return response.data;
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in retriving doctor schema.');
                errFunction(response);
            });
        },
        obj.retriveClinicInfo = function () {
            return $http({
                method: "GET",
                url: makeurl + "service/clinicInfo_Read.xml",
                cache: false
            }).then(function (response) {
                //Converting XML to JSON

                return xml2json(response);

            }, function errorCallback(response) {
                errFunction(response);
            });
        },
   obj.retriveDoctorInfo = function () {
            return $http({
                method: "GET",
                url: makeurl + "service/doctorInfo_Read.xml",
                cache: false
            }).then(function (response) {
                //Converting XML to JSON    

                return xml2json(response);

            }, function errorCallback(response) {
                errFunction(response);
            });
        },
        obj.archiveInfo = function () {
            return $http({
                method: "GET",
                url: makeurl + "service/archive_Read.xml",
                cache: false
            }).then(function (response) {
                //Converting XML to JSON

                return xml2json(response);

            }, function errorCallback(response) {
                errFunction(response);
            });
        },

        obj.changelog = function () {
            return $http({
                method: "GET",
                url: makeurl + "service/changeLog_Read.xml",
                cache: false
            }).then(function (response) {
                //Converting XML to JSON
                return xml2json(response);

            }, function errorCallback(response) {
                errFunction(response);
            });
        },

        obj.getActualClinicId = function () {
            return $http({
                method: "GET",
                url: makeurl + "service/counter.xq",
            }).then(function (response) {
                console.log(response);
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in generating auto ID');
                errFunction(response);
            });
        },

        /** =============== POST Methods ==================== **/

        obj.saveClinicInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/clinicInfo_Save.xq",
                data: json2xml(data),
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been Saved Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },
           obj.saveUploadedClinicInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/clinicInfo_Save_Template.xq",
                data: '<data>' +  json2xml(data) + '</data>',
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been Saved Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },
        obj.updateClinicInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/clinicInfo_Update.xq",
                data: json2xml(data),
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been Edited Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },

        obj.deleteClinicInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/clinicInfo_Delete.xq",
                data: '<data>' + json2xml(data) + '</data>',
                headers: {
                    'Content-Type': 'application/xml'
                }
            }).then(function (response) {
                Flash.create('success', 'Record has been deleted Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in Deleteing Data');
                errFunction(response);
            });
        },

        obj.uploadClinicInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/clinicInfo_Save_Template.xq",
                data: '<data>' + json2xml(data) + '</data>',
                headers: {
                    'Content-Type': 'application/xml'
                }
            }).then(function (response) {
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },

        obj.saveChangeLog = function (fileName) {
            return $http({
                method: "POST",
                url: makeurl + "service/changeLog_Save.xq",
                data: '<fileName>' + fileName + '</fileName>',
                headers: {
                    'Content-Type': 'application/xml'
                }
            }).then(function (response) {
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in made file saved entry');
                errFunction(response);
            });
        },
        obj.saveDoctorInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/doctorInfo_Save.xq",
                data: json2xml(data),
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been Saved Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },
          obj.updateDoctorInfo = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/doctorInfo_Update.xq",
                data: json2xml(data),
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been updated Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in saving Data');
                errFunction(response);
            });
        },
        obj.deleteClinicInDoctor = function (data) {
            return $http({
                method: "POST",
                url: makeurl + "service/doctorInfo_delete_clinic.xq",
                data: json2xml(data),
                // data: gyneData,
                headers: {
                    'Content-Type': 'application/xml'
                }

            }).then(function (response) {
                Flash.create('success', 'Record has been removed Successfully');
                return xml2json(response);
            }, function errorCallback(response) {
                Flash.create('danger', 'Problem in removing clinic in DoctorInfo');
                errFunction(response);
            });
        };


    return obj;
}]);