# This is in python because I did not want to have to
# parse the json manifest in shell


import simplejson as json
import os


def check_if_binary(line):
    binaries = ['protobuf', 'psycopg2']
    for binary in binaries:
        if binary in line:
            return True
    return False

source_requirements = []
binary_requirements = []

here = os.path.dirname(os.path.realpath(__file__))
python_deps_folder = os.path.join(here, '..', '..', 'src',
                                  'python-requirements')


dd_agent_dir = os.path.join(python_deps_folder, '..', 'dd-agent')
int_dir = os.path.join(python_deps_folder, '..', 'integrations-core')
source_reqs_file = os.path.join(python_deps_folder, 'source_requirements.txt')
binary_reqs_file = os.path.join(python_deps_folder, 'binary_requirements.txt')
reqs_files = []
reqs_files.append(os.path.join(dd_agent_dir, 'requirements.txt'))
reqs_files.append(os.path.join(dd_agent_dir, 'requirements-opt.txt'))


integrations = os.listdir(int_dir)

for integration in integrations:
    folder = os.path.join(int_dir, integration)
    if os.path.isdir(folder):

        manifest_file = os.path.join(folder, 'manifest.json')
        int_reqs_file = os.path.join(folder, 'requirements.txt')

        if os.path.isfile(manifest_file) and os.path.isfile(int_reqs_file):
            f = open(manifest_file)
            manifest = f.read()
            json_manifest = json.loads(manifest)
            if 'linux' in json_manifest['supported_os']:
                reqs_files.append(int_reqs_file)
            f.close()

for req_file in reqs_files:
    f = open(req_file, 'r')
    for line in f:
        if line[0] != '#' and line.strip() != '':
            req = line.strip()
            if check_if_binary(req):
                if req not in binary_requirements:
                    binary_requirements.append(req)
            else:
                if req not in source_requirements:
                    source_requirements.append(req)

    f.close()

f = open(source_reqs_file, 'w')
f.write('\n'.join(source_requirements))
f.close()

f = open(binary_reqs_file, 'w')
f.write('\n'.join(binary_requirements))
f.close()

python_blobs_folder = os.path.join(here, '..', '..', 'blobs', 'python-deps')

pip_cmd = """
pip download -r {0} -d {1} --no-binary=:all:
""".format(source_reqs_file, python_blobs_folder)

os.system(pip_cmd)
#
# pip_cmd = """
# pip download -r {0} -d {1} --platform linux_x86_64 --only-binary=:all:
# """.format(binary_reqs_file, python_blobs_folder, 'test')
# os.system(pip_cmd)
