$url = "http://localhost/internal/cluster/inactive"

Invoke-RestMethod -Method PUT -Uri $url | Out-Null;