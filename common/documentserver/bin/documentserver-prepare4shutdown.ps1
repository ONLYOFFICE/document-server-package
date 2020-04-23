$url = "http://localhost:8000/internal/cluster/inactive"

Invoke-RestMethod -Method PUT -Uri $url | Out-Null;