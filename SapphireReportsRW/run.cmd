@echo off
SET TMP_CP="classes\"
for %%I in (lib\*.jar) do CALL :AddToPath %%I
echo %TMP_CP%
set CLASSPATH=%TMP_CP%
java com.k12systems.sapphire.jasperserver.ws.client.ScriptRunner %1 %2 %3 %4 %5

:AddToPath
SET TMP_CP=%TMP_CP%;%1
GOTO :EOF
