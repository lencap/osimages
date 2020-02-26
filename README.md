## OS Images

These are [Packer](http://www.packer.io/) templates to create Ubuntu and CentOS Linux [VirtualBox](https://www.virtualbox.org/) OVA OS images. For the moment this is __only for macOS__.

## Prerequisites
These templates have been tested on macOS v10.15.3. Make sure you install at least the following versions of these applications:
  * VirtualBox v6.1.2
  * Packer v1.5.4

## Getting Started
Validate the specific template, then build the image. For instance:
  * `packer validate ubuntu1804.json`
  * `packer build ubuntu1804.json`

## Test
You can use the [vm utility](https://github.com/lencap/vm) to test the OVA image:
  * `vm create dev1 output-virtualbox-iso/ubuntu1804.ova`
  * `vm start dev1`
  * `vm ssh dev1`
  * `vm imgimp output-virtualbox-iso/ubuntu1804.ova`

## Vagrant Options
Alternatively, you can create Vagrant box images from the default OVA images these templates create by default. Although a sample Vagrantfile is included, how to do that Vagrant is not covered here - please read the Vagrant documentation. Of course, once you create Vagrant box files from these OVA one, you'll then be able to test with commands such as:
```
vagrant up
vagrant ssh
vagrant destroy
vagrant box remove ubuntu1804
```
