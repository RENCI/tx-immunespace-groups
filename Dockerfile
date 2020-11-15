FROM txscience/tx-r-immunespace:0.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ImmGeneBySampleMatrix.R ImmGeneBySampleMatrix.R

CMD ["/bin/bash"]
