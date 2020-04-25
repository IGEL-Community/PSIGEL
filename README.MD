# PSIGEL

![MIT licensed](https://img.shields.io/github/license/IGEL-Community/PSIGEL?logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/IGEL-Community/PSIGEL?logo=github)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/IGEL-Community/PSIGEL?logo=github)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSIGEL?logo=powershell)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSIGEL?logo=powershell)
![GitHub stars](https://img.shields.io/github/stars/IGEL-Community/PSIGEL?logo=github)
![IGEL-Community Slack](https://img.shields.io/badge/chat-IGEL%20Community-brightgreen?logo=slack&link=https://igelcommunity.slack.com/archives/C9XFWLXA8&link=https://igelcommunity.slack.com/archives/C9XFWLXA8)
![Logo](PSIGEL_1280_320.png)

Table of contents:

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Maintainer](#maintainer)
- [License](#license)

## Overview

**PSIGEL** is a module to interact with the IGEL UMS via API.

All functions got the noun-prefix **UMS** (Universal Management Server), e.g. Get-**UMS**Something .

## Prerequisites

|OS|min. PS Version (Edition)|
|-|-|
|Windows|5.1 (Desktop)\*|
|Windows|7 (Core)\*|
|Linux|7 (Core)\*|
|MacOS|7 (Core)|

\* tested

## Installation

If you have the [PowerShellGet](https://github.com/powershell/powershellget) module installed you can enter the following command:

```powershell
C:\> Install-Module -Name PSIGEL
```

Alternatively you can download a ZIP file of the latest version from our [Releases](https://github.com/IGEL-Community/PSIGEL/releases) page.

## Getting Started

Import Module:

```powershell
C:\> Import-Module -Name PSIGEL
```

Create a WebSession

```powershell
C:\> $WebSession = New-UMSAPICookie -Computername igelrmserver -Credential (Get-Credential)
```

Call a Function - e.g. get status information from the UMS server:

```powershell
C:\> Get-UMSStatus -Computername igelrmserver -WebSession $WebSession

RmGuiServerVersion : 6.3.130
BuildNumber        : 44584
ActiveMqVersion    : 5.7.0
DerbyVersion       : 10.12.1.1
ServerUuid         : f30fb3a2-37d4-4cbb-b884-4f5061d3260e
Server             : igelrmserver:8443
```

Remove WebSession:

```powershell
C:\> $null = Remove-UMSAPICookie -Computername igelrmserver -WebSession $WebSession
```

## Documentation

You can learn how to use PSIGEL by reading our documentation:

- [Functions](docs/en-US/Functions.md)

## Maintainer

- Falk Heiland
![https://github.com/falkheiland](https://img.shields.io/badge/github-black?logo=github&link=https://github.com/falkheiland&link=https://github.com/falkheiland)
![http://twitter.com/falkheiland](https://img.shields.io/badge/twitter-black?logo=twitter&link=http://twitter.com/falkheiland&link=http://twitter.com/falkheiland)

## License

This project is [licensed under the MIT License](LICENSE).