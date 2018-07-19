xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:= util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $dataLocation1 := util:eval("locator:getDataPath('clinicInfoarchieve')")
let $post-data :=request:get-data()

let $data := for $del in $post-data//clinicInfo
(:             where $del/active = 'true':)
             return
             let $filename := concat('ClinicInfo-',$del//id ,'.xml') 
             let $update_status := xmldb:remove($dataLocation,$filename)
              let $update_status := xmldb:store($dataLocation1,$filename,$del)
             return
                 $del//id
return
(:    $data:)
<messageData>{
    <message>Selected Item has been Deleted successfully</message>
}</messageData>
