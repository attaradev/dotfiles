# 🛠 Dotfiles Setup for macOS

This repository automates the setup of a macOS development environment using:

- **Homebrew** for installing CLI tools and GUI apps.
- **NVM** (Node Version Manager) for managing Node.js versions.
- **VSCode** setup with a curated list of extensions and custom settings.

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/attaradev/dotfiles.git ~/dotfiles
cd ~/dotfiles
````

### 2. Run the setup script

```bash
./setup.sh
```

This will:

* Install Homebrew (if not already installed).
* Install all the Homebrew packages and casks listed in `brew.sh`.
* Install NVM and configure your shell to load NVM.
* Install **VSCode** and a set of recommended **VSCode extensions**.
* Apply **custom VSCode settings** and **keybindings**.

### 3. Post-Setup Configuration

After running the setup, restart your terminal or source your profile to load the NVM environment:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

Then, you can install the latest LTS version of Node.js using:

```bash
nvm install --lts
nvm use --lts
```

---

## 📂 Files Overview

| File              | Purpose                                                       |
| ----------------- | ------------------------------------------------------------- |
| `brew.sh`         | Installs Homebrew and any configured CLI tools and casks.     |
| `install_nvm.sh`  | Installs NVM and configures your shell.                       |
| `vscode_setup.sh` | Installs VSCode extensions and configures VSCode settings.    |
| `setup.sh`        | Main setup script that runs all individual setup scripts.     |

---

## 🚀 Customizing the Setup

### Add More Packages

If you'd like to add additional Homebrew packages or casks, simply modify the `brew.sh` file:

* Add **CLI tools** to the list in the `brew install` section.
* Add **GUI apps** to the list in the `brew install --cask` section.

After modifying, you can re-run the `setup.sh` to install the new items.

### Add More VSCode Extensions

If you'd like to add or remove any extensions from VSCode, modify the `vscode_setup.sh` file. Here's a list of currently installed extensions:

```bash
# List of recommended extensions
EXTENSIONS=(
  ms-python.python
  esbenp.prettier-vscode
  dbaeumer.vscode-eslint
  ms-vscode.vscode-typescript-next
  eamodio.gitlens
  donjayamanne.githistory
  james-yu.latex-workshop
  figma.figma-vscode-extension
  ms-python.vscode-pylance
  ms-azuretools.vscode-docker
  EditorConfig.EditorConfig
  christian-kohler.path-intellisense
  amazonwebservices.aws-toolkit-vscode
  kisstkondoros.vscode-codemetrics
  docker.docker
  GitHub.vscode-pull-request-github
  github.vscode-github-actions
  PKief.material-icon-theme
  GitHub.copilot
  GitHub.copilot-chat
  VisualStudioExptTeam.vscodeintellicode
  VisualStudioExptTeam.intellicode-api-usage-examples
  VisualStudioExptTeam.vscodeintellicode-completions
)
```

Once you've updated the list of extensions, rerun the `setup.sh` to install the new extensions.

---

## 🛠 Contributing

If you have any improvements or suggestions, feel free to fork the repository and submit a pull request.

---

## ⚡ License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 💡 Troubleshooting

### 1. `brew.sh` or `install_nvm.sh` doesn't run properly

* Ensure the script has execute permissions by running `chmod +x ~/dotfiles/brew.sh ~/dotfiles/install_nvm.sh`.

### 2. NVM is not working after setup

* After running the setup, ensure that the following lines are added to your `~/.zshrc` or `~/.bashrc`:

  ```bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  ```

  If they're missing, you can manually add them to the appropriate shell configuration file.

---

## 📞 Contact

For any issues or further questions, feel free to contact me on [GitHub Issues](https://github.com/attaradev/dotfiles/issues).
