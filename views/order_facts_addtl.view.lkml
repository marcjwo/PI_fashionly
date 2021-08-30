view: order_facts_addtl {
  derived_table: {
    sql: SELECT
      a.order_id,
      a.created_at,
      COUNT(DISTINCT b.order_id) as number_of_subsequent_orders,
      MIN(b.order_id) as next_order_id,
      MIN(b.created_at) as next_order
      FROM order_items a
      JOIN order_items b
      ON a.user_id = b.user_id
      AND a.created_at < b.created_at
      GROUP BY 1,2
       ;;
  }

  # measure: count {
  #   type: count
  #   # drill_fields: [detail*]
  # }

  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  # dimension_group: created {
  #   type: time
  #   # timeframes: [
  #   #   raw,
  #   #   time,
  #   #   date,
  #   #   week,
  #   #   month,
  #   #   month_name,
  #   #   quarter,
  #   #   year,
  #   #   day_of_month
  #   # ]
  #   sql: ${TABLE}.created_at ;;
  # }

  dimension: number_of_subsequent_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_subsequent_orders ;;
  }

  dimension: next_order_id {
    type: number
    sql: ${TABLE}.next_order_id ;;
  }

  # dimension_group: next_order {
  #   type: time
  #   sql: ${TABLE}.next_order ;;
  # }

  # set: detail {
  #   fields: [order_id, created_time, number_of_subsequent_orders, next_order_id, next_order_time]
  # }

### USER ADDITIONS

  dimension: has_subsequent_orders {
    type: yesno
    sql: ${number_of_subsequent_orders} > 0 ;;
  }

  # dimension_group: next_order_in {
  #   type: duration
  #   sql_start: ${created_date} ;;
  #   sql_end: ${next_order_date} ;;
  # }

}
