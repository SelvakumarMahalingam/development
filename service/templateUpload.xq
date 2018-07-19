xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"FrontOfficeLocator",$conf/config/appServices/service[@name="locator"]/location)
let $vaccineLocation := util:eval("FrontOfficeLocator:getDataPath('clinicInfoCSV')")
(:return $vaccineLocation:)
let $filename := request:get-uploaded-file-name('file')

(: make sure you use the right user permissions that has write access to this collection :)
let $store := xmldb:store($vaccineLocation, $filename, request:get-uploaded-file-data('file'))

return
<results>
   <message>File {$filename} has been stored at collection={$vaccineLocation}.</message>
</results>
