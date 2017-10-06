FROM java:jdk
ENV DEBIAN_FRONTEND noninteractive
ENV GRADLE_VERSION gradle-4.1-all

WORKDIR /sources

# Dependencies
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 lib32z1 ant maven expect --no-install-recommends
ENV GRADLE_URL http://services.gradle.org/distributions/${GRADLE_VERSION}.zip
RUN curl -L ${GRADLE_URL} -o /tmp/${GRADLE_VERSION}.zip && unzip /tmp/${GRADLE_VERSION}.zip -d /usr/local && rm /tmp/${GRADLE_VERSION}.zip
ENV GRADLE_HOME /usr/local/${GRADLE_VERSION}

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L ${ANDROID_SDK_URL} | tar xz -C /usr/local

#ENV ANDROID_SDK_HOME /usr/local/android-sdk-linux
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN chmod -R +w $ANDROID_HOME

# Install Android SDK components
ENV ANDROID_SDK_DATE 20170206
ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools-26.0.2,android-26,extra-android-m2repository,extra-google-m2repository
ADD android-accept-licenses.sh /opt/tools/android-accept-licenses.sh
RUN chmod +x /opt/tools/android-accept-licenses.sh
RUN mkdir ${ANDROID_HOME}/licenses && echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > ${ANDROID_HOME}/licenses/android-sdk-license
RUN ["sh", "-c", "/opt/tools/android-accept-licenses.sh \"${ANDROID_HOME}/tools/android update sdk --no-ui --all --filter ${ANDROID_SDK_COMPONENTS}\""]

# Path
ENV PATH $PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin