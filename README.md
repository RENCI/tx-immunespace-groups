# tx-immunespace-groups
container gets gene counts matrix from immmunespace

# build
`docker build  -t tx-immunespace-groups`

# run
`docker run --rm  -t tx-immunespace-groups ./ImmGeneBySampleMatrix.R -g ${GROUP} -a ${APIKEY} > exp.csv`
Where GROUP and APIKEY were both created in ImmuneSpace
