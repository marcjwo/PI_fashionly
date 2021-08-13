view: order_enhancement {
  derived_table: {
    sql: SELECT
      order_id,
      RANK () OVER (PARTITION BY user_id ORDER BY created_at) as order_sequence,
      IFNULL(DATE_DIFF(created_at,LAG (created_at,1) OVER (PARTITION BY user_id ORDER BY created_at),DAY),0) as days_between_orders
      FROM order_items
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }

  dimension: days_between_orders {
    type: number
    sql: ${TABLE}.days_between_orders ;;
  }

  set: detail {
    fields: [order_id, order_sequence, days_between_orders]
  }

#---------------- USER ADDITIONS --------------------------

  measure: average_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
    description: "Average time in days between orders"
    value_format_name: decimal_2
  }

  dimension: first_purchase {
    type:  yesno
    sql: ${order_sequence} = 1 ;;
    description: "Is this order a users first purchase?"
  }

  measure: min_days {
    type: min
    sql: ${days_between_orders} ;;
  }

  measure: 25percentile_days {
    type: percentile
    percentile: 25
    sql: ${days_between_orders} ;;
  }

  measure: 75percentile_days {
    type: percentile
    percentile: 75
    sql: ${days_between_orders} ;;
  }

  measure: max_days {
    type: max
    sql: ${days_between_orders} ;;
  }

  measure: median_days {
    type: median
    sql: ${days_between_orders} ;;
  }
}
