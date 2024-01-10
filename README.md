# Ansible Project Template

This repository belongs in a family of repository templates:

- [ansible-project-template](https://github.com/ansiblejunky/ansible-project-template)
- [ansible-inventory-template](https://github.com/ansiblejunky/ansible-inventory-template)
- [ansible-role-template](https://github.com/ansiblejunky/ansible-role-template)
- TODO: Collection?

## Overview

This repository is part of a set of template repositories. Ansible best practice suggests an Ansible Project repository and separate repositories for your Ansible Roles. The purpose of having an Ansible Project repo is to maintain a single source of truth with regards to the following elements:

- Inventory (environments, hosts, groups, platforms)
- Configuration Management (variables)
- Plugins for custom behavior
- Linting rules for Continuous Integration tests
- Playbooks to run each various use cases
- Vagrantfile definitions for testing
- and more

`Ansible Playbooks` should ...

- be very short and simple and readable
- answer the questions of **WHERE** and **WHAT**
- contain one or more Plays
- be a high level workflow

`Ansible Roles` should ...

- be environment-agnostic
- answer the question of **HOW**
- be built independently from the Ansible Project repository which allows **any** Ansible Playbook to use the Ansible Role and run the tasks against **any** environment
- be a reusable, encapsulated, and environment-agnostic object

## Playbooks

- [Multi-OS-Family](playbooks/multi_os_family.yml) To determine if your target node is a Linux or Windows system, you could use the following trick to check the open port. This makes the assumption that the Windows servers do not support SSH on port 22.

## Development Environment

Do the following steps to enable linting and code syntax highlighting and immediate testing and module help.

- Enable Ansible Lint

```shell
# Configure Ansible Lint in your repository
mkdir -p .config && wget https://raw.githubusercontent.com/ansiblejunky/ansible-project-template/master/.config/ansible-lint.yml -O .config/ansible-lint.yml

# Configure GitHub Actions to trigger Ansible Lint for every push/pull-request
mkdir -p .github/workflows && wget https://raw.githubusercontent.com/ansiblejunky/ansible-project-template/master/.github/workflows/ansible-lint.yml -O .github/workflows/ansible-lint.yml

# TODO: add info for bit bucket

```

- Install the [VSCode Ansible Extension](https://marketplace.visualstudio.com/items?itemName=redhat.ansible)

- Configure Ansible extension
  - Configure the settings for the extension to use your custom execution environment image you built using `ansible-builder`

- Using Ansible extension
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

- TODO: Add `content/plugins` folder and explain in README (or insist plugins are created in separate repo as ansible role or collection?)
- TODO: how to use makefile or something to run ansible-navigator commands to run a playbook in VSCode
- TODO: Add python lint config file in this repo too, since ansible has python modules, etc; consider [flake8](https://flake8.pycqa.org/en/latest/user/configuration.html) or [pylint](https://www.codeac.io/documentation/pylint-configuration.html) and using VSCode python linting methods [here](https://code.visualstudio.com/docs/python/linting)

[Collection Template](https://github.com/ansible-collections/collection_template)

## Ansible Content - Roles, Collections, Plugins

This repository has customized the [Ansible Configuration file](ansible.cfg) to set the opinionated path for all Ansible content (Roles, Collections, Plugins) to the [content](content/) folder.

- `content/roles/requirements.yml` defines the Ansible Role **dependencies** that are used by our Ansible Playbooks
- `content/collections/requirements.yml` defines the Ansible Collection **dependencies** that are used by our Ansible Playbooks

```bash
# download ansible roles
ansible-galaxy role install -r content/roles/requirements.yml
```

## Gathering Facts

It is recommended to change the default setting in `ansible.cfg` from using `implicit` gathering to `explicit`. This forces developers to explicitly state that facts need to be gathered for particular hosts, otherwise it can result in unwanted fact gathering tasks that consume time.

This is set in the `ansible.cfg` file:

```yaml
gathering = explicit
```

## Variables

Variables can be defined in many different places in this repo. 

## Continuous Integration

This repo implements `linting` as part of the CI pipeline to ensure we `fail early and fail fast`. This is accomlished with custom configuration files for both [ansible-lint](https://docs.ansible.com/ansible-lint/) and [yamllint](https://yamllint.readthedocs.io/).

- [.yamllint](.yamllint)
- [.ansible-lint](.ansible-lint)

Run local linting tests manually by performing the following command:

```bash
ansible-lint playbooks/myplaybook.yml
```

## Inventory

In today's world of hybrid cloud, you have multiple stages (dev, test, and prod) as well as when you have multiple platforms (AWX, Google Cloud, Azure, VmWare, etc) that have their own multiple stages (dev, test, prod). To address the challenge of managing these `multi-stage environments` with Ansible, it is recommended to read through the following resources.  No matter the situation, it is important to establish a good inventory structure so you can manage your configuration (vars) appropriately.

- [How to Manage Multistage Environments with Ansible](https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible).
- [Managing multiple environments with Ansible - best practices](https://rock-it.pl/managing-multiple-environments-with-ansible-best-practices/)
- [Ansible Playbook Structure](http://www.oznetnerd.com/ansible-playbook-structure/)
- [Ansible: Directory Layout](https://dev.to/tmidi/ansible-directory-layout-5edj)

Also consider the following good practices:

- Setting a default inventory in the [Ansible Configuration File](ansible.cfg) using the `inventory` setting. This allows you to leave off explicit inventory flag (-i) and improve development turnaround time.
- Leverage the power of the `group_vars` folder to implicitly load your configuration
- Test your inventory using the `ansible-inventory` command: `ansible-inventory -i inventory --list`. Ensure you do not see any warning messages and you see the desired output. Variables should be assigned to hosts and group names should be listed appropriately under the right parent groups and so on.

More inventory information can be found [here](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html).

## Extending Ansible

Ansible can be extended using custom plugins and modules, which are written in Python code. As a general rule of thumb, only develop plugins and modules on an as-needed basis - do not directly write a module just because you want to integrate with a new system. It is not always necessary. Automation is not about writing code - it should be focused on writing meta-language (YAML) that describes "desired state".

- Filter Plugins
Place your custom filter plugins inside the `plugins/filter` folder.
Reference the following [filter plugin examples](https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py) from Ansible core filters.

It is recommended to get familiar with the common filter functions such as `default`, `mandatory`, etc. Filter functions stem from Jinja and help transform data.

- For Jinja core filter functions see the [list of builtin filters](http://jinja.pocoo.org/docs/2.10/templates/#builtin-filters).
- For Ansible core filter functions see [this page](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html).

Some common filter functions:

- [default](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#defaulting-undefined-variables)
- [lower](http://jinja.pocoo.org/docs/2.10/templates/#lower)
- [sort](http://jinja.pocoo.org/docs/2.10/templates/#sort)
- [trim](http://jinja.pocoo.org/docs/2.10/templates/#trim)
- [unique](http://jinja.pocoo.org/docs/2.10/templates/#unique)
- [undefined](http://jinja.pocoo.org/docs/2.10/templates/#undefined)
- [mandatory](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#forcing-variables-to-be-defined)

### Moving to Ansible Automation Platform (AAP)

TODO: add info to create job template too
Now that you have established an inventory structure and infra-as-code, it's time to move your inventory into Ansible Automation Platform (AAP).

- Create a new **Project** pointing to the Ansible Project version control repo
- Create a new **Inventory**
- Create a new **Inventory Source** in the new Inventory object you created
  - Select "Source from a Project"
  - Select the Project you created
  - Select the **inventory** file as the source
- Synchronize the Inventory Source to make sure it succeeds
- Notice now that your Inventory object contains the vars and hosts and groups from the inventory structure
- Notice it loaded the variables from within the `group_vars` folder as well!

## Using Ansible Navigator

TODO: Add info
- [ansible-navigator demo](https://www.youtube.com/watch?v=J9PBKi8ydi4)

## References

- [The Inside Playbook - USING ANSIBLE AND ANSIBLE TOWER WITH SHARED ROLES](https://www.ansible.com/blog/using-ansible-and-ansible-tower-with-shared-roles)
- [Rolling Updates, Performance, Strategies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

## License

BSD

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

