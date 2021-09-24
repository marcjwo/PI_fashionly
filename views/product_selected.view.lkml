view: brand_selected {
  derived_table: {
    sql: SELECT
      *
      FROM products p
      WHERE {%condition brand%} p.brand {%endcondition%} AND {%condition category%} p.category {%endcondition%}
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # dimension: id {
  #   type: number
  #   sql: ${TABLE}.id ;;
  # }

  # dimension: cost {
  #   type: number
  #   sql: ${TABLE}.cost ;;
  # }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: brand_category {
    type: string
    sql: ${TABLE}.brand||" - "${TABLE}.category ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: brand {
    type: string
    suggest_dimension: products.brand
    sql: ${TABLE}.brand ;;
  }

  # dimension: retail_price {
  #   type: number
  #   sql: ${TABLE}.retail_price ;;
  # }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: distribution_center_id {
    type: string
    sql: ${TABLE}.distribution_center_id ;;
  }

  set: detail {
    fields: [
      # id,
      # cost,
      category,
      name,
      brand,
      # retail_price,
      department,
      sku,
      distribution_center_id
    ]
  }
}
