view: products {
  sql_table_name: `thelook.products`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=google.com"
    }
    # link: {
    #   label: "Google Encode Uri"
    #   url: "http://www.google.com/search?q={{ value | encode_uri}}"
    #   icon_url: "https://www.google.com/s2/favicons?domain=google.com"
    # }
    link: {
      label: "Facebook"
      url: "http://www.facebook.com/{{ value }}"
      icon_url: "https://www.google.com/s2/favicons?domain=facebook.com"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }

#--- user additions

  dimension: brand_cleansed {
    # hidden: yes
    type: string
    sql: REPLACE(REPLACE(${brand}," ",""),"'","") ;;
  }

  dimension: brand_logo {
    # type: string
    sql: ${brand_cleansed} ;;
    html: <img src = "https://logo.clearbit.com/{{brand_cleansed._value}}.com" /> ;;
    # link: {
    #   label: "{{value}} website"
    #   url: "http://www.{{product_brand_cleansed._rendered_value}}.com"
    #   icon_url: "http://www.google.com/s2/favicons?domain={{brand_cleansed._value}}.com"
    # }
  }

  # dimension: brand_logo_small {
  #   # type: string
  #   sql: ${brand_cleansed} ;;
  #   html: <img src = "https://logo.clearbit.com/{{brand_cleansed._value}}.com?size=25" /> ;;
  # }

  dimension: brand_logo_small {
    # type: string
    sql: ${brand_cleansed} ;;
    html: <img src = "http://www.google.com/s2/favicons?domain={{brand_cleansed._value}}.com"/>;;
  }

  # dimension: comparison {
  #   sql:
  #   CASE
  #   WHEN  ${products.brand} = ${product_select.brand} THEN '(1) '||${products.brand}
  #   WHEN  ${products.category} = ${product_select.category} THEN '(2) Rest of '||${products.category}
  #   WHEN  ${products.department} = ${product_select.department} THEN '(2) Rest of '||${products.department}
  #   ELSE '(4) Rest Of Population'
  #   END;;
  # }


  measure: count_brands {
    type: count_distinct
    sql: ${brand} ;;
  }
}
