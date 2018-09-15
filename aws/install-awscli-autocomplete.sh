#!/usr/bin/env bash

#############################################################
## USAGE EXAMPLE (default):
## $ AWS_COMPLETE_EXE=~/.local/bin/aws_completer ./install-awscli-autocomplete.sh
#############################################################

set -e

AWS_COMPLETE_EXE=${AWS_COMPLETE_EXE:-$(which aws_completer)}

complete -C $AWS_COMPLETE_EXE aws
