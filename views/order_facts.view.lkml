view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: items_in_order {field: order_items.count}
      column: order_amount {field: order_items.total_sales}
      column: order_cost {field: order_items.total_cost}
      column: user_id {}
      column: created_at {field: order_items.created_raw}
      column: order_gross_margin {field: order_items.total_gross_margin}
      column: order_gross_revenue {field: order_items.total_gross_revenue}
      derived_column: order_sequence {
        sql: RANK () OVER (PARTITION BY user_id ORDER BY created_at);;
      }
      derived_column: days_between_orders {
        sql: IFNULL(DATE_DIFF(created_at,LAG (created_at,1) OVER (PARTITION BY user_id ORDER BY created_at),DAY),0);;
      }
      derived_column: running_sales {
        sql: SUM(order_amount) OVER (PARTITION BY user_id ORDER BY created_at) ;;
      }
    }
  }
  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: number
  }
  dimension: items_in_order {
    type: number
  }
  dimension: order_amount {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
  }
  # dimension: order_cost {
  #   description: "Total cost of items sold from inventory"
  #   value_format: "$#,##0.00"
  #   type: number
  # }
  dimension: user_id {
    hidden: yes
    type: number
  }
  dimension: created_at {
    hidden: yes
    type: date
  }
  # dimension: order_gross_margin {
  #   description: "Total difference between the total revenue from completed sales and the cost of goods that were sold"
  #   value_format: "$#,##0.00"
  #   type: number
  # }
  # dimension: order_gross_revenue {
  #   description: "Total revenue from completed sales"
  #   value_format: "$#,##0.00"
  #   type: number
  # }
  dimension: order_sequence {
    type: number
  }
  dimension: days_between_orders {
    type: number
  }
  dimension: running_sales {
    type: number
    value_format_name: usd
  }
  dimension: is_first_purchase {
    type:  yesno
    sql: ${order_sequence} = 1 ;;
    description: "Is this order a users first purchase?"
  }
  measure: average_items_per_order {
    type: average
    sql: ${items_in_order} ;;
    value_format_name: decimal_2
  }
  measure: average_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
    value_format_name: decimal_2
  }
  measure: count {
    type: count
  }
  measure: average_running_sales {
    type: average
    sql: ${running_sales} ;;
    value_format_name: usd
  }

}
