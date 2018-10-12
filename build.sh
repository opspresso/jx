#!/bin/bash

USERNAME=${CIRCLE_PROJECT_USERNAME}
REPONAME=${CIRCLE_PROJECT_REPONAME}

NOW=$(cat ./VERSION | xargs)
NEW=$(curl -s https://api.github.com/repos/jenkins-x/jx/releases/latest | grep tag_name | cut -d'"' -f4 | xargs)

printf '# %-10s %-10s %-10s\n' "${REPONAME}" "${NOW}" "${NEW}"

if [ "${NOW}" != "${NEW}" ]; then
    printf "${NEW}" > VERSION
    sed -i -e "s/ENV VERSION .*/ENV VERSION ${NEW}/g" Dockerfile

    if [ ! -z ${GITHUB_TOKEN} ]; then
        git config --global user.name "bot"
        git config --global user.email "bot@nalbam.com"

        git add --all
        git commit -m "${NEW}"
        git push -q https://${GITHUB_TOKEN}@github.com/${USERNAME}/${REPONAME}.git master

        echo "# git push github.com/${USERNAME}/${REPONAME} ${NEW}"

        git tag ${NEW}
        git push -q https://${GITHUB_TOKEN}@github.com/${USERNAME}/${REPONAME}.git ${NEW}
    fi
fi
