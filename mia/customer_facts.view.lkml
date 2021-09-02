view: customer_facts {
  derived_table: {
    sql: SELECT
      user_id,
      COUNT(DISTINCT order_id) AS lifetime_orders,
      SUM(sale_price) AS lifetime_revenue,
      MIN(created_at) AS first_order,
      MAX(created_at) AS last_order
FROM order_items
GROUP BY 1
;;
  }

  measure: count {
    type: count
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_month
    ]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_month
    ]
    sql: ${TABLE}.last_order ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue, first_order_time, last_order_time]
  }

#--- USER ADDITIONS

  dimension: lifetime_orders_group {
    type: tier
    tiers: [1,2,3,6,10]
    style: integer
    sql: ${lifetime_orders} ;;
    drill_fields: [inventory_items.product_brand, inventory_items.product_category]
  }

  dimension: lifetime_revenue_group {
    type: tier
    tiers: [0,5,20,50,100,500,1000,10000]
    style: integer
    sql: ${lifetime_revenue};;
    value_format: "$#.00;($#.00)"
    drill_fields: [inventory_items.product_brand, inventory_items.product_category]
  }

  dimension_group: since_last_order {
    type: duration
    intervals: [year,week,day]
    sql_start: ${last_order_date} ;;
    sql_end: current_date() ;;
  }

  dimension: active_ind {
    type: yesno
    sql: ${days_since_last_order} <= 90 ;;
    # drill_fields: [inventory_items.product_brand, inventory_items.product_category]
  }

  dimension: repeat_customer {
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
    drill_fields: [inventory_items.product_brand, inventory_items.product_category]
  }

  measure: total_repurchasers {
    type: count_distinct
    sql: ${user_id};;
    filters: [repeat_customer: "yes"]
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    description: "Total lifetime revenue to slice by"
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    type:  average
    sql: ${lifetime_revenue} ;;
    description: "Average lifetime revenue to slice by"
    value_format_name: usd
  }
}
