view: users {
  sql_table_name: `thelook.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
      day_of_month,
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [gender,age_group]
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, order_items.count, events.count]
  }

# ----- User additions -------------------

  dimension: mtd  {
    type: yesno
    sql: ${created_day_of_month} <= EXTRACT(DAY FROM current_date()) ;;
  }

  dimension: age_group {
    type: tier
    tiers: [14,26,36,51,66]
    style: integer
    sql: ${age} ;;
  }

  # dimension_group: since_signup {
  #   type: duration
  #   sql_start: ${created_date} ;;
  #   sql_end: ${order_items.created_date} ;;
  #   # sql_end: current_date() ;;
  # }

  # dimension:  new_customer {
  #   type: yesno
  #   sql: ${days_since_signup} <= 90 ;;
  # }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    drill_fields: [inventory_items.product_category, inventory_items.products_brand]
  }

  dimension_group: since_sign_up {
    type: duration
    sql_start: ${created_date} ;;
    sql_end: CURRENT_DATE()  ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_sign_up} <= 90 ;;
  }

  dimension: sign_up_cohort {
    type: tier
    style: integer
    tiers: [6,12,24,36]
    sql: ${months_since_sign_up} ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} ||' '||${last_name} ;;
  }
  # dimension: recency {
  #   type: duration_month
  #   sql_start: ${user_order_facts.latest_order_date}  ;;
  #   sql_end: CURRENT_DATE() ;;
  # }


}
