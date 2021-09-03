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
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
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
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- User additions -------------------

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  # dimension: logo {
  #   sql: ${inventory_items.product_brand_logo} ;;
  # }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    description: "Total sales from items sold"
    value_format_name: usd
  }

  measure: average_sales_price {
    type: average
    sql: NULLIF(${sale_price}) ;;
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

  measure: average_gross_revenue {
    type: average
    sql: ${sale_price} ;;
    filters: [status: "-Returned,-Cancelled"]
    description: "average revenue from completed sales"
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

  measure: gross_margin_viz {
    type: number
    sql: ${total_gross_margin} ;;
    # sql: ${total_gross_margin}/nullif(${total_gross_revenue},0) ;;
    value_format_name: usd
    html:
      Total margin: {{rendered_value}}<br>
      Total revenue: {{total_gross_revenue._rendered_value}}<br>
      Margin percentage: {{gross_margin_percentage._rendered_value}}
       ;;
  }

  # measure: gross_revenue_logo_viz {
  #   type: number
  #   sql: ${total_gross_revenue} ;;
  #   label: "https://logo.clearbit.com/{{logo._value}}.com"
  #   value_format_name: usd
  #   # html: <img src = "https://logo.clearbit.com/{{logo._value}}.com" /> ;;
  # }

  # measure: gross_margin_logo {
  #   type: number
  #   sql: ${total_gross_margin} ;;
  #   html: Total margin: {{rendered_value}}<br>
  #   <img src = "http://www.google.com/s2/favicons?domain={{product_brand._value}}.com" /> ;;
  # }

  # measure: gross_margin_viz {
  #   type: number
  #   sql: ${total_gross_margin}/nullif(${total_gross_revenue},0) ;;
  #   value_format_name: percent_2
  #   # html: {{ rendered_value }} margin of {{ total_gross_revenue._rendered_value }} total product revenue!;;
  # }

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
    sql: ${customer_returning_items}/${count} ;;
    description: "Percentage of users with returns"
    value_format_name: percent_2
  }

  measure: average_spend_per_user {
    type: number
    sql: ${total_gross_revenue}/${count} ;;
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
    hidden: yes
    type: yesno
    sql: ${created_day_of_month} <= EXTRACT(DAY FROM current_date()) ;;
  }

  # measure: distinct_order_count {
  #   type: count_distinct
  #   sql: ${order_id} ;;
  # }

  dimension_group: signup_to_order {
    type: duration
    intervals: [day,month,year]
    sql_start: ${users.created_date} ;;
    sql_end: ${created_date} ;;
  }

  # dimension: order_age_cohort {
  #   type: tier
  #   tiers: [12,24,36]
  #   style: integer
  #   sql: ${months_order_to_signup} ;;
  # }


  measure: first_order {
    type: date
    sql: min(${created_raw});;
  }

  measure: latest_order {
    type: date
    sql: max(${created_raw}) ;;
  }

  dimension_group: shipping_time {
    type: duration
    intervals: [day]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  filter: select_granularity {
    label: "Determine Drill Granularity"
    default_value: "Brand Only"
    type: string
    suggestions: ["Brand only","Category only","Brand & Category Only","Brand & Category And All Other Categories"]
  }

  dimension: compare_me {
    type: string
    sql:
    CASE
    WHEN {% condition select_granularity %} "Brand only" {% endcondition %}
    THEN ${comparison_brand}
    WHEN {% condition select_granularity %} "Category only" {% endcondition %}
    THEN ${comparison_category}
    WHEN {% condition select_granularity %} "Brand & Category Only" {% endcondition %}
    THEN ${comparison_category_brand_only}
    WHEN {% condition select_granularity %} "Brand & Category And All Other Categories" {% endcondition %}
    THEN ${comparison_category_brand}
    END;;
  }

  dimension: comparison_brand {
    sql:
    CASE
    WHEN  ${products.brand} = ${product_selected.brand}
    THEN '(1) '||${products.brand}
    ELSE '(2) Other Brands'
    END;;}

  dimension: comparison_category {
    sql:
    CASE
    WHEN  ${products.category} = ${product_selected.category}
    THEN '(1) '||${products.category}
    ELSE '(2) All Other Categories'
    END;;}

  dimension: comparison_category_brand_only {
    sql:
    CASE
    WHEN ${products.brand} = ${product_selected.brand} AND ${products.category} = ${product_selected.category}
    THEN '(1) '||${products.brand}||' - '||${products.category}
    WHEN ${products.category} = ${product_selected.category}
    THEN '(2) Rest of Population - '||${products.category}
  --   ELSE '(3) Everything Else'
    END;;}


  dimension: comparison_category_brand {
    sql:
    CASE
    WHEN ${products.brand} = ${product_selected.brand} AND ${products.category} = ${product_selected.category}
    THEN '(1) '||${products.brand}||' - '||${products.category}
    WHEN ${products.brand} = ${product_selected.brand}
    THEN '(2) '||${products.brand}||' - Other Categories'
    WHEN ${products.category} = ${product_selected.category}
    THEN '(3) Rest of Population - '||${products.category}
    ELSE '(4) Rest of Population - Other Categories'
    END;;}

  measure: total_sales_this_brand {
    type: sum
    sql: ${sale_price};;
    filters: [compare_me: "(2)%,(1)%"]
    value_format_name: usd
  }

  measure: share_of_wallet_in_company {
    type: number
    sql: ${total_sales_this_brand}/${total_sales} ;;
    value_format_name: percent_2
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
