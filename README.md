# ansible-playbook
An ansible playbook to deploy lug.org.uk infrastructure. This playbook is one part of three to define the lug.org.uk services, and enable off-box testing of the environment, using virtualization with Vagrant.

## How to use this playbook?

* Clone the repository `git clone --recursive https://github.com/lugorguk/ansible-playbook`
* then EITHER
  * Enter the playbook "shared secret" by creating a file called vault-password in the root of this playbook
  * OR Create new files in `/group_vars/all` called 
    * `admins.vault.yml` based on `admins.vault.example`
    * `service.vault.yml` based on `service.vault.example`
    * `lugs.vault.yml` based on `lugs.vault.example` (this may become unencrypted at some point in the future, to permit PRs to get LUGs created on the system.)
* then EITHER
  * Run the playbook against lug.org.uk with `ansible-playbook site.yml -i hosts.live`
  * OR have run it as part of [the Vagrantfile](https://github.com/lugorguk/vagrant-lab-infrastructure) by running `vagrant up`
