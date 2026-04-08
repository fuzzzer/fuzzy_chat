import sys
import os
import yaml
import re
import json
import subprocess

# usage: python add_localizations.py marketplace "Some String||ka||ქართული სტრიქონი||es||Cadena en español" "Welcome {userName}||ka||მოგესალმებით {userName}"

def to_camel_case(s):
    s = re.sub(r'{[^}]*}', '', s)  # Remove placeholders
    s = re.sub(r'[^a-zA-Z\s]', '', s)  # Keep only letters and spaces
    words = s.strip().split()
    if not words:
        return ''
    first_word = words[0].lower()
    other_words = [word.capitalize() for word in words[1:]]
    return first_word + ''.join(other_words)

def extract_placeholders(message):
    placeholders = re.findall(r'{\s*(\w+)\s*(?=,|})', message)
    return list(set(placeholders))

def read_l10n_yaml(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = yaml.safe_load(f)
    return content

def add_localizations_to_arb(arb_file_path, localizations):
    with open(arb_file_path, 'r', encoding='utf-8') as f:
        try:
            arb_data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Error parsing {arb_file_path}: {e}")
            return False

    updated = False
    for key, value in localizations.items():
        if key in arb_data:
            print(f"Key '{key}' already exists in {arb_file_path}, skipping.")
            continue
        arb_data[key] = value

        placeholders = extract_placeholders(value)
        metadata = {}
        if placeholders:
            metadata['placeholders'] = {placeholder: {} for placeholder in placeholders}
        arb_data[f"@{key}"] = metadata
        updated = True

    if not updated:
        return False

    with open(arb_file_path, 'w', encoding='utf-8') as f:
        json.dump(arb_data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f"Updated {arb_file_path} with new localizations.")
    return True

def parse_localization_string(s):
    # Split the string by ||lang||, e.g., "message||ka||მესიჯი||es||mensaje"
    parts = re.split(r'\|\|(\w+)\|\|', s)
    if len(parts) == 1:
        # No localization delimiters, treat as English only
        return {'en': parts[0].strip()}, parts[0].strip()
    
    # Parts: [default_message, lang1, translation1, lang2, translation2, ...]
    default_message = parts[0].strip()
    translations = {'en': default_message}
    for i in range(1, len(parts), 2):
        lang = parts[i]
        translation = parts[i + 1].strip()
        translations[lang] = translation
    return translations, default_message

def run_flutter_gen_l10n(project_root):
    commands = [['flutter', 'gen-l10n']]
    for cmd in commands:
        try:
            subprocess.run(cmd, check=True, cwd=project_root)
            print(f"Successfully ran command: {' '.join(cmd)}")
            return
        except FileNotFoundError:
            continue
        except subprocess.CalledProcessError as e:
            print(f"Command {' '.join(cmd)} failed with exit code {e.returncode}")
            return
    print("Error: Could not find 'flutter' or 'f' command in PATH.")

def find_project_root(script_dir, project_name=None):
    if project_name:
        project_root = os.path.abspath(os.path.join(script_dir, '..', project_name))
        if os.path.isdir(project_root):
            return project_root
        else:
            print(f"Error: Project '{project_name}' not found at '../{project_name}'")
            sys.exit(1)
    else:
        l10n_yaml_in_same_dir = os.path.exists(os.path.join(script_dir, 'l10n.yaml'))
        if l10n_yaml_in_same_dir:
            return script_dir
        else:
            parent_dir, current_dir_name = os.path.split(script_dir)
            if current_dir_name == 'scripts':
                project_root = parent_dir
                if os.path.exists(os.path.join(project_root, 'l10n.yaml')):
                    return project_root
            print("Error: 'l10n.yaml' not found. Please provide the project name or ensure 'l10n.yaml' is in the project root.")
            sys.exit(1)

def main():
    args = sys.argv[1:]
    if not args:
        print("Usage: python add_localizations.py [projectName] \"String 1\" \"String 2\" ...")
        sys.exit(1)

    # Check if the first argument is a project name
    if os.path.isdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', args[0])):
        project_name = args[0]
        localization_strings = args[1:]
    else:
        project_name = None
        localization_strings = args

    if not localization_strings:
        print("Error: No localization strings provided.")
        sys.exit(1)

    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = find_project_root(script_dir, project_name)
    l10n_yaml_path = os.path.join(project_root, 'l10n.yaml')

    if not os.path.exists(l10n_yaml_path):
        print(f"Error: l10n.yaml not found in {project_root}")
        sys.exit(1)

    config = read_l10n_yaml(l10n_yaml_path)
    arb_dir = config.get('arb-dir')
    if not arb_dir:
        print("Error: 'arb-dir' not found in l10n.yaml")
        sys.exit(1)

    arb_dir_path = os.path.join(project_root, arb_dir)
    if not os.path.isdir(arb_dir_path):
        print(f"Error: ARB directory '{arb_dir_path}' does not exist")
        sys.exit(1)

    localizations_by_lang = {}
    for s in localization_strings:
        translations, default_message = parse_localization_string(s)
        key = to_camel_case(default_message)
        if not key:
            print(f"Warning: Unable to generate a key for '{default_message}'")
            continue

        for lang, message in translations.items():
            if lang not in localizations_by_lang:
                localizations_by_lang[lang] = {}
            localizations_by_lang[lang][key] = message

    if not localizations_by_lang:
        print("No valid localizations to add.")
        sys.exit(1)

    # Update ARB files
    any_updates = False
    for lang, localizations in localizations_by_lang.items():
        arb_file = f"app_{lang}.arb"
        arb_file_path = os.path.join(arb_dir_path, arb_file)
        if not os.path.exists(arb_file_path):
            print(f"Warning: ARB file '{arb_file}' does not exist, creating it.")
            with open(arb_file_path, 'w', encoding='utf-8') as f:
                json.dump({}, f, indent=2, ensure_ascii=False)
                f.write('\n')
        
        updated = add_localizations_to_arb(arb_file_path, localizations)
        if updated:
            any_updates = True

    if any_updates:
        run_flutter_gen_l10n(project_root)
    else:
        print("No updates made to any .arb files. Skipping 'flutter gen-l10n' command.")

if __name__ == '__main__':
    main()