#!/usr/bin/env sh

set -e
set -x

if [ $# -ne 4 ]; then
  echo "Error: Invalid number of arguments."
  exit 1
fi

prefix=$1
remote=$2
reference=$3
as_tag=$4

# Convert the remote URL to use the https protocol and include the GITHUB_TOKEN for authentication
remote_https=$(echo "$remote" | sed 's/^git@github.com:/https:\/\/github.com\//' | sed "s/^https:\/\/github.com\//https:\/\/${GITHUB_TOKEN}@github.com\//")

# Set necessary git configuration options
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --local --unset-all http.https://github.com/.extraheader # https://github.com/actions/checkout/issues/162#issuecomment-590821598

# Split the repository
git remote add splitsh_target_remote "$remote_https"
SHA1=`/usr/local/bin/splitsh-lite --prefix="$prefix"`

# Push the split repository to the remote
if [ "$as_tag" = "true" ]; then
  git push splitsh_target_remote "$SHA1:refs/tags/$reference" -f --verbose
else
  git push splitsh_target_remote "$SHA1:refs/heads/$reference" -f --verbose
fi
