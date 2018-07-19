xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)let $y:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)
let $dataLocation := util:eval("platformServices:platformDir()")
let $data := replace($dataLocation,'/','')
let $counter-name := <data><counterName>{concat($data,':','Appointment')}</counterName></data>
let $init-value := 0
let $Create := counter:create($counter-name,$init-value) 

let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $post-data := request:get-data()
let $currentSolution := util:eval("locator:getSolutionName()")
    let $location := util:eval("platformServices:getDataDir('searchHints')")
    let $profilelocation   := util:eval("locator:getDataPath('profileStatusInfo')")
    
    let $doc := $post-data
    let $currentUser := xmldb:get-current-user()
    let $id := $doc/id/text()
    let $name := $doc/name/text()
    
    
    
    
let $output := for $task in $post-data//clinicInfo
let $search :=counter:next-value($counter-name)
let $name := $task//name/text()
let $searchHint :=
<searchHint>
        <id>{$search}</id>
        <origin type="data" profile="clinic" solution="{$currentSolution}" dataKey="clinicInfo" xpath="$clinic/name"/>
        <solution>{$currentSolution}</solution>
        <pattern>Clinics/{$name}</pattern>
        <text>{$name}</text>
        <type>clinicProfile</type>
    </searchHint>
         
    let $profile-status :=
                <profileStatusInfo> 
                    <dataKey>clinicInfo</dataKey>
                    <data id="{$search}" name="{$name}"/>
                    <created>{current-dateTime()}</created>
                    <lastModified></lastModified>
                    <creator id="{$currentUser}" name=""/>
                    <owner id="" name=""/>
                    <moderator id="" name=""/>
                    <agency id="" name=""/>
                    <verified>false</verified>
                    <premium>false</premium>
                    <featured>false</featured>
                    <solution enabled="false" id="" noofvisits=""/>
                    <website enabled="false" url=""/>                   
                </profileStatusInfo>              

                return
            
                 let $xml:= <clinicInfo>
                     <active/>
                                <id>{$search}</id>
                                <name>{$task/name/text()}</name>
                                <categories>
                                    <category>{$task/categories/category/text()}</category>
                                </categories>
                                <description>{$task/description/text()}</description>
                                 <website>{$task/website/text()}</website>
                                 <overview>{$task/overview/text()}</overview>
                                  <location type="{$task/location/type/text()}" place="{$task/location/place}" distance="{$task/location/distance}">
                                  <address>
                                        <line1>{$task/location/address/line1/text()}</line1>
                                        <line2>{$task/location/address/line2/text()}</line2>
                                        <line3>{$task/location/address/line3/text()}</line3>
                                        <town>{$task/location/address/town/text()}</town>
                                        <district>{$task/location/address/district/text()}</district>
                                        <city>{$task/location/address/city/text()}</city>
                                        <state>{$task/location/address/state/text()}</state>
                                        <pincode>{$task/location/address/pincode/text()}</pincode>
                                    </address>
                                    <trainStation tname="{$task/location/trainStation/@tname/string()}" tdistance="{$task/location/trainStation/@tdistance/string()}"/>
                                                <busStation bname="{$task/location/busStation/@bname/string()}" bdistance="{$task/location/busStation/@bdistance/string()}"/>
                                                <map>
                                                    <latitude>{$task/location/map/latitude/text()}</latitude>
                                                    <longitude>{$task/location/map/longitude/text()}</longitude>
                                                </map>
                                            </location>
                                            <contactInfo>
                                                    <name>{$task/contactInfo/name/text()}</name>
                                                    <phone>{$task/contactInfo/phone/text()}</phone>
                                                    <mobile>{$task/contactInfo/mobile/text()}</mobile>
                                                    <email>{$task/contactInfo/email/text()}</email>
                                                    <fax>{$task/contactInfo/fax/text()}</fax>
                                            </contactInfo>
                                            <specializations>
                                                    <specialization>{$task/specializations/specialization/text()}</specialization>
                                                </specializations>
                                                <services>
                                                    <service name="{$task/services/service/name/text()}" category="{$task/services/service/category/text()}" type="{$task/services/service/type/text()}"/>
                                                </services>
                                                <doctors>
                                                    <doctor id="{$task/doctors/doctor/id/text()}" name="{$task/doctors/doctor/name/text()}"/>
                                                </doctors>
                            </clinicInfo>
                           
  let $filename1 := concat('ClinicInfo-',$xml//id,'.xml')
  let $profilename := concat('profileStatus-clinicInfo-',$search,'.xml')
    let $store := xmldb:store($profilelocation,$profilename, $profile-status)
    
    let $filename := concat('hint-clinic-',$search,'-clinicName.xml')
    let $store := xmldb:store($location,$filename, $searchHint)
    let $update_status := xmldb:store($dataLocation,$filename1, $xml)   
    return
    $update_status
    
    return   
       <messageData>
           <message>Posted Successfully.</message>
       </messageData>
