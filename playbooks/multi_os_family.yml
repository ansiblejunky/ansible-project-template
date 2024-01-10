---
- name: Detect target host operating system
  hosts: localhost
  gather_facts: false

  tasks:
    - name: Attempt to connect via SSH (port 22)
      ansible.builtin.wait_for:
        host: "{{ item }}"
        port: 22
        timeout: 10
      ignore_errors: true
      register: _ssh_connectivity
      with_items: "{{ input_hosts }}"

    - name: Attempt to connect via WinRM (port 5985 for HTTP, port 5986 for HTTPS)
      ansible.builtin.wait_for:
        host: "{{ item }}"
        port: 5985
        timeout: 10
      ignore_errors: true
      register: _winrm_connectivity
      with_items: "{{ input_hosts }}"

    - name: Add hosts to linux group
      ansible.builtin.add_host:
        name: "{{ item.item }}"
        groups: linux
      when: not item.failed and item.state = "started"
      with_items: "{{ ssh_connectivity.results }}"

    - name: Add hosts to windows group
      ansible.builtin.add_host:
        name: "{{ item.item }}"
        groups: windows
      when: not item.failed and item.state = "started"
      with_items: "{{ winrm_connectivity.results }}"

  # - hosts: linux
  #   ......play tasks.......

  # - hosts: windows
  #   ......play tasks.......
