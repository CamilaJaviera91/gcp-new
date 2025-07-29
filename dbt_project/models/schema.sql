version: 2

models:
  - name: clients
    description: "Table of users generated with random data."
    columns:
      - name: client_id
        description: "Unique identifier of the user."
        tests:
          - not_null
          - unique

      - name: first_name
        description: "First name of the user."

      - name: last_name
        description: "Last name of the user."

      - name: gender
        description: "Gender of the user. Values: 'M' or 'F'."
        tests:
          - accepted_values:
              values: ['M', 'F']

      - name: country
        description: "Country of origin of the user."

      - name: username
        description: "Generated username based on name and user ID."

      - name: email
        description: "Generated fake email address."
        tests:
          - not_null

      - name: phone_number
        description: "Randomly generated Chilean phone number."

      - name: status
        description: "Account status of the user. Either 'active' or 'inactive'."
        tests:
          - not_null
          - accepted_values:
              values: ['active', 'inactive']

  - name: products
    description: "Table of products generated with random data."
    columns:
      - name: product_id
        description: "Unique identifier of the product."
        tests:
          - not_null
          - unique

      - name: product_name
        description: "Name of the product."

      - name: category
        description: "Category to which the product belongs."

      - name: price
        description: "Price of the product."

  - name: orders
    description: "Table of orders generated based on users and products."
    columns:
      - name: order_item_id
        description: "Unique identifier of the order item."
        tests:
          - not_null
          - unique

      - name: order_id
        description: "Identifier of the order."

      - name: client_id
        description: "Identifier of the user who placed the order."

      - name: product_id
        description: "Identifier of the purchased product."

      - name: sale_date
        description: "Date when the order was placed."

  - name: final_report

    description: "Final report table that consolidates information from orders, users, and products."

    columns:
      - name: order_id
        description: "Identifier of the order."
        tests:
          - not_null
          - unique

      - name: user_id
        description: "Identifier of the user who placed the order."
        tests:
          - not_null

      - name: full_name
        description: "Full name of the user (first name + last name)."
        tests:
          - not_null

      - name: sale_date
        description: "Date when the order was placed."
        tests:
          - not_null

      - name: product_name
        description: "Name of the purchased product."
        tests:
          - not_null

      - name: product_category
        description: "Category of the purchased product."

      - name: product_price
        description: "Unit price of the product at the time of purchase."
        tests:
          - not_null
      
  - name: sales_by_product
  
    description: "Monthly and yearly sales totals per product."
  
    columns:
      - name: ProductID
        description: "Unique identifier of the product."
        tests:
          - not_null

      - name: ProductName
        description: "Name of the product."
        tests:
          - not_null

      - name: Month
        description: "Month of the sale date (1-12)."
        tests:
          - not_null

      - name: Year
        description: "Year of the sale date."
        tests:
          - not_null

      - name: Total
        description: "Total sales revenue for the product in the given month and year."
        tests:
          - not_null