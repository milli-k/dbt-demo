{{ config(alias='events') }}

select
  {{ dbt_utils.star(source('ecomm', 'events')) }}
from {{ source('ecomm', 'events') }}