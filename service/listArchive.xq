(:xquery version "3.0";:)
(:let $conf := doc('../../../conf.xml'):)
(:let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location):)
(:let $dataLocation := util:eval("locator:getDataPath('clinicInfoarchieve')"):)
(:let $collection :=    for $data in collection($dataLocation):)
(:            return:)
(:                $data:)
(:                    :)
(:return :)
(:<data>{$collection}</data>:)



xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('clinicInfoarchieve')")
return
<data>{
for $hospital in collection($dataLocation)//clinicInfo
return $hospital
}</data>

