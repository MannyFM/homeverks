WORKING_DIR="__test__"
TARBALL="_run_.tar.gz"
SCRIPT="h1.sh"
SCRIPT_ARGS="sub.tar.gz sol.c stackoverflow.com"

rm -rf $WORKING_DIR
mkdir -p $WORKING_DIR
tar -xzf $TARBALL -C $WORKING_DIR
cp $SCRIPT ${WORKING_DIR}/${SCRIPT}
cd $WORKING_DIR
./$SCRIPT $SCRIPT_ARGS
