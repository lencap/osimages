## Ubuntu Vagrant Box images creation templates

These are [Packer](http://www.packer.io/) templates to create [Vagrant box images](https://www.vagrantup.com/docs/boxes.html) for the [VirtualBox](https://www.virtualbox.org/) provider.

## Prerequisites
This work has been tested on macOS v10.15.2. Make sure you install at least the following versions of these applications:
  * VirtualBox v6.1.0
  * Packer v1.4.5
  * Vagrant v2.2.6

## Getting Started
Validate the Ubuntu1804 template:
  * `packer validate ubuntu1804.json`

If the validation is good, then you can build the Vagrant box image with:
  * `packer build ubuntu1804.json`

## Test
To test the Vagrant box image, you can run:
  * `vagrant up`
  * `vagrant ssh`

then clean up with:
  * `vagrant destroy`
  * `vagrant box remove ubuntu1804`

## Notes
Ubuntu1910 template also included.
