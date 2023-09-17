from django.conf import settings
from django.shortcuts import get_object_or_404
import requests
from rest_framework import generics
from products.views import CustomPageNumberPagination
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_201_CREATED
from order.models import OrderItems, Orders
from order.serializer import OrderSerializer
from products.models import Product
from io import BytesIO
from django.http import HttpResponse, JsonResponse
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch
from reportlab.lib.colors import HexColor

from django.core.mail import EmailMessage
from dotenv import load_dotenv

load_dotenv()


def send_email_with_attachment(pdf_data, f_name, email):
    subject = "Receipt"
    message = "Sample Receipt"
    from_email = settings.EMAIL_HOST_USER
    recipient_list = ["aqoldiahmed@gmail.com", email]

    # Create an EmailMessage instance
    email = EmailMessage(subject, message, from_email, recipient_list)
    # Attach a file
    with open(f_name, "wb") as pdf_file:
        pdf_file.write(pdf_data)
    email.attach_file(f_name)
    # Send the email
    email.send()


def Receipt_Generator(buffer, order, id):
    pdf = canvas.Canvas(buffer)

    # Add logo
    # pdf.drawImage('logo.png', 1*inch, 10*inch, width=2*inch, preserveAspectRatio=True)

    # Add Receipt header
    pdf.setFillColor(HexColor("#444444"))
    pdf.setFont("Helvetica-Bold", 24)
    pdf.drawCentredString(4.25 * inch, 11 * inch, "RECEIPT")

    # Receipt details
    pdf.setFillColor(HexColor("#000000"))
    pdf.setFont("Helvetica", 14)
    pdf.drawString(1 * inch, 10 * inch, f"Receipt No: {id}")
    pdf.drawString(1 * inch, 9.5 * inch, f"Receipt Date: {order.date}")

    # Add table
    pdf.line(1 * inch, 8 * inch, 8 * inch, 8 * inch)
    pdf.drawString(1 * inch, 7.8 * inch, "#No.")
    pdf.drawString(2 * inch, 7.8 * inch, "Product")
    pdf.drawString(4 * inch, 7.8 * inch, "Quantity")
    pdf.drawString(6 * inch, 7.8 * inch, "Price")
    # pdf.drawString(7 * inch, 7.8 * inch, "Total")
    pdf.line(1 * inch, 7.6 * inch, 8 * inch, 7.6 * inch)

    y = 7.4
    total = 0
    for i, p in enumerate(OrderItems.objects.filter(order=order), 1):
        pdf.drawString(1 * inch, y * inch, f"{i}")
        pdf.drawString(2 * inch, y * inch, f"{p.item.name[:18]}..")
        pdf.drawString(4 * inch, y * inch, f"{p.quantity}")
        pdf.drawString(6 * inch, y * inch, f"$ {p.item.price}")
        total += p.item.price
        y -= 0.4

    # Totals
    pdf.line(1 * inch, (y - 0.2) * inch, 8 * inch, (y - 0.2) * inch)

    pdf.drawString(4.8 * inch, y * inch, f"Subtotal         $ {total}")
    pdf.drawString(4.8 * inch, y * inch - 0.4 * inch, f"Delivery Fee  $ {order.fee}")
    pdf.setFillColor(HexColor("#444444"))
    pdf.drawString(
        4.8 * inch,
        y * inch - 0.8 * inch,
        f"Total              $ {total+order.fee}",
    )

    pdf.save()

    pdf_data = buffer.getvalue()
    return pdf_data


# @user_passes_test(user_is_admin)
def Approve_payment(req, id):
    if req.method == "GET" and id:
        try:
            order = get_object_or_404(Orders, id=id)
            if not order.is_paid:
                order.is_paid = True
                order.save()
                buffer = BytesIO()

                pdf_data = Receipt_Generator(buffer, order, id)
                buffer.close()
                send_email_with_attachment(
                    pdf_data, f"Recipt_{id}.pdf", order.customer.email
                )
                url = "http://134.122.120.28:5000/api/notify"
                # for 
                data_to_send = {
                    "userId": order.customer,
                    "initialLat": 8.97874338,
                    "initialLong": 38.722713,
                    "destLat": 8.97634138,
                    "destLong": 38.748789,
                    "fee": 35.78,
                    "userFname": "Menge",
                    "userLname": "......",
                    "product": "PS3",
                    "productId": "IDKIDKIDK",
                }

                response = requests.post(url, data=data_to_send)

                if response.status_code == 200:
                    return HttpResponse("Successfully Approved", status=200)

                else:
                    return HttpResponse(
                        "Error: Unable to send data to the API",
                        status=response.status_code,
                    )

            else:
                return HttpResponse("Order is already approved", status=400)
        except Product.DoesNotExist:
            return HttpResponse("Order not found", status=404)
        except Exception as e:
            return HttpResponse(f"An error occurred : {str(e)}", status=500)


class OrderCreatelistView(generics.ListCreateAPIView):
    queryset = Orders.objects.all()
    lookup_field = "id"
    serializer_class = OrderSerializer

    def create(self, request):
        data = request.data
        serializer = OrderSerializer(data=data)
        serializer.is_valid(raise_exception=True)
        a = serializer.save()
        Total_price = 0
        for product in data["products"]:
            item = Product.objects.get(id=product["item"])
            quantity = product["quantity"]
            OrderItems.objects.create(
                order=a,
                item=item,
                quantity=quantity,
            )
            Total_price += int(quantity) * item.price
        a.total_price = Total_price
        a.save()
        return Response(serializer.data, status=HTTP_201_CREATED)


class OrderRetriveUpdateView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Orders.objects.all()
    serializer_class = OrderSerializer
    lookup_field = "id"


class OrderHistory(generics.ListAPIView):
    serializer_class = OrderSerializer
    pagination_class = CustomPageNumberPagination

    def get_queryset(self):
        id = self.kwargs["id"]
        return Orders.objects.filter(customer=id)


# @.....
def Status_update(req, id=None, status=None):
    if req.method == "GET" and id and status:
        try:
            order = Orders.objects.get(id=id)
            order.status = status
            order.save()
        except Exception as e:
            raise e
        return JsonResponse({"status": status})


# @.....
def Set_delivery(req, id=None, user_id=None):
    if req.method == "GET" and id and user_id:
        try:
            order = Orders.objects.get(id=id)
            order.delivery_person = user_id
            order.save()
        except Exception as e:
            raise e
        return JsonResponse({"delivery_person": user_id})
