version: 2

models:
  - name: users
    description: "Table of users generated with random data"
    columns:
      - name: user_id
        description: "Unique identifier for the user"
        tests:
          - not_null
          - unique

      - name: first_name
        description: "User's first name"

      - name: last_name
        description: "User's last name"

      - name: gender
        description: "User gender (M or F)"
        tests:
          - accepted_values:
              values: ['M', 'F']

      - name: country
        description: "User's city of origin"

      - name: username
        description: "Generated username based on name and user_id"

      - name: email
        description: "Fake generated email address"
        tests:
          - not_null

      - name: phone_number
        description: "Fake Chilean phone number"

      - name: status
        description: "User status (active or inactive)"
        tests:
          - not_null
          - accepted_values:
              values: ['active', 'inactive']

  - name: products
    description: "Table of products generated with random data"
    columns:
      - name: product_id
        description: "Unique identifier for the product"
        tests:
          - not_null
          - unique

      - name: product_name
        description: "Product's name"

      - name: category
        description: "Product's category name"

      - name: price
        description: "Product's price"
  
  - name: orders
    description: "Table of orders generated with the data of the previous tables"
    columns:
      - name: order_item_id
        description: "Unique identifier for the item"
        tests:
          - not_null
          - unique

      - name: order_id
        description: "Order's ID"

      - name: client_id
        description: "Client's ID"

      - name: product_id
        description: "Product's ID"

      - name: sale_date
        description: "Order's date"