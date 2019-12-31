## CentOS Vagrant Box images creation templates

These are [Packer](http://www.packer.io/) templates to create CentOS [Vagrant box images](https://www.vagrantup.com/docs/boxes.html) for the [VirtualBox](https://www.virtualbox.org/) provider. These templates also leave around the default OVA images, in case they are needed for projects not involving Vagrant. 

## Prerequisites
This work has been tested on macOS v10.15.2. Make sure you install at least the following versions of these applications:
  * VirtualBox v6.1.0
  * Packer v1.4.5
  * Vagrant v2.2.6

## Getting Started
Validate the CentOS7 image template file; then build it validation is successful:
  * `packer validate centos7.json`
  * `packer build centos7.json`

## Test
To test the Vagrant box image, you can run:
  * `vagrant up`
  * `vagrant ssh`

then clean up with:
  * `vagrant destroy`
  * `vagrant box remove centos7`

## Notes
The CentOS8 template is also included. 

## Amazon AMI
To create CentOS Amazon AMI [read this README](https://github.com/lencap/osimages/blob/master/centos/AMI.md)
