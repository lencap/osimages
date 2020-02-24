## CentOS Vagrant Box images creation templates

These are [Packer](http://www.packer.io/) templates to create CentOS [Vagrant box images](https://www.vagrantup.com/docs/boxes.html) for the [VirtualBox](https://www.virtualbox.org/) provider. These templates also leave around the default OVA images, in case they are needed for projects not involving Vagrant. 

## Prerequisites
This work has been tested on macOS v10.15.2. Make sure you install at least the following versions of these applications:
  * VirtualBox v6.1.0
  * Packer v1.5.1
  * Vagrant v2.2.6

## Getting Started
Validate the CentOS7 image template file; then build it validation is successful:
  * `packer validate centos7.7.1908.json`
  * `packer build centos7.7.1908.json`

## Test
To test the Vagrant box image, you can run:
  * `vagrant up`
  * `vagrant ssh`

then clean up with:
  * `vagrant destroy`
  * `vagrant box remove centos7.7.1908`

## Notes
The CentOS8 template is also included. 

## Parallels
To create CentOS Parallels PVM images [read this README](https://github.com/lencap/osimages/blob/master/centos/PVM.md)

## Amazon
To create CentOS Amazon AMI [read this README](https://github.com/lencap/osimages/blob/master/centos/AMI.md)

## Vagrant
To create Vagrant box you'll need to create a new template, based on one of these provided. You'll then need to make sure that:
1. A `vagrant` user is created
2. You add a post-processors stanza to the new template, like this:
```
  "post-processors": [
    {
      "type": "vagrant",
      "keep_input_artifact": true,
      "output": "./centos7.7.1908.box",
      "vagrantfile_template": "./Vagrantfile"
    }
  ]
```
