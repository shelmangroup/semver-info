#!/bin/bash
BRANCH=${GITHUB_HEAD_REF}
if [ -z "${BRANCH}" ]; then
  BRANCH=${GITHUB_REF}
fi
BRANCH=$(echo ${BRANCH} | sed -e "s/refs\/heads\///g")
BRANCH_ALPHA=$(echo ${BRANCH} | sed -e "s/[^a-z0-9]/-/g")

echo "::set-output name=branch::${BRANCH}"
echo "::set-output name=branch_alphanum::${BRANCH_ALPHA}"
