# PSIGEL

[![GitHub last commit][github-commit-badge]][github-psigel]
[![GitHub release (latest by date)][github-release-badge]][github-psigel]
[![PowerShell Gallery Version][psgallery-v-badge]][powershell-gallery]
[![PS Gallery][psgallery-dl-badge]][powershell-gallery]
[![GitHub stars][github-start-badge]][github-psigel]
[![IGEL-Community Slack][slack-badge]][slack-igelcommunity]


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

- [Functions](docs/Functions.md)

## Maintainer

### Falk Heiland
[![https://github.com/falkheiland][github-fh-badge]][github-fh]
[![http://twitter.com/falkheiland][twitter-fh-badge]][twitter-fh]

## License

This project is [licensed under the MIT License](LICENSE).

[![MIT licensed][mit-badge]][mit-license]

[psgallery-dl-badge]: https://img.shields.io/powershellgallery/dt/PSIGEL.svg?logo=powershell
[powershell-gallery]: https://www.powershellgallery.com/packages/PSIGEL/
[mit-badge]: https://img.shields.io/github/license/IGEL-Community/PSIGEL?logo=github
[mit-license]: LICENSE.md
[github-commit-badge]: https://img.shields.io/github/last-commit/IGEL-Community/PSIGEL?logo=github
[github-psigel]: https://github.com/IGEL-Community/PSIGEL
[github-release-badge]: https://img.shields.io/github/release/IGEL-Community/PSIGEL/all.svg?logo=github
[psgallery-v-badge]: https://img.shields.io/powershellgallery/v/PSIGEL?include_prereleases
[github-start-badge]: https://img.shields.io/github/stars/IGEL-Community/PSIGEL?logo=github
[slack-badge]: https://img.shields.io/badge/chat-IGEL%20Community-brightgreen?logo=slack
[slack-igelcommunity]: http://join.igelcommunity.com
[github-fh-badge]: https://img.shields.io/badge/Github-falkheiland-green?logo=github
[github-fh]: https://github.com/falkheiland
[twitter-fh-badge]: https://img.shields.io/badge/Twitter-falkheiland-blue?logo=twitter
[twitter-fh]: https://twitter.com/falkheiland
