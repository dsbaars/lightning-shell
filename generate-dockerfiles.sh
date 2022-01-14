#!/usr/bin/env bash

cat <<EOF > Dockerfile
# This file was automatically generated by generate-dockerfiles.sh
# Do not edit this file directly.
# Instead, edit Dockerfile.tmpl or generate-dockerfiles.sh, then run ./generate-dockerfiles.sh
EOF

cat <<EOF > Dockerfile.buster
# This file was automatically generated by generate-dockerfiles.sh
# Do not edit this file directly.
# Instead, edit Dockerfile.tmpl or generate-dockerfiles.sh, then run ./generate-dockerfiles.sh
EOF

cat Dockerfile.tmpl >> Dockerfile
cat Dockerfile.tmpl >> Dockerfile.buster

# Dockerfile contains bullseye, Dockerfile.buster contains the buster version
sed -i "s/\${DEBIAN_VERSION}/bullseye/g" Dockerfile
sed -i "s/\${DEBIAN_VERSION}/buster/g" Dockerfile.buster

# no VERSION_SPECIFIC_BUILD_STEPS for now
sed -i "/\n# VERSION_SPECIFIC_BUILD_STEPS/d" Dockerfile.buster
sed -i "/\n# VERSION_SPECIFIC_BUILD_STEPS/d" Dockerfile

# Version specific dependencies
sed -i "s/<VERSION_SPECIFIC_DEPENDENCIES>//" Dockerfile
# For Buster, we need python3-grpcio and python3-setuptools for Python dependencies
sed -i "s/<VERSION_SPECIFIC_DEPENDENCIES>/python3-grpcio python3-setuptools/g" Dockerfile.buster

# For Buster, we need a special filter to prevent pip from installing grpc, because it would compile it from scratch and that would take too long
# On Bullseye, pip is able to find a prebuilt wheel, so we don't need this filter
sed -i "s/<INSTALL_MAYBE_NO_GRPC>/pip3 install -r requirements.txt/g" Dockerfile
sed -i "s/<INSTALL_MAYBE_NO_GRPC>/cat requirements.txt | grep -v grpcio > requirements-nogrpcio.txt \&\& pip3 install -r requirements-nogrpcio.txt/g" Dockerfile.buster

# no VERSION_SPECIFIC_COPY_STEPS for now
sed -i "/\n# VERSION_SPECIFIC_COPY_STEPS/d" Dockerfile
sed -i "/\n# VERSION_SPECIFIC_COPY_STEPS/d" Dockerfile.buster

# no VERSION_SPECIFIC_BUILD_DEPENDENCIES for now
sed -i "s/<VERSION_SPECIFIC_BUILD_DEPENDENCIES>//g" Dockerfile.buster
sed -i "s/ <VERSION_SPECIFIC_BUILD_DEPENDENCIES>//g" Dockerfile

cp Dockerfile Dockerfile.bullseye
