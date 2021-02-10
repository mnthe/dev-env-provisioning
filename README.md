# dev-env-provisioning
개발 환경 프로비저닝

## Installations

### Linux

```bash
bash < <(curl -s https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/setup-linux-ubuntu.sh)
chsh -s /bin/zsh # Change default shell to zsh
```

### Windows

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) # Install chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/setup-windows.ps1'))
```

## Common Tools

### Development Tools

- [git](https://git-scm.com/)
- [vscode](https://code.visualstudio.com/)
- TODO: [docker]()
- TODO: [terraform]()
- TODO: [packer]()
- TODO: [kubectl]()
- TODO: [aws-cli]()

### Languages

- Node.js
- Go
- TODO: .Net
- TODO: python3

## Extra Tools

### Linux

- [oh-my-zsh](https://ohmyz.sh/#install)

### MacOS

### Windows Extras

