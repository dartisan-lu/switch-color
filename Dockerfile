FROM cirrusci/flutter:stable

WORKDIR /app

COPY ./pubspec.yaml ./pubspec.yaml
COPY ./pubspec.lock ./pubspec.lock
COPY ./bin ./bin
COPY ./lib ./lib

RUN flutter pub get
RUN dart compile exe bin/color-it.dart -o bin/color-it.sh

ENTRYPOINT ["bin/color-it.sh", "/demofiles/sample.csv", "/demofiles/sample-result.csv"]
