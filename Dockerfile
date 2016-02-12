FROM ubuntu:14.04

# Install dependencies
RUN apt-get update
RUN apt-get install -qq mc git curl g++ openjdk-7-jre python make

# Install the newest nodejs, coffee-script, forerver
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN sudo apt-get install -qq nodejs

# Install coffee-script, coffee
RUN npm install -g grunt-cli coffee-script coffee stylus supervisor http-server forever node-gyp
RUN npm config set strict-ssl false
RUN npm config set registry http://registry.npmjs.org/
RUN npm update npm -g;

# Make ssh dir
RUN mkdir /root/.ssh/
RUN mkdir /root/.bin/

# Copy over private key, and set permissions
ADD docker/ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add github key
RUN ssh-keyscan bitbucket.com >> /root/.ssh/known_hosts

ENV BRANCH master
RUN cd /var/www; git clone -b ${BRANCH} git@bitbucket.org:glacialman/tracking.git >> /tmp/log 2>&1

# Jump to app folder and run app
ADD docker/run.sh /root/.bin/run.sh
RUN chmod 600 /root/.bin/run.sh

ENTRYPOINT ["/bin/bash"]
EXPOSE 1987
# Usage
# docker run -it -p 1987:1987 --add-host dockerhost:`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'` bridgingithoang/automated-build /root/.bin/run.sh
# docker exec -it bridgingithoang/automated-build
# docker exec -i -t bridgingithoang/automated-build
