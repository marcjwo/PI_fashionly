connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"


explore: order_items {
  view_name: order_items
  join: order_facts {
    view_label: "Orders"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }

  join: order_facts_repurchase {
    view_label: "Orders"
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
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: product_selected {
    type: cross
    relationship: many_to_many
  }
  join: users {
    type: full_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    # fields: [user_facts.repeat_customer, user_facts.days_until_first_order, user_facts.average_days_until_first_order]
    type: left_outer
    view_label: "User Order Facts"
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
    relationship: many_to_one
  }
}

explore: order_items_with_share_of_wallet {
   view_name: order_items
   join: order_facts {
     view_label: "Orders"
     type: left_outer
     relationship: many_to_one
     sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
   }
   join: order_facts_repurchase {
     view_label: "Orders"
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
     view_label: "Products"
     type: left_outer
     sql_on: ${inventory_items.product_id} = ${products.id} ;;
     relationship: many_to_one
   }
   join: product_selected {
     type: cross
     relationship: many_to_many
   }

   join: users {
     type: full_outer
     sql_on: ${order_items.user_id} = ${users.id} ;;
     relationship: many_to_one
   }

   join: user_order_facts {
     # fields: [user_facts.repeat_customer, user_facts.days_until_first_order, user_facts.average_days_until_first_order]
     type: left_outer
     view_label: "User Order Facts"
     sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
     relationship: many_to_one
   }
}
