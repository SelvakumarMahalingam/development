xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $post-data := request:get-data()
return 
 <messageData>{
     let $filename := concat('clinicInfo-',$post-data//id ,'.xml') 
    let $update_status := xmldb:store($dataLocation,$filename, $post-data)
    return
    <message>Clinic details has been Updated successfully</message>
}</messageData>