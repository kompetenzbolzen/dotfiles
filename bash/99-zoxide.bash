#!/bin/bash

if which zoxide > /dev/null 2>&1 && [ ! "$FORCE_NORMAL_CD" = "yes" ] ; then
	eval "$(zoxide init bash --cmd cd)"
fi
