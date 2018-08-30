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


def clean_additional_endpoints_secrets(additional_endpoints, retain_last=False, truncate_length=False):
    clean_additional_endpoints_keys = {}
    for url, keys in additional_endpoints.iteritems():
        clean_additional_endpoints_keys[url] = clean_secret(keys, retain_last, truncate_length)
    return clean_additional_endpoints_keys


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
    config_json['DataDogAPIKey'] = clean_secret_list(config_json['DataDogAPIKey'], retain_last=True)
    config_json['DataDogAdditionalEndpoints'] = clean_additional_endpoints_secrets(config_json['DataDogAdditionalEndpoints'], retain_last=True)

    with open(cleaned_conig_file_path, 'w') as f:
        f.write(json.dumps(config_json, indent=4))


if __name__ == '__main__':
    main()
