#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-06-30 14:46:43 +0100 (Thu, 30 Jun 2016)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$srcdir/utils.sh"

if [ -z "$(find -L "${1:-.}" -name build.sbt)" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "S B T"

date
start_time="$(date +%s)"
echo

if which sbt &>/dev/null; then
    find -L "${1:-.}" -name build.sbt |
    grep -v '/target/' |
    while read build_sbt; do
        pushd "$(dirname $build_sbt)" >/dev/null
        echo "Validating $build_sbt"
        echo q | sbt reload || exit $?
        popd >/dev/null
        echo
    done
else
    echo "SBT not found in \$PATH, skipping maven pom checks"
fi

echo
date
echo
end_time="$(date +%s)"
# if start and end time are the same let returns exit code 1
let time_taken=$end_time-$start_time || :
echo "Completed in $time_taken secs"
echo
section2 "SBT checks passed"
echo
echo
