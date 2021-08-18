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

## Others

powerlevel10k를 쓰기 위해서는 [`Nerd Font`](https://www.nerdfonts.com/) 를 사용해야함

Windows는 기본적으로 FiraCode NF를 설치하게 해 둠
