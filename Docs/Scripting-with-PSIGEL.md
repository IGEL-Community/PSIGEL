# Scripting with PSIGEL

## Table of contents

- [Installation](#installation)
- [Setup](#setup)
- [Configuration](#configuration)
- [Authentication](#authentication)

## Installation

There are several ways to install PSIGEL:

### Powershell Gallery

```powershell
C:\> Install-Module -Name PSIGEL -Repository PSGallery
```

### Github Repository

#### Clone

Use your favorite Git client (e.g. git, Github Desktop etc.) to clone the PSIGEL repository via HTTPS `https://github.com/IGEL-Community/PSIGEL.git`

#### Release

Download and extract the latest [release](https://github.com/IGEL-Community/PSIGEL/releases).

## Setup

### Import the module

Powershell needs to import the PSIGEL module. This is done automatically if it resides within one of the Powershell Module Paths:

```powershell
[Environment]::GetEnvironmentVariable('PSModulePath') -split ';'
```

If you installed it by using the [PSGallery](#powershell-gallery) it will be located in one of the above paths. If it is not, you have to import the Module:

```powershell
Import-Module -FullyQualifiedName C:\Path\to\PSIGEL.psd1
```

## Configuration

If you want to script with PSIGEL, you will use parameters like `Computername` multiple times. To avoid unnecessary repetitions you can set Default Parameter Values (example):

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Computername' = 'igelrmserver' # Name or IP address of the UMS server
  '*-UMS*:TCPPort'      = 9443 # set, if the TCP Port differs from the default port 8443
}
```

## Authentication

A cookie is needed for authentication with the REST API of the IMI. In PSIGEL this is done by creating a WebSession with the function `New-UMSAPICookie`. It is then is provided to the functions with the parameter `WebSession`.

A simple way for an interactive, single time used script would be:

```powershell
$WebSession = New-UMSAPICookie -Credential (Get-Credential)
```

For the use in a unattended or repeated script you want to automatically add your credentials.

Within Windows you can store your credential in a secure way by using:

```powershell
Get-Credential | Export-Clixml -Path ('C:\Path\To\Your.cred')
```

**Warning:** This method does not create an encrypted file within Linux / MacOS.

You can now import the saved credential and create the WebSession:

```powershell
$WebSession = New-UMSAPICookie -Credential (Import-Clixml -Path 'C:\Path\To\Your.cred')
```

Finally we add the WebSession to the Default Parameter Values as well:

```powershell
$PSDefaultParameterValues.Add('*-UMS*:WebSession', $WebSession)
```
