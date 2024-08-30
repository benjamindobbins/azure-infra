module "resource_group" {
  source = "./modules/resource_group"
}

module "virtual_network" {
  source = "./modules/virtual_network"

    earg_name = module.resource_group.earg_name
    earg_loc =  module.resource_group.earg_loc
    userg_name = module.resource_group.userg_name
    userg_loc =  module.resource_group.userg_loc

}
module "virtual_machine" {
    source = "./modules/virtual_machine"

    earg_name = module.resource_group.earg_name
    earg_loc =  module.resource_group.earg_loc
    userg_name = module.resource_group.userg_name
    userg_loc =  module.resource_group.userg_loc
    earg_subnet_id = module.virtual_network.earg_subnet_id
    userg_subnet_id = module.virtual_network.userg_subnet_id
}

module "database" {
  source = "./modules/database"
  earg_name = module.resource_group.earg_name
  earg_loc =  module.resource_group.earg_loc
  
}