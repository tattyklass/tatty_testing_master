view: orders {
  sql_table_name: demo_db.orders ;;
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
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
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
    drill_fields: [id, users.last_name, users.id, users.first_name, order_items.count]
  }

  # measures below for html/liquid dashboard-next bug

  measure: sales_vbudget {
    type: number
    sql: ${count} - (${count}*2)/${count} ;;
    value_format: "0%"
    hidden:  yes
    view_label: "zz for dashboards"
  }

  measure: sales_millions {
    type: number
    hidden:  no
    sql: ${count} ;;
    value_format: "$0.00,,\" M\""
    view_label: "zz for dashboards"
    label: "Sales (in Millions)"
    description: "Sales but in M's format. Necessary for html tile in sales na dash"

  }

  measure: sales_vsbudget {
    hidden: no
    type: number
    value_format: "$0.00,,\" M\""
    view_label: "zz for dashboards"
    label: "Sales vs Budget"
    description: "html for sales vs goal tile for dashboards"
    sql: ${count} ;;
    html:
    {% if sales_vbudget._value < -0.05 %}
    <h2 style= "margin-left: 0px">
    <font size="9">
    {{ sales_millions._rendered_value}} </font>
    <h2 style= "margin-left: 0px">
    <font size="4" color="gray"> Sales </font> <br/>
    <font size="4" color="#a12a30"> &#9660; {{sales_vbudget._rendered_value}} </font>
    <font size="3" > vs Budget </font>

    {% elsif sales_vbudget._value > -0.05 %}
    <h2 style= "margin-left: 0px">
    <font size="9">
    {{ sales_millions._rendered_value}} </font>
    <h2 style= "margin-left: 0px">
    <font size="4" color="gray"> Sales </font><br/>
    <font size="4" color="#538a36"> &#9650; {{sales_vbudget._rendered_value}} </font>
    <font size="3" > vs Budget </font>
    {% endif %}
    ;;
  }
}
