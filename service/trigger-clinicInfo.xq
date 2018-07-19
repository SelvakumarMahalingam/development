xquery version "3.0";
module namespace trigger='http://exist-db.org/xquery/trigger';
import module namespace putil='http://vyasaka.com/vya-platform/core/collectionUtil' at '/db/core/util/collectionUtil.xq';
declare namespace request="http://exist-db.org/xquery/request";
declare namespace response="http://exist-db.org/xquery/response";
declare namespace session="http://exist-db.org/xquery/session";
declare namespace xdb="http://exist-db.org/xquery/xmldb";
declare namespace util="http://exist-db.org/xquery/util";

declare function trigger:after-create-document($uri as xs:anyURI) {    
(:let $uri := '/db/platforms-data/healthcare-platform/searchHints':)
(:let $profilelocation   := '/db/platforms-data/healthcare-platform/profileStatusInfo':)
let $tokens := tokenize($uri,'/')
let $location := concat(string-join(subsequence($tokens, 1,4),'/'),'/searchHints')
let $profilelocation   := concat(string-join(subsequence($tokens, 1,4),'/'),'/profileStatusInfo')
(:let $uri := '/db/platforms-data/healthcare-platform/clinicInfo/clinicInfo-002.xml':)
let $currentSolution := 'solution'
(:let $clinicInfoLoc := '/db/platforms-data/healthcare-platform/clinicInfo':)
(:for $doc in collection($clinicInfoLoc)/clinicInfo:)
let $doc := doc($uri)/clinicInfo
return 
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

    
    let $profilename := concat('profileStatus-clinic-',$id,'.xml')
    let $store := xmldb:store($profilelocation,$profilename, $profile-status)
    
    let $filename := concat('hint-clinic-',$id,'-clinicName.xml')
    let $store := xmldb:store($location,$filename, $searchHint)
    
    return 'Done'
};      