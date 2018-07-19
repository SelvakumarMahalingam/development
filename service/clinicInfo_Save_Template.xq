xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)let $y:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)
let $dataLocation := util:eval("platformServices:platformDir()")
let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $post-data := request:get-data()
let $currentSolution := util:eval("locator:getSolutionName()")
let $location := util:eval("platformServices:getDataDir('searchHints')")
let $profilelocation   := util:eval("locator:getDataPath('profileStatusInfo')")
let $doc := $post-data
let $currentUser := xmldb:get-current-user()

let $output := for $task in $post-data//clinicInfo
                    let $clinicId := util:eval("locator:getNextCounterVal('getClinicId')")
                    let $name := $task//name/text()
                    let $clinicIdHint :=
                        <searchHint>
                            <id>{$clinicId}</id>
                            <origin type="data" profile="clinic" solution="{$currentSolution}" dataKey="clinicInfo" xpath="$clinic/name"/>
                            <solution>{$currentSolution}</solution>
                            <pattern>Clinics/{$name}</pattern>
                            <text>{$name}</text>
                            <type>clinicProfile</type>
                        </searchHint>
                             
                    let $profile-status :=
                        <profileStatusInfo> 
                            <dataKey>clinicInfo</dataKey>
                            <data id="{$clinicId}" name="{$name}"/>
                            <created>{current-dateTime()}</created>
                            <lastModified></lastModified>
                            <creator id="" name="{$currentUser}"/>
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
                                
                            let $xml:= 
                            
                                <clinicInfo>
                                    <id>{$clinicId}</id>
                                    <name>{$task/name/text()}</name>
                                    <logo></logo>
                                    <images>
                                        <image></image>
                                    </images>
                                    <categories>
                                        <category>{$task/categories/category/text()}</category>
                                    </categories>
                                    <description>{$task/description/text()}</description>
                                    <website>{$task/website/text()}</website>
                                    <overview>{$task/overview/text()}</overview>
                                    <location>
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
                                        <phone>{$task/contactInfo/phone/text()}</phone>
                                        <mobile>{$task/contactInfo/mobile/text()}</mobile>
                                        <email>{$task/contactInfo/email/text()}</email>
                                        <fax>{$task/contactInfo/fax/text()}</fax>
                                    </contactInfo>
                                    <specializations>
                                        <specialization>{$task/specializations/specialization/text()}</specialization>
                                    </specializations>
                                    <services>
                                        <service>{$task/services/service/text()}</service>
                                    </services>
                                    <doctors>
                                        <doctor id="{$task/doctors/doctor/id/text()}" name="{$task/doctors/doctor/name/text()}"/>
                                    </doctors>
                                </clinicInfo>
                                               
                            let $profileStatusInfo := concat('profileStatus-clinicInfo-',$clinicId,'.xml')
                            let $store := xmldb:store($profilelocation,$profileStatusInfo, $profile-status)
                        
                            let $searchHint := concat('hint-clinicInfo-',$clinicId,'.xml')
                            let $store := xmldb:store($location,$searchHint, $clinicIdHint)
                            
                            let $clinicInfo := concat('clinicInfo-',$clinicId,'.xml')
                            let $update_status := xmldb:store($dataLocation,$clinicInfo, $xml)   
                        
                            return
                                $clinicInfo
                        
return   
   <messageData>
       <message>Posted Successfully.</message>
   </messageData>