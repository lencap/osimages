# Packer Parallels Machine Images
[Packer](http://www.packer.io/) templates to create a [Parallels](https://www.parallels.com/) [PVM](https://en.wikipedia.org/wiki/Parallel_Virtual_Machine) [virtual machine image](https://en.wikipedia.org/wiki/Virtual_machine) and/or Vagrant [box image](https://www.vagrantup.com/docs/boxes.html). [Vagrant](https://www.vagrantup.com/intro/index.html) is an open-source software product for building and maintaining portable virtual software development environments. The aim is to simplify software configuration management of virtualizations in order to increase development productivity.

# Prerequisites
All this has been tested on an Apple Mac running macOS v10.14.2.

Install the following versions of these applications:
  * Parallels v14.1.0+
  * Packer v1.3.4+
  * Vagrant v2.2.2+

You must also install the Parallels Virtualization SDK, and the Vagrant provider:
  * `brew cask install parallels-virtualization-sdk`
  * `vagrant plugin install vagrant-parallels`

# Build Images
| Command | Description |
| :----------- | :----------- |
| `packer validate centos7.6.1810-parallels-box.json` | First, confirm template is good |
| `packer build centos7.6.1810-parallels-box.json` | Build CentOS 7.6.1810 Parallels Vagrant box |
| OR | - |
| `packer validate centos7.6.1810-parallels-pvm.json` | Confirm template is good |
| `packer build centos7.6.1810-parallels-pvm.json` | Build CentOS 7.6.1810 Parallels PVM machine |

You can use the newly created PVM as you see fit.

# Test Vagrant Box
To test the Vagrant box, you can run:
  * `vagrant up`
  * `vagrant ssh`

To clean up afterwards, you can do:
  * `vagrant destroy`
  * `vagrant box remove centos7.6.1810-parallels`
