import sys

if len(sys.argv) > 1:
    env_file_name = sys.argv[1]
    with open(env_file_name, 'w+') as env_file: 
        for python_path in sys.path:
            if python_path:
                env_file.write("PYTHON_PATH={}:$PYTHONPATH\n".format(python_path))

        