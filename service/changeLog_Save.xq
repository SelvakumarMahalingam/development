xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $x:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)
let $dataLocation := util:eval("platformServices:platformDir()")

let $counter := ceiling(util:random() * 9999) cast as xs:integer
let $dataLocation := util:eval("locator:getDataPath('clinicInfoUploadHistory')")
let $post-data := request:get-data()
let $data := <uploadHistory>
                    <id>{$counter}</id>
                    <dateTime>{current-dateTime()}</dateTime>
                    <user>{xmldb:get-current-user()}</user>
                    <fileName>{$post-data//fileName/text()}</fileName>
                </uploadHistory>
    let $filename := concat('uploadHistory-',$counter,'.xml') 
    let $update_status := xmldb:store($dataLocation,$filename,$data)
return
    $update_status