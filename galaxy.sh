#!/bin/bash
# NAME: Prepare environment vars for installing Ansible Collections locally:
#   export ANSIBLE_GALAXY_TOKEN=<your_token>
#   source galaxy.sh --hub | --console
#   ansible-lint
#   ansible-lint --fix
# SOURCE: Source of truth on this configuration is located here:
#   https://github.com/ansiblejunky/ansible-project-template/blob/master/galaxy.sh

if [[ -z "${ANSIBLE_GALAXY_TOKEN}" ]]; then
  echo "Environment Variable 'ANSIBLE_GALAXY_TOKEN' is not set. Please get it from either your Automation Hub or console.redhat.com."
  return 1
fi

# Unset any previous Ansible Galaxy variables
for var in $(env | grep '^ANSIBLE_GALAXY_SERVER_' | cut -d= -f1); do
  unset "$var"
done

# Check for parameters
if [[ "$1" == "--hub" ]]; then
  export ANSIBLE_GALAXY_SERVER_LIST=certified,validated,community
  export ANSIBLE_GALAXY_SERVER_CERTIFIED_URL=https://$2/pulp_ansible/galaxy/rh-certified/
  export ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN=${ANSIBLE_GALAXY_TOKEN}
  export ANSIBLE_GALAXY_SERVER_VALIDATED_URL=https://$2/pulp_ansible/galaxy/validated/
  export ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN=${ANSIBLE_GALAXY_TOKEN}
  export ANSIBLE_GALAXY_SERVER_COMMUNITY_URL=https://galaxy.ansible.com
  echo "Configured for Automation Hub"
elif [[ "$1" == "--console" ]]; then
  # Refresh the console.redhat.com offline token since it expires every 30 days
  curl https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token \
    -d grant_type=refresh_token \
    -d client_id="cloud-services" \
    -d refresh_token=${ANSIBLE_GALAXY_TOKEN} \
    --fail --silent --show-error --output /dev/null
  export ANSIBLE_GALAXY_SERVER_LIST=certified,validated,community
  export ANSIBLE_GALAXY_SERVER_CERTIFIED_URL=https://console.redhat.com/api/automation-hub/content/published/
  export ANSIBLE_GALAXY_SERVER_CERTIFIED_AUTH_URL=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
  export ANSIBLE_GALAXY_SERVER_CERTIFIED_TOKEN=${ANSIBLE_GALAXY_TOKEN}
  export ANSIBLE_GALAXY_SERVER_VALIDATED_URL=https://console.redhat.com/api/automation-hub/content/validated/
  export ANSIBLE_GALAXY_SERVER_VALIDATED_AUTH_URL=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
  export ANSIBLE_GALAXY_SERVER_VALIDATED_TOKEN=${ANSIBLE_GALAXY_TOKEN}
  export ANSIBLE_GALAXY_SERVER_COMMUNITY_URL=https://galaxy.ansible.com
  echo "Configured for Console"
else
  echo "Usage: source galaxy.sh --hub gateway.com | --console"
  return 1
fi

echo "Ansible Galaxy Environment Variables Have Been Configured"
