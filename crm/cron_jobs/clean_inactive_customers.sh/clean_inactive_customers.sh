#!/bin/bash

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Run Django cleanup command
DELETED_COUNT=$(python3 manage.py shell << EOF
from datetime import timedelta
from django.utils import timezone
from crm.models import Customer

cutoff_date = timezone.now() - timedelta(days=365)
qs = Customer.objects.filter(orders__isnull=True, created_at__lt=cutoff_date)
count = qs.count()
qs.delete()
print(count)
EOF
)

# Log result
echo "$TIMESTAMP - Deleted $DELETED_COUNT inactive customers" >> /tmp/customer_cleanup_log.txt