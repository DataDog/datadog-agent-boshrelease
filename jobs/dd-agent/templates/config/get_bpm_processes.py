import sys

import yaml

with open(sys.argv[1]) as f:
    bpm_conf = yaml.load(f, Loader=yaml.SafeLoader)

for bpm_process in bpm_conf["processes"]:
    process_check_instance = {
        "name": bpm_process["name"],
        "search_string": [f"^{bpm_process['executable']}"],
        "exact_match": False,
    }
    yaml.dump([process_check_instance], sys.stdout, Dumper=yaml.SafeDumper)
