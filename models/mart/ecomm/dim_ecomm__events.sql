{{
    config(
        alias='events'
    )
}}
select
  {{ dbt_utils.star(ref('int_ecomm__events')) }}
from {{ ref('int_ecomm__events') }}