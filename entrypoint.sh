#!/bin/bash
set -exo pipefail

AUTO_RELEASE="yes"
if [ -n "${RELEASE_BRANCH}" ]; then
  RELEASE_BRANCH="master"
  AUTO_RELEASE="no"
fi

BRANCH=${GITHUB_HEAD_REF}
if [ -z "${BRANCH}" ]; then
  BRANCH=${GITHUB_REF}
fi
BRANCH=$(echo ${BRANCH} | sed -e "s/refs\/heads\///g")
BRANCH_ALPHA=$(echo ${BRANCH} | sed -e "s/[^a-z0-9]/-/g")

VERSION_CURRENT=$(< VERSION)
VERSION_NEXT=$(semver bump patch ${VERSION_CURRENT})

env | sort

if [ "${BRANCH}" != "${RELEASE_BRANCH}" ]; then
  PR_NUMBER=$(echo "$GITHUB_REF" | awk -F / '{print $3}')
  VERSION_NEXT=$(semver bump prerel pr.${PR_NUMBER}.${GITHUB_RUN_NUMBER} ${VERSION_NEXT})
  VERSION_NEXT=${VERSION_NEXT}+${BRANCH_ALPHA}.${GITHUB_SHA:0:8}
fi

echo ${VERSION_NEXT} >VERSION

if [ "${AUTO_RELEASE}" == "yes" && "${GITHUB_EVENT_NAME}" == "push" && "${BRANCH}" == "${RELEASE_BRANCH}" ]; then
  echo "RELEASE ME"
fi

echo "::set-output name=branch::${BRANCH}"
echo "::set-output name=branch_alpha::${BRANCH_ALPHA}"
echo "::set-output name=version::${VERSION_NEXT}"
