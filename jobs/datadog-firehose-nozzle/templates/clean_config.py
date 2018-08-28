import sys
import json


def clean_secret(secret, retain_last=False, truncate_length=False):
    i = 0
    cleaned_secret = ''
    for c in secret:
        if i > len(secret) - 6 and retain_last:
            cleaned_secret += c
        else:
            cleaned_secret += '*'
        if i == 5 and truncate_length:
            return cleaned_secret
        i += 1
    return cleaned_secret

def clean_secret_list(secret_list, retain_last=False, truncate_length=False):
    cleaned_secret_list = []
    for c in secret_list:
        cleaned_secret_list.append(clean_secret(c, retain_last, truncate_length))
    return cleaned_secret_list

def main():
    if len(sys.argv) != 3:
        print("please include the path to the config file as the first argument and the path to the cleaned file as the second")
        sys.exit(1)
    config_file_path=sys.argv[1]
    cleaned_conig_file_path=sys.argv[2]
    with open(config_file_path, 'r') as f:
        config_file = f.read()

    config_json = json.loads(config_file)
    config_json['ClientSecret'] = clean_secret(config_json['ClientSecret'], truncate_length=True)
    config_json['DataDogAPIKeys'] = clean_secret_list(config_json['DataDogAPIKeys'], retain_last=True)

    with open(cleaned_conig_file_path, 'w') as f:
        f.write(json.dumps(config_json, indent=4))

if __name__ == '__main__':
    main()
