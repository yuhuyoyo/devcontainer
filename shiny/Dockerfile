ARG VARIANT=4
ARG BASE_IMAGE=rocker/shiny
FROM ${BASE_IMAGE}:${VARIANT}

WORKDIR /srv/shiny-server/
ADD https://github.com/rstudio/shiny-examples.git shiny-examples
