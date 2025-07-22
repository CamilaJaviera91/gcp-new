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

      - name: role
        description: "Assigned role to the user"

      - name: country
        description: "User's country of origin"

      - name: username
        description: "Generated username based on name and user_id"

      - name: email
        description: "Fake generated email address"
        tests:
          - not_null

      - name: phone_number
        description: "Fake Chilean phone number"

      - name: created_at
        description: "Randomly generated creation date"
        tests:
          - not_null

      - name: status
        description: "User status (active or inactive)"
        tests:
          - not_null
          - accepted_values:
              values: ['active', 'inactive']

      - name: terminated_at
        description: "Date when the user was marked as inactive, NULL if active"