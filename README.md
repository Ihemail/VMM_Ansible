# VMM_Ansible

Note: Ansible Playbooks are customized to run from MacOS only & for tcsh shell in VMM Pod. 

1. Copy SSH Key to any Quincy Pod:
  ```ruby
  MacOS:~ $ ssh-copy-id -i ~/.ssh/id_rsa.pub ihazra@wf-pod01-vmm.englab.juniper.net
  ```
2. Login to any vmm Quincy Pod, and verify password less ssh login.
3. Create a folder named 'homes' in your vmm Quincy Pod Home directory:
  ```ruby
  [xxxx@q-pod13-vmm ~]$ mkdir homes
  ```
4. Exit from VMM Pod and execute the ansible-playbook:
  
  ```ruby
  MacOS:ansible xxxx$ ansible-playbook vmm-conf.yaml
  VMM Pod Name:
   p1 : q-pod05-vmm.englab.juniper.net
   p2 : q-pod08-vmm.englab.juniper.net
   p3 : q-pod13-vmm.englab.juniper.net
   p4 : q-pod23-vmm.englab.juniper.net
   p5 : wf-pod01-vmm.englab.juniper.net
   p6 : q-pod21-vmm.englab.juniper.net
   p7 : q-pod22-vmm.englab.juniper.net
   p8 : q-pod26-vmm.englab.juniper.net
   p9 :
   p10 :
  Select VMM Pod : p2

  PLAY [localhost] ***********************************************************************************************

  TASK [console: vmm_server_conf_deploy_1] ***********************************************************************
  changed: [localhost]

  TASK [console: vmm_server_conf_deploy_2] ***********************************************************************
  changed: [localhost] => (item=echo \"vmm_ansible_conf\")
  changed: [localhost] => (item=#ssh -o \"StrictHostKeyChecking no\" root@`vmm ip | grep vm_command | awk '\''{print $2}'\''`)
  changed: [localhost] => (item=cat << EOF > homes/reset-ansible.sh)
  changed: [localhost] => (item=#!/bin/bash)
  changed: [localhost] => (item=echo -n "" > ~/.ssh/known_hosts)
  changed: [localhost] => (item=/vmm/bin/vmm_capacity -g vmm-default)
  changed: [localhost] => (item=vmm ip)
  changed: [localhost] => (item=vmm stop)
  changed: [localhost] => (item=vmm unbind)
  changed: [localhost] => (item=vmm config homes/vmm-clean.conf -g vmm-default)
  changed: [localhost] => (item=/vmm/bin/vmm_capacity -g vmm-default)
  changed: [localhost] => (item=echo "Sleep for 5sec.")
  changed: [localhost] => (item=sleep 5)
  changed: [localhost] => (item=vmm config homes/vmm-ansible.conf -g vmm-default)
  changed: [localhost] => (item=echo " VMM Redeploy - Done ")
  changed: [localhost] => (item=vmm start vm_deployer_cc)
  changed: [localhost] => (item=vmm start vm_command)
  changed: [localhost] => (item=vmm start vm_cc)
  changed: [localhost] => (item=vmm start vm_cc2)
  changed: [localhost] => (item=vmm start vm_app)
  changed: [localhost] => (item=vmm start vm_compute1)
  changed: [localhost] => (item=vmm start vm_compute2)
  changed: [localhost] => (item=vmm start vm_bms1)
  changed: [localhost] => (item=vmm start vm_bms2)
  changed: [localhost] => (item=vmm start vm_openwrt)
  changed: [localhost] => (item=vmm start vqfx10k_spine1)
  changed: [localhost] => (item=vmm start vqfx10k_spine1_cosim)
  changed: [localhost] => (item=vmm start vqfx10k_spine2)
  changed: [localhost] => (item=vmm start vqfx10k_spine2_cosim)
  changed: [localhost] => (item=vmm start vqfx10k_leaf1)
  changed: [localhost] => (item=vmm start vqfx10k_leaf1_cosim)
  changed: [localhost] => (item=vmm start vqfx10k_leaf2)
  changed: [localhost] => (item=vmm start vqfx10k_leaf2_cosim)
  changed: [localhost] => (item=vmm start vmx_gw)
  changed: [localhost] => (item=vmm start vmx_gw_MPC0)
  changed: [localhost] => (item=/vmm/bin/vmm_capacity -g vmm-default)
  changed: [localhost] => (item=vmm ip)
  changed: [localhost] => (item=              )
  changed: [localhost] => (item=EOF)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=cat << EOF > homes/vmm-ansible.conf)
  changed: [localhost] => (item=#include \"/vmm/bin/common.defs\")
  changed: [localhost] => (item=#include \"/vmm/data/user_disks/vmxc/common.vmx.p3.defs\")
  changed: [localhost] => (item=#define VMX_DISK basedisk \"/vmm/data/user_disks/ihazra/jinstall64-17.2R2.8.img\";)
  changed: [localhost] => (item=#define CENTOS7_base basedisk \"/vmm/data/user_disks/ihazra/contrail/centos7-300g.vmdk\";)
  changed: [localhost] => (item=//#define COSIM_DISK basedisk \"/vmm/data/user_disks/ihazra/cosim-2018-02-12.vmdk\";)
  changed: [localhost] => (item=#define VQFX10_DISK basedisk \"/vmm/data/user_disks/ihazra/jinstall-vqfx-10-f-18.4R1.img\";)
  changed: [localhost] => (item=#define COSIM_DISK basedisk \"/vmm/data/user_disks/ihazra/cosim-2018-02-12.vmdk\";)
  changed: [localhost] => (item=#define OPENWRT_BASE basedisk \"/vmm/data/user_disks/ihazra/lede-disk1.vmdk\";)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=config \"contrail_CEM\" {)
  changed: [localhost] => (item=#undef VMX_CHASSIS_I2CID)
  changed: [localhost] => (item=#undef VMX_CHASSIS_NAME)
  changed: [localhost] => (item=#define VMX_CHASSIS_I2CID 21)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_deployer_cc\" {)
  changed: [localhost] => (item=    hostname \"vm_deployer_cc\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 22;)
  changed: [localhost] => (item=    memory 27000;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_command\" {)
  changed: [localhost] => (item=    hostname \"vm_command\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 32;)
  changed: [localhost] => (item=    memory 48480;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_cc\" {)
  changed: [localhost] => (item=    hostname \"vm_cc\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 32;)
  changed: [localhost] => (item=    memory 48000;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p3\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_cc2\" {)
  changed: [localhost] => (item=    hostname \"vm_cc2\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 32;)
  changed: [localhost] => (item=    memory 48000;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf2p2\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_app\" {)
  changed: [localhost] => (item=    hostname \"vm_app\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 10;)
  changed: [localhost] => (item=    memory 10240;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p3\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_compute1\" {)
  changed: [localhost] => (item=    hostname \"vm_compute1\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 22;)
  changed: [localhost] => (item=    memory 32240;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p3\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_compute2\" {)
  changed: [localhost] => (item=    hostname \"vm_compute2\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 22;)
  changed: [localhost] => (item=    memory 32240;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf2p2\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p3\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_bms1\" {)
  changed: [localhost] => (item=    hostname \"vm_bms1\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 22;)
  changed: [localhost] => (item=    memory 28192;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf1p4\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p5\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_bms2\" {)
  changed: [localhost] => (item=    hostname \"vm_bms2\";)
  changed: [localhost] => (item=    CENTOS7_base)
  changed: [localhost] => (item=    ncpus 22;)
  changed: [localhost] => (item=    memory 28192;)
  changed: [localhost] => (item=    setvar \"qemu_args\" \"-cpu host,vmx=on\";)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"leaf2p4\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p5\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vm_openwrt\" {)
  changed: [localhost] => (item=    hostname \"vm_openwrt_lede\";)
  changed: [localhost] => (item=    OPENWRT_BASE)
  changed: [localhost] => (item=    ncpus 2;)
  changed: [localhost] => (item=    memory 512;)
  changed: [localhost] => (item=    setvar \"boot_noveriexec\"       \"yes\";)
  changed: [localhost] => (item=    interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em1\" { bridge \"external\"; };)
  changed: [localhost] => (item=    interface \"em2\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=    interface \"em3\" { bridge \"leaf2p2\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  VMX_CHASSIS_START())
  changed: [localhost] => (item=  #define VMX_CHASSIS_NAME vmx_gw)
  changed: [localhost] => (item=  VMX_CHASSIS_START())
  changed: [localhost] => (item=    VMX_RE_START(vmx_gw, 0))
  changed: [localhost] => (item=        VMX_RE_INSTANCE(vmx_gw, VMX_DISK, VMX_RE_I2CID, 0))
  changed: [localhost] => (item=    VMX_RE_END)
  changed: [localhost] => (item=   VMX_MPC_START(vmx_gw_MPC,0))
  changed: [localhost] => (item=        VMX_MPC_INSTANCE(vmx_gw_MPC, VMX_DISK, VMX_MPC_I2CID, 0))
  changed: [localhost] => (item=          VMX_CONNECT(GE(0,0,0), private1))
  changed: [localhost] => (item=          VMX_CONNECT(GE(0,0,1), private2))
  changed: [localhost] => (item=          VMX_CONNECT(GE(0,0,2), private3))
  changed: [localhost] => (item=          VMX_CONNECT(GE(0,0,3), vmx_spine1))
  changed: [localhost] => (item=          VMX_CONNECT(GE(0,0,4), vmx_spine2))
  changed: [localhost] => (item=    VMX_MPC_END)
  changed: [localhost] => (item=  VMX_CHASSIS_END)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vqfx10k_spine1\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_spine1\";)
  changed: [localhost] => (item=      VQFX10_DISK)
  changed: [localhost] => (item=      setvar \"boot_noveriexec\" \"YES\";)
  changed: [localhost] => (item=      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";)
  changed: [localhost] => (item=      VQFX_SYSTEST_CONFIG)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_1\"; ipaddr \"169.254.0.2\"; };)
  changed: [localhost] => (item=      interface \"em2\" { bridge \"reserved_bridge\"; };)
  changed: [localhost] => (item=      interface \"em3\" { bridge \"vmx_spine1\"; };)
  changed: [localhost] => (item=      interface \"em4\" { bridge \"spine1_leaf1\"; };)
  changed: [localhost] => (item=      interface \"em5\" { bridge \"spine1_leaf2\"; };)
  changed: [localhost] => (item=      interface \"em6\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=  vm \"vqfx10k_spine1_cosim\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_spine1_cosim\";)
  changed: [localhost] => (item=      COSIM_DISK)
  changed: [localhost] => (item=      memory 4096;)
  changed: [localhost] => (item=      ncpus 4;)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { EXTERNAL; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_1\"; ipaddr \"169.254.0.1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vqfx10k_spine2\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_spine2\";)
  changed: [localhost] => (item=      VQFX10_DISK)
  changed: [localhost] => (item=      setvar \"boot_noveriexec\" \"YES\";)
  changed: [localhost] => (item=      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";)
  changed: [localhost] => (item=      VQFX_SYSTEST_CONFIG)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_2\"; ipaddr \"169.254.0.2\"; };)
  changed: [localhost] => (item=      interface \"em2\" { bridge \"reserved_bridge\"; };)
  changed: [localhost] => (item=      interface \"em3\" { bridge \"vmx_spine2\"; };)
  changed: [localhost] => (item=      interface \"em4\" { bridge \"spine2_leaf1\"; };)
  changed: [localhost] => (item=      interface \"em5\" { bridge \"spine2_leaf2\"; };)
  changed: [localhost] => (item=      interface \"em6\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=  vm \"vqfx10k_spine2_cosim\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_spine2_cosim\";)
  changed: [localhost] => (item=      COSIM_DISK)
  changed: [localhost] => (item=      memory 4096;)
  changed: [localhost] => (item=      ncpus 4;)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { EXTERNAL; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_2\"; ipaddr \"169.254.0.1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vqfx10k_leaf1\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_leaf1\";)
  changed: [localhost] => (item=      VQFX10_DISK)
  changed: [localhost] => (item=      setvar \"boot_noveriexec\" \"YES\";)
  changed: [localhost] => (item=      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";)
  changed: [localhost] => (item=      VQFX_SYSTEST_CONFIG)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_3\"; ipaddr \"169.254.0.2\"; };)
  changed: [localhost] => (item=      interface \"em2\" { bridge \"reserved_bridge\"; };)
  changed: [localhost] => (item=      interface \"em3\" { bridge \"spine1_leaf1\"; };)
  changed: [localhost] => (item=      interface \"em4\" { bridge \"leaf1p2\"; };)
  changed: [localhost] => (item=      interface \"em5\" { bridge \"leaf1p3\"; };)
  changed: [localhost] => (item=      interface \"em6\" { bridge \"spine2_leaf1\"; };)
  changed: [localhost] => (item=      interface \"em7\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=      interface \"em8\" { bridge \"leaf1p4\"; };)
  changed: [localhost] => (item=      interface \"em9\" { bridge \"leaf1p5\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=  vm \"vqfx10k_leaf1_cosim\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_leaf1_cosim\";)
  changed: [localhost] => (item=      COSIM_DISK)
  changed: [localhost] => (item=      memory 4096;)
  changed: [localhost] => (item=      ncpus 4;)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { EXTERNAL; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_3\"; ipaddr \"169.254.0.1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=  vm \"vqfx10k_leaf2\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_leaf2\";)
  changed: [localhost] => (item=      VQFX10_DISK)
  changed: [localhost] => (item=      setvar \"boot_noveriexec\" \"YES\";)
  changed: [localhost] => (item=      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";)
  changed: [localhost] => (item=      VQFX_SYSTEST_CONFIG)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { bridge \"external\"; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_4\"; ipaddr \"169.254.0.2\"; };)
  changed: [localhost] => (item=      interface \"em2\" { bridge \"reserved_bridge\"; };)
  changed: [localhost] => (item=      interface \"em3\" { bridge \"spine1_leaf2\"; };)
  changed: [localhost] => (item=      interface \"em4\" { bridge \"leaf2p2\"; };)
  changed: [localhost] => (item=      interface \"em5\" { bridge \"leaf2p3\"; };)
  changed: [localhost] => (item=      interface \"em6\" { bridge \"spine2_leaf2\"; };)
  changed: [localhost] => (item=      interface \"em7\" { bridge \"spine1p1\"; };)
  changed: [localhost] => (item=      interface \"em8\" { bridge \"leaf2p4\"; };)
  changed: [localhost] => (item=      interface \"em9\" { bridge \"leaf2p5\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=  vm \"vqfx10k_leaf2_cosim\" {)
  changed: [localhost] => (item=      hostname \"vqfx10k_leaf2_cosim\";)
  changed: [localhost] => (item=      COSIM_DISK)
  changed: [localhost] => (item=      memory 4096;)
  changed: [localhost] => (item=      ncpus 4;)
  changed: [localhost] => (item=      // Note: Don'\''t change destination paths below)
  changed: [localhost] => (item=      interface \"em0\" { EXTERNAL; };)
  changed: [localhost] => (item=      interface \"em1\" { bridge \"pecosim_bridge_4\"; ipaddr \"169.254.0.1\"; };)
  changed: [localhost] => (item=  };)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=   bridge \"pecosim_bridge_1\" {};)
  changed: [localhost] => (item=   bridge \"pecosim_bridge_2\" {};)
  changed: [localhost] => (item=   bridge \"pecosim_bridge_3\" {};)
  changed: [localhost] => (item=   bridge \"pecosim_bridge_4\" {};)
  changed: [localhost] => (item=   bridge \"reserved_bridge\" {};)
  changed: [localhost] => (item=   bridge \"spine1p1\" {};)
  changed: [localhost] => (item=   bridge \"spine1p2\" {};)
  changed: [localhost] => (item=   bridge \"spine1_leaf1\" {};)
  changed: [localhost] => (item=   bridge \"spine1_leaf2\" {};)
  changed: [localhost] => (item=   bridge \"spine2_leaf1\" {};)
  changed: [localhost] => (item=   bridge \"spine2_leaf2\" {};)
  changed: [localhost] => (item=   bridge \"leaf1p2\" {};)
  changed: [localhost] => (item=   bridge \"leaf1p3\" {};)
  changed: [localhost] => (item=   bridge \"leaf1p4\" {};)
  changed: [localhost] => (item=   bridge \"leaf1p5\" {};)
  changed: [localhost] => (item=   bridge \"leaf2p2\" {};)
  changed: [localhost] => (item=   bridge \"leaf2p3\" {};)
  changed: [localhost] => (item=   bridge \"leaf2p4\" {};)
  changed: [localhost] => (item=   bridge \"leaf2p5\" {};)
  changed: [localhost] => (item=   bridge \"vmx_spine1\" {};)
  changed: [localhost] => (item=   bridge \"vmx_spine2\" {};)
  changed: [localhost] => (item=PRIVATE_BRIDGES)
  changed: [localhost] => (item=};)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=EOF)
  changed: [localhost] => (item=)
  changed: [localhost] => (item=chmod +x homes/reset-ansible.sh)
  changed: [localhost] => (item= ./homes/reset-ansible.sh)

  TASK [console: delay for 360sec] *******************************************************************************
  ok: [localhost]

  TASK [console: vmm_server_conf_deploy_3] ***********************************************************************
  changed: [localhost] => (item=echo \"vmm_commands_1\")
  changed: [localhost] => (item=cat homes/vmm-ansible.conf)
  changed: [localhost] => (item=vmm list)

  TASK [console: vm_deployer_cc] *********************************************************************************
  changed: [localhost]

  TASK [console: vm_command] *************************************************************************************
  changed: [localhost]

  TASK [console: vm_cc] ******************************************************************************************
  changed: [localhost]

  TASK [console: vm_cc2] *****************************************************************************************
  changed: [localhost]

  TASK [console: vm_app] *****************************************************************************************
  changed: [localhost]

  TASK [console: vm_openWRT_VMM_Pod] *****************************************************************************
  changed: [localhost]

  TASK [console: QFX login checkpoint] ***************************************************************************
  [console: QFX login checkpoint]

  Continue to QFX login (y/n):
  ok: [localhost]

  TASK [ssh: vqfx10k_spine1] *************************************************************************************
  changed: [localhost]

  TASK [ssh: vqfx10k_spine2] *************************************************************************************
  changed: [localhost]

  TASK [ssh: vqfx10k_leaf1] **************************************************************************************
  changed: [localhost]

  TASK [ssh: vqfx10k_leaf2] **************************************************************************************
  changed: [localhost]


  PLAY RECAP *****************************************************************************************************
  localhost                  : ok=15   changed=13   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  ```


4. Similar login only Ansible Script for Server console & ssh to vQFX/vMX nodes:

  ```ruby
  MacOS:ansible xxxx$ ansible-playbook vmm-base.yaml
  ```
  
5. Close all Terminal app window once work is complete.
