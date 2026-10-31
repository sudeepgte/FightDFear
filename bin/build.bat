@echo off
set JAVA_HOME=C:\Users\Hp\Downloads\jdk-21.0.9_windows-x64_bin\jdk-21.0.9
set PATH=%JAVA_HOME%\bin;%PATH%
echo JAVA_HOME=%JAVA_HOME%
java -version
"C:\Program Files\apache-maven-3.8.6-bin\apache-maven-3.8.6\bin\mvn.cmd" clean compile
