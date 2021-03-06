# Parcel

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/Badgerati/Parcel/master/LICENSE.txt)
[![PowerShell](https://img.shields.io/powershellgallery/dt/parcel.svg?label=PowerShell&colorB=085298)](https://www.powershellgallery.com/packages/Parcel)

> This is still a work in progress!

Parcel is a cross-platform PowerShell package manager and provisioner for a number of different package managers.

You define a package file using YAML, and Parcel will install/uninstall the packages using the relevant provider.

## Support Providers

These are the currently support package providers (more to come!):

* Chocolatey
* PowerShell Gallery
* Scoop
* Homebrew
* Docker
* Windows Features
* Apt-get
* Yum

## Install

```powershell
Install-Module -Name Parcel
```

## Usage

You define the packages using a YAML file - the default is `parcel.yml`, but can be anything. Then, you can run one of the following:

```powershell
Install-ParcelPackages [-Path <string>] [-Environment <string>] [-IgnoreEnsures] [-WhatIf] [-Verbose]
Uninstall-ParcelPackages [-Path <string>] [-Environment <string>] [-IgnoreEnsures] [-WhatIf] [-Verbose]
```

## Examples

To install 7zip using Chocolatey, the following could be used. For each `name`/`names` and `provider` are mandatory, and the name *must* match precisely on all providers:

```yaml
---
packages:
- name: 7zip.install
  provider: choco
  version: 19.0
```

or to install Pester from the PowerShell Gallery:

```yaml
---
packages:
- name: pester
  provider: psgallery
  version: 4.8.1
```

### Properties

The properties that are currently supported are in packages are:

* name
* provider
* version (can be a specific version, or empty/latest)
* source (can be a url, or a repository name, or any other source)
* args (extra arguments to run, can also be split into `install:` and `uninstall:`)
* ensure (can be empty, or present/absent)
* os (can be windows, linux, or macos - package will only run if running on that OS)
* environment (can be anything, default is 'all'. packages will run based on `-Environment`)
* when (powershell script that returns a boolean value, if true then package will run)
* pre/post scritps (allows you to define powershell scripts to run pre/post install/uninstall)

There is also a scripts block that allows for defining pre/post scripts that run before or after all packages. They will run once at the beginning, and then once at the end.

```yaml
---
packages:
- name: <package-name>
  names: <an array of package names>
  provider: provider-name>
  version: <version|empty|latest>
  source: <source>
  args:
    install: <custom-install-arguments>
    uninstall: <custom-uninstall-arguments>
  ensure: <present|absent|neutral (default)>
  os: <linux|macos|windows|all (default)>
  environment: <environment(s)>
  when: <powershell-query>
  pre:
    install: <powershell-script>
    uninstall: <powershell-script>
  post:
    install: <powershell-script>
    uninstall: <powershell-script>

scripts:
  pre:
    install: <powershell-script>
    uninstall: <powershell-script>
  post:
    install: <powershell-script>
    uninstall: <powershell-script>

providers:
  <name>:
    source:
    - name: <source-name>
      url: <source-url>
      default: <true|false>
    args:
      install: <custom-install-arguments>
      uninstall: <custom-uninstall-arguments>
```

For `when`, there is a `$parcel` object available that has the following structure:

```powershell
$parcel = @{
    os = @{
        type = # <linux|windows|macos>
        name = # name of the OS, like Windows, Darwin, Ubuntu
        version = # only on Windows, the version of the OS
    }
    environment = # set from "-Environment"
    package = @{
        provider = # current provider being used for current package
    }
}
```

## Providers

### Chocolatey

```yaml
packages:
- name: 7zip.install
  provider: <choco|chocolatey>
  version: 19.0
```

### Scoop

```yaml
packages:
- name: 7zip
  provider: scoop
  version: 19.00
```

### PowerShell Gallery

```yaml
packages:
- name: Pester
  provider: <psgallery|ps-gallery>
  version: 4.8.0
```

### Homebrew

* Self-installation is not supported due to some quirks with PowerShell
* Sources are not supported, due to Homebrew not having them
* Latest does work, but Parcel cannot retrieve the latest version as Homebrew doesn't display it
  * Since Parcel can't get the latest version, using it will always "Change"

```yaml
packages:
- name: p7zip
  provider: <brew|homebrew>
```

> If you face issues installing casks, try running: `sudo chown -R $USER:admin /usr/local/Caskroom`

### Docker

* Self-installation is not supported - it's best to include this as another package to be installed
* Sources are not supported, due to Docker not having them (unless you pre-login to your own registry first)

```yaml
packages:
- name: badgerati/pode
  provider: docker
  version: 1.1.0
```

### Windows Features

* Only supported in Windows (Desktop PowerShell only)
* Version is always latest (as features have no version)

```yaml
packages:
- name: Microsoft-Hyper-V
  provider: <winfeature|windows-feature|win-feature>
```

### DISM

* Only supported in Windows (Desktop/Core PowerShell)
* Version is always latest

```yaml
- name: ActiveDirectory-PowerShell
  provider: <dism>
```

### Apt-Get

* Self-installation is not supported - if `apt-get` is not there, Parcel will fail
* Sources are not supported

```yaml
packages:
- name: vim
  provider: <aptget|apt-get>
  version: latest
```

or:

```yaml
packages:
- name: vim
  provider: <aptget|apt-get>
  version: 2:7.4.1689-3ubuntu1.3
```

### Yum

* Self-installation is not supported - if `yum` is not there, Parcel will fail
* Sources are not supported

```yaml
packages:
- name: ansible
  provider: yum
```
