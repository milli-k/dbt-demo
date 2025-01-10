Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- `dbt run`: creates all enabled models in the project
- `dbt test`: runs all tests defined in the project
- `dbt build`: creates and tests all enabled models in the project
- `dbt run --select path.to.directory`: runs all models in a directory
- `dbt deps`: refreshes your project set up - useful if updating things in dbt_project.yml and updating packages


### General flow
This project is set up to build things under the database analytics_prod.

Personal dev set up:
- To get access to the dbt cloud IDE, you will need to be invited by someone on the SE team
- You will need a Snowflake key-pair value generated for you by a Snowflake account admin
- Here are recommended inputs for the Snowflake config:
  - role: analyst
  - database: analytics_dev
  - warehouse: compute_wh
  - auth method: Key pair
  - username: you omni email
  - schema: dbt_<firstInitiallastName> e.g. (jkhiev)
  - <b>target name: dev</b>
    - this one is a hard requirement to get models to build in your custom schema when working in dev (e.g. dbt_jkhiev_ecomm)

Guidelines for building:
- use generate_source.sql in the analyses folder to generate new source files
- under each of these, you should create a sub-folder that matches the name of your schema
  - staging is where raw views go (i.e. selecting * from source)
  - intermediate is where reused logic for your marts should go
  - mart is where the final dimension / fact / mart that you want to expose in Omni should go
- update the dbt_project.yml to ensure that your models are built in the correct schema

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](http://community.getbdt.com/) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
