xquery version "3.0";
import module namespace putil="http://vyasaka.com/vya-platform/core/collectionUtil" at '/db/core/util/collectionUtil.xq';
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $dataCreationLocation := util:eval("locator:getDataPath('clinicFile')")
let $targeLocation :=  util:eval("locator:getDataPath('clinicInfo')")
let $post-data := request:get-data()

let $meta_file_name := 
            for $meta-info in  xmldb:get-child-resources($dataCreationLocation)
            let $file_path := concat($dataCreationLocation,'/',$meta-info)
            where xmldb:get-mime-type(xs:anyURI($file_path)) = 'application/xml' 
            return  
                 if(util:binary-doc-available($file_path))then 
                    ()
                 else    
                   if(doc($file_path)//metaInfo/fileName = $post-data//fileName)then
                   $meta-info
                   else ()  
(:              return $meta_file_name :)
                    
                    let $meta_move := xmldb:move($dataCreationLocation, $targeLocation, $meta_file_name)
                    let $file_move := xmldb:move($dataCreationLocation, $targeLocation, $post-data//fileName)
                    return  <message>success</message>