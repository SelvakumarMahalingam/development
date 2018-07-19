xquery version "3.0";
import module namespace putil="http://vyasaka.com/vya-platform/core/collectionUtil" at '/db/core/util/collectionUtil.xq';
declare namespace functx = "http://www.functx.com"; 
declare function functx:trim ( $arg as xs:string? )  as xs:string {      
   replace(replace($arg,'\s+$',''),'^\s+','')
 };
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('clinicInfo')")
let $post-data := request:get-data()
for $clinic in $post-data
return $clinic