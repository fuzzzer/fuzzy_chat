import os
import sys

# Configuration Section
# Default directory to process if none is provided via command-line argument
DEFAULT_DIRECTORY = '../lib/src'

def process_dart_files(directory):
    # Dictionary to track folder-level export files for parent directories
    folder_export_files = {}  # Key: folder path, Value: list of export statements for that folder

    # Walk through the directory recursively, processing from the bottom up
    for root, dirs, files in os.walk(directory, topdown=False):
        # Get Dart files in the current directory
        dart_files = [file for file in files if file.endswith('.dart') and not file.endswith('.g.dart')]

        # Skip if no .dart files found in this folder
        if not dart_files:
            continue

        # The name of the export file should match the folder name
        folder_name = os.path.basename(root)
        export_file_path = os.path.join(root, f"{folder_name}.dart")

        # Prepare export statements for each Dart file in the folder
        export_statements = []
        part_files = set()

        # First, identify files with `part of` directive to avoid exporting them
        for dart_file in dart_files:
            file_path = os.path.join(root, dart_file)
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                if any(line.strip().startswith('part of') for line in lines):
                    part_files.add(dart_file)

        # Now prepare the export statements for Dart files
        for dart_file in dart_files:
            # Skip the folder's own export file or files with `part of`
            if dart_file == f"{folder_name}.dart" or dart_file in part_files:
                continue
            export_statements.append(f"export '{dart_file}';")

        # Include exports for subfolder export files
        for dir in dirs:
            subfolder_export_file = os.path.join(root, dir, f"{dir}.dart")
            if os.path.exists(subfolder_export_file):
                export_statements.append(f"export '{dir}/{dir}.dart';")

        # Sort export statements
        export_statements.sort()

        if not export_statements:
            continue  # Skip if there's nothing to export

        existing_exports = set()
        import_lines = []
        remaining_lines = []

        if os.path.exists(export_file_path):
            # If the export file exists, read its content
            with open(export_file_path, 'r', encoding='utf-8') as export_file:
                lines = export_file.readlines()

            # Collect existing export statements and categorize lines
            for line in lines:
                stripped_line = line.strip()
                if stripped_line.startswith('import'):
                    import_lines.append(line)
                elif stripped_line.startswith('export'):
                    existing_exports.add(stripped_line)
                else:
                    # Any lines after exports are considered remaining content
                    remaining_lines.append(line)
        else:
            # If the file doesn't exist, initialize remaining content
            remaining_lines = []

        # Combine new and existing exports
        all_export_statements = sorted(existing_exports.union(export_statements))

        # Write or update the export file with sorted exports after imports
        with open(export_file_path, 'w', encoding='utf-8') as export_file:
            # Write import statements
            export_file.writelines(import_lines)
            # Ensure exactly one empty line after imports
            if import_lines and import_lines[-1].strip() != '':
                export_file.write('\n')

            # Write export statements
            export_file.write("\n".join(all_export_statements) + "\n")
            # Ensure exactly one empty line after exports if there is remaining content
            if remaining_lines:
                export_file.write('\n')

            # Write remaining content
            # Remove leading empty lines from remaining content to prevent extra gaps
            while remaining_lines and remaining_lines[0].strip() == '':
                remaining_lines.pop(0)
            export_file.writelines(remaining_lines)

        print(f"Updated {export_file_path} with new exports.")

        # Track folder-level export files for parent directory
        parent_folder = os.path.dirname(root)
        parent_export_statement = f"export '{os.path.basename(root)}/{folder_name}.dart';"
        if parent_folder in folder_export_files:
            folder_export_files[parent_folder].append(parent_export_statement)
        else:
            folder_export_files[parent_folder] = [parent_export_statement]

    # Now, update the export files for parent directories
    for root, dirs, files in os.walk(directory, topdown=True):
        # If we have collected export statements for this directory, write or update its export file
        if root in folder_export_files:
            export_statements = folder_export_files[root]
            export_statements.sort()
            folder_name = os.path.basename(root)
            export_file_path = os.path.join(root, f"{folder_name}.dart")

            existing_exports = set()
            import_lines = []
            remaining_lines = []

            if os.path.exists(export_file_path):
                # If the export file exists, read its content
                with open(export_file_path, 'r', encoding='utf-8') as export_file:
                    lines = export_file.readlines()

                # Collect existing export statements and categorize lines
                for line in lines:
                    stripped_line = line.strip()
                    if stripped_line.startswith('import'):
                        import_lines.append(line)
                    elif stripped_line.startswith('export'):
                        existing_exports.add(stripped_line)
                    else:
                        remaining_lines.append(line)
            else:
                remaining_lines = []

            # Combine new and existing exports
            all_export_statements = sorted(existing_exports.union(export_statements))

            # Write or update the export file with sorted exports after imports
            with open(export_file_path, 'w', encoding='utf-8') as export_file:
                # Write import statements
                export_file.writelines(import_lines)
                # Ensure exactly one empty line after imports
                if import_lines and import_lines[-1].strip() != '':
                    export_file.write('\n')

                # Write export statements
                export_file.write("\n".join(all_export_statements) + "\n")
                # Ensure exactly one empty line after exports if there is remaining content
                if remaining_lines:
                    export_file.write('\n')

                # Write remaining content
                # Remove leading empty lines from remaining content to prevent extra gaps
                while remaining_lines and remaining_lines[0].strip() == '':
                    remaining_lines.pop(0)
                export_file.writelines(remaining_lines)

            print(f"Updated {export_file_path} with new folder exports.")

    # Finally, create or update the root export file
    root_folder_name = os.path.basename(directory.rstrip('/\\'))
    root_export_file = os.path.join(directory, f"{root_folder_name}.dart")
    export_statements = []

    # Include export statements for all top-level subdirectories that have export files
    for dir in next(os.walk(directory))[1]:
        subfolder_export_file = os.path.join(directory, dir, f"{dir}.dart")
        if os.path.exists(subfolder_export_file):
            export_statements.append(f"export '{dir}/{dir}.dart';")

    if export_statements:
        export_statements.sort()
        existing_exports = set()
        import_lines = []
        remaining_lines = []

        if os.path.exists(root_export_file):
            # If the export file exists, read its content
            with open(root_export_file, 'r', encoding='utf-8') as export_file:
                lines = export_file.readlines()

            # Collect existing export statements and categorize lines
            for line in lines:
                stripped_line = line.strip()
                if stripped_line.startswith('import'):
                    import_lines.append(line)
                elif stripped_line.startswith('export'):
                    existing_exports.add(stripped_line)
                else:
                    remaining_lines.append(line)
        else:
            remaining_lines = []

        # Combine new and existing exports
        all_export_statements = sorted(existing_exports.union(export_statements))

        # Write or update the root export file with sorted exports after imports
        with open(root_export_file, 'w', encoding='utf-8') as export_file:
            # Write import statements
            export_file.writelines(import_lines)
            # Ensure exactly one empty line after imports
            if import_lines and import_lines[-1].strip() != '':
                export_file.write('\n')

            # Write export statements
            export_file.write("\n".join(all_export_statements) + "\n")
            # Ensure exactly one empty line after exports if there is remaining content
            if remaining_lines:
                export_file.write('\n')

            # Write remaining content
            # Remove leading empty lines from remaining content to prevent extra gaps
            while remaining_lines and remaining_lines[0].strip() == '':
                remaining_lines.pop(0)
            export_file.writelines(remaining_lines)

        print(f"Updated {root_export_file} with new exports.")

if __name__ == "__main__":
    # Parse command-line arguments
    if len(sys.argv) > 1:
        # Use the directory provided as a command-line argument
        input_path = sys.argv[1]
        # If the provided path is relative, convert it to an absolute path
        if not os.path.isabs(input_path):
            script_dir = os.path.dirname(os.path.abspath(__file__))
            lib_folder = os.path.abspath(os.path.join(script_dir, input_path))
        else:
            lib_folder = input_path
    else:
        # Use the default directory from the configuration
        script_dir = os.path.dirname(os.path.abspath(__file__))
        lib_folder = os.path.abspath(os.path.join(script_dir, DEFAULT_DIRECTORY))

    # Verify that the directory exists
    if not os.path.isdir(lib_folder):
        print(f"Error: The directory '{lib_folder}' does not exist.")
        sys.exit(1)

    # Process all Dart files in the specified directory
    process_dart_files(lib_folder)
