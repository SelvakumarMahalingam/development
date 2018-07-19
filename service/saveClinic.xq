xquery version "3.0";
try 
{
    let $conf := doc('../../../conf.xml')
    let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $x:= util:import-module($conf/config/appServices/service[@name="platformServices"]/nameSpace,"platformServices", $conf/config/appServices/service[@name="platformServices"]/location)    
    let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
    let $post-data := request:get-data()
    let $output := 
        for $task in collection($dataLocation)
        where $task//id= $post-data//id
        return $task
    return 
        <messageData>
        {
            if ($output)then
                <message>Clinic Already Exist</message>
            else 
                let $filename := concat('ClinicInfo-',$post-data//id ,'.xml') 
                let $update_status := xmldb:store($dataLocation,$filename, $post-data)
    let $currentSolution := util:eval("locator:getSolutionName()")
    let $location := util:eval("platformServices:getDataDir('searchHints')")
    let $profilelocation   := util:eval("locator:getDataPath('profileStatusInfo')")
    
	let $doc := $post-data
    let $currentUser := xmldb:get-current-user()
    let $id := $doc/id/text()
    let $name := $doc/name/text()
    let $searchHint :=
    <searchHint>
        <id>{$id}</id>
        <origin type="data" profile="clinic" solution="{$currentSolution}" dataKey="clinicInfo" xpath="$clinic/name"/>
        <solution>{$currentSolution}</solution>
        <pattern>Clinics/{$name}</pattern>
        <text>{$name}</text>
        <type>clinicProfile</type>
    </searchHint>
         
    let $profile-status :=
                <profileStatusInfo> 
                    <dataKey>clinicInfo</dataKey>
                    <data id="{$id}" name="{$name}"/>
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

    
    let $profilename := concat('profileStatus-clinicInfo-',$id,'.xml')
    let $store := xmldb:store($profilelocation,$profilename, $profile-status)
    
    let $filename := concat('hint-clinicInfo-',$id,'-clinicName.xml')
    let $store := xmldb:store($location,$filename, $searchHint)
                    
                return
           
                        <message status="success">Clinic Detail has been Added  successfully</message>
                   
        }</messageData>
} catch * 
{
    <messageData>
     <message>Clinic Detail save failed.</message>
     </messageData>
}
