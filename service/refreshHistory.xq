

 xquery version "3.0";
 try
 {
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataLocation := util:eval("locator:getDataPath('uploadHistory')")
return
 <data>{for $post-data in collection($dataLocation)
 order by $post-data//name
return 
    <uploadHistory>
          <active/>
       {$post-data/node()/element()}      
        </uploadHistory>
        }</data>
}
catch *{"error"}

