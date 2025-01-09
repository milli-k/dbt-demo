{{
    config(
        alias='sessions'
    )
}}
with
    sessions as (
        select *
        from
            (
                with
                    events_plus as (
                        select
                            id,
                            session_id,
                            created_at,
                            event_type,
                            first_value(user_id) over (
                                partition by session_id order by created_at asc
                            ) as user_id

                        from {{ ref("int_ecomm__events") }}
                    )
                select
                    session_id,
                    user_id,
                    min(created_at) as session_start,
                    max(created_at) as session_end,
                    count(
                        distinct case when event_type = 'Product' then id else null end
                    ) as viewed_product_events,
                    count(
                        distinct case when event_type = 'Cart' then id else null end
                    ) as add_to_cart_events,
                    count(
                        distinct case when event_type = 'Purchase' then id else null end
                    ) as purchase_events,
                    count(
                        distinct case when event_type = 'Home' then id else null end
                    ) as login_events,
                    count(*) as total_events
                from events_plus
                group by 1, 2
            )
    )

select
    sessions.session_id,
    sessions.user_id,
    sessions.session_start,
    sessions.session_end,
    sessions.total_events as events_in_sessions,
    datediff(second, sessions.session_start, sessions.session_end) as duration,
    datediff(month, users.created_at, sessions.session_start) as months_since_created,
    round(
        datediff(second, sessions.session_start, sessions.session_end) / 60, 0
    ) as duration_minutes,
    sessions.add_to_cart_events,
    sessions.viewed_product_events,
    sessions.purchase_events,
    sessions.login_events,
    sessions.add_to_cart_events > 0
    and sessions.purchase_events < 1 as is_abandoned_cart,
    sessions.login_events > 0 as had_login_event,
    sessions.viewed_product_events > 0 as had_viewed_product_event,
    sessions.add_to_cart_events > 0 as had_add_to_cart_event,
    sessions.purchase_events > 0 as had_purchase_event
from sessions
left join {{ ref("int_ecomm__users") }} as users on sessions.user_id = users.id
