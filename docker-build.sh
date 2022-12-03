if ! test -f build-number.txt; then echo 0 > build-number.txt; fi
echo $(($(cat build-number.txt) + 1)) > build-number.txt

buildNumber=$(cat build-number.txt)

# #move the certs
# cp ../certificates/domain.local.crt certificates/ca.crt
# cp ../certificates/gitlab.crt certificates/gitlab.domain.local.crt

#build the image
docker build . -t armyguy255a/gitlab-runner:v2.$buildNumber -t armyguy255a/gitlab-runner:latest