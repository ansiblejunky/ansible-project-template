# Ansible Playbook Repository

## Playbooks

Overall description of your playbooks goes here. Do not list every single playbook, as each playbook should be self-documenting by using `name:` at the Play level.

## Roles

This repo contains a `roles` folder that includes a `requirements.yml`. It defines the Ansible Role dependencies that is used by the `ansible-galaxy` command.

Two folders have been created to hold Ansible Roles for organizational purposes. The `ansible.cfg` has been modified to tell Ansible to search within these two folders for Ansible Roles.

The `roles/common/` folder can be used for roles that we want to maintain inside this playbook repo. This is generally not recommended, however it is available for exceptions.

The `roles/galaxy/` folder is the default folder where the `ansible-galaxy` command will install all dependent roles defined by the `requirements.yml` file.  This path has been defined in the `ansible.cfg`.

An example Ansible Role repo can be found [here](https://github.com/ansiblejunky/ansible-examples-repos-role1).

When testing playbooks locally, you must manually perform the `ansible-galaxy` command to install the dependent Ansible Roles into the `roles/galaxy/` folder. This can be achieved using the following command:
```
ansible-galaxy install -r roles/requirements.yml
```

When testing in Ansible Tower, the dependent Ansible Roles are downloaded automatically. Ansible Tower detects the `roles/requirements.yml` file and performs the `ansible-galaxy` command automatically.

It is important to note that since we are separating Ansible Playbooks and Ansible Roles in separate repositories, a Project pointing to the Ansible Playbook repo in Ansible Tower will still only check against the revision number of the Ansible Playbook repo to determine if a sync is necessary. This means if your Ansible Role repo has changed, but the Ansible Playbook repo has not, then Ansible Tower will not download the latest code from your Ansible Role repo to be used by your playbook. The solution is simple. Make sure you use tags on your revisions in your Ansible Role repos. Then you can simply update the `roles/requirements.yml` file in the Ansible Playbook repo according to the revision/tag you want to use.  That change will then trigger Ansible Tower to pull the newest Ansible Role code. This model produces a stable and controlled testing environment and is considered best practice.

## Group Variables

This repo contains a `group_vars` folder that includes standard connectivity variables defined for each Operating System Family. The Ansible `setup` module gathers facts about a target server and produces the `ansible_os_family` fact that describes the OS family. Therefore the filenames are named after the OS family since this is also the inventory group that our servers will be using.

For example, a Windows server will be assigned to the `windows` inventory group. As a result, Ansible will automatically load the `group_vars/windows.yml` file. For Windows servers, the recommended authentication method uses `winrm` transport and `kerberos` authentication.

For further information on Windows Remote Management (winrm), see this [link](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html).

## Multi-Stage Variables

A simple method to handle multi-stage variables (both vaulted and non-vaulted) is by using `vars_files` at the playbook level to load the appropriate environment-dependent variables. Do not do this inside an Ansible Role since roles should be environment agnostic and reusable.

```yaml
---
- hosts: all
  vars_files:
  - "vars/{{ env }}.yml"
  - "vars/vault_{{ env }}.yml"
```

## Continuous Integration

This repo implements various mechanisms to ensure we "Fail early and fail fast" using CI tools such as ansible-lint, pre-commit as well as others.

### Ansible Lint

This repo uses [Ansible Lint](https://docs.ansible.com/ansible-lint/) to perform various lint tests on YAML files.

The repo contains an Ansible Lint configuration file (.ansible-lint) to configure the default options and determine rules to skip as well as rules to enforce. A list of all default rules and their descriptions can be found [here](https://docs.ansible.com/ansible-lint/rules/default_rules.html#default-rules).

Additionally, Ansible Lint allows for custom rules written in Python script. These can be placed inside the `ansible_lint/rules/` folder. See the following link for more information on writting custom Python scripts for new Ansible Lint rules:

https://docs.ansible.com/ansible-lint/rules/rules.html#creating-custom-rules

### Pre-Commit Hooks

This repo uses the multi-language package manager for pre-commit hooks called [pre-commit](https://pre-commit.com/). To setup the `pre-commit` package manager follow these steps.

Install the `pre-commit` software
```
pip install pre-commit
```

Prepare the `pre-commit` configuration file by editing the `.pre-commit-config.yaml` file in the root of your repo. Add the following information to define our hooks:

```yaml
repos:
- repo: https://github.com/ansible/ansible-lint.git
  rev: v4.1.0a0
  hooks:
    - id: ansible-lint
      files: \.(yaml|yml)$
```

To install pre-commit into your git hooks
```
pre-commit install
```

pre-commit will now run on every commit. Every time you clone a project using pre-commit running `pre-commit install` should always be the first thing you do.


## Multi-Stage Environments

To address the challenge of managing multi-stage environments with Ansible, it is recommended read through the following resources.

[How to Manage Multistage Environments with Ansible](https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible).


## License

BSD

## Author

John Wadleigh

