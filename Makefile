build:
	if ! test -f build-number.txt; then echo 0 > build-number.txt; fi
	echo $(($(cat build-number.txt) + 1)) > build-number.txt

	buildNumber=$(cat build-number.txt)

	# #move the certs
	# cp ../certificates/domain.local.crt certificates/ca.crt
	# cp ../certificates/gitlab.crt certificates/gitlab.domain.local.crt

	#build the image
	docker build . -t armyguy255a/gitlab-runner:v2.$buildNumber -t armyguy255a/gitlab-runner:latest
	
run-interactive:
	docker run -it armyguy255a/vjoc:latest

run:	
	docker run --name vjoc --rm -i -t armyguy255a/vjoc:latest "dotnet /home/vjoc/webapp/Haptic.Web.Api.App.dll"
	docker exec -it armyguy255a/vjoc:latest sh -c "dotnet --depsfile Haptic.Web.Api.App.deps.json --runtimeconfig Haptic.Web.Api.App.runtimeconfig.json Haptic.Web.Api.App.dll"

sql:
	docker run -e "MSSQL_PID=Enterprise" -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
	docker container ls