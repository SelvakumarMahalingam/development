xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $x:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)
let $dataLocation := util:eval("platformServices:platformDir()")
let $data := replace($dataLocation,'/','')
let $counter-name := <data><counterName>{concat($data,':','uploadHistory')}</counterName></data>
let $init-value := 0
let $Create := counter:create($counter-name,$init-value) 
let $counter := counter:next-value($counter-name) 

let $dataLocation := util:eval("locator:getDataPath('uploadHistory')")
let $post-data := request:get-data()
let $data := <uploadHistory>
                    <id>{$counter}</id>
                    <dateTime>{current-dateTime()}</dateTime>
                    <user>{xmldb:get-current-user()}</user>
                    <fileName>{$post-data//fileName/text()}</fileName>
                </uploadHistory>
    let $filename := concat('uploadHistory-',$data/id,'.xml') 
    let $update_status := xmldb:store($dataLocation,$filename,$data)
return
    $update_status

