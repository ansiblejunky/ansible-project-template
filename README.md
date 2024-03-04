# Ansible Project Template

This repository represents a template for starting a new Ansible Project. It has all of the important folders and files that are often needed and gives a great starting point.

- [ansible-project-template](https://github.com/ansiblejunky/ansible-project-template)
- [ansible-inventory-template](https://github.com/ansiblejunky/ansible-inventory-template)

## Overview

Ansible recommends creating an `Ansible Project` repository along with separate repositories for your Ansible Roles and Ansible Collections. This repository covers the following Ansible concepts:

- [.config](.config) folder contains lint rules and other configuration
- [.github](.github) folder contains GitHub workflow action configuration
- [collections](./collections/) folder contains definitions of Ansible Collections
- [roles](./roles/) folder contains definitions of Ansible Roles
- [hosts](./hosts/) folder contains Ansible inventory and configuration management with group variables
- [plugins](./plugins/) folder contains custom Ansible plugins for inventory, filter, action, callback, and so on
- [playbooks](./playbooks/) folder contains Ansible Playbooks to perform actions
- Continuous Testing is performed using linting various tools
  - Ansible Lint
  - Flake8 for Python linting
  - PyLint for Python linting

## Standard Practices

Review the following blog on [Ansible Standards and Best Practices](https://www.ansiblejunky.com/blog/ansible-101-standards/).

## Development Environment

TODO: Create demo video to prepare development environment

Do the following steps to prepare your Ansible development environment:

- Create python virtual environment *Manually or using VSCode .vscode and .venv folders
- Enable/set Python Interpreter Path in VSCode
- Install and configure VSCode extensions
- Validate linting in VSCode ("Problems" tab and code highlighting and fixing errors)
- Validate Ansible extension in VSCode (in-place code advise for modules and parameters)
- Enable GitHub actions (and test locally using `act`)
- Enable Bit Bucket pipelines
- Install and configure Python linter in VSCode (pylint or flake8)
- Validate Python linting in VSCode ("Problems" tab)
- Advanced: Configure and use Execution Environments to perform linting and tests in VSCode using Ansible extension

Enable linting and code syntax highlighting and in-place module/parameter advise as well as testing.

- Enable Ansible Lint

```shell
# Configure Ansible Lint in your repository
mkdir -p .config && wget https://raw.githubusercontent.com/ansiblejunky/ansible-project-template/master/.config/ansible-lint.yml -O .config/ansible-lint.yml

# Configure GitHub Actions to trigger Ansible Lint for every push/pull-request
mkdir -p .github/workflows && wget https://raw.githubusercontent.com/ansiblejunky/ansible-project-template/master/.github/workflows/ansible-lint.yml -O .github/workflows/ansible-lint.yml

# TODO: add info for Bit Bucket

```

- Test GitHub Actions locally using [act](https://nektosact.com/introduction.html)

```shell
# Run act to test github action locally
act -v

# Run act on Apple M-series chip
act --container-architecture linux/amd64 -v
```

- Install the [Ansible Extension](https://marketplace.visualstudio.com/items?itemName=redhat.ansible)

- Configure Ansible Extension
  - Configure the settings for the extension to use your custom execution environment image you built using `ansible-builder`
  - Add file associates into VSCode `settings.json` so that VSCode detects Ansible files correctly using this [hack](https://github.com/ansible/vscode-ansible/issues/162#issuecomment-908133169)
  
- Using Ansible Extension
  - You can show module options as you edit your playbook by enabling [VSCode IntelliSense](https://code.visualstudio.com/docs/editor/intellisense#_intellisense-features): Ctrl+Space
  - When issues arrise or odd behavior from the Ansible extension, view the VSCode `Output` window (View -> Output menu item) and select `Ansible Support` in the drop down on the right side to see what is happening inside the extension
  - To log issues with the extension use [vscode-ansible](https://github.com/ansible/vscode-ansible) GitHub repository
- Generate latest `ansible.cfg` using the [ansible-config](https://docs.ansible.com/ansible/latest/cli/ansible-config.html) tool

- Extensions
  - [TODO Highlight](https://marketplace.visualstudio.com/items?itemName=wayou.vscode-todo-highlight)
  - [Python auto formatters](https://www.kevinpeters.net/auto-formatters-for-python)
  - [Docker]
  - [Dev Containers]
  - [Jinja]
  - [Remote Development]
  - [Vagrant]
  - [CloudFormation Linter]
  - [AsciiDoc]

- Using a [Python Linter](https://code.visualstudio.com/docs/python/linting) in VSCode
  - consider [flake8](https://flake8.pycqa.org/en/latest/user/configuration.html)
  - consider [pylint](https://www.codeac.io/documentation/pylint-configuration.html)
  - consider Github Action for [flake8](https://github.com/py-actions/flake8)

```shell
# Install lint tools locally
pip install pylint flake8
# Run lint tools locally
pylint
flake8
```

## Testing

Using `Ansible Playbook`:

```shell
ansible-playbook playbooks/example.yml
```

Using `Ansible Navigator`:

- [ansible-navigator demo](https://www.youtube.com/watch?v=J9PBKi8ydi4)

Using `Ansible Automation Platform (AAP)`:

TODO: add info to create job template too
TODO: (Option 1) Use playbook to create objects in AAP!
TODO: (Option 2) Manually create objects in AAP to support a Job Template

- Create a new **Project** pointing to the Ansible Project version control repo
- Create a new **Inventory**
- Create a new **Inventory Source** in the new Inventory object you created
  - Select "Source from a Project"
  - Select the Project you created
  - Select the **inventory** file as the source
- Synchronize the Inventory Source to make sure it succeeds
- Notice now that your Inventory object contains the vars and hosts and groups from the inventory structure
- Notice it loaded the variables from within the `group_vars` folder as well!
- Create a new **Job Template**
  - Set the name
  - Set the Project
  - Set the Playbook
  - Set the Credentials

## References

- [The Inside Playbook - USING ANSIBLE AND ANSIBLE TOWER WITH SHARED ROLES](https://www.ansible.com/blog/using-ansible-and-ansible-tower-with-shared-roles)
- [Rolling Updates, Performance, Strategies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

## License

GNUv3

## Author

John Wadleigh


## TODO:

Ansible Framework:

Playbook:

---
- hosts: localhost
  #connection: local

TODO: get the framework from HCSC that checks for Windows or Linux machine using port check!

  (payload provided from external system)

  tasks:
  - include_role:
      name: provision
    vars:
      os_string: "{{ item.os_string }}"
      ...
    with_items: "{{ buildlist }}"
    when: ansible_os_family == windows

  - include_role:
      name: provision
    vars:
      os_string: "{{ item.os_string }}"
      ...
    with_items: "{{ buildlist }}"
    when: ansible_os_family == linux

- hosts: windows
  gather_facts: true

  tasks:
  - do things

- hosts: linux
  gather_facts: true

  tasks:
  - do things

Ansible Role:

defaults/
   main.yml
tasks/
   main.yml
   linux_do_something.yml
   windows_do_something.yml
vars/
   main.yml (platform agnostic vars)
     port: 80
   linux.yml
     install_path: /opt/app
   windows.yml 
      install_path: c:\sdjfk

main.yml:

- include_tasks: "{{ ansible_os_family }}_do_something.yml"

