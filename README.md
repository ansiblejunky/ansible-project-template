# Ansible Playbook Repository

Example Ansible Playbook repository containing an initial structure that is a great starting point for anyone wanting to kickstart with Ansible.  Best practice states you should manage one repository for your Ansible Playbooks and separate repositories for each of your Ansible Roles.

The purpose of having an Ansible Playbook repo is to maintain a single source of truth with regards to the following elements:

- Inventory (hosts, groups, environments, platforms)
- Configuration Management (variables)
- Plugins
- Linting rules
- Playbooks
- etc.

Ansible Playbooks should be very short and simple - they define **where** and **what**. Ansible Roles should be environment-agnostic and answer **how**. Therefore they should be built independently from the Ansible Playbook repository. This allows **any** Ansible Playbook to use the Ansible Role and run the tasks against **any** environment. The overall goal for Ansible Roles is to be a reusable and encapsulated object.

## Ansible Roles

Ansible Roles should be built and managed within their own separate repositories. An example Ansible Role repo can be found [here](https://github.com/ansiblejunky/ansible-examples-repos-role-myrole). They should **not** be built inside this repo!

We have defined our default Ansible Roles folder using the `ansible.cfg` file by setting `roles_path: roles`.

In this repo the `roles/requirements.yml` file will be used to define our Ansible Role **dependencies** that are used by our Ansible Playbooks. Additionally, you can use `include:` statements inside your requirements file to break apart the dependencies by whatever means you wish. For example, each file can represent a specific application or business vertical.

## Ansible Galaxy

When testing playbooks locally, you must manually perform the `ansible-galaxy` command to install the dependent Ansible Roles into the `roles` folder. This can be achieved using the following command:

```bash
# navigate to the playbook directory and roles folder
cd playbook_dir/roles
# download ansible roles (-f = force overwrite, -p = roles path)
ansible-galaxy install -f -r requirements.yml -p .
```

When testing in Ansible Tower, the dependent Ansible Roles are downloaded automatically. Ansible Tower automatically detects the `roles/requirements.yml` file and performs the `ansible-galaxy` command to download the roles.

Multiple roles can be installed by listing them in the `requirements.yml` file. The format of the file is YAML, and the file extension must be either .yml or .yaml.

[Installing Multiple Roles From a File](https://galaxy.ansible.com/docs/using/installing.html#installing-multiple-roles-from-a-file)

Using the `include` directive, additional YAML files can be included into a single requirements.yml file. For large projects, this provides the ability to split a large file into multiple smaller files. For more information see [Multiple Roles From Multiple Files](https://galaxy.ansible.com/docs/using/installing.html#multiple-roles-from-multiple-files). NOTE: Documentation says to use `include: <path_to_requirements>/webserver.yml`, but it should be `include: webserver.yml`.

In order to support the `roles/requirements.yml` and the fact that roles will be downloaded into this folder as we develop our playbooks, we need to ensure that git ignores the temporary role folders. The temporary role folders should not be committed to the playbook repo, but rather to the Ansible Role repo where they are maintained. To do this, we add a whitelisted entry and blacklisted entry into our `.gitignore` file.

```bash
*.retry
*.pyc

# whitelist requirements.yml and any included yml files
!*.roles/*.yml
# blacklist everything else
roles/*
```

It is important to note that since we have Ansible Playbooks and Ansible Roles in separate repositories, a Project pointing to the Ansible Playbook repo in Ansible Tower will still only check against the revision number of the Ansible Playbook repo to determine if a sync is necessary. This means if your Ansible Role repo has changed, but the Ansible Playbook repo has not, then Ansible Tower will not download the latest code from your Ansible Role repo to be used by your playbook. The solution is simple. Make sure you use tags on your revisions in your Ansible Role repos. Then you can simply update the `roles/requirements.yml` file in the Ansible Playbook repo according to the revision/tag you want to use.  That change will then trigger Ansible Tower to pull the newest Ansible Role code. This model produces a stable and controlled testing environment and is considered best practice.

## Gathering Facts

It is considered best practice to change the default setting in `ansible.cfg` from using `implicit` gathering to `explicit`. The reason is you want developers to explicitly state that facts need to be gathered for particular hosts, otherwise it can result in unwanted fact gathering tasks that consume time.

This is set in the `ansible.cfg` file:

```yaml
gathering = explicit
```

## Variables

Variables can be defined in many different places in this repo. When defining variables, first get familiar with the common filter functions such as `default`, `mandatory`, etc. Filter functions stem from Jinja and help transform data/variables. With Ansible you can use both core Jinja and core Ansible filter functions however you wish.

For Jinja core filter functions see the [list of builtin filters](http://jinja.pocoo.org/docs/2.10/templates/#builtin-filters).

For Ansible core filter functions see [this page](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html).

Some common filter functions:

- [default](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#defaulting-undefined-variables)
- [lower](http://jinja.pocoo.org/docs/2.10/templates/#lower)
- [sort](http://jinja.pocoo.org/docs/2.10/templates/#sort)
- [trim](http://jinja.pocoo.org/docs/2.10/templates/#trim)
- [unique](http://jinja.pocoo.org/docs/2.10/templates/#unique)
- [undefined](http://jinja.pocoo.org/docs/2.10/templates/#undefined)
- [mandatory](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#forcing-variables-to-be-defined)

### Group Variables

This repo contains a `group_vars` folder that includes standard connectivity variables defined for each Operating System Family. The Ansible `setup` module gathers facts about a target server and produces the `ansible_os_family` fact that describes the OS family. Therefore the filenames are named after the OS family since this is also the inventory group that our servers will be using.

For example, a Windows server will be assigned to the `windows` inventory group. As a result, Ansible will automatically load the `group_vars/windows.yml` file. For Windows servers, the recommended authentication method uses `winrm` transport and `kerberos` authentication.

For further information on Windows Remote Management (winrm), see this [link](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html).

### Multi-Stage Variables

A simple method to handle multi-stage variables is by using `vars_files` at the playbook level to load the appropriate environment-dependent variables. Do not do this inside an Ansible Role since roles should be environment agnostic and reusable. This method also supports vars files that are vaulted.

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

Additionally, Ansible Lint allows for custom rules written in Python script. These have been placed inside the `.ansible_lint` folder. See the following link for more information on writting custom Python scripts for new Ansible Lint rules:

https://docs.ansible.com/ansible-lint/rules/rules.html#creating-custom-rules

### Yaml Lint

Another linting tool that is quite helpful is the YAML Lint tool.

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

## Inventory

### Multi-Stages and Multi-Platforms

To address the challenge of managing multi-stage environments with Ansible, it is recommended read through the following resources. This applies to situation where you have multiple stages (dev, test, and prod) as well as when you have multiple platforms (AWX, Google Cloud, Azure, VmWare, etc) that have their own multiple stages (dev, test, prod). No matter the situation it is important to establish a good inventory structure so you can manage your configuration (vars) appropriately.

- [How to Manage Multistage Environments with Ansible](https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible).
- [Managing multiple environments with Ansible - best practices](https://rock-it.pl/managing-multiple-environments-with-ansible-best-practices/)
- [Ansible Playbook Structure](http://www.oznetnerd.com/ansible-playbook-structure/)
- [Ansible: Directory Layout](https://dev.to/tmidi/ansible-directory-layout-5edj)

In this repository there are two examples of inventory structures. You may choose either one for your purposes. Ansible Inventories can be constructed using either `folders` or groups or both. In the first example `hostsv1` only folders and symbolic links are used along with multiple inventory files. In the second example `hostsv2` only groups are used in a single inventory file.

### Testing the Inventory

Before you decide on your final inventory structure be sure to test it out. Use the `ansible-inventory` command to determine the output when Ansible reads your inventory structure.

Navigate to an `inventory` file and run the following command:
```
ansible-invenory -i inventory --list
```

Ensure you do not see any warning messages and you see the desired output. Variables should be assigned to hosts and group names should be listed appropriately under the right parent groups and so on.

### Moving from CLI to Ansible Tower

Now that you have established an inventory structure to hold you config elements, it's time to move your inventory into Ansible Tower.

- Create a new **Project** pointing to the Playbook repo that contains your structure
- Create a new **Inventory**
- Create a new **Inventory Source** in the new Inventory object you created
  - Select "Source from a Project"
  - Select the Project you created
  - Select the **inventory** file as the source
- Synchronize the Inventory Source to make sure it succeeds
- Notice now that your Inventory object contains the vars and hosts and groups from the inventory structure
- Notice it loaded the variables from within the `group_vars` folder as well!

Now you can manage your variables in your repo and not in Ansible Tower. This maintains our goal of Infrastructure as Code.

Please note some of the following issues:

- [Groups without hosts are missing from inventory during job run](https://github.com/ansible/awx/issues/3787)
- [](https://github.com/ansible/awx/issues/1966#issuecomment-395211292)

### Default Inventory

It is possible to set a default inventory file in the ansible.cfg file. This is a good idea for a few reasons. First, it allows you to leave off explicit inventory flags to ansible and ansible-playbook. So instead of typing:

```
$ ansible -i hosts/dev -m ping
```

You can access the default inventory by typing:

```
$ ansible -m ping
```

Secondly, setting a default inventory helps prevent unwanted changes from accidentally affecting staging or production environments. By defaulting to your development environment, the least important infrastructure is affected by changes. Promoting changes to new environments then is an explicit action that requires the -i flag.

To set a default inventory, notice the following setting in the current repo `ansible.cfg` file.

```
[defaults]
inventory      = environments/dev/hosts
```

## Playbooks

### Multi-OS-Family

To determine if your target node is a Linux or Windows system, you could use the following trick to check the open port. This makes the assumption that the Windows servers do not support SSH on port 22.

```yaml
---
- name: Detect target host operating system
  hosts: localhost
  gather_facts: false

  tasks:
  - name: Attempt to connect via SSH (port 22)
    wait_for:
      host: "{{ item }}"
      port: 22
      timeout: 10
    ignore_errors: true
    register: _ssh_connectivity
    with_items: {{ input_hosts }}

  - name: Attempt to connect via WinRM (port 5985 for HTTP, port 5986 for HTTPS)
    wait_for:
      host: "{{ item }}"
      port: 5985
      timeout: 10
    ignore_errors: true
    register: _winrm_connectivity
    with_items: {{ input_hosts }}

  - name: Add hosts to linux group
    add_host:
      name: "{{ item.item }}"
      groups: linux
    when: not item.failed and item.state = "started"
    with_items: "{{ ssh_connectivity.results }}"

  - name: Add hosts to windows group
    add_host:
      name: "{{ item.item }}"
      groups: windows
    when: not item.failed and item.state = "started"
    with_items: "{{ winrm_connectivity.results }}"

- hosts: linux
  ......play tasks.......

- hosts: windows
  ......play tasks.......

```

### Retry Files

Ansible automatically generates `*.retry` files whenever a Playbook fails on a particular host. This allows you to run the playbook again but only against the failed hosts. However, in my experience these files become more annoying rather than useful in the repo so I prefer to disable this feature. Do this in the `ansible.cfg` file:

```
[defaults]
retry_files_enabled = False
```

## Extending Ansible

Ansible can be extended using custom plugins and modules, which are written in Python code. As a general rule of thumb, only develop plugins and modules on an as-needed basis - do not directly write a module just because you want to integrate with a new system. It is not always necessary. Automation is not about writing code - it should be focused on writing meta-language (YAML) that describes "desired state".

Examples of [plugins that come with Ansible](https://github.com/ansible/ansible/tree/devel/lib/ansible/plugins).

### Filter Plugins

Place your custom filter plugins inside the `plugins/filter` folder.

Reference the following [filter plugin examples](https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py) from Ansible core filters.


## References

[The Inside Playbook - USING ANSIBLE AND ANSIBLE TOWER WITH SHARED ROLES](https://www.ansible.com/blog/using-ansible-and-ansible-tower-with-shared-roles)

## Issues

None

## License

BSD

## Author

John Wadleigh

