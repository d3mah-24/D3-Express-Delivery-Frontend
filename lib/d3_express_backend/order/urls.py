from django.urls import path

from order.views import (
    OrderCreatelistView,
    OrderHistory,
    OrderRetriveUpdateView,
    Set_delivery,
    Approve_payment,
    Status_update,
)


urlpatterns = [
    path("", OrderCreatelistView.as_view()),
    path("<str:id>", OrderRetriveUpdateView.as_view()),
    path("approve/<str:id>", Approve_payment),
    path("orderhistory/<str:id>", OrderHistory.as_view()),
    path("updateStatus/<str:id>/<str:status>", Status_update),
    path("setDelivery/<str:id>/<str:user_id>", Set_delivery),
]
