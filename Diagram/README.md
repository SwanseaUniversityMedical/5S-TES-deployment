# Diagram Tooling

This directory contains scripts and source files for generating a C4 diagram of 
the stack.

## `create.sh`

The `create.sh` script wraps the LikeC4 Docker container to provide easy use
of the LikeC4 tooling.

```bash
./create.sh {command}
```

### Commands

- `server`: Launch the interactive LikeC4 server for diagram editing and visualisation.
- `export`: Run the LikeC4 tool for exporting images
- `build`: Run the LikeC4 tool for building a static website

### Requirements

- Docker must be installed and running.

### Notes

- The script assumes that the script is being run in the `Diagrams` subdirectory
