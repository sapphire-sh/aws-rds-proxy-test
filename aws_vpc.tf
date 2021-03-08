# data "aws_availability_zones" "main" {
#   state = "available"
# }

# resource "aws_default_subnet" "default" {
#   count = length(data.aws_availability_zones.main.names)

#   availability_zone = data.aws_availability_zones.main.names[count.index]
# }

# data "aws_security_group" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = var.name
#   }
# }

# data "aws_subnet_ids" "main_private" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Tier = "private"
#   }
# }

# data "aws_subnet_ids" "main_public" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Tier = "public"
#   }
# }
