FROM tomcat:11.0-jdk21-temurin-jammy@sha256:dde8f2bb633ff757dd39ef7a4b3e07725fe3ed52a658c204dee6269dce452ead AS runtime
ARG TARGETARCH
ARG CORRETTO_VERSION=21.0.13.1.2

# Install the patched JDK in the location used by the Tomcat base image.
RUN set -eu; \
    case "$TARGETARCH" in \
        amd64) arch=x64; sha=2aaa2a9a43143b20ff0b28c8d0da27407b97dc40b160d9a2f60a26965815e948 ;; \
        arm64) arch=aarch64; sha=55751c47c7e3be3b33af43ccdcf3a6f4814d308390b7400477594d421bd16a53 ;; \
        *) echo "Unsupported Corretto architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 3 "https://corretto.aws/downloads/resources/${CORRETTO_VERSION}/amazon-corretto-${CORRETTO_VERSION}-linux-${arch}.tar.gz" -o /tmp/jdk.tar.gz; \
    echo "$sha  /tmp/jdk.tar.gz" | sha256sum -c -; \
    rm -rf /opt/java/openjdk; \
    mkdir -p "$JAVA_HOME"; \
    tar -xzf /tmp/jdk.tar.gz -C "$JAVA_HOME" --strip-components=1; \
    rm /tmp/jdk.tar.gz

ENV JAVA_VERSION=jdk-21.0.13.1+2

FROM runtime AS build
WORKDIR /build
COPY mvnw pom.xml ./
COPY .mvn/ .mvn/
COPY src/ src/
RUN --mount=type=cache,target=/root/.m2 sh ./mvnw --batch-mode --no-transfer-progress package

FROM runtime
LABEL authors="soo_mini"
COPY --from=build /build/target/notice-board-project-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
