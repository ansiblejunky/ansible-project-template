#!/bin/bash
# NAME: Prepare environment vars for installing Ansible Collections locally:
#   export ANSIBLE_GALAXY_SERVER_TOKEN=<your_token>
#   source galaxy.sh
#   ansible-lint
#   ansible-lint --fix
# SOURCE: Source of truth on this configuration is located here:
#   https://github.com/ansiblejunky/ansible-project-template/blob/master/galaxy.sh

if [[ -z "${ANSIBLE_GALAXY_SERVER_TOKEN}" ]]; then
  echo "Environment Variable 'ANSIBLE_GALAXY_SERVER_TOKEN' is not set"
  return 1
fi

export ANSIBLE_GALAXY_SERVER_LIST=certified,validated,community

export ANSIBLE_GALAXY_SERVER_CERTIFIED_URL=https://console.redhat.com/api/automation-hub/content/published/
export ANSIBLE_GALAXY_SERVER_CERTIFIED_AUTH_URL=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
export ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN=${ANSIBLE_GALAXY_SERVER_TOKEN}

export ANSIBLE_GALAXY_SERVER_VALIDATED_URL=https://console.redhat.com/api/automation-hub/content/validated/
export ANSIBLE_GALAXY_SERVER_VALIDATED_AUTH_URL=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
export ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN=${ANSIBLE_GALAXY_SERVER_TOKEN}

export ANSIBLE_GALAXY_SERVER_COMMUNITY_URL=https://galaxy.ansible.com

echo "Ansible Galaxy Environment Variables Have Been Configured"