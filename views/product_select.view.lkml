# If necessary, uncomment the line below to include explore_source.
# include: "fashionly_casestudy.model.lkml"

view: product_select {
  derived_table: {
    explore_source: order_items {
      bind_filters: {
        to_field: product_select.brand
        from_field: products.brand
      }
      column: brand { field: products.brand }
      column: category { field: products.category }
      column: department { field: products.department }
      column: name { field: products.name }
    }
  }
  dimension: brand {}
  dimension: category {}
  dimension: department {}
  dimension: name {}
}
