# spark-docker-builder
Build spark image and push to docker-hub 

### Available Options (set as environment variables)

| Variable | Description | Default value |
| ----------- | ----------- | ----------- |
| SPARK_VERSION | Spark version to use | 3.0.1 |
| HADOOP_VERSION | Hadoop version to use | 3.2 |
| IMAGE_TAG | Tag to set for the built image | latest |
| DOWNLOAD_SPARK | Download spark from archive.apache.org | true |
| DOWNLOAD_AWS_JARS | Download extra aws jars and add them to $SPARK_HOME/jars | true |
| BUILD_DOCKER_IMAGE | Builds docker image and set `IMAGE_TAG` e.g `spark:3.0.1` | true |
| PUSH_DOCKER_IMAGE | Push docker image built to registry (`REGISTRY_NAME` & `REGISTRY_USERNAME` needs to be set) | false |
| REPOSITORY_NAME | Repository name to push the image to | spark |
| REGISTRY_NAME | Registry name to push the image to (should be already logged in) | - |