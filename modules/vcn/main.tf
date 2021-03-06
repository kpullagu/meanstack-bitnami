variable "VPC-CIDR" {
  default = "10.0.0.0/16"
  }
data "baremetal_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "baremetal_core_virtual_network" "a_hub_VCN" {
  cidr_block = "10.0.0.0/16"
    compartment_id = "${var.compartment_ocid}"
      display_name = "a_hub_VCN"
      }

resource "baremetal_core_internet_gateway" "a_hub_IG" {
    compartment_id = "${var.compartment_ocid}"
        display_name = "a_hub_IG"
	    vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	    }



resource "baremetal_core_route_table" "a_hub_RT" {
    compartment_id = "${var.compartment_ocid}"
        vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	    display_name = "a_hub_RT"
	        route_rules {
		        cidr_block = "0.0.0.0/0"
			        network_entity_id = "${baremetal_core_internet_gateway.a_hub_IG.id}"
				    }
				    }


resource "baremetal_core_security_list" "a_hub_SL_Public" {
    compartment_id = "${var.compartment_ocid}"
        display_name = "a_hub_SL_Public"
	    vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	       egress_security_rules = [{
	               destination = "0.0.0.0/0"
		               protocol = "6"
			           }]
				       ingress_security_rules = [{
				               tcp_options {
					                   "max" = 40000 
							               "min" = 20 
								               }
									               protocol = "6"
										               source = "0.0.0.0/0"
											           },
												   	{
														protocol = "6"
															source = "10.0.0.0/16"
															    }]

															   } 

resource "baremetal_core_subnet" "a_hub_Public_SubnetAD1" {
 availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    cidr_block = "10.0.1.0/24"
      display_name = "a_hub_Public_SubnetAD1"
        compartment_id = "${var.compartment_ocid}"
	  vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	    route_table_id = "${baremetal_core_route_table.a_hub_RT.id}"
	      security_list_ids = ["${baremetal_core_security_list.a_hub_SL_Public.id}"]
	      }
		  resource "baremetal_core_subnet" "a_hub_Public_SubnetAD2" {
 availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}"
    cidr_block = "10.0.2.0/24"
      display_name = "a_hub_Public_SubnetAD2"
        compartment_id = "${var.compartment_ocid}"
	  vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	    route_table_id = "${baremetal_core_route_table.a_hub_RT.id}"
	      security_list_ids = ["${baremetal_core_security_list.a_hub_SL_Public.id}"]
	      }
resource "baremetal_core_subnet" "a_hub_Public_SubnetAD3" {
 availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[2],"name")}"
    cidr_block = "10.0.3.0/24"
      display_name = "a_hub_Public_SubnetAD3"
        compartment_id = "${var.compartment_ocid}"
	  vcn_id = "${baremetal_core_virtual_network.a_hub_VCN.id}"
	    route_table_id = "${baremetal_core_route_table.a_hub_RT.id}"
	      security_list_ids = ["${baremetal_core_security_list.a_hub_SL_Public.id}"]
	      }



