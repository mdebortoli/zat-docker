# ZAT-Docker

**Note: This is not an official Zendesk project.**

ZAT-Docker is a project that makes it easier to use Zendesk Apps Tools (ZAT) within a Docker container.

This project offers a convenient solution by bundling all the necessary components, like Ruby, libraries, and tools needed for ZAT, into a ready-to-use Docker image. By using ZAT-Docker, you can effortlessly install and use ZAT within a Docker container.

## Installation

To use ZAT within a Docker container, follow these steps:

1. Install Docker on your machine by following the [official Docker installation guide](https://docs.docker.com/get-docker/).
2. Pull the Docker image by running the following command:

   ```shell
   docker pull mdebortoli/zat-docker
   ```

## Usage

After installing the ZAT-Docker image, you can use ZAT either by executing ZAT commands directly through the Docker command or by adding a system alias, which emulates the exact behavior of ZAT if it were installed locally.

### Using the Docker command

To use ZAT via the Docker command, follow these steps:

1. Open a terminal window.
2. Navigate to the directory where your Zendesk app files are located.
3. Execute the following Docker command:

   ```shell
   docker run -it --rm -u "$(id -u):$(id -g)" -p 4567:4567 -v "$(pwd)":/data mdebortoli/zat-docker zat <command>
   ```

   Replace `<command>` with the specific ZAT command you want to run.

   **Example:**

   ```shell
   docker run -it --rm -u "$(id -u):$(id -g)" -p 4567:4567 -v "$(pwd)":/data mdebortoli/zat-docker zat server
   ```

   Note: If you provide a custom port to run the ZAT command, remember to also update the Docker port you want to expose.

   **Example:**

   ```shell
   docker run -it --rm -u "$(id -u):$(id -g)" -p 1234:1234 -v "$(pwd)":/data mdebortoli/zat-docker zat server --port 1234
   ```

### Using the alias (Linux and Mac OS users)

To install the `zat` alias, follow these steps:

1. Open a terminal window.
2. Create a `bin` folder in your home folder.

   ```shell
   mkdir -p ~/bin
   ```

3. Create a `zat` file in the `~/bin` folder.

   ```shell
   touch ~/bin/zat
   ```

4. Make the `zat` file executable.

   ```shell
   chmod +x ~/bin/zat
   ```

5. Open your `~/bin/zat` file using a text editor and add the following lines:

   ```shell
   #!/bin/bash

   # ZAT-Docker alias

   port=4567
   args=()

   while [ "$#" -gt 0 ]; do
     case "$1" in
       --port=*)
         port="${1#*=}"
         shift
         ;;
       --port)
         if [ -n "$2" ]; then
           port="$2"
           shift 2
         else
           break
         fi
         ;;
       *)
         args+=("$1")
         shift
         ;;
     esac
   done

   if [ "$port" -ne 4567 ]; then
     args+=("--port" "$port")
   fi

   docker run -it --rm -u "$(id -u):$(id -g)" -p "${port}:${port}" -v "$(pwd)":/data mdebortoli/zat-docker zat "${args[@]}"
   ```

   ### Apple M1/M2 users (ignore this step if you're not using Apple M1/M2 processors)

   If you're using a Mac OS running on M1 or M2 processors, you can add `--platform linux/amd64` to your Docker commands to avoid architecture warnings.

   In your `zat` file, replace this:

   ```shell
   docker run -it --rm -u "$(id -u):$(id -g)" -p "${port}:${port}" -v "$(pwd)":/data mdebortoli/zat-docker zat "${args[@]}"
   ```

   With this:

   ```shell
   docker run --platform linux/amd64 -it --rm -u "$(id -u):$(id -g)" -p "${port}:${port}" -v "$(pwd)":/data mdebortoli/zat-docker zat "${args[@]}"
   ```

6. Open your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`) using a text editor and add the following lines at the end of the file:

   ```shell
   # Local aliases
   if ! echo "$PATH" | grep -q "$HOME/bin"; then
     export PATH="$HOME/bin:$PATH"
   fi
   ```

7. Save the file and exit the text editor.
8. Restart your terminal or run `source <path-to-config-file>` to load the updated configuration (e.g., `source ~/.bashrc`).

After installing the alias, you can use the `zat` command as if it were installed locally. Navigate to the directory containing your app files and run ZAT commands directly without the need for the lengthy Docker command.

**Example:**

```shell
zat new
```

## How to use ZAT

To learn about the available commands and usage details of Zendesk Apps Tools (ZAT), please refer to the [official Zendesk documentation for ZAT commands](https://developer.zendesk.com/documentation/apps/zendesk-app-tools-zat/zat-commands/).
