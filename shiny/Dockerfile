ARG VARIANT=4
ARG BASE_IMAGE=rocker/shiny
FROM ${BASE_IMAGE}:${VARIANT}

RUN rm -rf /srv/shiny-server/*

WORKDIR /srv/shiny-server/
ADD https://github.com/rstudio/shiny-examples.git /srv/shiny-server/shiny-examples
