connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"

datagroup: fashionly_casestudy_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: fashionly_casestudy_default_datagroup

# explore: distribution_centers {}

# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_enhancement {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_enhancement.order_id} ;;
    relationship: one_to_one
  }
}

#----- USER CREATED EXPLORES --------------

# explore: customer_facts {
#   fields: [ALL_FIELDS*, -order_items.average_costs, -order_items.total_cost]
#   join: users {
#     type: left_outer
#     sql_on: ${customer_facts.user_id} = ${users.id} ;;
#     relationship: one_to_one
#   }
#   join: order_items {
#     type: left_outer
#     sql_on: ${customer_facts.user_id} = ${order_items.user_id} ;;
#     relationship: one_to_many
#   }
#   join: inventory_items {
#     type: left_outer
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }
#   join: order_enhancement {
#     type: left_outer
#     sql_on: ${order_items.order_id} = ${order_enhancement.order_id};;
#     relationship: one_to_one
#   }
# }

# explore: users {
#   join: order_items {
#     type: left_outer
#     sql_on: ${users.id} = ${order_items.user_id} ;;
#     relationship: one_to_many
#   }
# }


# explore: users {
# }


# explore: products {
#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }
