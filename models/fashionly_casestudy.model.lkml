connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"


explore: order_items {
  view_name: order_items
  view_label: "(1) Orders"
  label: "(1) Orders"
  fields: [ALL_FIELDS*, order_items.months_signup_to_order, user_id, -products.brand_select, -products.brand_comparison, -inventory_item_id, -products.brand_logo, -products.id,-products.brand_logo_small]
  # always_filter: {
  # filters: [order_items.created_date: "last 2 years"]
  # }
  join: order_facts {
    view_label: "(2) Order Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }

  join: order_facts_repurchase {
    view_label: "(2) Order Facts"
    type: full_outer
    sql_on: ${order_items.order_id} = ${order_facts_repurchase.order_id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    fields: []
    type: full_outer ### changing join required to prevent only seeing inventory items that have been sold
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "(3) Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    view_label: "(4) Users"
    # fields: [users.traffic_source,users.location,users.is_new_customer,users.gender,users.age_group, users.count,users.created_date, users.created_year, users.sign_up_cohort]
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_order_facts {
    type: left_outer
    view_label: "(4) Users"
    fields: [user_order_facts.recency_months]
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }

  join: distribution_centers {
    view_label: "(5) Distribution Centers"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}



explore: users {
  view_name: users
  label: "(2) Users"
  view_label: "(1) Users"
  join: user_order_facts {
    view_label: "(2) User Order Facts"
    type: left_outer
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
  join: order_items {
    # fields: [-order_items.average_costs, -order_items.total_cost]
    view_label: "(3) Orders"
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    fields: []
    type: full_outer ### changing join required to prevent only seeing inventory items that have been sold
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  label: "(3) Products"
  view_label: "(1) Products"
  # fields: [ALL_FIELDS*, -products.brand_logo, -products.brand_logo_small]
  join: inventory_items {
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
    fields: []
  }
  join: order_items {
    view_label: "(2) Orders"
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    # fields: [total_gross_revenue,status,count_distinct_orders,count,order_items.created_month,order_items.gross_margin]
  }
  join: users {
    sql_on: ${order_items.user_id} = ${users.id} ;;
    fields: []
    type: left_outer
    relationship: many_to_one
  }
}

explore: rfm {
}
# explore: user_order_facts {}

# explore: order_items_with_share_of_wallet {
#   view_name: order_items
#   join: order_facts {
#     view_label: "Orders"
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
#   }
#   join: order_facts_repurchase {
#     view_label: "Orders"
#     type: full_outer
#     sql_on: ${order_items.order_id} = ${order_facts_repurchase.order_id} ;;
#     relationship: many_to_one
#   }

#   join: inventory_items {
#     fields: []
#     type: full_outer ### changing join required to prevent only seeing inventory items that have been sold
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }
#   join: products {
#     view_label: "Products"
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
#   join: product_selected {
#     type: cross
#     relationship: many_to_many
#   }

#   join: users {
#     type: full_outer
#     sql_on: ${order_items.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }

#   join: user_order_facts {
#     # fields: [user_facts.repeat_customer, user_facts.days_until_first_order, user_facts.average_days_until_first_order]
#     type: left_outer
#     view_label: "User Order Facts"
#     sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
#     relationship: many_to_one
#   }
# }
