@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  cql-to-elm startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

@rem Add default JVM options here. You can also use JAVA_OPTS and CQL_TO_ELM_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windowz variants

if not "%OS%" == "Windows_NT" goto win9xME_args
if "%@eval[2+2]" == "4" goto 4NT_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*
goto execute

:4NT_args
@rem Get arguments from the 4NT Shell from JP Software
set CMD_LINE_ARGS=%$

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\cql-to-elm-0.1-SNAPSHOT.jar;%APP_HOME%\lib\cql-0.1-SNAPSHOT.jar;%APP_HOME%\lib\elm-0.1-SNAPSHOT.jar;%APP_HOME%\lib\jackson-core-2.4.1.jar;%APP_HOME%\lib\jackson-databind-2.4.1.jar;%APP_HOME%\lib\jopt-simple-4.7.jar;%APP_HOME%\lib\quick-0.1-SNAPSHOT.jar;%APP_HOME%\lib\antlr4-4.5.jar;%APP_HOME%\lib\jaxb2-basics-0.9.4.jar;%APP_HOME%\lib\eclipselink-2.6.0.jar;%APP_HOME%\lib\validation-api-1.1.0.Final.jar;%APP_HOME%\lib\jackson-annotations-2.4.0.jar;%APP_HOME%\lib\antlr4-runtime-4.5.jar;%APP_HOME%\lib\antlr-runtime-3.5.2.jar;%APP_HOME%\lib\ST4-4.0.8.jar;%APP_HOME%\lib\jaxb2-basics-runtime-0.9.4.jar;%APP_HOME%\lib\jaxb2-basics-tools-0.9.4.jar;%APP_HOME%\lib\javaparser-1.0.11.jar;%APP_HOME%\lib\javax.persistence-2.1.0.jar;%APP_HOME%\lib\commonj.sdo-2.1.1.jar;%APP_HOME%\lib\javax.json-1.0.4.jar;%APP_HOME%\lib\org.abego.treelayout.core-1.0.1.jar;%APP_HOME%\lib\slf4j-api-1.7.7.jar;%APP_HOME%\lib\commons-beanutils-1.9.2.jar;%APP_HOME%\lib\jcl-over-slf4j-1.7.7.jar;%APP_HOME%\lib\commons-lang3-3.2.1.jar;%APP_HOME%\lib\commons-collections-3.2.1.jar

@rem Execute cql-to-elm
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %CQL_TO_ELM_OPTS%  -classpath "%CLASSPATH%" org.cqframework.cql.cql2elm.CqlTranslator %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable CQL_TO_ELM_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%CQL_TO_ELM_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
