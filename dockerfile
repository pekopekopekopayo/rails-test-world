# 기본 이미지로 Ruby 2.7을 사용합니다.
FROM ruby:3.2.2

# Rails 애플리케이션을 실행하기 위해 필요한 패키지를 설치합니다.
RUN apt-get update -qq && apt-get install -y build-essential nodejs

# 작업 디렉토리를 /app으로 설정합니다.
WORKDIR /app

# Gemfile과 Gemfile.lock을 복사하여 Docker 이미지에 추가합니다.
COPY Gemfile Gemfile.lock ./

# 애플리케이션의 종속성(Gems)을 설치합니다.
RUN gem install bundler && bundle install

# 애플리케이션의 모든 파일을 Docker 이미지에 추가합니다.
COPY . .

# 컨테이너 내에서 Rails 애플리케이션을 실행할 때 사용할 포트를 지정합니다.
EXPOSE 3000
