import yaml
import os

p = os.path.join(os.environ.get("WORKING_DIR"), 'releases/datadog-agent/index.yml')
version = os.environ.get('VERSION')

with open(p, 'r') as f:
    file = f.read()

    y = yaml.load(file)
    builds = y.get('builds')

    for number, info in builds.iteritems():
        build_version = info.get('version')
        if build_version == version:
            print(number)
            os.exit(0)
