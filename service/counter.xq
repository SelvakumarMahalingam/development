xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)

let $netx-val :=  util:eval("locator:getNextCounterVal('getClinicId')")
return
    
     <data>
      <lastId  id="{$netx-val}"/>
     </data>
     