FROM ubuntu:14.04

MAINTAINER beckl <runbeck@163.com>

# update apt-get source and install required tool set
RUN cp /etc/apt/sources.list /etc/apt/sources.list_bak
RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt
RUN apt-get update
RUN apt-get install -y git xz-utils wget memcached redis-server curl make gcc build-essential python2.7

# setup workspace and create directories for runtime
WORKDIR /home
RUN mkdir workspace
WORKDIR workspace
RUN mkdir conf
RUN mkdir pid
RUN mkdir log
RUN mkdir github
RUN mkdir shell
COPY shell/* shell/

# download and install node/npm
RUN wget --tries=100 --retry-connrefused https://nodejs.org/dist/v5.10.1/node-v5.10.1-linux-x64.tar.xz
RUN xz -d node-v5.10.1-linux-x64.tar.xz
RUN tar -xvf node-v5.10.1-linux-x64.tar
RUN rm node-v5.10.1-linux-x64.tar
RUN mv node-v5.10.1-linux-x64 /usr/local/node
RUN chmod 755 /usr/local/node/* -R
RUN sudo ln -s /usr/local/node/bin/node /usr/bin/node
RUN sudo ln -s /usr/local/node/bin/npm /usr/bin/npm

# start up memcached
RUN memcached -d -u root -P /home/workspace/pid/memcached.pid

# start up redis-server with updated configuration
RUN cp /etc/redis/redis.conf /home/workspace/conf
RUN sed -i "s/\/var\/run\/redis\/redis-server.pid/\/home\/workspace\/pid\/redis-server.pid/g" /home/workspace/conf/redis.conf
RUN sed -i "s/\/var\/log\/redis\/redis-server.log/\/home\/workspace\/log\/redis-server.log/g" /home/workspace/conf/redis.conf
RUN redis-server /home/workspace/conf/redis.conf

# setup ENV variables
RUN echo "export TEST=\"test\"" >> /etc/profile # FIXME
RUN source /etc/profile

# setup git configurations and clone the repo onto local workspace
WORKDIR github
RUN git config --global user.name "xxx" # FIXME
RUN git config --global user.email "xxx@xxx.com" # FIXME
RUN git config --global color.ui true
RUN git clone https://xxx:xxx@github.com/xxx/xxx.git # FIXME

# install node packages and startup application
WORKDIR xxx # FIXME
RUN npm config set registry http://registry.cnpmjs.org
# install coffee-script
RUN npm install coffee-script -g
RUN sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/coffee /usr/bin/coffee
RUN sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/cake /usr/bin/cake
RUN npm config set python python2.7
RUN npm install

EXPOSE 3000 4000 # FIXME
