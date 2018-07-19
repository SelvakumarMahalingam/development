xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:= util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $clinicInfoLocation := util:eval("locator:getDataPath('clinicInfo')")
let $clinicArchieveLocation := util:eval("locator:getDataPath('clinicInfoArchive')")

let $hintLocation := util:eval("locator:getDataPath('searchHints')")
let $profileStatusLoc := util:eval("locator:getDataPath('profileStatusInfo')") 

let $post-data := request:get-data()

let $data := for $del in $post-data//clinicInfo
             return
            let $clinicInfoFile := concat('clinicInfo-',$del//id ,'.xml') 
            let $hintFile := concat('hint-clinicInfo-',$del//id ,'.xml') 
            let $profileStatusFile := concat('profileStatus-clinicInfo-',$del//id ,'.xml') 
            let $remove_clinicInfoFile := xmldb:remove($clinicInfoLocation,$clinicInfoFile)
             let $archive_detail :=<clinicInfo>
                                        <archivedby dateTime="{current-dateTime()}">{xmldb:get-current-user()}</archivedby>
                                        {$del/node()}
                                   </clinicInfo>
             let $store_archieve := xmldb:store($clinicArchieveLocation,$clinicInfoFile,$archive_detail)
             let $remove_hintFile := xmldb:remove($hintLocation,$hintFile)
             let $remove_statusFile := xmldb:remove($profileStatusLoc,$profileStatusFile)
             return
                 $archive_detail
return
(:    $data:)
<messageData>{
    <message>Selected Item has been Deleted successfully</message>
}</messageData>