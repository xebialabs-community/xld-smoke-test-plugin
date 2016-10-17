	<#--

    THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
    FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.

-->
#!/bin/sh

<#if deployed.container.envVars??>
<#assign envVars=deployed.container.envVars />
<#list envVars?keys as envVar>
${envVar}="${envVars[envVar]}"
export ${envVar}
</#list>
</#if>

<#assign wgetCmdLine = ["wget", "--timeout=${deployed.timeout}"] />
<#if (deployed.ignoreCertificateWarnings?? && deployed.ignoreCertificateWarnings)>
        <#assign wgetCmdLine = wgetCmdLine + ["--no-check-certificate"]/>
</#if>
<#if (deployed.postData??)>
    <#assign wgetCmdLine = wgetCmdLine + ["--post-file=smoketest/postdata.dat", "--header=\"Content-Type: ${deployed.contentType}\""]/>
<#elseif (deployed.file??)>
    <#assign wgetCmdLine = wgetCmdLine + ["--post-file=${deployed.file.name}", "--header=\"Content-Type: ${deployed.contentType}\""]/>
</#if>
<#list deployed.headers as header>
    <#assign wgetCmdLine = wgetCmdLine + ["--header=\"${header}\""]/>
</#list>

<#assign wgetCmdLine = wgetCmdLine + ["-O", "$RESPONSE_FILE", "${deployed.url}"]/>

START_DELAY_SECS=${deployed.startDelay}

if [ $START_DELAY_SECS -ne 0 ]; then
echo Waiting $START_DELAY_SECS seconds
sleep $START_DELAY_SECS
fi

MAX_RETRIES=${deployed.maxRetries}
RETRY_INTERVAL_SECS=${deployed.retryWaitInterval}

for i in `seq 1 $MAX_RETRIES`
do
RESPONSE_FILE=http-response.$$
rm -f $RESPONSE_FILE

echo Executing <#list wgetCmdLine as item>${item} </#list>
<#list wgetCmdLine as item>${item} </#list>

WGET_EXIT_CODE=$?
if [ $WGET_EXIT_CODE -eq 0 ]; then
break
fi
sleep $RETRY_INTERVAL_SECS
done

if [ $WGET_EXIT_CODE -ne 0 ]; then
echo ERROR: '${deployed.url}' returned non-200 response code
exit $WGET_EXIT_CODE
fi

<#if (deployed.showPageInConsole?? && deployed.showPageInConsole)>
cat $RESPONSE_FILE
</#if>

<#if deployed.expectedResponseText?has_content>
echo Making sure response contains: "${deployed.expectedResponseText}"
grep "${deployed.expectedResponseText}" $RESPONSE_FILE

SEARCH_EXIT_CODE=$?

if [ $SEARCH_EXIT_CODE -ne 0 ]; then
echo ERROR: Response body did not contain: "${deployed.expectedResponseText}"
exit $SEARCH_EXIT_CODE
fi
</#if>

<#if deployed.unexpectedResponseText?has_content>
echo Making sure response does not contain: "${deployed.unexpectedResponseText}"
grep "${deployed.unexpectedResponseText}" $RESPONSE_FILE

SEARCH_EXIT_CODE=$?

if [ $SEARCH_EXIT_CODE -eq 0 ]; then
echo ERROR: Response body did contain: "${deployed.unexpectedResponseText}"
exit 1
fi
</#if>