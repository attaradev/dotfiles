#!/bin/bash

echo "🔧 Installing VSCode extensions..."

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

# Install each extension using VSCode CLI
for EXT in "${EXTENSIONS[@]}"; do
  code --install-extension $EXT
done

echo "✅ VSCode extensions installed!"
