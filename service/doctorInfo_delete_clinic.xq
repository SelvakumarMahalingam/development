xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:= util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('doctorInfo')")
let $post-data := request:get-data()
(:let $post-data := <test><data id="35" name="Vijay" clinicId="21" clinicName="CVB Clinic"></data></test>:)

let $data := <data>{for $del in collection($dataLocation)/doctorInfo
                    where $del/id = $post-data//@id
                   return
                     concat('doctorInfo-',$del//id ,'.xml') }</data>
let $doc :=concat($dataLocation,'/',$data)
let $update := for $workLocation in doc($doc)//location
                    where $workLocation/location_id = $post-data//@clinicId
                return 
                    if($workLocation)then
                    let $del-loc := update delete $workLocation
                    return   <messageData>{
                                <message>Selected location has been Deleted successfully.</message>
                            }</messageData>
                    else
                      
                       <messageData>{
                                <message>location doesn't exist.</message>
                            }</messageData>
return
    if($update)then
        $update
        else
  <messageData>{
                    <message>location doesn't exist.</message>
                }</messageData>