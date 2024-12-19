{{ config(alias='products') }}

select
  {{ dbt_utils.star(source('ecomm', 'products')) }}
from {{ source('ecomm', 'products') }}