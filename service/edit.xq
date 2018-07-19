xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $post-data :=request:get-data()
(:let $post-data := <data><id>02</id></data>:)
for $docter in collection($dataLocation)
where $docter//id = $post-data
return 
    $docter