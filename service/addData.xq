xquery version "1.0";
let $dataLocation := "../data/clinic.xml"                

let $list :=doc($dataLocation)
return  
         $list