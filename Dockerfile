FROM rstudio/r-base:4.2.2-jammy

USER root

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y zlib1g-dev libssl-dev libcurl4-openssl-dev libxml2-dev

RUN R -e "install.packages('BiocManager', version='3.15', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('optparse', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Rlabkey', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('readr', repos='http://cran.rstudio.com/')"

RUN R -e "BiocManager::install('ImmuneSpaceR')"

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ImmGeneBySampleMatrix.R ImmGeneBySampleMatrix.R
COPY test.csv test.csv

#CMD ["/bin/bash"]
ENTRYPOINT [ "/usr/src/app/ImmGeneBySampleMatrix.R" ]
