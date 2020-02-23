## Ubuntu Templates

These are [Packer](http://www.packer.io/) templates to create Ubuntu Linux OVA images for the [VirtualBox](https://www.virtualbox.org/) provider.

## Prerequisites
These templates have been tested on macOS v10.15.3. Make sure you install at least the following versions of these applications:
  * VirtualBox v6.1.2
  * Packer v1.5.4

## Getting Started
Validate the Ubuntu1804 template, then build the image:
  * `packer validate ubuntu1804.json`
  * `packer build ubuntu1804.json`

## Test
You can use the `vm` utility to test the OVA image:
  * `vm create dev1 output-virtualbox-iso/ubuntu1804.ova`
  * `vm start dev1`
  * `vm ssh dev1`
  * `vm imgimp output-virtualbox-iso/ubuntu1804.ova`

Alternatively, you can create Vagrant box images from the default OVA images these templates create by default. That's not covered here - please read the Vagrant documentation. Then you can use the usual commands to test:
  * `vagrant up`
  * `vagrant ssh`
  * `vagrant destroy`
  * `vagrant box remove ubuntu1804`


