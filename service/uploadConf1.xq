

xquery version "3.0";
let $conf := doc('../../../conf.xml')
let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
return 
<detailInfo>
    <data>
        <solutionKey>{util:eval("locator:getSolutionName()")}</solutionKey>
        <dataKey>clinicFile</dataKey>
        <fileNamePrefix>file</fileNamePrefix>
        <counterKey available=""></counterKey>
        <totalUploadFileInDataKey restriction="enable/disable" currentCount="80">80</totalUploadFileInDataKey>
        <uploadDialogHeader>File Upload</uploadDialogHeader>
        <alertcase>
            <message>
                    <emptyFileError>Are You select upload image file?.</emptyFileError>
                    <submitFileError>Image file submission error.</submitFileError>
                    <unknownError>Unknown  error.</unknownError>
            </message> 
            <case type="info" autoHide="disable" timeIn="MS"  time="1000"/>
            <case type="success" autoHide="enable" timeIn="MS"  time="3000"/>
            <case type="warning" autoHide="enable" timeIn="SC"  time="50"/>
            <case type="danger" autoHide="disable" timeIn="MI"  time="3"/>
        </alertcase>    
        <upload method="normal">     
        <method type="normal">
                        <uploadTotalFile>1</uploadTotalFile>
                           <message>
                               <typeValidation>Upload text/csv file otherwise cant accept.</typeValidation>
                            </message>  
                        <uploadFile accept="text/*,application/*">                         
                                <file type="text/*" sizeIn="MB" sizeFrom="0.0" sizeTo="1.5">
                                    <message>
                                      <sizeValidation>The image file size must between 200 KB to 1.5 MB.</sizeValidation>
                                  </message> 
                                </file> 
                                <file type="application/*" sizeIn="MB" sizeFrom="0.0" sizeTo="1.5">
                                    <message>
                                      <sizeValidation>The image file size must between 200 KB to 1.5 MB.</sizeValidation>
                                  </message> 
                                </file>      
                         </uploadFile>
                           
            </method>
            </upload>
         <metaInfo>
         <fileName>Null</fileName>
            <originalFileName>Null</originalFileName>
            <fileSize value="Null">Null</fileSize>
            <mediaType>Null</mediaType>
            <owner>{xmldb:get-current-user()}</owner>
            <create>
                <date></date>
                <time></time>
            </create>
            <modify>
                <date></date>
                <time></time>
            </modify>    
            <accessHistory>
                <acess>    
                   <date></date>
                   <time></time>
                </acess>
                <history>
                  <acess>    
                    <date></date>
                    <time></time>
                  </acess>
                </history>    
            </accessHistory>
            <purpose></purpose>
            <description></description>
            <category></category>           
        </metaInfo>
        <filters>
          <filter element="mediaType" type="string" name="$file//" operator="=" value="*" index="true"/>
        
        </filters>
    </data>
</detailInfo>

