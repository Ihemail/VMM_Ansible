echo \"vmm_ansible_conf\"
cat << EOF > homes/reset-ansible.sh
#!/bin/bash
echo -n "" > ~/.ssh/known_hosts
vmm ip
vmm stop
vmm unbind
vmm config homes/vmm-clean.conf -g vmm-default
echo "Sleep for 5sec."
sleep 5
vmm config homes/vmm-ansible.conf -g vmm-default
echo " VMM Redeploy - Done "
vmm start vm_deployer_cc
vmm start vm_command
vmm start vm_cc
vmm start vm_cc2
vmm start vm_app
#vmm start vm_compute1
#vmm start vm_compute2
#vmm start vm_openwrt
vmm start vqfx10k_spine1
vmm start vqfx10k_spine1_cosim
vmm start vqfx10k_spine2
vmm start vqfx10k_spine2_cosim
vmm start vqfx10k_leaf1
vmm start vqfx10k_leaf1_cosim
vmm start vqfx10k_leaf2
vmm start vqfx10k_leaf2_cosim
#vmm start vmx_gw
#vmm start vmx_gw_MPC0
vmm ip
              
EOF

cat << EOF > homes/vmm-ansible.conf
#include \"/vmm/bin/common.defs\"
#include \"/vmm/data/user_disks/vmxc/common.vmx.p3.defs\"
#define VMX_DISK basedisk \"/vmm/data/user_disks/ihazra/jinstall64-17.2R2.8.img\";
#define CENTOS7_base basedisk \"/vmm/data/user_disks/ihazra/contrail/centos7-300g.vmdk\";
//#define COSIM_DISK basedisk \"/vmm/data/user_disks/ihazra/cosim-2018-02-12.vmdk\";
#define VQFX10_DISK basedisk \"/vmm/data/user_disks/ihazra/jinstall-vqfx-10-f-18.4R1.img\";
#define COSIM_DISK basedisk \"/vmm/data/user_disks/ihazra/cosim-2018-02-12.vmdk\";
#define OPENWRT_BASE basedisk \"/vmm/data/user_disks/ihazra/lede-disk1.vmdk\";

