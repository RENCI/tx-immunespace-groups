FROM tx-r-immunespace

# RUN apt-get install -y emacs

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ImmGeneBySampleMatrix.R ImmGeneBySampleMatrix.R

CMD ["/bin/bash"]
