<#--

    Copyright 2019 XEBIALABS

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-->
@echo off
setlocal

<#if deployed.container.envVars??>
<#assign envVars=deployed.container.envVars />
<#list envVars?keys as envVar>
set ${envVar}=${envVars[envVar]}
</#list>
</#if>

set START_DELAY_SECS=${deployed.startDelay}

if not [%START_DELAY_SECS%]==[0] (
  echo Waiting %START_DELAY_SECS% seconds
  ping -w 1000 -n %START_DELAY_SECS% 127.0.0.1 > nul
)

set MAX_RETRIES=${deployed.maxRetries}
set RETRY_INTERVAL_SECS=${deployed.retryWaitInterval}
set RESPONSE_FILE_PREFIX=http-response.%RANDOM%

<#assign wgetCmdLine = ["${deployed.container.wgetExecutable}", "--timeout=${deployed.timeout}"] />
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

<#assign wgetCmdLine = wgetCmdLine + ["-O"]/>

 
for /L %%i in (1,1,%MAX_RETRIES%) do (
  del /Q %RESPONSE_FILE_PREFIX%.%%i 2> nul

  echo Executing <#list wgetCmdLine as item>${item} </#list>%RESPONSE_FILE_PREFIX%.%%i ${deployed.url}"
  <#list wgetCmdLine as item>${item} </#list>%RESPONSE_FILE_PREFIX%.%%i ${deployed.url}"

  if ERRORLEVEL 1 (
    set WGET_EXIT_CODE=1
  ) else (
    set WGET_EXIT_CODE=0
    set LAST_RESPONSE_FILE=%RESPONSE_FILE_PREFIX%.%%i
    goto RequestCompleted
  )
  ping -w 1000 -n %RETRY_INTERVAL_SECS% 127.0.0.1 > nul
)

:requestCompleted
if not [%WGET_EXIT_CODE%]==[0] (
  echo ERROR: '${deployed.url}' returned non-200 response code
  exit %WGET_EXIT_CODE% 
)

<#if (deployed.showPageInConsole?? && deployed.showPageInConsole)>
type %LAST_RESPONSE_FILE%
</#if>

<#if deployed.expectedResponseText?has_content>
findstr /C:"${deployed.expectedResponseText}" %LAST_RESPONSE_FILE%

set SEARCH_EXIT_CODE=%ERRORLEVEL%

if not [%SEARCH_EXIT_CODE%]==[0] (
  echo ERROR: Response body did not contain: "${deployed.expectedResponseText}"
  exit %SEARCH_EXIT_CODE%
)
</#if>

<#if deployed.unexpectedResponseText?has_content>
findstr /C:"${deployed.unexpectedResponseText}" %LAST_RESPONSE_FILE%

set SEARCH_EXIT_CODE=%ERRORLEVEL%

if [%SEARCH_EXIT_CODE%]==[0] (
  echo ERROR: Response body did contain: "${deployed.unexpectedResponseText}"
  exit 1
)
</#if>

endlocal
