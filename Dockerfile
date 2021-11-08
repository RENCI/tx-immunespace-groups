FROM txscience/tx-r-immunespace:1.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ImmGeneBySampleMatrix.R ImmGeneBySampleMatrix.R
COPY test.csv test.csv

CMD ["/bin/bash"]
ENTRYPOINT [ "/usr/src/app/ImmGeneBySampleMatrix.R" ]
