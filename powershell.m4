param([string]$FlushUrl)

$hosts = @()
HOSTLIST

if ($FlushUrl.length -eq 0) {
	echo "usage: dispatcherflush.ps1 -FlushUrl <content-url>"
}
else {
	foreach ($hostname in $hosts) {
		$request = [System.Net.WebRequest]::Create("http://" + $hostname + "/dispatcher/invalidate.cache")
		$request.Method = "POST"
	
		$request.Headers.Add("CQ-Action","Activate")
		$request.Headers.Add("CQ-Handle",$FlushUrl)
	
		$response = $request.GetResponse()
		
		$result = @{}
		$result.Host = $hostname
		$result.Result = [int]$response.StatusCode
		$object = New-Object -TypeName PSObject -Prop $result
		$object
		
		$request = $null
		$response = $null
		$result = $null
		$object = $null
	}
}
