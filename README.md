# ZAT-Docker

**Note: This is not an official Zendesk project.**

ZAT-Docker is a project that makes it easier to use Zendesk Apps Tools (ZAT) by running it inside a Docker container.

This project offers a convenient solution by bundling all the necessary components, like Ruby, libraries, and tools needed for ZAT, into a ready-to-use Docker image. By using ZAT-Docker, you can effortlessly install and use ZAT within a Docker environment, making your Zendesk app development process more efficient.

## Installation

To use ZAT within the Docker container, follow these steps:

1. Install Docker on your machine by following the [official Docker installation guide](https://docs.docker.com/get-docker/).
2. Pull the Docker image by running the following command:
   ```
   docker pull mdebortoli/zat-docker
   ```

## Usage

After installing the ZAT-Docker container, you can use ZAT either by executing ZAT commands directly through the Docker command or by adding a system alias, which emulates the exact behavior of ZAT if it were installed locally.

### Using Docker command

To use ZAT via the Docker command, follow these steps:

1. Open a terminal or command prompt.
2. Navigate to the directory where your app files are located.
3. Execute the following Docker command:

   ```
   docker run -it --rm -u "$(id -u):$(id -g)" -p 4567:4567 -v "$(pwd)":/data mdebortoli/zat-docker zat <command>
   ```

   Replace `<command>` with the specific ZAT command you want to run.

   **Example:**

   ```
   docker run -it --rm -u "$(id -u):$(id -g)" -p 4567:4567 -v "$(pwd)":/data mdebortoli/zat-docker zat server
   ```

   Note: If you provide a custom port to run a ZAT command, remember to also update the Docker port you want to expose.

   **Example:**

   ```
   docker run -it --rm -u "$(id -u):$(id -g)" -p 1234:1234 -v "$(pwd)":/data mdebortoli/zat-docker zat server --port 1234
   ```

### Installing the alias

To install the alias, follow these steps:

1. Open a terminal or command prompt.
2. Open your shell's configuration file (e.g., `~/.bash_aliases`, `~/.bash_profile`, `~/.bashrc`, `~/.zshrc`) using a text editor.
3. Add the following lines at the end of the file:

   ```bash
   function zat() {
     local port=4567
     local args=()

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
   }
   ```

4. Save the file and exit the text editor.
5. Restart your terminal or run `source <path-to-config-file>` to load the updated configuration (e.g., `source ~/.bash_aliases`).

After installing the alias, you can use the `zat` command as if it were installed locally. Navigate to the directory containing your app files and run ZAT commands directly without the need for the lengthy Docker command.

**Example:**

```
zat theme preview
```

## How to use ZAT

To learn about the available commands and usage details of Zendesk Apps Tools (ZAT), please refer to the official Zendesk documentation for ZAT commands: [Zendesk Apps Tools (ZAT) documentation](https://developer.zendesk.com/documentation/apps/zendesk-app-tools-zat/zat-commands/).
