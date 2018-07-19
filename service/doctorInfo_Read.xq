xquery version "1.0";
let $conf := doc('../../../conf.xml')
let $x:= util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator", $conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('doctorInfo')")
return
    
    <data>{
        for $doctor in collection($dataLocation)//doctorInfo
        return
            $doctor
    }</data>