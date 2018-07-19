xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $x:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)    
let $dataLocation := util:eval("locator:getDataPath('doctorInfo')")
let $profilelocation   := util:eval("locator:getDataPath('profileStatusInfo')")

let $post-data := request:get-data()
let $output := 
    for $task in collection($dataLocation) where $task//id= $post-data//id
    return $task
    return 
        if ($output)then
            <message>doctor Already Exist</message>
        else 
            let $currentSolution := util:eval("locator:getSolutionName()")
            let $location := util:eval("platformServices:getDataDir('searchHints')")
            let $profilelocation   := util:eval("locator:getDataPath('profileStatusInfo')")
            let $doc := $post-data
            let $currentUser := xmldb:get-current-user()
            let $id := util:eval("locator:getNextCounterVal('getDoctorId')")
            let $name := $doc//name/text()
            let $searchHint :=
            <searchHint>
                <id>{$id}</id>
                <origin type="data" profile="doctor" solution="{$currentSolution}" dataKey="doctorInfo" xpath="$doctor/name"/>
                <solution>{$currentSolution}</solution>
                <pattern>Doctors/{$name}</pattern>
                <text>{$name}</text>
                <type>doctorProfile</type>
            </searchHint>
                 
            let $profile-status :=
                        <profileStatusInfo> 
                            <dataKey>doctorInfo</dataKey>
                            <data id="{$id}" name="{$name}"/>
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
        
            let $doctor_detail := <doctorInfo>
                                        <id>{$id}</id>
                                        {$post-data/doctorInfo/*}
                                   </doctorInfo>
            
            let $profilename := concat('profileStatus-doctorInfo-',$id,'.xml')
            let $store := xmldb:store($profilelocation,$profilename, $profile-status)
            
            let $filename := concat('hint-doctorInfo-',$id,'.xml')
            let $store := xmldb:store($location,$filename, $searchHint)
            
            let $filename := concat('doctorInfo-',$id ,'.xml') 
            let $store_doctor := xmldb:store($dataLocation,$filename, $doctor_detail)
            
            return
               $doctor_detail
                   
     

