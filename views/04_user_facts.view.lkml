# If necessary, uncomment the line below to include explore_source.
# include: "fashionly_casestudy.model.lkml"

view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: order_count {}
      column: total_gross_revenue {}
      column: total_gross_margin {}
      column: total_sales {}
      column: first_order {}
      column: latest_order {}
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
  }
  dimension: lifetime_orders {
    type: number
    sql: COALESCE(${TABLE}.order_count,0) ;;
  }
  dimension: total_gross_revenue {
    description: "Total revenue from completed sales"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: total_gross_margin {
    description: "Total difference between the total revenue from completed sales and the cost of goods that were sold"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: total_sales {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
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

  dimension_group: latest_order {
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
    sql: ${TABLE}.latest_order ;;
  }

  measure: count {
    type: count
  }



#--- USER ADDITIONS

  dimension: lifetime_orders_group {
    type: tier
    tiers: [0,1,2,3,6,10]
    style: integer
    sql: COALESCE(${lifetime_orders},0) ;;
    drill_fields: [users.gender, users.age_group, inventory_items.product_brand, inventory_items.product_category]
  }

  # dimension: lifetime_orders_casetest {
  #   type: string
  #   sql: CASE
  #   WHEN ${lifetime_orders} = 1 THEN '1'
  #   WHEN ${lifetime_orders} = 2 THEN '2'
  #   WHEN ${lifetime_orders} > 2 AND ${lifetime_orders} < 6 THEN '3-5'
  #   WHEN ${lifetime_orders} > 5 AND ${lifetime_orders} < 10 THEN '6-9'
  #   WHEN ${lifetime_orders} > 9 THEN '10+'
  #   ELSE '0' END;;
  # }


  # dimension: lifetime_orders_grouped {
  #   case: {
  #     # when: {
  #     #   sql: ${lifetime_orders} = ' ;;
  #     #   label: "0"
  #     # }
  #     when: {
  #       sql: ${lifetime_orders} = 1 ;;
  #       label: "1"
  #     }
  #     when: {
  #       sql: ${lifetime_orders} = 2 ;;
  #       label: "2"
  #     }
  #     when: {
  #       sql: ${lifetime_orders} > 3 AND ${lifetime_orders} < 6;;
  #       label: "3-5"
  #     }
  #     when: {
  #       sql: ${lifetime_orders} > 5 AND ${lifetime_orders} < 10;;
  #       label: "6-9"
  #     }
  #     when: {
  #       sql: ${lifetime_orders} > 9;;
  #       label: "10+"
  #     }
  #     else: "0"
  #   }
  # }

  dimension: lifetime_revenue_group {
    type: tier
    tiers: [0,5,20,50,100,500,1000,10000]
    style: integer
    sql: COALESCE(${total_gross_revenue},0);;
    value_format: "$0"
    drill_fields: [inventory_items.product_brand, inventory_items.product_category]
  }

  dimension_group: since_last_order {
    type: duration
    intervals: [year,week,day]
    sql_start: ${latest_order_date} ;;
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

  dimension_group: until_first_order {
    type: duration
    intervals: [day,week,month]
    sql_start: ${users.created_date} ;;
    sql_end: ${first_order_date} ;;
  }

  measure: total_repurchasers {
    type: count_distinct
    sql: ${user_id};;
    filters: [repeat_customer: "yes"]
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${total_gross_revenue} ;;
    description: "Total lifetime revenue to slice by"
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    type:  average
    sql: ${total_gross_revenue} ;;
    description: "Average lifetime revenue to slice by"
    value_format_name: usd
  }

  measure: average_days_until_first_order {
    type: average
    sql: ${days_until_first_order} ;;
  }

  measure: Count_Purchasers{
    type: count
    filters: [first_order_date: "-NULL"]
    description: "People that purchased"
  }
}
