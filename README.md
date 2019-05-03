# Ansible Playbook Repository

## Playbooks


## Roles

This repo contains a `roles` folder that includes a `requirements.yml`. It defines the Ansible Role dependencies that is used by the `ansible-galaxy` command. 

Two folders have been created to hold Ansible Roles for organizational purposes. The `ansible.cfg` has been modified to tell Ansible to search within these two folders for Ansible Roles.

The `roles/common/` folder can be used for roles that we want to maintain inside this playbook repo. This is generally not recommended, however it is available for exceptions.

The `roles/galaxy/` folder is the default folder where the `ansible-galaxy` command will install all dependent roles defined by the `requirements.yml` file.  This path has been defined in the `ansible.cfg`. 

When testing playbooks locally, you must manually perform the `ansible-galaxy` command to install the dependent Ansible Roles into the `roles/galaxy/` folder. This can be achieved using the following command:
```
ansible-galaxy install -r roles/requirements.yml
```

When testing in Ansible Tower, the dependent Ansible Roles are downloaded automatically. Ansible Tower detects the `roles/requirements.yml` file and performs the `ansible-galaxy` command automatically.

It is important to note that since we are separating Ansible Playbooks and Ansible Roles in separate repositories, a Project pointing to the Ansible Playbook repo in Ansible Tower will still only check against the revision number of the Ansible Playbook repo to determine if a sync is necessary. This means if your Ansible Role repo has changed, but the Ansible Playbook repo has not, then Ansible Tower will not download the latest code from your Ansible Role repo to be used by your playbook. The solution is simple. Make sure you use tags on your revisions in your Ansible Role repos. Then you can simply update the `roles/requirements.yml` file in the Ansible Playbook repo according to the revision/tag you want to use.  That change will then trigger Ansible Tower to pull the newest Ansible Role code. This model produces a stable and controlled testing environment and is considered best practice.

## Ansible Lint

This repo uses [Ansible Lint](https://docs.ansible.com/ansible-lint/) to perform various lint tests on YAML files.

The repo contains an Ansible Lint configuration file (.ansible-lint) to configure the default options and determine rules to skip as well as rules to enforce. A list of all default rules and their descriptions can be found [here](https://docs.ansible.com/ansible-lint/rules/default_rules.html#default-rules).

Additionally, Ansible Lint allows for custom rules written in Python script. These can be placed inside the `ansible_lint/rules/` folder. See the following link for more information on writting custom Python scripts for new Ansible Lint rules:

https://docs.ansible.com/ansible-lint/rules/rules.html#creating-custom-rules

## Pre-Commit Hooks

This repo uses the multi-language package manager for pre-commit hooks called [pre-commit](https://pre-commit.com/). Before you can run hooks, you need to have the pre-commit package manager installed.
```
pip install pre-commit
```

## License

BSD

## Author

John Wadleigh

