#!/bin/bash
# Don't execute this from makefile
# Because build is triggered by triggering another make files
# It seems to cause some issues or conflicts in build
# Eg: https://stackoverflow.com/questions/68379786/building-postgres-from-source-throws-utils-errcodes-h-file-not-found-when-ca
./bin/omnibus build infisical -l=debug