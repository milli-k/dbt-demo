{{ config(alias='users') }}

select
  {{ dbt_utils.star(source('ecomm', 'users')) }}
from {{ source('ecomm', 'users') }}