config \"contrail_CEM\" {
#undef VMX_CHASSIS_I2CID
#undef VMX_CHASSIS_NAME
#define VMX_CHASSIS_I2CID 21

  vm \"vm_deployer_cc\" {
    hostname \"vm_deployer_cc\";
    CENTOS7_base
    ncpus 8;
    memory 8192;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf1p2\"; };
  };

  vm \"vm_command\" {
    hostname \"vm_command\";
    CENTOS7_base
    ncpus 12;
    memory 16384;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf1p2\"; };
  };

  vm \"vm_cc\" {
    hostname \"vm_cc\";
    CENTOS7_base
    ncpus 20;
    memory 40000;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf1p2\"; };
    interface \"em3\" { bridge \"leaf2p3\"; };
  };

  vm \"vm_cc2\" {
    hostname \"vm_cc2\";
    CENTOS7_base
    ncpus 20;
    memory 40000;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf2p2\"; };
  };

  vm \"vm_app\" {
    hostname \"vm_app\";
    CENTOS7_base
    ncpus 10;
    memory 10240;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf1p2\"; };
    interface \"em3\" { bridge \"leaf2p3\"; };
  };

  vm \"vm_compute1\" {
    hostname \"vm_compute1\";
    CENTOS7_base
    ncpus 8;
    memory 8192;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf1p2\"; };
    interface \"em3\" { bridge \"leaf2p3\"; };
  };

  vm \"vm_compute2\" {
    hostname \"vm_compute2\";
    CENTOS7_base
    ncpus 8;
    memory 8192;
    setvar \"+qemu_args\" \"-cpu qemu64,+vmx\";
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"spine1p1\"; };
    interface \"em2\" { bridge \"leaf2p2\"; };
    interface \"em3\" { bridge \"leaf2p3\"; };
  };

  vm \"vm_openwrt\" {
    hostname \"vm_openwrt_lede\";
    OPENWRT_BASE
    ncpus 2;
    memory 512;
    setvar \"boot_noveriexec\"       \"yes\";
    interface \"em0\" { bridge \"external\"; };
    interface \"em1\" { bridge \"external\"; };
    interface \"em2\" { bridge \"spine1p1\"; };
    interface \"em3\" { bridge \"leaf2p2\"; };
  };

  VMX_CHASSIS_START()
  #define VMX_CHASSIS_NAME vmx_gw
  VMX_CHASSIS_START()
    VMX_RE_START(vmx_gw, 0)
        VMX_RE_INSTANCE(vmx_gw, VMX_DISK, VMX_RE_I2CID, 0)
    VMX_RE_END
   VMX_MPC_START(vmx_gw_MPC,0)
        VMX_MPC_INSTANCE(vmx_gw_MPC, VMX_DISK, VMX_MPC_I2CID, 0)
          VMX_CONNECT(GE(0,0,0), private1)
          VMX_CONNECT(GE(0,0,1), private2)
          VMX_CONNECT(GE(0,0,2), private3)
          VMX_CONNECT(GE(0,0,3), vmx_spine1)
          VMX_CONNECT(GE(0,0,4), vmx_spine2)
    VMX_MPC_END
  VMX_CHASSIS_END

  vm \"vqfx10k_spine1\" {
      hostname \"vqfx10k_spine1\";
      VQFX10_DISK
      setvar \"boot_noveriexec\" \"YES\";
      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";
      VQFX_SYSTEST_CONFIG
      // Note: Don'\''t change destination paths below
      interface \"em0\" { bridge \"external\"; };
      interface \"em1\" { bridge \"pecosim_bridge_1\"; ipaddr \"169.254.0.2\"; };
      interface \"em2\" { bridge \"reserved_bridge\"; };
      interface \"em3\" { bridge \"vmx_spine1\"; };
      interface \"em4\" { bridge \"spine1_leaf1\"; };
      interface \"em5\" { bridge \"spine1_leaf2\"; };
      interface \"em6\" { bridge \"spine1p1\"; };
  };
  vm \"vqfx10k_spine1_cosim\" {
      hostname \"vqfx10k_spine1_cosim\";
      COSIM_DISK
      memory 4096;
      ncpus 4;
      // Note: Don'\''t change destination paths below
      interface \"em0\" { EXTERNAL; };
      interface \"em1\" { bridge \"pecosim_bridge_1\"; ipaddr \"169.254.0.1\"; };
  };

  vm \"vqfx10k_spine2\" {
      hostname \"vqfx10k_spine2\";
      VQFX10_DISK
      setvar \"boot_noveriexec\" \"YES\";
      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";
      VQFX_SYSTEST_CONFIG
      // Note: Don'\''t change destination paths below
      interface \"em0\" { bridge \"external\"; };
      interface \"em1\" { bridge \"pecosim_bridge_2\"; ipaddr \"169.254.0.2\"; };
      interface \"em2\" { bridge \"reserved_bridge\"; };
      interface \"em3\" { bridge \"vmx_spine2\"; };
      interface \"em4\" { bridge \"spine2_leaf1\"; };
      interface \"em5\" { bridge \"spine2_leaf2\"; };
      interface \"em6\" { bridge \"spine1p1\"; };
  };
  vm \"vqfx10k_spine2_cosim\" {
      hostname \"vqfx10k_spine2_cosim\";
      COSIM_DISK
      memory 4096;
      ncpus 4;
      // Note: Don'\''t change destination paths below
      interface \"em0\" { EXTERNAL; };
      interface \"em1\" { bridge \"pecosim_bridge_2\"; ipaddr \"169.254.0.1\"; };
  };

  vm \"vqfx10k_leaf1\" {
      hostname \"vqfx10k_leaf1\";
      VQFX10_DISK
      setvar \"boot_noveriexec\" \"YES\";
      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";
      VQFX_SYSTEST_CONFIG
      // Note: Don'\''t change destination paths below
      interface \"em0\" { bridge \"external\"; };
      interface \"em1\" { bridge \"pecosim_bridge_3\"; ipaddr \"169.254.0.2\"; };
      interface \"em2\" { bridge \"reserved_bridge\"; };
      interface \"em3\" { bridge \"spine1_leaf1\"; };
      interface \"em4\" { bridge \"leaf1p2\"; };
      interface \"em5\" { bridge \"leaf1p3\"; };
      interface \"em6\" { bridge \"spine2_leaf1\"; };
      interface \"em7\" { bridge \"spine1p1\"; };
      interface \"em8\" { bridge \"leaf1p4\"; };
      interface \"em9\" { bridge \"leaf1p5\"; };
  };
  vm \"vqfx10k_leaf1_cosim\" {
      hostname \"vqfx10k_leaf1_cosim\";
      COSIM_DISK
      memory 4096;
      ncpus 4;
      // Note: Don'\''t change destination paths below
      interface \"em0\" { EXTERNAL; };
      interface \"em1\" { bridge \"pecosim_bridge_3\"; ipaddr \"169.254.0.1\"; };
  };

  vm \"vqfx10k_leaf2\" {
      hostname \"vqfx10k_leaf2\";
      VQFX10_DISK
      setvar \"boot_noveriexec\" \"YES\";
      setvar \"qemu_args\" \"-smbios type=1,product=QFX10K-11\";
      VQFX_SYSTEST_CONFIG
      // Note: Don'\''t change destination paths below
      interface \"em0\" { bridge \"external\"; };
      interface \"em1\" { bridge \"pecosim_bridge_4\"; ipaddr \"169.254.0.2\"; };
      interface \"em2\" { bridge \"reserved_bridge\"; };
      interface \"em3\" { bridge \"spine1_leaf2\"; };
      interface \"em4\" { bridge \"leaf2p2\"; };
      interface \"em5\" { bridge \"leaf2p3\"; };
      interface \"em6\" { bridge \"spine2_leaf2\"; };
      interface \"em7\" { bridge \"spine1p1\"; };
      interface \"em8\" { bridge \"leaf2p4\"; };
      interface \"em9\" { bridge \"leaf2p5\"; };
  };
  vm \"vqfx10k_leaf2_cosim\" {
      hostname \"vqfx10k_leaf2_cosim\";
      COSIM_DISK
      memory 4096;
      ncpus 4;
      // Note: Don'\''t change destination paths below
      interface \"em0\" { EXTERNAL; };
      interface \"em1\" { bridge \"pecosim_bridge_4\"; ipaddr \"169.254.0.1\"; };
  };

   bridge \"pecosim_bridge_1\" {};
   bridge \"pecosim_bridge_2\" {};
   bridge \"pecosim_bridge_3\" {};
   bridge \"pecosim_bridge_4\" {};
   bridge \"reserved_bridge\" {};
   bridge \"spine1p1\" {};
   bridge \"spine1p2\" {};
   bridge \"spine1_leaf1\" {};
   bridge \"spine1_leaf2\" {};
   bridge \"spine2_leaf1\" {};
   bridge \"spine2_leaf2\" {};
   bridge \"leaf1p2\" {};
   bridge \"leaf1p3\" {};
   bridge \"leaf1p4\" {};
   bridge \"leaf1p5\" {};
   bridge \"leaf2p2\" {};
   bridge \"leaf2p3\" {};
   bridge \"leaf2p4\" {};
   bridge \"leaf2p5\" {};
   bridge \"vmx_spine1\" {};
   bridge \"vmx_spine2\" {};
PRIVATE_BRIDGES
};

EOF

chmod +x homes/reset-ansible.sh
 ./homes/reset-ansible.sh
