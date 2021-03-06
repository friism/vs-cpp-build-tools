FROM msbuild

RUN Install-WindowsFeature NET-Framework-45-Core
RUN Invoke-WebRequest "https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe" \
		-OutFile visualcppbuildtools_full.exe -UseBasicParsing ; \
	Start-Process -FilePath 'visualcppbuildtools_full.exe' -ArgumentList '/quiet', '/NoRestart' -Wait ; \
	Remove-Item .\visualcppbuildtools_full.exe

RUN [Environment]::SetEnvironmentVariable('PATH', ${Env:ProgramFiles(x86)} + '\Microsoft Visual Studio 14.0\VC\bin\amd64;' + ${Env:ProgramFiles(x86)} + '\Windows Kits\10\bin\x64;' + $env:PATH, [EnvironmentVariableTarget]::Machine);

RUN pushd 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC' ; \
	cmd /c 'vcvarsall.bat amd64&set' | foreach { if ($_ -match '=') { $v = $_.split('='); setx /M $v[0] $v[1] } } ; \
	popd
