view: inventory_items {
  sql_table_name: `thelook.inventory_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand_cleansed {
    hidden: yes
    type: string
    sql: REPLACE(REPLACE(${product_brand}," ",""),"'","") ;;
  }

  dimension: product_brand_logo {
    type: string
    sql: ${product_brand_cleansed} ;;
    html: <img src = "https://logo.clearbit.com/{{product_brand_cleansed._value}}.com" /> ;;
    link: {
      label: "{{value}} website"
      url: "http://www.{{product_brand_cleansed._rendered_value}}.com"
      icon_url: "http://www.google.com/s2/favicons?domain={{product_brand_cleansed._value}}.com   "
    }
  }

  dimension: product_brand_logo_small {
    type: string
    sql: ${product_brand_cleansed} ;;
    html: <img src = "https://www.google.com/s2/favicons?domain={{product_brand_cleansed._value}}" /> ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    drill_fields: [product_category,product_name]
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain={{ value }}"
    }
    link: {
      label: "Facebook"
      url: "http://www.facebook.com/{{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain={{ value }}"
    }
  # html: {{value}} - <img src = "http://www.google.com/s2/favicons?domain={{product_brand_cleansed._value}}.com" />   ;;
  }



  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }
}
