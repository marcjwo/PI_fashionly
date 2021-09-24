# If necessary, uncomment the line below to include explore_source.
# include: "fashionly_casestudy.model.lkml"

view: rfm {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: total_sales {}
      column: created_at {field: order_items.created_raw}
      column: order_id {}
      column: recency_months {field: user_order_facts.recency_months}
      filters: {
        field: order_items.status
        value: "-%Returned%,-%Cancelled%"
      }
      derived_column: months_between_orders {
        sql: IFNULL(DATETIME_DIFF(LAG(EXTRACT(DATE from created_at),1) OVER (PARTITION BY user_id ORDER BY EXTRACT(DATE from created_at) DESC),EXTRACT(DATE from created_at), month),0) ;;
      }
      derived_column: order_sequence_per_customer {
        sql:RANK () OVER (PARTITION BY user_id ORDER BY created_at);;
      }
    }
  }
  dimension: user_id {
    label: "User ID"
    primary_key: yes
    type: number
  }
  measure: count {
    type: count
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }
  dimension: created_at {
    # hidden: yes
    type: date
  }
  dimension: sales {
    label: "Total sales"
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  measure: max_order_date {
    type: date
    sql: MAX(${created_at}) ;;
  }

  measure: recency {
    type: number
    sql:DATETIME_DIFF(CURRENT_DATE(),${max_order_date},MONTH);;
  }

  dimension: order_id {
    label: "Order ID"
    type: number
  }
  dimension: months_between_orders {
    type: number
  }
  dimension: order_sequence_by_customer {
    type: number
  }
  dimension: recency_months {
    type: number
  }

  dimension: recency_tiers {
    type: tier
    tiers: [3,7,12,16]
    sql: ${recency_months} ;;
    style: integer
  }
  dimension: invoice_within_12_of_last {
    type: yesno
    sql: ${months_between_orders} > 0 AND ${months_between_orders} < 13 ;;
  }
  measure: total_sales {
    type: sum
    sql: ${sales} ;;
    value_format_name: usd
  }
  measure: invoice_count_l12m {
    type: count
    filters: [invoice_within_12_of_last: "Yes"]
  }

  measure: total_sales_invoice_l12m {
    type: sum
    sql: ${sales} ;;
    filters: [invoice_within_12_of_last: "Yes"]
    value_format_name: usd
  }
}
