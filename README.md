# LogSeq to NotebookLM Migration Script

A bash script that converts LogSeq markdown files into a single consolidated file suitable for import into NotebookLM. The script includes safety measures, automated backups, and clear user feedback throughout the migration process.

## Features

- Automated backup creation before migration
- Merges both journals and pages from LogSeq
- Maintains original file hierarchy in the output structure
- Progress indicators and detailed feedback
- Comprehensive error handling
- Cleanup of temporary files
- Statistics about the migration process

## Prerequisites

- macOS operating system
- Bash shell
- Read/write permissions for the LogSeq directory
- Sufficient disk space for backup and temporary files

## Installation

1. Download the script:

```bash
curl -O https://raw.githubusercontent.com/[username]/logseq-to-notebooklm/main/logseq_to_notebooklm.sh
```

2. Make the script executable:

```bash
chmod +x logseq_to_notebooklm.sh
```

## Usage

### Method 1: Command Line Argument

Run the script by providing the path to your LogSeq directory as an argument:

```bash
./logseq_to_notebooklm.sh /path/to/your/logseq/directory
```

### Method 2: Environment Variable

Alternatively, set the LOGSEQ_DIR environment variable and run the script:

```bash
export LOGSEQ_DIR=/path/to/your/logseq/directory
./logseq_to_notebooklm.sh
```

## Output

The script generates:

1. A timestamped backup of your LogSeq directory in `~/Documents/logseq_backups/`
2. A consolidated markdown file named `notebooklm_import_[timestamp].md` in the current directory

## Directory Structure

The script expects your LogSeq directory to have the following structure:

```
logseq_directory/
├── journals/
│   └── *.md files
└── pages/
    └── *.md files
```

## Backup Location

Backups are automatically created in:

```
~/Documents/logseq_backups/backup_YYYYMMDD_HHMMSS/
```

## Error Handling

The script includes error handling for common scenarios:

- Missing input directory
- Invalid directory structure
- Permission issues
- Failed backup attempts
- Empty output file

## Customization

The script includes several variables at the top that can be modified to customize behavior:

- `TEMP_DIR`: Location for temporary files
- `BACKUP_DIR`: Location for backups
- `OUTPUT_FILE`: Name pattern for the output file

## Notes

- The script creates a complete backup before making any changes
- Temporary files are automatically cleaned up after execution
- The output file maintains a clear separation between journals and pages
- Each file is preceded by its filename as a header
- Progress messages are color-coded for better visibility

## Troubleshooting

If you encounter issues:

1. Ensure you have proper permissions for the LogSeq directory
2. Check available disk space
3. Verify the LogSeq directory structure
4. Review the error messages for specific issues

## Known Limitations

- Designed specifically for macOS
- Handles only markdown files
- Assumes standard LogSeq directory structure

## Contributing

Feel free to submit issues and enhancement requests!

## License

[Your chosen license]

## Author

[Your name/contact information]

## Version History

- 1.0.0 (2025-01-26)
  - Initial release
  - Basic migration functionality
  - Backup and safety features

```

```
