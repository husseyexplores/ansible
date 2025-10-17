  ### 1. You've got a fresh PC.
  - Congrats. I'm happy for you (or sad for you)

  ### 2. Clone this repo
  Clone this [repo](https://github.com/husseyexplores/ansible) at `/home/hsy`
  - `cd ~`
  - `git clone https://github.com/husseyexplores/ansible`
  - `cd ~/ansible`

  ### 3. Run the playbook
  Execute `bash setup.sh` script. [Installs/updates vital packages (ssh, git, curl, ansible)]

  Execute `ansible-playbook local.yml --ask-become-pass --ask-vault-pass`

  Or execute with tags to run specific tasks only.

  `ansible-playbook local.yml --ask-become-pass --ask-vault-pass --tag "ssh,git"`
