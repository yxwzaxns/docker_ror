FROM centos:6.6

ADD ./nginx.repo /etc/yum.repos.d/

RUN yum -y update

RUN curl --silent --location https://rpm.nodesource.com/setup | bash -

RUN yum -y install which tar nginx nodejs

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -

RUN curl -sSL https://get.rvm.io | bash -s stable

RUN bash --login -c "rvm install ruby"

RUN bash --login -c "gem source -a https://ruby.taobao.org/"

RUN bash --login -c "gem source --remove https://rubygems.org/"

RUN bash --login -c "gem install rails"

RUN bash --login -c "gem install thin"

RUN bash --login -c "thin install"

RUN mkdir /app && rm -rf /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf
ADD . /app
WORKDIR /app
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./default.conf /etc/nginx/conf.d/

WORKDIR /app/src

RUN echo "gem 'thin'" >> ./Gemfile

RUN sed -i "1c source 'https://ruby.taobao.org'" ./Gemfile

RUN bash --login -c "thin config -C /etc/thin/railsapp.yml -c /app/src  --servers 3 -e development"

RUN bash --login -c "bundle install"

RUN ln -s /app/src /var/vo

EXPOSE 80
# Default command

RUN chmod a+x /app/start.sh
CMD ["/app/start.sh"]
