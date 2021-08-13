view: order_items {
  sql_table_name: `thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- User additions -------------------

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    description: "Total sales from items sold"
    value_format_name: usd
  }

  measure: average_sales_price {
    type: average
    sql: ${sale_price} ;;
    description: "Average sales price from items sold"
    value_format_name: usd
  }

  measure: cumulative_sales_price {
    type: running_total
    sql: ${sale_price} ;;
    description: "Cumulative total sales from items sold/running total"
    value_format_name: usd
  }

  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "-Returned,-Cancelled"]
    description: "Total revenue from completed sales"
    value_format_name: usd
  }

  measure: total_gross_margin {
    type: number
    sql: ${total_gross_revenue} - ${total_cost} ;;
    description: "Total difference between the total revenue from completed sales and the cost of goods that were sold"
    value_format_name: usd
  }

  measure: average_gross_margin {
    type: number
    sql: (${total_gross_revenue} - ${total_cost})/${count} ;;
    description: "Average difference between the total revenue from completed sales and the cost of goods that were sold"
    value_format_name: usd
  }

  measure: gross_margin_percentage {
    type: number
    sql: ${total_gross_margin}/nullif(${total_gross_revenue},0) ;;
    value_format_name: percent_2
  }

  # measure: gross_revenue_percentage {
  #   type: number
  #   sql: ${total_gross_revenue}/sum(nullif(${total_gross_revenue},0)) ;;
  #   value_format_name: percent_2
  # }

### -------------------------------------------------  2 ways to determine returned items

  # measure: returned_items {
  #   type: count
  #   filters: [status: "Returned"]
  #   drill_fields: [detail*]
  # }

### -------------------------------------------------

  measure: returned_items {
    type: count
    filters: [returned_date: "-NULL"]
    drill_fields: [detail*]
    description: "Number of items that were returned by dissatisfied customers"
  }

  measure: item_return_rate {
    type: number
    sql: ${returned_items}/${count} ;;
    description: "Item return rate"
    value_format_name: percent_2
  }

  measure: customer_returning_items {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [returned_date: "-NULL"]
  }


  measure: number_of_users_with_orders {
    type: count_distinct
    sql: ${user_id} ;;
    description: "Number of distinct users that have placed an order"
  }

  measure: user_return_rate {
    type: number
    sql: ${customer_returning_items}/${number_of_users_with_orders} ;;
    description: "Percentage of users with returns"
    value_format_name: percent_2
  }

  measure: average_spend_per_user {
    type: number
    sql: ${total_sales}/${number_of_users_with_orders} ;;
    value_format_name: usd
    description: "Average spend per user"
  }

  measure: total_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
    description: "Total cost of items sold from inventory"
    value_format_name: usd
  }

  measure: average_costs {
    type: average
    sql: ${inventory_items.cost} ;;
    description: "Average cost of items sold from inventory"
    value_format_name: usd
  }

  dimension: mtd  {
    type: yesno
    sql: ${created_day_of_month} <= EXTRACT(DAY FROM current_date()) ;;
  }

  measure: distinct_order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension_group: order_to_signup {
    type: duration
    intervals: [day,month,year]
    sql_start: ${users.created_date} ;;
    sql_end: ${created_date} ;;
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
