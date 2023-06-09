<h1><a name="readme-top"></a></h1>

[![Check bind Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-bind-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-bind-stack.yml)
[![Check dhcp Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-dhcp-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-dhcp-stack.yml)
[![Check Openldap Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-openldap-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-openldap-stack.yml)
[![Check Apache Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-apache-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-apache-stack.yml)
[![Check Nginx Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-nginx-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-ngix-stack.yml)
[![Check Postfix Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-postfix-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-postfix-stack.yml)
[![Check Samba Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-samba-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-samba-stack.yml)
[![Check NFS Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-nfs-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-nfs-stack.yml)
[![Check Pure-FTP Stack](https://github.com/marcossilvestrini/labs/actions/workflows/check-pureftp-stack.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/check-pureftp-stack.yml)
[![PSScriptAnalyzer](https://github.com/marcossilvestrini/labs/actions/workflows/powershell.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/powershell.yml) [![Release](https://github.com/marcossilvestrini/labs/actions/workflows/release.yml/badge.svg)](https://github.com/marcossilvestrini/labs/actions/workflows/release.yml)

# LAB

![202-450 Linux Engineer](../../../images/labs.png)

<p align="center">
<strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/marcossilvestrini/labs">Main Page</a>
    -
    <a href="https://github.com/marcossilvestrini/labs/issues">Report Bug</a>
    -
    <a href="https://github.com/marcossilvestrini/labs/issues">Request Feature</a>
</p>

## Summary

<details>
  <summary><b>TABLE OF CONTENT</b></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#instalation">Instalation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#freedoms">Four Essential Freedoms</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details><br>

<a name="about-the-project"></a>

## About Project

This project up a stack in linux for labs

## Whats is?

In this project, I up a stack of:

* dns bind
* apache
* postfix
* samba
* nfs
* pureftp



### Vagrant

 I use vagrant for provision all File system server in this project.

### Shell provisioner

I use vagrant shell provisioner for configure stack of service and others tools of this stack

### Git Actions (pipelines)

I use git actions for create a pipeline for test stack of services

### Slack API

I use slack api and git actions for send a test that I execute after all
push\pull in this repository

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<a name="getting-started"></a>

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

<a name="prerequisites"></a>

### Prerequisites

This is an example of how to list things you need to use the software
and how to install them.

* git
* Virtual Box and extension
* Vagrant

<a name="installation"></a>

### Installation

Clone the repo

```sh
git clone https://github.com/marcossilvestrini/labs.git
```

<a name="usage"></a>

## Usage

```sh
cd vagrant/linux/labs
vagrant up
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<a name="roadmap"></a>

## Roadmap

* [x] Install And Configure Stack
  * [x] Install and configure bind
  * [x] Install and configure postfix
  * [x] Install and configure apache
  * [x] Install and configure pureftp
  

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contributing

Contributions are what make the open source community such an amazing place to
learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and
create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

* This project is licensed under the MIT License * see the LICENSE.md file for details

## Contact

Marcos Silvestrini - marcos.silvestrini@gmail.com \
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/mrsilvestrini.svg?style=social&label=Follow%20%40mrsilvestrini)](https://twitter.com/mrsilvestrini)

Project Link: [https://github.com/marcossilvestrini/labs](https://github.com/marcossilvestrini/labs)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Acknowledgments

* [Github](https://github.com/marcossilvestrini/labs)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
