# dev-env-provisioning
개발 환경 프로비저닝

## Installations

### Linux

```bash
bash < <(curl -s https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/setup-linux-ubuntu.sh)
chsh -s /bin/zsh # Change default shell to zsh
```

WSL을 사용할 때 credential들을 쉽게 쓰고 싶으면 아래 스크립트 추가 실행
```bash
bash < <(curl -s https://raw.githubusercontent.com/mnthe/dev-env-provisioning/main/wsl_link_configs.sh)
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
- [docker](https://docs.docker.com/)
- [terraform](https://www.terraform.io/)
- [packer](https://www.packer.io/)
- [vault](https://www.vaultproject.io/)
- [kubectl](https://kubernetes.io/ko/docs/reference/kubectl/overview/)
- [aws-cli2](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/install-cliv2.html)

### Languages

- [Node.js](https://nodejs.org/ko/)
- [Golang](https://golang.org/)
- [python](https://www.python.org/)

## Extra Tools

### Linux

- [oh-my-zsh](https://ohmyz.sh/#install)

### MacOS

### Windows Extras

- [lens]()
- [postman]()
- [1password]()
- [chrome]()
- [steam]()
- [slack]()
- [office365]()
- [discord]()
- [line]()
- [kakaotalk]()
- [vs2019]()

