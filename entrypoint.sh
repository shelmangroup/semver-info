#!/bin/bash
set -ex

BRANCH=${GITHUB_HEAD_REF}
if [ -z "${BRANCH}" ]; then
  BRANCH=${GITHUB_REF}
fi
BRANCH=$(echo ${BRANCH} | sed -e "s/refs\/heads\///g")
BRANCH_ALPHA=$(echo ${BRANCH} | sed -e "s/[^a-z0-9]/-/g")

VERSION_CURRENT=$(< VERSION)
VERSION_NEXT=$(semver bump patch ${VERSION_CURRENT})

if [ "${BRANCH}" != "master" ]; then
  VERSION_NEXT=$(semver bump prerel ${BRANCH_ALPHA}.${GITHUB_RUN_NUMBER} ${VERSION_NEXT})
fi

VERSION_NEXT=${VERSION_NEXT}+${GITHUB_SHA:0:8}

echo ${VERSION_NEXT} >VERSION
echo "::set-output name=branch::${BRANCH}"
echo "::set-output name=branch_alpha::${BRANCH_ALPHA}"
echo "::set-output name=version::${VERSION_NEXT}"
