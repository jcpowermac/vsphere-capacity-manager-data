FROM registry.ci.openshift.org/openshift/release:golang-1.20 AS builder
WORKDIR /go/src/github.com/openshift-splat-team/vsphere-capacity-manager-data
COPY . .
ENV GO_PACKAGE github.com/openshift-splat-team/vsphere-capacity-manager-data
RUN NO_DOCKER=1 make build

# FROM registry.ci.openshift.org/openshift/origin-v4.0:base
# FROM registry.ci.openshift.org/ocp/4.13:base
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.7-1107
COPY --from=builder /go/src/github.com/openshift-splat-team/vsphere-capacity-manager/install manifests
COPY --from=builder /go/src/github.com/openshift-splat-team/vsphere-capacity-manager/bin/mapi-static-ip-controller /usr/bin/mapi-static-ip-controller
ENTRYPOINT ["/usr/bin/mapi-static-ip-controller"]
LABEL io.openshift.release.operator=true
