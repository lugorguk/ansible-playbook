#!/bin/bash
DIRNAME="$(dirname "$0")"
pip3 install -r "$DIRNAME/requirements.txt"
ansible-playbook "$DIRNAME/site.yml" --vault-password-file="$DIRNAME/vaultpw"
