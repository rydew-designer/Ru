#!/usr/bin/env sh
#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

app_path="$0"

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"${app_path##*/}"}
    [ -L "$app_path" ]
do
    app_path=$( (readlink "$app_path") 2>/dev/null) || app_path=$(expr "$app_path" : '.*->\(.*\)')
done

APP_HOME=$( cd "${APP_HOME%.}" && pwd -P ) || exit

case "$1" in
    -classpath | -cp) shift ;;
    -Xms* | -Xmx* | -XX*)
        JAVA_OPTS="$JAVA_OPTS $1"
        shift
        ;;
    gradle | gradlew) break ;;
    *)
        echo "usage: gradlew [gradle options] [gradle tasks]"
        echo ""
        echo "Option: -Dclient.encoding.override=<encoding> (only for testing purpose)"
        echo "Property: org.gradle.client.http.socketTimeout, http.socketTimeout (default: 10000)"
        exit 1
        ;;
esac

set -- gradlew "$@"

JAVA_EXE=
if command -v java >/dev/null 2>&1; then
    JAVA_EXE=java
fi

if [ ! -x "$JAVA_EXE" ] ; then
    echo "Error: JAVA_HOME is not defined correctly." >&2
    echo "  We cannot execute java as it is not found." >&2
    echo "  Please set the JAVA_HOME variable in your environment to match the" >&2
    echo "  location of your Java installation." >&2
    exit 1
fi

if [ -z "$JAVA_OPTS" ] ; then
    JAVA_OPTS=" -XX:MaxMetaspaceSize=64m"
fi

JAVA_OPTS="$JAVA_OPTS -Dorg.gradle.appname=$APP_BASE_NAME"
exec "$JAVA_EXE" $JAVA_OPTS -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain "$@"
