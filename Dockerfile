ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2023.1.0.218.0
FROM $IMAGE

WORKDIR /home/irisowner/irisdev/

ARG TESTS=0
ARG MODULE="interoperability-sample"
ARG NAMESPACE="USER"

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
