#!/bin/bash

NC='\x1b[0m';
ColorBright='\x1b[1m';
ColorFgRed='\x1b[31m';

MIRROR=archive.apache.org

DOWNLOAD_SPARK="${DOWNLOAD_SPARK:-true}"
DOWNLOAD_AWS_JARS="${DOWNLOAD_AWS_JARS:-true}"
BUILD_DOCKER_IMAGE="${BUILD_DOCKER_IMAGE:-true}"
PUSH_DOCKER_IMAGE="${PUSH_DOCKER_IMAGE:-false}"

REPOSITORY_NAME=${REPOSITORY_NAME:-"spark"}
SPARK_VERSION=${SPARK_VERSION:-"3.0.1"}
HADOOP_VERSION=${HADOOP_VERSION:-"3.2"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}
SPARK_FULL_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

export SPARK_HOME=$(pwd)/${SPARK_FULL_NAME}

function start {
    downloadSpark
    extractSpark
    downloadAwsJars
    buildDcokerImage
    pushDockerImage
}

function downloadSpark {
    if [[ "$DOWNLOAD_SPARK" = true ]] ; then
        echo -e "${ColorBright}Downloading Spark...${NC}"
        curl -Lo ${SPARK_FULL_NAME}.tgz https://${MIRROR}/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
    fi
}

function extractSpark {
    echo -e "${ColorBright}Extracting Spark...${NC}"
    which pv > /dev/null 2>&1
    PV_EXISTS=$?
    if [[ "$PV_EXISTS" -eq "0" ]]; then
        pv ${SPARK_FULL_NAME}.tgz | tar xzf -
    else
        tar xvzf ${SPARK_FULL_NAME}.tgz
    fi
}

function downloadAwsJars {
    if [[ "$DOWNLOAD_AWS_JARS" = true ]] ; then
        echo -e "${ColorBright}Downloading AWS dependent jars...${NC}"
        curl -Lo $SPARK_HOME/jars/aws-java-sdk-bundle-1.11.888.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.888/aws-java-sdk-bundle-1.11.888.jar
        curl -Lo $SPARK_HOME/jars/hadoop-aws-3.2.0.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar
    fi
}

function buildDcokerImage {
    if [[ "$BUILD_DOCKER_IMAGE" = true ]] ; then
        echo -e "${ColorBright}Building Docker image...${NC}"
        $SPARK_HOME/bin/docker-image-tool.sh -n -u root -t ${IMAGE_TAG} build
    fi
}

function pushDockerImage {
    if [[ "$PUSH_DOCKER_IMAGE" = true ]] ; then
        if [[ -z "${REGISTRY_NAME}" ]]; then
            echo -e "${ColorBright}${ColorFgRed}REGISTRY_NAME must be set before pushing image${NC}"
        else
            docker tag spark:${IMAGE_TAG} ${REGISTRY_NAME}/${REPOSITORY_NAME}:${IMAGE_TAG}
            docker push ${REGISTRY_NAME}/${REPOSITORY_NAME}:${IMAGE_TAG}
        fi
    fi
}

start