FROM python:3.10.5-alpine

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

ARG UID=1000
ARG GID=1000
ARG ENV=development
ARG UNAME=dev
ENV PATH="/home/dev/.local/bin:${PATH}"

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker} 
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.13.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

RUN addgroup -S devgroup && adduser -S dev -G devgroup -u ${UID} -h /home/dev

RUN mkdir /opt/python-webapp

RUN chown ${UID} /opt/python-webapp

WORKDIR /opt/python-webapp

USER ${UID}

ENTRYPOINT [ "/bin/sh" , "/opt/setup.sh" ]

CMD [ "flask" , "run" , "--host=0.0.0.0" , "--port=5000" ]