#region conversion-functions
function Convert-RuleName {
	param(
		$inputer = $null
		 )
	(($inputer -split ':')[1]).trimstart('')
	
}


function Convert-Enabled {
	param(
		$inputer = $null
	)
	$splitInputer = (($inputer -split ':')[1]).trimstart('')
	if($splitInputer -eq 'Yes'){
		[bool]$enabled = $true
	} else {
		[bool]$enabled = $false
	}
	$enabled
	
}


function Convert-Direction {
	param(
			$inputer = $null
		)
	$splitInputer = (($inputer -split ':')[1]).trimstart('')
	if($splitInputer -eq 'in'){
		$direction = 'In'
	} else {
		$direction = 'Out'
	}
	$direction
}


function Convert-Profiles {
	param(
			$inputer = $null
		)
	$splitInputer = (($inputer -split ':')[1]).trimstart('')
	$splitInputer -split ','
}


function Convert-LocalIP {
	param(
			$inputer = $null
		)
	(($inputer -split ':')[1]).trimstart('')

}

function Convert-Protocol {
	param(
			$inputer = $null
		)
	(($inputer -split ':')[1]).trimstart('')

}

function Convert-Action {
	param(
			$inputer = $null
		)
	(($inputer -split ':')[1]).trimstart('')

}
#endregion


function Convert-NetshFirewallRules {
	
	$firewallRules = netsh.exe advfirewall firewall show rule name=all
	$firewallRules | ForEach-Object { 
		switch -Regex ($_) {
			'^Rule Name:' {$ruleName = Convert-RuleName $_}
			'^Enabled'    {$enabled = Convert-Enabled $_}
			'^Direction'  {$direction = Convert-Direction $_}
			'^Profiles'   {$profiles = Convert-Profiles $_}
			'^LocalIp'    {$localIp = Convert-LocalIP $_}
			'^Protocol'   {$protocol = Convert-Protocol $_}
			'^Action'     {$action = Convert-Action $_
						     $props = [ordered]@{
									Name = $ruleName
									Enabled = $enabled
									Direction = $direction
									Profiles = $profiles
									LocalIP = $localIp
									Protocol = $protocol
									Action = $action
								   }
						     New-Object -TypeName psobject -Property $props
					      }
		} 
	} 
}