#!/usr/bin/python

import sys
import json

# Example taken from https://github.com/DataDog/datadog-agent/blob/master/docs/agent/secrets.md#the-executable-api
# and translated to python
def main():
    data = json.loads(sys.stdin.read())

    res = {}
    for secret_handle in data["secrets"]:
        res[secret_handle] = {
            "value": "decrypted_{}".format(secret_handle),
            "error": None,
        }

    sys.stdout.write(json.dumps(res))

if __name__ == "__main__":
    main()
